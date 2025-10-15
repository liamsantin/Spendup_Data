use gestion_financiere;

DELIMITER //

CREATE PROCEDURE sp_generer_rapport_mensuel(
    IN p_user_id BIGINT,
    IN p_mois INT,
    IN p_annee INT
)
BEGIN
    DECLARE v_date_debut DATE;
    DECLARE v_date_fin DATE;
    DECLARE v_total_depenses DECIMAL(12,2) DEFAULT 0;
    DECLARE v_total_revenus DECIMAL(12,2) DEFAULT 0;
    DECLARE v_solde_final DECIMAL(12,2) DEFAULT 0;
    DECLARE v_nb_transactions INT DEFAULT 0;

    -- Calcul des dates
    SET v_date_debut = STR_TO_DATE(CONCAT(p_annee, '-', LPAD(p_mois, 2, '0'), '-01'), '%Y-%m-%d');
    SET v_date_fin = LAST_DAY(v_date_debut);

    -- Calculs agrégés des revenus, dépenses et nombre de transactions
    SELECT
        IFNULL(SUM(CASE WHEN tt.name = 'depense' THEN t.amount END), 0),
        IFNULL(SUM(CASE WHEN tt.name = 'revenu' THEN t.amount END), 0),
        COUNT(*)
    INTO v_total_depenses, v_total_revenus, v_nb_transactions
    FROM transactions t
    INNER JOIN accounts a ON a.id = t.account_id
    INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id
    WHERE a.user_id = p_user_id
      AND DATE(t.created_at) BETWEEN v_date_debut AND v_date_fin;

    SET v_solde_final = v_total_revenus - v_total_depenses;

    -- Insertion du rapport mensuel
    INSERT INTO reports (
        user_id, type_report_id, name, periode_debut, periode_fin, data_json
    )
    VALUES (
        p_user_id,
        (SELECT id FROM type_reports WHERE name = 'mensuel' LIMIT 1),
        CONCAT('Rapport Mensuel ', LPAD(p_mois, 2, '0'), '/', p_annee),
        v_date_debut,
        v_date_fin,
        JSON_OBJECT(
            'total_depenses', v_total_depenses,
            'total_revenus', v_total_revenus,
            'solde_final', v_solde_final,
            'nb_transactions', v_nb_transactions
        )
    );
END;
//
DELIMITER ;

CALL sp_generer_rapport_mensuel(1, 10, 2025);
select * from reports;

DELIMITER //

CREATE PROCEDURE sp_mettre_a_jour_progression_objectifs()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_objectif_id BIGINT;
    DECLARE v_cible DECIMAL(12,2);
    DECLARE v_total_reel DECIMAL(12,2);

    -- Déclaration du curseur
    DECLARE cur CURSOR FOR
        SELECT id, montant_cible FROM objectifs;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_objectif_id, v_cible;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calcule la somme réelle (revenus liés à cet objectif)
        SELECT IFNULL(SUM(t.amount), 0)
        INTO v_total_reel
        FROM transactions t
        INNER JOIN type_transactions tt ON tt.id = t.type_transaction_id
        WHERE t.objectif_id = v_objectif_id
          AND tt.name = 'revenu';

        -- Mise à jour de la progression (évite la division par zéro)
        IF v_cible > 0 THEN
            UPDATE objectifs
            SET progression = ROUND((v_total_reel / v_cible) * 100, 2),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = v_objectif_id;
        END IF;
    END LOOP;

    CLOSE cur;
END;
//
DELIMITER ;

DELIMITER //

CREATE  PROCEDURE sp_verifier_depassement_budgets()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_user VARCHAR(255);
    DECLARE v_budget VARCHAR(255);
    DECLARE v_taux DECIMAL(6,2);
    DECLARE v_budget_id BIGINT;
    DECLARE v_user_id BIGINT;
    DECLARE v_message TEXT;

    -- Curseur : budgets dont le taux d’utilisation dépasse 100 %
    DECLARE cur CURSOR FOR
        SELECT utilisateur, budget, taux_utilisation
        FROM v_resume_par_budget
        WHERE taux_utilisation > 100;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_user, v_budget, v_taux;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Récupère l'identifiant de l'utilisateur
        SELECT id INTO v_user_id
        FROM users
        WHERE name = v_user
        LIMIT 1;

        -- Récupère l'identifiant du budget
        SELECT id INTO v_budget_id
        FROM budgets
        WHERE name = v_budget
          AND user_id = v_user_id
        LIMIT 1;

        -- Construit le message d’alerte
        SET v_message = CONCAT(
            '⚠️ Le budget "', v_budget,
            '" est dépassé à ', ROUND(v_taux, 2), ' %.'
        );

        -- Vérifie si une notification similaire existe déjà
        IF NOT EXISTS (
            SELECT 1
            FROM notifications
            WHERE user_id = v_user_id
              AND type = 'budget'
              AND related_id = v_budget_id
              AND message LIKE CONCAT('%', v_budget, '%')
        ) THEN
            -- Insère la nouvelle notification
            INSERT INTO notifications (user_id, type, message, related_id, is_read)
            VALUES (v_user_id, 'budget', v_message, v_budget_id, FALSE);
        END IF;

    END LOOP;

    CLOSE cur;
END;
//

DELIMITER ;


CALL sp_mettre_a_jour_progression_objectifs();
select * from v_objectifs_progress;

CALL sp_verifier_depassement_budgets();
SELECT * FROM notifications ORDER BY created_at DESC;


DELIMITER //

CREATE TRIGGER trg_update_budget_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE v_type VARCHAR(50);

    -- Vérifie le type de transaction
    SELECT name INTO v_type
    FROM type_transactions
    WHERE id = NEW.type_transaction_id;

    -- Si c’est une dépense liée à un budget, on met à jour le montant dépensé
    IF v_type = 'depense' AND NEW.budget_id IS NOT NULL THEN
        UPDATE budgets
        SET spent_amount = COALESCE(spent_amount, 0) + NEW.amount,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.budget_id;
    END IF;
END;
//

DELIMITER ;

