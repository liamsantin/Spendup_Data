drop database spendup;
CREATE DATABASE IF NOT EXISTS spendup CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE spendup;

-- =========================
-- Tables "types / statuts"
-- =========================
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

CREATE TABLE StatutTransaction (
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

-- ===========
-- Utilisateur
-- ===========
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

-- 1 ── 1 : chaque user possède exactement un Parameter
CREATE TABLE Parameter (
  id INT AUTO_INCREMENT PRIMARY KEY,
  theme VARCHAR(50) NOT NULL,
  langue VARCHAR(10) NOT NULL,
  user_id INT NOT NULL UNIQUE,          -- unicité = vraie relation 1–1
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_parameter_user FOREIGN KEY (user_id) REFERENCES User(id)
);

-- ========
-- Comptes
-- ========
-- UML: User 1 ── 0..* Account ; TypeAccount 1 ── 0..* Account
CREATE TABLE Account (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type_account_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  currency_code CHAR(3) NOT NULL DEFAULT 'CHF',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_account_user FOREIGN KEY (user_id) REFERENCES User(id),
  CONSTRAINT fk_account_type FOREIGN KEY (type_account_id) REFERENCES TypeAccount(id)
);

CREATE TABLE PaymentMethod (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========
-- Catégory
-- =========
-- UML: User 1 ── 0..* Category ; TypeCategory 1 ── 0..* Category
CREATE TABLE Category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type_category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_category_type FOREIGN KEY (type_category_id) REFERENCES TypeCategory(id)
);

-- ======
-- Budget
-- ======
-- UML: User 1 ── 0..* Budget
CREATE TABLE Budget (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  max_amount DECIMAL(10,2),
  start_date DATE,
  end_date DATE,
  spent_amount DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_budget_user FOREIGN KEY (user_id) REFERENCES User(id),
  FOREIGN KEY (category_id) REFERENCES Category(id)
);

-- =========
-- Property
-- =========
-- UML: User 1 ── 0..* Property ; TypeProperty 1 ── 0..* Property
CREATE TABLE Property (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type_property_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  valeur_achat DECIMAL(10,2),
  valeur_actuelle DECIMAL(10,2),
  date_acquisition DATE,
  date_estimation DATE,
  revenu_annuel DECIMAL(10,2),
  cout_annuel DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_property_user FOREIGN KEY (user_id) REFERENCES User(id),
  CONSTRAINT fk_property_type FOREIGN KEY (type_property_id) REFERENCES TypeProperty(id)
);

-- =======
-- Report
-- =======
-- UML: User 1 ── 0..* Report ; TypeReport 1 ── 0..* Report
CREATE TABLE Report (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type_report_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  data JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_report_user FOREIGN KEY (user_id) REFERENCES User(id),
  CONSTRAINT fk_report_type FOREIGN KEY (type_report_id) REFERENCES TypeReport(id)
);

-- ========
-- Objectif
-- ========
-- UML: User 1 ── 0..* Objectif ; StatutObjectif 1 ── 0..* Objectif
CREATE TABLE Objectif (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  statut_objectif_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  cible DECIMAL(10,2),
  progression DECIMAL(10,2),
  start_date DATE,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_objectif_user FOREIGN KEY (user_id) REFERENCES User(id),
  CONSTRAINT fk_objectif_status FOREIGN KEY (statut_objectif_id) REFERENCES StatutObjectif(id)
);

-- ======================
-- RecurrentTransaction
-- ======================
-- UML: indépendant ; 0..1 lié à Transaction
CREATE TABLE RecurrentTransaction (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  intervale INT NOT NULL,
  nextDate DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============
-- Transaction
-- ============
-- UML:
--   User 1 ── 0..* Transaction
--   Account 1 ── 0..* Transaction
--   TypeTransaction 1 ── 0..* Transaction
--   StatutTransaction 1 ── 0..* Transaction
--   Budget 1 ── 0..* Transaction  (côté Transaction optionnel)
--   Category 1 ── 0..* Transaction
--   PaymentMethod 0..1 ── 0..* Transaction (optionnel)
--   RecurrentTransaction 0..1 ── 0..* Transaction (optionnel)
--   Property 0..1 ── 0..* Transaction (optionnel)
CREATE TABLE Transaction (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  type_transaction_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  description TEXT,
  statut_transaction_id INT NOT NULL,
  budget_id INT,
  objectif_id INT,
  property_id INT,
  category_id INT NOT NULL,
  payment_method_id INT NULL,
  recurrence_transaction_id INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (account_id) REFERENCES Account(id),
  CONSTRAINT fk_trx_ttype FOREIGN KEY (type_transaction_id) REFERENCES TypeTransaction(id),
  CONSTRAINT fk_trx_status FOREIGN KEY (statut_transaction_id) REFERENCES StatutTransaction(id),
  CONSTRAINT fk_trx_budget FOREIGN KEY (budget_id) REFERENCES Budget(id),
  CONSTRAINT fk_trx_category FOREIGN KEY (category_id) REFERENCES Category(id),
  CONSTRAINT fk_trx_pmethod FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(id),
  CONSTRAINT fk_trx_recur FOREIGN KEY (recurrence_transaction_id) REFERENCES RecurrentTransaction(id),
  FOREIGN KEY (property_id) REFERENCES Property(id)
);

delete from Transaction WHERE account_id = 1;

-- ============
-- Notification
-- ============
-- UML: référence polymorphe vers Budget/Objectif/Transaction (optionnels)
CREATE TABLE Notification (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50) NOT NULL,
  message TEXT NOT NULL,
  related_id INT,
  is_read BOOLEAN DEFAULT FALSE,
  budget_id INT NULL,
  objectif_id INT NULL,
  transaction_id INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES User(id),
  CONSTRAINT fk_notif_budget FOREIGN KEY (budget_id) REFERENCES Budget(id),
  CONSTRAINT fk_notif_objectif FOREIGN KEY (objectif_id) REFERENCES Objectif(id),
  FOREIGN KEY (transaction_id) REFERENCES Transaction(id) ON DELETE CASCADE
);

-- =========================
-- Index utiles (performances)
-- =========================
CREATE INDEX ix_trx_budget ON Transaction(budget_id);
CREATE INDEX ix_trx_category ON Transaction(category_id);
CREATE INDEX ix_trx_account ON Transaction(account_id);
CREATE INDEX ix_trx_created ON Transaction(created_at);

CREATE INDEX ix_budget_user ON Budget(user_id);
CREATE INDEX ix_account_user ON Account(user_id);
CREATE INDEX ix_property_user ON Property(user_id);
CREATE INDEX ix_objectif_user ON Objectif(user_id);


-- ========================================
-- TYPES ET STATUTS
-- ========================================
INSERT INTO TypeProperty (name) VALUES
('Véhicule'),
('Immobilier');

INSERT INTO TypeCategory (name) VALUES
('Revenu'),
('Dépense'),
('Autre');

INSERT INTO TypeTransaction (name) VALUES
('Revenu'),
('Dépense'),
('Transfert interne');

INSERT INTO TypeAccount (name) VALUES
('Courant'),
('Épargne'),
('Crypto');

INSERT INTO StatutTransaction (name) VALUES
('Confirmé'),
('En attente'),
('Annulé');

INSERT INTO StatutObjectif (name) VALUES
('En cours'),
('Abandonné'),
('Atteint');

INSERT INTO TypeReport (name) VALUES
('Mensuel'),
('Prévisionnel');

-- ========================================
-- UTILISATEUR ET PARAMÈTRE
-- ========================================
INSERT INTO User (email, password, name, phone, birthdate)
VALUES ('liam@example.com', 'hash123', 'Liam Santin', '0791234567', '1995-04-12');

INSERT INTO Parameter (theme, langue, user_id)
VALUES ('dark', 'fr', 1);

-- ========================================
-- COMPTES ET MOYENS DE PAIEMENT
-- ========================================
INSERT INTO Account (user_id, type_account_id, name, balance, currency_code)
VALUES
(1, 1, 'Compte Principal', 2500.00, 'CHF'),
(1, 2, 'Compte Épargne', 5000.00, 'CHF'),
(1, 3, 'Portefeuille Crypto', 1000.00, 'CHF');

INSERT INTO PaymentMethod (name)
VALUES
('Cash'),
('Carte bancaire'),
('Virement');

-- ========================================
-- CATÉGORIES (liées aux types)
-- ========================================

-- 💸 Dépenses
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

-- 💰 Revenus
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

-- 🏦 Autres
INSERT INTO Category (name, type_category_id) VALUES
('Transfert interne', 3),
('Carte de crédit', 3),
('Remboursement', 3),
('Investissement', 3),
('Autre', 3);

-- ========================================
-- BIENS (Property)
-- ========================================
INSERT INTO Property (user_id, type_property_id, name, description, valeur_achat, valeur_actuelle, date_acquisition, date_estimation, revenu_annuel, cout_annuel)
VALUES
(1, 1, 'Voiture Audi A3', 'Véhicule personnel acheté neuf', 22000.00, null, '2022-06-15', '2025-01-01', 0.00, 1200.00),
(1, 2, 'Appartement Lausanne', 'Appartement locatif 3 pièces', 420000.00, null, '2020-03-01', '2025-01-01', 18000.00, 3500.00);

-- ========================================
-- BUDGETS
-- ========================================
INSERT INTO Budget (user_id, category_id,name, max_amount, start_date, end_date, spent_amount)
VALUES
(1,2, 'Budget Octobre', 2000.00, '2025-10-01', '2025-10-31', 350.00),
(1, 2,'Budget Vacances Été', 3000.00, '2025-07-01', '2025-08-31', 1200.00);

-- ========================================
-- OBJECTIFS
-- ========================================
INSERT INTO Objectif (user_id, statut_objectif_id, name, cible, progression, start_date, end_date)
VALUES
(1, 1, 'Économiser 1000 CHF', 1000.00, 300.00, '2025-01-01', '2025-12-31'),
(1, 1, 'Financer vacances 2026', 2500.00, 800.00, '2025-07-01', '2026-06-30'),
(1, 3, 'Acheter un nouveau PC', 2000.00, 2000.00, '2025-02-01', '2025-12-31');

-- ========================================
-- TRANSACTIONS RÉCURRENTES
-- ========================================
INSERT INTO RecurrentTransaction (name, intervale, nextDate)
VALUES
('Salaire mensuel', 30, '2025-11-01'),
('Abonnement Netflix', 30, '2025-11-05'),
('Transfert automatique vers épargne', 30, '2025-11-01');

-- ========================================
-- TRANSACTIONS (cohérentes UML)
-- ========================================

-- 💰 Revenus
INSERT INTO Transaction (account_id, type_transaction_id, amount, description, statut_transaction_id, budget_id, objectif_id, property_id, category_id, payment_method_id, recurrence_transaction_id)
VALUES
(1, 1, 3500.00, 'Salaire mensuel d’octobre', 1, 1, NULL, NULL, 17, 3, 1),
(1, 1, 250.00, 'Vente ancien téléphone', 1, 1, NULL, NULL, 24, 1, NULL);

-- 💸 Dépenses
INSERT INTO Transaction (account_id, type_transaction_id, amount, description, statut_transaction_id, budget_id, objectif_id, property_id, category_id, payment_method_id, recurrence_transaction_id)
VALUES
(1, 2, 80.00, 'Achat d’essence', 1, 1, NULL, 1, 3, 2, NULL),
(1, 2, 1400.00, 'Loyer appartement Lausanne', 1, 1, NULL, 2, 2, 3, NULL),
(1, 2, 18.00, 'Abonnement Netflix', 1, 1, NULL, NULL, 6, 2, 2),
(1, 2, 120.00, 'Vêtements d’hiver', 1, 1, NULL, NULL, 8, 2, NULL),
(1, 2, 50.00, 'Don mensuel', 1, 1, 1, NULL, 15, 1, NULL);

-- 🔁 Transfert interne / Épargne
INSERT INTO Transaction (account_id, type_transaction_id, amount, description, statut_transaction_id, budget_id, objectif_id, property_id, category_id, payment_method_id, recurrence_transaction_id)
VALUES
(1, 3, 500.00, 'Transfert vers compte épargne', 1, 1, 1, NULL, 25, 3, 3);

-- ========================================
-- RAPPORTS
-- ========================================
INSERT INTO Report (user_id, type_report_id, start_date, end_date, data)
VALUES
(1, 1, '2025-10-01', '2025-10-31', JSON_OBJECT('revenus', 3750, 'dépenses', 1668, 'solde', 2082)),
(1, 2, '2025-11-01', '2025-11-30', JSON_OBJECT('prévision_revenus', 3500, 'prévision_dépenses', 1800));

-- ========================================
-- NOTIFICATIONS
-- ========================================
INSERT INTO Notification (user_id, type, message, related_id, is_read, budget_id, objectif_id, transaction_id)
VALUES
(1, 'Budget', 'Vous avez atteint 80% de votre budget mensuel', 1, FALSE, 1, NULL, NULL),
(1, 'Objectif', 'Votre objectif "Acheter un nouveau PC" est atteint !', 3, FALSE, NULL, 3, NULL),
(1, 'Transaction', 'Votre salaire d’octobre a été enregistré', 1, TRUE, 1, NULL, 1);


select * from User;

