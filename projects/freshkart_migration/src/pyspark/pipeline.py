"""
Pipeline de traitement FreshKart - Version PYSPARK (migré)

Ce module contient le code de traitement des données FreshKart
migré vers PySpark pour améliorer les performances.
"""

import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, countDistinct, explode, to_date


class FreshKartPySparkPipeline:
    """Pipeline de traitement des données FreshKart avec PySpark"""

    def __init__(self, data_path: str, spark: SparkSession = None):
        """
        Initialise le pipeline

        Args:
            data_path: Chemin vers le dossier contenant les données
            spark: Session Spark (créée automatiquement si None)
        """
        self.data_path = data_path

        if spark is None:
            self.spark = (
                SparkSession.builder.appName("FreshKart-Pipeline")
                .config("spark.driver.memory", "4g")
                .getOrCreate()
            )
        else:
            self.spark = spark

        self.customers_df = None
        self.orders_df = None
        self.refunds_df = None

    def load_data(self):
        """
        Charge toutes les données FreshKart

        Returns:
            Tuple (customers_df, orders_df, refunds_df)
        """
        print("📥 Chargement des données PySpark...")

        # Charger les clients
        customers_path = os.path.join(self.data_path, "customers.csv")
        self.customers_df = (
            self.spark.read.option("header", "true")
            .option("inferSchema", "true")
            .csv(customers_path)
        )
        print(f"  ✅ Clients: {self.customers_df.count():,} lignes")

        # Charger tous les fichiers JSON de commandes (pattern matching)
        orders_pattern = os.path.join(self.data_path, "orders_*.json")
        self.orders_df = self.spark.read.option("multiline", "true").json(orders_pattern)
        print(f"  ✅ Commandes: {self.orders_df.count():,} lignes")

        # Charger les remboursements
        refunds_path = os.path.join(self.data_path, "refunds.csv")
        self.refunds_df = (
            self.spark.read.option("header", "true").option("inferSchema", "true").csv(refunds_path)
        )
        print(f"  ✅ Remboursements: {self.refunds_df.count():,} lignes")

        return self.customers_df, self.orders_df, self.refunds_df

    def filter_paid_orders(self):
        """
        Filtre uniquement les commandes payées

        Returns:
            DataFrame des commandes payées
        """
        paid_orders = self.orders_df.filter(col("payment_status") == "paid")

        count = paid_orders.count()
        total = self.orders_df.count()
        print(f"💳 Commandes payées: {count:,} / {total:,}")

        return paid_orders

    def explode_items(self, orders_df):
        """
        Explose la colonne 'items' pour avoir une ligne par article

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame avec items explosés
        """
        # Exploser les items et extraire les champs
        exploded = orders_df.select(
            "order_id",
            "customer_id",
            "order_date",
            "channel",
            "payment_status",
            explode("items").alias("item"),
        ).select(
            "order_id",
            "customer_id",
            "order_date",
            "channel",
            col("item.product_id").alias("item_product_id"),
            col("item.qty").alias("item_qty"),
            col("item.unit_price").alias("item_unit_price"),
        )

        count = exploded.count()
        print(f"📦 Items explosés: {count:,} lignes")

        return exploded

    def calculate_revenue(self, orders_df):
        """
        Calcule le revenu par commande

        Args:
            orders_df: DataFrame avec items explosés

        Returns:
            DataFrame avec revenue calculé
        """
        # Calculer line revenue
        with_revenue = orders_df.withColumn(
            "line_revenue", col("item_qty") * col("item_unit_price")
        )

        # Agréger par commande
        revenue_df = with_revenue.groupBy("order_id", "customer_id", "order_date", "channel").agg(
            sum("item_qty").alias("total_items"), sum("line_revenue").alias("gross_revenue")
        )

        count = revenue_df.count()
        print(f"💰 Revenue calculé pour {count:,} commandes")

        return revenue_df

    def join_with_customers(self, orders_df):
        """
        Joint les commandes avec les données clients

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame jointé
        """
        result = orders_df.join(
            self.customers_df.select("customer_id", "city", "is_active"),
            on="customer_id",
            how="left",
        )

        count = result.count()
        print(f"👥 Jointure clients: {count:,} lignes")

        return result

    def add_refunds(self, orders_df):
        """
        Ajoute les informations de remboursement

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame avec refunds
        """
        # Agréger les remboursements par commande
        refunds_agg = self.refunds_df.groupBy("order_id").agg(sum("amount").alias("refund_amount"))

        # Joindre avec les commandes
        result = orders_df.join(refunds_agg, on="order_id", how="left")

        # Remplir les valeurs nulles et calculer net revenue
        result = result.fillna({"refund_amount": 0.0}).withColumn(
            "net_revenue", col("gross_revenue") + col("refund_amount")
        )

        count = result.count()
        print(f"🔄 Remboursements ajoutés: {count:,} lignes")

        return result

    def aggregate_daily_stats(self, orders_df):
        """
        Agrège les statistiques par jour, ville et canal

        Args:
            orders_df: DataFrame des commandes avec toutes les infos

        Returns:
            DataFrame agrégé
        """
        # Extraire la date
        with_date = orders_df.withColumn("date", to_date(col("order_date")))

        # Agréger
        stats = (
            with_date.groupBy("date", "city", "channel")
            .agg(
                countDistinct("order_id").alias("orders_count"),
                countDistinct("customer_id").alias("unique_customers"),
                sum("total_items").alias("items_sold"),
                sum("gross_revenue").alias("gross_revenue_eur"),
                sum("refund_amount").alias("refunds_eur"),
                sum("net_revenue").alias("net_revenue_eur"),
            )
            .orderBy("date", "city", "channel")
        )

        count = stats.count()
        print(f"📊 Stats agrégées: {count:,} lignes")

        return stats

    def run_full_pipeline(self):
        """
        Exécute le pipeline complet

        Returns:
            DataFrame des statistiques quotidiennes finales
        """
        print("\n🚀 Exécution du pipeline PySpark complet")
        print("=" * 60)

        # 1. Chargement
        self.load_data()

        # 2. Filtrer commandes payées
        paid_orders = self.filter_paid_orders()

        # 3. Exploser les items
        orders_exploded = self.explode_items(paid_orders)

        # 4. Calculer revenue
        orders_revenue = self.calculate_revenue(orders_exploded)

        # 5. Joindre avec customers
        orders_with_customers = self.join_with_customers(orders_revenue)

        # 6. Ajouter refunds
        orders_with_refunds = self.add_refunds(orders_with_customers)

        # 7. Agréger stats quotidiennes
        daily_stats = self.aggregate_daily_stats(orders_with_refunds)

        print("\n✅ Pipeline PySpark terminé !")
        print(f"📈 Résultat final: {daily_stats.count():,} lignes")

        return daily_stats

    def stop(self):
        """Arrête la session Spark"""
        if self.spark:
            self.spark.stop()
            print("🛑 Session Spark arrêtée")


def main():
    """Fonction principale pour tester le pipeline"""
    # Chemin des données
    data_path = "/workspace/Brief_Starter_Pack/data/march-input"

    # Créer et exécuter le pipeline
    pipeline = FreshKartPySparkPipeline(data_path)
    result = pipeline.run_full_pipeline()

    # Afficher un aperçu
    print("\n📋 Aperçu du résultat:")
    result.show(10, truncate=False)

    # Arrêter Spark
    pipeline.stop()

    return result


if __name__ == "__main__":
    main()
