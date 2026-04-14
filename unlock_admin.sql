UPDATE users SET is_active=true, failed_login_attempts=0, locked_until=NULL WHERE email='jarassanchezl@gmail.com';
SELECT email, is_active, failed_login_attempts, locked_until FROM users WHERE email='jarassanchezl@gmail.com';
