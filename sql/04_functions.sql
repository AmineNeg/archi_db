-- ============================================================================
-- CABINET D'ARCHITECTURE — FONCTIONS PL/pgSQL
-- ============================================================================
-- Fichier  : 04_functions.sql
-- Objet    : Fonctions metier pour calculs, alertes et generation de refs
-- Version  : 1.0
-- ============================================================================

-- ============================================================================
-- FONCTION : calculer_honoraires(projet_id)
-- Retourne les honoraires ventiles par phase
-- ============================================================================
CREATE OR REPLACE FUNCTION calculer_honoraires(p_projet_id INTEGER)
RETURNS TABLE (
    phase           phase_type,
    honoraires_ht   NUMERIC,
    pct_avancement  INTEGER,
    honoraires_acquis NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ph.phase,
        ph.honoraires_phase_ht,
        ph.pct_avancement,
        ROUND(ph.honoraires_phase_ht * ph.pct_avancement / 100.0, 2)
    FROM phases_projet ph
    WHERE ph.projet_id = p_projet_id
    ORDER BY
        CASE ph.phase
            WHEN 'ESQ' THEN 1 WHEN 'APS' THEN 2 WHEN 'APD' THEN 3
            WHEN 'PRO' THEN 4 WHEN 'DCE' THEN 5 WHEN 'ACT' THEN 6
            WHEN 'VISA' THEN 7 WHEN 'DET' THEN 8 WHEN 'AOR' THEN 9
        END;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FONCTION : verifier_rentabilite(projet_id)
-- Compare honoraires vs cout reel en heures
-- ============================================================================
CREATE OR REPLACE FUNCTION verifier_rentabilite(p_projet_id INTEGER)
RETURNS TABLE (
    ref_projet      VARCHAR,
    nom_projet      VARCHAR,
    honoraires_ht   NUMERIC,
    heures_totales  NUMERIC,
    cout_reel       NUMERIC,
    marge           NUMERIC,
    marge_pct       NUMERIC,
    alerte          TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.ref_projet,
        p.nom_projet,
        p.honoraires_ht,
        COALESCE(SUM(sh.nb_heures), 0),
        COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0),
        p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0),
        CASE
            WHEN p.honoraires_ht > 0
            THEN ROUND((p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0)) / p.honoraires_ht * 100, 1)
            ELSE 0::NUMERIC
        END,
        CASE
            WHEN COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) > p.honoraires_ht
            THEN 'DEPASSEMENT BUDGET'
            WHEN COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) > p.honoraires_ht * 0.8
            THEN 'ATTENTION - 80% du budget consomme'
            ELSE 'OK'
        END
    FROM projets p
    LEFT JOIN suivi_heures sh ON sh.projet_id = p.id
    LEFT JOIN architectes a ON a.id = sh.architecte_id
    WHERE p.id = p_projet_id
    GROUP BY p.id, p.ref_projet, p.nom_projet, p.honoraires_ht;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FONCTION : generer_ref_projet(annee)
-- Auto-genere ARCH-YYYY-NNN
-- ============================================================================
CREATE OR REPLACE FUNCTION generer_ref_projet(p_annee INTEGER DEFAULT EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_next_num INTEGER;
    v_ref VARCHAR;
BEGIN
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(ref_projet FROM 'ARCH-\d{4}-(\d+)') AS INTEGER)
    ), 0) + 1
    INTO v_next_num
    FROM projets
    WHERE ref_projet LIKE 'ARCH-' || p_annee || '-%';

    v_ref := 'ARCH-' || p_annee || '-' || LPAD(v_next_num::TEXT, 3, '0');
    RETURN v_ref;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- FONCTION : alertes_delais()
