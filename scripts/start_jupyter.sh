#!/bin/bash

# Activer le venv
source venv/bin/activate

# Lancer Jupyter Lab
jupyter lab --notebook-dir=notebooks --no-browser --port=8888
