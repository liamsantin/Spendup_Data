use gestion_financiere;

    -- Virement du compte courant vers l’épargne (sortie)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='transfert_interne'),
  500.00, 'Transfert vers épargne', 'confirmed',
  (SELECT id FROM payment_methods WHERE name='virement')
);

-- Réception sur le compte épargne (entrée)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, objectif_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte épargne Voyage'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  500.00, 'Réception transfert interne', 'confirmed',
  (SELECT id FROM objectifs WHERE name='Voyage au Japon'),
  (SELECT id FROM payment_methods WHERE name='virement')
);


select * from transactions;