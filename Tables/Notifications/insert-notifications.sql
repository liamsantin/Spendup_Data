use gestion_financiere;

-- 🔔 Dépassement de Budgets
INSERT INTO notifications (user_id, type, message, related_id, is_read)
VALUES
  (1, 'Budgets', 'Le Budgets **"Divertissement"** est dépassé à 116.67 %.',
   (SELECT id FROM budgets WHERE name = 'Divertissement'), FALSE),

  (1, 'Budgets', 'Le Budgets **"Transport"** atteint 95 % de sa limite, surveillez vos dépenses.',
   (SELECT id FROM budgets WHERE name = 'Transport'), FALSE);

-- 🎯 Objectif atteint
INSERT INTO notifications (user_id, type, message, related_id, is_read)
VALUES
  (1, 'objectif', 'Félicitations ! L’objectif **"Fonds d’urgence"** est désormais atteint à 100 %. 🎉',
   (SELECT id FROM objectifs WHERE name = 'Fonds d’urgence'), FALSE);

-- 💰 Progression significative d’un objectif
INSERT INTO notifications (user_id, type, message, related_id, is_read)
VALUES
  (1, 'objectif', 'Votre objectif **"Achat voiture"** a franchi le cap des 25 %. Continuez ainsi ! 🚗',
   (SELECT id FROM objectifs WHERE name = 'Achat voiture'), FALSE);

-- 📆 Rapport mensuel généré
INSERT INTO notifications (user_id, type, message, related_id, is_read)
VALUES
  (1, 'rapport', 'Le rapport mensuel d’octobre 2025 a été généré automatiquement.',
   (SELECT id FROM reports WHERE name LIKE '%Octobre 2025%'), TRUE);

select * from notifications;