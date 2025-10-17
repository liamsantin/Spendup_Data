drop database spendup;
CREATE DATABASE IF NOT EXISTS spendup CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE spendup;

-- ==========================
-- TABLES DE TYPE / STATUT
-- ==========================

CREATE TABLE TypeProperty (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO TypeProperty (name) VALUES ('Véhicule'), ('Immobilier');

CREATE TABLE TypeReport (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO TypeReport (name) VALUES ('Mensuel'), ('Prévisionnel');

CREATE TABLE TypeCategory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO TypeCategory (name) VALUES ('Revenu'), ('Dépense'), ('Autre');

CREATE TABLE TypeTransaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO TypeTransaction (name) VALUES ('Revenu'), ('Dépense'), ('Transfert interne');

CREATE TABLE TypeAccount (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO TypeAccount (name) VALUES ('Courant'), ('Épargne'), ('Crypto');

CREATE TABLE StatutObjectif (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO StatutObjectif (name) VALUES ('En cours'), ('Abandonné'), ('Atteint');

CREATE TABLE StatutTransaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO StatutTransaction (name) VALUES ('Confirmé'), ('En attente'), ('Annulé');

-- ==========================
-- TABLES UTILISATEUR ET PARAMÈTRES
-- ==========================

CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    birthdate DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO User (email, password, name, phone, birthdate)
VALUES ('liam@example.com', 'hash123', 'Liam Santin', '0791234567', '1995-04-12');


CREATE TABLE Parameter (
    id INT AUTO_INCREMENT PRIMARY KEY,
    theme VARCHAR(50) NOT NULL,
    langue VARCHAR(10) NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id)
);
INSERT INTO Parameter (theme, langue, user_id)
VALUES ('dark', 'fr', 1);

-- ==========================
-- TABLES DE COMPTES ET PAIEMENTS
-- ==========================

CREATE TABLE PaymentMethod (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO PaymentMethod (name) VALUES ('Cash'), ('Carte bancaire'), ('Virement'), ('Crypto');

CREATE TABLE Account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    currency_code CHAR(3) NOT NULL DEFAULT 'CHF',
    type_account_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_account_id) REFERENCES TypeAccount(id)
);
INSERT INTO Account (name, balance, type_account_id)
VALUES
('Compte Principal', 2500.00, 1),
('Épargne Crypto', 1000.00, 3),
('Compte Épargne', 5000.00, 2);

-- ==========================
-- TABLES DE BASE BUDGÉTAIRE
-- ==========================

CREATE TABLE Category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type_category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_category_id) REFERENCES TypeCategory(id)
);
-- 💸 Dépenses (type_category_id = 2)
INSERT INTO Category (name, type_category_id) VALUES
('Alimentation', 2),
('Logement', 2),
('Transport', 2),
('Santé', 2),
('Éducation', 2),
('Divertissement', 2),
('Vacances', 2),
('Habillement', 2),
('Communication', 2),
('Assurance', 2),
('Enfants', 2),
('Animaux', 2),
('Impôts', 2),
('Épargne', 2),
('Dons', 2),
('Autres dépenses', 2);

-- 💰 Revenus (type_category_id = 1)
INSERT INTO Category (name, type_category_id) VALUES
('Salaire', 1),
('Prime', 1),
('Indemnités', 1),
('Pensions', 1),
('Revenus locatifs', 1),
('Dividendes', 1),
('Intérêts bancaires', 1),
('Vente', 1),
('Autres revenus', 1);

-- 🏦 Spéciales / mixtes (type_category_id = 3)
INSERT INTO Category (name, type_category_id) VALUES
('Transfert interne', 3),
('Carte de crédit', 3),
('Remboursement', 3),
('Investissement', 3),
('Autre', 3);

CREATE TABLE Property (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    valeur DECIMAL(10,2),
    date_acquisition DATE,
    date_estimation DATE,
    revenu_annuel DECIMAL(10,2),
    cout_annuel DECIMAL(10,2),
    type_property_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_property_id) REFERENCES TypeProperty(id)
);
INSERT INTO Property (name, description, valeur, date_acquisition, date_estimation, revenu_annuel, cout_annuel, type_property_id)
VALUES
('Voiture Audi A3', 'Véhicule principal acheté neuf', 22000.00, '2022-06-15', '2025-01-01', 0.00, 1200.00, 1),
('Appartement Lausanne', 'Appartement locatif 3 pièces', 420000.00, '2020-03-01', '2025-01-01', 18000.00, 3500.00, 2);

