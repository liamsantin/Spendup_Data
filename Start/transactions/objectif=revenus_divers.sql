use gestion_financiere;

-- Prime professionnelle
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  800.00, 'Prime performance trimestrielle', 'confirmed',
  (SELECT id FROM categories WHERE name='Salaire'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Remboursement assurance maladie
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  150.00, 'Remboursement assurance médicale', 'confirmed',
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

