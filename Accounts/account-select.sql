use gestion_financiere;

SELECT id FROM Accounts WHERE user_id = 2 LIMIT 1;
SELECT t.*
        FROM transactions t
        INNER JOIN accounts a ON a.id = t.account_id
        WHERE a.user_id = 1
        ORDER BY t.created_at DESC;

