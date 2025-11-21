"""
Pipeline de données FreshKart - Version PySpark

Ce module contient la migration du pipeline vers PySpark
pour le traitement distribué des données.
"""

from .pipeline import FreshKartPySparkPipeline

__all__ = ["FreshKartPySparkPipeline"]
__version__ = "1.0.0"
