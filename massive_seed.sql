-- MASSIVE DATA SEED V3.1 - CLEAN START
BEGIN;
TRUNCATE TABLE sale_details, daily_sales, inventory_records, products, categories, users CASCADE;

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
              VALUES ('740a0f73-ce7a-423d-bc3f-67a94e9dcd09', 'master@tienditacampus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Admin', 'Master', 'admin', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('ce21b49f-4627-43de-8852-aef7e2c86e9f', 'antonio.hoyos@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Antonio', 'de Hoyos', 'seller', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('3f15e936-c14f-43f1-82b3-9e71aa6f4405', 'vendedor1@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Juan', 'Perez', 'seller', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('efcb46dd-2131-4263-b2e9-f6c9522117c8', 'vendedor2@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Maria', 'Gomez', 'seller', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('a3a67c98-0a18-4199-be8b-1c1b7497c823', 'vendedor3@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Luis', 'Rodriguez', 'seller', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('fa5f573d-5bf7-46ad-a62c-981d12a42645', 'comprador1@campus.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'Estudiante', 'Prueba', 'buyer', true, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('6adfbf5b-0cc7-4a55-92c0-b60668abb9e8', 'user1@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '1', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e3408f4b-a7f3-4e5a-8582-0546f5377ee9', 'user2@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '2', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('f3b6780f-cf6a-4fc3-857b-f69b13681dd9', 'user3@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '3', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('1dac4c5b-cc0b-4127-ad70-aeb505870cc9', 'user4@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '4', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('97ae6588-2b93-483e-80c8-e24adad2350b', 'user5@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '5', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('fcddfb67-f056-49bc-89e8-13d9fe717c23', 'user6@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '6', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('9edb9ba6-4393-40a0-bbda-d77ae6913e94', 'user7@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '7', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('8ba7771d-af56-481d-9528-c03629102e55', 'user8@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '8', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('bbf80d4c-d245-4631-a1b3-da9310377c11', 'user9@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '9', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c29110bc-6f16-47d4-ae70-8e3850c2b263', 'user10@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '10', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('b8cc95c7-7385-4f21-aafb-9ccfc56990f0', 'user11@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '11', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('5df198f3-ffba-4f29-9c0a-67e31975a1e9', 'user12@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '12', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('94caaf74-e510-4407-b101-f35f0b8a6845', 'user13@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '13', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('41f1f854-576d-4e4e-ab6b-094b01828b30', 'user14@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '14', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('d101bddb-7729-4eeb-ac4e-92e7e428f04a', 'user15@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '15', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('6a3a991f-436f-48a1-b6b7-217adaf71e42', 'user16@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '16', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('8845f6ce-13ac-4fd9-975c-90f50bdef9b4', 'user17@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '17', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('06da6d0f-b608-4291-8c95-2509a22f8e91', 'user18@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '18', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('db626c81-2bf5-40d9-90e3-4698f056120e', 'user19@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '19', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('719f1441-de7f-4ecd-8b95-1ed89e4009a9', 'user20@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '20', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e2571dcb-b635-4c47-b9b8-fc313d3a4822', 'user21@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '21', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('38d51cee-dd18-49e4-a2de-665fe412fcb1', 'user22@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '22', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('349cccfd-0d3f-4ff0-9d6a-bfe0d223f7cc', 'user23@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '23', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('e7c321ba-4618-4a44-8158-cd0a51a92fce', 'user24@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '24', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('a9446775-81bd-49ed-a8d3-629f00e41bab', 'user25@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '25', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('2fd8cfc9-5bb4-47cf-a24d-801733faad05', 'user26@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '26', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c4ec8856-deac-41ee-a7d0-9efda0681f04', 'user27@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '27', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('0b93d719-3b84-4163-831f-a899bfaba0b0', 'user28@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '28', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('76e58e7a-fef3-454c-9a3c-922ed9d54bff', 'user29@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '29', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('63396ec7-1702-4c20-b31c-bb1012463e73', 'user30@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '30', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c6ca5f56-4e91-4c6f-933d-9c9360d90afa', 'user31@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '31', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('eeea4480-195e-4721-ab55-5c211708455f', 'user32@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '32', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('c9b5db96-ac9d-4542-bf70-2d15f25844fc', 'user33@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '33', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('d6e720a1-7a2d-4002-a73f-d6fcbad52ab9', 'user34@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '34', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('dcf920c8-c75c-471e-8c8a-2092648a8638', 'user35@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '35', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('1a733408-11d4-4abe-802f-896acfaa92aa', 'user36@inactive.com', '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0', 'User', '36', 'buyer', false, true, '2026-02-08T00:00:00.000Z');
INSERT INTO categories (id, name, description) VALUES ('5ef75bc2-ced2-43a1-a39c-bfd061448c79', 'Comida Preparada', 'Platillos caseros hechos por alumnos');
INSERT INTO categories (id, name, description) VALUES ('bf70dfeb-1c7b-48da-8768-8772c9c94a1f', 'Bebidas', 'Refrigerios fríos y calientes');
INSERT INTO categories (id, name, description) VALUES ('3c1371b6-670c-4889-8b17-f886db29d011', 'Snacks', 'Botanas y golosinas');
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '5ef75bc2-ced2-43a1-a39c-bfd061448c79', 'Burritos Mixtos', 'Frijoles con queso y guisado', 45, 70, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('3dbda863-b00b-4680-a990-1a16c8d8e0bd', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 100, 50, 45, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('2e6e43c3-7f55-4be7-b0f7-9b8408964d83', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', 'bf70dfeb-1c7b-48da-8768-8772c9c94a1f', 'Coca-Cola 600ml', 'Muy fría', 14, 20, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('3401059a-34bf-4eac-a448-9c9c7d96e271', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 100, 50, 14, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '5ef75bc2-ced2-43a1-a39c-bfd061448c79', 'Torta de Chilaquiles', 'Picositas y ricas', 50, 85, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('8e5763ef-74ca-43d2-89d0-9d4621acb4f6', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 100, 50, 50, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('84127a30-b0ed-48ba-8f16-51da93168869', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', 'bf70dfeb-1c7b-48da-8768-8772c9c94a1f', 'Café Americano', 'Café de grano recién hecho', 8, 25, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('1dc606f4-b6ed-449f-950c-b31d55ab6ed5', '84127a30-b0ed-48ba-8f16-51da93168869', 100, 50, 8, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('3da9be99-5450-4d21-960c-bfbabe080a8f', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '3c1371b6-670c-4889-8b17-f886db29d011', 'Papas Caseras', 'Con sal y limón', 15, 35, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('334b0e77-bbcf-414f-a202-1e0e319e9a5b', '3da9be99-5450-4d21-960c-bfbabe080a8f', 100, 50, 15, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('04f68469-aee3-44de-8033-48c491e7a02d', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', 'bf70dfeb-1c7b-48da-8768-8772c9c94a1f', 'Agua de Horchata', '100% natural', 12, 30, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('7c55e405-4bd6-45e6-9190-59b020fea215', '04f68469-aee3-44de-8033-48c491e7a02d', 100, 50, 12, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('eecaac52-1b86-4775-9a3d-969ac7ac994e', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '3c1371b6-670c-4889-8b17-f886db29d011', 'Brownie de Chocolate', 'Horneados hoy mismo', 18, 40, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('bcabfc89-e56c-464f-810a-309e92b416a5', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 100, 50, 18, 'active', NOW());
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('5a72b529-1198-4ec8-8407-056623947621', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '5ef75bc2-ced2-43a1-a39c-bfd061448c79', 'Ensalada de Frutas', 'Fresca y variada', 25, 50, true, '2026-02-08T00:00:00.000Z', true);
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('fcba2119-5fb4-4cf9-99e4-38b6330cb456', '5a72b529-1198-4ec8-8407-056623947621', 100, 50, 25, 'active', NOW());
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4f5a6688-6627-4b39-99ae-8bc816d855e1', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-08', 435, 700, 15, 2, 60, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e85d86b0-03c9-4fb5-829b-a1db93c7562e', '4f5a6688-6627-4b39-99ae-8bc816d855e1', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 5, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e94b50f9-3188-467f-bd56-f942c3a48674', '4f5a6688-6627-4b39-99ae-8bc816d855e1', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 10, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a9dacedd-4557-45a5-acfa-9799c10cca06', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-08', 224, 410, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c90940a2-7921-4733-a745-c472daed3371', 'a9dacedd-4557-45a5-acfa-9799c10cca06', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 10, 10, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5ffaad35-ab0b-4d75-a342-62ba39024e0e', 'a9dacedd-4557-45a5-acfa-9799c10cca06', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f7f70e5f-0abf-4f59-ab80-709d17015842', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-08', 744, 1340, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9c66ca5b-f068-4da9-a026-6fc2fcb4bd04', 'f7f70e5f-0abf-4f59-ab80-709d17015842', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6ed7e47d-eb44-4bff-97b9-af79d126f717', 'f7f70e5f-0abf-4f59-ab80-709d17015842', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 8, 8, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('bdcab324-fa08-4688-b3e2-3a11b9879c48', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-08', 296, 700, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a178c8df-73af-46f3-8053-77b3e6b1e8ee', 'bdcab324-fa08-4688-b3e2-3a11b9879c48', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 12, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4a140278-33b9-4879-bf6a-627a709924d6', 'bdcab324-fa08-4688-b3e2-3a11b9879c48', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d4197221-991b-4e09-8668-d43af2ac71ca', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-09', 570, 1015, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ab32a993-8f13-4bd8-8ad5-817b6f0ce7a3', 'd4197221-991b-4e09-8668-d43af2ac71ca', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6fd56122-8517-4484-8169-96f9bd124a9c', 'd4197221-991b-4e09-8668-d43af2ac71ca', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 11, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('df4ccc40-2cd4-4007-8bd7-e4490cf2c3c9', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-09', 144, 250, 10, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('29065def-ebb6-4cee-90d5-9f419811c882', 'df4ccc40-2cd4-4007-8bd7-e4490cf2c3c9', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 5, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6292524d-a2e8-4e78-ac70-aed8e802ec5d', 'df4ccc40-2cd4-4007-8bd7-e4490cf2c3c9', '04f68469-aee3-44de-8033-48c491e7a02d', 5, 5, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6b5b8dc0-f3dd-4364-802b-5ea8dc7114a4', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-09', 726, 1260, 18, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a38f9ade-d182-4255-a48b-2f2f42edf452', '6b5b8dc0-f3dd-4364-802b-5ea8dc7114a4', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e6e91069-e8c7-43da-bd42-9f52645fd423', '6b5b8dc0-f3dd-4364-802b-5ea8dc7114a4', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 6, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ccf82fea-56d6-4412-bc6d-0712a18dc64a', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-09', 255, 600, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d2ca8323-df7a-44cf-9643-aa5742ba00c2', 'ccf82fea-56d6-4412-bc6d-0712a18dc64a', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6943c2de-fa3e-406d-adb6-5d4ef00682df', 'ccf82fea-56d6-4412-bc6d-0712a18dc64a', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c4741160-9ff0-40d0-b19e-06592ee9bc81', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-10', 615, 1050, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('84f22c5c-1b4f-4bc3-abb7-046e6189f445', 'c4741160-9ff0-40d0-b19e-06592ee9bc81', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 11, 11, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e491e757-492a-4641-a5bf-5fd528061ffa', 'c4741160-9ff0-40d0-b19e-06592ee9bc81', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 8, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('87681533-4031-47be-afce-557fe1a9f837', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-10', 252, 450, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ff34106e-0c46-4891-b872-791127ee94bc', '87681533-4031-47be-afce-557fe1a9f837', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('82cdddab-e34f-4941-bb3d-3436a6be0845', '87681533-4031-47be-afce-557fe1a9f837', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('0fc20ecd-fb3d-4fa0-9e71-feeea1c7220d', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-10', 530, 995, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e686c730-3190-49bc-8228-836dc4551063', '0fc20ecd-fb3d-4fa0-9e71-feeea1c7220d', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('424525f7-96de-47b9-a960-62e242e9f747', '0fc20ecd-fb3d-4fa0-9e71-feeea1c7220d', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6fc8ecbb-31c1-423c-ab3e-8ba9a7fb723f', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-10', 396, 850, 23, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b4608e9a-850d-4a03-9c61-62b5bfdd5f77', '6fc8ecbb-31c1-423c-ab3e-8ba9a7fb723f', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 12, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bc396af2-85e2-495e-992f-6f56b415cdbc', '6fc8ecbb-31c1-423c-ab3e-8ba9a7fb723f', '5a72b529-1198-4ec8-8407-056623947621', 12, 11, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8ca6842b-c2a2-437b-a29b-09f05fa48e7a', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-11', 720, 1260, 24, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('571a20f4-f584-4391-bacc-41f453f1c470', '8ca6842b-c2a2-437b-a29b-09f05fa48e7a', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a463db38-2a4c-4139-98a5-879148809068', '8ca6842b-c2a2-437b-a29b-09f05fa48e7a', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('7d73a55e-a56d-42d4-a08b-b4731b5d9a00', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-11', 182, 350, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dda0426c-3e80-4bff-902f-1cfedd46eb14', '7d73a55e-a56d-42d4-a08b-b4731b5d9a00', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 7, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0266dc7a-3506-483e-ada5-72f8824b3996', '7d73a55e-a56d-42d4-a08b-b4731b5d9a00', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('679c26cf-5ba4-408b-8448-92ef2c9ee7bd', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-11', 616, 1120, 19, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9f08425c-3537-4758-9c78-0bfb53be4ee7', '679c26cf-5ba4-408b-8448-92ef2c9ee7bd', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2aa5e5ec-346e-4c5d-89ea-e961d9f2fc4a', '679c26cf-5ba4-408b-8448-92ef2c9ee7bd', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 11, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('84bc34e0-bc33-4ee9-b59f-78994ffbf9a7', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-11', 198, 450, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f2383088-ff99-4315-a1ea-257505adfc9c', '84bc34e0-bc33-4ee9-b59f-78994ffbf9a7', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 6, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a48c6b66-5492-4603-bc9b-1429c84eb047', '84bc34e0-bc33-4ee9-b59f-78994ffbf9a7', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('438b4c24-ea7a-4c06-996c-c95affa85f8f', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-12', 420, 665, 13, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8095dd55-47f6-4cea-8286-2ce8b89a06ee', '438b4c24-ea7a-4c06-996c-c95affa85f8f', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 6, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2b0dc6bb-90ec-4e28-b416-d90c68d7702f', '438b4c24-ea7a-4c06-996c-c95affa85f8f', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b7197e26-94d3-4077-9178-d364c6efb125', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-12', 262, 490, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8c89577a-cd24-4599-83e5-b624347f5fd2', 'b7197e26-94d3-4077-9178-d364c6efb125', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 11, 11, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('732c7c15-cc4d-44be-aff4-6864bdf22dd5', 'b7197e26-94d3-4077-9178-d364c6efb125', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('fc9525be-25d8-4c5a-9b0b-7d7d7fe47e93', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-12', 540, 880, 13, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6fb8503e-337f-4438-90a6-c2f352644860', 'fc9525be-25d8-4c5a-9b0b-7d7d7fe47e93', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 8, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e65618f6-d630-4ffe-84aa-3e1352121278', 'fc9525be-25d8-4c5a-9b0b-7d7d7fe47e93', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('7714028f-71a6-4d8d-9e71-e3418c40772d', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-12', 239, 550, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ff97319e-6f9a-4bdc-a4ae-f42afe4493c0', '7714028f-71a6-4d8d-9e71-e3418c40772d', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9438707c-785c-4f8b-bb04-722b58a9ddaf', '7714028f-71a6-4d8d-9e71-e3418c40772d', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a8c3a69d-aeb8-4d60-a805-4b37f5936940', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-13', 405, 770, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('90e1531e-9a31-4814-8525-92fcaa4db272', 'a8c3a69d-aeb8-4d60-a805-4b37f5936940', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5c0c98c6-e19c-434d-9d68-e2f7ac4abe39', 'a8c3a69d-aeb8-4d60-a805-4b37f5936940', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a6211e30-1211-4594-a6ad-e2a9b367efa5', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-13', 166, 310, 12, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3ad6d88d-f36d-4613-8956-c1da5ba97fc8', 'a6211e30-1211-4594-a6ad-e2a9b367efa5', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('528ca083-5e05-4e8e-a5b6-aff1d1620c19', 'a6211e30-1211-4594-a6ad-e2a9b367efa5', '04f68469-aee3-44de-8033-48c491e7a02d', 8, 7, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1f2d42ea-43b7-4bca-9722-d40d2eb72e01', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-13', 690, 1220, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e0210392-fef9-4d4e-a79f-fd517d56cf83', '1f2d42ea-43b7-4bca-9722-d40d2eb72e01', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8a47441b-46ad-4fa2-b6e5-34b3fbd95a15', '1f2d42ea-43b7-4bca-9722-d40d2eb72e01', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ccbd04ff-1e90-404e-85b3-7ff0020187fc', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-13', 256, 575, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3f46374c-a57c-4e26-8334-6f15df64ba9a', 'ccbd04ff-1e90-404e-85b3-7ff0020187fc', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 7, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cddf7ee8-70e6-48b5-987f-6d56546e80fa', 'ccbd04ff-1e90-404e-85b3-7ff0020187fc', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('88d68b29-06dc-4e22-92e9-ed605fa17b3c', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-14', 645, 1085, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1aa38d88-cb8e-4bff-b32f-ceb0dca9e969', '88d68b29-06dc-4e22-92e9-ed605fa17b3c', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be8ff90e-477e-4780-8b45-aaababceac66', '88d68b29-06dc-4e22-92e9-ed605fa17b3c', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3d392975-5edd-49e1-85ac-f68da795df5b', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-14', 312, 600, 24, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('055fcf8c-eea5-42b4-85a7-89a03b12b128', '3d392975-5edd-49e1-85ac-f68da795df5b', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('068bef10-8773-49d2-afc5-bbf49bb9927c', '3d392975-5edd-49e1-85ac-f68da795df5b', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('48dc514f-fcdc-4155-909a-7b905dcfc922', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-14', 576, 1045, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7bdb8e1d-994a-48a6-af3b-0692fbfb57d4', '48dc514f-fcdc-4155-909a-7b905dcfc922', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e64fb826-3a60-41a9-b34e-e5b6f38a3c1f', '48dc514f-fcdc-4155-909a-7b905dcfc922', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 7, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e5618a19-da2a-4672-90c3-5c54c95ea868', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-14', 355, 775, 20, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('26825010-7011-48ef-87b6-89e1d00b524a', 'e5618a19-da2a-4672-90c3-5c54c95ea868', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 9, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1d38bf1a-7da2-47ed-b3ee-d6b24e2c5adf', 'e5618a19-da2a-4672-90c3-5c54c95ea868', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f3b15613-4995-410d-9202-dcc4e2aa3043', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-15', 600, 1015, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4af74449-e475-4cab-abb8-b899aa933b45', 'f3b15613-4995-410d-9202-dcc4e2aa3043', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 11, 11, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('aaa6e3b2-83f7-43e8-a50e-bbce471461d0', 'f3b15613-4995-410d-9202-dcc4e2aa3043', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5efdb405-4e6b-4c94-9153-7f3a40fe8156', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-15', 144, 250, 10, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('442602ec-4e59-46c4-a210-3ce8982a151b', '5efdb405-4e6b-4c94-9153-7f3a40fe8156', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 5, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2876cb8a-4f0e-4efb-8519-d638fcfdd1ce', '5efdb405-4e6b-4c94-9153-7f3a40fe8156', '04f68469-aee3-44de-8033-48c491e7a02d', 5, 5, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('da05e57d-71a8-4dc1-a7e1-b84a5661f3e2', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-15', 490, 880, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3af3cad3-5209-45c9-a00b-4339a727decb', 'da05e57d-71a8-4dc1-a7e1-b84a5661f3e2', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e3cefbf3-0b4d-40c7-8c75-1755fca3bdb6', 'da05e57d-71a8-4dc1-a7e1-b84a5661f3e2', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('73f7e5d3-f973-4cea-a3da-909aa76fddfe', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-15', 238, 575, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('463ec804-7f54-4b7c-94db-698699c5837f', '73f7e5d3-f973-4cea-a3da-909aa76fddfe', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('85344f83-8f05-40fa-8ecc-989151c29e23', '73f7e5d3-f973-4cea-a3da-909aa76fddfe', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('acc3ab85-009c-4307-ad07-e8cd3eee411d', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-16', 495, 770, 14, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1e09509b-fcdb-438c-8f44-d5b364aee3f2', 'acc3ab85-009c-4307-ad07-e8cd3eee411d', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 8, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dc363e93-6668-4bf5-a2c8-029f00533682', 'acc3ab85-009c-4307-ad07-e8cd3eee411d', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('096fa911-d09f-46a2-aaed-6e2d1d90ab97', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-16', 196, 370, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('30dea751-d14b-4f87-9421-420201e33f04', '096fa911-d09f-46a2-aaed-6e2d1d90ab97', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7102a748-75d5-4e2e-96e9-8eac1a81d078', '096fa911-d09f-46a2-aaed-6e2d1d90ab97', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('0194ab6a-e3e8-40ab-902e-30fd0cbef80e', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-16', 530, 995, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('054e923e-9397-42c7-9c84-9f41ad91fe50', '0194ab6a-e3e8-40ab-902e-30fd0cbef80e', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('754327b8-5b36-46f4-86de-1b61bab96ad6', '0194ab6a-e3e8-40ab-902e-30fd0cbef80e', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1d896c06-8027-4a37-90d8-c91053ba89bc', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-16', 213, 475, 15, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('adfb8a03-eefc-4c37-9a81-64c36afa57ab', '1d896c06-8027-4a37-90d8-c91053ba89bc', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('25eb062a-676b-4ab8-998f-e9e88d0200df', '1d896c06-8027-4a37-90d8-c91053ba89bc', '5a72b529-1198-4ec8-8407-056623947621', 5, 4, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('15a57ec1-b4b0-4a2b-bfad-27946f4403f5', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-17', 405, 630, 12, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('21172e75-1519-41aa-bec6-2f222d90083a', '15a57ec1-b4b0-4a2b-bfad-27946f4403f5', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 6, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b5672079-cfd4-4e94-b861-de51c76f736c', '15a57ec1-b4b0-4a2b-bfad-27946f4403f5', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1cd861c8-1ffd-41c6-9d88-1fc1f8974ec3', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-17', 182, 330, 13, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e29b904b-c2d0-4028-9f17-686878543d8e', '1cd861c8-1ffd-41c6-9d88-1fc1f8974ec3', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 6, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1a3f0f9a-b950-452c-a45d-e78f81a2bc86', '1cd861c8-1ffd-41c6-9d88-1fc1f8974ec3', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('140c67c8-c363-4b1a-ac18-af7da7550e48', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-17', 580, 1080, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ce000455-c9e9-4c59-9fc2-49410c7fdc0e', '140c67c8-c363-4b1a-ac18-af7da7550e48', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('05510ac4-1c32-43a5-b4b1-db40169f4a49', '140c67c8-c363-4b1a-ac18-af7da7550e48', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a943397e-fad6-412c-b590-3dc789545756', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-17', 264, 600, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0f4fce0b-36d9-40b6-b446-eedefde6d7c6', 'a943397e-fad6-412c-b590-3dc789545756', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be37c4ec-6ef7-410c-8ca3-eb373a5c9a93', 'a943397e-fad6-412c-b590-3dc789545756', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a99341b1-f8e0-4a30-8c64-f6b53803966e', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-18', 675, 1155, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a7c4fa46-98f6-4bb2-9377-75fa2f7de028', 'a99341b1-f8e0-4a30-8c64-f6b53803966e', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8a79e9e2-8eeb-4a78-a898-f81822cffc3d', 'a99341b1-f8e0-4a30-8c64-f6b53803966e', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 9, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5e9a949f-f529-41e5-b936-5af1d56871f7', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-18', 312, 580, 23, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bd2f6957-a07b-4321-83d9-84dc8ba46a11', '5e9a949f-f529-41e5-b936-5af1d56871f7', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 11, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('26515b70-9dfb-4b9e-8b14-c77056b3e736', '5e9a949f-f529-41e5-b936-5af1d56871f7', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d1036d33-9ad0-41a6-8296-851147d2296d', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-18', 580, 995, 17, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('40f420c9-fc99-4eb0-9551-e3711814baaa', 'd1036d33-9ad0-41a6-8296-851147d2296d', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 7, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dd2db533-28a8-40e9-8161-183284d06043', 'd1036d33-9ad0-41a6-8296-851147d2296d', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('149c3870-d313-46d8-90ac-e804b5e95180', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-18', 263, 600, 17, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6a3b8096-26c3-4a62-89b3-f0300e6233f7', '149c3870-d313-46d8-90ac-e804b5e95180', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 10, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f0a95119-7744-4114-b468-048bc030943c', '149c3870-d313-46d8-90ac-e804b5e95180', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1917ebd6-9fe6-4940-91a8-217b657f74c4', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-19', 465, 840, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('99db00b9-b0a3-4f60-9cdd-df2e7b67f38a', '1917ebd6-9fe6-4940-91a8-217b657f74c4', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 7, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8990120d-3f15-48c3-95a3-803092c3674c', '1917ebd6-9fe6-4940-91a8-217b657f74c4', '3da9be99-5450-4d21-960c-bfbabe080a8f', 10, 10, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1c0931dd-3f32-4d90-aa05-41870c5c85be', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-19', 130, 220, 9, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e561c799-cdb3-42fb-88b1-f5d82813249c', '1c0931dd-3f32-4d90-aa05-41870c5c85be', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b8958dcb-b45d-42f7-83e1-7d863ac9b746', '1c0931dd-3f32-4d90-aa05-41870c5c85be', '04f68469-aee3-44de-8033-48c491e7a02d', 5, 4, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('846981e3-a0d2-4be3-ac84-a527880a5fcf', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-19', 662, 1125, 18, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7203aecf-c8ac-49cf-a1a4-0cc6072745f7', '846981e3-a0d2-4be3-ac84-a527880a5fcf', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 9, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8738af50-8406-4499-84e8-4794ba69705e', '846981e3-a0d2-4be3-ac84-a527880a5fcf', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('adaec848-67e0-4534-8e87-fe812c05ae4e', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-19', 289, 625, 16, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('54aafa52-c3ff-41ac-a04b-78c5f1cf5b4c', 'adaec848-67e0-4534-8e87-fe812c05ae4e', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 7, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ecff9bea-f41c-42bf-b5bb-3989b2deca3d', 'adaec848-67e0-4534-8e87-fe812c05ae4e', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b3d27da8-464a-4bf7-80f4-9ddef01a0986', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-20', 435, 700, 14, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f7ad5004-acbc-4b08-b13d-63c672a99acc', 'b3d27da8-464a-4bf7-80f4-9ddef01a0986', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 6, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b52ae974-842f-423b-8728-35df7b495364', 'b3d27da8-464a-4bf7-80f4-9ddef01a0986', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 8, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('75c7c648-3a39-4987-a882-5a3c22d9b7fa', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-20', 276, 510, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fdf16e5f-24e2-4e27-beed-32ec008ef86c', '75c7c648-3a39-4987-a882-5a3c22d9b7fa', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4b83a214-8579-4540-a956-c32e06fe3914', '75c7c648-3a39-4987-a882-5a3c22d9b7fa', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('0e3e6d9d-71ab-404e-a322-814a6f7cea36', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-20', 680, 1165, 19, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('66e6aeea-e449-4bf8-855d-29208e8117fb', '0e3e6d9d-71ab-404e-a322-814a6f7cea36', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 9, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ec197451-2512-4e35-82e8-7e04cbcfb681', '0e3e6d9d-71ab-404e-a322-814a6f7cea36', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('dccc7c8d-730b-48ba-a1e9-6f6dad6f0109', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-20', 363, 775, 21, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fb5c7d94-b0a1-48df-8d69-f7c1820268e5', 'dccc7c8d-730b-48ba-a1e9-6f6dad6f0109', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9fa224ff-9da8-4fae-a243-433edb0df179', 'dccc7c8d-730b-48ba-a1e9-6f6dad6f0109', '5a72b529-1198-4ec8-8407-056623947621', 11, 10, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4a5271dd-79af-4c53-8e1b-873da2502f52', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-21', 720, 1260, 24, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1efedd3b-733b-4b51-9fb6-7bce11ae26bf', '4a5271dd-79af-4c53-8e1b-873da2502f52', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b4591ece-4d10-4849-bd5b-5d26d067dc2b', '4a5271dd-79af-4c53-8e1b-873da2502f52', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('22066933-9549-401d-aab9-d33ad1592038', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-21', 206, 390, 15, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('68c58e71-3a0b-4e7e-ac1d-7a9362f03c0c', '22066933-9549-401d-aab9-d33ad1592038', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 6, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c5879999-26fc-43f4-8542-ad3c026112ce', '22066933-9549-401d-aab9-d33ad1592038', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3c3bd21b-5009-47bd-9d5d-0e67bfa92300', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-21', 698, 1290, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5e1cd7f4-4800-4f9a-aae6-8d576fbf8a88', '3c3bd21b-5009-47bd-9d5d-0e67bfa92300', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('97c6078e-065f-40d5-97ec-22d30ac40452', '3c3bd21b-5009-47bd-9d5d-0e67bfa92300', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6f7e3465-404c-4204-89dc-85052f8de80a', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-21', 296, 700, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7de157f4-6466-484e-a9f6-e7815a96d1a9', '6f7e3465-404c-4204-89dc-85052f8de80a', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 12, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2d636ddc-57ee-431d-b7eb-af5e66ed145d', '6f7e3465-404c-4204-89dc-85052f8de80a', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('9446835c-bcd7-4bf1-9214-fb6ea18e5414', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-22', 405, 770, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6c747bdf-3363-4117-a04f-ca48337a510d', '9446835c-bcd7-4bf1-9214-fb6ea18e5414', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9bd7c3ea-6f8e-4394-b766-92403361e935', '9446835c-bcd7-4bf1-9214-fb6ea18e5414', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3e6d240b-32ed-4700-a7cc-f515f8d0c2af', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-22', 216, 450, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('301dd65e-372f-4830-a903-db2dbe06942a', '3e6d240b-32ed-4700-a7cc-f515f8d0c2af', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('154ae575-a114-449b-be79-a5ae5554c801', '3e6d240b-32ed-4700-a7cc-f515f8d0c2af', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 11, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a0de62f5-5a72-455f-9739-2905226f3313', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-22', 616, 1160, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7ec4c365-28dc-43d1-aa16-29aadf4e0b55', 'a0de62f5-5a72-455f-9739-2905226f3313', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0b8aa141-ba01-4578-995a-1e926b024e4e', 'a0de62f5-5a72-455f-9739-2905226f3313', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 12, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('44dcfe87-3645-4723-91ad-7179daf63ac0', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-22', 289, 650, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('75d04b27-26d4-46f3-bcb8-8a54291a2983', '44dcfe87-3645-4723-91ad-7179daf63ac0', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0b663c46-faa6-41a7-9d37-ad244f4a7369', '44dcfe87-3645-4723-91ad-7179daf63ac0', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('014f05ff-430b-4f92-8777-e2b8b6a2cc00', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-23', 675, 1190, 23, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('67ec2b31-90ec-478d-8cbc-86323384413b', '014f05ff-430b-4f92-8777-e2b8b6a2cc00', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 11, 11, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('83befbdc-091e-4c04-80cc-adf9b9969869', '014f05ff-430b-4f92-8777-e2b8b6a2cc00', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('66036093-9260-4b52-ad74-5c0a757b3d0e', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-23', 202, 430, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2c158b11-f9de-4bf4-bee6-afe20d0d3026', '66036093-9260-4b52-ad74-5c0a757b3d0e', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('60566953-2d7f-4c88-b116-adadc76a4f16', '66036093-9260-4b52-ad74-5c0a757b3d0e', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 11, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('95e36508-2bb4-4b57-8282-22a0b954bc93', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-23', 540, 965, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4b66dec3-2355-42af-9bd0-d1e1e2dd59a3', '95e36508-2bb4-4b57-8282-22a0b954bc93', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('14d78ff1-40a3-4972-8817-151e05d5e4cd', '95e36508-2bb4-4b57-8282-22a0b954bc93', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('7e06a232-102c-4886-941b-d65e737f299a', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-23', 173, 400, 11, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dd59d5fb-f11e-4cce-aa02-268623d82471', '7e06a232-102c-4886-941b-d65e737f299a', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 6, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fc437630-df13-4613-ae6d-37f3c94761ff', '7e06a232-102c-4886-941b-d65e737f299a', '5a72b529-1198-4ec8-8407-056623947621', 5, 5, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('fd91b0db-a6e5-467f-ac8b-480b50876f73', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-24', 435, 805, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('95fa62ab-7a86-4471-a6ab-fc6439dc42d5', 'fd91b0db-a6e5-467f-ac8b-480b50876f73', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c9696847-d6f7-42f4-bea7-1e36c69abe0d', 'fd91b0db-a6e5-467f-ac8b-480b50876f73', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 11, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6dfe8dea-a000-4224-b59a-e7e2c651e08a', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-24', 260, 500, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f481aeb7-272c-4233-b762-3322be2a509e', '6dfe8dea-a000-4224-b59a-e7e2c651e08a', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 10, 10, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('998ff2e8-7b90-4d02-b045-de52a3f7464e', '6dfe8dea-a000-4224-b59a-e7e2c651e08a', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('72f7c6a3-c2e9-49db-89de-729e5bc9570d', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-24', 590, 1050, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fb52227e-ed62-4834-8341-5cc6ddcf4619', '72f7c6a3-c2e9-49db-89de-729e5bc9570d', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2fef0a50-aad6-4774-8a38-7710015a3a9a', '72f7c6a3-c2e9-49db-89de-729e5bc9570d', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('65c6cd65-571c-4587-90ed-0e7f987bc5f1', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-24', 363, 800, 21, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('244b32a4-2815-4e67-94a5-7bb33328c034', '65c6cd65-571c-4587-90ed-0e7f987bc5f1', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 10, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b8915d99-21af-4d5e-96f9-c21838f877d3', '65c6cd65-571c-4587-90ed-0e7f987bc5f1', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2d18a04b-187e-4765-a945-323f086428b5', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-25', 510, 875, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c66ab70b-c755-468a-bca6-6e13046334bc', '2d18a04b-187e-4765-a945-323f086428b5', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0a29e489-df31-4179-a20e-8ad8535031bd', '2d18a04b-187e-4765-a945-323f086428b5', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('073e0d07-d324-4ef8-89b6-16e061446ddd', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-25', 230, 470, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3941e6e4-50b9-4e9f-ad5c-673e4d6f9bf8', '073e0d07-d324-4ef8-89b6-16e061446ddd', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 7, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c5bd011e-1b2a-4279-8e8a-a62edc01a450', '073e0d07-d324-4ef8-89b6-16e061446ddd', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 11, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2898d7be-5cf2-4fd5-858c-3135b62473b7', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-25', 444, 830, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be13e190-a667-4d40-b057-7b54b6c311c2', '2898d7be-5cf2-4fd5-858c-3135b62473b7', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('60e8ec0a-8bf6-472d-8b7f-96d006e8dc8d', '2898d7be-5cf2-4fd5-858c-3135b62473b7', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 8, 8, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('db4ae842-3e80-481c-9de8-1bfd0fd83774', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-25', 206, 450, 12, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('572cb90a-f342-46a1-b670-bbfd088de3f3', 'db4ae842-3e80-481c-9de8-1bfd0fd83774', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 6, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0b596b71-fa1f-49a4-9b28-d371de9eba4c', 'db4ae842-3e80-481c-9de8-1bfd0fd83774', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ebf7affb-7336-4be5-b775-519a4e440e11', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-26', 300, 525, 10, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a2e3edba-9565-407e-94fc-a39c57c1a908', 'ebf7affb-7336-4be5-b775-519a4e440e11', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('86f6da33-6bb7-489a-88c9-be0df7ce584e', 'ebf7affb-7336-4be5-b775-519a4e440e11', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('095602be-f3e0-4b1d-9781-5cf1882b3162', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-26', 168, 330, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('46b25c67-215a-423a-859f-e06d95debac7', '095602be-f3e0-4b1d-9781-5cf1882b3162', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('129c604a-52be-4907-9346-b881dbbf2ea5', '095602be-f3e0-4b1d-9781-5cf1882b3162', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('84741438-983c-49db-9e4c-d58430c21a39', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-26', 744, 1340, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d876a78a-2566-487d-99c7-3b4f64bf5f06', '84741438-983c-49db-9e4c-d58430c21a39', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bed357ed-4450-4b3f-8f4b-ffaa55cc4195', '84741438-983c-49db-9e4c-d58430c21a39', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 8, 8, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e790b762-bd9f-4e61-8295-2c8277293233', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-26', 197, 475, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7969c5a2-6250-44b1-b7b7-c93b682e8373', 'e790b762-bd9f-4e61-8295-2c8277293233', '84127a30-b0ed-48ba-8f16-51da93168869', 9, 9, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6e58d075-dbc3-4da2-b2e7-7d06da1d572c', 'e790b762-bd9f-4e61-8295-2c8277293233', '5a72b529-1198-4ec8-8407-056623947621', 5, 5, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1b85c4d8-add8-46a7-98ad-18409b73d1f6', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-27', 555, 945, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('334030ac-8c1b-4dc2-b999-bc77d9e8648c', '1b85c4d8-add8-46a7-98ad-18409b73d1f6', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 10, 10, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8c0eea65-80ff-4b38-85b9-87642097ce96', '1b85c4d8-add8-46a7-98ad-18409b73d1f6', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('63540841-b6e5-4efb-87eb-928de71a7e8c', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-27', 238, 430, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d65946f2-d2eb-4798-887f-bdda134c5cde', '63540841-b6e5-4efb-87eb-928de71a7e8c', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 11, 11, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a7ef3ab2-1ad9-4c41-8378-30c06357f967', '63540841-b6e5-4efb-87eb-928de71a7e8c', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('03c767a0-a1b0-473b-9a9a-e7914b624df7', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-27', 762, 1295, 20, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a7c9e6b3-8aca-4f43-a594-ae4d57167d73', '03c767a0-a1b0-473b-9a9a-e7914b624df7', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 11, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b416a9c5-5a32-4eb2-bbd2-f7a627581509', '03c767a0-a1b0-473b-9a9a-e7914b624df7', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('9cca9fb2-2443-49f0-8e1b-7c0d76cd2b4d', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-27', 213, 525, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a0cc6075-d409-40a9-8562-bb22b987248b', '9cca9fb2-2443-49f0-8e1b-7c0d76cd2b4d', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d068c691-0a17-4483-b364-78cc389792ad', '9cca9fb2-2443-49f0-8e1b-7c0d76cd2b4d', '5a72b529-1198-4ec8-8407-056623947621', 5, 5, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('edd525e2-d455-4d95-97cc-eda3273fd34a', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-02-28', 360, 630, 13, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('13416a0e-b2d4-4c44-8f31-91c05e6de6b5', 'edd525e2-d455-4d95-97cc-eda3273fd34a', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('49466667-8039-4d84-b21b-5758b5cd4c7a', 'edd525e2-d455-4d95-97cc-eda3273fd34a', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 8, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a83c55f1-3b04-4c92-9e1b-38e7e9f23f69', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-02-28', 166, 340, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f15d408e-5aab-4a9e-a6ad-c0e9a4f5dedf', 'a83c55f1-3b04-4c92-9e1b-38e7e9f23f69', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('89faa46a-fd53-442e-8ee2-60f1d249e18d', 'a83c55f1-3b04-4c92-9e1b-38e7e9f23f69', '04f68469-aee3-44de-8033-48c491e7a02d', 8, 8, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d39fa48a-8388-4117-b319-49f38fcd1ae1', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-02-28', 358, 665, 11, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d1891b99-1d29-491d-99c4-45dc711aed33', 'd39fa48a-8388-4117-b319-49f38fcd1ae1', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7f2eb111-8fff-424b-80bd-4b80568a92e5', 'd39fa48a-8388-4117-b319-49f38fcd1ae1', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 6, 6, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8777277a-0897-4f06-8faf-716c78fab6e4', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-02-28', 315, 675, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('17229362-da63-4eb6-b2b8-9d17e83bef09', '8777277a-0897-4f06-8faf-716c78fab6e4', '84127a30-b0ed-48ba-8f16-51da93168869', 5, 5, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1ebb2d6c-a599-4f74-8085-d616b7b0f20b', '8777277a-0897-4f06-8faf-716c78fab6e4', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f89d958c-2341-4557-bd60-9bb5777141e4', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-01', 435, 770, 16, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e2b6d698-0061-4d99-a960-c3e00fc10e68', 'f89d958c-2341-4557-bd60-9bb5777141e4', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('74bffb96-bdc3-4095-bb74-3ea663fe6ca6', 'f89d958c-2341-4557-bd60-9bb5777141e4', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 10, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c5cc44b1-a86c-41d8-8e39-e7cea9a1cf29', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-01', 240, 420, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ed8ed1dd-e31b-4460-a20f-20ff9f4a719e', 'c5cc44b1-a86c-41d8-8e39-e7cea9a1cf29', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('28341a21-1b91-46da-95b6-5f02af8b1021', 'c5cc44b1-a86c-41d8-8e39-e7cea9a1cf29', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('52676dd3-642b-4e78-b166-ad7f660ba831', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-01', 480, 910, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fde4de1e-3b15-48a7-a626-07ca8de8aad0', '52676dd3-642b-4e78-b166-ad7f660ba831', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b41fd83e-e413-4c4c-af14-e343992b6d0c', '52676dd3-642b-4e78-b166-ad7f660ba831', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('021e88ec-f4f1-4720-a5f6-bac141623b73', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-01', 364, 800, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5d67768f-a82b-4dee-a8cd-40971feec3f1', '021e88ec-f4f1-4720-a5f6-bac141623b73', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a5a2d982-2bb0-4130-b9ed-75360caac529', '021e88ec-f4f1-4720-a5f6-bac141623b73', '5a72b529-1198-4ec8-8407-056623947621', 12, 12, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('be96a014-708c-495f-a23c-154e17830222', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-02', 390, 665, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be25d5f4-01cf-4ba3-8b67-9305d12087ef', 'be96a014-708c-495f-a23c-154e17830222', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 7, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d39fe4db-fb6b-4cf3-9cca-c792719302e8', 'be96a014-708c-495f-a23c-154e17830222', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3f96553d-9f7f-4d1c-85a3-822281db0a90', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-02', 210, 390, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0a939460-ee3c-49be-a81f-95a3e7a4b76b', '3f96553d-9f7f-4d1c-85a3-822281db0a90', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9e0443a0-543d-4958-8f3c-e63446a6ff90', '3f96553d-9f7f-4d1c-85a3-822281db0a90', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b3de9271-da07-4e24-8683-854cb6c48135', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-02', 798, 1460, 23, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('84afdcaa-1a55-4788-b2e4-49f73c4000ee', 'b3de9271-da07-4e24-8683-854cb6c48135', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('54759411-7788-4d02-9eef-8bbe72927f64', 'b3de9271-da07-4e24-8683-854cb6c48135', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('59edd3dd-e28d-417e-b73c-19113128bd8c', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-02', 289, 600, 16, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('74c42ca8-c411-43d2-bbc7-46c983547c2e', '59edd3dd-e28d-417e-b73c-19113128bd8c', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b583aef5-aef8-45c7-8da0-49ae0ad59c7d', '59edd3dd-e28d-417e-b73c-19113128bd8c', '5a72b529-1198-4ec8-8407-056623947621', 9, 8, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4e306fe0-1d61-4c5a-9403-022ae2f9bd23', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-03', 390, 700, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c0ab9765-563f-46b1-a16c-7d6570445bbe', '4e306fe0-1d61-4c5a-9403-022ae2f9bd23', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('439af333-9a8f-4966-b83f-38f4f0d2791f', '4e306fe0-1d61-4c5a-9403-022ae2f9bd23', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 8, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('88b29a0b-2a43-4ea3-a41d-2b7c01dc5f4e', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-03', 202, 400, 15, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2146754f-db96-46dc-9e2f-bf21304970d8', '88b29a0b-2a43-4ea3-a41d-2b7c01dc5f4e', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8dfc9e22-d478-41f0-80b6-6266a657508a', '88b29a0b-2a43-4ea3-a41d-2b7c01dc5f4e', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 10, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a9c11b4d-d74e-4586-b384-074dda2244e7', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-03', 466, 905, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('69a12654-544c-49e6-922c-8dde62fbb76c', 'a9c11b4d-d74e-4586-b384-074dda2244e7', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e1ddb548-6a4d-4106-bacb-9ce484a56f6c', 'a9c11b4d-d74e-4586-b384-074dda2244e7', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 12, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('df9d276a-b531-4ad9-bd34-cde3d321ac28', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-03', 230, 550, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a3451148-b438-484a-9fe1-a3814b7bcfe9', 'df9d276a-b531-4ad9-bd34-cde3d321ac28', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('88da0bb7-faaf-431c-b78e-5246f3242604', 'df9d276a-b531-4ad9-bd34-cde3d321ac28', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('35e06c3a-0df2-4209-a7a2-2fd38d93278c', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-04', 390, 665, 13, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5105b6fc-7c1a-4c08-8a9d-c1c5e9034227', '35e06c3a-0df2-4209-a7a2-2fd38d93278c', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9bb1716a-c0f1-4705-97f3-9f4ae39425a8', '35e06c3a-0df2-4209-a7a2-2fd38d93278c', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 7, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5c2d0d92-696a-403d-a480-67d97649b360', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-04', 246, 480, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b145c977-8c8e-41f9-b63b-844274c35a74', '5c2d0d92-696a-403d-a480-67d97649b360', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('76955e1d-f5a1-43c9-b03c-b4eb92b80e09', '5c2d0d92-696a-403d-a480-67d97649b360', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('59f9c47a-cce3-4aaf-ada3-7109d870285a', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-04', 576, 1045, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b8428ba9-c0fb-484e-a46f-17409ab590ce', '59f9c47a-cce3-4aaf-ada3-7109d870285a', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('594ac3f0-f689-4996-8d01-c8613a0ccd84', '59f9c47a-cce3-4aaf-ada3-7109d870285a', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 7, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8ddfd99f-aef5-4f78-b7a6-9202e6733680', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-04', 339, 750, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('618fc0ae-ce07-4fa9-b7f7-695993665f47', '8ddfd99f-aef5-4f78-b7a6-9202e6733680', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1091de81-d3aa-454e-9c3b-a0d949076df0', '8ddfd99f-aef5-4f78-b7a6-9202e6733680', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('aa89a1d3-56b1-4ded-9c3e-592ab6c57df7', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-05', 540, 840, 15, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c8a51149-2ea4-4ac9-afdb-03f98cbde2dd', 'aa89a1d3-56b1-4ded-9c3e-592ab6c57df7', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 10, 9, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('651fabbd-cb40-4982-a24c-9366d3bbed2e', 'aa89a1d3-56b1-4ded-9c3e-592ab6c57df7', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('189bff4f-4280-470e-adb3-70c5ce58c921', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-05', 240, 420, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0f399535-bf79-4209-9a7b-fa6ccc7a9139', '189bff4f-4280-470e-adb3-70c5ce58c921', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f9f7ac58-270b-41ee-ae59-4942b211a629', '189bff4f-4280-470e-adb3-70c5ce58c921', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d83d1c39-b73f-49d6-8194-0f13f8655a72', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-05', 716, 1205, 20, 2, 68, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5cb0dcb6-1853-4273-b929-1b02bd6c9da4', 'd83d1c39-b73f-49d6-8194-0f13f8655a72', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 9, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5f298fe0-2584-4fa4-a450-059b5943f395', 'd83d1c39-b73f-49d6-8194-0f13f8655a72', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 11, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2adcaef3-72e1-40e2-a692-fd4d67dc7418', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-05', 330, 750, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4e85ff29-242d-446c-9d6d-a6380280d50c', '2adcaef3-72e1-40e2-a692-fd4d67dc7418', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('10a2c7e5-9a01-4f4a-820f-2b94e6b45fef', '2adcaef3-72e1-40e2-a692-fd4d67dc7418', '5a72b529-1198-4ec8-8407-056623947621', 10, 10, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6121aa3f-ced8-4f6b-b109-698b0a66ab52', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-06', 435, 805, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c1d978cd-0fe8-4915-80dc-26f9b9fe837b', '6121aa3f-ced8-4f6b-b109-698b0a66ab52', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a6c78772-845c-400d-9f6a-2262d364f3e3', '6121aa3f-ced8-4f6b-b109-698b0a66ab52', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 11, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('227febd0-9f09-4a2e-8c36-fe9f179d6644', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-06', 208, 400, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('aab40174-7150-4459-b7c1-4914a1aef4b5', '227febd0-9f09-4a2e-8c36-fe9f179d6644', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ecb9a1a1-8234-41f3-9dd1-74159273cdf1', '227febd0-9f09-4a2e-8c36-fe9f179d6644', '04f68469-aee3-44de-8033-48c491e7a02d', 8, 8, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4c381e13-4c27-4ee7-a880-023ca5fbbd01', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-06', 412, 700, 13, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('11f57fff-06c3-4364-99d4-315ee273a81c', '4c381e13-4c27-4ee7-a880-023ca5fbbd01', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 5, 4, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('576ad297-7e6e-4347-b922-3a27ca8c0bbb', '4c381e13-4c27-4ee7-a880-023ca5fbbd01', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6f97a81b-b505-491b-86d4-a4c9be925f99', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-06', 280, 650, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0645986b-03fe-455f-b44b-98befec47365', '6f97a81b-b505-491b-86d4-a4c9be925f99', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9dd69587-3030-467a-a444-bf677a88b944', '6f97a81b-b505-491b-86d4-a4c9be925f99', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2cf9c283-6810-4271-9eb5-dd893576a424', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-07', 645, 1050, 20, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a1056efe-5c56-4038-9fd0-bb7a1d666798', '2cf9c283-6810-4271-9eb5-dd893576a424', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 11, 10, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a1aece62-3976-4b98-8b45-3a22fe1a65f5', '2cf9c283-6810-4271-9eb5-dd893576a424', '3da9be99-5450-4d21-960c-bfbabe080a8f', 10, 10, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f17be73f-f16a-40c8-8864-eabb24803985', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-07', 142, 280, 11, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f97ca5d6-8bfc-4324-bfea-6188ba687ef4', 'f17be73f-f16a-40c8-8864-eabb24803985', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e1f17350-5563-44a3-93e3-15bd45a630c9', 'f17be73f-f16a-40c8-8864-eabb24803985', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f70a924b-6edb-43ac-ba8e-af7c5a1e68b8', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-07', 612, 1040, 17, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('21365b28-2318-4e01-a6bf-f413d62eca80', 'f70a924b-6edb-43ac-ba8e-af7c5a1e68b8', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 8, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f2ac366f-d491-4321-84ff-b8287b125bdd', 'f70a924b-6edb-43ac-ba8e-af7c5a1e68b8', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ec2dd391-2f60-4966-8eb5-9ef8f6b07b91', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-07', 313, 700, 19, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d8adde4f-2234-43da-a3fc-f9bb1e63c155', 'ec2dd391-2f60-4966-8eb5-9ef8f6b07b91', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 10, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6cc7c55a-47bb-4171-a07e-b50c72fc7e09', 'ec2dd391-2f60-4966-8eb5-9ef8f6b07b91', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('53be7dbb-9fb7-4066-a554-33147d58eaee', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-08', 420, 665, 13, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ee38ead0-9414-4f77-88a2-2dbe07365c05', '53be7dbb-9fb7-4066-a554-33147d58eaee', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 6, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2b94e16b-2366-42a9-8e40-e895d6675812', '53be7dbb-9fb7-4066-a554-33147d58eaee', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('db371a1b-c97a-48cd-ac61-eb1a8e277ec1', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-08', 276, 510, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bd468686-7df5-4ad7-bf16-b11173c7f15a', 'db371a1b-c97a-48cd-ac61-eb1a8e277ec1', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('38a4c4aa-f869-43d5-a4b2-8940b44034d6', 'db371a1b-c97a-48cd-ac61-eb1a8e277ec1', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('208d560a-44e9-44da-8661-da90fdbf9d1c', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-08', 640, 1095, 15, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1adba233-b2ef-43ba-8e5c-ffe4e8e90188', '208d560a-44e9-44da-8661-da90fdbf9d1c', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 11, 11, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a55a1484-8700-4dcd-98ea-d9d08c8642b9', '208d560a-44e9-44da-8661-da90fdbf9d1c', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 4, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ef948156-94fa-484d-a7e1-7cd8518de8f8', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-08', 206, 475, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dfdf0b5b-0301-4b93-9430-5f2b5abf5133', 'ef948156-94fa-484d-a7e1-7cd8518de8f8', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 7, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('03e174c9-a668-44c3-a048-d2706e8e4490', 'ef948156-94fa-484d-a7e1-7cd8518de8f8', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d6565be3-c876-4ef2-bfa3-5c1e02bef542', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-09', 510, 875, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('54fd1d57-d9b4-4487-8abe-70796980226a', 'd6565be3-c876-4ef2-bfa3-5c1e02bef542', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6843cfc3-0d1c-4ce7-99d3-fd2670654c1e', 'd6565be3-c876-4ef2-bfa3-5c1e02bef542', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c46d6e94-315c-4100-95b0-46d09986b6fc', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-09', 258, 510, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7fd619df-3c31-4711-8c01-ddfdc41f14ef', 'c46d6e94-315c-4100-95b0-46d09986b6fc', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3025139a-ec87-444e-86fc-dfd9360b9f6a', 'c46d6e94-315c-4100-95b0-46d09986b6fc', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 11, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('99ab36b8-c363-4bf7-9655-79a8a5c7616c', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-09', 798, 1375, 22, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1025cc2e-8280-42a0-a606-a96701b8402c', '99ab36b8-c363-4bf7-9655-79a8a5c7616c', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 11, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e0d44cf7-7967-4277-b225-c1cd8728ab85', '99ab36b8-c363-4bf7-9655-79a8a5c7616c', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('fda89a24-27d2-4d90-a47f-5a866843df51', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-09', 338, 775, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9a914f96-db86-4a52-8256-3a2a0d80a1a6', 'fda89a24-27d2-4d90-a47f-5a866843df51', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dd0afdd9-5bf7-4cfa-831b-91922afd4506', 'fda89a24-27d2-4d90-a47f-5a866843df51', '5a72b529-1198-4ec8-8407-056623947621', 10, 10, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('802640b2-2e2c-411a-981b-d22df38d2f44', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-10', 435, 665, 12, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('01c6d076-548e-48e0-b84a-968a6332033f', '802640b2-2e2c-411a-981b-d22df38d2f44', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 8, 7, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2f4c49a4-06cb-47a2-8aa4-12b9b075094a', '802640b2-2e2c-411a-981b-d22df38d2f44', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('0da6d61b-d5a4-4f41-a46a-6f9663d74af7', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-10', 248, 470, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('08e2b9c0-dafc-465f-9caa-46fb060e04c6', '0da6d61b-d5a4-4f41-a46a-6f9663d74af7', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 10, 10, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b184d8c4-4299-444c-9a16-591c9ad0e537', '0da6d61b-d5a4-4f41-a46a-6f9663d74af7', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('08e5b6e0-d0c8-4f6a-b1c4-d2f17f545436', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-10', 448, 865, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5c3e097c-1424-453d-b6dd-fccde1315e88', '08e5b6e0-d0c8-4f6a-b1c4-d2f17f545436', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b0a6f215-07eb-4556-af31-2a6e99d0b4e0', '08e5b6e0-d0c8-4f6a-b1c4-d2f17f545436', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('36b3befb-b245-4358-a7e3-837a13799ed6', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-10', 330, 750, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f2b66e13-2650-4a60-bb78-3841c0ded5fa', '36b3befb-b245-4358-a7e3-837a13799ed6', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7b05d9a2-3244-40ae-96de-975e3984a7a6', '36b3befb-b245-4358-a7e3-837a13799ed6', '5a72b529-1198-4ec8-8407-056623947621', 10, 10, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1dc0179b-53a6-4f3a-a0a7-c0a777d9dd61', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-11', 390, 630, 13, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c35780c1-db91-4f2b-839f-ebb521c480a2', '1dc0179b-53a6-4f3a-a0a7-c0a777d9dd61', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 5, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7cd9294f-ef2c-4e9a-bc31-40114e86eb17', '1dc0179b-53a6-4f3a-a0a7-c0a777d9dd61', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 8, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('49f77026-529b-4413-8948-5163be97a1b9', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-11', 198, 360, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f81991e6-4f7c-448d-b8e8-afe3eec1e049', '49f77026-529b-4413-8948-5163be97a1b9', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f8e9d076-f909-44d2-a1ca-3e948627508e', '49f77026-529b-4413-8948-5163be97a1b9', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('42165ae4-385a-4797-a7b0-bc27cec7c3b9', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-11', 666, 1160, 20, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4ac11f3d-dfd2-40e7-8f7c-79bc23f01d4d', '42165ae4-385a-4797-a7b0-bc27cec7c3b9', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 8, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('192f1c44-2b50-4514-8c7c-941b2184a4b6', '42165ae4-385a-4797-a7b0-bc27cec7c3b9', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 12, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('24a6ede5-0754-4e2b-9cee-112e43ab7e3f', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-11', 238, 525, 16, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b65147ae-1436-4321-ad30-698d0a2bdfd3', '24a6ede5-0754-4e2b-9cee-112e43ab7e3f', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8cc7644c-b061-497d-ae46-c4e137438dcd', '24a6ede5-0754-4e2b-9cee-112e43ab7e3f', '5a72b529-1198-4ec8-8407-056623947621', 6, 5, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('9be0c664-934a-434a-8c5b-a41cdac3e7cd', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-12', 495, 840, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c4e93367-a051-41f4-be16-8c9009039b94', '9be0c664-934a-434a-8c5b-a41cdac3e7cd', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('093f580c-3d89-4add-83a4-cf032ae19313', '9be0c664-934a-434a-8c5b-a41cdac3e7cd', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('845acc5d-3de2-4bfc-8362-ecb63232e136', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-12', 220, 400, 16, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('be47b715-6d75-4953-b418-98eab1c066e0', '845acc5d-3de2-4bfc-8362-ecb63232e136', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('37f8ffe0-1d9c-4b35-b012-b4f4ecaf0d50', '845acc5d-3de2-4bfc-8362-ecb63232e136', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 8, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f2e5711e-a25d-41a1-afc2-5bdf3083bd67', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-12', 640, 1095, 15, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ef6bde51-18c6-4c77-b6fe-d641c12108ad', 'f2e5711e-a25d-41a1-afc2-5bdf3083bd67', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 11, 11, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e4610bcb-3e9b-47b2-b6ad-4f5132803cef', 'f2e5711e-a25d-41a1-afc2-5bdf3083bd67', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 4, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('353c06b8-6126-4119-b101-7c12dee219a5', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-12', 246, 550, 17, 1, 25, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1e961630-c5f8-4641-827d-b695f932208e', '353c06b8-6126-4119-b101-7c12dee219a5', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 12, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8e4cfad2-c06d-4927-a012-3cffd15e3953', '353c06b8-6126-4119-b101-7c12dee219a5', '5a72b529-1198-4ec8-8407-056623947621', 6, 5, 1, 25, 50, 25, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('79fa4193-c5b6-4431-975c-9fd0c35f18a6', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-13', 360, 595, 11, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9269b4ee-ce6a-457f-b4bc-af27020d669f', '79fa4193-c5b6-4431-975c-9fd0c35f18a6', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('dc1db153-0d8b-4686-ad1d-d9e783249e0b', '79fa4193-c5b6-4431-975c-9fd0c35f18a6', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 5, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('17e1cf64-42a4-4598-ba8d-76456a6a55f8', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-13', 170, 320, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('11c60dfe-52a0-4afd-91d8-e653b9cfac95', '17e1cf64-42a4-4598-ba8d-76456a6a55f8', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 7, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cc286882-4254-47ad-81ab-26802349e0f3', '17e1cf64-42a4-4598-ba8d-76456a6a55f8', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a1dac67d-9583-48ef-bb42-90353dcb5535', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-13', 590, 1050, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d696fe7b-2463-4ef8-aea1-555c1c84522d', 'a1dac67d-9583-48ef-bb42-90353dcb5535', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('250ffc02-e367-487d-a0e0-e247df755712', 'a1dac67d-9583-48ef-bb42-90353dcb5535', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c5fc0a71-3494-4274-bfe9-d48a224b5d5e', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-13', 305, 700, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e7df9c33-cef5-4380-b1da-a080c3de90cb', 'c5fc0a71-3494-4274-bfe9-d48a224b5d5e', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3e41cf78-11ee-47b9-84d3-153644da03e8', 'c5fc0a71-3494-4274-bfe9-d48a224b5d5e', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3d9b982a-6b8a-4b1a-8aa3-a2a8e58a8134', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-14', 360, 630, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('559b920c-7382-4e2a-8e3c-b679b6b65e12', '3d9b982a-6b8a-4b1a-8aa3-a2a8e58a8134', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 6, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('10f9f78a-7a0c-4e0e-a564-62c688b8af2b', '3d9b982a-6b8a-4b1a-8aa3-a2a8e58a8134', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e831146f-551d-4d87-8c39-18ce75e36ce3', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-14', 196, 370, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a57f5695-6fe5-4470-8264-449684c2efdd', 'e831146f-551d-4d87-8c39-18ce75e36ce3', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('62c6f4ba-7491-46df-99a0-32847cf54588', 'e831146f-551d-4d87-8c39-18ce75e36ce3', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8fcfbf82-2427-44be-b8b9-f60d67f113d0', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-14', 540, 880, 13, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7593c2ee-e785-44de-ae75-e7c533bd5108', '8fcfbf82-2427-44be-b8b9-f60d67f113d0', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 8, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b28758be-d0cb-4b4a-9306-5f96f3c1ea5a', '8fcfbf82-2427-44be-b8b9-f60d67f113d0', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('685d8884-fd40-4cf2-ade4-08b67ea2ca99', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-14', 313, 725, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9105eb7f-dd31-44c3-be0a-a5c45d8241f6', '685d8884-fd40-4cf2-ade4-08b67ea2ca99', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0c4e9a9c-dc2e-42d7-821f-54c6862544d5', '685d8884-fd40-4cf2-ade4-08b67ea2ca99', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d0844150-ba7f-4e3e-adeb-db2ae7205014', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-15', 480, 805, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('427e6662-5d77-4aba-8cf1-480946688767', 'd0844150-ba7f-4e3e-adeb-db2ae7205014', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1d414080-3d76-4c1d-a536-ec2b3620c52a', 'd0844150-ba7f-4e3e-adeb-db2ae7205014', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ee231965-2e35-47ca-a841-50bbc66c8f89', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-15', 204, 420, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('51813bff-7df6-4842-8e32-23a6c50a234e', 'ee231965-2e35-47ca-a841-50bbc66c8f89', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3b500a17-083f-4278-a80b-b73873328329', 'ee231965-2e35-47ca-a841-50bbc66c8f89', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c78f7292-3782-4d1c-b819-772a76173ade', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-15', 490, 840, 12, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('730075fc-9014-4838-b999-6db906bf37fa', 'c78f7292-3782-4d1c-b819-772a76173ade', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d3c07d82-fe9d-4160-b2fe-d6376cce3501', 'c78f7292-3782-4d1c-b819-772a76173ade', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 4, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('005605ba-d49b-4693-b6be-8241b926256c', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-15', 348, 725, 17, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('287caf68-7163-4525-8855-ae9ced187cf7', '005605ba-d49b-4693-b6be-8241b926256c', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 5, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e0a60c0c-218c-4e9c-a0d7-18b1c3ad5561', '005605ba-d49b-4693-b6be-8241b926256c', '5a72b529-1198-4ec8-8407-056623947621', 12, 12, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d5a44fff-3707-4a9d-b6b3-55654643f65a', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-16', 420, 665, 13, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6e87149f-e9ff-4ce3-b565-d1f29303977c', 'd5a44fff-3707-4a9d-b6b3-55654643f65a', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 6, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4bb700e9-1c7c-4879-a398-ff1555f7973c', 'd5a44fff-3707-4a9d-b6b3-55654643f65a', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('388b885f-b76f-40b5-97a4-41a45b02d2b0', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-16', 184, 340, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('30d862c6-97ee-465d-8f0b-f52d3c7bf783', '388b885f-b76f-40b5-97a4-41a45b02d2b0', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('335aa29e-0771-4f46-93e0-67d1a6b64d32', '388b885f-b76f-40b5-97a4-41a45b02d2b0', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5ff6f4aa-1b0d-4481-861d-ead17d78605e', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-16', 748, 1375, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2aeca436-44ca-4cdc-9e0c-b3a65d5a746b', '5ff6f4aa-1b0d-4481-861d-ead17d78605e', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 11, 11, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e2a6ea8c-4a88-4eff-90a5-fba9414f3fe1', '5ff6f4aa-1b0d-4481-861d-ead17d78605e', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('acde7069-2546-4efe-af75-0b7edb41eb30', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-16', 371, 825, 22, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ad192fe1-3c16-487d-b95c-439e9ad20041', 'acde7069-2546-4efe-af75-0b7edb41eb30', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 11, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6d6be276-4f6f-436d-9de6-d410b1e21476', 'acde7069-2546-4efe-af75-0b7edb41eb30', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f8e823c5-994c-4442-a805-56e20e7c0d28', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-17', 435, 735, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('276ef53b-2caa-4504-a593-e598a34ff8c9', 'f8e823c5-994c-4442-a805-56e20e7c0d28', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 8, 8, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fc2b8ea9-bfd5-42d7-ac95-c9eef8d7d39e', 'f8e823c5-994c-4442-a805-56e20e7c0d28', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6088f28d-61b8-4852-8666-57f32e13f605', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-17', 228, 480, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7c2b37bc-65b6-4fec-bddb-6494d8b27782', '6088f28d-61b8-4852-8666-57f32e13f605', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('148251aa-98c5-4ecc-9a3c-0494128db4ab', '6088f28d-61b8-4852-8666-57f32e13f605', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e3cbbc23-40aa-4848-99a7-027766e4035f', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-17', 516, 950, 17, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5a637b69-c956-4559-8450-88d1d8f8b1c8', 'e3cbbc23-40aa-4848-99a7-027766e4035f', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c6cb434a-8867-4c67-b2e3-8a3f51555684', 'e3cbbc23-40aa-4848-99a7-027766e4035f', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 11, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('dc971414-d83f-4b85-ba35-584d5fab833b', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-17', 297, 650, 17, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('194b5098-aa4b-4a42-8aa7-ebaf53002feb', 'dc971414-d83f-4b85-ba35-584d5fab833b', '84127a30-b0ed-48ba-8f16-51da93168869', 9, 8, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4b43defd-0ef4-4d5a-a4fc-5a590479df56', 'dc971414-d83f-4b85-ba35-584d5fab833b', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('55472cb5-c22d-4f4a-b76c-048c0783bf30', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-18', 540, 945, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7e351855-06eb-4082-9683-049dc9dcdce9', '55472cb5-c22d-4f4a-b76c-048c0783bf30', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6186eb8a-83f3-4813-bc61-a1103809e7dc', '55472cb5-c22d-4f4a-b76c-048c0783bf30', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 9, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('bd82be5f-ea41-4663-b3a2-e9425ef897a4', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-18', 202, 430, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c8477cf2-4b19-4b34-8059-8ce66a29f7b2', 'bd82be5f-ea41-4663-b3a2-e9425ef897a4', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 5, 5, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('28e1409e-f251-4eb0-b8ab-e5fb19a381a9', 'bd82be5f-ea41-4663-b3a2-e9425ef897a4', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 11, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2ad5cec2-3a27-4a3f-b26d-0a591f9f267f', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-18', 716, 1245, 21, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e4b9df69-3b64-4c23-985f-ff87ebd0b764', '2ad5cec2-3a27-4a3f-b26d-0a591f9f267f', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 9, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cf6ef3aa-cdaa-4a14-8bfb-5e7732118356', '2ad5cec2-3a27-4a3f-b26d-0a591f9f267f', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 12, 12, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1630a190-ecf7-4f21-b5c3-175e24e3ea9d', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-18', 255, 600, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bd7e3acb-bd94-48e6-b199-0068a7144521', '1630a190-ecf7-4f21-b5c3-175e24e3ea9d', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('99089a26-c1ec-4c8b-85be-e0c4427f287d', '1630a190-ecf7-4f21-b5c3-175e24e3ea9d', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('25639fad-047c-41a5-9033-12cd6fb65dc4', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-19', 480, 805, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('39d62ea0-b23e-413a-bcb6-07f1a252f7be', '25639fad-047c-41a5-9033-12cd6fb65dc4', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e7b7ef7e-85a4-423a-a8ef-1b1da658aefa', '25639fad-047c-41a5-9033-12cd6fb65dc4', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f6c919d5-6bb4-44e1-840d-2d4976eed0a5', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-19', 204, 420, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a1064004-e7de-47a9-9e7b-b99b7fdcae57', 'f6c919d5-6bb4-44e1-840d-2d4976eed0a5', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ead24e3c-8a70-4cc0-8de0-435bcadb3da8', 'f6c919d5-6bb4-44e1-840d-2d4976eed0a5', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3e9e502c-1a17-4931-9e7d-cca8cd0de732', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-19', 608, 1090, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0a4ff5e1-eaef-4999-ae42-01c33073ddd6', '3e9e502c-1a17-4931-9e7d-cca8cd0de732', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bb33429b-ee27-40a1-8e67-350957db5e47', '3e9e502c-1a17-4931-9e7d-cca8cd0de732', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 6, 6, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('bcdc60ca-eed8-4b0d-8f7c-ff26bbdf4a0b', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-19', 339, 750, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d361ef22-0d4c-4b8c-aa23-98dee33e1ae3', 'bcdc60ca-eed8-4b0d-8f7c-ff26bbdf4a0b', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fcf93540-4d5d-4a23-9735-afe2d925906c', 'bcdc60ca-eed8-4b0d-8f7c-ff26bbdf4a0b', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e13d3e10-b401-4139-ad76-6952802f217a', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-20', 360, 630, 13, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('93cbd76f-337a-45bd-a160-2d5d322b1860', 'e13d3e10-b401-4139-ad76-6952802f217a', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('37259307-b864-4d14-ad62-5d13b2e3d92e', 'e13d3e10-b401-4139-ad76-6952802f217a', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 8, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('77e728f7-bb99-4b5f-ab21-cef8ceb7deb2', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-20', 234, 450, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ce230e98-5502-4245-890e-bd90b5ec7d89', '77e728f7-bb99-4b5f-ab21-cef8ceb7deb2', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b14c2327-01e4-4024-9afd-4473a351d100', '77e728f7-bb99-4b5f-ab21-cef8ceb7deb2', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('eb345c10-545a-4865-8b12-c6a73abb8e88', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-20', 476, 875, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('274d953d-34ba-4352-92fe-e6ab1bbc7bdb', 'eb345c10-545a-4865-8b12-c6a73abb8e88', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('26e5dfcd-94ae-4a62-b2b9-1a93296d2d38', 'eb345c10-545a-4865-8b12-c6a73abb8e88', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 7, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('1f308590-913d-4b07-a4cc-38d627ef7bc9', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-20', 289, 650, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c0236ed5-b2ab-4613-848d-106d7ab97561', '1f308590-913d-4b07-a4cc-38d627ef7bc9', '84127a30-b0ed-48ba-8f16-51da93168869', 8, 8, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8ec15148-4aeb-4ded-a16b-4fea7b534010', '1f308590-913d-4b07-a4cc-38d627ef7bc9', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('58985216-9535-46c0-9c3f-e8afad4de1c1', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-21', 450, 805, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('837bd7d6-9c5d-4a10-902e-610b9ac44997', '58985216-9535-46c0-9c3f-e8afad4de1c1', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 7, 7, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9e3e4c19-ccd8-443f-b614-d43ec4bafb85', '58985216-9535-46c0-9c3f-e8afad4de1c1', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 9, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c8a98516-a9fa-4fe0-84f1-7fe3e044ad42', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-21', 270, 540, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7785765c-6a01-4fc4-932a-6e9061fc3349', 'c8a98516-a9fa-4fe0-84f1-7fe3e044ad42', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4d3f8043-f600-46ca-991d-b758806c9471', 'c8a98516-a9fa-4fe0-84f1-7fe3e044ad42', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('69254be0-ebf6-449c-94b0-bffe72f66ad2', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-21', 594, 1085, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4244ba99-df8c-45b3-b3d7-65b93a0fafec', '69254be0-ebf6-449c-94b0-bffe72f66ad2', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6208cd90-efb2-4cdb-b3d7-a434e4e136dd', '69254be0-ebf6-449c-94b0-bffe72f66ad2', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 8, 8, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('760f8d5f-dfce-45d0-a2b9-639d2ca75eec', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-21', 363, 825, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('173e4e67-e5fa-4ef8-a02c-def4067070be', '760f8d5f-dfce-45d0-a2b9-639d2ca75eec', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('fcf2967e-1976-4232-8261-b89bebb0d824', '760f8d5f-dfce-45d0-a2b9-639d2ca75eec', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ecd25b3c-6775-46d6-9b12-8d2eb6b60ea7', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-22', 585, 1050, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('11c693eb-79f6-448c-a592-e5cd1035e8c2', 'ecd25b3c-6775-46d6-9b12-8d2eb6b60ea7', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cc2f4ef7-b652-4ad3-b0cd-19c60564463b', 'ecd25b3c-6775-46d6-9b12-8d2eb6b60ea7', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('def562ad-64c4-41ec-865a-c3618c8c5187', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-22', 192, 340, 13, 2, 26, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c775aca8-225c-402d-ac32-53c51643ee71', 'def562ad-64c4-41ec-865a-c3618c8c5187', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 5, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('31dec5c2-76e1-4bf7-80ec-8cbcde33c000', 'def562ad-64c4-41ec-865a-c3618c8c5187', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 8, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b026c668-9f91-4baf-9466-300bcf7f7a5d', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-22', 548, 1035, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('45469fd8-3e86-4a90-a259-ce7ddb10db21', 'b026c668-9f91-4baf-9466-300bcf7f7a5d', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e3ae8336-8434-4b24-a1b4-1bf067067e04', 'b026c668-9f91-4baf-9466-300bcf7f7a5d', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('225277f5-6f7d-4e46-8c01-a7422a9fbfdc', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-22', 305, 700, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ad764026-8d4f-4082-b8af-40d7b864ba29', '225277f5-6f7d-4e46-8c01-a7422a9fbfdc', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('04dd1890-058e-4368-a8d7-569c98a7a8b1', '225277f5-6f7d-4e46-8c01-a7422a9fbfdc', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f45caa54-293e-4429-99d8-e7dafb14afa6', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-23', 675, 1155, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('15335507-ae95-47ec-8d12-ee55ecddcfcb', 'f45caa54-293e-4429-99d8-e7dafb14afa6', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e51977db-4777-4cf5-ba08-9a541c7d34f2', 'f45caa54-293e-4429-99d8-e7dafb14afa6', '3da9be99-5450-4d21-960c-bfbabe080a8f', 9, 9, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('118639bd-66d6-48ac-bb3e-fd78fd524347', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-23', 192, 390, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bf3e6995-baa0-4490-beb9-d776374b0a5b', '118639bd-66d6-48ac-bb3e-fd78fd524347', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b86b65c8-eaf4-41c2-89cd-384287f7e47c', '118639bd-66d6-48ac-bb3e-fd78fd524347', '04f68469-aee3-44de-8033-48c491e7a02d', 9, 9, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ab1bc1c4-6bf0-4d2b-8579-55e6f0a67877', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-23', 512, 955, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7aeb4dd1-2632-42b4-a417-1c917a810d53', 'ab1bc1c4-6bf0-4d2b-8579-55e6f0a67877', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('61fc4901-5e3e-4eb0-b536-bf784b905475', 'ab1bc1c4-6bf0-4d2b-8579-55e6f0a67877', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('707c29f5-f1ce-4ff9-a258-03fb23a92681', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-23', 231, 500, 13, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0a4d7425-1b7c-4085-bb4b-88b9b0d1279f', '707c29f5-f1ce-4ff9-a258-03fb23a92681', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 6, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ec80371a-8d58-45b2-a5ee-3c74550065b0', '707c29f5-f1ce-4ff9-a258-03fb23a92681', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('291f5c95-9433-42a3-9e46-ed4c9398581f', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-24', 330, 595, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8f709b8b-2c7a-481e-a992-c4b6f7561545', '291f5c95-9433-42a3-9e46-ed4c9398581f', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ca1a92d1-c1ff-4da9-b097-924f637f247d', '291f5c95-9433-42a3-9e46-ed4c9398581f', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c308c23a-251c-4347-981f-03eafb07240a', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-24', 144, 270, 11, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('23c7be52-4432-4a7c-9a5a-99494b219205', 'c308c23a-251c-4347-981f-03eafb07240a', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('11de40e1-bad4-4678-882c-76a53bfd15d3', 'c308c23a-251c-4347-981f-03eafb07240a', '04f68469-aee3-44de-8033-48c491e7a02d', 5, 5, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('3525969d-cdd7-4bcd-ab14-c8e6545fa808', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-24', 462, 870, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ba13184a-ecc2-40ec-9ab3-2b49e9d3b5f4', '3525969d-cdd7-4bcd-ab14-c8e6545fa808', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('732a426e-597d-41fb-bc05-b399f39b0a7e', '3525969d-cdd7-4bcd-ab14-c8e6545fa808', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('32676154-34b1-427f-bf2d-33f02821d241', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-24', 281, 600, 15, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0d1eb21f-1065-4b59-b197-270c38726aec', '32676154-34b1-427f-bf2d-33f02821d241', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 6, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('670467ee-1093-44e0-8ed9-2770e7873717', '32676154-34b1-427f-bf2d-33f02821d241', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d4012d1c-e179-431e-98bb-e317d12497be', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-25', 510, 840, 17, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('21dba239-ec41-4d3f-9c3a-452f183f618a', 'd4012d1c-e179-431e-98bb-e317d12497be', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 8, 7, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e865b940-cde2-4ec7-925f-3214de79d110', 'd4012d1c-e179-431e-98bb-e317d12497be', '3da9be99-5450-4d21-960c-bfbabe080a8f', 10, 10, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('475a07b0-1051-4a94-8899-26cebcb0b538', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-25', 170, 320, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('42aef9f2-869d-4d4c-8fbb-262b3fdcdfd6', '475a07b0-1051-4a94-8899-26cebcb0b538', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 7, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9004c6be-3f3e-4010-9bb1-747b29936a4a', '475a07b0-1051-4a94-8899-26cebcb0b538', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('60e0e908-35c7-46f0-8f83-077b5262fbbf', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-25', 612, 1125, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e707305e-4240-45b3-ba11-fa55199bb5ba', '60e0e908-35c7-46f0-8f83-077b5262fbbf', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3b523788-d360-4e9c-b35a-e023490d8466', '60e0e908-35c7-46f0-8f83-077b5262fbbf', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 9, 9, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5c7988c7-e1d7-407d-9b50-4e778b036ee9', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-25', 265, 575, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d27b8a64-cb74-427e-bde7-3e78ad497cec', '5c7988c7-e1d7-407d-9b50-4e778b036ee9', '84127a30-b0ed-48ba-8f16-51da93168869', 5, 5, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('07c753f5-b168-4044-a158-7ee42a142b62', '5c7988c7-e1d7-407d-9b50-4e778b036ee9', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2e2264ee-6d0a-4982-a219-a061267432b7', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-26', 450, 770, 17, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('408e8351-7795-42a2-83f8-3357c5e6090f', '2e2264ee-6d0a-4982-a219-a061267432b7', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 5, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('47ec02b6-4ca1-4d8d-9174-ef222fbf9fe8', '2e2264ee-6d0a-4982-a219-a061267432b7', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 12, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b2b21236-da9d-492d-927f-622de1a2b2c6', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-26', 228, 480, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('24fcd97e-8194-48d9-a308-5ec2907f2487', 'b2b21236-da9d-492d-927f-622de1a2b2c6', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('780e3360-25f2-442c-9533-6ea1b9871daa', 'b2b21236-da9d-492d-927f-622de1a2b2c6', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e333278d-9451-4de8-a48a-b60b50c77486', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-26', 498, 950, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9c52c661-cf6b-401c-b398-597dd1a43642', 'e333278d-9451-4de8-a48a-b60b50c77486', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('4f345885-1634-4514-b185-3742a0696c04', 'e333278d-9451-4de8-a48a-b60b50c77486', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d0f528be-f87c-4b4a-9a0c-b8fbc35dfb44', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-26', 215, 475, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9f2e19d8-0f4f-49f1-8da3-9f68b0c88267', 'd0f528be-f87c-4b4a-9a0c-b8fbc35dfb44', '84127a30-b0ed-48ba-8f16-51da93168869', 5, 5, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5ce32daa-091f-43c9-baac-0e2f3d39ba04', 'd0f528be-f87c-4b4a-9a0c-b8fbc35dfb44', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('19217eb1-5054-4b88-b931-7f2a296811ea', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-27', 480, 770, 13, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('69f9f789-c391-47be-a872-2c55b151f917', '19217eb1-5054-4b88-b931-7f2a296811ea', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('81b92d1d-6ccd-4bb8-8988-8a82eff452fd', '19217eb1-5054-4b88-b931-7f2a296811ea', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 4, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c29f53f4-df45-45a9-86c1-89195fc73198', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-27', 204, 420, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c5570e96-004a-46cc-8699-b181a4176325', 'c29f53f4-df45-45a9-86c1-89195fc73198', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f4df9d39-b0eb-4f78-8122-8ebfc5563244', 'c29f53f4-df45-45a9-86c1-89195fc73198', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('f9082224-4bf5-4206-b914-433bd055cea7', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-27', 598, 1120, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a318c9d8-035e-42a7-a87c-c14b781512a3', 'f9082224-4bf5-4206-b914-433bd055cea7', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5512c813-5d7b-4217-a0e5-00a1e3d75b48', 'f9082224-4bf5-4206-b914-433bd055cea7', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d859e5eb-7418-4115-87f5-4d5dec67ead9', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-27', 248, 550, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('50ae63a2-6e39-4912-9b0c-fcb74ee9c4f8', 'd859e5eb-7418-4115-87f5-4d5dec67ead9', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 6, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e67b487b-2fc6-4c81-bb7e-41476815b1ff', 'd859e5eb-7418-4115-87f5-4d5dec67ead9', '5a72b529-1198-4ec8-8407-056623947621', 8, 8, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('7eac118a-f7bb-40a1-9e63-449b953ff064', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-28', 630, 1085, 21, 1, 15, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c4cbc886-286e-400b-b4f6-1cc4752c727c', '7eac118a-f7bb-40a1-9e63-449b953ff064', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 10, 10, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('81ed204b-d505-4213-96c2-3af38ad8bec0', '7eac118a-f7bb-40a1-9e63-449b953ff064', '3da9be99-5450-4d21-960c-bfbabe080a8f', 12, 11, 1, 15, 35, 15, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6be8cc98-9c03-4ca4-bc36-5ce006912450', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-28', 230, 440, 17, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5a28f179-53eb-4f15-9f77-f6d912e33440', '6be8cc98-9c03-4ca4-bc36-5ce006912450', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 7, 7, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('58449fa9-2fe4-488d-ace5-516ac5fe86dd', '6be8cc98-9c03-4ca4-bc36-5ce006912450', '04f68469-aee3-44de-8033-48c491e7a02d', 11, 10, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('83d0421a-0ac1-419b-a896-7aeeb3aeb9d1', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-28', 780, 1420, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('066609cc-bc63-4eb2-bb9e-8181a2ad3689', '83d0421a-0ac1-419b-a896-7aeeb3aeb9d1', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f3c52826-b0a9-4659-85b9-960cda2b30a3', '83d0421a-0ac1-419b-a896-7aeeb3aeb9d1', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ac50df21-9406-4107-94db-83f0a4d22459', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-28', 230, 550, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ff384e6f-e77f-4e51-a71d-3b516c64e35d', 'ac50df21-9406-4107-94db-83f0a4d22459', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e296d31e-9a3c-4120-80b4-1bf6cc05756f', 'ac50df21-9406-4107-94db-83f0a4d22459', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4ae16108-b42c-4946-a80a-441b093c4d4e', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-29', 555, 875, 16, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9c173db7-ca5c-4cb4-81ed-33e5a0912121', '4ae16108-b42c-4946-a80a-441b093c4d4e', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 10, 9, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('eda688ba-e765-44c0-ab01-d94a109c9014', '4ae16108-b42c-4946-a80a-441b093c4d4e', '3da9be99-5450-4d21-960c-bfbabe080a8f', 7, 7, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2eb7f7d4-a6be-49bc-9539-ad30b1d1e4f7', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-29', 232, 460, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f04a21c6-919c-43d3-a0ae-4be49a0b8bfa', '2eb7f7d4-a6be-49bc-9539-ad30b1d1e4f7', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5d486a82-755d-4692-88cb-29f8dcdf2383', '2eb7f7d4-a6be-49bc-9539-ad30b1d1e4f7', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 10, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ca9a4301-e206-4e96-a0fc-9f4b94daf1d2', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-29', 540, 965, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('96027a70-f37d-4769-8f88-06ac84c12443', 'ca9a4301-e206-4e96-a0fc-9f4b94daf1d2', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 9, 9, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c9201e2c-921c-4acc-8dff-3c76efb1506b', 'ca9a4301-e206-4e96-a0fc-9f4b94daf1d2', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 5, 5, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c1f5ef3a-3f01-422e-9e5c-3e7dc36b7c6e', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-29', 313, 725, 20, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f7772aab-847f-49ad-b054-a59049d0f82c', 'c1f5ef3a-3f01-422e-9e5c-3e7dc36b7c6e', '84127a30-b0ed-48ba-8f16-51da93168869', 11, 11, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c251b705-2499-4048-8eeb-86a6ad98a96a', 'c1f5ef3a-3f01-422e-9e5c-3e7dc36b7c6e', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4e36dac4-1281-4980-80d7-988ceb061f9d', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-30', 660, 1155, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('80be3b80-0d8d-4dd7-ab51-05ac39993c77', '4e36dac4-1281-4980-80d7-988ceb061f9d', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 11, 11, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bcf877bc-2529-4ca8-b36a-2228b39e5880', '4e36dac4-1281-4980-80d7-988ceb061f9d', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 11, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('47df9775-61de-4385-8b58-7cb518b2f668', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-30', 312, 600, 24, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('53e76ba4-f9b5-4922-a0a1-931c53a6c59f', '47df9775-61de-4385-8b58-7cb518b2f668', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('69b0847b-9a8d-4406-bab6-1c5dea12e91c', '47df9775-61de-4385-8b58-7cb518b2f668', '04f68469-aee3-44de-8033-48c491e7a02d', 12, 12, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8acbc26b-91d3-44fe-8272-a3383985e74e', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-30', 780, 1420, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('175af0fd-eb8b-40c5-878a-502b7e5241b3', '8acbc26b-91d3-44fe-8272-a3383985e74e', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('00b2117c-5a4d-45cd-b5cd-880ab91d6387', '8acbc26b-91d3-44fe-8272-a3383985e74e', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d55441c9-f47a-4401-9df6-05c39663ca6d', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-30', 231, 525, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e581a36e-93df-475b-a22f-248ab042a14d', 'd55441c9-f47a-4401-9df6-05c39663ca6d', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 7, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e3ac0ae6-1834-443d-9ec4-0110dbdf147b', 'd55441c9-f47a-4401-9df6-05c39663ca6d', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('edb62181-7b02-4511-b346-19ad23f3823f', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-03-31', 615, 1015, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('254dfe7b-0540-4a12-9906-b5a059a2b270', 'edb62181-7b02-4511-b346-19ad23f3823f', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('486964f8-2be7-40ec-bb93-ced7a2d662d9', 'edb62181-7b02-4511-b346-19ad23f3823f', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6eca6f9b-5bb9-4e52-9ced-4f178501985a', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-03-31', 200, 330, 14, 1, 14, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('12ef45b2-bdaa-40c0-9c34-8e4e68f1f93c', '6eca6f9b-5bb9-4e52-9ced-4f178501985a', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 10, 9, 1, 14, 20, 14, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d133378a-3ca9-4686-bb16-93f5b34d57ea', '6eca6f9b-5bb9-4e52-9ced-4f178501985a', '04f68469-aee3-44de-8033-48c491e7a02d', 5, 5, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4688700c-5c9e-4b7e-85e2-15bba4da9a9d', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-03-31', 448, 865, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('48a65533-d5fd-4eca-b135-7d15ed8ea515', '4688700c-5c9e-4b7e-85e2-15bba4da9a9d', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 5, 5, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bc489309-6d15-4400-a4b3-3c281a07675e', '4688700c-5c9e-4b7e-85e2-15bba4da9a9d', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2d9f84a6-3759-454c-ac0a-6be6223149c1', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-03-31', 380, 825, 21, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('973d1dbf-5d07-4fd7-8eda-8cd85e2656af', '2d9f84a6-3759-454c-ac0a-6be6223149c1', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 9, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c9e3acc6-5071-43a8-a6e2-225372e18a0b', '2d9f84a6-3759-454c-ac0a-6be6223149c1', '5a72b529-1198-4ec8-8407-056623947621', 12, 12, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('83d6422c-6ce2-4ad5-afaa-08992886e51f', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-01', 480, 805, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('52de9709-4ff2-4279-af26-9cd88fcfc64a', '83d6422c-6ce2-4ad5-afaa-08992886e51f', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b2760a5b-85b0-4fe2-a81b-fdb4640c64e9', '83d6422c-6ce2-4ad5-afaa-08992886e51f', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('aa89e5f9-04f4-43df-90bd-131c9c154e3c', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-01', 196, 370, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('e70c1054-526c-4c4c-91cc-bd418150cf62', 'aa89e5f9-04f4-43df-90bd-131c9c154e3c', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 8, 8, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('607d9f10-7004-4c7e-ad79-3fec00da71db', 'aa89e5f9-04f4-43df-90bd-131c9c154e3c', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b918e6c6-687a-4581-9be4-44d00e0c8f4b', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-01', 458, 835, 13, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('75e3d9ad-2107-4c03-9d41-b6de8a966100', 'b918e6c6-687a-4581-9be4-44d00e0c8f4b', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 7, 7, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a08bba5a-b0d9-4805-a605-f51bb36aac70', 'b918e6c6-687a-4581-9be4-44d00e0c8f4b', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 6, 6, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('a49fe10c-a0ed-4d9d-80d2-03539ce1ac68', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-01', 198, 425, 11, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b8038870-c9f2-48ee-a94f-1d0e065f88fa', 'a49fe10c-a0ed-4d9d-80d2-03539ce1ac68', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 5, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f08eaaed-7318-4307-9c46-ec7a2a362a5a', 'a49fe10c-a0ed-4d9d-80d2-03539ce1ac68', '5a72b529-1198-4ec8-8407-056623947621', 6, 6, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('0c75c343-b409-4866-8e77-6a657e0e8e93', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-02', 375, 700, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9c240fdc-f8f8-451c-9349-12985a8cf014', '0c75c343-b409-4866-8e77-6a657e0e8e93', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 5, 5, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3b6c69d6-940f-4f57-9ec6-d9766308e546', '0c75c343-b409-4866-8e77-6a657e0e8e93', '3da9be99-5450-4d21-960c-bfbabe080a8f', 10, 10, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('78e388bb-1dd2-4236-942a-5b9e58d10740', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-02', 226, 400, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('836fcc22-58bd-4165-a500-2d113612fa6e', '78e388bb-1dd2-4236-942a-5b9e58d10740', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 11, 11, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('55c56f57-4b67-4647-a54a-51daa02af64b', '78e388bb-1dd2-4236-942a-5b9e58d10740', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d0ab52d9-fcc4-4715-80eb-0a65431c28fb', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-02', 508, 880, 13, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('5d3bbc4b-d4c5-4f85-97d4-db84b799d94a', 'd0ab52d9-fcc4-4715-80eb-0a65431c28fb', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 8, 8, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1f8bf965-5c7e-4cbd-bd0d-0210dd5cf462', 'd0ab52d9-fcc4-4715-80eb-0a65431c28fb', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 6, 5, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('b9eebb77-9f33-453d-beb5-47b69525552d', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-02', 205, 500, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f1fa9ac4-0c64-4583-b13b-656a62577778', 'b9eebb77-9f33-453d-beb5-47b69525552d', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('9252c920-4f5d-42e6-8e7e-428c4f760a6a', 'b9eebb77-9f33-453d-beb5-47b69525552d', '5a72b529-1198-4ec8-8407-056623947621', 5, 5, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('849d2acd-6bb6-4e2c-be6e-9966bd2467aa', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-03', 630, 1050, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('3c468cd2-2958-438e-9d8f-b62c1d08a828', '849d2acd-6bb6-4e2c-be6e-9966bd2467aa', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('cd93240c-f131-4547-a1c5-b59ee3d90f86', '849d2acd-6bb6-4e2c-be6e-9966bd2467aa', '3da9be99-5450-4d21-960c-bfbabe080a8f', 6, 6, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2731c850-33d4-4308-b0a1-f17e9be84944', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-03', 240, 420, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('44f1ddcb-03e2-42a2-9bf0-f8117b2ad724', '2731c850-33d4-4308-b0a1-f17e9be84944', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 12, 12, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b3fc796d-00d6-47dd-ba74-834975f9d925', '2731c850-33d4-4308-b0a1-f17e9be84944', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('6f164c07-641a-4b2e-8b0c-5c5a31cccf1f', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-03', 480, 870, 15, 1, 18, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('efc9e3d9-76e0-47bc-aac1-4ef1872c2c26', '6f164c07-641a-4b2e-8b0c-5c5a31cccf1f', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 6, 6, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('70b3f7a9-fece-4bc2-9bde-8b56241bb39e', '6f164c07-641a-4b2e-8b0c-5c5a31cccf1f', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 9, 1, 18, 40, 18, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('9871a3c0-5810-4ed3-a540-3e0a2ad76b3c', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-03', 281, 600, 15, 1, 8, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a27b4c5f-c9ac-41f8-a874-0f3b6d4c8012', '9871a3c0-5810-4ed3-a540-3e0a2ad76b3c', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 6, 1, 8, 25, 8, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('89af6d89-1abe-4080-9453-c747e8f6a696', '9871a3c0-5810-4ed3-a540-3e0a2ad76b3c', '5a72b529-1198-4ec8-8407-056623947621', 9, 9, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d4330171-c636-4fdc-a5c2-19be2572ecd1', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-04', 525, 945, 19, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('efe63f4a-cd6d-4971-ba2d-8762bfc2c5b4', 'd4330171-c636-4fdc-a5c2-19be2572ecd1', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 8, 8, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('93051311-b237-4e7e-b9ad-2f0c61cc298f', 'd4330171-c636-4fdc-a5c2-19be2572ecd1', '3da9be99-5450-4d21-960c-bfbabe080a8f', 11, 11, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ff26767e-040c-49c7-84db-bd2e3cb80936', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-04', 260, 470, 19, 1, 12, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f9f4fb06-c710-4b5e-9d74-1254a50f429c', 'ff26767e-040c-49c7-84db-bd2e3cb80936', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 10, 10, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('46ff1dbe-012d-4550-be50-caf1fb890901', 'ff26767e-040c-49c7-84db-bd2e3cb80936', '04f68469-aee3-44de-8033-48c491e7a02d', 10, 9, 1, 12, 30, 12, 'expired');
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('336f3143-df47-4e1b-8868-2823846d6433', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-04', 780, 1420, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('89ec3e17-6df0-47b8-bf3e-db888c4c378e', '336f3143-df47-4e1b-8868-2823846d6433', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 12, 12, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('515e9848-28be-48e7-b2ae-82572dc8198c', '336f3143-df47-4e1b-8868-2823846d6433', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 10, 10, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('19100476-745f-4eb1-9840-1ac7e51a782c', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-04', 255, 600, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1a93b12f-4bea-47dd-b433-f5a47ff30ec5', '19100476-745f-4eb1-9840-1ac7e51a782c', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('95df21ec-8271-4c2b-b2d6-042e6f207b57', '19100476-745f-4eb1-9840-1ac7e51a782c', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('50b8b4c6-d92d-464a-acb9-b4a070d30762', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-05', 525, 875, 15, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d80d94c7-1d27-44bf-aaf7-d3d469aa110a', '50b8b4c6-d92d-464a-acb9-b4a070d30762', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 10, 10, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('2dde6d96-b423-4ede-889c-845b349ff28d', '50b8b4c6-d92d-464a-acb9-b4a070d30762', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('d5239b54-1c33-45e0-a9c6-b7b382d4a80a', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-05', 180, 360, 14, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8833192c-76fb-462c-94a4-7e2a6f5a68ab', 'd5239b54-1c33-45e0-a9c6-b7b382d4a80a', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 6, 6, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('22b3aa87-f5d4-4ec1-939c-64377e91df24', 'd5239b54-1c33-45e0-a9c6-b7b382d4a80a', '04f68469-aee3-44de-8033-48c491e7a02d', 8, 8, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('2657fd71-89b1-44d7-afa4-8a476698367f', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-05', 698, 1290, 21, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('0f69275c-ac88-4e43-ab02-407b7b117fff', '2657fd71-89b1-44d7-afa4-8a476698367f', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('22bbb134-8a8b-46ff-808d-2bac8c609bc7', '2657fd71-89b1-44d7-afa4-8a476698367f', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('70e65764-91b9-4b0c-9390-f75ba561cb75', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-05', 323, 700, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c17d4eb2-50f2-4a21-98ca-1614a0cd89bf', '70e65764-91b9-4b0c-9390-f75ba561cb75', '84127a30-b0ed-48ba-8f16-51da93168869', 6, 6, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('b83ccf1f-be70-409c-b4d6-71dd90277837', '70e65764-91b9-4b0c-9390-f75ba561cb75', '5a72b529-1198-4ec8-8407-056623947621', 11, 11, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('bf3199c2-d647-453e-ab3a-1b76099b2024', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-06', 615, 1015, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('33a6e2cf-9083-4dcf-92bd-023b8fcb891c', 'bf3199c2-d647-453e-ab3a-1b76099b2024', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 12, 12, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c4866009-8d2e-484c-87eb-87a5d536221b', 'bf3199c2-d647-453e-ab3a-1b76099b2024', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('25de93c2-1be8-4536-bf8b-d820340a230f', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-06', 210, 390, 16, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ada4fd8d-9999-4966-995a-78356501493c', '25de93c2-1be8-4536-bf8b-d820340a230f', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 9, 9, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('52f7b066-b0cc-45cc-9fc7-bf2c6ed9f144', '25de93c2-1be8-4536-bf8b-d820340a230f', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('c05141b6-eb4b-42e7-b94a-46c86d2949fe', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-06', 748, 1375, 22, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('05528d3e-3d21-40d8-a8b2-ed111f7f4745', 'c05141b6-eb4b-42e7-b94a-46c86d2949fe', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 11, 11, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8fb85378-aa6b-4fe9-8fbf-93db8008f033', 'c05141b6-eb4b-42e7-b94a-46c86d2949fe', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 11, 11, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('5b17aa57-19f0-4552-b43b-804b53bf61ff', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-06', 181, 425, 12, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('73da5063-3330-4a97-8203-f48179f27019', '5b17aa57-19f0-4552-b43b-804b53bf61ff', '84127a30-b0ed-48ba-8f16-51da93168869', 7, 7, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('7784dd9b-e175-4f48-9bd5-5de3729b0742', '5b17aa57-19f0-4552-b43b-804b53bf61ff', '5a72b529-1198-4ec8-8407-056623947621', 5, 5, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('8fe1c059-4a35-412d-9c66-c18c3c4bb58b', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-07', 345, 525, 10, 1, 45, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f1e2b7f0-b29b-4050-9fc7-e7878bddf355', '8fe1c059-4a35-412d-9c66-c18c3c4bb58b', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 6, 5, 1, 45, 70, 45, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('55ee8f0f-183f-4503-b86a-523308389fac', '8fe1c059-4a35-412d-9c66-c18c3c4bb58b', '3da9be99-5450-4d21-960c-bfbabe080a8f', 5, 5, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('9579a2a6-2791-4a35-b367-232fed97cbd9', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-07', 226, 400, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('428b0195-46ed-4c52-a659-bfd2c90084b2', '9579a2a6-2791-4a35-b367-232fed97cbd9', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 11, 11, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('bbf5dc0a-74b1-4507-ab02-8bc3832fe12e', '9579a2a6-2791-4a35-b367-232fed97cbd9', '04f68469-aee3-44de-8033-48c491e7a02d', 6, 6, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('4c9a8506-c276-4a31-a895-545ce784ec88', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-07', 626, 1130, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ebb06df5-6ca9-412f-838d-0537274080a9', '4c9a8506-c276-4a31-a895-545ce784ec88', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 10, 0, 50, 85, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('6b61e566-4c49-4521-92bc-50d67c18025f', '4c9a8506-c276-4a31-a895-545ce784ec88', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 7, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('eece5045-b4d9-4817-9bde-a93d7e63e8d3', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-07', 396, 900, 24, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('40b7329d-8ca4-4ca1-aed0-b5d3b7da7a83', 'eece5045-b4d9-4817-9bde-a93d7e63e8d3', '84127a30-b0ed-48ba-8f16-51da93168869', 12, 12, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('d9bb2ea9-ed54-48af-aa37-a53514d38c30', 'eece5045-b4d9-4817-9bde-a93d7e63e8d3', '5a72b529-1198-4ec8-8407-056623947621', 12, 12, 0, 25, 50, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e7bb3b31-d32b-4e07-b98a-49a56f56c731', 'ce21b49f-4627-43de-8852-aef7e2c86e9f', '2026-04-08', 525, 910, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('69f2b71c-610d-441a-a996-06b72c2e7fce', 'e7bb3b31-d32b-4e07-b98a-49a56f56c731', 'b2f03711-2b73-4cc2-bb52-e71334bcfb6d', 9, 9, 0, 45, 70, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('c8159605-35ea-4207-966b-7850cb8790ff', 'e7bb3b31-d32b-4e07-b98a-49a56f56c731', '3da9be99-5450-4d21-960c-bfbabe080a8f', 8, 8, 0, 15, 35, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('ac0d6f07-ade0-4fd6-bdfd-1c137155081f', '3f15e936-c14f-43f1-82b3-9e71aa6f4405', '2026-04-08', 238, 430, 18, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('572d5941-c9ed-4178-9816-49684dff8354', 'ac0d6f07-ade0-4fd6-bdfd-1c137155081f', '2e6e43c3-7f55-4be7-b0f7-9b8408964d83', 11, 11, 0, 14, 20, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('1e19e0ab-ceba-4f3d-80d4-58d7b0b56a66', 'ac0d6f07-ade0-4fd6-bdfd-1c137155081f', '04f68469-aee3-44de-8033-48c491e7a02d', 7, 7, 0, 12, 30, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('af4023e9-a949-4a38-9bef-bafc20826a51', 'efcb46dd-2131-4263-b2e9-f6c9522117c8', '2026-04-08', 626, 1045, 16, 1, 50, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('f19c184a-ec40-4e8e-9c5f-571cf3ef8b32', 'af4023e9-a949-4a38-9bef-bafc20826a51', 'e47fd477-0d1b-48d0-bf67-9cbfcd92a5d8', 10, 9, 1, 50, 85, 50, 'expired');
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('8dfc974c-0f73-46c6-a955-20efcee1436a', 'af4023e9-a949-4a38-9bef-bafc20826a51', 'eecaac52-1b86-4775-9a3d-969ac7ac994e', 7, 7, 0, 18, 40, 0, NULL);
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('e5ff0f8c-217d-461e-b075-ef1a045a5aa8', 'a3a67c98-0a18-4199-be8b-1c1b7497c823', '2026-04-08', 255, 600, 17, 0, 0, true);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('ccd95627-d386-434c-bfd0-3c6a8ad22cb9', 'e5ff0f8c-217d-461e-b075-ef1a045a5aa8', '84127a30-b0ed-48ba-8f16-51da93168869', 10, 10, 0, 8, 25, 0, NULL);
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('a612ad43-16e9-4a80-99ba-2ee2978e1a5b', 'e5ff0f8c-217d-461e-b075-ef1a045a5aa8', '5a72b529-1198-4ec8-8407-056623947621', 7, 7, 0, 25, 50, 0, NULL);
COMMIT;