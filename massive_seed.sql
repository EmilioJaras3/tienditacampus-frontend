-- MASSIVE DATA SEED V6.1 - MASTER FINAL STABILIZATION
BEGIN;
TRUNCATE TABLE sale_details, daily_sales, inventory_records, order_items, orders, products, categories, users CASCADE;

DROP VIEW IF EXISTS vw_seller_roi CASCADE;
CREATE OR REPLACE VIEW vw_seller_roi AS
SELECT
    seller_id,
    SUM(total_investment) as global_investment,
    SUM(total_revenue) as global_revenue,
    (SUM(total_revenue) - SUM(total_investment)) as global_net_profit,
    CASE 
        WHEN SUM(total_investment) > 0 THEN ((SUM(total_revenue) - SUM(total_investment)) / SUM(total_investment)) * 100 
        ELSE 0 
    END as global_roi_pct
FROM daily_sales
GROUP BY seller_id;


DROP VIEW IF EXISTS vw_weekday_analytics CASCADE;
CREATE OR REPLACE VIEW vw_weekday_analytics AS
SELECT
    seller_id,
    EXTRACT(DOW FROM CAST(sale_date AS DATE)) as weekday_index,
    TO_CHAR(CAST(sale_date AS DATE), 'Day') as weekday_name,
    AVG(total_revenue) as avg_revenue,
    AVG(total_investment) as avg_investment,
    SUM(units_sold) as total_units_sold,
    SUM(units_lost) as total_units_lost
FROM daily_sales
GROUP BY seller_id, weekday_index, weekday_name;

INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c14d8bd9-c204-42b3-b587-197025a36c65', 'master@tienditacampus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Admin', 'Master', 'admin', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('295672f7-ad03-49be-8afc-f7e31cabbe17', 'antonio@tienditacampus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Antonio', 'de Hoyos', 'seller', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('cc8eacf6-1b44-47af-b56e-7155440212fc', 'vendedor1@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Juan', 'Perez', 'seller', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('2d037e2e-5793-4dde-adda-0e25fabea338', 'vendedor2@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Maria', 'Gomez', 'seller', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('4e47c9e2-a921-466d-9c97-9931d2d26c5e', 'vendedor3@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Luis', 'Rodriguez', 'seller', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('9bcf7717-a095-4371-892a-6a75f13d6f83', 'comprador1@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Estudiante', 'Activo', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c5ba338e-d08f-4f3d-9076-7e1c47b8135c', 'user1@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 1', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('7afb89e9-fbaa-4460-acca-d9374347a1a6', 'user2@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 2', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('763a854e-0d3b-4508-8b6e-ed2c34c44251', 'user3@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 3', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('fc22500f-9706-49cf-aa87-bd77c865d352', 'user4@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 4', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('899d489d-0050-4eca-8bbc-6e1d493f9eea', 'user5@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 5', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('71ca797d-74f8-4730-a237-4f6095ded3d7', 'user6@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 6', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', 'user7@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 7', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c24eaafc-e103-46ea-9ac5-1de1afc14eb7', 'user8@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 8', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e14d5bdc-573a-4ebf-812b-c00c8599520d', 'user9@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 9', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('ff2755b5-ee79-4b48-941e-84e272b5a91c', 'user10@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 10', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('a4ad3a63-6c13-4f2e-9412-00a2ddec5f2f', 'user11@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 11', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('4a770e52-2196-40fc-b67d-bc68a6b31847', 'user12@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 12', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('242b409f-1ea9-4a66-8361-e38c287b8a14', 'user13@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 13', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('3c50816c-affd-4654-83a2-a4fb6def7419', 'user14@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 14', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c0d14847-8ed9-4488-94d3-544a041ef967', 'user15@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 15', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('5e6b870b-bc3e-4971-a50f-2290e63e4a1b', 'user16@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 16', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('7770b1ae-6745-4595-b20d-55c49bfe1cbf', 'user17@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 17', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('b4fc7750-1b90-4a9a-93f5-a6ff19df5781', 'user18@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 18', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('97f67070-1057-4ec1-92c3-910d9d5bc3af', 'user19@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 19', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e6622482-370a-406b-bc0e-90286ffe3b92', 'user20@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 20', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('cb24793b-0741-4761-a701-e34935fcaa2b', 'user21@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 21', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('babba52c-bea0-4bad-a47c-7a9de7db3f7b', 'user22@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 22', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('83657f4f-0217-4404-ac6c-a5d70134171c', 'user23@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 23', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e9daad6c-9835-4b37-86c1-d291f93bcdd6', 'user24@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 24', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('56ae08c3-f9f2-4048-9419-962455c372a4', 'user25@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 25', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('eb421b73-922f-4bf3-9a99-daa66b7f6536', 'user26@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 26', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', 'user27@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 27', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('21bae6b5-9e4b-4c9f-94a8-258a18994657', 'user28@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 28', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('bf6d07c1-bd1e-4e6a-a0db-0e135dc8a510', 'user29@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 29', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('fbb5112a-25ab-41af-b22e-b5882da0ce8e', 'user30@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 30', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('f138596a-02ba-44f5-903c-de8f7c2f31a8', 'user31@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 31', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('94b6bcd0-476e-41f3-abbf-dbc0a7803e2b', 'user32@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 32', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('a1b26990-cf90-47ce-b96f-a8acce39cb80', 'user33@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 33', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e2c0ffe4-445e-46e2-b344-92d32301da40', 'user34@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 34', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('b38ecd5d-65dc-407f-b667-6907243d5d5e', 'user35@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 35', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('d4ef1378-99c8-477c-8dee-e83879e9d7db', 'user36@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Usuario', 'Historico 36', 'buyer', true, true, '2026-02-11T00:00:00.000Z');
INSERT INTO categories (id, name, description) VALUES ('aceac71d-f7b1-4d43-a109-f8594bb5bc0f', 'Alimentos', 'Comida casera y snacks preparados');
INSERT INTO categories (id, name, description) VALUES ('3319fb12-44f4-4bc0-8db6-4eeb87f5ed39', 'Bebidas', 'Refrescos y aguas naturales');
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('8299809d-5c1b-4df8-b31e-fcbea2d7d751', '295672f7-ad03-49be-8afc-f7e31cabbe17', 'aceac71d-f7b1-4d43-a109-f8594bb5bc0f', 'Burritos de Guisado', 'Famosos burritos de Antonio (20-30 unidades/semana)', 35, 70, true, '2026-02-11T00:00:00.000Z', true);
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, status, created_at) 
              VALUES ('d2566572-3ede-4657-8f9e-a1d29318f760', '295672f7-ad03-49be-8afc-f7e31cabbe17', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', '2026-04-11', 100, 45, 3500, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('dddbf095-34a8-42f5-b5ff-93ef240fc428', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 'aceac71d-f7b1-4d43-a109-f8594bb5bc0f', 'Torta Cubana', 'Muy bien servida', 50, 85, true, '2026-02-11T00:00:00.000Z', true);
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, status, created_at) 
              VALUES ('7a32f322-774d-4352-932e-b5b53e04cc98', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', '2026-04-11', 100, 45, 5000, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('b06d347e-209c-4c35-a97e-1efad5f3bba5', '2d037e2e-5793-4dde-adda-0e25fabea338', '3319fb12-44f4-4bc0-8db6-4eeb87f5ed39', 'Coca-Cola 600ml', 'Fría', 15, 22, true, '2026-02-11T00:00:00.000Z', true);
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, status, created_at) 
              VALUES ('21f9ddcf-2bfe-48a8-945f-d6028a59b5ba', '2d037e2e-5793-4dde-adda-0e25fabea338', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', '2026-04-11', 100, 45, 1500, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '3319fb12-44f4-4bc0-8db6-4eeb87f5ed39', 'Agua de Horchata', 'Natural 1L', 10, 25, true, '2026-02-11T00:00:00.000Z', true);
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, status, created_at) 
              VALUES ('076ca04b-e243-4c33-b247-8ce651356782', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', '2026-04-11', 100, 45, 1000, 'active', NOW());
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('64c9903d-8ed3-4d11-a063-1762533277c5', '3c50816c-affd-4654-83a2-a4fb6def7419', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0638d692-8385-40f2-948d-5eb588946abe', '64c9903d-8ed3-4d11-a063-1762533277c5', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('931f906c-a2ea-45b8-b81a-f044498dfd96', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-11', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6ad53e3a-e874-4449-ab56-3b94f00aa267', '931f906c-a2ea-45b8-b81a-f044498dfd96', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('10e5cde7-329b-4168-b9a7-4d54c3335745', 'e14d5bdc-573a-4ebf-812b-c00c8599520d', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 425, 'completed', '2026-02-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('2831de06-cc18-4d02-a0ad-c08f5ae061ed', '10e5cde7-329b-4168-b9a7-4d54c3335745', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 85, 425, '2026-02-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('af7c50dc-e3b4-4c8f-acf3-2639d2e6919d', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-11', 250, 425, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bab0d5e8-c66f-4ac8-ada1-43df3c29c5a7', 'af7c50dc-e3b4-4c8f-acf3-2639d2e6919d', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8b7a895b-e3c3-4039-8fba-0e6ce54bb78b', '899d489d-0050-4eca-8bbc-6e1d493f9eea', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-02-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3aff71a2-905c-45e8-b28c-362df61bed93', '8b7a895b-e3c3-4039-8fba-0e6ce54bb78b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-02-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('36b12fb2-cbee-4e25-91ab-beeda4cbe94c', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-11', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('43ed27d5-8e5c-4565-b28d-135afdd820be', '36b12fb2-cbee-4e25-91ab-beeda4cbe94c', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('36a19dde-a6a2-4a03-949d-7d52730c8017', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-02-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3fe917ee-7a85-4a6e-abe7-05d9aa67cd0e', '36a19dde-a6a2-4a03-949d-7d52730c8017', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-02-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('80b3cadc-6da5-4736-9b36-ca0ed0dca669', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-11', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('edb59c56-3125-4bce-900c-a1f990dd6544', '80b3cadc-6da5-4736-9b36-ca0ed0dca669', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9ed5fba7-cbbe-4d8e-aa43-cbec12654207', 'cb24793b-0741-4761-a701-e34935fcaa2b', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('6696b162-2a1b-4a8c-b183-fefbe902784d', '9ed5fba7-cbbe-4d8e-aa43-cbec12654207', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('16a7cb7e-d7d4-4e9e-9f43-7eead7d8302f', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-12', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c2117453-92d2-4b6e-ad3d-306acaeb9460', '16a7cb7e-d7d4-4e9e-9f43-7eead7d8302f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4821e2f3-a0c2-43d3-821a-76eab94a7ef8', 'b4fc7750-1b90-4a9a-93f5-a6ff19df5781', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 425, 'completed', '2026-02-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('65bcb5e3-85f5-4129-8dd6-f46b71668c25', '4821e2f3-a0c2-43d3-821a-76eab94a7ef8', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 85, 425, '2026-02-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d23ba985-cb6a-429f-81c6-c9f45284d38c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-12', 250, 425, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2c9ebc69-6ea8-4be8-b079-824bab464935', 'd23ba985-cb6a-429f-81c6-c9f45284d38c', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('41ef0b5b-a656-4d9e-84a4-76b8ea47a04b', 'c0d14847-8ed9-4488-94d3-544a041ef967', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-02-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('87036a3f-8345-4626-98c4-46422c4848f7', '41ef0b5b-a656-4d9e-84a4-76b8ea47a04b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-02-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('85665815-f08b-4b25-a380-a5d23013d454', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-12', 105, 132, 6, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('49126451-c558-454b-b40a-bbc3d4ce796c', '85665815-f08b-4b25-a380-a5d23013d454', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 6, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4674ff96-acba-4ef0-8657-ca2b7da402d7', 'a1b26990-cf90-47ce-b96f-a8acce39cb80', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('259a08ab-5a89-47be-a2cb-a06a7cfd44f1', '4674ff96-acba-4ef0-8657-ca2b7da402d7', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('639eed57-1e07-48d0-ae1a-febf91494b24', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-12', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('10969185-e64a-41ed-b502-843c992a96da', '639eed57-1e07-48d0-ae1a-febf91494b24', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ea5c741e-2bd1-4d7f-90b4-e9ca3a3c33c3', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('36170ce2-7394-4178-8056-57d28263fa1e', 'ea5c741e-2bd1-4d7f-90b4-e9ca3a3c33c3', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('2fc7481a-0735-43b1-9ce4-2125ea5bdd92', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-13', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('08124435-0fe7-4248-882e-caaa1084fe97', '2fc7481a-0735-43b1-9ce4-2125ea5bdd92', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('519e3fc2-ec00-499c-9762-cdc8cf80ba31', '94b6bcd0-476e-41f3-abbf-dbc0a7803e2b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-02-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('362c5c37-f744-4a80-b63a-94bf3cfe259b', '519e3fc2-ec00-499c-9762-cdc8cf80ba31', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-02-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('58c72f71-99c6-40e9-882e-c433ecac5b2e', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-13', 250, 340, 4, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5fdd8ff0-48cb-4a8b-a476-7b51b9253860', '58c72f71-99c6-40e9-882e-c433ecac5b2e', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 4, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('dff5bfb5-0b24-4cf9-82d2-0baaa7446611', '3c50816c-affd-4654-83a2-a4fb6def7419', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-02-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('35aa47c8-5688-4a8e-8220-6a471c6dc618', 'dff5bfb5-0b24-4cf9-82d2-0baaa7446611', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-02-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('7f3c8fc9-5023-4cca-a809-e5652ef545ab', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-13', 45, 66, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b0408f06-c9bc-448e-9df2-a5e9d8b8ef3b', '7f3c8fc9-5023-4cca-a809-e5652ef545ab', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 3, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('89a4f801-24ef-4ae2-9cee-55c9030c8030', '83657f4f-0217-4404-ac6c-a5d70134171c', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c705e4f3-6a45-4ad1-9d88-82bdd1d3b8f9', '89a4f801-24ef-4ae2-9cee-55c9030c8030', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c38f1042-ff85-452f-8116-bb5c07325731', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-13', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dcd08b68-e8c6-4bf1-bdba-b26fffb81b57', 'c38f1042-ff85-452f-8116-bb5c07325731', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4e015a53-8746-4c6f-a9c9-3f5e5b4b4ac6', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('fba79609-7fd3-4f37-9bec-cfcfc08d4155', '4e015a53-8746-4c6f-a9c9-3f5e5b4b4ac6', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c8a5974d-69d8-43dd-b3cf-f022a0035276', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-14', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f1032b74-fb04-4150-a71b-614a952f9821', 'c8a5974d-69d8-43dd-b3cf-f022a0035276', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c46cc799-22c7-47f0-915c-522c82773926', '7afb89e9-fbaa-4460-acca-d9374347a1a6', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-02-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a2b27c76-7c7b-4164-a7c2-6adc0999e8b4', 'c46cc799-22c7-47f0-915c-522c82773926', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-02-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('10cb5a68-3eed-4e31-b352-1e812180e3b4', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-14', 250, 340, 4, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be0046fd-4a18-4f67-b1e8-c6a33e9f27bd', '10cb5a68-3eed-4e31-b352-1e812180e3b4', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 4, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4e5d98c5-2aaa-4755-a6a5-43fe63b10e1c', 'b4fc7750-1b90-4a9a-93f5-a6ff19df5781', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-02-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('990cd11c-4899-4633-a477-8783517ab20d', '4e5d98c5-2aaa-4755-a6a5-43fe63b10e1c', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-02-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('87b75342-11ea-4cf9-b7d3-98e423458e41', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-14', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('68565941-56fa-4c10-b8a6-edba8f576d0c', '87b75342-11ea-4cf9-b7d3-98e423458e41', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d7a91763-a0a8-4711-85ca-a6e983c696a5', 'eb421b73-922f-4bf3-9a99-daa66b7f6536', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-02-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0fc88210-3690-4a6f-a9ba-ff650d3032d2', 'd7a91763-a0a8-4711-85ca-a6e983c696a5', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-02-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('bb5eefa8-3c7b-4021-ae63-24811f022a36', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-14', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('03e41ffc-a0f0-4c7a-bd42-615ea11974d7', 'bb5eefa8-3c7b-4021-ae63-24811f022a36', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8a39553f-9f15-405f-9e05-e84dc82e4966', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-02-15T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1977493d-3e1c-48cf-b8dc-2ed8e7354760', '8a39553f-9f15-405f-9e05-e84dc82e4966', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-02-15T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('fabe9f97-da42-470b-9ab9-1c05a8ae9c6d', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-15', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('53db0e45-933a-404e-abef-72f32a09bf43', 'fabe9f97-da42-470b-9ab9-1c05a8ae9c6d', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('965aa506-1068-40d3-8b3a-6b1b086daf9a', 'a1b26990-cf90-47ce-b96f-a8acce39cb80', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-02-16T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c377878a-1867-46dc-9c4d-f126801b251a', '965aa506-1068-40d3-8b3a-6b1b086daf9a', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-02-16T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('5a6b00ac-0354-4014-9497-8498932e156a', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-16', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('29b475bf-e9b3-4dc1-ba88-8495b13b9ef2', '5a6b00ac-0354-4014-9497-8498932e156a', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a8666687-f657-4d6a-9b3d-469ad0f53c46', '3c50816c-affd-4654-83a2-a4fb6def7419', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-02-16T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a4415cee-e5ee-4f21-a282-725b560532e6', 'a8666687-f657-4d6a-9b3d-469ad0f53c46', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-02-16T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f77dbbd7-36db-46b5-8bac-e60fdeaf3f36', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-16', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6ee47d4c-40b5-4adf-b1da-a8fe232d7964', 'f77dbbd7-36db-46b5-8bac-e60fdeaf3f36', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('60f937e6-c06e-438d-a69e-4ed1e783374d', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('19ff7cd2-3e1b-4881-940b-cefa915faeac', '60f937e6-c06e-438d-a69e-4ed1e783374d', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c76a6424-8519-4884-9740-5006fad5333f', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-17', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8cc157e4-0893-42fb-bb87-8b6517cea5e9', 'c76a6424-8519-4884-9740-5006fad5333f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a8e9d851-5980-4011-bfc5-a15012d64155', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-02-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c893b2fd-a1fb-43eb-8aae-fbc8fe7e0c40', 'a8e9d851-5980-4011-bfc5-a15012d64155', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-02-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('5fc07a61-3f8b-4e33-b755-0478974bb9f7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-17', 200, 340, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('99eaa985-0978-47de-bcee-6b339596aec5', '5fc07a61-3f8b-4e33-b755-0478974bb9f7', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 4, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('33fc9f92-f331-4c6b-93ba-f8c27201bcaa', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-02-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3ac1ccd3-19b1-4dfa-9b79-18415ba0e49b', '33fc9f92-f331-4c6b-93ba-f8c27201bcaa', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-02-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a7ddd174-4c8a-4940-8124-09af6f678d38', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-17', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('387b6a40-5440-4633-9c40-a265492c1b18', 'a7ddd174-4c8a-4940-8124-09af6f678d38', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a97a510a-7170-4f9c-9331-88f0a53eae25', 'c0d14847-8ed9-4488-94d3-544a041ef967', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-02-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('8db8fcbe-0730-4305-bc5d-ccd69f6df1de', 'a97a510a-7170-4f9c-9331-88f0a53eae25', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-02-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9738b47c-9690-44e2-940a-22d70b7b2f60', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-17', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9e40dabe-79c5-4d0d-a8b5-3155053ea65f', '9738b47c-9690-44e2-940a-22d70b7b2f60', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('45184c7a-2211-4eb6-a960-b257df15dc83', '71ca797d-74f8-4730-a237-4f6095ded3d7', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('5e764f83-ae29-4b96-99a4-8302c68008e7', '45184c7a-2211-4eb6-a960-b257df15dc83', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('94eca0e0-257d-4166-a47a-cfe2cf9a6fa5', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-18', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b399fa36-076e-498b-8cd1-5c7f065c9fd3', '94eca0e0-257d-4166-a47a-cfe2cf9a6fa5', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('064d3785-b596-4352-b69d-2f6dbccc6e05', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-02-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cab57b34-3515-493e-827d-f991c6f8c962', '064d3785-b596-4352-b69d-2f6dbccc6e05', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-02-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c6f71b9a-3eb3-46ba-a839-ddf1a193afb6', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-18', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a61cdeb3-f4d3-45ab-80b8-b17333a78442', 'c6f71b9a-3eb3-46ba-a839-ddf1a193afb6', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('58b2185a-d080-4e96-8bdc-0b676c2cb992', 'b4fc7750-1b90-4a9a-93f5-a6ff19df5781', '2d037e2e-5793-4dde-adda-0e25fabea338', 44, 'completed', '2026-02-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c1c121bb-c086-401a-a63e-9de4dbe75931', '58b2185a-d080-4e96-8bdc-0b676c2cb992', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 2, 22, 44, '2026-02-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9dd2311a-6141-4c4c-92f7-b55fe3d594fe', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-18', 45, 44, 2, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fa842ef8-fa62-4fea-9173-c83edc403b05', '9dd2311a-6141-4c4c-92f7-b55fe3d594fe', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 2, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('b372e03f-9d95-41ca-80b3-5da87a744761', 'b38ecd5d-65dc-407f-b667-6907243d5d5e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('ffd207cf-e9e5-4414-b9f7-8db0bbff6d26', 'b372e03f-9d95-41ca-80b3-5da87a744761', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('753db803-ad7a-4382-9598-0186b2861a3d', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-18', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a0527d71-50f6-4978-9075-236e463cb5f3', '753db803-ad7a-4382-9598-0186b2861a3d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('882711cb-5987-4222-9626-bfdbe8c8ffc4', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('13b6f4cf-47ec-4d02-9f23-edb9cb81e5db', '882711cb-5987-4222-9626-bfdbe8c8ffc4', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('15692e92-926d-4836-a612-18cb973b6df6', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-19', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('db97b5ec-72c7-4b13-8fae-861d3c885291', '15692e92-926d-4836-a612-18cb973b6df6', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('2595480e-75e1-48e0-8112-6e1f69f5b9dc', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-02-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('fa6ea816-b4e7-4299-9b99-67f07b35ce75', '2595480e-75e1-48e0-8112-6e1f69f5b9dc', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-02-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f72847d7-7ff5-4f55-b6a4-00899924fb1e', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-19', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('94a0a5cc-29e3-4145-a266-b2d8bbada8d2', 'f72847d7-7ff5-4f55-b6a4-00899924fb1e', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('40406f00-b7bb-43e3-b9bc-265779b8c8c2', 'd4ef1378-99c8-477c-8dee-e83879e9d7db', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-02-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('48ca5f5f-e5dd-4a23-a2ae-d47eb27b6d0b', '40406f00-b7bb-43e3-b9bc-265779b8c8c2', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-02-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c7b7b643-7038-4433-97fe-5f1780dbfd5c', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-19', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a8184d00-e69c-42ae-9657-4b5df37c01c3', 'c7b7b643-7038-4433-97fe-5f1780dbfd5c', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c32cdc3c-9b12-4d65-8519-c1226d76f78b', 'e6622482-370a-406b-bc0e-90286ffe3b92', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0b781e3a-8b67-4af8-ad31-be061482de15', 'c32cdc3c-9b12-4d65-8519-c1226d76f78b', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('06ef0ad5-db18-4781-b4ac-40e41b8819c5', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-19', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3396c17c-e97d-4469-a08a-e108dce43688', '06ef0ad5-db18-4781-b4ac-40e41b8819c5', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('1636cb1a-78c5-4828-ad49-cfbe18825c07', 'bf6d07c1-bd1e-4e6a-a0db-0e135dc8a510', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('ba2da641-1ebd-457a-9f17-6b9a41d0fa07', '1636cb1a-78c5-4828-ad49-cfbe18825c07', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ac62a3df-cfd4-4c3b-bafb-d19cb56041eb', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-20', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b29afe21-cf5e-4bfd-b447-88cba1fd080c', 'ac62a3df-cfd4-4c3b-bafb-d19cb56041eb', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4635457e-37e5-4bd3-a12a-473fb4da3fc4', '56ae08c3-f9f2-4048-9419-962455c372a4', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-02-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('b6b5f10d-5113-4888-aed1-000d3d3ba0f8', '4635457e-37e5-4bd3-a12a-473fb4da3fc4', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-02-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1ae04d70-601a-4917-adc9-d4b365136936', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-20', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('baaae37a-7ac6-47cc-adf3-579450df878b', '1ae04d70-601a-4917-adc9-d4b365136936', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('7ec6781a-cebc-4ce9-a881-e53c42f2b045', '71ca797d-74f8-4730-a237-4f6095ded3d7', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-02-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a138266d-d85a-4ea6-b646-2739fdc4af96', '7ec6781a-cebc-4ce9-a881-e53c42f2b045', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-02-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e146ab8e-a557-4977-a6e6-c04c517acb57', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-20', 75, 110, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c00047e2-2338-489f-9f44-73c9cedd9907', 'e146ab8e-a557-4977-a6e6-c04c517acb57', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 5, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('328486b0-84ca-413f-9c04-eb3dd382cbd8', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('68c1a992-0951-4b78-8702-2668b0ecaf53', '328486b0-84ca-413f-9c04-eb3dd382cbd8', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f829daf4-8382-4ac2-9b93-444627aefd07', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-20', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0f413ca2-797d-445e-a34b-a4363750d889', 'f829daf4-8382-4ac2-9b93-444627aefd07', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d97b3adc-d27a-4f8c-a68c-b9e398239732', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('41ff1fb0-fc5f-426d-8e9a-f846b682f2a4', 'd97b3adc-d27a-4f8c-a68c-b9e398239732', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('b42771dd-f668-474a-8e3f-6c9efe05ec7f', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-21', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cfe08b4f-a9f3-4918-a418-e18c79a85b35', 'b42771dd-f668-474a-8e3f-6c9efe05ec7f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('669fefcd-68d1-4b66-aa71-cd460d82f086', 'cb24793b-0741-4761-a701-e34935fcaa2b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-02-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('5ecf1966-3861-4b4c-9797-d2e3b08de0f1', '669fefcd-68d1-4b66-aa71-cd460d82f086', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-02-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('4142ffa1-d14f-4b0d-a778-2757171cc7cb', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-21', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('42b0b19f-f224-4b4a-a1a1-173831049050', '4142ffa1-d14f-4b0d-a778-2757171cc7cb', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e120e959-0d54-43b0-8cd9-17aa49cafa5a', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', '2d037e2e-5793-4dde-adda-0e25fabea338', 44, 'completed', '2026-02-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('77ab720e-ac8f-4f82-b2b2-9c6d2839bf83', 'e120e959-0d54-43b0-8cd9-17aa49cafa5a', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 2, 22, 44, '2026-02-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('bcc39e33-00db-4dd0-8d4d-ed63b5d78988', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-21', 45, 44, 2, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('856da78f-b341-4084-8965-6a780a073c20', 'bcc39e33-00db-4dd0-8d4d-ed63b5d78988', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 2, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('45a8bcec-e4ad-42b4-970a-7fa547407fca', '71ca797d-74f8-4730-a237-4f6095ded3d7', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-02-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('9d50d47f-a326-497f-be39-fff6b78f2621', '45a8bcec-e4ad-42b4-970a-7fa547407fca', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-02-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('48c825d1-5472-47c9-b78f-747853ba654d', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-21', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('43b8b0a0-1b41-49ab-8542-d3d469c2bf2e', '48c825d1-5472-47c9-b78f-747853ba654d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d779c441-ffe2-483c-a655-e36079871405', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-22', 50, 0, 0, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ebf4abb7-54a2-4bcc-8b37-deec2f55ffd8', 'd779c441-ffe2-483c-a655-e36079871405', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 0, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('32e3f4a5-cabe-4a90-815a-2e3d0543af95', 'ff2755b5-ee79-4b48-941e-84e272b5a91c', '2d037e2e-5793-4dde-adda-0e25fabea338', 22, 'completed', '2026-02-23T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c8ac32ac-0e16-4ea9-accd-ea8af663f31b', '32e3f4a5-cabe-4a90-815a-2e3d0543af95', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 22, 22, '2026-02-23T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9794f731-141d-4cfb-b48c-ab2622ec586a', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-23', 15, 22, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fddd3c26-8eb9-40ae-ad4e-fb5657403972', '9794f731-141d-4cfb-b48c-ab2622ec586a', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 1, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9e0d5943-ad62-4739-b58e-dfd2d548c773', 'ff2755b5-ee79-4b48-941e-84e272b5a91c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cd833a13-b7ef-44ca-b9ec-aaffb5e48495', '9e0d5943-ad62-4739-b58e-dfd2d548c773', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('6af64405-c259-4d8a-9edf-e06c4d450129', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-24', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e214cd90-4c96-4137-ba3d-61688ff89bae', '6af64405-c259-4d8a-9edf-e06c4d450129', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('30b6a3da-ceac-4749-aabe-11caa50eacb4', 'e9daad6c-9835-4b37-86c1-d291f93bcdd6', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-02-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('fdc3e0d0-a439-47d8-baee-b5f6ba4041ab', '30b6a3da-ceac-4749-aabe-11caa50eacb4', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-02-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d742e5fa-f436-44ef-bdd6-550f6fc21e4b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-24', 200, 340, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f2ed4562-fb4d-40e4-ae79-e5d2ea6fccb2', 'd742e5fa-f436-44ef-bdd6-550f6fc21e4b', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 4, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f967f041-e157-4866-a69d-567fff877917', 'e9daad6c-9835-4b37-86c1-d291f93bcdd6', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-02-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1340cf67-b404-4a2c-bb77-9bfa85d4a651', 'f967f041-e157-4866-a69d-567fff877917', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-02-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('aacbbb36-fa9e-4aca-a509-3d2a1d85b435', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-24', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c220a01d-ad70-4a9c-9629-19b299727060', 'aacbbb36-fa9e-4aca-a509-3d2a1d85b435', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('cb73dd35-ddb9-43d5-ac68-251d09a16428', '242b409f-1ea9-4a66-8361-e38c287b8a14', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-02-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('14406b7d-317d-47a5-90cd-5a7d5284d29f', 'cb73dd35-ddb9-43d5-ac68-251d09a16428', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-02-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ed62b07b-8462-47b7-9be7-95b624d48560', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-24', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('00e467c9-610e-4e38-8ef1-64e774c29e8c', 'ed62b07b-8462-47b7-9be7-95b624d48560', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('988cb694-2bcf-4d01-8801-c4a7b7db79c0', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('4cd5e864-7693-43a5-a26b-a2e91e20425b', '988cb694-2bcf-4d01-8801-c4a7b7db79c0', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f4d08058-c406-4cf7-a4ff-e07bcc66e92c', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-25', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('89e7b462-dc59-421f-8f0e-505f44947461', 'f4d08058-c406-4cf7-a4ff-e07bcc66e92c', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('5d24c664-bd4d-49de-b465-376cf9d649f6', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 170, 'completed', '2026-02-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3865dd02-afdb-4ccc-a1f9-64137bc8f1eb', '5d24c664-bd4d-49de-b465-376cf9d649f6', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 2, 85, 170, '2026-02-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c559f0d1-5af2-4f20-9a24-739dbef6703b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-25', 150, 170, 2, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8f67ec07-e20a-4821-b1ad-cf884447f582', 'c559f0d1-5af2-4f20-9a24-739dbef6703b', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 2, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('3e4e237f-b0e3-41e8-8b45-f48a18e6b802', 'a4ad3a63-6c13-4f2e-9412-00a2ddec5f2f', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-02-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('6745eff8-7aa4-4168-808d-aed20be7fe6f', '3e4e237f-b0e3-41e8-8b45-f48a18e6b802', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-02-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('51dbe2da-c1c6-4d09-ab89-d0b38aed0326', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-25', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('294cc834-d71c-4820-9367-3adcc1c5735a', '51dbe2da-c1c6-4d09-ab89-d0b38aed0326', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d47043ba-9ee2-4719-9733-e87493755042', '763a854e-0d3b-4508-8b6e-ed2c34c44251', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-02-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('61f5bf43-44aa-4a08-9a32-1018520c768f', 'd47043ba-9ee2-4719-9733-e87493755042', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-02-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a00a4480-f637-4b06-899a-a44f38f790df', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-25', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('349d8cfa-1e3a-41aa-8460-f94013f13c7d', 'a00a4480-f637-4b06-899a-a44f38f790df', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('10ff8d7f-5330-4d8f-8d13-acaa2726b3b0', 'e2c0ffe4-445e-46e2-b344-92d32301da40', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('4a0062a4-3eb7-4864-a673-23e2e6e355bd', '10ff8d7f-5330-4d8f-8d13-acaa2726b3b0', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f4126409-871c-4f55-82f5-ef8ff9c2cac2', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-26', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('96e4cf48-0ace-49dc-89db-71560d66bf9e', 'f4126409-871c-4f55-82f5-ef8ff9c2cac2', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4eb17390-4454-4d0b-8d64-7f97b3249d44', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-02-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('88c9b15f-3c2f-4b39-a793-c39fed970770', '4eb17390-4454-4d0b-8d64-7f97b3249d44', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-02-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('7deb770a-27c4-4ac2-8d24-5225f3d82307', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-26', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b50c254f-8af6-4cd2-b903-4c98bd846fc5', '7deb770a-27c4-4ac2-8d24-5225f3d82307', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e3943d9a-fb1d-4919-9529-560eff81fac6', 'e6622482-370a-406b-bc0e-90286ffe3b92', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-02-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('df22b7d4-20ad-4d73-92cb-2e2df376062e', 'e3943d9a-fb1d-4919-9529-560eff81fac6', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-02-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a75eb77d-0d68-49d7-b1fa-eb8cf0bb3aee', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-26', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1f1fb36a-75a0-401c-9c27-03a2a83ead86', 'a75eb77d-0d68-49d7-b1fa-eb8cf0bb3aee', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('92dd87a7-292e-438e-b842-af62f560f41a', '242b409f-1ea9-4a66-8361-e38c287b8a14', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-02-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('de8ce500-dff0-4652-b679-d9af0f6af64a', '92dd87a7-292e-438e-b842-af62f560f41a', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-02-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('00244ff4-1f25-475a-9d73-edb173314a18', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-26', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('498e78f2-a903-4002-8044-8cd2b37f5517', '00244ff4-1f25-475a-9d73-edb173314a18', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c72babf8-ef90-4b6a-9266-f7bae297aefa', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-02-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cb4a2893-adc7-4f6b-abb4-2cc3fbbb3547', 'c72babf8-ef90-4b6a-9266-f7bae297aefa', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-02-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ebfe6d10-cab6-4cda-861c-5acd6406c368', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-27', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('62ff569b-11dc-4073-a63a-593e2b7dfd00', 'ebfe6d10-cab6-4cda-861c-5acd6406c368', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('deba9b4b-0a18-4677-b834-2b9794c0843b', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 425, 'completed', '2026-02-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a2062663-0545-4376-aed9-652367c22222', 'deba9b4b-0a18-4677-b834-2b9794c0843b', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 85, 425, '2026-02-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('120be74f-02f1-4954-92eb-2e3dca25c547', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-27', 250, 425, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('00499021-968f-452d-92b0-b98de0329fa8', '120be74f-02f1-4954-92eb-2e3dca25c547', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('423007cf-0448-4543-b292-a99c7ecd89b0', 'fbb5112a-25ab-41af-b22e-b5882da0ce8e', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-02-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1f22410f-2369-443f-b204-726e404f9e62', '423007cf-0448-4543-b292-a99c7ecd89b0', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-02-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a2f9f74d-2c14-4e91-bdba-85dda1812fcd', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-27', 75, 110, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4a57116f-a6ba-49d4-b373-fc6b8e57e230', 'a2f9f74d-2c14-4e91-bdba-85dda1812fcd', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 5, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4c61db06-e70c-4952-801a-65173506afa2', '3c50816c-affd-4654-83a2-a4fb6def7419', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-02-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cc40653a-e533-416d-b6cb-e020605f56e7', '4c61db06-e70c-4952-801a-65173506afa2', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-02-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9e10a0c2-320b-4936-b527-c6f0828aeb1e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-27', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f681d59f-f3f6-4bb5-a05d-393fadd716a4', '9e10a0c2-320b-4936-b527-c6f0828aeb1e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f5bb1ce2-bb5d-48eb-927f-e8f5666b32e8', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 210, 'completed', '2026-02-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('997516b6-90e7-424c-8d2f-595bf3381c85', 'f5bb1ce2-bb5d-48eb-927f-e8f5666b32e8', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 3, 70, 210, '2026-02-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('4919380a-5706-4514-a210-750e5c96c567', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-02-28', 140, 210, 3, 1, 35, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('029b59fa-3c29-463f-9315-45710d112b13', '4919380a-5706-4514-a210-750e5c96c567', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 3, 1, 35, 70, 35, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f6e049b8-796b-4747-9d2b-c61eb79eb3e1', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-02-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('8fa5dc5b-c43f-4eab-994f-9a7e3b65b6f0', 'f6e049b8-796b-4747-9d2b-c61eb79eb3e1', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-02-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a600b088-5301-4868-9c25-3d448feb6cb9', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-02-28', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9889580a-5164-4ab4-b518-18794f216b91', 'a600b088-5301-4868-9c25-3d448feb6cb9', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('462e445f-7dab-4b5b-9ed7-27f06088dd8c', 'e6622482-370a-406b-bc0e-90286ffe3b92', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-02-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('2d5141e9-1a99-4fbe-87cb-5cce8e438488', '462e445f-7dab-4b5b-9ed7-27f06088dd8c', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-02-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c0aca320-0523-494f-8763-7b82c5c09373', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-02-28', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('860f8d7f-268f-49bd-95b2-b239be4e64d9', 'c0aca320-0523-494f-8763-7b82c5c09373', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('08ecfdb8-adb9-4ec0-bd83-602efe88dff6', '763a854e-0d3b-4508-8b6e-ed2c34c44251', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-02-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3b65cce1-cce5-45df-b3c9-2a899b6ffd11', '08ecfdb8-adb9-4ec0-bd83-602efe88dff6', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-02-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('8a4131fd-4c0a-4132-bc86-2a432cb8f80b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-02-28', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5205bac4-3fc0-4253-8ea4-5afaed4d5b98', '8a4131fd-4c0a-4132-bc86-2a432cb8f80b', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('29f85209-00fd-414b-90d4-78f64a6d5589', 'fc22500f-9706-49cf-aa87-bd77c865d352', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-03-01T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('91848ff7-4137-406e-b2cc-7f58144f80f9', '29f85209-00fd-414b-90d4-78f64a6d5589', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-03-01T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('2f6a7b18-6ff1-4e30-889a-396eee8bcab2', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-01', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('46475bbf-3463-486e-8e6e-531baf826754', '2f6a7b18-6ff1-4e30-889a-396eee8bcab2', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('62c74f6e-8431-46e3-8ede-6945dbb9377b', 'fbb5112a-25ab-41af-b22e-b5882da0ce8e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-03-01T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cce8f303-1161-4638-b50c-73d0658ae203', '62c74f6e-8431-46e3-8ede-6945dbb9377b', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-03-01T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('fcbffbfd-6630-4fa0-ad4a-f12738018508', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-01', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e40b02a0-a453-4987-bd59-b2cde075968c', 'fcbffbfd-6630-4fa0-ad4a-f12738018508', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('57cb7b2e-b803-4e47-a3c3-4b9e9be4a46b', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-03-02T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1740c277-7a6a-4b47-9864-3df395e2fd9b', '57cb7b2e-b803-4e47-a3c3-4b9e9be4a46b', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-03-02T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('8ee4a1d6-5635-4bf1-baf6-72aab3984b1f', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-02', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('78124d55-c55d-4b22-ac44-4040ca99c331', '8ee4a1d6-5635-4bf1-baf6-72aab3984b1f', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ccfcb643-83dd-4c56-b272-3c90b246893d', 'b4fc7750-1b90-4a9a-93f5-a6ff19df5781', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-03T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('bcaf4b80-49ca-42de-919c-c0347cc665d8', 'ccfcb643-83dd-4c56-b272-3c90b246893d', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-03T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('fb0a9955-aec2-4bf7-b571-6e1e7030e38b', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-03', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ee5b68c5-7221-4b0e-af70-edc0d6686f8b', 'fb0a9955-aec2-4bf7-b571-6e1e7030e38b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('83db1062-9ad8-4b1f-86b6-48d0d8dbe296', 'c0d14847-8ed9-4488-94d3-544a041ef967', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 255, 'completed', '2026-03-03T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('f0a68712-8d67-4067-bc66-286750909977', '83db1062-9ad8-4b1f-86b6-48d0d8dbe296', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 85, 255, '2026-03-03T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c63ef5e2-7913-4502-b3cb-8deb01f1902f', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-03', 200, 255, 3, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0a2dd45e-b518-4465-ad10-35fa89a6bbe1', 'c63ef5e2-7913-4502-b3cb-8deb01f1902f', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 3, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f3d3dfe4-a282-453e-9bd4-061784abc599', 'ff2755b5-ee79-4b48-941e-84e272b5a91c', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-03-03T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0f7f4d38-33ea-4433-8db8-cc90acbb7038', 'f3d3dfe4-a282-453e-9bd4-061784abc599', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-03-03T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('324f9aff-f32e-499b-b561-75e22fa382e4', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-03', 75, 110, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('376a2789-47d1-4fda-b55e-82957f0a0b00', '324f9aff-f32e-499b-b561-75e22fa382e4', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 5, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a5be60ba-cf07-4c5d-a496-f8e552b3ece6', 'a4ad3a63-6c13-4f2e-9412-00a2ddec5f2f', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-03-03T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('ab0c8db8-f15d-45ef-bd73-cfde1cfef01f', 'a5be60ba-cf07-4c5d-a496-f8e552b3ece6', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-03-03T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('5901f86b-2d43-40c1-94fc-482f07be683e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-03', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e06138cf-7885-40df-b38f-b4a5b70fe575', '5901f86b-2d43-40c1-94fc-482f07be683e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9b21cc80-ac09-49da-b152-756cb77d0f82', '56ae08c3-f9f2-4048-9419-962455c372a4', '295672f7-ad03-49be-8afc-f7e31cabbe17', 210, 'completed', '2026-03-04T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('aab28825-891a-42f4-bb7d-a0e8647bd114', '9b21cc80-ac09-49da-b152-756cb77d0f82', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 3, 70, 210, '2026-03-04T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e7de7fb2-de36-4904-bf98-a3f5bb2fe30f', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-04', 140, 210, 3, 1, 35, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0caecf62-79b1-4ad7-9e23-d2b4b10136c3', 'e7de7fb2-de36-4904-bf98-a3f5bb2fe30f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 3, 1, 35, 70, 35, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('80e63394-0982-4b0b-9f10-d975bd39c512', '83657f4f-0217-4404-ac6c-a5d70134171c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-03-04T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('7a5878c6-89ee-486d-a2b5-6b73a2533611', '80e63394-0982-4b0b-9f10-d975bd39c512', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-03-04T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('3be36270-3551-422d-aa06-07383d7ee642', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-04', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f3af3ab7-537e-4ee9-b4dd-26fc0518e0d7', '3be36270-3551-422d-aa06-07383d7ee642', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ea01d995-7bcc-4457-a561-282141e2dd8a', '94b6bcd0-476e-41f3-abbf-dbc0a7803e2b', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-03-04T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c1e58ce0-0954-4b55-85ac-e874fb6a2a77', 'ea01d995-7bcc-4457-a561-282141e2dd8a', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-03-04T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1481a08a-2d1a-477e-bb24-d4ca09445031', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-04', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('edd75b5e-af2e-46f6-a24c-fb127ccec245', '1481a08a-2d1a-477e-bb24-d4ca09445031', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ee2d86f6-601c-4f64-83f0-517d74354d90', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-04T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1ebb7200-68b3-42dd-85fc-bd3f8df6768c', 'ee2d86f6-601c-4f64-83f0-517d74354d90', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-04T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('742c5952-d145-413e-854b-d702378b54bf', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-04', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('849218c1-bea3-4072-a3b0-27a0be7d71f9', '742c5952-d145-413e-854b-d702378b54bf', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('cf03204b-1fef-46ea-b2c7-44d982097da2', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-05T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1b1daac6-d786-4cf6-81af-4bad25070f49', 'cf03204b-1fef-46ea-b2c7-44d982097da2', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-05T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('5234c7fd-690f-4a3f-9a6f-0cbeb480a5e1', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-05', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5ed6a826-b673-4590-be98-7376025c8c02', '5234c7fd-690f-4a3f-9a6f-0cbeb480a5e1', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('0d6277f9-9d6e-4117-b0c7-3b1d60004d76', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-03-05T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('fd79fd6b-6a86-49a4-bc58-b382607a0f9c', '0d6277f9-9d6e-4117-b0c7-3b1d60004d76', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-03-05T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d281f575-582e-4497-8e6a-0d093718372b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-05', 200, 340, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5b06d5f5-3344-463c-b5d6-2a55a5387cce', 'd281f575-582e-4497-8e6a-0d093718372b', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 4, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('587d3a98-4460-4f6c-bb57-ce1279fae607', 'c0d14847-8ed9-4488-94d3-544a041ef967', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-05T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1c0be9b9-b4ee-4186-a74c-095511e5d20d', '587d3a98-4460-4f6c-bb57-ce1279fae607', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-05T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('3b9cb08c-2480-4ef8-833e-fbfeea29e195', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-05', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c14b6bd2-c837-42cd-aeb6-232b82fb0263', '3b9cb08c-2480-4ef8-833e-fbfeea29e195', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ec3e057f-2cff-4480-9540-d676a81bb879', 'e6622482-370a-406b-bc0e-90286ffe3b92', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-05T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('66bb7f12-6ecb-467a-8bfc-6aaa0a953fbf', 'ec3e057f-2cff-4480-9540-d676a81bb879', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-05T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('fe49a3da-9bbd-4739-ae8b-f8920fb17c4e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-05', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('60be8698-0539-4383-9aa6-71c341dfa8e1', 'fe49a3da-9bbd-4739-ae8b-f8920fb17c4e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('b509c2a3-38b4-43b2-b38a-c42114c8da77', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-06T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0a75c153-fbe2-4675-ba7a-8cef41b29c1a', 'b509c2a3-38b4-43b2-b38a-c42114c8da77', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-06T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e1cc7f0b-2e9d-407b-8001-1e9b406a5fb2', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-06', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('50cc55cf-e246-468a-895b-97f156812309', 'e1cc7f0b-2e9d-407b-8001-1e9b406a5fb2', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('6ae604dc-576c-45c4-a24b-47dd0fd994a9', '4a770e52-2196-40fc-b67d-bc68a6b31847', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 255, 'completed', '2026-03-06T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c9788eef-1223-4773-b1d2-06d3578aa953', '6ae604dc-576c-45c4-a24b-47dd0fd994a9', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 85, 255, '2026-03-06T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ca4527dc-c504-496e-8944-e4d280d82e11', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-06', 150, 255, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('33ae60ea-e769-4cb4-89fd-2b2e30b6fe26', 'ca4527dc-c504-496e-8944-e4d280d82e11', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 3, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('3a05c7c9-90bf-4911-8df5-93a74f4335c7', 'b4fc7750-1b90-4a9a-93f5-a6ff19df5781', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-03-06T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('9a4ed362-9a2b-4533-8823-707e21d227e7', '3a05c7c9-90bf-4911-8df5-93a74f4335c7', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-03-06T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('3e801fdb-d096-466f-9391-751db833fb91', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-06', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1fad63ce-f4e9-4ec6-91d6-76c4c4d436d4', '3e801fdb-d096-466f-9391-751db833fb91', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9d9eb157-d44f-48fb-8b61-373372d219ff', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-06T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cbeffe41-3d89-45b5-ac5c-1d85c8f328a5', '9d9eb157-d44f-48fb-8b61-373372d219ff', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-06T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('38737cb1-e880-4675-94a0-c60c41d24514', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-06', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c2c8b7c5-ecf6-46da-a308-df8e2b0a6629', '38737cb1-e880-4675-94a0-c60c41d24514', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('101d5ae4-969c-4831-b2e5-bf5bcdab5694', 'e6622482-370a-406b-bc0e-90286ffe3b92', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-07T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('40d3d6e7-9844-49c9-afe3-518cffe378c0', '101d5ae4-969c-4831-b2e5-bf5bcdab5694', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-07T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('33ffda97-c8b7-4717-95c8-86e7ed6ebed4', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-07', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bf1cce61-beba-44e6-8e1c-ee5b91e3054c', '33ffda97-c8b7-4717-95c8-86e7ed6ebed4', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ce20a82e-4a26-48e7-b2b2-21798f9d475e', 'e14d5bdc-573a-4ebf-812b-c00c8599520d', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 425, 'completed', '2026-03-07T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('d720ea35-1603-4836-bfa3-f695d445c13c', 'ce20a82e-4a26-48e7-b2b2-21798f9d475e', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 85, 425, '2026-03-07T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('156ab9f2-98ab-4ed1-ac88-f9118fc85255', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-07', 250, 425, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7953fed3-af8d-4082-90d6-9a18273d0d24', '156ab9f2-98ab-4ed1-ac88-f9118fc85255', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8fe11543-3937-4011-9bfa-f23bbbc5688b', '7afb89e9-fbaa-4460-acca-d9374347a1a6', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-03-07T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c91f0586-9386-4dc7-af8f-6cee5ff56017', '8fe11543-3937-4011-9bfa-f23bbbc5688b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-03-07T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('69bc02d2-3f5e-48d5-a8ab-8a0584973199', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-07', 90, 110, 5, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3d7ea662-f4e2-4ae8-a1b3-d007ad9873d1', '69bc02d2-3f5e-48d5-a8ab-8a0584973199', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 5, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('bc20793a-b75f-4f7d-a39a-de04483a3fcf', '242b409f-1ea9-4a66-8361-e38c287b8a14', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-03-07T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('499f588d-3b28-419c-9245-e39012300549', 'bc20793a-b75f-4f7d-a39a-de04483a3fcf', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-03-07T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('08b5cdfc-4625-47be-b056-95c35179d3cc', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-07', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ba8263b1-88b5-4dbe-b3c3-4834f48918ca', '08b5cdfc-4625-47be-b056-95c35179d3cc', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('7a242c6d-8226-42e6-a742-13bb8bbc12bd', 'e14d5bdc-573a-4ebf-812b-c00c8599520d', '2d037e2e-5793-4dde-adda-0e25fabea338', 22, 'completed', '2026-03-08T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('6db05654-04bf-4443-8a24-6637f7e9b25e', '7a242c6d-8226-42e6-a742-13bb8bbc12bd', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 22, 22, '2026-03-08T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a51b85b2-4727-4d14-89b6-bf874bc79a1c', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-08', 15, 22, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('512cc7d5-f6b1-4dec-b69f-6bd3518dddc3', 'a51b85b2-4727-4d14-89b6-bf874bc79a1c', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 1, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9069c9e9-c976-4f89-a0bd-887f368789fe', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-03-09T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('f4dce6bf-36ef-4e4e-a797-69566d09f3aa', '9069c9e9-c976-4f89-a0bd-887f368789fe', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-03-09T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('db02006a-1b79-4087-b5f9-1270f6c6576c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-09', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('00bb472f-7f45-449b-99f6-eea2e493a8b2', 'db02006a-1b79-4087-b5f9-1270f6c6576c', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('1f80c450-2f66-4920-b05a-b62102cb8d61', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-03-09T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('d064ecd8-61e7-4b25-ba48-8eb3ec5f6a6d', '1f80c450-2f66-4920-b05a-b62102cb8d61', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-03-09T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('af5b2871-d4de-4294-a283-6d7d56630dbd', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-09', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('afcccb06-9012-4432-b581-eae5732fa968', 'af5b2871-d4de-4294-a283-6d7d56630dbd', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('16643724-175c-4796-846b-defd1475b6bb', 'fbb5112a-25ab-41af-b22e-b5882da0ce8e', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-10T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('9badc0a9-49f0-4d98-be78-f6a64ab6766c', '16643724-175c-4796-846b-defd1475b6bb', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-10T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('31c444e4-07f0-425c-9b5e-3770f8bbbf2b', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-10', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1abe3aba-7b2b-4b9e-b323-1eb76a26c3cc', '31c444e4-07f0-425c-9b5e-3770f8bbbf2b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('7ef88e84-a04a-46df-8cf9-cf95ea3294df', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 170, 'completed', '2026-03-10T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('d0e7b345-df92-413d-bbb2-0381e4a5d92c', '7ef88e84-a04a-46df-8cf9-cf95ea3294df', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 2, 85, 170, '2026-03-10T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9038c046-1f9e-42bc-9a2a-7e804f558e35', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-10', 150, 170, 2, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ea38da42-eb81-4f9b-a1e7-5899c6aa5ca2', '9038c046-1f9e-42bc-9a2a-7e804f558e35', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 2, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c5332014-a0a0-4e2e-84e8-e4e43ebd984e', 'e6622482-370a-406b-bc0e-90286ffe3b92', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-10T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('de6b73de-c9e3-4080-9cae-204c9e8e48e3', 'c5332014-a0a0-4e2e-84e8-e4e43ebd984e', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-10T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('2f2a45ae-8cfa-454c-8c43-041552f7263b', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-10', 75, 88, 4, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bc251d2b-40ee-463d-a79d-7108be388d9f', '2f2a45ae-8cfa-454c-8c43-041552f7263b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 4, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('dde604e8-2b7a-4420-b8fa-cfba7ec2aef5', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-03-10T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('502d1d7f-e4bd-40d4-812c-e102de742a8c', 'dde604e8-2b7a-4420-b8fa-cfba7ec2aef5', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-03-10T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('b6bf7d2e-364d-4213-9a6c-85437a9693bf', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-10', 70, 150, 6, 1, 10, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f89c425b-470d-48d8-b775-1b1bc6249988', 'b6bf7d2e-364d-4213-9a6c-85437a9693bf', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 6, 1, 10, 25, 10, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('6b01311e-b194-4ff1-b386-35cab781b497', 'ff2755b5-ee79-4b48-941e-84e272b5a91c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('2b02b785-f575-4f38-88ad-40eb25b978ea', '6b01311e-b194-4ff1-b386-35cab781b497', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('215eaffb-8938-4498-b2fb-7b5d4e407346', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-11', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('734d7ed3-308c-40c3-95e1-8bf66f4f66e5', '215eaffb-8938-4498-b2fb-7b5d4e407346', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('0a6e4161-a0b5-48cf-b0ca-699e62c67143', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 340, 'completed', '2026-03-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('6294a8a2-a6af-4fa5-bcb0-5740489e0de9', '0a6e4161-a0b5-48cf-b0ca-699e62c67143', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 85, 340, '2026-03-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('eb152197-32f0-4b9d-8cb3-af5688aa61c3', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-11', 200, 340, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ed30000f-f1f6-4cff-ae85-4099a1e3650a', 'eb152197-32f0-4b9d-8cb3-af5688aa61c3', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 4, 4, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('80293433-94da-4425-a044-20b63f254472', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-03-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('4926ef85-7012-4fd8-b66c-6350926e61d2', '80293433-94da-4425-a044-20b63f254472', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-03-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0313a19d-e97a-456e-8f82-958c4fb6c824', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-11', 60, 66, 3, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('aee70bd7-b883-4e81-8873-c4c2d701fdea', '0313a19d-e97a-456e-8f82-958c4fb6c824', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 3, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c38949a5-6e5c-4b3d-8ca7-432e2ffd2e6d', 'bf6d07c1-bd1e-4e6a-a0db-0e135dc8a510', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-03-11T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('fcb81064-826c-4a10-9019-58767b9e804b', 'c38949a5-6e5c-4b3d-8ca7-432e2ffd2e6d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-03-11T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('5d898007-6b91-41c7-a08f-c4574adc93cc', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-11', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f24bd4b9-dac8-4506-9c00-027d1dca4d2a', '5d898007-6b91-41c7-a08f-c4574adc93cc', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('0ea66d14-7224-4b3d-99a4-3e88e7a79fbe', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('435b7c54-17ef-481c-8fd2-16915ad73e98', '0ea66d14-7224-4b3d-99a4-3e88e7a79fbe', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('2274890e-3c4e-4b09-98a5-1605c6454142', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-12', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('88cd3027-08f4-4004-96ce-b35f4b5ed8fc', '2274890e-3c4e-4b09-98a5-1605c6454142', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c3704282-8746-4631-ad3c-60b9ec123fe0', '763a854e-0d3b-4508-8b6e-ed2c34c44251', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-03-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('272a85db-cb64-461e-aeba-8e5a5381fc50', 'c3704282-8746-4631-ad3c-60b9ec123fe0', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-03-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('889eac39-2303-47b0-b321-fac0d2b69f19', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-12', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5ca86048-01e8-496e-b7af-4c18d3d41db9', '889eac39-2303-47b0-b321-fac0d2b69f19', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d1b72500-fecd-47f5-89c4-5f7b88510ab5', '242b409f-1ea9-4a66-8361-e38c287b8a14', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('21d43c69-9647-4e69-9c78-e2797c6c31dc', 'd1b72500-fecd-47f5-89c4-5f7b88510ab5', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('900e0dca-98e5-48d6-bbe8-4d7f9bdd4ae7', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-12', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4c690770-da13-4c3d-b38a-9699d3e757ed', '900e0dca-98e5-48d6-bbe8-4d7f9bdd4ae7', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e801a6f6-dd35-4352-8a02-1d8670ca52ef', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 75, 'completed', '2026-03-12T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1e006a2f-d530-4e52-9589-818d69e28847', 'e801a6f6-dd35-4352-8a02-1d8670ca52ef', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 25, 75, '2026-03-12T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('04aeddbc-39ac-4339-b6c7-25a62829a201', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-12', 30, 75, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('06cae8d6-9adf-447c-9328-8d7dc508f654', '04aeddbc-39ac-4339-b6c7-25a62829a201', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 3, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('fa1e1ee9-6a4a-46bb-8f47-f1797022cc86', 'a1b26990-cf90-47ce-b96f-a8acce39cb80', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3f9a49d1-2e22-40f9-9015-154b7d3a85ca', 'fa1e1ee9-6a4a-46bb-8f47-f1797022cc86', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1d858c50-ba9f-4df4-a455-a8d35e6ba9aa', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-13', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7c7191c0-e494-48d0-8afc-e5040ff4310d', '1d858c50-ba9f-4df4-a455-a8d35e6ba9aa', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8f9ecfb1-743e-4706-a237-ae9464941cc1', '83657f4f-0217-4404-ac6c-a5d70134171c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 255, 'completed', '2026-03-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('bf307461-9cff-4fbb-a757-0d51023d55bb', '8f9ecfb1-743e-4706-a237-ae9464941cc1', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 85, 255, '2026-03-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('488d5881-a692-4b12-9659-18b915ef6fc5', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-13', 150, 255, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b184eaf1-ac61-40ae-ad7b-9369294c90ea', '488d5881-a692-4b12-9659-18b915ef6fc5', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 3, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('cc45db35-74be-42f6-acc0-115888f5434e', '56ae08c3-f9f2-4048-9419-962455c372a4', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-03-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('19cc0525-5398-40d1-ba61-74d1fdb94b84', 'cc45db35-74be-42f6-acc0-115888f5434e', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-03-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('af309745-1a20-4834-a842-4bb042d0f550', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-13', 45, 66, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1cf513e5-5263-4951-857b-ad5f40019cbe', 'af309745-1a20-4834-a842-4bb042d0f550', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 3, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ac8f8fd7-f51f-482c-8203-823b716fb19a', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-03-13T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('2776f7bb-e495-4967-89ce-9142e0fe8c57', 'ac8f8fd7-f51f-482c-8203-823b716fb19a', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-03-13T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1dcea21b-db59-4b91-9d34-1ac06405cb4e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-13', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('97424888-e3e8-48f8-bdb3-74220d6ad58d', '1dcea21b-db59-4b91-9d34-1ac06405cb4e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('783cbd27-1921-4c2d-8b80-16fb9c5d4e5b', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('cf71c690-030e-4efc-b7a6-b0be1a099336', '783cbd27-1921-4c2d-8b80-16fb9c5d4e5b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('489482fb-90a0-4315-9d05-80607416e44f', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-14', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('393ae64b-721d-4957-831f-c5ba9875b639', '489482fb-90a0-4315-9d05-80607416e44f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('4e259d93-21c8-4d19-a0be-66cea221bfa5', '97f67070-1057-4ec1-92c3-910d9d5bc3af', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-03-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3a0090ae-6b9d-4ead-8e89-471e4ab5ef7a', '4e259d93-21c8-4d19-a0be-66cea221bfa5', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-03-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('4b842e9d-a4fd-4da2-93af-438466849a37', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-14', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('96cf8ffe-a034-49de-bc92-df05125f5c58', '4b842e9d-a4fd-4da2-93af-438466849a37', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f8808b9c-3112-49f9-b376-abbd2949511a', '4a770e52-2196-40fc-b67d-bc68a6b31847', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('982751bb-ed08-4a21-827e-436ef66caecd', 'f8808b9c-3112-49f9-b376-abbd2949511a', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('b5fd447c-dfba-4db2-8964-3d8494be84c4', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-14', 75, 88, 4, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0fee75c0-3d24-4986-8e73-0f5009a6dded', 'b5fd447c-dfba-4db2-8964-3d8494be84c4', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 4, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d90024cd-e61b-4bba-9199-7b4171974b3d', 'eb421b73-922f-4bf3-9a99-daa66b7f6536', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 100, 'completed', '2026-03-14T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('7618b592-8f13-486c-8040-94974b903675', 'd90024cd-e61b-4bba-9199-7b4171974b3d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 4, 25, 100, '2026-03-14T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('28530a40-3a7d-4357-8555-60985fdc3eba', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-14', 50, 100, 4, 1, 10, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bb7040a6-470b-4f30-a0e2-2423fa4c25dd', '28530a40-3a7d-4357-8555-60985fdc3eba', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 4, 1, 10, 25, 10, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('2e88be56-cb2e-4616-910c-4ff46e5d04a7', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '2d037e2e-5793-4dde-adda-0e25fabea338', 22, 'completed', '2026-03-16T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('36eac5f5-028d-4fa8-95ac-05f61c1080f5', '2e88be56-cb2e-4616-910c-4ff46e5d04a7', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 22, 22, '2026-03-16T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0558821f-709e-496b-b900-9c3483c02ec8', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-16', 15, 22, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7973473d-5018-477a-bca3-6fd68601fce1', '0558821f-709e-496b-b900-9c3483c02ec8', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 1, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('727f0c94-2480-41ed-b133-d49ac52870cd', 'd4ef1378-99c8-477c-8dee-e83879e9d7db', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-03-16T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3568cc35-8665-4e21-897b-180859d6adba', '727f0c94-2480-41ed-b133-d49ac52870cd', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-03-16T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0cd136c6-c62f-4dd2-83f1-3da4ea207e45', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-16', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('992921b4-77cd-4b84-a22b-cdf787405aae', '0cd136c6-c62f-4dd2-83f1-3da4ea207e45', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('40c90ad2-0d5c-44a7-9d26-974e745e3db4', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('4509893b-93b1-43da-ad25-f4ef6cb6c3fe', '40c90ad2-0d5c-44a7-9d26-974e745e3db4', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1b53ac64-1f81-4935-b627-d03194568020', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-17', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('aa934905-f814-4415-b1c5-66df41ebc242', '1b53ac64-1f81-4935-b627-d03194568020', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f31709df-f20b-4c9e-a993-190d32b207e8', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('56bfcbcd-d3b3-4552-b4e2-39e5514fa2e2', 'f31709df-f20b-4c9e-a993-190d32b207e8', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9dff5acb-0389-4dc9-918b-7659dd56ec95', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-17', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e81b12f1-37a0-4c80-804d-2ed45b53f1e9', '9dff5acb-0389-4dc9-918b-7659dd56ec95', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('daae972c-6dfb-4f40-a540-f23813b245cf', 'e9daad6c-9835-4b37-86c1-d291f93bcdd6', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-03-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c4118839-764d-44d5-a8ce-425feb6ddef9', 'daae972c-6dfb-4f40-a540-f23813b245cf', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-03-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('c7000a82-0a6c-46ed-a13a-1902a867ccbe', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-17', 75, 110, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8d3edd5f-5c3d-4af4-b9b7-52240509b815', 'c7000a82-0a6c-46ed-a13a-1902a867ccbe', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 5, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('d7f255ba-5aa8-43e7-8957-b1c2628f9187', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-17T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('d44ae9a5-c5eb-4a25-a6b7-fa3bfc7ab665', 'd7f255ba-5aa8-43e7-8957-b1c2628f9187', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-17T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('94902de3-1a87-4d3c-a7c8-b3c9e212466e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-17', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7bdc9688-c547-4ec9-be65-a975ab53d9e8', '94902de3-1a87-4d3c-a7c8-b3c9e212466e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('5ae0f249-b724-45af-a7ab-6ab862f76eb7', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a3a5ab64-2ca2-4fc7-b976-cf94f90c1357', '5ae0f249-b724-45af-a7ab-6ab862f76eb7', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('01fb0518-806d-4a67-b037-f29ae964dab9', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-18', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a1c28c1e-c9b9-458d-9b98-46f894a73d16', '01fb0518-806d-4a67-b037-f29ae964dab9', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ed9fe8b2-d7ed-4c32-8f3f-8592693733df', 'e2c0ffe4-445e-46e2-b344-92d32301da40', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('53dc8edb-ea5e-4ecb-b6d5-cd938c40026b', 'ed9fe8b2-d7ed-4c32-8f3f-8592693733df', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e8272ed5-0832-455b-b9d9-320a6391a1f2', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-18', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ac70dda0-17cb-4822-b762-eef7f706b072', 'e8272ed5-0832-455b-b9d9-320a6391a1f2', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('44a9d7e0-a6cd-488e-83f1-08f590323da8', '0fe643f1-5ff6-40d5-8598-e1bfac12b6fd', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('5e04fb27-6775-4e02-83ea-805b34509ecb', '44a9d7e0-a6cd-488e-83f1-08f590323da8', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('397ecce7-7b5a-4ff2-8f14-ec89a87e6aa3', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-18', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('92a988eb-992c-477e-bdd6-4530c993b7d2', '397ecce7-7b5a-4ff2-8f14-ec89a87e6aa3', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e3670331-0da0-41fc-9433-22cf69743689', 'e6622482-370a-406b-bc0e-90286ffe3b92', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-18T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('7d336296-172f-4983-b299-2f0a3817a7d3', 'e3670331-0da0-41fc-9433-22cf69743689', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-18T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('919d1bfd-78a6-4d21-9032-3432108009dd', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-18', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('30f6f69a-77ea-418c-8251-ff2691735ae1', '919d1bfd-78a6-4d21-9032-3432108009dd', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('156c9cf2-c66e-4c63-a912-2ac9ba7a92ee', 'e14d5bdc-573a-4ebf-812b-c00c8599520d', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('7a3632f2-47b6-4023-b744-0d7300ca16b9', '156c9cf2-c66e-4c63-a912-2ac9ba7a92ee', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('97352151-c0b1-4959-8d75-c9d0ae9c1e60', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-19', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3c69e2c5-24b2-4994-9e04-9899aabf99a0', '97352151-c0b1-4959-8d75-c9d0ae9c1e60', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f9986703-0843-437f-9eea-1d0751e3e236', '3c50816c-affd-4654-83a2-a4fb6def7419', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 255, 'completed', '2026-03-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('592f42de-8235-4b7b-b1c8-c0b5cb4785fb', 'f9986703-0843-437f-9eea-1d0751e3e236', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 85, 255, '2026-03-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e1a221f3-c514-4f76-ad2a-f701801cac80', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-19', 150, 255, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cdce259a-2588-4632-bff9-873ff3af0ad0', 'e1a221f3-c514-4f76-ad2a-f701801cac80', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 3, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('130eb838-6154-4a79-851e-579a8a4aeadf', '899d489d-0050-4eca-8bbc-6e1d493f9eea', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-03-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a773e46d-a1df-4484-84b7-fc5be1fbc799', '130eb838-6154-4a79-851e-579a8a4aeadf', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-03-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('df5d86e8-fbda-4919-8bae-8bfead9d4f45', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-19', 60, 66, 3, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('51b5f796-9c64-411c-b52e-536a8a6c0943', 'df5d86e8-fbda-4919-8bae-8bfead9d4f45', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 3, 1, 15, 22, 15, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('37b4ddba-625c-48a3-bbd8-8dbfc28125ef', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 100, 'completed', '2026-03-19T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('ac1a80c6-561c-4e49-aade-5db1694b3caf', '37b4ddba-625c-48a3-bbd8-8dbfc28125ef', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 4, 25, 100, '2026-03-19T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('13e0d751-423f-40f2-9a5d-8ddc025204f2', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-19', 40, 100, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('76db1a44-2624-4af3-8bab-d9ea0e12bb30', '13e0d751-423f-40f2-9a5d-8ddc025204f2', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 4, 4, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('b1066f60-3235-4ea5-a55e-20ab8c499d98', '4a770e52-2196-40fc-b67d-bc68a6b31847', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('71ce8e13-127b-4459-9568-a25638c3a130', 'b1066f60-3235-4ea5-a55e-20ab8c499d98', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('36188ffb-c64f-436e-8133-2c35de0fa5bf', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-20', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8e20b606-075d-4bb2-acb1-e6f1d78749de', '36188ffb-c64f-436e-8133-2c35de0fa5bf', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a3add3d7-2136-4de0-a58f-f69d869e05e4', '97f67070-1057-4ec1-92c3-910d9d5bc3af', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 255, 'completed', '2026-03-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0d1afc8b-d9d7-428b-be07-dd8cce026f52', 'a3add3d7-2136-4de0-a58f-f69d869e05e4', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 85, 255, '2026-03-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('bbd2ee89-6b9c-409a-ad95-96fcfae0748f', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-20', 150, 255, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b7ab1c59-20e2-4edb-98a8-de7c9368e1f3', 'bbd2ee89-6b9c-409a-ad95-96fcfae0748f', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 3, 3, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('01a162b6-cdc0-4695-a19d-6162aafebbdc', '97f67070-1057-4ec1-92c3-910d9d5bc3af', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-03-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('80276a89-918d-4eef-8c95-632152234ffc', '01a162b6-cdc0-4695-a19d-6162aafebbdc', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-03-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('4c439dae-323e-439d-a93a-088ac627d8a2', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-20', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('af326e89-0750-47dc-bd18-5cd76c5c57df', '4c439dae-323e-439d-a93a-088ac627d8a2', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f4413f31-f735-4260-a213-539fbd211345', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-03-20T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('b56c96f3-b993-42de-aa87-038d5205e964', 'f4413f31-f735-4260-a213-539fbd211345', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-03-20T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('2add4ee7-8a53-435a-bf44-1e81c21e1fc9', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-20', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('976f0126-ad12-4c2c-a9a3-5f59b210f250', '2add4ee7-8a53-435a-bf44-1e81c21e1fc9', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a4b4803d-ef9f-40b7-9b51-69cc5832bd2b', 'f138596a-02ba-44f5-903c-de8f7c2f31a8', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('d342011e-5411-4844-abc3-602b3665113f', 'a4b4803d-ef9f-40b7-9b51-69cc5832bd2b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('74e38daa-4a0f-426d-ba6e-d4059c069123', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-21', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6ce27854-3bd3-40ee-8b1f-538e1cf31016', '74e38daa-4a0f-426d-ba6e-d4059c069123', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('7dc25a4b-a975-4a2b-82d4-89fe5609baf9', 'e2c0ffe4-445e-46e2-b344-92d32301da40', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('42abde69-509d-4a53-8b63-e8599472523e', '7dc25a4b-a975-4a2b-82d4-89fe5609baf9', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('11f939ec-800c-4efb-b875-cc4f2f5f227a', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-21', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f875d6f2-8874-4a49-afb1-98f6fd091476', '11f939ec-800c-4efb-b875-cc4f2f5f227a', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('5e03ad6c-4983-46d5-b7e9-2bb0303060c3', '56ae08c3-f9f2-4048-9419-962455c372a4', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-03-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('98497e86-f12f-442e-9156-2493c9c7b71e', '5e03ad6c-4983-46d5-b7e9-2bb0303060c3', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-03-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('517486aa-8744-400c-aaeb-964173ee2059', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-21', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('75aee2d6-afee-426d-9d20-68b6427a5c9c', '517486aa-8744-400c-aaeb-964173ee2059', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e24cc8c1-6038-45cc-94da-96a33d0e243d', '4a770e52-2196-40fc-b67d-bc68a6b31847', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 175, 'completed', '2026-03-21T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('5e475822-325b-4987-b3f8-245db1cd87fa', 'e24cc8c1-6038-45cc-94da-96a33d0e243d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 25, 175, '2026-03-21T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e19c1596-3f5f-407b-8f6a-0200848f2fca', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-21', 70, 175, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7464f345-851e-4943-83d7-ef0102c4e4ad', 'e19c1596-3f5f-407b-8f6a-0200848f2fca', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 7, 7, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e9b7ee18-f679-4a5b-97e2-3cc0cae261e3', 'e14d5bdc-573a-4ebf-812b-c00c8599520d', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-03-23T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('ab89e6d6-c4de-49c2-af52-c91852753848', 'e9b7ee18-f679-4a5b-97e2-3cc0cae261e3', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-03-23T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0290ad71-3eb9-41b0-8253-dea45102e142', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-23', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3e070771-88ef-41c6-accd-c5ed6304a2b5', '0290ad71-3eb9-41b0-8253-dea45102e142', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('cf01fd6f-3983-4e93-b074-1168fa5179b7', 'd4ef1378-99c8-477c-8dee-e83879e9d7db', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c32b0813-e057-4940-b4c1-199aaf6779c6', 'cf01fd6f-3983-4e93-b074-1168fa5179b7', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ea86df7d-2353-423e-acd2-9c1199a04c9b', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-24', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('078881cd-fa9b-46e9-b7c6-1c94122b963d', 'ea86df7d-2353-423e-acd2-9c1199a04c9b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('c6d2733f-1ece-4086-82b6-c537d3ace4c5', '7afb89e9-fbaa-4460-acca-d9374347a1a6', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-03-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('eb780e2d-db71-40a3-bcd0-4019f6e600a3', 'c6d2733f-1ece-4086-82b6-c537d3ace4c5', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-03-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('bf96858e-65b3-41ce-b2b3-649641544324', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-24', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e7036c1a-006f-40f3-945d-b9c239caf3f4', 'bf96858e-65b3-41ce-b2b3-649641544324', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('59062613-51a1-40cd-aa80-e3e66dfd8a06', '763a854e-0d3b-4508-8b6e-ed2c34c44251', '2d037e2e-5793-4dde-adda-0e25fabea338', 154, 'completed', '2026-03-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('8da1e4bb-3288-43f8-bbb2-22b70d980e11', '59062613-51a1-40cd-aa80-e3e66dfd8a06', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 22, 154, '2026-03-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('22ebdee8-3ab1-4d43-aecc-b2e2e97b7e6d', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-24', 105, 154, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b9329bbd-ddc9-4a93-919f-a8b43cde704b', '22ebdee8-3ab1-4d43-aecc-b2e2e97b7e6d', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 7, 7, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('0a03bf5a-c7da-4a35-a89e-339b696ff653', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-24T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('2eae6dc5-acdd-46b2-9c3b-26bb7da2211a', '0a03bf5a-c7da-4a35-a89e-339b696ff653', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-24T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('02f91199-fa0a-43d7-8e2c-01b0ecaa77e3', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-24', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3c3cb01a-c5b2-4fcf-8e15-b1e952c52aae', '02f91199-fa0a-43d7-8e2c-01b0ecaa77e3', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('526d69b1-d763-4678-b464-69751a410bd7', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('3bff09c6-197e-4d84-a7bc-606b56584d9e', '526d69b1-d763-4678-b464-69751a410bd7', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('7d442221-04c3-4874-bb7d-ab74cb96861e', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-25', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f766dd67-43aa-4990-a66d-c7140770f3a8', '7d442221-04c3-4874-bb7d-ab74cb96861e', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('e87aa9df-9610-46d9-a734-f26750c209f4', '7afb89e9-fbaa-4460-acca-d9374347a1a6', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('39a8c4d2-fa3d-4b6f-b3f8-daad7f3e3b86', 'e87aa9df-9610-46d9-a734-f26750c209f4', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('8dd3246d-c464-44e6-b4de-b88792abddba', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-25', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('751638f8-0b77-460e-9fa3-ff0930c57d03', '8dd3246d-c464-44e6-b4de-b88792abddba', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('b5446971-d1e8-47a6-90c2-8f71f0bc59f0', 'babba52c-bea0-4bad-a47c-7a9de7db3f7b', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-03-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('05cb9a94-26df-46a4-85a4-2a1aa5fd12c0', 'b5446971-d1e8-47a6-90c2-8f71f0bc59f0', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-03-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1072300c-6ac5-44ca-a73c-ad336275c107', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-25', 45, 66, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f93dcd66-f7cb-41b1-bb84-91b508e386b0', '1072300c-6ac5-44ca-a73c-ad336275c107', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 3, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('2b1a67f7-a992-4857-bc4b-081d27b6c87f', 'c5ba338e-d08f-4f3d-9076-7e1c47b8135c', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 50, 'completed', '2026-03-25T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('daaa1f37-f4c7-45af-aaae-e98236ff5146', '2b1a67f7-a992-4857-bc4b-081d27b6c87f', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 2, 25, 50, '2026-03-25T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0c3a56b9-b899-4586-8f76-435e62413764', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-25', 30, 50, 2, 1, 10, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f5906e53-efb2-4013-94b8-b2078bb827bb', '0c3a56b9-b899-4586-8f76-435e62413764', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 3, 2, 1, 10, 25, 10, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('5a422b2a-a85a-48c4-b5ab-e1457afe275f', 'bf6d07c1-bd1e-4e6a-a0db-0e135dc8a510', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('18f0bdfa-075b-47b6-ad1c-e60b03728cfa', '5a422b2a-a85a-48c4-b5ab-e1457afe275f', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('cebba869-5126-40bb-9f2c-ae6ae6ede2d5', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-26', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9a37fd21-fa74-47e4-8a96-d4de3b62398e', 'cebba869-5126-40bb-9f2c-ae6ae6ede2d5', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('a44a7a54-2a02-4192-8058-8ffa00f51cd0', 'c0d14847-8ed9-4488-94d3-544a041ef967', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('a0214e19-b60f-4165-b5e3-37bc370e171f', 'a44a7a54-2a02-4192-8058-8ffa00f51cd0', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('feb6a477-3219-4854-bbc3-a099b4e915aa', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-26', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2c4a07d4-d23e-46c6-be9e-e0fc16492568', 'feb6a477-3219-4854-bbc3-a099b4e915aa', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('b9cefc71-5ccf-49aa-9516-6f4b2a515225', '242b409f-1ea9-4a66-8361-e38c287b8a14', '2d037e2e-5793-4dde-adda-0e25fabea338', 66, 'completed', '2026-03-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('75842672-2ad6-4ff2-a7eb-49957de9eb93', 'b9cefc71-5ccf-49aa-9516-6f4b2a515225', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 22, 66, '2026-03-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('48ea2eae-9e18-499c-9bb4-1c7d198d1c9b', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-26', 45, 66, 3, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c1256e0d-4d74-4fdb-89bd-7984d87985ce', '48ea2eae-9e18-499c-9bb4-1c7d198d1c9b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 3, 3, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f23348fa-93df-4ac2-8857-2c2e69fbe41e', 'e9daad6c-9835-4b37-86c1-d291f93bcdd6', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-03-26T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('65d9d03c-f780-48ad-9f29-f5d8e8fc9f76', 'f23348fa-93df-4ac2-8857-2c2e69fbe41e', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-03-26T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0c334444-2af6-412e-8871-061971bd9637', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-26', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5ca77f0d-8b13-4c14-b7c3-9ba9785a5d69', '0c334444-2af6-412e-8871-061971bd9637', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('21bc3e2e-56ea-4b05-ac9c-00ca7cc08e15', '7afb89e9-fbaa-4460-acca-d9374347a1a6', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('72cf1e96-b3a2-4932-9e0d-08a6767cdeab', '21bc3e2e-56ea-4b05-ac9c-00ca7cc08e15', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d855b3a9-81d2-4ebe-b2c4-04f67ca0a535', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-27', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2a166305-f2f3-406c-b182-eb94bb5d712c', 'd855b3a9-81d2-4ebe-b2c4-04f67ca0a535', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('bde9a0ed-8c5c-4254-a588-ba5b4fb50e18', 'cb24793b-0741-4761-a701-e34935fcaa2b', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 595, 'completed', '2026-03-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('458139a6-ee3d-4ec2-bf2d-6f70dff02ecb', 'bde9a0ed-8c5c-4254-a588-ba5b4fb50e18', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 85, 595, '2026-03-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d3cbca8b-2655-45c7-8da8-6366dfcd3d9a', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-27', 350, 595, 7, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('36d8b4ea-ec13-4f30-88f3-76a8cfdabd3e', 'd3cbca8b-2655-45c7-8da8-6366dfcd3d9a', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('f85280ee-183e-48fd-aaad-793ab158436f', '94b6bcd0-476e-41f3-abbf-dbc0a7803e2b', '2d037e2e-5793-4dde-adda-0e25fabea338', 88, 'completed', '2026-03-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('51e6a48d-4d2a-44e0-954f-1fec0a61c164', 'f85280ee-183e-48fd-aaad-793ab158436f', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 22, 88, '2026-03-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('e279a257-73ca-4c9e-8611-a8cb9cbb55fd', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-27', 60, 88, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0d5194a9-4d35-41ee-a339-ed67b40a1100', 'e279a257-73ca-4c9e-8611-a8cb9cbb55fd', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 4, 4, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('9d981297-ea31-465b-852d-da7b2e51ad7a', 'b38ecd5d-65dc-407f-b667-6907243d5d5e', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 100, 'completed', '2026-03-27T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('c4194f7b-187e-4c37-bfd5-efacd09f47ea', '9d981297-ea31-465b-852d-da7b2e51ad7a', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 4, 25, 100, '2026-03-27T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a7fd3011-33e3-44cb-9015-00a626a54fd9', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-27', 40, 100, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('aee163f1-84a3-4792-8375-2611fbf07e15', 'a7fd3011-33e3-44cb-9015-00a626a54fd9', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 4, 4, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8f41d259-0e0e-4118-bbcf-9724a1db4937', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', '295672f7-ad03-49be-8afc-f7e31cabbe17', 280, 'completed', '2026-03-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('0d4a9c08-1039-454d-bbc8-1708c574996d', '8f41d259-0e0e-4118-bbcf-9724a1db4937', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 70, 280, '2026-03-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('f8879251-6887-4684-9225-f9aef62dbb9b', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-28', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('04f2fb53-ace4-4c1a-831b-f09b95952d1a', 'f8879251-6887-4684-9225-f9aef62dbb9b', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8263c9cb-8995-4f9f-b4c4-818346bd964f', '7770b1ae-6745-4595-b20d-55c49bfe1cbf', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 425, 'completed', '2026-03-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('dc0e6cfb-3bd9-4ca9-92ba-baf73e9b9b7f', '8263c9cb-8995-4f9f-b4c4-818346bd964f', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 5, 85, 425, '2026-03-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('66512ede-5f9f-4769-9072-8857bd908438', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-28', 300, 425, 5, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6d08336e-25c9-4211-9e77-d8f435bdf639', '66512ede-5f9f-4769-9072-8857bd908438', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 5, 1, 50, 85, 50, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('69d7c561-b500-4812-97d7-6f4331c6f117', '5e6b870b-bc3e-4971-a50f-2290e63e4a1b', '2d037e2e-5793-4dde-adda-0e25fabea338', 110, 'completed', '2026-03-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('147966c4-b946-47e2-a7be-cfefa3e71058', '69d7c561-b500-4812-97d7-6f4331c6f117', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 22, 110, '2026-03-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('76f688b2-e908-437d-8198-a7b31adb5ac9', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-28', 75, 110, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8be39887-bbf7-4b21-abd2-54263fc3782e', '76f688b2-e908-437d-8198-a7b31adb5ac9', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 5, 5, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('eb31fc64-6c60-4e43-8f89-89e4b6ba62d6', '83657f4f-0217-4404-ac6c-a5d70134171c', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 150, 'completed', '2026-03-28T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('6914cad7-e77a-430c-9d69-bc3cadaf4503', 'eb31fc64-6c60-4e43-8f89-89e4b6ba62d6', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 25, 150, '2026-03-28T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('423d3536-2406-44e4-9bcc-aa5b400e383c', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-28', 60, 150, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('30eae65b-9c66-4ca8-89c1-050ab79bbd3c', '423d3536-2406-44e4-9bcc-aa5b400e383c', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 6, 6, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8277f569-ec92-462a-abf1-2eeb90411c16', 'ff2755b5-ee79-4b48-941e-84e272b5a91c', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-03-29T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('5b3c1f2b-6084-4c76-bd07-031d4f68fced', '8277f569-ec92-462a-abf1-2eeb90411c16', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-03-29T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('a9fcea4f-8c5c-4a44-8d11-bc8d2ce4dcd9', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-29', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8f7b4394-a392-4f9a-ae54-ae9a84a129b3', 'a9fcea4f-8c5c-4a44-8d11-bc8d2ce4dcd9', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('df9140bf-a3d8-4a73-8408-5859a791826b', '3c50816c-affd-4654-83a2-a4fb6def7419', '2d037e2e-5793-4dde-adda-0e25fabea338', 22, 'completed', '2026-03-29T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('89e0f558-71bf-4254-9a8b-8ecec4cfe9f9', 'df9140bf-a3d8-4a73-8408-5859a791826b', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 22, 22, '2026-03-29T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('d08179d8-22a1-4026-a237-a59fa131a155', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-29', 15, 22, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a694489a-5d49-4616-aae3-29c3a5e2c144', 'd08179d8-22a1-4026-a237-a59fa131a155', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 1, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('35f5e348-a760-437d-937f-625b2e7d23f8', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 25, 'completed', '2026-03-29T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('673e19a4-5d06-4755-aa9c-bb8313201eb8', '35f5e348-a760-437d-937f-625b2e7d23f8', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 25, 25, '2026-03-29T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('10b69247-26a8-4565-8ad8-1f54b6ac2b55', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-29', 10, 25, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bb441162-7e97-4b2a-9fa8-896e7d0f323f', '10b69247-26a8-4565-8ad8-1f54b6ac2b55', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 1, 1, 0, 10, 25, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('29501426-4aa3-405f-a661-2e8394a93c6a', 'c24eaafc-e103-46ea-9ac5-1de1afc14eb7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 85, 'completed', '2026-03-30T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('4e5f643a-8fd6-4d87-81cc-ccdfec2076da', '29501426-4aa3-405f-a661-2e8394a93c6a', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 85, 85, '2026-03-30T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('ce3cc465-c548-4b23-b481-72ab74b03dd7', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-30', 50, 85, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('02a0c462-4d6c-435d-960a-f5238d8dcbd0', 'ce3cc465-c548-4b23-b481-72ab74b03dd7', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 1, 1, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('21858ee7-4b4a-4872-8389-8dcaf86cc77f', '3c50816c-affd-4654-83a2-a4fb6def7419', '2d037e2e-5793-4dde-adda-0e25fabea338', 22, 'completed', '2026-03-30T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('58f31f11-4663-4d28-818e-c3b168f42be2', '21858ee7-4b4a-4872-8389-8dcaf86cc77f', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 22, 22, '2026-03-30T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('91d5b523-8a7e-4422-b2bb-77bd947366bb', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-30', 15, 22, 1, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0061ee83-6622-41fe-a320-cb8b174df14a', '91d5b523-8a7e-4422-b2bb-77bd947366bb', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 1, 1, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('cde09cd0-5cc2-4a0f-8597-1440117251fa', '242b409f-1ea9-4a66-8361-e38c287b8a14', '295672f7-ad03-49be-8afc-f7e31cabbe17', 210, 'completed', '2026-03-31T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1b752ff3-4a5f-453b-a695-dd13bc0fd33e', 'cde09cd0-5cc2-4a0f-8597-1440117251fa', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 3, 70, 210, '2026-03-31T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('8a16bca7-45b9-42cb-952a-beb89521ec21', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-03-31', 140, 210, 3, 1, 35, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('20e7d117-314f-4d63-b5d7-ce4d42e0a892', '8a16bca7-45b9-42cb-952a-beb89521ec21', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 3, 1, 35, 70, 35, 'expired');
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('ec09a6df-d0cd-4d09-b894-afbf9beb6248', '5c2df1d5-7847-4441-a23d-53c0bb5ea9d2', 'cc8eacf6-1b44-47af-b56e-7155440212fc', 510, 'completed', '2026-03-31T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('577ff16b-fc7e-4f22-96a0-cfa632898d33', 'ec09a6df-d0cd-4d09-b894-afbf9beb6248', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 85, 510, '2026-03-31T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('4f739449-b6d2-45c4-b477-ea0cf03cd9e2', 'cc8eacf6-1b44-47af-b56e-7155440212fc', '2026-03-31', 300, 510, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8707562b-0411-4918-a79e-0831f86b0fb5', '4f739449-b6d2-45c4-b477-ea0cf03cd9e2', 'dddbf095-34a8-42f5-b5ff-93ef240fc428', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('91bf2655-8099-446c-aaee-0d31de3f15ee', '763a854e-0d3b-4508-8b6e-ed2c34c44251', '2d037e2e-5793-4dde-adda-0e25fabea338', 132, 'completed', '2026-03-31T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('66765733-7d05-46b7-905a-925a41c887a8', '91bf2655-8099-446c-aaee-0d31de3f15ee', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 22, 132, '2026-03-31T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('252f6df0-4ed4-4825-a774-2a4f088ff721', '2d037e2e-5793-4dde-adda-0e25fabea338', '2026-03-31', 90, 132, 6, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c529307d-b645-4932-91de-ee23604db377', '252f6df0-4ed4-4825-a774-2a4f088ff721', 'b06d347e-209c-4c35-a97e-1efad5f3bba5', 6, 6, 0, 15, 22, 0, NULL);
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                          VALUES ('8f52ac6e-fc2d-4644-9664-b40ab65bb10d', 'e9daad6c-9835-4b37-86c1-d291f93bcdd6', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', 125, 'completed', '2026-03-31T00:00:00.000Z');
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                          VALUES ('1d515cba-2ea8-4d14-a9c1-88d350e49a1f', '8f52ac6e-fc2d-4644-9664-b40ab65bb10d', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 25, 125, '2026-03-31T00:00:00.000Z');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('57968ade-0c45-4658-a2ff-7e8db75f2899', '4e47c9e2-a921-466d-9c97-9931d2d26c5e', '2026-03-31', 50, 125, 5, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('102be5a5-d60b-4c28-9357-03d0b9828e95', '57968ade-0c45-4658-a2ff-7e8db75f2899', 'ae92aaf7-9ae0-422c-aa2d-3dfdb291b648', 5, 5, 0, 10, 25, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('1a246a60-f1df-4899-b06d-64d997ad47be', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-01', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dfafa39c-c16d-4c78-817d-3494c84d41b1', '1a246a60-f1df-4899-b06d-64d997ad47be', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('9a7e641b-f3fa-4e63-aace-6fd5666631f9', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-02', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('879cc0a3-a89b-4427-a2f9-7da9ef5678d4', '9a7e641b-f3fa-4e63-aace-6fd5666631f9', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('349fcff4-1a42-49fc-813a-0fb6575776c0', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-03', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('343cea27-e0ab-4dea-92cd-6fc483b4c585', '349fcff4-1a42-49fc-813a-0fb6575776c0', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('b6d20f45-d64f-4510-82b1-9acce58e536c', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-04', 140, 210, 3, 1, 35, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e9a18532-6aea-472a-ade7-fa006a73db07', 'b6d20f45-d64f-4510-82b1-9acce58e536c', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 3, 1, 35, 70, 35, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('755d7bd7-363f-4780-b98c-0df6573597dc', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-07', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1116ab2e-500f-479c-a82c-8554862f909c', '755d7bd7-363f-4780-b98c-0df6573597dc', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('da2fa84a-1238-4a16-8037-0d9d22c8226a', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-08', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4cd29edf-4e7b-4645-9839-187b6d26b36e', 'da2fa84a-1238-4a16-8037-0d9d22c8226a', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('0b0b8aa6-af04-40d1-94e7-8611826d2d3d', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-09', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('35121946-6383-4dbd-95a6-8d2d2ef4dbc1', '0b0b8aa6-af04-40d1-94e7-8611826d2d3d', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('11969ba4-1281-4552-b3c6-765e87909c87', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-10', 140, 280, 4, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('193b5a0d-5814-4f4d-a889-a989440afafe', '11969ba4-1281-4552-b3c6-765e87909c87', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 4, 0, 35, 70, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                      VALUES ('07985bb8-7822-4f0b-bee0-69c97aa9b356', '295672f7-ad03-49be-8afc-f7e31cabbe17', '2026-04-11', 140, 210, 3, 1, 35, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('34563949-cd73-4020-b923-aa25e068b243', '07985bb8-7822-4f0b-bee0-69c97aa9b356', '8299809d-5c1b-4df8-b31e-fcbea2d7d751', 4, 3, 1, 35, 70, 35, 'expired');
COMMIT;