"""Configuration pytest pour les tests de migration"""

import pytest
import sys
import os

# Ajouter le path des sources pour les imports
project_root = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(project_root, 'src'))


def pytest_configure(config):
    """Configuration pytest personnalisée"""
    config.addinivalue_line(
        "markers", "slow: marque les tests lents à exécuter"
    )
    config.addinivalue_line(
        "markers", "benchmark: tests de performance"
    )


@pytest.fixture(scope="session", autouse=True)
def setup_test_environment():
    """Setup global pour les tests"""
    print("\n🧪 Initialisation de l'environnement de tests...")
    yield
    print("\n✅ Tests terminés!")
