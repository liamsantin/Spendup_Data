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