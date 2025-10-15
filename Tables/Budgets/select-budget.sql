use gestion_financiere;

select * from budgets;

SELECT COUNT(*)
                        FROM budgets
                        WHERE id = 2 AND user_id = 2;

ALTER TABLE budgets
MODIFY COLUMN start_date DATE NOT NULL,
MODIFY COLUMN end_date DATE NOT NULL;

describe budgets;
ALTER TABLE budgets
DROP COLUMN category_id;

ALTER TABLE budgets
ADD COLUMN category_id INT NULL AFTER user_id;


describe budgets;
