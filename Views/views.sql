use spendup;

USE spendup;

-- =======================================================
-- 1️⃣ solde par compte (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_solde_par_compte AS
SELECT
    u.id AS user_id,
    a.id AS account_id,
    a.name AS account_name,
    a.balance AS base_balance,
    COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0) AS total_revenus,
    COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0) AS total_depenses,
    (a.balance
     + COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0)
     - COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0)
    ) AS solde_actuel
FROM Account a
JOIN Transaction t ON t.account_id = a.id
JOIN User u ON u.id = t.user_id
LEFT JOIN TypeTransaction tt ON tt.id = t.type_transaction_id
GROUP BY u.id, a.id, a.name, a.balance;

-- =======================================================
-- 2️⃣ budget vs dépense (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_budget_vs_depense AS
SELECT
    u.id AS user_id,
    b.id AS budget_id,
    b.name AS budget_name,
    b.max_amount AS montant_budget,
    COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0) AS total_depense,
    ROUND(
        (COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0) / b.max_amount) * 100,
        2
    ) AS taux_utilisation
FROM Budget b
JOIN User u ON u.id = b.user_id
LEFT JOIN Transaction t ON t.budget_id = b.id AND t.user_id = b.user_id
LEFT JOIN TypeTransaction tt ON tt.id = t.type_transaction_id
GROUP BY u.id, b.id, b.name, b.max_amount;

-- =======================================================
-- 3️⃣ résumé par budget (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_resume_par_budget AS
SELECT
    u.id AS user_id,
    b.id AS budget_id,
    b.name AS budget_name,
    COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0) AS total_revenus,
    COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0) AS total_depenses,
    (COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0)
     - COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0)) AS solde_budget
FROM Budget b
JOIN User u ON u.id = b.user_id
LEFT JOIN Transaction t ON t.budget_id = b.id AND t.user_id = b.user_id
LEFT JOIN TypeTransaction tt ON tt.id = t.type_transaction_id
GROUP BY u.id, b.id, b.name;

-- =======================================================
-- 4️⃣ résumé annuel (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_resume_annuel AS
SELECT
    t.user_id,
    YEAR(t.created_at) AS annee,
    COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0) AS total_revenus,
    COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0) AS total_depenses,
    (COALESCE(SUM(CASE WHEN tt.name = 'Revenu' THEN t.amount ELSE 0 END), 0)
     - COALESCE(SUM(CASE WHEN tt.name = 'Dépense' THEN t.amount ELSE 0 END), 0)) AS solde_annuel
FROM Transaction t
LEFT JOIN TypeTransaction tt ON tt.id = t.type_transaction_id
GROUP BY t.user_id, YEAR(t.created_at)
ORDER BY annee DESC;

-- =======================================================
-- 5️⃣ objectif_progress (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_objectif_progress AS
SELECT
    o.user_id,
    o.id AS objectif_id,
    o.name AS objectif_name,
    o.cible AS objectif_cible,
    o.progression AS montant_atteint,
    ROUND((o.progression / o.cible) * 100, 2) AS progression_pourcentage,
    s.name AS statut,
    o.start_date,
    o.end_date
FROM Objectif o
LEFT JOIN StatutObjectif s ON s.id = o.statut_objectif_id;

-- =======================================================
-- 6️⃣ dashboard_global (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_dashboard_global AS
SELECT
    u.id AS user_id,
    (SELECT COUNT(*) FROM Account) AS nb_comptes,
    (SELECT COUNT(*) FROM Budget WHERE user_id = u.id) AS nb_budgets,
    (SELECT COUNT(*) FROM Objectif WHERE user_id = u.id) AS nb_objectifs,
    (SELECT COUNT(*) FROM Objectif WHERE user_id = u.id AND progression >= cible) AS nb_objectifs_atteints,
    (SELECT SUM(amount) FROM Transaction t JOIN TypeTransaction tt ON tt.id = t.type_transaction_id WHERE tt.name = 'Revenu' AND t.user_id = u.id) AS total_revenus,
    (SELECT SUM(amount) FROM Transaction t JOIN TypeTransaction tt ON tt.id = t.type_transaction_id WHERE tt.name = 'Dépense' AND t.user_id = u.id) AS total_depenses,
    (SELECT SUM(balance) FROM Account) AS total_solde_comptes,
    (SELECT SUM(cible) FROM Objectif WHERE user_id = u.id) AS total_objectifs_cibles,
    (SELECT SUM(progression) FROM Objectif WHERE user_id = u.id) AS total_objectifs_progression
FROM User u;

-- =======================================================
-- 7️⃣ property_resume (par user)
-- =======================================================
CREATE OR REPLACE VIEW v_property_resume AS
SELECT
    u.id AS user_id,
    p.id AS property_id,
    p.name AS property_name,
    tp.name AS type_bien,
    p.valeur,
    p.revenu_annuel,
    p.cout_annuel,
    (p.revenu_annuel - p.cout_annuel) AS resultat_annuel,
    ROUND(((p.revenu_annuel - p.cout_annuel) / p.valeur) * 100, 2) AS rendement_percent,
    p.date_acquisition,
    p.date_estimation
FROM Property p
JOIN User u ON u.id = 1  -- ⚠️ à adapter si tu ajoutes un user_id à Property
LEFT JOIN TypeProperty tp ON tp.id = p.type_property_id;
