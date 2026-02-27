-- ============================================================================
-- CABINET D'ARCHITECTURE — REQUETES ANALYTIQUES
-- ============================================================================
-- Fichier  : 07_analytics_queries.sql
-- Objet    : 15 requetes analytiques commentees, pretes a executer
-- Version  : 1.0
-- ============================================================================

-- ============================================================================
-- 1. CA total et par architecte (annee en cours)
-- ============================================================================
SELECT
    '--- CA PAR ARCHITECTE ---' AS section;

SELECT
    a.nom || ' ' || a.prenom AS architecte,
    COUNT(DISTINCT f.id) AS nb_factures,
    COALESCE(SUM(f.montant_ht) FILTER (WHERE f.statut = 'payee'), 0) AS ca_encaisse_ht,
    COALESCE(SUM(f.montant_ht), 0) AS ca_total_facture_ht
FROM architectes a
LEFT JOIN projets p ON p.architecte_responsable_id = a.id
LEFT JOIN factures f ON f.projet_id = p.id
    AND EXTRACT(YEAR FROM f.date_emission) = EXTRACT(YEAR FROM CURRENT_DATE)
WHERE a.statut = 'actif'
GROUP BY a.id, a.nom, a.prenom
ORDER BY ca_encaisse_ht DESC;

-- ============================================================================
-- 2. Projets en retard avec nombre de jours de depassement
-- ============================================================================
SELECT
    '--- PROJETS EN RETARD ---' AS section;

SELECT
    p.ref_projet,
    p.nom_projet,
    c.raison_sociale AS client,
    p.statut,
    p.date_fin_prevue,
    (CURRENT_DATE - p.date_fin_prevue) AS jours_retard,
    a.nom || ' ' || a.prenom AS architecte
FROM projets p
JOIN clients c ON c.id = p.client_id
LEFT JOIN architectes a ON a.id = p.architecte_responsable_id
WHERE p.date_fin_prevue < CURRENT_DATE
  AND p.statut NOT IN ('reception', 'clos')
  AND p.date_fin_reelle IS NULL
ORDER BY jours_retard DESC;

-- ============================================================================
-- 3. Taux de conversion devis → projet
-- ============================================================================
SELECT
    '--- TAUX CONVERSION DEVIS ---' AS section;

SELECT
    COUNT(*) AS total_devis,
    COUNT(*) FILTER (WHERE statut = 'accepte') AS devis_acceptes,
    COUNT(*) FILTER (WHERE statut = 'refuse') AS devis_refuses,
    COUNT(*) FILTER (WHERE statut IN ('envoye', 'expire')) AS devis_en_attente,
    ROUND(
        COUNT(*) FILTER (WHERE statut = 'accepte')::NUMERIC
        / NULLIF(COUNT(*) FILTER (WHERE statut IN ('accepte', 'refuse')), 0) * 100, 1
    ) AS taux_conversion_pct
FROM devis;

-- ============================================================================
-- 4. Rentabilite par projet (honoraires vs heures × taux horaire)
-- ============================================================================
SELECT
    '--- RENTABILITE PAR PROJET ---' AS section;

SELECT
    p.ref_projet,
    p.nom_projet,
    p.honoraires_ht,
    ROUND(COALESCE(SUM(sh.nb_heures), 0), 1) AS heures_passees,
    ROUND(COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0), 2) AS cout_reel,
    ROUND(p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0), 2) AS marge,
    CASE
        WHEN p.honoraires_ht > 0
        THEN ROUND((p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0)) / p.honoraires_ht * 100, 1)
        ELSE 0
    END AS marge_pct
FROM projets p
LEFT JOIN suivi_heures sh ON sh.projet_id = p.id
LEFT JOIN architectes a ON a.id = sh.architecte_id
WHERE p.statut NOT IN ('prospect')
GROUP BY p.id, p.ref_projet, p.nom_projet, p.honoraires_ht
ORDER BY marge_pct ASC;

-- ============================================================================
-- 5. Repartition des projets par type et statut
-- ============================================================================
SELECT
    '--- REPARTITION TYPE/STATUT ---' AS section;

SELECT
    p.type_projet,
    p.statut,
    COUNT(*) AS nb_projets,
    ROUND(AVG(p.surface_m2), 0) AS surface_moyenne,
    ROUND(AVG(p.budget_estime_ht), 0) AS budget_moyen
FROM projets p
GROUP BY p.type_projet, p.statut
ORDER BY p.type_projet, p.statut;

-- ============================================================================
-- 6. Top 5 clients par CA cumule
-- ============================================================================
SELECT
    '--- TOP 5 CLIENTS PAR CA ---' AS section;

SELECT
    c.raison_sociale,
    c.type,
    COUNT(DISTINCT p.id) AS nb_projets,
    COALESCE(SUM(f.montant_ht) FILTER (WHERE f.statut = 'payee'), 0) AS ca_encaisse,
    COALESCE(SUM(f.montant_ht), 0) AS ca_facture_total
