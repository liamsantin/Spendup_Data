use gestion_financiere;

INSERT INTO type_biens (nom, description, icone) VALUES
('vehicule', 'Voitures, motos, vélos, etc.', 'fa-car'),
('immobilier', 'Maisons, appartements, terrains', 'fa-home'),
('investissement', 'Actions, cryptos, fonds, assurances-vie', 'fa-chart-line'),
('objet', 'Objets de valeur, matériel électronique, bijoux', 'fa-gem'),
('autre', 'Autres types d’actifs divers', 'fa-box');

select * from type_biens;

-- 🚗 Véhicule
INSERT INTO biens (user_id, type_bien_id, nom, description, valeur_achat, valeur_actuelle, date_acquisition, cout_annuel)
VALUES
(1, (SELECT id FROM type_biens WHERE nom = 'vehicule'), 'Toyota Yaris 2020', 'Voiture principale, essence', 15000.00, 12000.00, '2020-06-10', 1200.00);

-- 🏠 Immobilier
INSERT INTO biens (user_id, type_bien_id, nom, description, valeur_achat, valeur_actuelle, localisation, revenu_annuel, cout_annuel)
VALUES
(1, (SELECT id FROM type_biens WHERE nom = 'immobilier'), 'Appartement Lausanne', 'Appartement principal 3.5p', 550000.00, 650000.00, 'Lausanne, Suisse', 0, 4000.00);

-- 📈 Investissement
INSERT INTO biens (user_id, type_bien_id, nom, description, valeur_achat, valeur_actuelle, revenu_annuel)
VALUES
(1, (SELECT id FROM type_biens WHERE nom = 'investissement'), 'ETF World MSCI', 'Investissement sur Degiro', 8000.00, 9500.00, 300.00);
