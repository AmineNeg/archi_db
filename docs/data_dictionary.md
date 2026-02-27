# Dictionnaire de donnees — Cabinet d'Architecture

## Table : `architectes`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| nom | VARCHAR(100) | NON | Nom de famille |
| prenom | VARCHAR(100) | NON | Prenom |
| email | VARCHAR(255) | NON | Email professionnel (unique) |
| telephone | VARCHAR(20) | OUI | Telephone mobile |
| specialite | VARCHAR(150) | OUI | Domaine d'expertise principal |
| numero_ordre | VARCHAR(30) | OUI | Numero d'inscription a l'Ordre des Architectes |
| date_inscription_ordre | DATE | OUI | Date d'inscription a l'Ordre |
| taux_horaire | NUMERIC(8,2) | NON | Taux horaire en EUR HT (defaut: 85.00) |
| statut | ENUM | NON | actif / inactif |
| created_at | TIMESTAMPTZ | NON | Date de creation |
| updated_at | TIMESTAMPTZ | NON | Derniere modification |

## Table : `clients`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| raison_sociale | VARCHAR(255) | NON | Nom ou raison sociale |
| type | ENUM | NON | particulier / promoteur / collectivite / entreprise |
| nom_contact | VARCHAR(100) | OUI | Nom du contact principal |
| prenom_contact | VARCHAR(100) | OUI | Prenom du contact |
| email | VARCHAR(255) | OUI | Email du contact |
| telephone | VARCHAR(20) | OUI | Telephone |
| adresse | VARCHAR(255) | OUI | Adresse postale |
| ville | VARCHAR(100) | OUI | Ville |
| code_postal | VARCHAR(10) | OUI | Code postal |
| siret | VARCHAR(17) | OUI | Numero SIRET (personnes morales) |
| date_creation | DATE | NON | Date de creation du client |
| notes | TEXT | OUI | Notes libres |

## Table : `projets`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| ref_projet | VARCHAR(20) | NON | Reference unique (ARCH-YYYY-NNN) |
| nom_projet | VARCHAR(255) | NON | Intitule du projet |
| client_id | INTEGER FK | NON | Reference vers clients |
| type_projet | ENUM | NON | neuf / renovation / extension / amenagement_interieur / urbanisme |
| description | TEXT | OUI | Description detaillee |
| adresse_chantier | VARCHAR(255) | OUI | Adresse du chantier |
| ville_chantier | VARCHAR(100) | OUI | Ville du chantier |
| surface_m2 | NUMERIC(10,2) | OUI | Surface en m2 (doit etre > 0) |
| nb_lots | INTEGER | OUI | Nombre de lots (logements) |
| budget_estime_ht | NUMERIC(14,2) | OUI | Budget travaux estime HT (>= 0) |
| honoraires_ht | NUMERIC(12,2) | OUI | Montant total des honoraires HT |
| taux_honoraires_pct | NUMERIC(5,2) | OUI | Pourcentage d'honoraires (0-100) |
| statut | ENUM | NON | prospect / etude / permis_depose / permis_accorde / chantier / reception / clos |
| date_debut | DATE | OUI | Date de demarrage |
| date_fin_prevue | DATE | OUI | Date de fin prevue |
| date_fin_reelle | DATE | OUI | Date de fin effective |
| architecte_responsable_id | INTEGER FK | OUI | Architecte responsable |

## Table : `phases_projet`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Reference vers projets |
| phase | ENUM | NON | ESQ / APS / APD / PRO / DCE / ACT / VISA / DET / AOR |
| statut | ENUM | NON | a_faire / en_cours / valide / annule |
| date_debut | DATE | OUI | Date debut de la phase |
| date_fin_prevue | DATE | OUI | Date fin prevue |
| date_fin_reelle | DATE | OUI | Date fin effective |
| honoraires_phase_ht | NUMERIC(12,2) | OUI | Honoraires pour cette phase |
| pct_avancement | INTEGER | OUI | Pourcentage d'avancement (0-100) |
| commentaires | TEXT | OUI | Commentaires libres |

