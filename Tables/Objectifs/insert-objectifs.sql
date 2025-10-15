use gestion_financiere;

-- Objectif : Achat voiture
INSERT INTO objectifs (
  user_id, statut_objectif_id, name, montant_cible, progression, start_date, end_date
) VALUES (
  1,
  1,  -- en_cours
  'Achat voiture',
  12000.00,
  15.00,
  '2025-03-01',
  '2026-03-01'
);

-- Objectif : Fonds d’urgence
INSERT INTO objectifs (
  user_id, statut_objectif_id, name, montant_cible, progression, start_date
) VALUES (
  1,
  1,
  'Fonds d’urgence',
  5000.00,
  40.00,
  '2024-11-01'
);

-- Objectif : Vacances d’été 2026
INSERT INTO objectifs (
  user_id, statut_objectif_id, name, montant_cible, progression, start_date, end_date
) VALUES (
  1,
  1,
  'Vacances d’été 2026',
  3000.00,
  10.00,
  '2025-10-01',
  '2026-07-01'
);

select * from objectifs;