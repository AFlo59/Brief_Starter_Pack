FROM ubuntu:22.04

# Éviter les prompts interactifs
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Installer Python 3, Java (requis pour PySpark), et utilitaires
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    openjdk-11-jre-headless \
    curl \
    wget \
    git \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Installer code-server (VS Code dans le navigateur)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Créer un utilisateur non-root
RUN useradd -m -s /bin/bash sparkuser && \
    echo "sparkuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /workspace /workspace/data/output /workspace/projects && \
    chown -R sparkuser:sparkuser /workspace

# Passer à l'utilisateur non-root
USER sparkuser
WORKDIR /workspace

# Installer extensions VS Code pour Python/Jupyter
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter

# Créer et activer le venv
RUN python3 -m venv /workspace/venv

# Installer les dépendances Python dans le venv
COPY --chown=sparkuser:sparkuser requirements.txt .
RUN /workspace/venv/bin/pip install --upgrade pip && \
    /workspace/venv/bin/pip install -r requirements.txt

# Exposer les ports Jupyter et VS Code
EXPOSE 8888 8080

# Variables d'environnement pour PySpark
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=/workspace/venv/bin:$PATH

# Créer script de démarrage pour lancer Jupyter + code-server
RUN echo '#!/bin/bash\n\
code-server --bind-addr 0.0.0.0:8080 --auth none /workspace &\n\
/workspace/venv/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --notebook-dir=/workspace\n\
' > /workspace/start.sh && chmod +x /workspace/start.sh

# Commande par défaut : Lancer les deux services
CMD ["/bin/bash", "/workspace/start.sh"]
