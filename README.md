# Cabinet d'Architecture — Base de Donnees

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql) ![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python) ![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-red) ![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker) ![License](https://img.shields.io/badge/License-MIT-green)

Systeme de gestion complet pour un cabinet d'architecture : projets, clients, plans, devis, suivi de chantier et facturation.

## Schema ERD (ASCII)

```
┌──────────────┐       ┌──────────────────┐       ┌──────────────┐
│  ARCHITECTES │       │     PROJETS      │       │   CLIENTS    │
├──────────────┤       ├──────────────────┤       ├──────────────┤
│ id (PK)      │──┐    │ id (PK)          │    ┌──│ id (PK)      │
│ nom          │  │    │ ref_projet (UK)  │    │  │ raison_soc.  │
│ prenom       │  │    │ nom_projet       │    │  │ type         │
│ specialite   │  └───>│ architecte_id FK │    │  │ email        │
│ taux_horaire │       │ client_id FK ────│────┘  │ ville        │
│ numero_ordre │       │ type_projet      │       │ siret        │
└──────┬───────┘       │ statut           │       └──────┬───────┘
       │               │ budget_ht        │              │
       │               │ honoraires_ht    │              │
       │               └────────┬─────────┘              │
       │                        │                        │
       │          ┌─────────────┼─────────────┐          │
       │          │             │             │          │
       │          v             v             v          │
       │   ┌────────────┐ ┌──────────┐ ┌───────────┐    │
       │   │PHASES_PROJ.│ │ DOCUMENTS│ │  REUNIONS  │    │
       │   ├────────────┤ ├──────────┤ │  CHANTIER  │    │
       │   │ phase      │ │ type_doc │ ├───────────┤    │
       │   │ statut     │ │ fichier  │ │ date      │    │
       │   │ avancement │ │ version  │ │ CR        │    │
       │   └────────────┘ └──────────┘ └───────────┘    │
       │          │                                      │
       │          v             v             v          │
       │   ┌────────────┐ ┌──────────┐ ┌───────────┐    │
       │   │SUIVI_HEURES│ │  DEVIS   │ │  LOTS     │    │
       │   ├────────────┤ ├──────────┤ │ENTREPRISES│    │
       ├──>│ arch_id FK │ │ ref_devis│ ├───────────┤    │
       │   │ nb_heures  │ │ montant  │◄│ lot       │    │
       │   │ date       │ │ statut   │ │ entreprise│    │
       │   └────────────┘ └────┬─────┘ │ montant   │    │
       │                       │       └───────────┘    │
       │                       v                        │
       │                ┌──────────┐                    │
       │                │ FACTURES │                    │
       │                ├──────────┤                    │
       │                │ ref_fact │                    │
       │                │ montant  │                    │
       │                │ statut   │                    │
       │                └──────────┘                    │
       │                                                │
       │   ┌──────────────────────────────────────┐     │
       │   │            AUDIT_LOG                  │     │
       │   ├──────────────────────────────────────┤     │
       │   │ table_name | record_id | action      │     │
       │   │ old_values (JSONB) | new_values      │     │
       │   └──────────────────────────────────────┘     │
```

> Diagramme Mermaid complet : [`docs/erd.md`](docs/erd.md)

## Demarrage rapide

### 1. Lancer la stack Docker

```bash
cp .env.example .env
docker-compose up -d
```

- **PostgreSQL** : `localhost:5432` (user: `archi` / pass: `archi_secret_2024`)
- **pgAdmin** : [http://localhost:8080](http://localhost:8080) (admin@cabinet-archi.fr / admin)

### 2. Initialiser la base de donnees

```bash
make init
```

### 3. Explorer les donnees

```bash
# Requetes analytiques
make query

# Dashboard terminal
pip install -e ".[dev]"
make dashboard

# Shell psql
make psql
```

## Commandes Make

| Commande | Description |
|----------|-------------|
| `make up` | Demarrer PostgreSQL + pgAdmin |
| `make down` | Arreter les conteneurs |
| `make init` | Initialiser la base complete |
| `make seed` | Recharger les donnees |
| `make query` | Lancer les requetes analytiques |
| `make dashboard` | Dashboard terminal Rich |
| `make export` | Exporter en CSV |
| `make test` | Lancer les tests |
| `make backup` | Backup de la base |
| `make clean` | Supprimer conteneurs + volumes |
| `make psql` | Ouvrir un shell psql |

## Structure du projet

```
archi-db/
├── README.md
├── Makefile
├── docker-compose.yml
├── .env.example
├── pyproject.toml
├── sql/
│   ├── 01_schema.sql          # 11 tables + contraintes
│   ├── 02_indexes.sql         # 40+ index de performance
│   ├── 03_views.sql           # 6 vues metier
│   ├── 04_functions.sql       # 6 fonctions PL/pgSQL
│   ├── 05_triggers.sql        # Audit, timestamps, alertes
│   ├── 06_seed_data.sql       # Donnees realistes
│   └── 07_analytics_queries.sql # 15 requetes analytiques
├── src/
│   ├── db.py                  # Connexion SQLAlchemy
│   ├── models.py              # ORM complet
│   ├── cli.py                 # CLI Rich
│   ├── dashboard.py           # Dashboard terminal
│   └── export.py              # Export CSV
├── tests/
│   ├── test_schema.py
│   ├── test_queries.py
│   └── test_functions.py
├── docs/
│   ├── erd.md                 # Diagramme Mermaid
│   ├── data_dictionary.md     # Dictionnaire de donnees
│   └── business_rules.md      # Regles metier
└── scripts/
    ├── init_db.sh
    └── backup.sh
```

## Donnees incluses

- **18 clients** : promoteurs (Bouygues, Nexity, Altarea), collectivites (Mairies), particuliers, SCI
- **22 projets** : logements, renovation, equipements publics, urbanisme
- **5 architectes** avec specialites
- **80+ phases** avec avancements coherents
- **25 devis** et **30 factures** avec montants realistes
- **12 reunions de chantier** avec vrais CR
- **35 lots d'entreprises**
- **120+ saisies d'heures** sur 6 mois
- **17 documents** references

## Documentation

- [Diagramme ERD](docs/erd.md)
- [Dictionnaire de donnees](docs/data_dictionary.md)
- [Regles metier](docs/business_rules.md)
