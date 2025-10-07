drop database spendup;

create database spendup;

use spendup;

-- Donner tous les droits à devuser sur spendup
GRANT ALL PRIVILEGES ON spendup.* TO 'devuser'@'localhost';
FLUSH PRIVILEGES;

CREATE TABLE `User` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR (100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(50) NOT NULL,
    phone VARCHAR(100) not null,
    birthDate date not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- PaymentMethod
create table PaymentMethod (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);
insert into PaymentMethod (id, name) VALUES (null, 'Carte bancaire');
insert into PaymentMethod (id, name) VALUES (null, 'Espèce');

-- ActivityDomain
create table ActivityDomain(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);
insert into ActivityDomain (id, name) VALUES (null, 'Restaurant');
insert into ActivityDomain (id, name) VALUES (null, 'Magasin');

create table Transaction (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    payment_method_id INT,
    activity_domain_id INT,
    amount DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    constraint fk_transaction_payment_method FOREIGN KEY (payment_method_id)
                         REFERENCES PaymentMethod(id) ON DELETE SET NULL,
    constraint fk_transaction_activity_domain FOREIGN KEY  (activity_domain_id)
                         REFERENCES  ActivityDomain(id) ON DELETE SET NULL
);
insert into Transaction (id, user_id, payment_method_id, activity_domain_id, amount, description, date)
VALUES (null, 2, 1,1, 100.20, 'paiement test', now());

create table Objectif (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
)

select * from Transaction;

delete from Transaction where id = 26 and user_id = 3;

SELECT EXISTS(
    SELECT 1
    FROM Transaction
    WHERE id = 23
      AND user_id = 3
) AS IsAuthorized;

SELECT
    CASE
        WHEN t.id IS NULL THEN 'NOT_FOUND'
        WHEN t.user_id = 1 THEN 'AUTHORIZED'
        ELSE 'FORBIDDEN'
    END AS AccessStatus
FROM Transaction t
WHERE t.id = 23;

select * from PaymentMethod;