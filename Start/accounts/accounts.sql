use gestion_financiere;

SELECT
  t.id AS transaction_id,
  u.id AS user_id,
  u.name AS user_name,
  t.description,
  t.amount
FROM transactions t
JOIN accounts a ON a.id = t.account_id
JOIN users u ON u.id = a.user_id;

delete FROM accounts where id = 8 and user_id = 3;
select * from accounts;