## Table : `documents`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Projet associe |
| phase_id | INTEGER FK | OUI | Phase associee |
| type_document | ENUM | NON | plan / coupe / perspective / notice / devis / facture / cr_chantier / photo |
| nom_fichier | VARCHAR(500) | NON | Nom du fichier |
| version | INTEGER | NON | Numero de version (> 0) |
| chemin_fichier | VARCHAR(1000) | NON | Chemin d'acces au fichier |
| uploaded_by | INTEGER FK | OUI | Architecte ayant uploade |

## Table : `devis`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Projet associe |
| client_id | INTEGER FK | NON | Client destinataire |
| ref_devis | VARCHAR(30) | NON | Reference unique du devis |
| montant_ht | NUMERIC(14,2) | NON | Montant HT |
| taux_tva | NUMERIC(5,2) | NON | Taux de TVA (defaut 20%) |
| montant_ttc | NUMERIC(14,2) | NON | Montant TTC |
| statut | ENUM | NON | brouillon / envoye / accepte / refuse / expire |
| date_emission | DATE | NON | Date d'emission |
| date_validite | DATE | OUI | Date de validite |
| conditions_paiement | TEXT | OUI | Conditions de paiement |
| notes | TEXT | OUI | Notes |

## Table : `factures`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Projet associe |
| devis_id | INTEGER FK | OUI | Devis associe |
| ref_facture | VARCHAR(30) | NON | Reference unique |
| montant_ht | NUMERIC(14,2) | NON | Montant HT |
| taux_tva | NUMERIC(5,2) | NON | Taux TVA |
| montant_ttc | NUMERIC(14,2) | NON | Montant TTC |
| statut | ENUM | NON | brouillon / envoyee / payee / en_retard / annulee |
| date_emission | DATE | NON | Date d'emission |
| date_echeance | DATE | OUI | Date d'echeance |
| date_paiement | DATE | OUI | Date de paiement effectif |
| mode_paiement | VARCHAR(50) | OUI | Mode de paiement |

## Table : `reunions_chantier`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Projet associe |
| date_reunion | DATE | NON | Date de la reunion |
| lieu | VARCHAR(255) | OUI | Lieu de la reunion |
| participants | TEXT | OUI | Liste des participants |
| ordre_du_jour | TEXT | OUI | Ordre du jour |
| compte_rendu | TEXT | OUI | Compte rendu |
| prochaine_reunion | DATE | OUI | Date de la prochaine reunion |
| actions_a_suivre | TEXT | OUI | Actions a suivre |

## Table : `lots_entreprises`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| projet_id | INTEGER FK | NON | Projet associe |
| lot | ENUM | NON | Type de lot (gros_oeuvre, plomberie, etc.) |
| entreprise_nom | VARCHAR(255) | NON | Nom de l'entreprise |
| entreprise_siret | VARCHAR(17) | OUI | SIRET |
| montant_marche_ht | NUMERIC(14,2) | OUI | Montant du marche HT |
| statut | ENUM | NON | consultation / attribue / en_cours / receptionne |

## Table : `suivi_heures`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | SERIAL | NON | Identifiant unique |
| architecte_id | INTEGER FK | NON | Architecte |
| projet_id | INTEGER FK | NON | Projet |
| date | DATE | NON | Date de la saisie |
| nb_heures | NUMERIC(5,2) | NON | Nombre d'heures (> 0, <= 24) |
| description_tache | VARCHAR(500) | OUI | Description de la tache |
| phase_id | INTEGER FK | OUI | Phase associee |

## Table : `audit_log`

| Colonne | Type | Nullable | Description |
|---------|------|----------|-------------|
| id | BIGSERIAL | NON | Identifiant unique |
| table_name | VARCHAR(100) | NON | Table concernee |
| record_id | INTEGER | NON | ID de l'enregistrement |
| action | ENUM | NON | INSERT / UPDATE / DELETE |
| old_values | JSONB | OUI | Anciennes valeurs |
| new_values | JSONB | OUI | Nouvelles valeurs |
| user_info | VARCHAR(255) | OUI | Utilisateur |
| created_at | TIMESTAMPTZ | NON | Date de l'operation |
