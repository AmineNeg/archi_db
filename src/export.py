"""Export CSV / Excel / PDF des donnees."""

import csv
import os
from pathlib import Path

from rich.console import Console

from src.db import get_session
from src.models import Client, Facture, Projet

console = Console()
EXPORT_DIR = Path("exports")


def _ensure_dir():
    EXPORT_DIR.mkdir(exist_ok=True)


def export_projets_csv(filepath: str = None):
    """Exporte la liste des projets en CSV."""
    _ensure_dir()
    filepath = filepath or str(EXPORT_DIR / "projets.csv")

    with get_session() as session:
        projets = session.query(Projet).order_by(Projet.ref_projet).all()

        with open(filepath, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f, delimiter=";")
            writer.writerow([
                "ref_projet", "nom_projet", "client_id", "type_projet",
                "statut", "surface_m2", "budget_estime_ht", "honoraires_ht",
                "date_debut", "date_fin_prevue", "ville_chantier",
            ])
            for p in projets:
                writer.writerow([
                    p.ref_projet, p.nom_projet, p.client_id, p.type_projet,
                    p.statut, p.surface_m2, p.budget_estime_ht, p.honoraires_ht,
                    p.date_debut, p.date_fin_prevue, p.ville_chantier,
                ])

    console.print(f"[green]Projets exportes :[/green] {filepath}")


def export_factures_csv(filepath: str = None):
    """Exporte la liste des factures en CSV."""
    _ensure_dir()
    filepath = filepath or str(EXPORT_DIR / "factures.csv")

    with get_session() as session:
        factures = session.query(Facture).order_by(Facture.date_emission).all()

        with open(filepath, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f, delimiter=";")
            writer.writerow([
                "ref_facture", "projet_id", "montant_ht", "taux_tva",
                "montant_ttc", "statut", "date_emission", "date_echeance",
                "date_paiement", "mode_paiement",
            ])
            for fac in factures:
                writer.writerow([
                    fac.ref_facture, fac.projet_id, fac.montant_ht,
                    fac.taux_tva, fac.montant_ttc, fac.statut,
                    fac.date_emission, fac.date_echeance,
                    fac.date_paiement, fac.mode_paiement,
                ])

    console.print(f"[green]Factures exportees :[/green] {filepath}")


def export_clients_csv(filepath: str = None):
    """Exporte la liste des clients en CSV."""
    _ensure_dir()
    filepath = filepath or str(EXPORT_DIR / "clients.csv")

    with get_session() as session:
        clients = session.query(Client).order_by(Client.raison_sociale).all()

        with open(filepath, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f, delimiter=";")
            writer.writerow([
                "id", "raison_sociale", "type", "nom_contact",
                "prenom_contact", "email", "telephone", "ville",
                "code_postal", "siret",
            ])
            for c in clients:
                writer.writerow([
                    c.id, c.raison_sociale, c.type, c.nom_contact,
                    c.prenom_contact, c.email, c.telephone, c.ville,
                    c.code_postal, c.siret,
                ])

    console.print(f"[green]Clients exportes :[/green] {filepath}")
