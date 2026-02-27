-- ============================================================================
-- CABINET D'ARCHITECTURE — INDEX DE PERFORMANCE
-- ============================================================================
-- Fichier  : 02_indexes.sql
-- Objet    : Index pour optimiser les requetes frequentes
-- Version  : 1.0
-- ============================================================================

-- === Clients ===
CREATE INDEX idx_clients_type ON clients(type);
CREATE INDEX idx_clients_ville ON clients(ville);
CREATE INDEX idx_clients_raison_sociale ON clients(raison_sociale);

-- === Projets ===
CREATE INDEX idx_projets_client_id ON projets(client_id);
CREATE INDEX idx_projets_statut ON projets(statut);
CREATE INDEX idx_projets_type_projet ON projets(type_projet);
CREATE INDEX idx_projets_architecte ON projets(architecte_responsable_id);
CREATE INDEX idx_projets_date_debut ON projets(date_debut);
CREATE INDEX idx_projets_ref ON projets(ref_projet);
CREATE INDEX idx_projets_statut_type ON projets(statut, type_projet);

-- === Phases projet ===
CREATE INDEX idx_phases_projet_id ON phases_projet(projet_id);
CREATE INDEX idx_phases_statut ON phases_projet(statut);
CREATE INDEX idx_phases_phase ON phases_projet(phase);

-- === Documents ===
CREATE INDEX idx_documents_projet_id ON documents(projet_id);
CREATE INDEX idx_documents_phase_id ON documents(phase_id);
CREATE INDEX idx_documents_type ON documents(type_document);

-- === Devis ===
CREATE INDEX idx_devis_projet_id ON devis(projet_id);
CREATE INDEX idx_devis_client_id ON devis(client_id);
CREATE INDEX idx_devis_statut ON devis(statut);
CREATE INDEX idx_devis_date_emission ON devis(date_emission);

-- === Factures ===
CREATE INDEX idx_factures_projet_id ON factures(projet_id);
CREATE INDEX idx_factures_devis_id ON factures(devis_id);
CREATE INDEX idx_factures_statut ON factures(statut);
CREATE INDEX idx_factures_date_echeance ON factures(date_echeance);
CREATE INDEX idx_factures_date_emission ON factures(date_emission);

-- === Reunions chantier ===
CREATE INDEX idx_reunions_projet_id ON reunions_chantier(projet_id);
CREATE INDEX idx_reunions_date ON reunions_chantier(date_reunion);

-- === Lots entreprises ===
CREATE INDEX idx_lots_projet_id ON lots_entreprises(projet_id);
CREATE INDEX idx_lots_statut ON lots_entreprises(statut);
CREATE INDEX idx_lots_lot ON lots_entreprises(lot);

-- === Suivi heures ===
CREATE INDEX idx_suivi_architecte_id ON suivi_heures(architecte_id);
CREATE INDEX idx_suivi_projet_id ON suivi_heures(projet_id);
CREATE INDEX idx_suivi_date ON suivi_heures(date);
CREATE INDEX idx_suivi_phase_id ON suivi_heures(phase_id);
CREATE INDEX idx_suivi_archi_date ON suivi_heures(architecte_id, date);

-- === Audit log ===
CREATE INDEX idx_audit_table_name ON audit_log(table_name);
CREATE INDEX idx_audit_record_id ON audit_log(record_id);
CREATE INDEX idx_audit_action ON audit_log(action);
CREATE INDEX idx_audit_created_at ON audit_log(created_at);

-- ============================================================================
-- FIN DES INDEX
-- ============================================================================
