# 📁 Organisation des Scripts - Brief Starter Pack

## 🎯 Structure Organisée

Tous les scripts sont maintenant dans le dossier `scripts/` avec des wrappers PowerShell à la racine pour Windows.

### 📂 scripts/ (Scripts principaux)

| Script | Usage | Description |
|--------|-------|-------------|
| **docker-build.sh** | `bash scripts/docker-build.sh` | Build l'image Docker |
| **docker-start.sh** | `bash scripts/docker-start.sh` | Démarre les services |
| **docker-rebuild.sh** | `bash scripts/docker-rebuild.sh` | Rebuild complet (down + build + up) |
| **get-token.sh** | `bash scripts/get-token.sh` | Récupère le token Jupyter |
| **test-migration.sh** | `bash scripts/test-migration.sh` | Test complet environnement |
| **test-env.sh** | `bash scripts/test-env.sh` | Test environnement Python |

**Caractéristiques** :
- ✅ Tous les scripts utilisent `cd "$(dirname "$0")/.."` pour se positionner à la racine
- ✅ Chemins relatifs vers `docker-compose.yml` à la racine
- ✅ Messages colorés et informatifs
- ✅ Gestion d'erreurs améliorée

### 💻 Racine (Wrappers PowerShell pour Windows)

| Script | Usage | Description |
|--------|-------|-------------|
| **docker-build.ps1** | `.\docker-build.ps1` | Wrapper pour docker-build.sh |
| **docker-start.ps1** | `.\docker-start.ps1` | Wrapper pour docker-start.sh |
| **get-token.ps1** | `.\get-token.ps1` | Wrapper pour get-token.sh |
| **run-tests.ps1** | `.\run-tests.ps1 [--coverage]` | Lance les tests migration |

**Avantages** :
- ✅ Facilite l'utilisation sous Windows PowerShell
- ✅ Pas besoin de préfixer avec `bash`
- ✅ Gestion des codes de retour
- ✅ Messages colorés PowerShell

### 🛠️ Makefile (Commandes courantes)

```bash
make help           # Affiche l'aide
make build          # Build image (via scripts/docker-build.sh)
make start          # Démarre services (via scripts/docker-start.sh)
make stop           # Arrête services
make restart        # Redémarre services
make token          # Récupère token (via scripts/get-token.sh)
make rebuild        # Rebuild complet (via scripts/docker-rebuild.sh)
make test           # Lance tests unitaires
make test-cov       # Lance tests avec coverage
make pre-commit     # Lance pre-commit hooks
make clean          # Nettoie fichiers temporaires
make check-env      # Vérifie environnement (via scripts/test-migration.sh)
```

## 🚀 Utilisation Recommandée

### Windows PowerShell (Recommandé)

```powershell
# Build & Start
.\docker-build.ps1
.\docker-start.ps1

# Token
.\get-token.ps1

# Tests
.\run-tests.ps1
.\run-tests.ps1 --coverage
```

### Bash (WSL / Git Bash)

```bash
# Build & Start
bash scripts/docker-build.sh
bash scripts/docker-start.sh

# Token
bash scripts/get-token.sh

# Rebuild complet
bash scripts/docker-rebuild.sh
```

### Make (si installé)

```bash
make build
make start
make token
make test
```

## 📋 Emplacement des Fichiers

```
Brief_Starter_Pack/
├── 📁 scripts/                   # Scripts Bash principaux
│   ├── docker-build.sh          # Build image
│   ├── docker-start.sh          # Start services
│   ├── docker-rebuild.sh        # Rebuild complet
│   ├── get-token.sh             # Get token
│   ├── test-migration.sh        # Test migration
│   └── test-env.sh              # Test env Python
│
├── 💻 Racine (Wrappers + Config)
│   ├── docker-build.ps1         # Wrapper PowerShell
│   ├── docker-start.ps1         # Wrapper PowerShell
│   ├── get-token.ps1            # Wrapper PowerShell
│   ├── run-tests.ps1            # Tests migration
│   ├── Makefile                 # Make commands
│   ├── docker-compose.yml       # Config Docker
│   └── Dockerfile               # Image Docker
│
└── 📁 projects/freshkart_migration/
    └── compare_results.py       # Script comparaison Python
```

## ✅ Avantages de cette Organisation

1. **Clarté** : Tous les scripts bash dans `scripts/`, wrappers PS à la racine
2. **Portabilité** : Fonctionne sous Windows, Linux, macOS
3. **Flexibilité** : Utiliser bash, PowerShell ou make selon préférence
4. **Maintenabilité** : Scripts bash avec chemins relatifs corrects
5. **Cohérence** : `docker-compose.yml` à la racine, scripts le référencent correctement

## 🔧 Migration depuis Ancienne Structure

Si vous aviez des scripts à la racine :
- ✅ Déplacés dans `scripts/`
- ✅ Mis à jour avec `cd "$(dirname "$0")/.."`
- ✅ Wrappers PowerShell créés à la racine
- ✅ Makefile mis à jour pour utiliser `scripts/`

## 📝 Notes Techniques

### Scripts Bash
- Utilisent `#!/bin/bash` (shebang)
- Se positionnent à la racine avec `cd "$(dirname "$0")/.."`
- Référencent `docker-compose.yml` depuis racine
- Gestion d'erreurs avec `if [ $? -ne 0 ]; then ... fi`

### Scripts PowerShell
- Utilisent `#!/usr/bin/env pwsh` (shebang)
- Appellent les scripts bash via `& bash scripts/...`
- Vérifient `$LASTEXITCODE` pour les erreurs
- Messages colorés avec `-ForegroundColor`

### Makefile
- Utilise `bash scripts/...` pour tous les scripts
- Commandes `@` pour supprimer l'écho
- Cibles `.PHONY` pour éviter conflits avec fichiers

## 🆘 Troubleshooting

| Problème | Solution |
|----------|----------|
| Script bash introuvable | Vérifier que vous êtes à la racine du projet |
| Permission denied | `chmod +x scripts/*.sh` |
| PowerShell pas de bash | Installer Git Bash ou WSL |
| Make pas reconnu | Utiliser directement les scripts .ps1 ou .sh |

---

**Organisation finalisée le 21 novembre 2025**
