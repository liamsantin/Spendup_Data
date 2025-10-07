use gestion_financiere;

-- Dépôt vers fonds d’urgence
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  200.00, 'Versement mensuel fonds d’urgence', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Fonds d’urgence'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Consultation médicale (dépense santé)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  120.00, 'Consultation médecin généraliste', 'confirmed',
  (SELECT id FROM budgets WHERE name='Santé'),
  (SELECT id FROM categories WHERE name='Transport'),  -- ou crée une catégorie “Santé” si tu veux
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

select * from transactions;