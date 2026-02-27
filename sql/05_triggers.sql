-- ============================================================================
-- CABINET D'ARCHITECTURE — TRIGGERS
-- ============================================================================
-- Fichier  : 05_triggers.sql
-- Objet    : Triggers pour audit log, mises a jour auto et alertes
-- Version  : 1.0
-- ============================================================================

-- ============================================================================
-- TRIGGER GENERIQUE : Audit log
-- Enregistre toutes les modifications dans audit_log
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_audit_log()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, record_id, action, new_values)
        VALUES (TG_TABLE_NAME, NEW.id, 'INSERT', to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_values, new_values)
        VALUES (TG_TABLE_NAME, NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, record_id, action, old_values)
        VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', to_jsonb(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Application sur les tables principales
CREATE TRIGGER trg_audit_projets
    AFTER INSERT OR UPDATE OR DELETE ON projets
    FOR EACH ROW EXECUTE FUNCTION fn_audit_log();

CREATE TRIGGER trg_audit_clients
    AFTER INSERT OR UPDATE OR DELETE ON clients
    FOR EACH ROW EXECUTE FUNCTION fn_audit_log();

CREATE TRIGGER trg_audit_devis
    AFTER INSERT OR UPDATE OR DELETE ON devis
    FOR EACH ROW EXECUTE FUNCTION fn_audit_log();

CREATE TRIGGER trg_audit_factures
    AFTER INSERT OR UPDATE OR DELETE ON factures
    FOR EACH ROW EXECUTE FUNCTION fn_audit_log();

-- ============================================================================
-- TRIGGER : Mise a jour automatique de updated_at
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_timestamp_projets
    BEFORE UPDATE ON projets
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_clients
    BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_devis
    BEFORE UPDATE ON devis
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_factures
    BEFORE UPDATE ON factures
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_phases
    BEFORE UPDATE ON phases_projet
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_lots
    BEFORE UPDATE ON lots_entreprises
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

CREATE TRIGGER trg_timestamp_architectes
    BEFORE UPDATE ON architectes
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();

-- ============================================================================
-- TRIGGER : Mise a jour statut facture → en_retard
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_check_facture_retard()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.statut = 'envoyee' AND NEW.date_echeance < CURRENT_DATE THEN
        NEW.statut := 'en_retard';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_facture_retard
    BEFORE INSERT OR UPDATE ON factures
    FOR EACH ROW EXECUTE FUNCTION fn_check_facture_retard();

-- ============================================================================
-- TRIGGER : Mise a jour automatique statut projet
-- Quand toutes les phases sont validees → statut 'reception'
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_auto_statut_projet()
RETURNS TRIGGER AS $$
DECLARE
    v_total_phases INTEGER;
    v_phases_validees INTEGER;
BEGIN
    IF NEW.statut = 'valide' THEN
        SELECT COUNT(*), COUNT(*) FILTER (WHERE statut = 'valide')
        INTO v_total_phases, v_phases_validees
        FROM phases_projet
        WHERE projet_id = NEW.projet_id;

        IF v_total_phases > 0 AND v_total_phases = v_phases_validees THEN
            UPDATE projets
            SET statut = 'reception'
            WHERE id = NEW.projet_id
              AND statut NOT IN ('reception', 'clos');
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_statut_projet
    AFTER UPDATE ON phases_projet
    FOR EACH ROW EXECUTE FUNCTION fn_auto_statut_projet();

-- ============================================================================
-- TRIGGER : Alerte depassement budget
-- Log une alerte quand les heures depassent 80% du budget honoraires
-- ============================================================================
CREATE OR REPLACE FUNCTION fn_alerte_budget()
RETURNS TRIGGER AS $$
DECLARE
    v_cout_total NUMERIC;
    v_honoraires NUMERIC;
BEGIN
    SELECT
        COALESCE(SUM(sh.nb_heures * a.taux_horaire), 0),
        p.honoraires_ht
    INTO v_cout_total, v_honoraires
    FROM projets p
    LEFT JOIN suivi_heures sh ON sh.projet_id = p.id
    LEFT JOIN architectes a ON a.id = sh.architecte_id
    WHERE p.id = NEW.projet_id
    GROUP BY p.id, p.honoraires_ht;

    IF v_honoraires > 0 AND v_cout_total > v_honoraires * 0.8 THEN
        INSERT INTO audit_log (table_name, record_id, action, new_values)
        VALUES (
            'suivi_heures',
            NEW.projet_id,
            'INSERT',
            jsonb_build_object(
                'alerte', 'DEPASSEMENT_BUDGET_80PCT',
                'cout_reel', v_cout_total,
                'honoraires', v_honoraires,
                'ratio_pct', ROUND(v_cout_total / v_honoraires * 100, 1)
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_alerte_budget
    AFTER INSERT ON suivi_heures
    FOR EACH ROW EXECUTE FUNCTION fn_alerte_budget();

-- ============================================================================
-- FIN DES TRIGGERS
-- ============================================================================
