use gestion_financiere;

-- Versement vers épargne "Voyage au Japon" (transfert interne + objectif)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  400.00, 'Épargne pour objectif Japon', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Voyage au Japon'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Retrait exceptionnel (dépense liée à un objectif)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  150.00, 'Achat valise pour le voyage', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Voyage au Japon'),
  (SELECT id FROM categories WHERE name='Loisirs'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

select * from transactions;

