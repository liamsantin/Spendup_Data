use gestion_financiere;

-- Paiement du loyer
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id, recurrence_transaction_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  1200.00, 'Loyer appartement octobre 2025', 'confirmed',
  (SELECT id FROM budgets WHERE name='Logement'),
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='virement'),
  (SELECT id FROM recurrence_transactions WHERE name='monthly')
);

-- Entretien plomberie
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  85.00, 'Réparation robinet cuisine', 'confirmed',
  (SELECT id FROM budgets WHERE name='Logement'),
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='cash')
);

