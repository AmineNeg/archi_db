-- ============================================================================
-- CABINET D'ARCHITECTURE — SCHEMA DE BASE DE DONNEES
-- ============================================================================
-- Fichier  : 01_schema.sql
-- Objet    : Creation de toutes les tables, types ENUM et contraintes
-- Version  : 1.0
-- Date     : 2024
-- ============================================================================

-- Nettoyage prealable
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- ============================================================================
-- TYPES ENUM
-- ============================================================================

CREATE TYPE type_client AS ENUM (
    'particulier', 'promoteur', 'collectivite', 'entreprise'
);

CREATE TYPE type_projet AS ENUM (
    'neuf', 'renovation', 'extension', 'amenagement_interieur', 'urbanisme'
);

CREATE TYPE statut_projet AS ENUM (
    'prospect', 'etude', 'permis_depose', 'permis_accorde',
    'chantier', 'reception', 'clos'
);

CREATE TYPE phase_type AS ENUM (
    'ESQ', 'APS', 'APD', 'PRO', 'DCE', 'ACT', 'VISA', 'DET', 'AOR'
);

CREATE TYPE statut_phase AS ENUM (
    'a_faire', 'en_cours', 'valide', 'annule'
);

CREATE TYPE type_document AS ENUM (
    'plan', 'coupe', 'perspective', 'notice', 'devis',
    'facture', 'cr_chantier', 'photo'
);

CREATE TYPE statut_devis AS ENUM (
    'brouillon', 'envoye', 'accepte', 'refuse', 'expire'
);

CREATE TYPE statut_facture AS ENUM (
    'brouillon', 'envoyee', 'payee', 'en_retard', 'annulee'
);

CREATE TYPE statut_architecte AS ENUM (
    'actif', 'inactif'
);

CREATE TYPE type_lot AS ENUM (
    'gros_oeuvre', 'charpente', 'couverture', 'menuiserie',
    'plomberie', 'electricite', 'peinture', 'vrd',
    'cloisons', 'carrelage', 'cvc', 'ascenseur',
    'espaces_verts', 'serrurerie', 'etancheite'
);

CREATE TYPE statut_lot AS ENUM (
    'consultation', 'attribue', 'en_cours', 'receptionne'
);

CREATE TYPE action_audit AS ENUM (
    'INSERT', 'UPDATE', 'DELETE'
);

-- ============================================================================
-- TABLE : architectes
-- ============================================================================

