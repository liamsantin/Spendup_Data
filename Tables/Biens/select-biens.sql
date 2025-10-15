use gestion_financiere;

select * from transactions;

SELECT
  tb.nom AS type_bien,
  ROUND(SUM(b.valeur_actuelle), 2) AS valeur_totale,
  ROUND(SUM(b.revenu_annuel), 2) AS revenus_totaux,
  ROUND(SUM(b.cout_annuel), 2) AS couts_totaux
FROM biens b
INNER JOIN type_biens tb ON tb.id = b.type_bien_id
GROUP BY tb.nom
ORDER BY valeur_totale DESC;

select * from users;