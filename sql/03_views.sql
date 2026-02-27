-- ============================================================================
-- CABINET D'ARCHITECTURE — VUES METIER
-- ============================================================================
-- Fichier  : 03_views.sql
-- Objet    : Vues pour le reporting et le suivi operationnel
-- Version  : 1.0
-- ============================================================================

-- ============================================================================
-- VUE : Projets en cours avec details
-- ============================================================================
CREATE OR REPLACE VIEW v_projets_en_cours AS
SELECT
    p.id,
    p.ref_projet,
    p.nom_projet,
    c.raison_sociale AS client,
    p.type_projet,
    p.statut,
    p.surface_m2,
    p.budget_estime_ht,
    p.honoraires_ht,
    p.date_debut,
    p.date_fin_prevue,
    a.nom || ' ' || a.prenom AS architecte_responsable,
    COALESCE(AVG(ph.pct_avancement), 0)::INTEGER AS avancement_moyen,
    CASE
        WHEN p.date_fin_prevue < CURRENT_DATE AND p.statut NOT IN ('reception', 'clos')
        THEN CURRENT_DATE - p.date_fin_prevue
        ELSE 0
    END AS jours_retard
FROM projets p
LEFT JOIN clients c ON c.id = p.client_id
LEFT JOIN architectes a ON a.id = p.architecte_responsable_id
LEFT JOIN phases_projet ph ON ph.projet_id = p.id
WHERE p.statut NOT IN ('clos', 'prospect')
GROUP BY p.id, c.raison_sociale, a.nom, a.prenom;

-- ============================================================================
-- VUE : Chiffre d'affaires par client
-- ============================================================================
CREATE OR REPLACE VIEW v_ca_par_client AS
SELECT
    c.id AS client_id,
    c.raison_sociale,
    c.type,
    COUNT(DISTINCT p.id) AS nb_projets,
    COALESCE(SUM(f.montant_ht) FILTER (WHERE f.statut = 'payee'), 0) AS ca_encaisse,
    COALESCE(SUM(f.montant_ht), 0) AS ca_facture_total,
    COALESCE(SUM(p.honoraires_ht), 0) AS honoraires_totaux
FROM clients c
LEFT JOIN projets p ON p.client_id = c.id
LEFT JOIN factures f ON f.projet_id = p.id
GROUP BY c.id, c.raison_sociale, c.type
ORDER BY ca_encaisse DESC;

-- ============================================================================
-- VUE : Rentabilite par projet
-- ============================================================================
CREATE OR REPLACE VIEW v_rentabilite_projet AS
SELECT
    p.id,
    p.ref_projet,
    p.nom_projet,
    p.honoraires_ht,
    COALESCE(SUM(sh.nb_heures), 0) AS heures_passees,
    COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) AS cout_reel,
    p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) AS marge_nette,
    CASE
        WHEN p.honoraires_ht > 0
        THEN ROUND(
            (p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0))
            / p.honoraires_ht * 100, 1
        )
        ELSE 0
    END AS marge_pct
FROM projets p
LEFT JOIN suivi_heures sh ON sh.projet_id = p.id
LEFT JOIN architectes a ON a.id = sh.architecte_id
GROUP BY p.id, p.ref_projet, p.nom_projet, p.honoraires_ht
ORDER BY marge_pct DESC;

-- ============================================================================
-- VUE : Factures en attente
-- ============================================================================
CREATE OR REPLACE VIEW v_factures_impayees AS
SELECT
    f.id,
    f.ref_facture,
    p.ref_projet,
    p.nom_projet,
    c.raison_sociale AS client,
    f.montant_ttc,
    f.date_emission,
    f.date_echeance,
    CURRENT_DATE - f.date_echeance AS jours_retard,
    f.statut
FROM factures f
JOIN projets p ON p.id = f.projet_id
JOIN clients c ON c.id = p.client_id
WHERE f.statut IN ('envoyee', 'en_retard')
ORDER BY jours_retard DESC;

-- ============================================================================
-- VUE : Charge de travail par architecte
-- ============================================================================
CREATE OR REPLACE VIEW v_charge_architectes AS
SELECT
    a.id,
    a.nom || ' ' || a.prenom AS architecte,
    a.specialite,
    COUNT(DISTINCT p.id) FILTER (WHERE p.statut NOT IN ('clos', 'prospect')) AS nb_projets_actifs,
    COALESCE(SUM(sh.nb_heures) FILTER (
        WHERE sh.date >= date_trunc('week', CURRENT_DATE)
    ), 0) AS heures_semaine_courante,
    COALESCE(SUM(sh.nb_heures) FILTER (
        WHERE sh.date >= date_trunc('month', CURRENT_DATE)
    ), 0) AS heures_mois_courant,
    COALESCE(AVG(sh.nb_heures), 0) AS heures_moy_jour
FROM architectes a
LEFT JOIN projets p ON p.architecte_responsable_id = a.id
LEFT JOIN suivi_heures sh ON sh.architecte_id = a.id
WHERE a.statut = 'actif'
GROUP BY a.id, a.nom, a.prenom, a.specialite;

-- ============================================================================
-- VUE : Pipeline commercial
-- ============================================================================
CREATE OR REPLACE VIEW v_pipeline_commercial AS
SELECT
    p.statut,
    COUNT(*) AS nb_projets,
    COALESCE(SUM(p.budget_estime_ht), 0) AS budget_total,
    COALESCE(SUM(p.honoraires_ht), 0) AS honoraires_potentiels,
    ROUND(AVG(p.surface_m2), 0) AS surface_moyenne
FROM projets p
GROUP BY p.statut
ORDER BY
    CASE p.statut
        WHEN 'prospect' THEN 1
        WHEN 'etude' THEN 2
        WHEN 'permis_depose' THEN 3
        WHEN 'permis_accorde' THEN 4
        WHEN 'chantier' THEN 5
        WHEN 'reception' THEN 6
        WHEN 'clos' THEN 7
    END;

-- ============================================================================
-- FIN DES VUES
-- ============================================================================
