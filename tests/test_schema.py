"""Tests — Verifie l'integrite des tables et contraintes."""

import pytest
from sqlalchemy import inspect, text

from src.db import engine


EXPECTED_TABLES = [
    "architectes", "clients", "projets", "phases_projet",
    "documents", "devis", "factures", "reunions_chantier",
    "lots_entreprises", "suivi_heures", "audit_log",
]


@pytest.fixture(scope="module")
def connection():
    with engine.connect() as conn:
        yield conn


class TestSchema:
    def test_all_tables_exist(self, connection):
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        for t in EXPECTED_TABLES:
            assert t in tables, f"Table '{t}' manquante"

    def test_projets_has_expected_columns(self, connection):
        inspector = inspect(engine)
        columns = [c["name"] for c in inspector.get_columns("projets")]
        expected = ["id", "ref_projet", "nom_projet", "client_id", "statut"]
        for col in expected:
            assert col in columns, f"Colonne '{col}' manquante dans projets"

    def test_foreign_keys_projets(self, connection):
        inspector = inspect(engine)
        fks = inspector.get_foreign_keys("projets")
        fk_columns = [fk["constrained_columns"][0] for fk in fks]
        assert "client_id" in fk_columns
        assert "architecte_responsable_id" in fk_columns

    def test_unique_constraints(self, connection):
        inspector = inspect(engine)
        uniques = inspector.get_unique_constraints("projets")
        unique_cols = []
        for u in uniques:
            unique_cols.extend(u["column_names"])
        assert "ref_projet" in unique_cols

    def test_check_constraints_budget(self, connection):
        """Budget doit etre >= 0."""
        with pytest.raises(Exception):
            connection.execute(text(
                "INSERT INTO projets (ref_projet, nom_projet, client_id, type_projet, "
                "budget_estime_ht, surface_m2) "
                "VALUES ('TEST-NEG', 'Test', 1, 'neuf', -100, 50)"
            ))
            connection.commit()

    def test_audit_log_table(self, connection):
        inspector = inspect(engine)
        columns = [c["name"] for c in inspector.get_columns("audit_log")]
        assert "old_values" in columns
        assert "new_values" in columns

    def test_phases_unique_constraint(self, connection):
        """Un projet ne peut pas avoir deux fois la meme phase."""
        inspector = inspect(engine)
        uniques = inspector.get_unique_constraints("phases_projet")
        found = any(
            set(u["column_names"]) == {"projet_id", "phase"}
            for u in uniques
        )
        assert found, "Contrainte unique (projet_id, phase) manquante"
