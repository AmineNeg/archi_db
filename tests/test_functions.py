"""Tests — Verifie les fonctions PL/pgSQL."""

import pytest
from sqlalchemy import text

from src.db import engine


@pytest.fixture(scope="module")
def connection():
    with engine.connect() as conn:
        yield conn


class TestFunctions:
    def test_calculer_honoraires(self, connection):
        result = connection.execute(text("SELECT * FROM calculer_honoraires(1)"))
        rows = result.fetchall()
        assert len(rows) > 0, "Aucune phase trouvee pour projet 1"
        # Verifier que les honoraires sont positifs
        for row in rows:
            assert row[1] >= 0

    def test_verifier_rentabilite(self, connection):
        result = connection.execute(text("SELECT * FROM verifier_rentabilite(1)"))
        row = result.fetchone()
        assert row is not None
        assert row[0] == "ARCH-2023-001"

    def test_generer_ref_projet(self, connection):
        result = connection.execute(text("SELECT generer_ref_projet(2025)"))
        ref = result.scalar()
        assert ref.startswith("ARCH-2025-")

    def test_alertes_delais(self, connection):
        result = connection.execute(text("SELECT * FROM alertes_delais()"))
        # Peut retourner des lignes ou non
        assert result is not None

    def test_ca_mensuel(self, connection):
        result = connection.execute(text("SELECT * FROM ca_mensuel(2024)"))
        rows = result.fetchall()
        assert len(rows) > 0, "Aucune facture en 2024"

    def test_synthese_projet(self, connection):
        result = connection.execute(text("SELECT synthese_projet(1)"))
        json_data = result.scalar()
        assert json_data is not None
        assert "projet" in json_data
        assert "client" in json_data
        assert "financier" in json_data
