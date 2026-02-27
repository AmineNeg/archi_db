"""Dashboard terminal avec stats temps reel."""

from datetime import date as dt_date
from decimal import Decimal

from rich.console import Console
from rich.columns import Columns
from rich.panel import Panel
from rich.table import Table
from rich.text import Text

from src.db import get_session
from src.models import (
    Architecte,
    Client,
    Devis,
    Facture,
    PhaseProjet,
    Projet,
    SuiviHeures,
)

console = Console()


def _stat_panel(title: str, value: str, color: str = "cyan") -> Panel:
    """Cree un petit panel de statistique."""
    content = Text(value, style=f"bold {color}", justify="center")
    return Panel(content, title=f"[bold]{title}[/bold]", border_style=color, width=28)


def render_dashboard():
    """Affiche le dashboard complet."""
    with get_session() as session:
        # --- Stats globales ---
        nb_projets_actifs = (
            session.query(Projet)
            .filter(Projet.statut.notin_(["clos", "prospect"]))
            .count()
        )
        nb_prospects = (
            session.query(Projet)
            .filter(Projet.statut == "prospect")
            .count()
        )
        nb_clients = session.query(Client).count()
        nb_architectes = (
            session.query(Architecte)
            .filter(Architecte.statut == "actif")
            .count()
        )

        # CA encaisse
        ca_result = (
            session.query(Facture)
            .filter(Facture.statut == "payee")
            .all()
        )
        ca_encaisse = sum(f.montant_ht for f in ca_result)

        # Factures en attente
        factures_attente = (
            session.query(Facture)
            .filter(Facture.statut.in_(["envoyee", "en_retard"]))
            .all()
        )
        montant_attente = sum(f.montant_ttc for f in factures_attente)

        # Projets en retard
        projets_retard = (
            session.query(Projet)
            .filter(
                Projet.date_fin_prevue < dt_date.today(),
                Projet.statut.notin_(["reception", "clos"]),
                Projet.date_fin_reelle.is_(None),
            )
            .count()
        )

        # Heures totales
        heures_total = sum(
            h.nb_heures for h in session.query(SuiviHeures).all()
        )

        # --- Header ---
        console.print()
        console.print(
            Panel(
                "[bold white]CABINET D'ARCHITECTURE — TABLEAU DE BORD[/bold white]",
                border_style="bright_blue",
                padding=(0, 2),
            )
        )

        # --- KPI Cards ---
        panels = [
            _stat_panel("Projets actifs", str(nb_projets_actifs), "blue"),
            _stat_panel("Prospects", str(nb_prospects), "yellow"),
            _stat_panel("Clients", str(nb_clients), "green"),
            _stat_panel("Architectes", str(nb_architectes), "cyan"),
        ]
        console.print(Columns(panels, equal=True, padding=(0, 1)))

        panels2 = [
            _stat_panel("CA encaisse HT", f"{ca_encaisse:,.0f} EUR", "green"),
            _stat_panel("Factures en attente", f"{montant_attente:,.0f} EUR TTC", "yellow"),
            _stat_panel("Projets en retard", str(projets_retard), "red" if projets_retard else "green"),
            _stat_panel("Heures totales", f"{heures_total:,.0f} h", "cyan"),
        ]
        console.print(Columns(panels2, equal=True, padding=(0, 1)))

        # --- Projets actifs ---
        console.print()
        projets_table = Table(
            title="Projets en cours",
            show_header=True,
            header_style="bold white on dark_blue",
            border_style="blue",
            width=110,
        )
        projets_table.add_column("Ref", width=16)
        projets_table.add_column("Projet", width=30)
        projets_table.add_column("Client", width=20)
        projets_table.add_column("Statut", width=16)
        projets_table.add_column("Budget HT", justify="right", width=14)
        projets_table.add_column("Avancement", justify="right", width=12)

        projets_actifs = (
            session.query(Projet)
            .filter(Projet.statut.notin_(["clos", "prospect"]))
            .order_by(Projet.ref_projet)
            .all()
        )

        STATUT_COLORS = {
            "etude": "cyan",
            "permis_depose": "yellow",
            "permis_accorde": "green",
            "chantier": "bold blue",
            "reception": "bold magenta",
        }

        for p in projets_actifs:
            client = session.query(Client).get(p.client_id)
            phases = (
                session.query(PhaseProjet)
                .filter(PhaseProjet.projet_id == p.id)
                .all()
            )
            avg_avancement = (
                sum(ph.pct_avancement for ph in phases) // len(phases)
                if phases else 0
            )
            color = STATUT_COLORS.get(p.statut, "white")

            bar_len = avg_avancement // 5
            bar = "[green]" + "█" * bar_len + "[/green]" + "░" * (20 - bar_len)

            projets_table.add_row(
                p.ref_projet,
                p.nom_projet[:28],
                (client.raison_sociale[:18] if client else "-"),
                f"[{color}]{p.statut}[/{color}]",
                f"{p.budget_estime_ht:,.0f} EUR" if p.budget_estime_ht else "-",
                f"{bar} {avg_avancement}%",
            )

        console.print(projets_table)

        # --- Alertes ---
        console.print()
        alertes_panel_content = []

        projets_en_retard = (
            session.query(Projet)
            .filter(
                Projet.date_fin_prevue < dt_date.today(),
                Projet.statut.notin_(["reception", "clos"]),
                Projet.date_fin_reelle.is_(None),
            )
            .all()
        )
        for p in projets_en_retard:
            jours = (dt_date.today() - p.date_fin_prevue).days
            alertes_panel_content.append(
                f"[red]![/red] {p.ref_projet} en retard de [bold]{jours}j[/bold]"
            )

        for f in factures_attente:
            if f.date_echeance and f.date_echeance < dt_date.today():
                jours = (dt_date.today() - f.date_echeance).days
                alertes_panel_content.append(
                    f"[yellow]$[/yellow] {f.ref_facture} impayee depuis [bold]{jours}j[/bold] "
                    f"({f.montant_ttc:,.0f} EUR)"
                )

        if alertes_panel_content:
            console.print(
                Panel(
                    "\n".join(alertes_panel_content),
                    title="[bold red]Alertes[/bold red]",
                    border_style="red",
                )
            )
        else:
            console.print(
                Panel(
                    "[green]Aucune alerte[/green]",
                    title="Alertes",
                    border_style="green",
                )
            )