-- Retourne les projets et phases en retard
-- ============================================================================
CREATE OR REPLACE FUNCTION alertes_delais()
RETURNS TABLE (
    type_alerte     TEXT,
    ref_projet      VARCHAR,
    nom_projet      VARCHAR,
    element         TEXT,
    date_prevue     DATE,
    jours_retard    INTEGER,
    responsable     TEXT
) AS $$
BEGIN
    -- Projets en retard
    RETURN QUERY
    SELECT
        'PROJET EN RETARD'::TEXT,
        p.ref_projet,
        p.nom_projet,
        p.statut::TEXT,
        p.date_fin_prevue,
        (CURRENT_DATE - p.date_fin_prevue)::INTEGER,
        a.nom || ' ' || a.prenom
    FROM projets p
    LEFT JOIN architectes a ON a.id = p.architecte_responsable_id
    WHERE p.date_fin_prevue < CURRENT_DATE
      AND p.statut NOT IN ('reception', 'clos')
      AND p.date_fin_reelle IS NULL;

    -- Phases en retard
    RETURN QUERY
    SELECT
        'PHASE EN RETARD'::TEXT,
        p.ref_projet,
        p.nom_projet,
        ph.phase::TEXT,
        ph.date_fin_prevue,
        (CURRENT_DATE - ph.date_fin_prevue)::INTEGER,
        a.nom || ' ' || a.prenom
    FROM phases_projet ph
    JOIN projets p ON p.id = ph.projet_id
    LEFT JOIN architectes a ON a.id = p.architecte_responsable_id
    WHERE ph.date_fin_prevue < CURRENT_DATE
      AND ph.statut IN ('a_faire', 'en_cours')
      AND ph.date_fin_reelle IS NULL;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FONCTION : ca_mensuel(annee)
-- Retourne le CA mois par mois
-- ============================================================================
CREATE OR REPLACE FUNCTION ca_mensuel(p_annee INTEGER DEFAULT EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER)
RETURNS TABLE (
    mois        INTEGER,
    mois_nom    TEXT,
    nb_factures BIGINT,
    ca_ht       NUMERIC,
    ca_ttc      NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        EXTRACT(MONTH FROM f.date_emission)::INTEGER,
        TO_CHAR(f.date_emission, 'TMMonth'),
        COUNT(*),
        COALESCE(SUM(f.montant_ht), 0),
        COALESCE(SUM(f.montant_ttc), 0)
    FROM factures f
    WHERE EXTRACT(YEAR FROM f.date_emission) = p_annee
      AND f.statut NOT IN ('brouillon', 'annulee')
    GROUP BY EXTRACT(MONTH FROM f.date_emission), TO_CHAR(f.date_emission, 'TMMonth')
    ORDER BY EXTRACT(MONTH FROM f.date_emission);
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FONCTION : synthese_projet(projet_id)
-- Retourne un JSON complet du projet
-- ============================================================================
CREATE OR REPLACE FUNCTION synthese_projet(p_projet_id INTEGER)
RETURNS JSONB AS $$
DECLARE
    v_result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'projet', jsonb_build_object(
            'ref', p.ref_projet,
            'nom', p.nom_projet,
            'type', p.type_projet,
            'statut', p.statut,
            'surface_m2', p.surface_m2,
            'budget_ht', p.budget_estime_ht,
            'honoraires_ht', p.honoraires_ht,
            'date_debut', p.date_debut,
            'date_fin_prevue', p.date_fin_prevue
        ),
        'client', jsonb_build_object(
            'raison_sociale', c.raison_sociale,
            'type', c.type,
            'contact', c.prenom_contact || ' ' || c.nom_contact
        ),
        'architecte', jsonb_build_object(
            'nom', a.nom || ' ' || a.prenom,
            'specialite', a.specialite
        ),
        'phases', (
            SELECT COALESCE(jsonb_agg(jsonb_build_object(
                'phase', ph.phase,
                'statut', ph.statut,
                'avancement', ph.pct_avancement,
                'honoraires', ph.honoraires_phase_ht
            ) ORDER BY ph.id), '[]'::JSONB)
            FROM phases_projet ph WHERE ph.projet_id = p.id
        ),
        'financier', jsonb_build_object(
            'total_devis_ht', (SELECT COALESCE(SUM(d.montant_ht), 0) FROM devis d WHERE d.projet_id = p.id),
            'total_facture_ht', (SELECT COALESCE(SUM(f.montant_ht), 0) FROM factures f WHERE f.projet_id = p.id),
            'total_paye', (SELECT COALESCE(SUM(f.montant_ht), 0) FROM factures f WHERE f.projet_id = p.id AND f.statut = 'payee'),
            'heures_passees', (SELECT COALESCE(SUM(sh.nb_heures), 0) FROM suivi_heures sh WHERE sh.projet_id = p.id)
        )
    )
    INTO v_result
    FROM projets p
    LEFT JOIN clients c ON c.id = p.client_id
    LEFT JOIN architectes a ON a.id = p.architecte_responsable_id
    WHERE p.id = p_projet_id;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql STABLE;

-- ============================================================================
-- FIN DES FONCTIONS
-- ============================================================================
