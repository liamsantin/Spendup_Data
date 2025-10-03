SELECT u.user_id,u.user_nom,u.user_prenom,u.user_email,u.user_password,u.user_iban,
u.user_phone,a.addr_street,a.addr_postalCode,a.addr_city,c.country_name,c.country_iso,u.user_createAt,
u.user_updateAt FROM TA_USER u 
LEFT JOIN TA_ADDRESS a ON u.addr_id = a.addr_id 
LEFT JOIN TA_COUNTRY c ON a.country_id = c.country_id;