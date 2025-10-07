use gestion_financiere;

    -- Achat carburant
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  78.50, 'Plein d’essence station Coop', 'confirmed',
  (SELECT id FROM budgets WHERE name='Transport'),
  (SELECT id FROM categories WHERE name='Carburant'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

-- Cashback carte (revenu)
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='revenu'),
  5.20, 'Cashback carte bancaire', 'confirmed',
  (SELECT id FROM categories WHERE name='Salaire'),
  (SELECT id FROM payment_methods WHERE name='carte_bancaire')
);

-- Paiement facture électricité
INSERT INTO transactions (
  account_id, type_transaction_id, amount, description, status, budget_id, category_id, payment_method_id
) VALUES (
  (SELECT id FROM accounts WHERE description='Compte courant UBS'),
  (SELECT id FROM type_transactions WHERE name='depense'),
  110.25, 'Facture électricité octobre', 'confirmed',
  (SELECT id FROM budgets WHERE name='Budget Alimentaire'),
  (SELECT id FROM categories WHERE name='Transport'),
  (SELECT id FROM payment_methods WHERE name='virement')
);

select * from transactions;

CALL sp_mettre_a_jour_progression_objectifs();
CALL sp_generer_rapport_mensuel(1, 10, 2025);
SELECT * FROM reports;
