use gestion_financiere;

-- =====================================================================
-- OBJECTIF -> CLASSIC
-- =====================================================================
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


-- =====================================================================
-- OBJECTIF -> DIVERS
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> Transaction interne transfert
-- =====================================================================
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


-- =====================================================================
-- OBJECTIF -> ACHAT VOITURE
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> Animaux
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> fonds urgence
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> LOYER / LOGEMENT
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> REVENU DIVERS
-- =====================================================================
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

-- =====================================================================
-- OBJECTIF -> VACANCES
-- =====================================================================
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

