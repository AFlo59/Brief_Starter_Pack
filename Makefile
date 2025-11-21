.PHONY: help build start stop restart logs test test-cov clean token shell

help: ## Affiche cette aide
	@echo "Commandes disponibles pour FreshKart Migration:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build l'image Docker
	bash scripts/docker-build.sh

start: ## Démarre les services Docker
	bash scripts/docker-start.sh
	@echo ""
	@echo "✅ Services démarrés!"
	@echo "📝 Jupyter Lab: http://localhost:8888"
	@echo "📝 VS Code: http://localhost:8080"
	@echo ""
	@echo "🔑 Token Jupyter:"
	@bash scripts/get-token.sh

stop: ## Arrête les services Docker
	docker-compose down

restart: ## Redémarre les services
	docker-compose restart

logs: ## Affiche les logs
	docker-compose logs -f

token: ## Récupère le token Jupyter
	@bash scripts/get-token.sh

shell: ## Ouvre un shell dans le container
	docker exec -it brief_starter_pack /bin/bash

test: ## Lance les tests unitaires
	docker exec -it brief_starter_pack bash -c "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pytest tests/ -v"

test-cov: ## Lance les tests avec coverage
	docker exec -it brief_starter_pack bash -c "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pytest tests/ --cov=src --cov-report=html --cov-report=term"

pre-commit: ## Lance les pre-commit hooks
	docker exec -it brief_starter_pack bash -c "cd /workspace/Brief_Starter_Pack/projects/freshkart_migration && pre-commit run --all-files"

clean: ## Nettoie les fichiers temporaires
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name "htmlcov" -exec rm -rf {} +
	find . -type f -name ".coverage" -delete
	find . -type f -name "*.pyc" -delete

rebuild: ## Rebuild complet (down + build + up)
	bash scripts/docker-rebuild.sh

check-env: ## Vérifie l'environnement
	docker exec -it brief_starter_pack bash /workspace/Brief_Starter_Pack/scripts/test-migration.sh