CREATE TABLE Budget (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    max_amount DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    spent_amount DECIMAL(10,2),
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id)
);
INSERT INTO Budget (name, max_amount, start_date, end_date, spent_amount, user_id)
VALUES
('Budget Octobre', 2000.00, '2025-10-01', '2025-10-31', 250.00, 1),
('Budget Vacances', 3000.00, '2025-07-01', '2025-08-31', 1200.00, 1);

-- ==========================
-- TABLES TRANSACTIONS
-- ==========================

CREATE TABLE Transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    user_id INT NOT NULL,
    budget_id INT,
    category_id INT,
    statut_transaction_id INT NOT NULL,
    type_transaction_id INT NOT NULL,
    payment_method_id INT,
    account_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (budget_id) REFERENCES Budget(id),
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (statut_transaction_id) REFERENCES StatutTransaction(id),
    FOREIGN KEY (type_transaction_id) REFERENCES TypeTransaction(id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(id),
    FOREIGN KEY (account_id) REFERENCES Account(id)
);
INSERT INTO Transaction (name, amount, description, user_id, budget_id, category_id, statut_transaction_id, type_transaction_id, payment_method_id, account_id)
VALUES
('Salaire mensuel', 3500.00, 'Revenu principal', 1, 1, 17, 1, 1, 3, 1),
('Achat essence', 80.00, 'Plein de carburant pour le mois', 1, 1, 3, 1, 2, 2, 1),
('Loyer appartement', 1400.00, 'Paiement du loyer d’octobre', 1, 1, 2, 1, 2, 3, 1),
('Netflix', 18.00, 'Abonnement mensuel', 1, 1, 6, 1, 2, 2, 1),
('Vente ancien téléphone', 250.00, 'Revente d’un ancien smartphone', 1, 1, 24, 1, 1, 1, 1),
('Achat vêtements', 120.00, 'Nouveaux vêtements d’hiver', 1, 1, 8, 1, 2, 2, 1),
('Transfert vers épargne', 500.00, 'Épargne mensuelle automatique', 1, 1, 25, 1, 3, 3, 1);

CREATE TABLE RecurrentTransaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    intervale INT NOT NULL,
    nextDate DATE,
    transaction_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES Transaction(id)
);
INSERT INTO RecurrentTransaction (name, intervale, nextDate, transaction_id)
VALUES
('Salaire mensuel récurrent', 30, '2025-11-01', 1),
('Abonnement Netflix', 30, '2025-11-05', 4),
('Transfert automatique vers épargne', 30, '2025-11-01', 7);

-- ==========================
-- TABLES RAPPORTS / OBJECTIFS
-- ==========================

CREATE TABLE Report (
    id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    data JSON,
    type_report_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_report_id) REFERENCES TypeReport(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);
INSERT INTO Report (start_date, end_date, data, type_report_id, user_id)
VALUES
('2025-10-01', '2025-10-31', JSON_OBJECT('revenus', 3750, 'dépenses', 1618), 1, 1),
('2025-11-01', '2025-11-30', JSON_OBJECT('prévision_revenus', 3500, 'prévision_dépenses', 1800), 2, 1);

CREATE TABLE Objectif (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cible DECIMAL(10,2),
    progression DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    statut_objectif_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (statut_objectif_id) REFERENCES StatutObjectif(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);
INSERT INTO Objectif (name, cible, progression, start_date, end_date, statut_objectif_id, user_id)
VALUES
('Économiser 1000 CHF', 1000.00, 300.00, '2025-01-01', '2025-12-31', 1, 1),
('Financer vacances 2026', 2500.00, 800.00, '2025-07-01', '2026-06-30', 1, 1),
('Acheter un nouveau PC', 2000.00, 1500.00, '2025-02-01', '2025-12-31', 3, 1);

-- ==========================
-- TABLE NOTIFICATIONS
-- ==========================

CREATE TABLE Notification (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    related_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    budget_id INT,
    objectif_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (budget_id) REFERENCES Budget(id),
    FOREIGN KEY (objectif_id) REFERENCES Objectif(id)
);
INSERT INTO Notification (type, message, related_id, is_read, budget_id)
VALUES
('Budget', 'Vous avez dépassé 80% de votre budget mensuel', 1, FALSE, 1),
('Objectif', 'Votre objectif "Acheter un nouveau PC" est presque atteint', 3, FALSE, NULL),
('Revenu', 'Votre salaire du mois d’octobre a été enregistré', 1, TRUE, 1);

show tables;

