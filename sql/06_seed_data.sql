-- ============================================================================
-- CABINET D'ARCHITECTURE — DONNEES SEED
-- ============================================================================
-- Fichier  : 06_seed_data.sql
-- Objet    : Donnees realistes d'un cabinet d'architecture parisien
-- Version  : 1.0
-- ============================================================================

-- ============================================================================
-- ARCHITECTES (5)
-- ============================================================================
INSERT INTO architectes (id, nom, prenom, email, telephone, specialite, numero_ordre, date_inscription_ordre, taux_horaire, statut) VALUES
(1, 'Moreau',    'Antoine',   'a.moreau@atelier-moreau.fr',    '06 12 34 56 78', 'Logements collectifs',     'IDF-12345', '2008-03-15', 95.00,  'actif'),
(2, 'Lefebvre',  'Camille',   'c.lefebvre@atelier-moreau.fr',  '06 23 45 67 89', 'Renovation patrimoine',    'IDF-23456', '2012-09-01', 90.00,  'actif'),
(3, 'Dupont',    'Julien',    'j.dupont@atelier-moreau.fr',    '06 34 56 78 90', 'Equipements publics',      'IDF-34567', '2015-06-20', 85.00,  'actif'),
(4, 'Bernard',   'Sophie',    's.bernard@atelier-moreau.fr',   '06 45 67 89 01', 'Amenagement interieur',    'IDF-45678', '2018-01-10', 80.00,  'actif'),
(5, 'Petit',     'Maxime',    'm.petit@atelier-moreau.fr',     '06 56 78 90 12', 'Urbanisme et paysage',     'IDF-56789', '2020-11-05', 75.00,  'actif');

SELECT setval('architectes_id_seq', 5);

-- ============================================================================
-- CLIENTS (18)
-- ============================================================================
INSERT INTO clients (id, raison_sociale, type, nom_contact, prenom_contact, email, telephone, adresse, ville, code_postal, siret, notes) VALUES
(1,  'Bouygues Immobilier',            'promoteur',     'Martin',      'Philippe',   'p.martin@bouygues-immo.fr',       '01 40 12 34 56', '3 Boulevard Gallieni',           'Issy-les-Moulineaux', '92130', '57213015200018', 'Client historique, gros volumes'),
(2,  'Nexity Residences',              'promoteur',     'Garnier',     'Isabelle',   'i.garnier@nexity.fr',             '01 41 23 45 67', '19 Rue de Vienne',               'Paris',               '75008', '44474859000011', 'Partenariat cadre signe en 2022'),
(3,  'Mairie de Vincennes',            'collectivite',  'Rousseau',    'Jean-Marc',  'jm.rousseau@vincennes.fr',        '01 43 98 76 54', '53 Bis Rue de Fontenay',         'Vincennes',           '94300', '21940080400014', 'Marche public equipement sportif'),
(4,  'SCI Les Terrasses du Parc',      'entreprise',    'Lambert',     'Catherine',  'c.lambert@sci-terrasses.fr',      '01 45 67 89 01', '12 Avenue de la Republique',     'Montreuil',           '93100', '82345678900015', NULL),
(5,  'Mairie du 11e Arrondissement',   'collectivite',  'Dubois',      'Francois',   'f.dubois@paris.fr',               '01 53 36 11 00', '12 Place Leon Blum',             'Paris',               '75011', '21750001600017', 'Renovation ecole maternelle'),
(6,  'M. et Mme Fontaine',            'particulier',   'Fontaine',    'Laurent',    'l.fontaine@gmail.com',            '06 78 90 12 34', '45 Rue des Acacias',             'Saint-Mande',         '94160', NULL,             'Extension maison individuelle'),
(7,  'Groupe Altarea Cogedim',         'promoteur',     'Mercier',     'Nathalie',   'n.mercier@altarea.com',           '01 56 78 90 12', '87 Rue de Richelieu',            'Paris',               '75002', '33507063700019', 'Programme neuf Ivry'),
(8,  'SCI du Marais',                  'entreprise',    'Chevalier',   'Pierre',     'p.chevalier@sci-marais.fr',       '01 42 77 88 99', '18 Rue des Archives',            'Paris',               '75004', '91234567800016', 'Rehabilitation immeuble haussmannien'),
(9,  'Conseil Regional IDF',          'collectivite',  'Girard',      'Anne',       'a.girard@iledefrance.fr',         '01 53 85 53 85', '2 Rue Simone Veil',              'Saint-Ouen',          '93400', '23750007900018', 'Lycee neuf Creteil'),
(10, 'M. Lefranc',                     'particulier',   'Lefranc',     'Thomas',     't.lefranc@orange.fr',             '06 89 01 23 45', '8 Rue du Chateau',               'Boulogne-Billancourt','92100', NULL,             'Renovation appartement 150m2'),
(11, 'Mairie de Nantes',               'collectivite',  'Morel',       'Sandrine',   's.morel@nantes.fr',               '02 40 41 90 00', '2 Rue de l Hotel de Ville',      'Nantes',              '44000', '21440109300019', 'Mediatheque quartier Bellevue'),
(12, 'Vinci Immobilier',               'promoteur',     'Robert',      'Christophe', 'c.robert@vinci-immo.fr',          '01 47 16 35 00', '61 Avenue Jules Quentin',        'Nanterre',            '92000', '34284843200020', NULL),
(13, 'SCI Rive Gauche',                'entreprise',    'Leroy',       'Marianne',   'm.leroy@sci-rivegauche.fr',       '01 43 26 55 44', '34 Boulevard Saint-Germain',     'Paris',               '75005', '87654321000021', 'Transformation bureaux en logements'),
(14, 'Mme Blanchard',                  'particulier',   'Blanchard',   'Helene',     'h.blanchard@free.fr',             '06 90 12 34 56', '22 Allee des Tilleuls',          'Bordeaux',            '33000', NULL,             'Construction maison contemporaine'),
(15, 'Mairie de Lyon 3e',              'collectivite',  'Perrin',      'Michel',     'm.perrin@lyon.fr',                '04 72 10 30 30', '215 Rue Duguesclin',             'Lyon',                '69003', '21690123800022', 'Rehabilitation salle des fetes'),
(16, 'Icade Promotion',                'promoteur',     'Simon',       'Valerie',    'v.simon@icade.fr',                '01 41 57 70 00', '35 Rue de la Gare',              'Aubervilliers',       '93300', '56789012300023', 'Eco-quartier Marseille'),
(17, 'M. et Mme Nguyen',              'particulier',   'Nguyen',      'David',      'd.nguyen@gmail.com',              '06 01 23 45 67', '15 Rue de la Paix',              'Versailles',          '78000', NULL,             'Amenagement combles + terrasse'),
(18, 'SARL Espaces de Travail',        'entreprise',    'Durand',      'Olivier',    'o.durand@espaces-travail.fr',     '01 55 43 21 00', '120 Avenue de France',           'Paris',               '75013', '43210987600024', 'Amenagement coworking 800m2');

SELECT setval('clients_id_seq', 18);

