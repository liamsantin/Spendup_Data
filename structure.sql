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

CREATE TABLE TypeReport (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE TypeCategory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE TypeTransaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE TypeAccount (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE StatutObjectif (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE StatutTransaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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

CREATE TABLE Parameter (
    id INT AUTO_INCREMENT PRIMARY KEY,
    theme VARCHAR(50) NOT NULL,
    langue VARCHAR(10) NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- ==========================
-- TABLES DE COMPTES ET PAIEMENTS
-- ==========================

CREATE TABLE PaymentMethod (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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

-- ==========================
-- DATA EXEMPLE
-- ==========================
-- Types
INSERT INTO TypeProperty (name) VALUES ('Véhicule'), ('Immobilier');
INSERT INTO TypeCategory (name) VALUES ('Transport'), ('Carburant'), ('Alimentation');
INSERT INTO TypeTransaction (name) VALUES ('Revenu'), ('Dépense'), ('Transfert interne');
INSERT INTO TypeAccount (name) VALUES ('Courant'), ('Épargne'), ('Crypto'), ('investissement');
INSERT INTO StatutTransaction (name) VALUES ('Confirmé'), ('En attente'), ('Annulé');
INSERT INTO StatutObjectif (name) VALUES ('En cours'), ('Abandonné'), ('Atteint');
INSERT INTO TypeReport (name) VALUES ('Mensuel'), ('Prévisionnel');

-- Utilisateurs
INSERT INTO User (email, password, name, phone, birthdate)
VALUES ('liam@example.com', 'hash123', 'Liam Santin', '0791234567', '1995-04-12');

INSERT INTO Parameter (theme, langue, user_id)
VALUES ('dark', 'fr', 1);

-- Comptes et moyens de paiement
INSERT INTO PaymentMethod (name) VALUES ('Cash'), ('Carte bancaire'), ('Virement');
INSERT INTO Account (name, balance, type_account_id)
VALUES ('Compte Principal', 2500.00, 1), ('Épargne Crypto', 1000.00, 3);

-- Catégories / Budgets
INSERT INTO Category (name, type_category_id) VALUES ('Transport', 1), ('Courses', 3);
INSERT INTO Budget (name, max_amount, start_date, end_date, spent_amount, user_id)
VALUES ('Budget Octobre', 2000.00, '2025-10-01', '2025-10-31', 0.00, 1);

-- Transactions
INSERT INTO Transaction (name, amount, description, user_id, budget_id, category_id, statut_transaction_id, type_transaction_id, payment_method_id, account_id)
VALUES ('Achat essence', 80.00, 'Plein de carburant', 1, 1, 1, 1, 2, 2, 1),
       ('Salaire', 3500.00, 'Revenu mensuel', 1, 1, NULL, 1, 1, 3, 1);

-- Objectifs
INSERT INTO Objectif (name, cible, progression, start_date, end_date, statut_objectif_id, user_id)
VALUES ('Économiser 1000 CHF', 1000.00, 300.00, '2025-01-01', '2025-12-31', 1, 1);

-- Notifications
INSERT INTO Notification (type, message, related_id, is_read, budget_id)
VALUES ('Budget', 'Vous avez dépassé 80% de votre budget', 1, FALSE, 1);