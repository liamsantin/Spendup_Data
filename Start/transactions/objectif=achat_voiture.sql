use gestion_financiere;

-- Versement vers épargne pour la voiture (objectif)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  600.00, 'Épargne mensuelle pour voiture', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Achat voiture'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Achat d’accessoires auto (dépense transport)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  89.90, 'Achat tapis et produits entretien voiture', 'confirmed',
  (SELECT id FROM budgets WHERE name='Transport'),
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

select * from transactions;
