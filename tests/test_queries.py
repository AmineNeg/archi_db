"""Tests — Verifie que les requetes analytiques tournent."""

import pytest
from sqlalchemy import text

from src.db import engine


@pytest.fixture(scope="module")
def connection():
    with engine.connect() as conn:
        yield conn


class TestViews:
    def test_view_projets_en_cours(self, connection):
        result = connection.execute(text("SELECT * FROM v_projets_en_cours"))
        rows = result.fetchall()
        assert len(rows) > 0

    def test_view_ca_par_client(self, connection):
        result = connection.execute(text("SELECT * FROM v_ca_par_client"))
        rows = result.fetchall()
        assert len(rows) > 0

    def test_view_rentabilite(self, connection):
        result = connection.execute(text("SELECT * FROM v_rentabilite_projet"))
        rows = result.fetchall()
        assert len(rows) > 0

    def test_view_factures_impayees(self, connection):
        result = connection.execute(text("SELECT * FROM v_factures_impayees"))
        # Peut etre vide si tout est paye
        assert result is not None

    def test_view_charge_architectes(self, connection):
        result = connection.execute(text("SELECT * FROM v_charge_architectes"))
        rows = result.fetchall()
        assert len(rows) > 0

    def test_view_pipeline(self, connection):
        result = connection.execute(text("SELECT * FROM v_pipeline_commercial"))
        rows = result.fetchall()
        assert len(rows) > 0


class TestAnalyticsQueries:
    def test_ca_par_architecte(self, connection):
        result = connection.execute(text("""
            SELECT a.nom, COALESCE(SUM(f.montant_ht), 0) AS ca
            FROM architectes a
            LEFT JOIN projets p ON p.architecte_responsable_id = a.id
            LEFT JOIN factures f ON f.projet_id = p.id AND f.statut = 'payee'
            GROUP BY a.id, a.nom
        """))
        rows = result.fetchall()
        assert len(rows) >= 5

    def test_projets_en_retard(self, connection):
        result = connection.execute(text("""
            SELECT p.ref_projet, (CURRENT_DATE - p.date_fin_prevue) AS jours
            FROM projets p
            WHERE p.date_fin_prevue < CURRENT_DATE
              AND p.statut NOT IN ('reception', 'clos')
              AND p.date_fin_reelle IS NULL
        """))
        assert result is not None

    def test_taux_conversion_devis(self, connection):
        result = connection.execute(text("""
            SELECT COUNT(*) FILTER (WHERE statut = 'accepte') AS acceptes,
                   COUNT(*) AS total
            FROM devis
        """))
        row = result.fetchone()
        assert row[1] > 0

    def test_saisonnalite(self, connection):
        result = connection.execute(text("""
            SELECT TO_CHAR(date_debut, 'YYYY-MM') AS mois, COUNT(*)
            FROM projets WHERE date_debut IS NOT NULL
            GROUP BY TO_CHAR(date_debut, 'YYYY-MM')
        """))
        rows = result.fetchall()
        assert len(rows) > 0
