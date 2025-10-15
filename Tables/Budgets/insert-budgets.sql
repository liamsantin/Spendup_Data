-- Lier objectifs ↔ budgets
INSERT INTO objectif_budget (objectif_id, budget_id)
VALUES
  ((SELECT id FROM objectifs WHERE name='Achat voiture'),
   (SELECT id FROM budgets WHERE name='Transport')),
  ((SELECT id FROM objectifs WHERE name='Fonds d’urgence'),
   (SELECT id FROM budgets WHERE name='Santé')),
  ((SELECT id FROM objectifs WHERE name='Vacances d’été 2026'),
   (SELECT id FROM budgets WHERE name='Divertissement'));

-- Budget : Transport
INSERT INTO budgets (user_id, name, montant_max, start_date, end_date)
VALUES (1, 'Transport', 200.00, '2025-10-01', '2025-10-31');

-- Budget : Santé
INSERT INTO budgets (user_id, name, montant_max, start_date, end_date)
VALUES (1, 'Santé', 150.00, '2025-10-01', '2025-10-31');

-- Budget : Logement
INSERT INTO budgets (user_id, name, montant_max, start_date, end_date)
VALUES (1, 'Logement', 1200.00, '2025-10-01', '2025-10-31');

-- Budget : Divertissement
INSERT INTO budgets (user_id, name, montant_max, start_date, end_date)
VALUES (1, 'Divertissement', 300.00, '2025-10-01', '2025-10-31');

-- Budget : Animaux
INSERT INTO budgets (user_id, category_id, name, montant_max, start_date, end_date)
VALUES (1, 2, 'Animaux', 100.00, '2025-10-01', '2025-10-31');