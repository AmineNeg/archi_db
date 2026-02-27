# Regles metier — Cabinet d'Architecture

## 1. Gestion des projets

- Chaque projet possede une reference unique au format `ARCH-YYYY-NNN`.
- Un projet est obligatoirement rattache a un client et peut etre assigne a un architecte responsable.
- Le cycle de vie d'un projet suit les statuts : `prospect` → `etude` → `permis_depose` → `permis_accorde` → `chantier` → `reception` → `clos`.
- La date de fin prevue doit etre superieure ou egale a la date de debut.
- Le budget estime HT et les honoraires doivent etre positifs ou nuls.
- Le taux d'honoraires est compris entre 0% et 100% (generalement entre 8% et 15% selon le type de projet).

## 2. Phases de projet

- Chaque projet peut avoir jusqu'a 9 phases standard de la loi MOP : ESQ, APS, APD, PRO, DCE, ACT, VISA, DET, AOR.
- Un projet ne peut pas avoir deux fois la meme phase (contrainte d'unicite).
- L'avancement d'une phase est compris entre 0% et 100%.
- Quand toutes les phases d'un projet sont validees, le statut du projet passe automatiquement a `reception` (trigger).

## 3. Devis et facturation

- Un devis est lie a un projet et a un client.
- Le montant TTC doit etre superieur ou egal au montant HT.
- Les statuts d'un devis sont : `brouillon` → `envoye` → `accepte` | `refuse` | `expire`.
- Une facture peut etre liee a un devis (optionnel).
- Les factures dont la date d'echeance est depassee passent automatiquement en statut `en_retard` (trigger).

## 4. Suivi des heures

- Un architecte saisit ses heures sur un projet, avec une description et une phase optionnelle.
- Le nombre d'heures par saisie est compris entre 0 et 24 (exclusif).
- Quand le cout reel en heures depasse 80% des honoraires, une alerte est generee dans l'audit log (trigger).

## 5. Lots et entreprises

- Chaque lot de travaux est attribue a une entreprise.
- Le montant du marche doit etre positif ou nul.
- Le cycle de vie d'un lot : `consultation` → `attribue` → `en_cours` → `receptionne`.

## 6. Audit

- Toute modification (INSERT, UPDATE, DELETE) sur les tables `projets`, `clients`, `devis` et `factures` est tracee dans la table `audit_log`.
- Les anciennes et nouvelles valeurs sont stockees en JSONB.
- Le champ `updated_at` est automatiquement mis a jour sur toute modification (trigger).

## 7. Calculs metier

- **Rentabilite** = Honoraires HT - (Heures passees x Taux horaire architecte)
- **Taux de conversion** = Devis acceptes / (Devis acceptes + refuses) x 100
- **Taux d'occupation** = Heures saisies sur 30j / (22 jours x 7.5h) x 100
- **Marge nette** = Honoraires HT - Cout reel en heures
