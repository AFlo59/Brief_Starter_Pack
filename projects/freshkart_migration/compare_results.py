"""
Script de comparaison visuelle Pandas vs PySpark

Ce script exécute les deux pipelines et compare les résultats
de manière détaillée avec affichage formaté.
"""

import os
import sys
from datetime import datetime

from pyspark.sql import SparkSession

# Ajouter le path des sources
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "src"))

from pandas_freshkart.pipeline import FreshKartPandasPipeline  # noqa: E402
from pyspark_freshkart.pipeline import FreshKartPySparkPipeline  # noqa: E402


def print_section(title):
    """Affiche une section formatée"""
    print("\n" + "=" * 80)
    print(f"  {title}")
    print("=" * 80)


def compare_pipelines(data_path):
    """Compare les résultats des deux pipelines"""

    print_section("🚀 COMPARAISON PANDAS vs PYSPARK")

    # 1. Créer les pipelines
    print("\n📦 Initialisation des pipelines...")
    pandas_pipeline = FreshKartPandasPipeline(data_path)

    spark = (
        SparkSession.builder.appName("ComparaisonPipelines")
        .master("local[*]")
        .config("spark.driver.memory", "2g")
        .getOrCreate()
    )
    pyspark_pipeline = FreshKartPySparkPipeline(data_path, spark)

    # 2. Charger les données
    print_section("📊 CHARGEMENT DES DONNÉES")

    print("⏳ Chargement Pandas...")
    start = datetime.now()
    customers_pd, orders_pd, refunds_pd = pandas_pipeline.load_data()
    time_pandas_load = (datetime.now() - start).total_seconds()

    print("⏳ Chargement PySpark...")
    start = datetime.now()
    customers_spark, orders_spark, refunds_spark = pyspark_pipeline.load_data()
    time_pyspark_load = (datetime.now() - start).total_seconds()

    print(f"\n{'Métrique':<30} {'Pandas':<15} {'PySpark':<15} {'Diff':<15}")
    print("-" * 75)
    nb_clients_diff = len(customers_pd) - customers_spark.count()
    nb_orders_diff = len(orders_pd) - orders_spark.count()
    nb_refunds_diff = len(refunds_pd) - refunds_spark.count()
    time_diff = time_pandas_load - time_pyspark_load

    print(
        f"{'Nb Clients':<30} {len(customers_pd):<15} "
        f"{customers_spark.count():<15} {nb_clients_diff:<15}"
    )
    print(
        f"{'Nb Commandes':<30} {len(orders_pd):<15} "
        f"{orders_spark.count():<15} {nb_orders_diff:<15}"
    )
    print(
        f"{'Nb Remboursements':<30} {len(refunds_pd):<15} "
        f"{refunds_spark.count():<15} {nb_refunds_diff:<15}"
    )
    print(
        f"{'Temps chargement (s)':<30} {time_pandas_load:<15.2f} "
        f"{time_pyspark_load:<15.2f} {time_diff:<15.2f}"
    )

    # 3. Pipeline complet
    print_section("🔄 EXÉCUTION PIPELINE COMPLET")

    print("⏳ Pipeline Pandas...")
    start = datetime.now()
    result_pd = pandas_pipeline.run_full_pipeline()
    time_pandas_full = (datetime.now() - start).total_seconds()

    print("⏳ Pipeline PySpark...")
    start = datetime.now()
    result_spark = pyspark_pipeline.run_full_pipeline()
    time_pyspark_full = (datetime.now() - start).total_seconds()

    print(f"\n{'Métrique':<30} {'Pandas':<15} {'PySpark':<15} {'Diff':<15}")
    print("-" * 75)
    rows_diff = len(result_pd) - result_spark.count()
    cols_diff = len(result_pd.columns) - len(result_spark.columns)
    exec_time_diff = time_pandas_full - time_pyspark_full

    print(
        f"{'Nb lignes finales':<30} {len(result_pd):<15} "
        f"{result_spark.count():<15} {rows_diff:<15}"
    )
    print(
        f"{'Nb colonnes':<30} {len(result_pd.columns):<15} "
        f"{len(result_spark.columns):<15} {cols_diff:<15}"
    )
    print(
        f"{'Temps exécution (s)':<30} {time_pandas_full:<15.2f} "
        f"{time_pyspark_full:<15.2f} {exec_time_diff:<15.2f}"
    )

    # 4. Analyse des revenus
    print_section("💰 ANALYSE DES REVENUS")

    total_revenue_pd = result_pd["net_revenue_eur"].sum()
    total_revenue_spark = result_spark.agg({"net_revenue_eur": "sum"}).collect()[0][0]

    mean_revenue_pd = result_pd["net_revenue_eur"].mean()
    mean_revenue_spark = result_spark.agg({"net_revenue_eur": "avg"}).collect()[0][0]

    print(f"\n{'Métrique':<30} {'Pandas':<20} {'PySpark':<20} {'Diff':<20}")
    print("-" * 90)
    revenue_diff = abs(total_revenue_pd - total_revenue_spark)
    mean_diff = abs(mean_revenue_pd - mean_revenue_spark)

    print(
        f"{'Revenu total (€)':<30} {total_revenue_pd:<20.2f} "
        f"{total_revenue_spark:<20.2f} {revenue_diff:<20.2f}"
    )
    print(
        f"{'Revenu moyen (€)':<30} {mean_revenue_pd:<20.2f} "
        f"{mean_revenue_spark:<20.2f} {mean_diff:<20.2f}"
    )

    # 5. Comparaison échantillon
    print_section("🔍 ÉCHANTILLON DES RÉSULTATS")

    print("\n📝 Pandas (5 premières lignes) :")
    print(result_pd.head().to_string())

    print("\n📝 PySpark (5 premières lignes) :")
    result_spark.show(5, truncate=False)

    # 6. Colonnes
    print_section("📋 COLONNES")

    cols_pd = set(result_pd.columns)
    cols_spark = set(result_spark.columns)

    print(f"\n✅ Colonnes communes : {len(cols_pd & cols_spark)}")
    cols_only_pd = cols_pd - cols_spark if cols_pd - cols_spark else "Aucune"
    cols_only_spark = cols_spark - cols_pd if cols_spark - cols_pd else "Aucune"
    print(f"⚠️  Colonnes uniquement Pandas : {cols_only_pd}")
    print(f"⚠️  Colonnes uniquement PySpark : {cols_only_spark}")

    # 7. Validation
    print_section("✅ VALIDATION")

    diff_rows = abs(len(result_pd) - result_spark.count())
    diff_revenue = abs(total_revenue_pd - total_revenue_spark)

    print("\n🧪 Tests de validation :")
    row_status = "✅ PASS" if diff_rows == 0 else f"❌ FAIL (diff: {diff_rows})"
    col_status = "✅ PASS" if cols_pd == cols_spark else "❌ FAIL"
    revenue_status = "✅ PASS" if diff_revenue < 1.0 else f"❌ FAIL (diff: {diff_revenue:.2f}€)"
    time_status = "⚡ PySpark" if time_pyspark_full < time_pandas_full else "🐢 Pandas"

    print(f"  {'Nb lignes identiques':<40} {row_status}")
    print(f"  {'Colonnes identiques':<40} {col_status}")
    print(f"  {'Revenu total proche (±1€)':<40} {revenue_status}")
    print(f"  {'Temps exécution':<40} {time_status} plus rapide")

    # 8. Performance globale
    print_section("⚡ PERFORMANCE GLOBALE")

    speedup = time_pandas_full / time_pyspark_full if time_pyspark_full > 0 else 0

    print("\n📊 Résumé :")
    print(f"  Temps total Pandas   : {time_pandas_load + time_pandas_full:.2f}s")
    print(f"  Temps total PySpark  : {time_pyspark_load + time_pyspark_full:.2f}s")
    print(f"  Speedup              : {speedup:.2f}x")

    if speedup > 1:
        print(f"\n🚀 PySpark est {speedup:.1f}x plus rapide que Pandas !")
    else:
        print(f"\n🐢 Pandas est {1/speedup:.1f}x plus rapide (dataset trop petit pour PySpark)")

    # Cleanup
    spark.stop()

    print("\n" + "=" * 80)
    print("  ✅ Comparaison terminée !")
    print("=" * 80 + "\n")


if __name__ == "__main__":
    # Chemin par défaut
    data_path = "/workspace/Brief_Starter_Pack/data/march-input"

    # Permettre de passer le chemin en argument
    if len(sys.argv) > 1:
        data_path = sys.argv[1]

    # Vérifier que le chemin existe
    if not os.path.exists(data_path):
        print(f"❌ ERREUR : Le chemin {data_path} n'existe pas!")
        print(f"Usage: python {sys.argv[0]} [chemin_data]")
        sys.exit(1)

    compare_pipelines(data_path)
