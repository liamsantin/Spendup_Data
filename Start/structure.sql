-- =====================================================================
--  Base de données : gestion_financiere
-- =====================================================================

CREATE DATABASE IF NOT EXISTS gestion_financiere
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestion_financiere;

-- Remarque : on fera un TRIGGER par table (MySQL ne permet pas un trigger global)

-- =====================================================================
--  Tables de référence
-- =====================================================================

CREATE TABLE type_accounts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE type_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE payment_methods (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE recurrence_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  interval_value INT DEFAULT 1,
  next_date DATE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE categories ADD COLUMN type ENUM('income', 'expense', 'other') DEFAULT 'expense';

CREATE TABLE statut_objectifs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(60) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE type_reports (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(60) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================================
--  Tables principales
-- =====================================================================

CREATE TABLE users (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(40),
  birthday DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE users
CHANGE birthday birthdate TEXT NOT NULL;
select * from users;

CREATE TABLE parameters (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  theme INT DEFAULT 0,
  langue VARCHAR(5) DEFAULT 'fr',
  user_id BIGINT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type_account_id BIGINT NOT NULL,
  description TEXT,
  amount DECIMAL(12,2) DEFAULT 0,
  currency_code CHAR(3) DEFAULT 'CHF',
  is_archived BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (type_account_id) REFERENCES type_accounts(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT id FROM Accounts WHERE user_id = 2 LIMIT 1;
 SELECT t.*
        FROM transactions t
        INNER JOIN accounts a ON a.id = t.account_id
        WHERE a.user_id = 1
        ORDER BY t.created_at DESC;

CREATE TABLE budgets (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR(150) NOT NULL,
  montant_max DECIMAL(12,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  spent_amount DECIMAL(12,2) DEFAULT 0,
  is_archived BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
ALTER TABLE budgets MODIFY category_id BIGINT NOT NULL;
ALTER TABLE budgets
ADD CONSTRAINT fk_budgets_category
FOREIGN KEY (category_id)
REFERENCES categories(id)
ON DELETE CASCADE;
ALTER TABLE budgets
ADD COLUMN category_id BIGINT NOT NULL,
ADD FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


CREATE TABLE objectifs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  statut_objectif_id BIGINT NOT NULL,
  name VARCHAR(150) NOT NULL,
  montant_cible DECIMAL(12,2) NOT NULL,
  progression DECIMAL(5,2) DEFAULT 0,
  start_date DATE NOT NULL,
  end_date DATE NULL,
  is_archived BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (statut_objectif_id) REFERENCES statut_objectifs(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE objectif_budget (
  objectif_id BIGINT NOT NULL,
  budget_id BIGINT NOT NULL,
  PRIMARY KEY (objectif_id, budget_id),
  FOREIGN KEY (objectif_id) REFERENCES objectifs(id) ON DELETE CASCADE,
  FOREIGN KEY (budget_id) REFERENCES budgets(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE reports (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type_report_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  periode_debut DATE NOT NULL,
  periode_fin DATE NOT NULL,
  data_json JSON,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (type_report_id) REFERENCES type_reports(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  type_transaction_id BIGINT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  description TEXT,
  status VARCHAR(20) DEFAULT 'confirmed',
  budget_id BIGINT NULL,
  objectif_id BIGINT NULL,
  category_id BIGINT NULL,
  payment_method_id BIGINT NULL,
  recurrence_transaction_id BIGINT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (type_transaction_id) REFERENCES type_transactions(id),
  FOREIGN KEY (budget_id) REFERENCES budgets(id) ON DELETE SET NULL,
  FOREIGN KEY (objectif_id) REFERENCES objectifs(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL,
  FOREIGN KEY (recurrence_transaction_id) REFERENCES recurrence_transactions(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT t.*
FROM transactions t
INNER JOIN accounts a ON a.id = t.account_id
WHERE a.user_id = 2 and t.id = 33
ORDER BY t.created_at DESC;
SELECT COUNT(*)
        FROM Transactions t
        INNER JOIN Accounts a ON a.id = t.account_id
        WHERE t.id = 43 AND a.user_id = 3 ;
SELECT COUNT(*)
        FROM Accounts
        WHERE id = 6 AND user_id = 2;

CREATE TABLE notifications (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type VARCHAR(50) NOT NULL,              -- ex: 'budget', 'objectif', 'transaction'
  message TEXT NOT NULL,                  -- contenu de l’alerte lisible par l’utilisateur
  related_id BIGINT NULL,                 -- id de l’élément concerné (ex: budget_id, objectif_id)
  is_read BOOLEAN DEFAULT FALSE,          -- lu / non lu
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE type_biens (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(50) NOT NULL UNIQUE,
  description TEXT NULL,
  icone VARCHAR(100) NULL,        -- pour un affichage frontend (ex: “fa-car”, “fa-home”)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE biens (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  type_bien_id BIGINT NOT NULL,
  nom VARCHAR(100) NOT NULL,
  description TEXT NULL,
  valeur_achat DECIMAL(12,2) DEFAULT 0,
  valeur_actuelle DECIMAL(12,2) DEFAULT 0,
  date_acquisition DATE NULL,
  date_estimation DATE NULL,
  localisation VARCHAR(255) NULL,
  source_estimation VARCHAR(100) NULL,  -- ex: "Argus Auto", "Banque", "Site immo"
  revenu_annuel DECIMAL(12,2) DEFAULT 0,  -- ex: loyers, dividendes
  cout_annuel DECIMAL(12,2) DEFAULT 0,    -- ex: assurance, entretien, impôts
  objectif_id BIGINT NULL,                -- relie à un objectif ("remplacer la voiture")
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_bien_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_type_bien FOREIGN KEY (type_bien_id) REFERENCES type_biens(id) ON DELETE CASCADE,
  CONSTRAINT fk_bien_objectif FOREIGN KEY (objectif_id) REFERENCES objectifs(id) ON DELETE SET NULL
);

ALTER TABLE transactions ADD COLUMN bien_id BIGINT NULL AFTER objectif_id;
ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_bien FOREIGN KEY (bien_id) REFERENCES biens(id) ON DELETE SET NULL;



select * from biens;

-- =====================================================================
--  Données d'exemple
-- =====================================================================

INSERT INTO type_accounts (name) VALUES
  ('courant'), ('epargne'), ('investissement'), ('crypto');

INSERT INTO type_transactions (name) VALUES
  ('revenu'), ('depense'), ('transfert_interne');

INSERT INTO payment_methods (name) VALUES
  ('cash'), ('carte_bancaire'), ('virement');

INSERT INTO recurrence_transactions (name, interval_value) VALUES
  ('none', 1), ('monthly', 1), ('weekly', 1);

INSERT INTO categories (name) VALUES
  ('Alimentation'), ('Transport'), ('Carburant'), ('Loisirs'), ('Salaire');

INSERT INTO statut_objectifs (name) VALUES
  ('en_cours'), ('atteint'), ('abandonne');

INSERT INTO type_reports (name) VALUES
  ('mensuel'), ('categorie'), ('previsionnel');

-- Utilisateur et paramètres
INSERT INTO users (email, password_hash, name, phone, birthday)
VALUES ('liam@example.com', 'bcrypt$2a$example', 'Liam Santin', '+41 79 000 00 00', '1995-06-15');

INSERT INTO parameters (user_id, theme, langue)
VALUES (1, 1, 'fr');

-- Comptes
INSERT INTO accounts (user_id, type_account_id, description, amount, currency_code)
VALUES
  (1, 1, 'Compte courant UBS', 2500.00, 'CHF'),
  (1, 2, 'Compte épargne Voyage', 3000.00, 'CHF');

-- Budgets
INSERT INTO budgets (user_id, name, montant_max, start_date, end_date)
VALUES
  (1, 'Budget Alimentaire', 600.00, '2025-10-01', '2025-10-31'),
  (1, 'Loisirs', 200.00, '2025-10-01', '2025-10-31');

-- Objectif
INSERT INTO objectifs (user_id, statut_objectif_id, name, montant_cible, progression, start_date)
VALUES
  (1, 1, 'Voyage au Japon', 5000.00, 30.00, '2025-01-01');

INSERT INTO objectif_budget (objectif_id, budget_id)
VALUES (1, 2);

-- Transactions
INSERT INTO transactions (account_id, type_transaction_id, amount, description, status, category_id, payment_method_id)
VALUES
  (1, 1, 4200.00, 'Salaire mensuel', 'confirmed', 5, 3),
  (1, 2, 92.40, 'Courses Migros', 'confirmed', 1, 2),
  (1, 2, 65.30, 'Carburant station Shell', 'confirmed', 3, 2),
  (1, 3, 500.00, 'Virement vers épargne', 'confirmed', NULL, 3),
  (2, 1, 500.00, 'Alimentation objectif Japon', 'confirmed', NULL, 3);

-- Rapport
INSERT INTO reports (user_id, type_report_id, name, periode_debut, periode_fin, data_json)
VALUES
  (1, 1, 'Rapport Mensuel Octobre 2025', '2025-10-01', '2025-10-31',
   JSON_OBJECT('note', 'Aperçu des dépenses et revenus du mois'));

-- ---------------------------------------------------------------------
--  Fonction utilitaire : mise à jour automatique du champ updated_at
-- ---------------------------------------------------------------------
DELIMITER //
CREATE TRIGGER before_update_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
  SET NEW.updated_at = CURRENT_TIMESTAMP;
//
DELIMITER ;


select * from users;