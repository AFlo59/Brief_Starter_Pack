"""
Pipeline de traitement FreshKart - Version PANDAS (original)

Ce module contient le code de traitement des données FreshKart
en utilisant Pandas. Sert de référence pour la migration PySpark.
"""

import glob
import os
from typing import Tuple

import pandas as pd


class FreshKartPandasPipeline:
    """Pipeline de traitement des données FreshKart avec Pandas"""

    def __init__(self, data_path: str):
        """
        Initialise le pipeline

        Args:
            data_path: Chemin vers le dossier contenant les données
        """
        self.data_path = data_path
        self.customers_df = None
        self.orders_df = None
        self.refunds_df = None

    def load_data(self) -> Tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
        """
        Charge toutes les données FreshKart

        Returns:
            Tuple (customers_df, orders_df, refunds_df)
        """
        print("📥 Chargement des données Pandas...")

        # Charger les clients
        customers_path = os.path.join(self.data_path, "customers.csv")
        self.customers_df = pd.read_csv(customers_path)
        print(f"  ✅ Clients: {len(self.customers_df):,} lignes")

        # Charger tous les fichiers JSON de commandes
        json_pattern = os.path.join(self.data_path, "orders_*.json")
        json_files = glob.glob(json_pattern)

        orders_list = []
        for file_path in json_files:
            df_temp = pd.read_json(file_path)
            orders_list.append(df_temp)

        self.orders_df = pd.concat(orders_list, ignore_index=True)
        print(f"  ✅ Commandes: {len(self.orders_df):,} lignes ({len(json_files)} fichiers)")

        # Charger les remboursements
        refunds_path = os.path.join(self.data_path, "refunds.csv")
        self.refunds_df = pd.read_csv(refunds_path)
        print(f"  ✅ Remboursements: {len(self.refunds_df):,} lignes")

        return self.customers_df, self.orders_df, self.refunds_df

    def filter_paid_orders(self) -> pd.DataFrame:
        """
        Filtre uniquement les commandes payées

        Returns:
            DataFrame des commandes payées
        """
        paid_orders = self.orders_df[self.orders_df["payment_status"] == "paid"].copy()

        print(f"💳 Commandes payées: {len(paid_orders):,} / {len(self.orders_df):,}")
        return paid_orders

    def explode_items(self, orders_df: pd.DataFrame) -> pd.DataFrame:
        """
        Explose la colonne 'items' pour avoir une ligne par article

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame avec items explosés
        """
        # Exploser la colonne items
        exploded = orders_df.explode("items", ignore_index=True)

        # Extraire les champs de chaque item
        items_df = pd.json_normalize(exploded["items"])

        # Combiner avec les autres colonnes
        result = pd.concat(
            [exploded.drop(columns=["items"]).reset_index(drop=True), items_df.add_prefix("item_")],
            axis=1,
        )

        print(f"📦 Items explosés: {len(result):,} lignes")
        return result

    def calculate_revenue(self, orders_df: pd.DataFrame) -> pd.DataFrame:
        """
        Calcule le revenu par commande

        Args:
            orders_df: DataFrame avec items explosés

        Returns:
            DataFrame avec revenue calculé
        """
        orders_df["line_revenue"] = orders_df["item_qty"] * orders_df["item_unit_price"]

        # Agréger par commande
        revenue_df = (
            orders_df.groupby(["order_id", "customer_id", "order_date", "channel"])
            .agg({"item_qty": "sum", "line_revenue": "sum"})
            .rename(columns={"item_qty": "total_items", "line_revenue": "gross_revenue"})
            .reset_index()
        )

        print(f"💰 Revenue calculé pour {len(revenue_df):,} commandes")
        return revenue_df

    def join_with_customers(self, orders_df: pd.DataFrame) -> pd.DataFrame:
        """
        Joint les commandes avec les données clients

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame jointé
        """
        result = orders_df.merge(
            self.customers_df[["customer_id", "city", "is_active"]], on="customer_id", how="left"
        )

        print(f"👥 Jointure clients: {len(result):,} lignes")
        return result

    def add_refunds(self, orders_df: pd.DataFrame) -> pd.DataFrame:
        """
        Ajoute les informations de remboursement

        Args:
            orders_df: DataFrame des commandes

        Returns:
            DataFrame avec refunds
        """
        # Agréger les remboursements par commande
        refunds_agg = self.refunds_df.groupby("order_id")["amount"].sum().reset_index()
        refunds_agg.columns = ["order_id", "refund_amount"]

        # Joindre avec les commandes
        result = orders_df.merge(refunds_agg, on="order_id", how="left")
        result["refund_amount"] = result["refund_amount"].fillna(0)

        # Calculer le revenu net
        result["net_revenue"] = result["gross_revenue"] + result["refund_amount"]

        print(f"🔄 Remboursements ajoutés: {len(result):,} lignes")
        return result

    def aggregate_daily_stats(self, orders_df: pd.DataFrame) -> pd.DataFrame:
        """
        Agrège les statistiques par jour, ville et canal

        Args:
            orders_df: DataFrame des commandes avec toutes les infos

        Returns:
            DataFrame agrégé
        """
        # Extraire la date depuis order_date
        orders_df["date"] = pd.to_datetime(orders_df["order_date"]).dt.date

        # Agréger
        stats = (
            orders_df.groupby(["date", "city", "channel"])
            .agg(
                {
                    "order_id": "nunique",
                    "customer_id": "nunique",
                    "total_items": "sum",
                    "gross_revenue": "sum",
                    "refund_amount": "sum",
                    "net_revenue": "sum",
                }
            )
            .rename(
                columns={
                    "order_id": "orders_count",
                    "customer_id": "unique_customers",
                    "total_items": "items_sold",
                    "gross_revenue": "gross_revenue_eur",
                    "refund_amount": "refunds_eur",
                    "net_revenue": "net_revenue_eur",
                }
            )
            .reset_index()
        )

        print(f"📊 Stats agrégées: {len(stats):,} lignes")
        return stats

    def run_full_pipeline(self) -> pd.DataFrame:
        """
        Exécute le pipeline complet

        Returns:
            DataFrame des statistiques quotidiennes finales
        """
        print("\n🚀 Exécution du pipeline Pandas complet")
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

        print("\n✅ Pipeline Pandas terminé !")
        print(f"📈 Résultat final: {len(daily_stats):,} lignes")

        return daily_stats


def main():
    """Fonction principale pour tester le pipeline"""
    # Chemin des données
    data_path = "/workspace/Brief_Starter_Pack/data/march-input"

    # Créer et exécuter le pipeline
    pipeline = FreshKartPandasPipeline(data_path)
    result = pipeline.run_full_pipeline()

    # Afficher un aperçu
    print("\n📋 Aperçu du résultat:")
    print(result.head(10))

    return result


if __name__ == "__main__":
    main()