FROM clients c
JOIN projets p ON p.client_id = c.id
LEFT JOIN factures f ON f.projet_id = p.id
GROUP BY c.id, c.raison_sociale, c.type
ORDER BY ca_encaisse DESC
LIMIT 5;

-- ============================================================================
-- 7. Charge de travail par architecte (heures/semaine, mois courant)
-- ============================================================================
SELECT
    '--- CHARGE ARCHITECTES ---' AS section;

SELECT
    a.nom || ' ' || a.prenom AS architecte,
    a.specialite,
    COUNT(DISTINCT p.id) FILTER (WHERE p.statut NOT IN ('clos', 'prospect')) AS projets_actifs,
    ROUND(COALESCE(SUM(sh.nb_heures) FILTER (
        WHERE sh.date >= CURRENT_DATE - INTERVAL '7 days'
    ), 0), 1) AS heures_7j,
    ROUND(COALESCE(SUM(sh.nb_heures) FILTER (
        WHERE sh.date >= date_trunc('month', CURRENT_DATE)
    ), 0), 1) AS heures_mois,
    ROUND(COALESCE(SUM(sh.nb_heures), 0), 1) AS heures_totales
FROM architectes a
LEFT JOIN projets p ON p.architecte_responsable_id = a.id
LEFT JOIN suivi_heures sh ON sh.architecte_id = a.id
WHERE a.statut = 'actif'
GROUP BY a.id, a.nom, a.prenom, a.specialite
ORDER BY heures_mois DESC;

-- ============================================================================
-- 8. Factures impayees avec anciennete
-- ============================================================================
SELECT
    '--- FACTURES IMPAYEES ---' AS section;

SELECT
    f.ref_facture,
    p.ref_projet,
    c.raison_sociale AS client,
    f.montant_ttc,
    f.date_emission,
    f.date_echeance,
    (CURRENT_DATE - f.date_echeance) AS jours_retard,
    CASE
        WHEN (CURRENT_DATE - f.date_echeance) > 60 THEN 'CRITIQUE'
        WHEN (CURRENT_DATE - f.date_echeance) > 30 THEN 'ALERTE'
        WHEN (CURRENT_DATE - f.date_echeance) > 0  THEN 'RETARD'
        ELSE 'A ECHEANCE'
    END AS niveau_urgence
FROM factures f
JOIN projets p ON p.id = f.projet_id
JOIN clients c ON c.id = p.client_id
WHERE f.statut IN ('envoyee', 'en_retard')
ORDER BY jours_retard DESC;

-- ============================================================================
-- 9. Pipeline commercial (prospects → CA potentiel)
-- ============================================================================
SELECT
    '--- PIPELINE COMMERCIAL ---' AS section;

SELECT
    p.statut,
    COUNT(*) AS nb_projets,
    SUM(p.budget_estime_ht) AS budget_total,
    SUM(p.honoraires_ht) AS honoraires_potentiels,
    ROUND(AVG(p.taux_honoraires_pct), 1) AS taux_moyen_pct
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
-- 10. Avancement moyen par phase sur tous les projets
-- ============================================================================
SELECT
    '--- AVANCEMENT PAR PHASE ---' AS section;

SELECT
    ph.phase,
    COUNT(*) AS nb_projets,
    ROUND(AVG(ph.pct_avancement), 0) AS avancement_moyen,
    COUNT(*) FILTER (WHERE ph.statut = 'valide') AS nb_valides,
    COUNT(*) FILTER (WHERE ph.statut = 'en_cours') AS nb_en_cours,
    COUNT(*) FILTER (WHERE ph.statut = 'a_faire') AS nb_a_faire,
    SUM(ph.honoraires_phase_ht) AS honoraires_totaux
FROM phases_projet ph
GROUP BY ph.phase
ORDER BY
    CASE ph.phase
        WHEN 'ESQ' THEN 1 WHEN 'APS' THEN 2 WHEN 'APD' THEN 3
        WHEN 'PRO' THEN 4 WHEN 'DCE' THEN 5 WHEN 'ACT' THEN 6
        WHEN 'VISA' THEN 7 WHEN 'DET' THEN 8 WHEN 'AOR' THEN 9
    END;

-- ============================================================================
-- 11. Marge nette par projet (detail)
-- ============================================================================
SELECT
    '--- MARGE NETTE PAR PROJET ---' AS section;

SELECT
    p.ref_projet,
    p.nom_projet,
    p.type_projet,
    p.honoraires_ht AS honoraires,
    ROUND(COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0), 2) AS cout_heures,
    ROUND(p.honoraires_ht - COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0), 2) AS marge_nette,
    CASE
        WHEN COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) > p.honoraires_ht
        THEN 'DEFICIT'
        WHEN COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0) > p.honoraires_ht * 0.8
        THEN 'ATTENTION'
        ELSE 'OK'
    END AS statut_marge