-- ============================================================================
-- PROJETS (22)
-- ============================================================================
INSERT INTO projets (id, ref_projet, nom_projet, client_id, type_projet, description, adresse_chantier, ville_chantier, surface_m2, nb_lots, budget_estime_ht, honoraires_ht, taux_honoraires_pct, statut, date_debut, date_fin_prevue, date_fin_reelle, architecte_responsable_id) VALUES
(1,  'ARCH-2023-001', 'Residence Les Cerisiers',              1,  'neuf',                  'Programme de 45 logements collectifs R+5 avec parking souterrain',                    '25 Rue des Merisiers',        'Vitry-sur-Seine',    3200.00,  45, 5800000.00,  580000.00,  10.00, 'chantier',       '2023-02-01', '2025-06-30', NULL, 1),
(2,  'ARCH-2023-002', 'Rehabilitation Haussmannien Marais',   8,  'renovation',            'Rehabilitation complete d un immeuble haussmannien de 6 etages, ravalement et restructuration',  '18 Rue des Archives',  'Paris',              1800.00,  12, 2400000.00,  312000.00,  13.00, 'chantier',       '2023-04-15', '2025-03-31', NULL, 2),
(3,  'ARCH-2023-003', 'Ecole Maternelle Jules Ferry',         5,  'renovation',            'Renovation thermique et mise aux normes accessibilite',                                '45 Rue Mercoeur',             'Paris',              850.00,   0,  1200000.00,  144000.00,  12.00, 'permis_accorde', '2023-06-01', '2024-12-31', NULL, 3),
(4,  'ARCH-2023-004', 'Extension Villa Fontaine',             6,  'extension',             'Extension de 60m2 en ossature bois avec toiture vegetalisee',                          '45 Rue des Acacias',          'Saint-Mande',        60.00,    0,  180000.00,   25200.00,   14.00, 'reception',      '2023-03-01', '2024-02-28', '2024-03-15', 2),
(5,  'ARCH-2023-005', 'Programme Neuf Ivry Confluence',       7,  'neuf',                  'Programme mixte 120 logements + commerces RDC, demarche BIM',                          '12 Quai de la Gare',          'Ivry-sur-Seine',     8500.00,  120,15000000.00, 1200000.00, 8.00,  'chantier',       '2023-01-15', '2026-03-31', NULL, 1),
(6,  'ARCH-2024-001', 'Bureaux Rive Gauche → Logements',      13, 'renovation',            'Transformation de 2000m2 de bureaux en 24 logements',                                  '34 Boulevard Saint-Germain',  'Paris',              2000.00,  24, 3500000.00,  385000.00,  11.00, 'permis_depose',  '2024-01-10', '2025-12-31', NULL, 1),
(7,  'ARCH-2024-002', 'Lycee Simone Veil',                    9,  'neuf',                  'Construction d un lycee 900 eleves - HQE niveau Excellent',                           'Avenue du General de Gaulle', 'Creteil',            12000.00, 0,  28000000.00, 2240000.00, 8.00,  'etude',          '2024-03-01', '2027-09-01', NULL, 3),
(8,  'ARCH-2024-003', 'Renovation Appartement Lefranc',       10, 'amenagement_interieur', 'Renovation complete appartement 150m2 - style contemporain',                            '8 Rue du Chateau',            'Boulogne-Billancourt', 150.00, 0,  250000.00,   35000.00,   14.00, 'chantier',       '2024-02-15', '2024-09-30', NULL, 4),
(9,  'ARCH-2024-004', 'Mediatheque Bellevue',                 11, 'neuf',                  'Mediatheque de quartier 1200m2 avec espace numerique et auditorium',                    'Place Simone de Beauvoir',    'Nantes',             1200.00,  0,  4200000.00,  462000.00,  11.00, 'permis_depose',  '2024-04-01', '2026-06-30', NULL, 3),
(10, 'ARCH-2024-005', 'Eco-Quartier Les Calanques',           16, 'urbanisme',             'Masterplan eco-quartier 200 logements + equipements, lot paysager',                     'Traverse de la Barasse',      'Marseille',          25000.00, 200,45000000.00, 3150000.00, 7.00,  'etude',          '2024-05-15', '2028-12-31', NULL, 5),
(11, 'ARCH-2024-006', 'Coworking Nation',                     18, 'amenagement_interieur', 'Amenagement d un espace de coworking 800m2 sur 2 niveaux',                            '120 Avenue de France',        'Paris',              800.00,   0,  650000.00,   84500.00,   13.00, 'chantier',       '2024-06-01', '2024-12-15', NULL, 4),
(12, 'ARCH-2024-007', 'Maison Bordeaux Contemporaine',        14, 'neuf',                  'Construction maison individuelle 200m2 - architecture bioclimatique',                    '8 Chemin des Vignes',         'Bordeaux',           200.00,   0,  450000.00,   54000.00,   12.00, 'permis_accorde', '2024-07-01', '2025-10-31', NULL, 2),
(13, 'ARCH-2024-008', 'Rehabilitation Salle des Fetes',       15, 'renovation',            'Rehabilitation et mise aux normes ERP de la salle des fetes du 3e',                     '215 Rue Duguesclin',          'Lyon',               600.00,   0,  1800000.00,  216000.00,  12.00, 'etude',          '2024-08-01', '2026-01-31', NULL, 3),
(14, 'ARCH-2024-009', 'Residence Nexity Bois-Colombe',        2,  'neuf',                  'Programme 60 logements BBC avec jardin partage en coeur d ilot',                       '15 Rue Victor Hugo',          'Bois-Colombes',      4200.00,  60, 9500000.00,  855000.00,  9.00,  'permis_accorde', '2024-02-01', '2026-08-31', NULL, 1),
(15, 'ARCH-2024-010', 'Combles + Terrasse Nguyen',            17, 'extension',             'Amenagement combles 45m2 et creation terrasse tropezienne',                             '15 Rue de la Paix',           'Versailles',         45.00,    0,  120000.00,   18000.00,   15.00, 'chantier',       '2024-09-01', '2025-02-28', NULL, 4),
(16, 'ARCH-2024-011', 'Logements Vinci Charenton',            12, 'neuf',                  'Residence 80 logements avec certification NF Habitat HQE',                              '30 Rue de Paris',             'Charenton-le-Pont',  5600.00,  80, 12000000.00, 1080000.00, 9.00,  'permis_depose',  '2024-10-01', '2027-03-31', NULL, 1),
(17, 'ARCH-2024-012', 'Bureaux SCI Terrasses',                4,  'amenagement_interieur', 'Reamenagement plateaux de bureaux en open space avec salles de reunion',                '12 Avenue de la Republique',  'Montreuil',          450.00,   0,  280000.00,   39200.00,   14.00, 'reception',      '2024-03-15', '2024-08-31', '2024-09-10', 4),
(18, 'ARCH-2024-013', 'Prospect Villa Versailles',            17, 'extension',             'Projet d extension laterale avec piscine couverte',                                    '15 Rue de la Paix',           'Versailles',         80.00,    0,  350000.00,   45500.00,   13.00, 'prospect',       NULL,         NULL,         NULL, 2),
(19, 'ARCH-2024-014', 'Prospect Lofts Pantin',                2,  'renovation',            'Transformation ancienne usine en 30 lofts',                                            '45 Rue Cartier-Bresson',      'Pantin',             3500.00,  30, 6000000.00,  720000.00,  12.00, 'prospect',       NULL,         NULL,         NULL, 1),
(20, 'ARCH-2024-015', 'Residence Les Jardins de Montreuil',   1,  'neuf',                  'Programme 35 logements avec espaces verts et aires de jeux',                            '78 Rue de Paris',             'Montreuil',          2800.00,  35, 5200000.00,  468000.00,  9.00,  'etude',          '2024-11-01', '2027-06-30', NULL, 1),
(21, 'ARCH-2023-006', 'Centre Sportif Municipal Vincennes',   3,  'neuf',                  'Construction gymnase et piscine municipale',                                            '10 Avenue du Chateau',        'Vincennes',          4500.00,  0,  8500000.00,  850000.00,  10.00, 'chantier',       '2023-09-01', '2025-12-31', NULL, 3),
(22, 'ARCH-2024-016', 'Prospect Altarea Bagneux',             7,  'neuf',                  'Programme 90 logements + creche - etude de faisabilite',                               '20 Avenue Henri Barbusse',    'Bagneux',            6200.00,  90, 11000000.00, 880000.00,  8.00,  'prospect',       NULL,         NULL,         NULL, 1);

SELECT setval('projets_id_seq', 22);

-- ============================================================================
-- PHASES PROJET (exemples complets pour les projets actifs)
-- ============================================================================

-- Projet 1 : Residence Les Cerisiers (chantier - avance)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(1, 'ESQ',  'valide',   '2023-02-01', '2023-03-15', '2023-03-10', 29000.00,  100),
(1, 'APS',  'valide',   '2023-03-15', '2023-05-31', '2023-05-25', 58000.00,  100),
(1, 'APD',  'valide',   '2023-06-01', '2023-08-31', '2023-09-05', 87000.00,  100),
(1, 'PRO',  'valide',   '2023-09-10', '2023-12-31', '2024-01-10', 116000.00, 100),
(1, 'DCE',  'valide',   '2024-01-15', '2024-03-31', '2024-03-20', 58000.00,  100),
(1, 'ACT',  'valide',   '2024-04-01', '2024-05-15', '2024-05-10', 29000.00,  100),
(1, 'VISA', 'en_cours', '2024-05-15', '2025-04-30', NULL,         58000.00,  60),
(1, 'DET',  'en_cours', '2024-06-01', '2025-06-30', NULL,         116000.00, 45),
(1, 'AOR',  'a_faire',  NULL,         '2025-06-30', NULL,         29000.00,  0);

