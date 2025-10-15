use gestion_financiere;

-- Solde par compte
SELECT *
FROM v_solde_par_compte
WHERE user_id = 1;

-- Budget vs dépense
select * from v_budget_vs_depenses;

-- Objectifs progression
select * from v_objectifs_progress;

-- dashboard global
select * from v_dashboard_global;

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

-- Resume par budget
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


-- Biens
select * from v_biens_resume;