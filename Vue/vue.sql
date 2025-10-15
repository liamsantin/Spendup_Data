use gestion_financiere;

-- Montre le solde réel de chaque compte utilisateur,
-- calculé dynamiquement selon les transactions.
-- Utilité :
--          Permet d’afficher les soldes à jour dans ton dashboard.
--          Idéal pour un graphique “Répartition des soldes par compte”.
CREATE OR REPLACE VIEW v_solde_par_compte AS
SELECT
    a.id                     AS account_id,
    u.id                     AS user_id,
    u.name                   AS user_name,
    a.description            AS account_name,
    a.currency_code,
    a.amount                 AS solde_initial,
    COALESCE(SUM(
        CASE
            WHEN tt.name = 'revenu' THEN t.amount
            WHEN tt.name = 'depense' THEN -t.amount
            ELSE 0
        END
    ), 0) AS total_transactions,
    (a.amount + COALESCE(SUM(
        CASE
            WHEN tt.name = 'revenu' THEN t.amount
            WHEN tt.name = 'depense' THEN -t.amount
            ELSE 0
        END
    ), 0)) AS solde_final,
    a.created_at,
    a.updated_at
FROM accounts a
JOIN users u ON u.id = a.user_id
LEFT JOIN transactions t ON t.account_id = a.id
LEFT JOIN type_transactions tt ON tt.id = t.type_transaction_id
GROUP BY a.id, u.id, u.name, a.description, a.amount, a.currency_code, a.created_at, a.updated_at;

-- Compare les budgets planifiés et les dépenses réelles
-- pour chaque Budgets et utilisateur.
-- Utilité :
--      Suivre facilement les budgets dépassés ou presque atteints.
--      Parfait pour un “thermomètre de Budgets” dans une interface graphique.
CREATE OR REPLACE VIEW v_budget_vs_depenses AS
SELECT
    b.id                     AS budget_id,
    u.id                     AS user_id,
    u.name                   AS user_name,
    b.name                   AS budget_name,
    b.montant_max            AS budget_prevu,
    COALESCE(SUM(
        CASE
            WHEN tt.name = 'depense' THEN t.amount
            ELSE 0
        END
    ), 0)                    AS depense_reelle,
    (b.montant_max - COALESCE(SUM(
        CASE
            WHEN tt.name = 'depense' THEN t.amount
            ELSE 0
        END
    ), 0))                   AS reste_budget,
    ROUND(
        (COALESCE(SUM(
            CASE WHEN tt.name = 'depense' THEN t.amount ELSE 0 END
        ), 0) / b.montant_max) * 100, 2
    ) AS pourcentage_utilisation,
    b.start_date,
    b.end_date,
    b.created_at,
    b.updated_at
FROM budgets b
JOIN users u ON u.id = b.user_id
LEFT JOIN transactions t ON t.budget_id = b.id
LEFT JOIN type_transactions tt ON tt.id = t.type_transaction_id
GROUP BY b.id, u.id, u.name, b.name, b.montant_max, b.start_date, b.end_date, b.created_at, b.updated_at;

-- Suivi global des objectifs personnels avec le total accumulé.
-- Utilité :
--          Montre la progression réelle par rapport à la cible (progression_calculee).
--          Permet de repérer rapidement les objectifs atteints ou en retard.
CREATE OR REPLACE VIEW v_objectifs_progress AS
SELECT
    o.id                     AS objectif_id,
    u.id                     AS user_id,
    u.name                   AS user_name,
    o.name                   AS objectif_name,
    o.montant_cible,
    o.progression            AS progression_declared,
    COALESCE(SUM(
        CASE
            WHEN tt.name = 'revenu' THEN t.amount
            ELSE 0
        END
    ), 0)                    AS montant_economise,
    ROUND(
        (COALESCE(SUM(
            CASE WHEN tt.name = 'revenu' THEN t.amount ELSE 0 END
        ), 0) / o.montant_cible) * 100, 2
    ) AS progression_calculee,
    s.name                   AS statut,
    o.start_date,
    o.end_date,
    o.created_at,
    o.updated_at
FROM objectifs o
JOIN users u ON u.id = o.user_id
JOIN statut_objectifs s ON s.id = o.statut_objectif_id
LEFT JOIN transactions t ON t.objectif_id = o.id
LEFT JOIN type_transactions tt ON tt.id = t.type_transaction_id
GROUP BY o.id, u.id, u.name, o.name, o.montant_cible, o.progression, s.name, o.start_date, o.end_date, o.created_at, o.updated_at;

