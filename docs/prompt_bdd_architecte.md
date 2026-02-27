# 🎬 PROMPT CLAUDE CODE — Base de Données Cabinet d'Architecture

> Copie-colle ce prompt dans Claude Code. Il construit tout en autonomie.

---

```
Construis-moi une base de données complète et production-ready pour un cabinet d'architecture. Le système doit gérer les projets, clients, plans, devis, suivi de chantier, et facturation.

Fais TOUT en une seule passe autonome, fichier par fichier.

## 1. Structure du projet
Crée l'arborescence complète :
```
archi-db/
├── README.md                          # Doc pro avec schéma ERD en ASCII + badges
├── Makefile                           # make init, make seed, make query, make test, make docker
├── docker-compose.yml                 # PostgreSQL 16 + pgAdmin
├── .env.example
├── sql/
│   ├── 01_schema.sql                  # Création de toutes les tables avec contraintes
│   ├── 02_indexes.sql                 # Index de performance
│   ├── 03_views.sql                   # Vues métier (projets en cours, CA par client, rentabilité)
│   ├── 04_functions.sql               # Fonctions PL/pgSQL (calcul honoraires, marges, alertes délais)
│   ├── 05_triggers.sql                # Triggers (audit log, mise à jour statuts auto, alertes budget)
│   ├── 06_seed_data.sql               # Données réalistes d'un vrai cabinet français (100+ lignes)
│   └── 07_analytics_queries.sql       # 15+ requêtes analytiques commentées prêtes à l'emploi
├── src/
│   ├── __init__.py
│   ├── db.py                          # Connexion SQLAlchemy + session manager
│   ├── models.py                      # ORM SQLAlchemy complet (miroir du schéma SQL)
│   ├── cli.py                         # CLI interactive avec Rich (dashboard, recherche, rapports)
│   ├── dashboard.py                   # Dashboard terminal avec stats temps réel
│   └── export.py                      # Export CSV / Excel / PDF des données
├── tests/
│   ├── test_schema.py                 # Vérifie intégrité des tables et contraintes
│   ├── test_queries.py                # Vérifie que les requêtes analytiques tournent
│   └── test_functions.py              # Vérifie les fonctions PL/pgSQL
├── docs/
│   ├── erd.md                         # Diagramme Mermaid du schéma ERD complet
│   ├── data_dictionary.md             # Dictionnaire de données détaillé
│   └── business_rules.md              # Règles métier documentées
├── scripts/
│   ├── init_db.sh                     # Script d'initialisation complète
│   └── backup.sh                      # Script de backup automatique
└── pyproject.toml
```

## 2. Modèle de données — Tables à créer

### Tables principales :
- **clients** : id, raison_sociale, type (particulier/promoteur/collectivité/entreprise), nom_contact, prenom_contact, email, telephone, adresse, ville, code_postal, siret, date_creation, notes
- **projets** : id, ref_projet (format: ARCH-2024-001), nom_projet, client_id (FK), type_projet (neuf/rénovation/extension/aménagement_intérieur/urbanisme), description, adresse_chantier, ville_chantier, surface_m2, nb_lots, budget_estime_ht, honoraires_ht, taux_honoraires_pct, statut (prospect/étude/permis_déposé/permis_accordé/chantier/réception/clos), date_debut, date_fin_prevue, date_fin_reelle, architecte_responsable_id (FK), created_at, updated_at
- **architectes** : id, nom, prenom, email, telephone, specialite, numero_ordre, date_inscription_ordre, taux_horaire, statut (actif/inactif)
- **phases_projet** : id, projet_id (FK), phase (ESQ/APS/APD/PRO/DCE/ACT/VISA/DET/AOR), statut (à_faire/en_cours/validé/annulé), date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement, commentaires
- **documents** : id, projet_id (FK), phase_id (FK), type_document (plan/coupe/perspective/notice/devis/facture/CR_chantier/photo), nom_fichier, version, chemin_fichier, uploaded_by (FK architectes), created_at
- **devis** : id, projet_id (FK), client_id (FK), ref_devis, montant_ht, taux_tva, montant_ttc, statut (brouillon/envoyé/accepté/refusé/expiré), date_emission, date_validite, conditions_paiement, notes
- **factures** : id, projet_id (FK), devis_id (FK), ref_facture, montant_ht, taux_tva, montant_ttc, statut (brouillon/envoyée/payée/en_retard/annulée), date_emission, date_echeance, date_paiement, mode_paiement
- **reunions_chantier** : id, projet_id (FK), date_reunion, lieu, participants, ordre_du_jour, compte_rendu, prochaine_reunion, actions_a_suivre
- **lots_entreprises** : id, projet_id (FK), lot (gros_oeuvre/charpente/couverture/menuiserie/plomberie/electricite/peinture/VRD/etc), entreprise_nom, entreprise_siret, montant_marche_ht, statut (consultation/attribué/en_cours/réceptionné), date_debut, date_fin
- **suivi_heures** : id, architecte_id (FK), projet_id (FK), date, nb_heures, description_tache, phase_id (FK)
- **audit_log** : id, table_name, record_id, action (INSERT/UPDATE/DELETE), old_values (JSONB), new_values (JSONB), user_info, created_at

## 3. Données seed réalistes
Génère des données cohérentes d'un vrai cabinet parisien :
- 15+ clients variés (promoteurs immobiliers, mairies, particuliers, SCI)
- 20+ projets réalistes (rénovation haussmannien, construction logements, aménagement bureau, extension maison, équipement public)
- 5 architectes avec spécialités différentes
- Phases remplies pour chaque projet avec avancements cohérents
- Devis et factures avec montants réalistes (honoraires 8-15% du budget)
- Réunions de chantier avec vrais ordres du jour
- Suivi d'heures sur 6 mois
- Les villes doivent être des vraies villes françaises (Paris, Lyon, Bordeaux, Nantes, Marseille...)
- Les noms d'entreprises doivent être crédibles (SCI Les Terrasses, Bouygues Immobilier, Mairie de Vincennes...)

## 4. Vues et requêtes analytiques (07_analytics_queries.sql)
Inclus ces requêtes commentées et prêtes à exécuter :
1. CA total et par architecte (année en cours)
2. Projets en retard avec nb jours de dépassement
3. Taux de conversion devis → projet
4. Rentabilité par projet (honoraires vs heures passées × taux horaire)
5. Répartition des projets par type et statut
6. Top 5 clients par CA cumulé
7. Charge de travail par architecte (heures/semaine)
8. Factures impayées avec ancienneté
9. Pipeline commercial (prospects → CA potentiel)
10. Avancement moyen par phase sur tous les projets
11. Marge nette par projet
12. Saisonnalité des projets (nb démarrés par mois)
13. Délai moyen obtention permis de construire
14. Budget moyen par type de projet et surface
15. Taux d'occupation des architectes

## 5. Fonctions PL/pgSQL (04_functions.sql)
- `calculer_honoraires(projet_id)` → retourne les honoraires ventilés par phase
- `verifier_rentabilite(projet_id)` → compare honoraires vs coût réel en heures
- `generer_ref_projet(annee)` → auto-génère ARCH-2024-XXX
- `alertes_delais()` → retourne les projets/phases en retard
- `ca_mensuel(annee)` → retourne le CA mois par mois
- `synthese_projet(projet_id)` → retourne un JSON complet du projet

## 6. CLI Dashboard (src/cli.py)
Le CLI avec Rich doit afficher :
- Un tableau de bord avec stats clés (nb projets actifs, CA, factures en attente)
- La liste des projets avec couleurs par statut
- Les alertes (retards, factures impayées, budgets dépassés)
- Commandes : `dashboard`, `projets`, `clients`, `factures`, `alertes`, `export`

## 7. Points d'impression pour la vidéo
- Le README doit avoir un schéma ERD en ASCII art ET un lien vers le Mermaid
- Logging coloré avec Rich pendant l'initialisation de la DB
- Le dashboard terminal doit être visuellement impressionnant
- Chaque fichier SQL doit avoir un header commenté professionnel
- Le docker-compose doit inclure pgAdmin pour visualisation web

Lance-toi, fichier par fichier. Montre que tu construis une vraie base de données métier.
```

