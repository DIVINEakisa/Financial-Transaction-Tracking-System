-- Fix passwords for all users
-- Password for all: Admin@123
USE ftts_db;

UPDATE users SET password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMye7FRZJQcZ3PEDpkq3MApZ1aQQGVPrzCi';

SELECT 'Passwords updated successfully!' as message;
SELECT email, role, LEFT(password_hash, 30) as hash_preview FROM users;
