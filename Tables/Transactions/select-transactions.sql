use gestion_financiere;

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

CALL sp_mettre_a_jour_progression_objectifs();
CALL sp_generer_rapport_mensuel(1, 10, 2025);
SELECT * FROM v_dashboard_global;

select * from transactions;

SELECT u.name, t.*
FROM transactions t
JOIN accounts a ON a.id = t.account_id
JOIN users u ON u.id = a.user_id;


SELECT
    u.name                    AS utilisateur,
    a.description             AS compte,
    tt.name                   AS type_transaction,
    t.description             AS libelle,
    t.amount                  AS montant,
    c.name                    AS categorie,
    b.name                    AS budget,
    o.name                    AS objectif,
    pm.name                   AS methode_paiement,
    t.status                  AS statut,
    DATE(t.created_at)        AS date_transaction
FROM transactions t
INNER JOIN accounts a             ON a.id = t.account_id
INNER JOIN users u                ON u.id = a.user_id
INNER JOIN type_transactions tt   ON tt.id = t.type_transaction_id
LEFT JOIN categories c            ON c.id = t.category_id
LEFT JOIN budgets b               ON b.id = t.budget_id
LEFT JOIN objectifs o             ON o.id = t.objectif_id
LEFT JOIN payment_methods pm      ON pm.id = t.payment_method_id
ORDER BY t.created_at DESC;

SELECT
    u.name                    AS utilisateur,
    a.description             AS compte,
    tt.name                   AS type_transaction,
    t.description             AS libelle,
    t.amount                  AS montant,
    c.name                    AS categorie,
    b.name                    AS budget,
    o.name                    AS objectif,
    pm.name                   AS methode_paiement,
    t.status                  AS statut,
    DATE(t.created_at)        AS date_transaction
FROM transactions t
INNER JOIN accounts a             ON a.id = t.account_id
INNER JOIN users u                ON u.id = a.user_id
INNER JOIN type_transactions tt   ON tt.id = t.type_transaction_id
LEFT JOIN categories c            ON c.id = t.category_id
LEFT JOIN budgets b               ON b.id = t.budget_id
LEFT JOIN objectifs o             ON o.id = t.objectif_id
LEFT JOIN payment_methods pm      ON pm.id = t.payment_method_id
WHERE u.name = 'Liam Santin'
ORDER BY t.created_at DESC;

SELECT
    tt.name AS type_transaction,
    ROUND(SUM(t.amount), 2) AS total_montant,
    COUNT(t.id) AS nombre_transactions
FROM transactions t
INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id
INNER JOIN accounts a           ON a.id = t.account_id
INNER JOIN users u              ON u.id = a.user_id
WHERE u.name = 'Liam Santin'
GROUP BY tt.name
ORDER BY total_montant DESC;

SELECT
    u.name AS utilisateur,
    o.name AS objectif,
    t.description AS libelle,
    tt.name AS type_transaction,
    t.amount AS montant,
    pm.name AS methode_paiement,
    DATE(t.created_at) AS date_transaction
FROM transactions t
INNER JOIN accounts a           ON a.id = t.account_id
INNER JOIN users u              ON u.id = a.user_id
INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id
INNER JOIN objectifs o          ON o.id = t.objectif_id
LEFT JOIN payment_methods pm    ON pm.id = t.payment_method_id
ORDER BY o.name, t.created_at;

SELECT
    u.name AS utilisateur,
    b.name AS budget,
    t.description AS libelle,
    t.amount AS montant,
    c.name AS categorie,
    pm.name AS methode_paiement,
    DATE(t.created_at) AS date_transaction
FROM transactions t
INNER JOIN accounts a           ON a.id = t.account_id
INNER JOIN users u              ON u.id = a.user_id
INNER JOIN budgets b            ON b.id = t.budget_id
LEFT JOIN categories c          ON c.id = t.category_id
LEFT JOIN payment_methods pm    ON pm.id = t.payment_method_id
WHERE b.name = 'Transport'
ORDER BY t.created_at DESC;