-- Projet 2 : Rehabilitation Haussmannien (chantier)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(2, 'ESQ',  'valide',   '2023-04-15', '2023-05-31', '2023-05-28', 15600.00, 100),
(2, 'APS',  'valide',   '2023-06-01', '2023-08-15', '2023-08-10', 31200.00, 100),
(2, 'APD',  'valide',   '2023-08-20', '2023-11-30', '2023-12-05', 46800.00, 100),
(2, 'PRO',  'valide',   '2023-12-10', '2024-03-31', '2024-04-05', 62400.00, 100),
(2, 'DCE',  'valide',   '2024-04-10', '2024-06-30', '2024-06-25', 31200.00, 100),
(2, 'ACT',  'valide',   '2024-07-01', '2024-08-15', '2024-08-12', 15600.00, 100),
(2, 'VISA', 'en_cours', '2024-08-20', '2025-02-28', NULL,         31200.00, 75),
(2, 'DET',  'en_cours', '2024-09-01', '2025-03-31', NULL,         62400.00, 50),
(2, 'AOR',  'a_faire',  NULL,         '2025-03-31', NULL,         15600.00, 0);

-- Projet 5 : Programme Ivry Confluence (chantier - grand projet)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(5, 'ESQ',  'valide',   '2023-01-15', '2023-03-31', '2023-03-28', 60000.00,  100),
(5, 'APS',  'valide',   '2023-04-01', '2023-07-31', '2023-08-05', 120000.00, 100),
(5, 'APD',  'valide',   '2023-08-10', '2023-12-31', '2024-01-15', 180000.00, 100),
(5, 'PRO',  'valide',   '2024-01-20', '2024-06-30', '2024-07-05', 240000.00, 100),
(5, 'DCE',  'valide',   '2024-07-10', '2024-10-31', '2024-10-28', 120000.00, 100),
(5, 'ACT',  'en_cours', '2024-11-01', '2025-01-31', NULL,         60000.00,  80),
(5, 'VISA', 'a_faire',  NULL,         '2025-12-31', NULL,         120000.00, 0),
(5, 'DET',  'a_faire',  NULL,         '2026-03-31', NULL,         240000.00, 0),
(5, 'AOR',  'a_faire',  NULL,         '2026-03-31', NULL,         60000.00,  0);

-- Projet 7 : Lycee Simone Veil (etude)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(7, 'ESQ',  'valide',   '2024-03-01', '2024-05-31', '2024-05-20', 112000.00, 100),
(7, 'APS',  'en_cours', '2024-06-01', '2024-10-31', NULL,         224000.00, 65),
(7, 'APD',  'a_faire',  NULL,         '2025-03-31', NULL,         336000.00, 0),
(7, 'PRO',  'a_faire',  NULL,         '2025-09-30', NULL,         448000.00, 0),
(7, 'DCE',  'a_faire',  NULL,         '2026-03-31', NULL,         224000.00, 0),
(7, 'ACT',  'a_faire',  NULL,         '2026-06-30', NULL,         112000.00, 0),
(7, 'VISA', 'a_faire',  NULL,         '2027-03-31', NULL,         224000.00, 0),
(7, 'DET',  'a_faire',  NULL,         '2027-09-01', NULL,         448000.00, 0),
(7, 'AOR',  'a_faire',  NULL,         '2027-09-01', NULL,         112000.00, 0);

-- Projet 8 : Renovation Lefranc (chantier)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(8, 'ESQ',  'valide',   '2024-02-15', '2024-03-15', '2024-03-12', 3500.00,  100),
(8, 'APS',  'valide',   '2024-03-18', '2024-04-30', '2024-04-28', 5250.00,  100),
(8, 'APD',  'valide',   '2024-05-01', '2024-06-15', '2024-06-12', 7000.00,  100),
(8, 'PRO',  'valide',   '2024-06-15', '2024-07-31', '2024-07-25', 8750.00,  100),
(8, 'DET',  'en_cours', '2024-08-01', '2024-09-30', NULL,         7000.00,  70),
(8, 'AOR',  'a_faire',  NULL,         '2024-09-30', NULL,         3500.00,  0);

-- Projet 11 : Coworking Nation (chantier)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(11, 'ESQ',  'valide',   '2024-06-01', '2024-06-30', '2024-06-28', 8450.00,  100),
(11, 'APS',  'valide',   '2024-07-01', '2024-07-31', '2024-07-30', 12675.00, 100),
(11, 'APD',  'valide',   '2024-08-01', '2024-08-31', '2024-09-02', 16900.00, 100),
(11, 'PRO',  'valide',   '2024-09-05', '2024-10-15', '2024-10-12', 21125.00, 100),
(11, 'DET',  'en_cours', '2024-10-15', '2024-12-15', NULL,         16900.00, 40),
(11, 'AOR',  'a_faire',  NULL,         '2024-12-15', NULL,         8450.00,  0);

-- Projet 14 : Residence Nexity (permis accorde)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(14, 'ESQ',  'valide',   '2024-02-01', '2024-03-31', '2024-03-25', 42750.00,  100),
(14, 'APS',  'valide',   '2024-04-01', '2024-06-30', '2024-06-28', 85500.00,  100),
(14, 'APD',  'valide',   '2024-07-01', '2024-09-30', '2024-09-25', 128250.00, 100),
(14, 'PRO',  'en_cours', '2024-10-01', '2025-02-28', NULL,         171000.00, 35),
(14, 'DCE',  'a_faire',  NULL,         '2025-05-31', NULL,         85500.00,  0),
(14, 'ACT',  'a_faire',  NULL,         '2025-07-31', NULL,         42750.00,  0),
(14, 'VISA', 'a_faire',  NULL,         '2026-04-30', NULL,         85500.00,  0),
(14, 'DET',  'a_faire',  NULL,         '2026-08-31', NULL,         171000.00, 0),
(14, 'AOR',  'a_faire',  NULL,         '2026-08-31', NULL,         42750.00,  0);

-- Projet 21 : Centre Sportif Vincennes (chantier)
INSERT INTO phases_projet (projet_id, phase, statut, date_debut, date_fin_prevue, date_fin_reelle, honoraires_phase_ht, pct_avancement) VALUES
(21, 'ESQ',  'valide',   '2023-09-01', '2023-10-31', '2023-10-28', 42500.00,  100),
(21, 'APS',  'valide',   '2023-11-01', '2024-01-31', '2024-01-25', 85000.00,  100),
(21, 'APD',  'valide',   '2024-02-01', '2024-05-31', '2024-05-28', 127500.00, 100),
(21, 'PRO',  'valide',   '2024-06-01', '2024-09-30', '2024-10-05', 170000.00, 100),
(21, 'DCE',  'valide',   '2024-10-10', '2024-12-31', '2024-12-20', 85000.00,  100),
(21, 'ACT',  'valide',   '2025-01-05', '2025-02-28', '2025-02-25', 42500.00,  100),
(21, 'VISA', 'en_cours', '2025-03-01', '2025-09-30', NULL,         85000.00,  20),
(21, 'DET',  'en_cours', '2025-03-15', '2025-12-31', NULL,         170000.00, 10),
(21, 'AOR',  'a_faire',  NULL,         '2025-12-31', NULL,         42500.00,  0);

