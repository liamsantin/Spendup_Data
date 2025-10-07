use gestion_financiere;

-- Épargne vacances
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, payment_method_id, recurrence_transaction_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  250.00, 'Épargne vacances été 2026', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Vacances d’été 2026'),
  (SELECT id FROM payment_methods WHERE name='virement'),
  (SELECT id FROM recurrence_transactions WHERE name='monthly')
);

-- Achat d’un billet d’avion (pré-réservation)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, objectif_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  350.00, 'Acompte billet avion vacances été 2026', 'confirmed',
  (SELECT id FROM budgets WHERE name='Divertissement'),
  (SELECT id FROM objectifs WHERE name='Vacances d’été 2026'),
  (SELECT id FROM categories WHERE name='Loisirs'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

select * from budgets;