CREATE TABLE architectes (
    id              SERIAL PRIMARY KEY,
    nom             VARCHAR(100) NOT NULL,
    prenom          VARCHAR(100) NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    telephone       VARCHAR(20),
    specialite      VARCHAR(150),
    numero_ordre    VARCHAR(30) UNIQUE,
    date_inscription_ordre DATE,
    taux_horaire    NUMERIC(8,2) NOT NULL DEFAULT 85.00,
    statut          statut_architecte NOT NULL DEFAULT 'actif',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE : clients
-- ============================================================================

CREATE TABLE clients (
    id              SERIAL PRIMARY KEY,
    raison_sociale  VARCHAR(255) NOT NULL,
    type            type_client NOT NULL DEFAULT 'particulier',
    nom_contact     VARCHAR(100),
    prenom_contact  VARCHAR(100),
    email           VARCHAR(255),
    telephone       VARCHAR(20),
    adresse         VARCHAR(255),
    ville           VARCHAR(100),
    code_postal     VARCHAR(10),
    siret           VARCHAR(17),
    date_creation   DATE NOT NULL DEFAULT CURRENT_DATE,
    notes           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE : projets
-- ============================================================================

CREATE TABLE projets (
    id                      SERIAL PRIMARY KEY,
    ref_projet              VARCHAR(20) NOT NULL UNIQUE,
    nom_projet              VARCHAR(255) NOT NULL,
    client_id               INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    type_projet             type_projet NOT NULL,
    description             TEXT,
    adresse_chantier        VARCHAR(255),
    ville_chantier          VARCHAR(100),
    surface_m2              NUMERIC(10,2),
    nb_lots                 INTEGER DEFAULT 0,
    budget_estime_ht        NUMERIC(14,2),
    honoraires_ht           NUMERIC(12,2),
    taux_honoraires_pct     NUMERIC(5,2),
    statut                  statut_projet NOT NULL DEFAULT 'prospect',
    date_debut              DATE,
    date_fin_prevue         DATE,
    date_fin_reelle         DATE,
    architecte_responsable_id INTEGER REFERENCES architectes(id) ON DELETE SET NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_budget_positif CHECK (budget_estime_ht >= 0),
    CONSTRAINT chk_honoraires_positif CHECK (honoraires_ht >= 0),
    CONSTRAINT chk_taux_honoraires CHECK (taux_honoraires_pct BETWEEN 0 AND 100),
    CONSTRAINT chk_surface_positive CHECK (surface_m2 > 0),
    CONSTRAINT chk_dates_projet CHECK (date_fin_prevue IS NULL OR date_debut IS NULL OR date_fin_prevue >= date_debut)
);

-- ============================================================================
-- TABLE : phases_projet
-- ============================================================================

CREATE TABLE phases_projet (
    id                  SERIAL PRIMARY KEY,
    projet_id           INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    phase               phase_type NOT NULL,
    statut              statut_phase NOT NULL DEFAULT 'a_faire',
    date_debut          DATE,
    date_fin_prevue     DATE,
    date_fin_reelle     DATE,
    honoraires_phase_ht NUMERIC(12,2) DEFAULT 0,
    pct_avancement      INTEGER DEFAULT 0,
    commentaires        TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_projet_phase UNIQUE (projet_id, phase),
    CONSTRAINT chk_avancement CHECK (pct_avancement BETWEEN 0 AND 100),
    CONSTRAINT chk_honoraires_phase CHECK (honoraires_phase_ht >= 0)
);

-- ============================================================================
-- TABLE : documents
-- ============================================================================

CREATE TABLE documents (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    phase_id        INTEGER REFERENCES phases_projet(id) ON DELETE SET NULL,
    type_document   type_document NOT NULL,
    nom_fichier     VARCHAR(500) NOT NULL,
    version         INTEGER NOT NULL DEFAULT 1,
    chemin_fichier  VARCHAR(1000) NOT NULL,
    uploaded_by     INTEGER REFERENCES architectes(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_version_positive CHECK (version > 0)
);

-- ============================================================================
-- TABLE : devis
-- ============================================================================

CREATE TABLE devis (
    id                  SERIAL PRIMARY KEY,
    projet_id           INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    client_id           INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    ref_devis           VARCHAR(30) NOT NULL UNIQUE,
    montant_ht          NUMERIC(14,2) NOT NULL,
    taux_tva            NUMERIC(5,2) NOT NULL DEFAULT 20.00,
    montant_ttc         NUMERIC(14,2) NOT NULL,
    statut              statut_devis NOT NULL DEFAULT 'brouillon',
    date_emission       DATE NOT NULL DEFAULT CURRENT_DATE,
    date_validite       DATE,
    conditions_paiement TEXT,
    notes               TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_montant_ht_positif CHECK (montant_ht >= 0),
    CONSTRAINT chk_tva_positive CHECK (taux_tva >= 0),
    CONSTRAINT chk_montant_ttc_coherent CHECK (montant_ttc >= montant_ht)
);

-- ============================================================================
-- TABLE : factures
-- ============================================================================

CREATE TABLE factures (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    devis_id        INTEGER REFERENCES devis(id) ON DELETE SET NULL,
    ref_facture     VARCHAR(30) NOT NULL UNIQUE,
    montant_ht      NUMERIC(14,2) NOT NULL,
    taux_tva        NUMERIC(5,2) NOT NULL DEFAULT 20.00,
    montant_ttc     NUMERIC(14,2) NOT NULL,
    statut          statut_facture NOT NULL DEFAULT 'brouillon',
    date_emission   DATE NOT NULL DEFAULT CURRENT_DATE,
    date_echeance   DATE,
    date_paiement   DATE,
    mode_paiement   VARCHAR(50),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_facture_ht_positif CHECK (montant_ht >= 0),
    CONSTRAINT chk_facture_ttc_coherent CHECK (montant_ttc >= montant_ht)
);

-- ============================================================================
-- TABLE : reunions_chantier
-- ============================================================================

CREATE TABLE reunions_chantier (
    id                  SERIAL PRIMARY KEY,
    projet_id           INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    date_reunion        DATE NOT NULL,
    lieu                VARCHAR(255),
    participants        TEXT,
    ordre_du_jour       TEXT,
    compte_rendu        TEXT,
    prochaine_reunion   DATE,
    actions_a_suivre    TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TABLE : lots_entreprises
-- ============================================================================

CREATE TABLE lots_entreprises (
    id                  SERIAL PRIMARY KEY,
    projet_id           INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    lot                 type_lot NOT NULL,
    entreprise_nom      VARCHAR(255) NOT NULL,
    entreprise_siret    VARCHAR(17),
    montant_marche_ht   NUMERIC(14,2),
    statut              statut_lot NOT NULL DEFAULT 'consultation',
    date_debut          DATE,
    date_fin            DATE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_montant_marche_positif CHECK (montant_marche_ht >= 0)
);

-- ============================================================================
-- TABLE : suivi_heures
-- ============================================================================

CREATE TABLE suivi_heures (
    id              SERIAL PRIMARY KEY,
    architecte_id   INTEGER NOT NULL REFERENCES architectes(id) ON DELETE CASCADE,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    date            DATE NOT NULL,
    nb_heures       NUMERIC(5,2) NOT NULL,
    description_tache VARCHAR(500),
    phase_id        INTEGER REFERENCES phases_projet(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_heures_positive CHECK (nb_heures > 0 AND nb_heures <= 24)
);

-- ============================================================================
-- TABLE : audit_log
-- ============================================================================

CREATE TABLE audit_log (
    id          BIGSERIAL PRIMARY KEY,
    table_name  VARCHAR(100) NOT NULL,
    record_id   INTEGER NOT NULL,
    action      action_audit NOT NULL,
    old_values  JSONB,
    new_values  JSONB,
    user_info   VARCHAR(255) DEFAULT current_user,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- FIN DU SCHEMA
-- ============================================================================
