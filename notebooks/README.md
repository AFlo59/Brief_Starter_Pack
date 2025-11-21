# 📚 Notebooks FreshKart - Migration Pandas → PySpark

## 🎯 Vue d'ensemble

Cette collection de notebooks vous guide dans la migration complète du pipeline e-commerce FreshKart de Pandas vers PySpark.

## 📂 Structure des notebooks

### 1. `01_introduction_pyspark.ipynb`
**🎯 Découverte et premiers pas**
- Introduction aux concepts PySpark
- Comparaison directe Pandas vs PySpark
- Exploration des données FreshKart réelles
- ⏱️ **Durée : 30-45 minutes**

### 2. `02_pyspark_avance.ipynb`
**🚀 Techniques avancées**
- Optimisations (cache, broadcast, partitioning)
- Fonctions avancées PySpark
- Gestion des erreurs et debugging
- ⏱️ **Durée : 45-60 minutes**

### 3. `03_exercice_freshkart_pyspark.ipynb` ⭐
**💼 Exercice principal complet**
- Pipeline FreshKart complet en PySpark
- Reproduction du pipeline `partie2.ipynb`
- Objectif : < 15 secondes vs 45s Pandas
- Toutes les optimisations appliquées
- ⏱️ **Durée : 1-2 heures**

### 4. `04_migration_comparison_pandas_pyspark.ipynb`
**🥊 Comparaison round par round**
- Exécution côte à côte Pandas vs PySpark
- Mesure de performance étape par étape
- Validation des résultats identiques
- Analyse des gains de performance
- ⏱️ **Durée : 1 heure**

## 🚀 Comment démarrer

### 1. **Lancement Jupyter**
```bash
# Depuis PowerShell Windows
wsl
./launch_jupyter.sh
```

### 2. **Ordre recommandé**
1. `01_introduction_pyspark.ipynb` - Pour comprendre les bases
2. `03_exercice_freshkart_pyspark.ipynb` - **Exercice principal**
3. `04_migration_comparison_pandas_pyspark.ipynb` - Pour analyser les gains
4. `02_pyspark_avance.ipynb` - Pour aller plus loin

### 3. **Prérequis vérifiés**
- ✅ WSL Ubuntu configuré
- ✅ Environnement `pyspark-migration` activé
- ✅ Données FreshKart disponibles
- ✅ Jupyter Lab avec kernel Python configuré

## 📊 Données utilisées

### Données FreshKart réelles
```
../Starter stack pour Data Engineers - Partie 1/data/
├── customers.csv                    # 802 clients
├── march-input/
│   ├── orders_2025-03-01.json     # 31 fichiers JSON
│   ├── orders_2025-03-02.json
│   └── ...
└── refunds.csv                     # 1,124 remboursements
```

### Pipeline original Pandas
- **Fichier :** `../Starter stack pour Data Engineers - Partie 1/partie2.ipynb`
- **Performance :** ~45 secondes
- **Approche :** Séquentielle, boucles manuelles

## 🎯 Objectifs d'apprentissage

### Compétences techniques
- ✅ **Chargement optimisé** : Pattern matching vs boucles
- ✅ **Explosion JSON native** : `explode()` vs boucles manuelles
- ✅ **Jointures distribuées** : `broadcast()` et optimisations
- ✅ **Cache intelligent** : `.cache()` sur DataFrames réutilisés
- ✅ **Agrégations distribuées** : `groupBy()` vs `groupby()`

### Gains de performance visés
- 🚀 **3x plus rapide minimum** (45s → <15s)
- 🧠 **Mémoire optimisée** (lazy evaluation)
- 📈 **Scalabilité** (prêt pour 10x plus de données)

## 💡 Conseils d'utilisation

### ⚡ Performance optimale
1. **Exécutez cellule par cellule** pour comprendre chaque étape
2. **Surveillez Spark UI** : `http://localhost:4040`
3. **Vérifiez les caches** : Indicateurs dans les cellules
4. **Mesurez les temps** : Chronomètres intégrés

### 🔧 Debugging
```python
# Vérifier les plans d'exécution
df.explain(mode=\"simple\")

# Surveiller le cache
df.is_cached

# Analyser les partitions
df.rdd.getNumPartitions()
```

### 📈 Monitoring
- **Spark UI** : Stages, tasks, cache utilization
- **Memory usage** : Storage tab
- **Query plans** : SQL tab

## 🏆 Résultats attendus

### Performance mesurée
- **Chargement** : ~5s vs 15s Pandas
- **Explosion JSON** : ~2s vs 20s Pandas
- **Agrégations** : ~3s vs 8s Pandas
- **TOTAL** : ~12s vs 45s Pandas = **3.7x plus rapide**

### Validation
- ✅ **Résultats identiques** : Ligne par ligne
- ✅ **Montants corrects** : Validation automatique
- ✅ **Structure préservée** : Format CSV identique

## 🚀 Prochaines étapes

Après avoir maîtrisé ces notebooks :

### Niveau avancé
1. **Streaming temps réel** : Kafka + Spark Streaming
2. **Machine Learning** : MLlib pour segmentation clients
3. **Pipeline production** : Airflow + Docker
4. **Monitoring avancé** : Grafana + métriques custom

### Optimisations supplémentaires
- Schema explicite pour JSON
- Partitioning par date
- Bucketing pour jointures
- Columnar format (Parquet)

---

**🎉 Bon apprentissage !** Ces notebooks vous donnent une maîtrise complète de la migration Pandas → PySpark avec un cas d'usage réel.

**📞 Support :** Consultez la documentation dans `../Migration_Pandas_PySpark_Guide/` pour plus de détails.