CREATE OR REPLACE VIEW v_transactions_detaillees AS
SELECT
    u.name AS utilisateur,
    a.description AS compte,
    tt.name AS type_transaction,

    t.description AS libelle,
    t.amount AS montant_brut,

    CASE
        WHEN tt.name = 'revenu' THEN t.amount
        WHEN tt.name = 'depense' THEN -t.amount
        ELSE 0
    END AS montant_signe,

    c.name AS categorie,
    b.name AS budget,
    o.name AS objectif,
    pm.name AS methode_paiement,
    t.status AS statut,
    DATE(t.created_at) AS date_transaction,
    DATE(t.updated_at) AS derniere_modification

FROM transactions t
INNER JOIN accounts a             ON a.id = t.account_id
INNER JOIN users u                ON u.id = a.user_id
INNER JOIN type_transactions tt   ON tt.id = t.type_transaction_id
LEFT JOIN categories c            ON c.id = t.category_id
LEFT JOIN budgets b               ON b.id = t.budget_id
LEFT JOIN objectifs o             ON o.id = t.objectif_id
LEFT JOIN payment_methods pm      ON pm.id = t.payment_method_id

ORDER BY t.created_at DESC;


SELECT * FROM v_transactions_detaillees;

SELECT *
FROM v_transactions_detaillees
WHERE utilisateur = 'Liam Santin';

SELECT *
FROM v_transactions_detaillees
WHERE type_transaction = 'depense';

SELECT *
FROM v_transactions_detaillees
WHERE budget = 'Transport';

SELECT *
FROM v_transactions_detaillees
ORDER BY montant DESC;

SELECT utilisateur, compte, type_transaction, libelle, montant_signe, date_transaction
FROM v_transactions_detaillees
ORDER BY date_transaction DESC;

-- Calculer le solde total réel
SELECT utilisateur, SUM(montant_signe) AS solde_reel
FROM v_transactions_detaillees
GROUP BY utilisateur;

-- Total dépenses par Budgets
SELECT budget, ROUND(SUM(montant_signe), 2) AS total_depense
FROM v_transactions_detaillees
WHERE type_transaction = 'depense'
GROUP BY budget;

-- verfiication
SELECT type_transaction, montant_brut, montant_signe
FROM v_transactions_detaillees
LIMIT 10;

SELECT
    tt.name AS type_transaction,
    SUM(
        CASE
            WHEN tt.name = 'revenu' THEN t.amount
            WHEN tt.name = 'depense' THEN -t.amount
            ELSE 0
        END
    ) AS impact_total
FROM transactions t
INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id
GROUP BY tt.name;

CREATE OR REPLACE VIEW v_resume_mensuel AS
SELECT
    u.name AS utilisateur,
    YEAR(t.created_at) AS annee,
    MONTH(t.created_at) AS mois,
    DATE_FORMAT(t.created_at, '%Y-%m') AS periode,

    ROUND(SUM(CASE WHEN tt.name = 'revenu' THEN t.amount ELSE 0 END), 2) AS total_revenus,
    ROUND(SUM(CASE WHEN tt.name = 'depense' THEN t.amount ELSE 0 END), 2) AS total_depenses,
    ROUND(SUM(CASE
        WHEN tt.name = 'revenu' THEN t.amount
        WHEN tt.name = 'depense' THEN -t.amount
        ELSE 0
    END), 2) AS solde_net,

    COUNT(t.id) AS nb_transactions

FROM transactions t
INNER JOIN accounts a           ON a.id = t.account_id
INNER JOIN users u              ON u.id = a.user_id
INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id

GROUP BY
    u.id, u.name,
    YEAR(t.created_at),
    MONTH(t.created_at),
    DATE_FORMAT(t.created_at, '%Y-%m')

ORDER BY annee DESC, mois DESC;

-- Voir ton résumé mois par mois
SELECT * FROM v_resume_mensuel;

-- Voir uniquement les 3 derniers mois
SELECT *
FROM v_resume_mensuel
WHERE utilisateur = 'Liam Santin'
ORDER BY annee DESC, mois DESC
LIMIT 3;

-- Voir l’évolution du solde net dans le temps
SELECT periode, solde_net
FROM v_resume_mensuel
WHERE utilisateur = 'Liam Santin'
ORDER BY periode ASC;

-- Comparer revenus vs dépenses
SELECT periode, total_revenus, total_depenses
FROM v_resume_mensuel
WHERE utilisateur = 'Liam Santin'
ORDER BY periode ASC;