-- ============================================================================
-- DEVIS (25)
-- ============================================================================
INSERT INTO devis (id, projet_id, client_id, ref_devis, montant_ht, taux_tva, montant_ttc, statut, date_emission, date_validite, conditions_paiement, notes) VALUES
(1,  1,  1,  'DEV-2023-001', 580000.00,  20.00, 696000.00,  'accepte',   '2023-01-15', '2023-02-15', '30% a la commande, solde echelonne par phase', NULL),
(2,  2,  8,  'DEV-2023-002', 312000.00,  20.00, 374400.00,  'accepte',   '2023-03-20', '2023-04-20', '25% commande, 25% APD, 25% DCE, 25% reception', NULL),
(3,  3,  5,  'DEV-2023-003', 144000.00,  20.00, 172800.00,  'accepte',   '2023-05-10', '2023-06-10', 'Paiement sur situation mensuelle',               'Marche public - reglement 30j'),
(4,  4,  6,  'DEV-2023-004', 25200.00,   10.00, 27720.00,   'accepte',   '2023-02-10', '2023-03-10', '50% commande, 50% reception',                    'TVA 10% renovation'),
(5,  5,  7,  'DEV-2023-005', 1200000.00, 20.00, 1440000.00, 'accepte',   '2022-12-01', '2023-01-15', 'Echelonnement trimestriel sur duree du projet',  NULL),
(6,  6,  13, 'DEV-2024-001', 385000.00,  20.00, 462000.00,  'accepte',   '2023-12-15', '2024-01-15', '30% commande, solde par phase',                  NULL),
(7,  7,  9,  'DEV-2024-002', 2240000.00, 20.00, 2688000.00, 'accepte',   '2024-02-01', '2024-03-01', 'Marche public - situations mensuelles',          'Accord cadre region IDF'),
(8,  8,  10, 'DEV-2024-003', 35000.00,   10.00, 38500.00,   'accepte',   '2024-01-20', '2024-02-20', '40% commande, 30% travaux, 30% reception',       'TVA 10% renovation'),
(9,  9,  11, 'DEV-2024-004', 462000.00,  20.00, 554400.00,  'accepte',   '2024-03-15', '2024-04-15', 'Situations mensuelles - reglement 30j',          NULL),
(10, 10, 16, 'DEV-2024-005', 3150000.00, 20.00, 3780000.00, 'envoye',    '2024-05-01', '2024-06-15', 'A negocier selon planning',                     'En attente validation DG'),
(11, 11, 18, 'DEV-2024-006', 84500.00,   20.00, 101400.00,  'accepte',   '2024-05-15', '2024-06-15', '50% commande, 50% livraison',                   NULL),
(12, 12, 14, 'DEV-2024-007', 54000.00,   20.00, 64800.00,   'accepte',   '2024-06-10', '2024-07-10', '30% commande, 40% hors eau, 30% reception',     NULL),
(13, 13, 15, 'DEV-2024-008', 216000.00,  20.00, 259200.00,  'envoye',    '2024-07-20', '2024-08-20', 'Marche public - paiement 45j',                  NULL),
(14, 14, 2,  'DEV-2024-009', 855000.00,  20.00, 1026000.00, 'accepte',   '2024-01-15', '2024-02-15', 'Echelonnement par phase - trimestriel',          NULL),
(15, 15, 17, 'DEV-2024-010', 18000.00,   10.00, 19800.00,   'accepte',   '2024-08-15', '2024-09-15', '50% commande, 50% reception',                   'TVA 10% renovation'),
(16, 16, 12, 'DEV-2024-011', 1080000.00, 20.00, 1296000.00, 'accepte',   '2024-09-10', '2024-10-10', '20% commande, solde par phase',                 NULL),
(17, 17, 4,  'DEV-2024-012', 39200.00,   20.00, 47040.00,   'accepte',   '2024-03-01', '2024-03-31', '50% commande, 50% livraison',                   NULL),
(18, 18, 17, 'DEV-2024-013', 45500.00,   20.00, 54600.00,   'envoye',    '2024-10-01', '2024-11-01', '30% commande, 70% echelonne',                   'En attente retour client'),
(19, 19, 2,  'DEV-2024-014', 720000.00,  20.00, 864000.00,  'envoye',    '2024-10-15', '2024-11-15', 'A negocier',                                    'Prospect - 1ere approche'),
(20, 20, 1,  'DEV-2024-015', 468000.00,  20.00, 561600.00,  'accepte',   '2024-10-20', '2024-11-20', 'Echelonnement par phase',                       NULL),
(21, 21, 3,  'DEV-2023-006', 850000.00,  20.00, 1020000.00, 'accepte',   '2023-08-01', '2023-09-01', 'Marche public - situations mensuelles',          NULL),
(22, 22, 7,  'DEV-2024-016', 880000.00,  20.00, 1056000.00, 'envoye',    '2024-11-01', '2024-12-01', 'A negocier',                                    'Etude de faisabilite d abord'),
(23, 3,  5,  'DEV-2023-007', 28000.00,   20.00, 33600.00,   'refuse',    '2023-05-01', '2023-06-01', 'Forfait',                                       'V1 refusee - montant trop eleve'),
(24, 8,  10, 'DEV-2024-017', 42000.00,   10.00, 46200.00,   'refuse',    '2024-01-10', '2024-02-10', '3 x 33%',                                       'V1 refusee - perimetre reduit ensuite'),
(25, 11, 18, 'DEV-2024-018', 95000.00,   20.00, 114000.00,  'refuse',    '2024-05-10', '2024-06-10', '50/50',                                         'V1 - revue a la baisse apres nego');

SELECT setval('devis_id_seq', 25);

