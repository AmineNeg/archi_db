"""CLI interactive avec Rich — Dashboard, recherche, rapports."""

import sys

import click
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.layout import Layout
from rich.text import Text

from src.db import get_session
from src.models import (
    Architecte,
    Client,
    Devis,
    Facture,
    Projet,
    SuiviHeures,
)
from src.dashboard import render_dashboard
from src.export import export_projets_csv, export_factures_csv

console = Console()

STATUT_COLORS = {
    "prospect": "dim",
    "etude": "cyan",
    "permis_depose": "yellow",
    "permis_accorde": "green",
    "chantier": "bold blue",
    "reception": "bold magenta",
    "clos": "dim green",
}

FACTURE_COLORS = {
    "brouillon": "dim",
    "envoyee": "yellow",
    "payee": "green",
    "en_retard": "bold red",
    "annulee": "dim red",
}


@click.group()
def cli():
    """Cabinet d'Architecture — Systeme de gestion."""
    pass


@cli.command()
def dashboard():
    """Affiche le tableau de bord principal."""
    render_dashboard()


@cli.command()
def projets():
    """Liste tous les projets avec couleurs par statut."""
    with get_session() as session:
        all_projets = (
            session.query(Projet)
            .order_by(Projet.ref_projet)
            .all()
        )

        table = Table(
            title="Projets du Cabinet",
            show_header=True,
            header_style="bold white on dark_blue",
            border_style="blue",
        )
        table.add_column("Ref", style="bold", width=16)
        table.add_column("Nom du projet", width=35)
        table.add_column("Type", width=14)
        table.add_column("Statut", width=16)
        table.add_column("Surface", justify="right", width=10)
        table.add_column("Budget HT", justify="right", width=14)
        table.add_column("Honoraires", justify="right", width=12)

        for p in all_projets:
            color = STATUT_COLORS.get(p.statut, "white")
            table.add_row(
                p.ref_projet,
                p.nom_projet[:33],
                str(p.type_projet),
                f"[{color}]{p.statut}[/{color}]",
                f"{p.surface_m2:,.0f} m2" if p.surface_m2 else "-",
                f"{p.budget_estime_ht:,.0f} EUR" if p.budget_estime_ht else "-",
                f"{p.honoraires_ht:,.0f} EUR" if p.honoraires_ht else "-",
            )

        console.print(table)
        console.print(f"\n[bold]{len(all_projets)}[/bold] projets au total")


@cli.command()
def clients():
    """Liste tous les clients."""
    with get_session() as session:
        all_clients = (
            session.query(Client)
            .order_by(Client.raison_sociale)
            .all()
        )

        table = Table(
            title="Clients du Cabinet",
            show_header=True,
            header_style="bold white on dark_green",
            border_style="green",
        )
        table.add_column("ID", width=4)
        table.add_column("Raison sociale", width=35)
        table.add_column("Type", width=14)
        table.add_column("Contact", width=25)
        table.add_column("Ville", width=18)
        table.add_column("Email", width=30)

        for c in all_clients:
            contact = f"{c.prenom_contact or ''} {c.nom_contact or ''}".strip()
            table.add_row(
                str(c.id),
                c.raison_sociale[:33],
                str(c.type),
                contact,
                c.ville or "-",
                c.email or "-",
            )

        console.print(table)
        console.print(f"\n[bold]{len(all_clients)}[/bold] clients au total")


@cli.command()
def factures():
    """Liste les factures avec statut colore."""
    with get_session() as session:
        all_factures = (
            session.query(Facture)
            .order_by(Facture.date_emission.desc())
            .all()
        )

        table = Table(
            title="Factures",
            show_header=True,
            header_style="bold white on dark_red",
            border_style="red",
        )
        table.add_column("Ref", width=16)
        table.add_column("Projet", width=16)
        table.add_column("Montant HT", justify="right", width=14)
        table.add_column("TTC", justify="right", width=14)
        table.add_column("Statut", width=12)
        table.add_column("Emission", width=12)
        table.add_column("Echeance", width=12)

        for f in all_factures:
            color = FACTURE_COLORS.get(f.statut, "white")
            projet = session.query(Projet).get(f.projet_id)
            table.add_row(
                f.ref_facture,
                projet.ref_projet if projet else "-",
                f"{f.montant_ht:,.0f} EUR",
                f"{f.montant_ttc:,.0f} EUR",
                f"[{color}]{f.statut}[/{color}]",
                str(f.date_emission) if f.date_emission else "-",
                str(f.date_echeance) if f.date_echeance else "-",
            )

        console.print(table)

        total_impaye = sum(
            f.montant_ttc for f in all_factures
            if f.statut in ("envoyee", "en_retard")
        )
        console.print(f"\n[bold]{len(all_factures)}[/bold] factures | "
                       f"[bold red]Impaye: {total_impaye:,.0f} EUR TTC[/bold red]")


@cli.command()
def alertes():
    """Affiche les alertes : retards, impayees, depassements."""
    from datetime import date as dt_date

    with get_session() as session:
        console.print(Panel("[bold red]ALERTES[/bold red]", border_style="red"))

        # Projets en retard
        projets_retard = (
            session.query(Projet)
            .filter(
                Projet.date_fin_prevue < dt_date.today(),
                Projet.statut.notin_(["reception", "clos"]),
                Projet.date_fin_reelle.is_(None),
            )
            .all()
        )
        if projets_retard:
            console.print("\n[bold red]Projets en retard :[/bold red]")
            for p in projets_retard:
                jours = (dt_date.today() - p.date_fin_prevue).days
                console.print(f"  [red]![/red] {p.ref_projet} — {p.nom_projet} "
                               f"([bold]{jours}j[/bold] de retard)")
        else:
            console.print("\n[green]Aucun projet en retard[/green]")

        # Factures impayees
        factures_impayees = (
            session.query(Facture)
            .filter(Facture.statut.in_(["envoyee", "en_retard"]))
            .all()
        )
        if factures_impayees:
            console.print("\n[bold yellow]Factures impayees :[/bold yellow]")
            for f in factures_impayees:
                jours = (dt_date.today() - f.date_echeance).days if f.date_echeance else 0
                projet = session.query(Projet).get(f.projet_id)
                status = "[red]EN RETARD[/red]" if jours > 0 else "[yellow]A echeance[/yellow]"
                console.print(
                    f"  [yellow]$[/yellow] {f.ref_facture} — "
                    f"{f.montant_ttc:,.0f} EUR — {projet.ref_projet if projet else '?'} "
                    f"— {status} ({jours}j)"
                )
        else:
            console.print("\n[green]Aucune facture impayee[/green]")


@cli.command()
@click.argument("format", type=click.Choice(["csv"]), default="csv")
def export(format):
    """Exporte les donnees (csv)."""
    export_projets_csv()
    export_factures_csv()
    console.print("[green]Export termine dans exports/[/green]")


if __name__ == "__main__":
    cli()
