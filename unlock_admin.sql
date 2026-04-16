-- Emergency Unlock and Re-hash for Admin Account
UPDATE users 
SET 
  failed_login_attempts = 0, 
  locked_until = NULL, 
  password_hash = '$argon2id$v=19$m=19456,t=2,p=1$JKxnt7qbhIzOERyUT+MiCw$5m0LK/5EeeOLG+QekLJbgMwMR2c8171aUtSyoWAhId8' 
WHERE email = 'jarassanchezl@gmail.com';