-- ============================================================================
-- FACTURES (30)
-- ============================================================================
INSERT INTO factures (id, projet_id, devis_id, ref_facture, montant_ht, taux_tva, montant_ttc, statut, date_emission, date_echeance, date_paiement, mode_paiement) VALUES
-- Projet 1 : Residence Les Cerisiers
(1,  1, 1, 'FAC-2023-001', 174000.00, 20.00, 208800.00, 'payee',    '2023-02-15', '2023-03-15', '2023-03-10', 'virement'),
(2,  1, 1, 'FAC-2023-008', 116000.00, 20.00, 139200.00, 'payee',    '2023-06-30', '2023-07-30', '2023-07-25', 'virement'),
(3,  1, 1, 'FAC-2024-001', 116000.00, 20.00, 139200.00, 'payee',    '2024-01-15', '2024-02-15', '2024-02-12', 'virement'),
(4,  1, 1, 'FAC-2024-010', 87000.00,  20.00, 104400.00, 'payee',    '2024-06-30', '2024-07-30', '2024-07-28', 'virement'),
(5,  1, 1, 'FAC-2024-020', 58000.00,  20.00, 69600.00,  'envoyee',  '2024-10-15', '2024-11-15', NULL,         NULL),
-- Projet 2 : Haussmannien
(6,  2, 2, 'FAC-2023-002', 78000.00,  20.00, 93600.00,  'payee',    '2023-05-01', '2023-06-01', '2023-05-28', 'virement'),
(7,  2, 2, 'FAC-2023-009', 78000.00,  20.00, 93600.00,  'payee',    '2023-12-15', '2024-01-15', '2024-01-10', 'virement'),
(8,  2, 2, 'FAC-2024-002', 78000.00,  20.00, 93600.00,  'payee',    '2024-07-01', '2024-08-01', '2024-07-29', 'virement'),
(9,  2, 2, 'FAC-2024-021', 78000.00,  20.00, 93600.00,  'envoyee',  '2024-11-01', '2024-12-01', NULL,         NULL),
-- Projet 4 : Extension Fontaine (clos)
(10, 4, 4, 'FAC-2023-003', 12600.00,  10.00, 13860.00,  'payee',    '2023-03-15', '2023-04-15', '2023-04-10', 'cheque'),
(11, 4, 4, 'FAC-2024-003', 12600.00,  10.00, 13860.00,  'payee',    '2024-03-20', '2024-04-20', '2024-04-15', 'cheque'),
-- Projet 5 : Ivry Confluence
(12, 5, 5, 'FAC-2023-004', 360000.00, 20.00, 432000.00, 'payee',    '2023-04-01', '2023-05-01', '2023-04-28', 'virement'),
(13, 5, 5, 'FAC-2023-010', 240000.00, 20.00, 288000.00, 'payee',    '2023-10-01', '2023-11-01', '2023-10-28', 'virement'),
(14, 5, 5, 'FAC-2024-004', 240000.00, 20.00, 288000.00, 'payee',    '2024-04-01', '2024-05-01', '2024-04-29', 'virement'),
(15, 5, 5, 'FAC-2024-022', 120000.00, 20.00, 144000.00, 'envoyee',  '2024-11-15', '2024-12-15', NULL,         NULL),
-- Projet 7 : Lycee
(16, 7, 7, 'FAC-2024-005', 336000.00, 20.00, 403200.00, 'payee',    '2024-06-01', '2024-07-01', '2024-06-28', 'virement'),
-- Projet 8 : Renovation Lefranc
(17, 8, 8, 'FAC-2024-006', 14000.00,  10.00, 15400.00,  'payee',    '2024-03-01', '2024-04-01', '2024-03-28', 'virement'),
(18, 8, 8, 'FAC-2024-011', 10500.00,  10.00, 11550.00,  'payee',    '2024-07-01', '2024-08-01', '2024-07-30', 'virement'),
(19, 8, 8, 'FAC-2024-023', 10500.00,  10.00, 11550.00,  'envoyee',  '2024-10-01', '2024-11-01', NULL,         NULL),
-- Projet 11 : Coworking
(20, 11, 11, 'FAC-2024-007', 42250.00, 20.00, 50700.00,  'payee',   '2024-06-15', '2024-07-15', '2024-07-10', 'virement'),
(21, 11, 11, 'FAC-2024-024', 42250.00, 20.00, 50700.00,  'envoyee', '2024-11-15', '2024-12-15', NULL,         NULL),
-- Projet 14 : Nexity
(22, 14, 14, 'FAC-2024-008', 256500.00, 20.00, 307800.00, 'payee',  '2024-04-01', '2024-05-01', '2024-04-28', 'virement'),
(23, 14, 14, 'FAC-2024-012', 128250.00, 20.00, 153900.00, 'payee',  '2024-10-01', '2024-11-01', '2024-10-28', 'virement'),
-- Projet 15 : Combles Nguyen
(24, 15, 15, 'FAC-2024-009', 9000.00,  10.00, 9900.00,   'payee',   '2024-09-15', '2024-10-15', '2024-10-10', 'cheque'),
-- Projet 17 : Bureaux SCI Terrasses (clos)
(25, 17, 17, 'FAC-2024-013', 19600.00, 20.00, 23520.00,  'payee',   '2024-03-20', '2024-04-20', '2024-04-15', 'virement'),
(26, 17, 17, 'FAC-2024-014', 19600.00, 20.00, 23520.00,  'payee',   '2024-09-15', '2024-10-15', '2024-10-10', 'virement'),
-- Projet 21 : Centre Sportif Vincennes
(27, 21, 21, 'FAC-2023-005', 255000.00, 20.00, 306000.00, 'payee',  '2023-10-01', '2023-11-01', '2023-10-28', 'virement'),
(28, 21, 21, 'FAC-2024-015', 255000.00, 20.00, 306000.00, 'payee',  '2024-06-01', '2024-07-01', '2024-06-28', 'virement'),
(29, 21, 21, 'FAC-2024-025', 170000.00, 20.00, 204000.00, 'envoyee','2024-11-01', '2024-12-01', NULL,         NULL),
-- Projet 3 : Ecole Jules Ferry
(30, 3, 3, 'FAC-2024-016', 72000.00,  20.00, 86400.00,  'payee',    '2024-01-15', '2024-02-15', '2024-02-12', 'virement');

SELECT setval('factures_id_seq', 30);

-- ============================================================================
-- REUNIONS DE CHANTIER (12)
-- ============================================================================
INSERT INTO reunions_chantier (projet_id, date_reunion, lieu, participants, ordre_du_jour, compte_rendu, prochaine_reunion, actions_a_suivre) VALUES
(1, '2024-10-07', 'Base vie chantier - Vitry-sur-Seine',
   'A. Moreau (archi), P. Martin (Bouygues), J. Duval (OPC), M. Renard (BET structure)',
   '1. Avancement gros oeuvre R+4\n2. Point facades\n3. Lots techniques\n4. Planning previsionnel',
   'Gros oeuvre R+4 acheve, coulage dalle R+5 prevu S43. Facades en cours de pose R+1 a R+3. Electricite et plomberie demarrent R+1.',
   '2024-10-21',
   'Bouygues : fournir planning detaille facades. BET : valider reserves structure R+3.'),

(1, '2024-10-21', 'Base vie chantier - Vitry-sur-Seine',
   'A. Moreau (archi), P. Martin (Bouygues), J. Duval (OPC)',
   '1. Suite gros oeuvre R+5\n2. Avancement facades\n3. Lots CVC',
   'Coffrage R+5 en cours. Facades R+1-R+2 posees. CVC : attente validation plans execution par BET.',
   '2024-11-04',
   'Moreau : VISA plans CVC sous 8j. Bouygues : photo avancement facades.'),

(2, '2024-10-14', 'Sur site - 18 Rue des Archives, Paris 4e',
   'C. Lefebvre (archi), P. Chevalier (MOA), F. Blanc (entreprise generale), L. Tran (BET)',
   '1. Avancement restructuration R+3 a R+5\n2. Ravalement facade sur rue\n3. Menuiseries exterieures',
   'Restructuration R+3 terminee. R+4 en cours, cloisonnement a 60%. Ravalement : echafaudages poses, decapage en cours. Menuiseries livrees semaine prochaine.',
   '2024-10-28',
   'Lefebvre : valider coloris ravalement. Blanc : planning menuiseries.'),

(2, '2024-10-28', 'Sur site - 18 Rue des Archives, Paris 4e',
   'C. Lefebvre (archi), P. Chevalier (MOA), F. Blanc (entreprise generale)',
   '1. Suite ravalement\n2. Point menuiseries\n3. Lots second oeuvre',
   'Ravalement : decapage termine, rebouchage en cours. Menuiseries : pose demarre lundi. Plomberie : alimentation en cours R+1-R+2.',
   '2024-11-12',
   'Blanc : confirmer planning peinture cages escalier.'),

(5, '2024-10-10', 'Bureau de chantier - Quai de la Gare, Ivry',
   'A. Moreau (archi), N. Mercier (Altarea), BET Ingenierie, OPC, 6 entreprises',
   '1. Point general tous lots\n2. Interface structure/facades\n3. Planning phase 2\n4. Budget',
   'Phase 1 (batiment A) : structure achevee, facade en cours. Phase 2 (batiment B) : fondations speciales achevees. Point budget : +2.3% sur previsionnel, principalement fondations speciales.',
   '2024-10-24',
   'Moreau : mise a jour planning general. BET : note fondations batiment C.'),

(8, '2024-09-30', 'Sur site - 8 Rue du Chateau, Boulogne',
   'S. Bernard (archi), T. Lefranc (client), M. Roux (entreprise TCE)',
   '1. Finitions cuisine et SDB\n2. Electricite\n3. Parquet\n4. Peinture',
   'Cuisine installee, raccordements en cours. SDB : faience posee, receveur a installer. Electricite : appareillage en cours. Parquet : pose prevue S42.',
   '2024-10-14',
   'Bernard : choix luminaires avec client. Roux : protection parquet pendant peinture.'),

(11, '2024-11-04', 'Sur site - 120 Avenue de France, Paris 13e',
    'S. Bernard (archi), O. Durand (client), K. Benali (entreprise amenagement)',
    '1. Cloisonnement niveau 1\n2. Reseau electrique\n3. Mobilier sur mesure\n4. Signaletique',
    'Cloisonnement N1 a 80%, salles de reunion definies. Electricite : chemins de cables poses, tirage en cours. Mobilier : fabrication lancee, livraison prevue S48.',
    '2024-11-18',
    'Bernard : valider implantation prises N2. Durand : confirmer signaletique.'),

(21, '2024-11-05', 'Bureau de chantier - Vincennes',
    'J. Dupont (archi), J-M. Rousseau (Mairie), BET structure, BET fluides, entreprises',
    '1. Gros oeuvre piscine\n2. Charpente gymnase\n3. CVC\n4. Planning',
    'Bassin piscine : beton coule, etancheite la semaine prochaine. Gymnase : charpente bois lamelle-colle en cours montage. CVC : centrale traitement air livree.',
    '2024-11-19',
    'Dupont : validation finitions vestiaires. BET fluides : schema hydraulique piscine.'),

