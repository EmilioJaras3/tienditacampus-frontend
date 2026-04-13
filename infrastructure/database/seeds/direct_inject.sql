DELETE FROM users WHERE email = 'master@tienditacampus.com';

INSERT INTO users (id, email, password_hash, first_name, last_name, role) 
VALUES (
    gen_random_uuid(), 
    'master@tienditacampus.com', 
    '$argon2id$v=19$m=19456,t=2,p=1$eEuPX0rncbrhqyauxqwjFg$re8m+2AptH43M1r19yD0Xf8C9dM2WdHxIU+/7Bh', 
    'Super', 
    'Admin', 
    'admin'
);
