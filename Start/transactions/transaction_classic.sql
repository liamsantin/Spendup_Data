use gestion_financiere;

-- Salaire mensuel (revenu)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  4300.00, 'Salaire mensuel octobre', 'confirmed',
  (SELECT id FROM categories WHERE name='Salaire'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Courses Migros (dépense)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  87.40, 'Courses Migros du week-end', 'confirmed',
  (SELECT id FROM budgets WHERE name='Budget Alimentaire'),
  (SELECT id FROM categories WHERE name='Alimentation'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

-- Restaurant (dépense loisirs)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  54.90, 'Restaurant entre amis', 'confirmed',
  (SELECT id FROM budgets WHERE name='Loisirs'),
  (SELECT id FROM categories WHERE name='Loisirs'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

-- Abonnement Netflix (dépense récurrente)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id, recurrence_transaction_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  19.90, 'Abonnement Netflix', 'confirmed',
  (SELECT id FROM budgets WHERE name='Loisirs'),
  (SELECT id FROM categories WHERE name='Loisirs'),
  (SELECT id FROM payment_methods WHERE name='virement'),
  (SELECT id FROM recurrence_transactions WHERE name='monthly')
);

select * from transactions;