(15, '2024-10-21', 'Sur site - 15 Rue de la Paix, Versailles',
    'S. Bernard (archi), D. Nguyen (client), artisan charpente, electricien',
    '1. Charpente et isolation\n2. Velux\n3. Electricite combles\n4. Terrasse',
    'Charpente modifiee et renforcee. Isolation laine de bois posee. 3 Velux sur 4 installes. Terrasse : etancheite en cours.',
    '2024-11-04',
    'Bernard : detail garde-corps terrasse. Electricien : plan eclairage combles.'),

(14, '2024-10-28', 'Bureaux Nexity - Bois-Colombes',
    'A. Moreau (archi), I. Garnier (Nexity), BET, economiste',
    '1. Validation PRO\n2. Estimatif travaux\n3. Planning DCE\n4. Labels et certifications',
    'PRO a 35% davancement. Points en suspens : choix systeme chauffage (PAC vs raccordement reseau chaleur). Estimatif provisoire a 9.2M€ HT, dans lenveloppe.',
    '2024-11-25',
    'Moreau : etude comparative chauffage. Economiste : mise a jour estimatif.'),

(1, '2024-11-04', 'Base vie chantier - Vitry-sur-Seine',
   'A. Moreau (archi), P. Martin (Bouygues), OPC, lots techniques',
   '1. Achevement gros oeuvre\n2. Facades R+3-R+5\n3. Electricite et plomberie\n4. Planning livraison',
   'Dalle R+5 coulee. Toiture terrasse : etancheite semaine prochaine. Facades avancent bien. Lots techniques : retard electricite de 5 jours sur planning.',
   '2024-11-18',
   'OPC : mise a jour planning electricite. Bouygues : note sur etancheite terrasse.'),

(5, '2024-10-24', 'Bureau de chantier - Ivry',
   'A. Moreau (archi), N. Mercier (Altarea), maitrise d oeuvre complete',
   '1. Avancement batiment A\n2. Fondations batiment C\n3. Budget global\n4. Commercialisation',
   'Batiment A : facade a 70%. Batiment B : structure en cours R+2. Batiment C : etude de sol complementaire necessaire. Budget reajuste a +3.1%. Commercialisation : 65% des lots vendus.',
   '2024-11-07',
   'Moreau : adaptation fondations batiment C. Altarea : point commercialisation detaille.');

-- ============================================================================
-- LOTS ENTREPRISES (35+)
-- ============================================================================
INSERT INTO lots_entreprises (projet_id, lot, entreprise_nom, entreprise_siret, montant_marche_ht, statut, date_debut, date_fin) VALUES
-- Projet 1 : Residence Les Cerisiers
(1, 'gros_oeuvre',  'Eiffage Construction',       '32950072100019', 2200000.00, 'en_cours',     '2023-09-01', '2025-03-31'),
(1, 'charpente',    'Charpentes de France SAS',    '45678912300020', 180000.00,  'en_cours',     '2024-08-01', '2025-01-31'),
(1, 'couverture',   'SMAC Etancheite',             '56789012300021', 320000.00,  'en_cours',     '2024-09-01', '2025-02-28'),
(1, 'menuiserie',   'Menuiseries Girard',          '67890123400022', 450000.00,  'attribue',     '2024-11-01', '2025-04-30'),
(1, 'plomberie',    'Engie Solutions',              '34567890100023', 380000.00,  'en_cours',     '2024-06-01', '2025-05-31'),
(1, 'electricite',  'Ineo Infracom',                '45678901200024', 520000.00,  'en_cours',     '2024-06-01', '2025-05-31'),
(1, 'peinture',     'Peintures Gauthier SARL',      '78901234500025', 280000.00,  'consultation', NULL,         NULL),
-- Projet 2 : Haussmannien
(2, 'gros_oeuvre',  'Demathieu Bard',               '12345678900026', 850000.00,  'en_cours',     '2024-03-01', '2025-01-31'),
(2, 'menuiserie',   'Ateliers Perrault',            '23456789000027', 320000.00,  'en_cours',     '2024-07-01', '2025-02-28'),
(2, 'plomberie',    'Brossette Pro',                '34567890100028', 180000.00,  'en_cours',     '2024-05-01', '2025-03-31'),
(2, 'electricite',  'Clemessy',                     '45678901200029', 210000.00,  'en_cours',     '2024-05-01', '2025-03-31'),
(2, 'peinture',     'Zolpan Pro',                   '56789012300030', 150000.00,  'attribue',     '2024-12-01', '2025-03-31'),
-- Projet 5 : Ivry Confluence
(5, 'gros_oeuvre',  'Bouygues Batiment IDF',        '67890123400031', 5500000.00, 'en_cours',     '2023-06-01', '2025-06-30'),
(5, 'charpente',    'Arbonis',                      '78901234500032', 800000.00,  'en_cours',     '2024-09-01', '2025-12-31'),
(5, 'electricite',  'Spie Batignolles',             '89012345600033', 1200000.00, 'en_cours',     '2024-03-01', '2026-01-31'),
(5, 'plomberie',    'Axima GDF Suez',               '90123456700034', 980000.00,  'en_cours',     '2024-03-01', '2026-01-31'),
(5, 'vrd',          'Colas IDF',                    '01234567800035', 1800000.00, 'en_cours',     '2023-04-01', '2025-12-31'),
-- Projet 8 : Renovation Lefranc
(8, 'plomberie',    'SAS Dupont Plomberie',         '12345678900036', 45000.00,   'en_cours',     '2024-07-01', '2024-09-30'),
(8, 'electricite',  'Electricite Martin',           '23456789000037', 35000.00,   'en_cours',     '2024-07-01', '2024-09-30'),
(8, 'peinture',     'Leroy Peinture',               '34567890100038', 28000.00,   'attribue',     '2024-09-15', '2024-10-31'),
(8, 'menuiserie',   'Menuiserie Artisan Bois',      '45678901200039', 52000.00,   'en_cours',     '2024-06-15', '2024-09-15'),
(8, 'carrelage',    'Carrelages Parisiens',         '56789012300040', 18000.00,   'en_cours',     '2024-08-01', '2024-09-30'),
-- Projet 11 : Coworking
(11, 'cloisons',    'Placo Solutions',              '67890123400041', 85000.00,   'en_cours',     '2024-09-15', '2024-11-15'),
(11, 'electricite', 'SNEF',                         '78901234500042', 120000.00,  'en_cours',     '2024-09-01', '2024-12-15'),
(11, 'peinture',    'Tollens Pro',                  '89012345600043', 45000.00,   'attribue',     '2024-11-15', '2024-12-15'),
-- Projet 21 : Centre Sportif
(21, 'gros_oeuvre', 'Vinci Construction',           '90123456700044', 3200000.00, 'en_cours',     '2024-01-15', '2025-06-30'),
(21, 'charpente',   'Mathis Bois Lamelle',          '01234567800045', 650000.00,  'en_cours',     '2024-09-01', '2025-03-31'),
(21, 'cvc',         'Dalkia',                       '12345678900046', 890000.00,  'en_cours',     '2024-06-01', '2025-09-30'),
(21, 'etancheite',  'Siplast SAS',                  '23456789000047', 280000.00,  'en_cours',     '2024-10-01', '2025-04-30'),
(21, 'carrelage',   'Porcelanosa Pro',              '34567890100048', 180000.00,  'consultation', NULL,         NULL),
-- Projet 14 : Nexity Bois-Colombes
(14, 'gros_oeuvre', 'GTM Batiment',                 '45678901200049', 3800000.00, 'consultation', NULL,         NULL),
(14, 'electricite', 'Ineo Tertiaire',               '56789012300050', 750000.00,  'consultation', NULL,         NULL),
-- Projet 15 : Combles Nguyen
(15, 'charpente',   'Charpentier Artisan',          '67890123400051', 28000.00,   'en_cours',     '2024-09-15', '2024-11-15'),
(15, 'couverture',  'Couverture Mansart',           '78901234500052', 15000.00,   'en_cours',     '2024-10-01', '2024-11-30'),
(15, 'electricite', 'Elec Home',                    '89012345600053', 12000.00,   'en_cours',     '2024-10-15', '2024-12-31');