-- Vue synthétique pour tableau de bord général (solde total, total dépensé, épargné, etc.)
-- Utilité :
--          Vue “résumé financier” prête à afficher sur le tableau de bord principal.
--          Tu peux l’utiliser directement dans un graphique global ou un résumé de profil utilisateur.
CREATE OR REPLACE VIEW v_dashboard_global AS
SELECT
    u.id AS user_id,
    u.name AS user_name,
    ROUND(SUM(
        CASE
            WHEN tt.name = 'revenu' THEN t.amount
            WHEN tt.name = 'depense' THEN -t.amount
            ELSE 0
        END
    ), 2) AS balance_globale,
    ROUND(SUM(
        CASE WHEN tt.name = 'revenu' THEN t.amount ELSE 0 END
    ), 2) AS total_revenus,
    ROUND(SUM(
        CASE WHEN tt.name = 'depense' THEN t.amount ELSE 0 END
    ), 2) AS total_depenses,
    COUNT(DISTINCT a.id) AS nb_comptes,
    COUNT(DISTINCT b.id) AS nb_budgets,
    COUNT(DISTINCT o.id) AS nb_objectifs,
    u.created_at,
    u.updated_at
FROM users u
LEFT JOIN accounts a ON a.user_id = u.id
LEFT JOIN transactions t ON t.account_id = a.id
LEFT JOIN type_transactions tt ON tt.id = t.type_transaction_id
LEFT JOIN budgets b ON b.user_id = u.id
LEFT JOIN objectifs o ON o.user_id = u.id
GROUP BY u.id, u.name, u.created_at, u.updated_at;

CREATE OR REPLACE VIEW v_resume_annuel AS
SELECT
    u.name AS utilisateur,
    YEAR(t.created_at) AS annee,

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
    u.id, u.name, YEAR(t.created_at)

ORDER BY annee DESC;


CREATE OR REPLACE VIEW v_resume_par_budget AS
SELECT
    u.name AS utilisateur,
    b.name AS budget,
    b.montant_max AS montant_prevu,

    -- Total des dépenses liées à ce Budgets
    ROUND(SUM(
        CASE
            WHEN tt.name = 'depense' THEN t.amount
            ELSE 0
        END
    ), 2) AS montant_depense,

    -- Montant restant
    ROUND(b.montant_max - SUM(
        CASE
            WHEN tt.name = 'depense' THEN t.amount
            ELSE 0
        END
    ), 2) AS montant_restant,

    -- Pourcentage utilisé (sécurisé pour éviter division par zéro)
    ROUND(
        CASE
            WHEN b.montant_max > 0 THEN
                (SUM(CASE WHEN tt.name = 'depense' THEN t.amount ELSE 0 END) / b.montant_max) * 100
            ELSE 0
        END, 2
    ) AS taux_utilisation,

    COUNT(t.id) AS nb_transactions,
    b.start_date,
    b.end_date

FROM budgets b
INNER JOIN users u              ON u.id = b.user_id
LEFT JOIN transactions t        ON t.budget_id = b.id
LEFT JOIN type_transactions tt  ON tt.id = t.type_transaction_id

GROUP BY
    u.id, u.name, b.id, b.name, b.montant_max, b.start_date, b.end_date

ORDER BY taux_utilisation DESC;


select * from v_budget_vs_depenses;

SELECT *
FROM v_solde_par_compte
WHERE user_id = 1;

-- voir le résumé global de l'année
SELECT * FROM v_resume_annuel;

-- comparer revenus/dépenses sur plusieurs années
SELECT annee, total_revenus, total_depenses, solde_net
FROM v_resume_annuel
WHERE utilisateur = 'Liam Santin'
ORDER BY annee;

-- Moyenne de revenu par an
SELECT utilisateur, ROUND(AVG(total_revenus), 2) AS moyenne_revenus
FROM v_resume_annuel
GROUP BY utilisateur;

SELECT * FROM v_resume_par_budget;

-- Budget dépassé
SELECT *
FROM v_resume_par_budget
WHERE taux_utilisation > 100;

-- Voir les budgets encore valides pour le mois en cours
SELECT *
FROM v_resume_par_budget
WHERE CURDATE() BETWEEN start_date AND end_date;


-- Classement des budgets du plus utilisé au moins utilisé
SELECT utilisateur, budget, taux_utilisation
FROM v_resume_par_budget
ORDER BY taux_utilisation DESC;


CREATE OR REPLACE VIEW v_biens_resume AS
SELECT
  b.id AS bien_id,
  u.name AS utilisateur,
  b.nom,
  tb.nom AS type_bien,
  b.valeur_achat,
  b.valeur_actuelle,
  ROUND((b.valeur_actuelle - b.valeur_achat), 2) AS variation_valeur,
  b.revenu_annuel,
  b.cout_annuel,
  ROUND((b.revenu_annuel - b.cout_annuel), 2) AS resultat_net_annuel,
  b.date_acquisition,
  b.date_estimation,
  b.localisation,
  b.source_estimation,
  b.created_at,
  b.updated_at
FROM biens b
INNER JOIN users u ON u.id = b.user_id
INNER JOIN type_biens tb ON tb.id = b.type_bien_id
ORDER BY b.updated_at DESC;

select * from v_biens_resume;

