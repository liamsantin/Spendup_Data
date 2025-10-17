-- 💸 Dépenses
INSERT INTO categories (name, type) VALUES
# ('Alimentation', 'expense'),
('Logement', 'expense'),
# ('Transport', 'expense'),
('Santé', 'expense'),
('Éducation', 'expense'),
('Divertissement', 'expense'),
('Vacances', 'expense'),
('Habillement', 'expense'),
('Communication', 'expense'),
('Assurance', 'expense'),
('Enfants', 'expense'),
('Animaux', 'expense'),
('Impôts', 'expense'),
('Épargne', 'expense'),
('Dons', 'expense'),
('Autres dépenses', 'expense');

-- 💰 Revenus
INSERT INTO categories (name, type) VALUES
('Salaire', 'income'),
('Prime', 'income'),
('Indemnités', 'income'),
('Pensions', 'income'),
('Revenus locatifs', 'income'),
('Dividendes', 'income'),
('Intérêts bancaires', 'income'),
('Vente', 'income'),
('Autres revenus', 'income');

-- 🏦 Spéciales / mixtes
INSERT INTO categories (name, type) VALUES
('Transfert interne', 'other'),
('Carte de crédit', 'other'),
('Remboursement', 'other'),
('Investissement', 'other'),
('Autre', 'other');