-- ============================================================================
-- SUIVI DES HEURES (6 mois - sept 2024 a fev 2025)
-- ============================================================================
INSERT INTO suivi_heures (architecte_id, projet_id, date, nb_heures, description_tache, phase_id) VALUES
-- Septembre 2024
(1, 1,  '2024-09-02', 6.00, 'Revue plans execution lot CVC',          NULL),
(1, 1,  '2024-09-05', 7.00, 'Reunion chantier + CR',                  NULL),
(1, 1,  '2024-09-09', 5.00, 'VISA plans electricite bat A',           NULL),
(1, 5,  '2024-09-03', 8.00, 'Coordination BIM lots techniques',       NULL),
(1, 5,  '2024-09-10', 6.00, 'Reunion MOA point avancement',           NULL),
(1, 5,  '2024-09-16', 7.00, 'Revue DCE lot facades',                  NULL),
(1, 6,  '2024-09-04', 4.00, 'Montage dossier permis',                 NULL),
(1, 14, '2024-09-11', 6.00, 'Etude PRO - plans niveaux courants',     NULL),
(1, 14, '2024-09-18', 5.00, 'Point economies avec BET',               NULL),
(2, 2,  '2024-09-02', 7.00, 'Suivi chantier ravalement',              NULL),
(2, 2,  '2024-09-06', 5.00, 'Validation echantillons menuiseries',    NULL),
(2, 2,  '2024-09-12', 6.00, 'Reunion chantier hebdo',                 NULL),
(2, 12, '2024-09-03', 4.00, 'Mise au point plans permis',             NULL),
(2, 12, '2024-09-09', 5.00, 'Etude insertion paysagere',              NULL),
(3, 7,  '2024-09-02', 8.00, 'APS - plans masse et volumetrie',        NULL),
(3, 7,  '2024-09-05', 7.00, 'Reunion region IDF - point programme',   NULL),
(3, 7,  '2024-09-11', 6.00, 'Etude structure avec BET',               NULL),
(3, 21, '2024-09-04', 6.00, 'Suivi chantier piscine',                 NULL),
(3, 21, '2024-09-09', 5.00, 'VISA plans CVC gymnase',                 NULL),
(3, 9,  '2024-09-06', 4.00, 'Montage dossier PC mediatheque',         NULL),
(4, 8,  '2024-09-02', 7.00, 'Suivi travaux cuisine et SDB',           NULL),
(4, 8,  '2024-09-06', 5.00, 'Choix materiaux avec client',            NULL),
(4, 11, '2024-09-03', 6.00, 'Plans execution coworking N1',           NULL),
(4, 11, '2024-09-10', 7.00, 'Coordination lots techniques',           NULL),
(4, 15, '2024-09-05', 4.00, 'Suivi charpente combles',                NULL),
(5, 10, '2024-09-02', 8.00, 'Masterplan - schema directeur',          NULL),
(5, 10, '2024-09-06', 6.00, 'Etude paysagere',                        NULL),
(5, 10, '2024-09-12', 7.00, 'Reunion Icade - presentation esquisse',  NULL),

-- Octobre 2024
(1, 1,  '2024-10-01', 5.00, 'Point budget lots techniques',           NULL),
(1, 1,  '2024-10-07', 7.00, 'Reunion chantier + tour de site',        NULL),
(1, 1,  '2024-10-14', 4.00, 'VISA menuiseries exterieures',           NULL),
(1, 5,  '2024-10-02', 7.00, 'Consultation lot facades bat B',         NULL),
(1, 5,  '2024-10-10', 8.00, 'Reunion chantier generale',              NULL),
(1, 5,  '2024-10-24', 6.00, 'Reunion MOA + entreprises',              NULL),
(1, 14, '2024-10-03', 6.00, 'PRO - plans detailles parkings',         NULL),
(1, 14, '2024-10-15', 5.00, 'Reunion Nexity - point PRO',             NULL),
(1, 16, '2024-10-08', 4.00, 'Montage dossier PC',                     NULL),
(1, 20, '2024-10-22', 3.00, 'Premiere reunion de lancement',          NULL),
(2, 2,  '2024-10-01', 6.00, 'Suivi ravalement + menuiseries',         NULL),
(2, 2,  '2024-10-14', 7.00, 'Reunion chantier',                       NULL),
(2, 2,  '2024-10-28', 5.00, 'Reunion chantier + point peinture',      NULL),
(2, 12, '2024-10-02', 5.00, 'APD maison Bordeaux',                    NULL),
(2, 12, '2024-10-16', 4.00, 'Etude thermique avec BET',               NULL),
(3, 7,  '2024-10-01', 7.00, 'APS plans detailles',                    NULL),
(3, 7,  '2024-10-08', 8.00, 'Maquette BIM lycee',                     NULL),
(3, 7,  '2024-10-15', 6.00, 'Reunion region + ABF',                   NULL),
(3, 21, '2024-10-03', 5.00, 'Suivi chantier gymnase',                 NULL),
(3, 21, '2024-10-17', 6.00, 'VISA lot charpente',                     NULL),
(3, 21, '2024-11-05', 7.00, 'Reunion chantier generale',              NULL),
(3, 9,  '2024-10-07', 4.00, 'Plans masse mediatheque',                NULL),
(3, 13, '2024-10-10', 3.00, 'Diagnostic salle des fetes Lyon',        NULL),
(4, 8,  '2024-10-01', 6.00, 'Suivi finitions appartement',            NULL),
(4, 8,  '2024-10-14', 5.00, 'Reunion chantier + client',              NULL),
(4, 11, '2024-10-02', 7.00, 'Plans execution N2 coworking',           NULL),
(4, 11, '2024-10-09', 6.00, 'Coordination mobilier sur mesure',       NULL),
(4, 11, '2024-11-04', 5.00, 'Reunion chantier coworking',             NULL),
(4, 15, '2024-10-08', 4.00, 'Suivi velux + terrasse',                 NULL),
(4, 15, '2024-10-21', 5.00, 'Reunion chantier combles',               NULL),
(4, 17, '2024-10-03', 2.00, 'OPR bureaux Montreuil',                  NULL),
(5, 10, '2024-10-01', 7.00, 'Masterplan - plans quartier',            NULL),
(5, 10, '2024-10-08', 8.00, 'Etude mobilite et stationnement',        NULL),
(5, 10, '2024-10-15', 6.00, 'Presentation comite pilotage',           NULL),
(5, 10, '2024-10-22', 5.00, 'Integration remarques ABF',              NULL),

-- Novembre 2024
(1, 1,  '2024-11-04', 7.00, 'Reunion chantier + OPC',                 NULL),
(1, 1,  '2024-11-12', 5.00, 'VISA lots peinture',                     NULL),
(1, 5,  '2024-11-05', 6.00, 'Point avancement batiment B',            NULL),
(1, 5,  '2024-11-15', 7.00, 'Analyse offres lot facade C',            NULL),
(1, 14, '2024-11-06', 5.00, 'PRO - synthese technique',               NULL),
(1, 16, '2024-11-08', 6.00, 'PC - plans de masse',                    NULL),
(1, 20, '2024-11-12', 4.00, 'Esquisse residence Montreuil',           NULL),
(2, 2,  '2024-11-04', 6.00, 'Suivi second oeuvre',                    NULL),
(2, 2,  '2024-11-12', 5.00, 'VISA plans agencement',                  NULL),
(2, 12, '2024-11-05', 6.00, 'Plans PRO maison Bordeaux',              NULL),
(3, 7,  '2024-11-04', 7.00, 'APS - synthese',                         NULL),
(3, 7,  '2024-11-12', 6.00, 'Maquette 3D presentation',               NULL),
(3, 21, '2024-11-05', 7.00, 'Reunion chantier centre sportif',        NULL),
(3, 21, '2024-11-13', 5.00, 'Finitions vestiaires',                   NULL),
(3, 9,  '2024-11-06', 5.00, 'ESQ mediatheque Nantes',                 NULL),
(4, 11, '2024-11-05', 7.00, 'Suivi amenagement coworking',            NULL),
(4, 11, '2024-11-13', 6.00, 'Coordination signaletique',              NULL),
(4, 15, '2024-11-04', 4.00, 'Suivi terrasse + garde-corps',           NULL),
(4, 8,  '2024-11-06', 3.00, 'Levee reserves appartement',             NULL),
(5, 10, '2024-11-04', 8.00, 'Plan guide eco-quartier',                NULL),
(5, 10, '2024-11-12', 7.00, 'Etude impact environnemental',           NULL),

