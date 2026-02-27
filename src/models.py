"""ORM SQLAlchemy — Miroir du schema SQL."""

from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import (
    Column,
    Date,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
    func,
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import DeclarativeBase, relationship


class Base(DeclarativeBase):
    pass


class Architecte(Base):
    __tablename__ = "architectes"

    id = Column(Integer, primary_key=True)
    nom = Column(String(100), nullable=False)
    prenom = Column(String(100), nullable=False)
    email = Column(String(255), nullable=False, unique=True)
    telephone = Column(String(20))
    specialite = Column(String(150))
    numero_ordre = Column(String(30), unique=True)
    date_inscription_ordre = Column(Date)
    taux_horaire = Column(Numeric(8, 2), nullable=False, default=Decimal("85.00"))
    statut = Column(String(10), nullable=False, default="actif")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projets = relationship("Projet", back_populates="architecte_responsable")
    heures = relationship("SuiviHeures", back_populates="architecte")


class Client(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True)
    raison_sociale = Column(String(255), nullable=False)
    type = Column(String(20), nullable=False, default="particulier")
    nom_contact = Column(String(100))
    prenom_contact = Column(String(100))
    email = Column(String(255))
    telephone = Column(String(20))
    adresse = Column(String(255))
    ville = Column(String(100))
    code_postal = Column(String(10))
    siret = Column(String(17))
    date_creation = Column(Date, default=date.today)
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projets = relationship("Projet", back_populates="client")
    devis = relationship("Devis", back_populates="client")


class Projet(Base):
    __tablename__ = "projets"

    id = Column(Integer, primary_key=True)
    ref_projet = Column(String(20), nullable=False, unique=True)
    nom_projet = Column(String(255), nullable=False)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)
    type_projet = Column(String(30), nullable=False)
    description = Column(Text)
    adresse_chantier = Column(String(255))
    ville_chantier = Column(String(100))
    surface_m2 = Column(Numeric(10, 2))
    nb_lots = Column(Integer, default=0)
    budget_estime_ht = Column(Numeric(14, 2))
    honoraires_ht = Column(Numeric(12, 2))
    taux_honoraires_pct = Column(Numeric(5, 2))
    statut = Column(String(20), nullable=False, default="prospect")
    date_debut = Column(Date)
    date_fin_prevue = Column(Date)
    date_fin_reelle = Column(Date)
    architecte_responsable_id = Column(Integer, ForeignKey("architectes.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    client = relationship("Client", back_populates="projets")
    architecte_responsable = relationship("Architecte", back_populates="projets")
    phases = relationship("PhaseProjet", back_populates="projet")
    documents = relationship("Document", back_populates="projet")
    devis = relationship("Devis", back_populates="projet")
    factures = relationship("Facture", back_populates="projet")
    reunions = relationship("ReunionChantier", back_populates="projet")
    lots = relationship("LotEntreprise", back_populates="projet")
    heures = relationship("SuiviHeures", back_populates="projet")


class PhaseProjet(Base):
    __tablename__ = "phases_projet"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    phase = Column(String(10), nullable=False)
    statut = Column(String(15), nullable=False, default="a_faire")
    date_debut = Column(Date)
    date_fin_prevue = Column(Date)
    date_fin_reelle = Column(Date)
    honoraires_phase_ht = Column(Numeric(12, 2), default=Decimal("0"))
    pct_avancement = Column(Integer, default=0)
    commentaires = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="phases")


class Document(Base):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    phase_id = Column(Integer, ForeignKey("phases_projet.id"))
    type_document = Column(String(20), nullable=False)
    nom_fichier = Column(String(500), nullable=False)
    version = Column(Integer, nullable=False, default=1)
    chemin_fichier = Column(String(1000), nullable=False)
    uploaded_by = Column(Integer, ForeignKey("architectes.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="documents")


class Devis(Base):
    __tablename__ = "devis"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    client_id = Column(Integer, ForeignKey("clients.id"), nullable=False)
    ref_devis = Column(String(30), nullable=False, unique=True)
    montant_ht = Column(Numeric(14, 2), nullable=False)
    taux_tva = Column(Numeric(5, 2), nullable=False, default=Decimal("20.00"))
    montant_ttc = Column(Numeric(14, 2), nullable=False)
    statut = Column(String(15), nullable=False, default="brouillon")
    date_emission = Column(Date, default=date.today)
    date_validite = Column(Date)
    conditions_paiement = Column(Text)
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="devis")
    client = relationship("Client", back_populates="devis")
    factures = relationship("Facture", back_populates="devis")


class Facture(Base):
    __tablename__ = "factures"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    devis_id = Column(Integer, ForeignKey("devis.id"))
    ref_facture = Column(String(30), nullable=False, unique=True)
    montant_ht = Column(Numeric(14, 2), nullable=False)
    taux_tva = Column(Numeric(5, 2), nullable=False, default=Decimal("20.00"))
    montant_ttc = Column(Numeric(14, 2), nullable=False)
    statut = Column(String(15), nullable=False, default="brouillon")
    date_emission = Column(Date, default=date.today)
    date_echeance = Column(Date)
    date_paiement = Column(Date)
    mode_paiement = Column(String(50))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="factures")
    devis = relationship("Devis", back_populates="factures")


class ReunionChantier(Base):
    __tablename__ = "reunions_chantier"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    date_reunion = Column(Date, nullable=False)
    lieu = Column(String(255))
    participants = Column(Text)
    ordre_du_jour = Column(Text)
    compte_rendu = Column(Text)
    prochaine_reunion = Column(Date)
    actions_a_suivre = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="reunions")


class LotEntreprise(Base):
    __tablename__ = "lots_entreprises"

    id = Column(Integer, primary_key=True)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    lot = Column(String(20), nullable=False)
    entreprise_nom = Column(String(255), nullable=False)
    entreprise_siret = Column(String(17))
    montant_marche_ht = Column(Numeric(14, 2))
    statut = Column(String(20), nullable=False, default="consultation")
    date_debut = Column(Date)
    date_fin = Column(Date)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

    projet = relationship("Projet", back_populates="lots")


class SuiviHeures(Base):
    __tablename__ = "suivi_heures"

    id = Column(Integer, primary_key=True)
    architecte_id = Column(Integer, ForeignKey("architectes.id"), nullable=False)
    projet_id = Column(Integer, ForeignKey("projets.id"), nullable=False)
    date = Column(Date, nullable=False)
    nb_heures = Column(Numeric(5, 2), nullable=False)
    description_tache = Column(String(500))
    phase_id = Column(Integer, ForeignKey("phases_projet.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    architecte = relationship("Architecte", back_populates="heures")
    projet = relationship("Projet", back_populates="heures")


class AuditLog(Base):
    __tablename__ = "audit_log"

    id = Column(Integer, primary_key=True)
    table_name = Column(String(100), nullable=False)
    record_id = Column(Integer, nullable=False)
    action = Column(String(10), nullable=False)
    old_values = Column(JSONB)
    new_values = Column(JSONB)
    user_info = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
