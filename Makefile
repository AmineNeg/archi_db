# ============================================================================
# CABINET D'ARCHITECTURE — Makefile
# ============================================================================

.PHONY: help init seed query test docker up down logs clean backup export dashboard

PSQL = psql -h localhost -p 5432 -U archi -d archi_db

help: ## Afficher l'aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- Docker ---

docker: up ## Alias pour 'up'

up: ## Demarrer PostgreSQL + pgAdmin
	docker-compose up -d
	@echo "\033[32mPostgreSQL: localhost:5432 | pgAdmin: http://localhost:8080\033[0m"

down: ## Arreter les conteneurs
	docker-compose down

logs: ## Voir les logs PostgreSQL
	docker-compose logs -f postgres

# --- Base de donnees ---

init: ## Initialiser la base (schema + index + vues + fonctions + triggers + seed)
	@bash scripts/init_db.sh

seed: ## Recharger les donnees seed uniquement
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/01_schema.sql -q
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/02_indexes.sql -q
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/03_views.sql -q
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/04_functions.sql -q
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/05_triggers.sql -q
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/06_seed_data.sql -q
	@echo "\033[32mDonnees rechargees.\033[0m"

query: ## Executer les requetes analytiques
	@PGPASSWORD=archi_secret_2024 $(PSQL) -f sql/07_analytics_queries.sql

# --- Application Python ---

dashboard: ## Lancer le dashboard terminal
	python -m src.cli dashboard

export: ## Exporter les donnees en CSV
	python -m src.cli export csv

# --- Tests ---

test: ## Lancer les tests pytest
	pytest tests/ -v

# --- Utilitaires ---

backup: ## Sauvegarder la base
	@bash scripts/backup.sh

clean: ## Supprimer les conteneurs et volumes
	docker-compose down -v
	@echo "\033[33mConteneurs et volumes supprimes.\033[0m"

psql: ## Ouvrir un shell psql
	@PGPASSWORD=archi_secret_2024 $(PSQL)