-- Decembre 2024
(1, 1,  '2024-12-02', 6.00, 'Reunion chantier',                       NULL),
(1, 1,  '2024-12-10', 5.00, 'Point livraison lots',                   NULL),
(1, 5,  '2024-12-03', 7.00, 'Coordination phases 2-3',                NULL),
(1, 14, '2024-12-04', 6.00, 'PRO finalisation',                       NULL),
(1, 16, '2024-12-09', 5.00, 'PC Charenton - insertion',               NULL),
(2, 2,  '2024-12-02', 5.00, 'Suivi peintures interieur',              NULL),
(2, 2,  '2024-12-11', 6.00, 'Point reception partielle',              NULL),
(2, 12, '2024-12-03', 5.00, 'Suivi permis Bordeaux',                  NULL),
(3, 7,  '2024-12-02', 7.00, 'Finalisation APS lycee',                 NULL),
(3, 7,  '2024-12-10', 6.00, 'Presentation APS a la region',           NULL),
(3, 21, '2024-12-04', 6.00, 'Reunion chantier',                       NULL),
(3, 9,  '2024-12-05', 4.00, 'Depot PC mediatheque',                   NULL),
(4, 11, '2024-12-02', 7.00, 'Reception coworking - OPR',              NULL),
(4, 15, '2024-12-03', 5.00, 'Suivi finitions combles',                NULL),
(5, 10, '2024-12-02', 8.00, 'Rendu esquisse masterplan',              NULL),
(5, 10, '2024-12-10', 6.00, 'Presentation publique',                  NULL),

-- Janvier 2025
(1, 1,  '2025-01-06', 6.00, 'Reprise chantier post-fetes',            NULL),
(1, 1,  '2025-01-13', 5.00, 'DET - suivi lots techniques',            NULL),
(1, 5,  '2025-01-07', 7.00, 'ACT lot facade bat C',                   NULL),
(1, 5,  '2025-01-14', 6.00, 'Analyse offres',                         NULL),
(1, 14, '2025-01-08', 5.00, 'Lancement DCE Nexity',                   NULL),
(1, 16, '2025-01-10', 4.00, 'Suivi instruction PC',                   NULL),
(1, 20, '2025-01-09', 5.00, 'APS residence Montreuil',                NULL),
(2, 2,  '2025-01-06', 6.00, 'Preparation reception',                  NULL),
(2, 2,  '2025-01-15', 5.00, 'Liste reserves',                         NULL),
(2, 12, '2025-01-07', 4.00, 'Suivi PC Bordeaux',                      NULL),
(3, 7,  '2025-01-06', 8.00, 'Lancement APD lycee',                    NULL),
(3, 7,  '2025-01-13', 7.00, 'Plans detailles CDI',                    NULL),
(3, 21, '2025-01-08', 6.00, 'Reunion chantier centre sportif',        NULL),
(3, 9,  '2025-01-09', 5.00, 'Instruction PC mediatheque',             NULL),
(4, 15, '2025-01-07', 5.00, 'Finitions combles Nguyen',               NULL),
(4, 11, '2025-01-08', 3.00, 'Levee reserves coworking',               NULL),
(5, 10, '2025-01-06', 7.00, 'Revision masterplan',                    NULL),
(5, 10, '2025-01-14', 6.00, 'Etude mixite fonctionnelle',             NULL),

-- Fevrier 2025
(1, 1,  '2025-02-03', 5.00, 'DET facades + finitions',                NULL),
(1, 1,  '2025-02-10', 6.00, 'Reunion chantier',                       NULL),
(1, 5,  '2025-02-04', 7.00, 'Suivi batiment B structure',             NULL),
(1, 14, '2025-02-05', 6.00, 'DCE en cours',                           NULL),
(1, 20, '2025-02-06', 5.00, 'APS plans courants Montreuil',           NULL),
(2, 2,  '2025-02-03', 6.00, 'Pre-reception',                          NULL),
(2, 2,  '2025-02-12', 4.00, 'Listes snags',                           NULL),
(3, 7,  '2025-02-03', 8.00, 'APD lycee - synthese technique',         NULL),
(3, 7,  '2025-02-11', 7.00, 'APD - plans salles de classe',           NULL),
(3, 21, '2025-02-05', 5.00, 'Suivi finitions centre sportif',         NULL),
(4, 15, '2025-02-03', 4.00, 'OPR combles Nguyen',                     NULL),
(5, 10, '2025-02-03', 7.00, 'Plan masse definitif',                   NULL),
(5, 10, '2025-02-11', 6.00, 'Presentation comite pilotage final',     NULL);

-- ============================================================================
-- DOCUMENTS (exemples representatifs)
-- ============================================================================
INSERT INTO documents (projet_id, phase_id, type_document, nom_fichier, version, chemin_fichier, uploaded_by) VALUES
(1,  1,  'plan',        'ARCH-2023-001_ESQ_plan-masse.dwg',          2, '/projets/2023-001/ESQ/plan-masse_v2.dwg',       1),
(1,  1,  'perspective', 'ARCH-2023-001_ESQ_perspective-01.jpg',      1, '/projets/2023-001/ESQ/perspective-01.jpg',       1),
(1,  4,  'plan',        'ARCH-2023-001_PRO_plans-niveaux.dwg',       3, '/projets/2023-001/PRO/plans-niveaux_v3.dwg',    1),
(1,  5,  'devis',       'ARCH-2023-001_DCE_CCTP-lot1.pdf',           1, '/projets/2023-001/DCE/CCTP-lot1.pdf',           1),
(2,  1,  'plan',        'ARCH-2023-002_ESQ_releve-existant.dwg',     1, '/projets/2023-002/ESQ/releve-existant.dwg',     2),
(2,  3,  'coupe',       'ARCH-2023-002_APD_coupes-AA-BB.dwg',        2, '/projets/2023-002/APD/coupes-AA-BB_v2.dwg',     2),
(2,  NULL,'photo',       'ARCH-2023-002_chantier_20241014.jpg',       1, '/projets/2023-002/chantier/photo-20241014.jpg', 2),
(5,  3,  'plan',        'ARCH-2023-005_APD_plan-masse-BIM.ifc',      4, '/projets/2023-005/APD/plan-masse-BIM_v4.ifc',   1),
(5,  5,  'devis',       'ARCH-2023-005_DCE_DPGF-lot-GO.xlsx',       1, '/projets/2023-005/DCE/DPGF-lot-GO.xlsx',        1),
(7,  NULL,'notice',      'ARCH-2024-002_notice-descriptive.pdf',      1, '/projets/2024-002/notice-descriptive.pdf',      3),
(8,  1,  'plan',        'ARCH-2024-003_ESQ_plan-existant.dwg',       1, '/projets/2024-003/ESQ/plan-existant.dwg',       4),
(8,  4,  'perspective', 'ARCH-2024-003_PRO_3D-cuisine.jpg',          2, '/projets/2024-003/PRO/3D-cuisine_v2.jpg',       4),
(11, 4,  'plan',        'ARCH-2024-006_PRO_plan-N1.dwg',             2, '/projets/2024-006/PRO/plan-N1_v2.dwg',          4),
(14, 3,  'plan',        'ARCH-2024-009_APD_plan-R+1.dwg',            1, '/projets/2024-009/APD/plan-R+1.dwg',            1),
(21, 4,  'plan',        'ARCH-2023-006_PRO_piscine-structure.dwg',   2, '/projets/2023-006/PRO/piscine-structure_v2.dwg', 3),
(21, NULL,'cr_chantier', 'ARCH-2023-006_CR-chantier-20241105.pdf',   1, '/projets/2023-006/CR/CR-20241105.pdf',          3),
(10, NULL,'plan',        'ARCH-2024-005_ESQ_masterplan.pdf',          3, '/projets/2024-005/ESQ/masterplan_v3.pdf',       5);

-- ============================================================================
-- FIN DES DONNEES SEED
-- ============================================================================