---

## 🎥 SCÉNARIO DE SCREEN RECORDING

### Avant (5 sec)
```bash
mkdir archi-demo && cd archi-demo
ls -la   # Montrer que c'est vide
```

### Pendant (3-5 min)
Colle le prompt → laisse Claude Code travailler en autonomie

### Après — Les money shots 🎯
```bash
# 1. Montrer la structure
tree archi-db/

# 2. Lancer la stack
cd archi-db
docker-compose up -d

# 3. Initialiser la DB avec les données
make init

# 4. Lancer le dashboard
python -m src.cli dashboard

# 5. Lancer une requête analytique
psql -U archi -d archi_db -f sql/07_analytics_queries.sql
```

### Post LinkedIn suggéré
> 🏗️ J'ai demandé à Claude Code de construire une base de données complète pour un cabinet d'architecture.
>
> En 4 minutes, il a généré :
> — 12 tables avec contraintes et relations
> — 100+ lignes de données réalistes
> — 15 requêtes analytiques métier
> — Des fonctions PL/pgSQL
> — Un CLI dashboard
> — Docker + pgAdmin
> — Documentation complète
>
> L'IA ne remplace pas les développeurs. Elle les rend 10x plus productifs.
>
> 🎥 Regardez-le travailler en autonomie ⬇️
