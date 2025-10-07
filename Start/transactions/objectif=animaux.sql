use gestion_financiere;

-- Achat de croquettes
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  49.90, 'Croquettes premium pour chien', 'confirmed',
  (SELECT id FROM budgets WHERE name='Animaux'),
  (SELECT id FROM categories WHERE name='Alimentation'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

-- Visite vétérinaire annuelle
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  90.00, 'Visite vétérinaire annuelle', 'confirmed',
  (SELECT id FROM budgets WHERE name='Animaux'),
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);