FROM projets p
LEFT JOIN suivi_heures sh ON sh.projet_id = p.id
LEFT JOIN architectes a ON a.id = sh.architecte_id
WHERE p.statut NOT IN ('prospect')
GROUP BY p.id, p.ref_projet, p.nom_projet, p.type_projet, p.honoraires_ht
ORDER BY marge_nette ASC;

-- ============================================================================
-- 12. Saisonnalite des projets (nb demarres par mois)
-- ============================================================================
SELECT
    '--- SAISONNALITE ---' AS section;

SELECT
    TO_CHAR(p.date_debut, 'YYYY-MM') AS mois,
    COUNT(*) AS nb_projets_demarres,
    SUM(p.budget_estime_ht) AS volume_budget,
    STRING_AGG(p.ref_projet, ', ') AS projets
FROM projets p
WHERE p.date_debut IS NOT NULL
GROUP BY TO_CHAR(p.date_debut, 'YYYY-MM')
ORDER BY mois;

-- ============================================================================
-- 13. Delai moyen obtention permis de construire
-- ============================================================================
SELECT
    '--- DELAI MOYEN PERMIS ---' AS section;

SELECT
    p.type_projet,
    COUNT(*) AS nb_projets_avec_permis,
    ROUND(AVG(
        CASE
            WHEN ph_depose.date_fin_reelle IS NOT NULL AND ph_accorde.date_debut IS NOT NULL
            THEN ph_accorde.date_debut - ph_depose.date_fin_reelle
            ELSE NULL
        END
    ), 0) AS delai_moyen_jours
FROM projets p
LEFT JOIN phases_projet ph_depose ON ph_depose.projet_id = p.id AND ph_depose.phase = 'APD'
LEFT JOIN phases_projet ph_accorde ON ph_accorde.projet_id = p.id AND ph_accorde.phase = 'PRO'
WHERE p.statut NOT IN ('prospect', 'etude')
GROUP BY p.type_projet
ORDER BY delai_moyen_jours DESC NULLS LAST;

-- ============================================================================
-- 14. Budget moyen par type de projet et surface
-- ============================================================================
SELECT
    '--- BUDGET PAR TYPE ET SURFACE ---' AS section;

SELECT
    p.type_projet,
    COUNT(*) AS nb_projets,
    ROUND(AVG(p.budget_estime_ht), 0) AS budget_moyen,
    ROUND(AVG(p.surface_m2), 0) AS surface_moyenne,
    ROUND(AVG(p.budget_estime_ht / NULLIF(p.surface_m2, 0)), 0) AS cout_m2_moyen,
    ROUND(AVG(p.taux_honoraires_pct), 1) AS taux_honoraires_moyen
FROM projets p
GROUP BY p.type_projet
ORDER BY budget_moyen DESC;

-- ============================================================================
-- 15. Taux d'occupation des architectes
-- ============================================================================
SELECT
    '--- TAUX OCCUPATION ---' AS section;

SELECT
    a.nom || ' ' || a.prenom AS architecte,
    ROUND(COALESCE(SUM(sh.nb_heures) FILTER (
        WHERE sh.date >= CURRENT_DATE - INTERVAL '30 days'
    ), 0), 1) AS heures_30j,
    ROUND(22 * 7.5, 1) AS capacite_30j,  -- 22 jours ouvrés × 7.5h
    ROUND(
        COALESCE(SUM(sh.nb_heures) FILTER (
            WHERE sh.date >= CURRENT_DATE - INTERVAL '30 days'
        ), 0) / (22 * 7.5) * 100, 1
    ) AS taux_occupation_pct,
    CASE
        WHEN COALESCE(SUM(sh.nb_heures) FILTER (
            WHERE sh.date >= CURRENT_DATE - INTERVAL '30 days'
        ), 0) / (22 * 7.5) > 0.9 THEN 'SURCHARGE'
        WHEN COALESCE(SUM(sh.nb_heures) FILTER (
            WHERE sh.date >= CURRENT_DATE - INTERVAL '30 days'
        ), 0) / (22 * 7.5) > 0.7 THEN 'OPTIMAL'
        WHEN COALESCE(SUM(sh.nb_heures) FILTER (
            WHERE sh.date >= CURRENT_DATE - INTERVAL '30 days'
        ), 0) / (22 * 7.5) > 0.4 THEN 'DISPONIBLE'
        ELSE 'SOUS-CHARGE'
    END AS statut
FROM architectes a
LEFT JOIN suivi_heures sh ON sh.architecte_id = a.id
WHERE a.statut = 'actif'
GROUP BY a.id, a.nom, a.prenom
ORDER BY taux_occupation_pct DESC;

-- ============================================================================
-- FIN DES REQUETES ANALYTIQUES
-- ============================================================================
