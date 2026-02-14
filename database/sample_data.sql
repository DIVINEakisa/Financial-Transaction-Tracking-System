-- =====================================================
-- FINANCIAL TRANSACTION TRACKING SYSTEM - SAMPLE DATA
-- =====================================================
-- This file contains sample data for testing purposes
-- Run this AFTER running schema.sql
-- =====================================================

USE ftts_db;

-- =====================================================
-- SAMPLE USERS
-- Password for all test users: Test@123
-- =====================================================
INSERT INTO users (full_name, email, password_hash, phone, role, status, last_login) VALUES
('John Smith', 'john.smith@example.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', '+1-555-0101', 'User', 'Active', NOW()),
('Sarah Johnson', 'sarah.johnson@example.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', '+1-555-0102', 'User', 'Active', NOW()),
('Michael Chen', 'michael.chen@example.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', '+1-555-0103', 'User', 'Active', NOW()),
('Emily Davis', 'emily.davis@example.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', '+1-555-0104', 'Manager', 'Active', NOW()),
('David Wilson', 'david.wilson@example.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', '+1-555-0105', 'User', 'Active', NOW());

-- =====================================================
-- SAMPLE ACCOUNTS
-- =====================================================
-- Admin user accounts (user_id = 1)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(1, 'Main Checking Account', 'Bank', 15240.50, 'USD', 'Active'),
(1, 'Savings Account', 'Bank', 25000.00, 'USD', 'Active'),
(1, 'Cash Wallet', 'Cash', 350.00, 'USD', 'Active'),
(1, 'Investment Portfolio', 'Other', 50000.00, 'USD', 'Active');

-- Manager user accounts (user_id = 2)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(2, 'Business Checking', 'Bank', 8500.75, 'USD', 'Active'),
(2, 'Personal Account', 'Bank', 12300.00, 'USD', 'Active'),
(2, 'Mobile Money', 'Mobile Money', 500.00, 'USD', 'Active');

-- John Smith accounts (user_id = 3)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(3, 'Chase Bank Account', 'Bank', 5420.30, 'USD', 'Active'),
(3, 'Emergency Fund', 'Bank', 3000.00, 'USD', 'Active'),
(3, 'Petty Cash', 'Cash', 200.00, 'USD', 'Active');

-- Sarah Johnson accounts (user_id = 4)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(4, 'Wells Fargo Checking', 'Bank', 7850.60, 'USD', 'Active'),
(4, 'PayPal Wallet', 'Mobile Money', 1200.00, 'USD', 'Active'),
(4, 'Travel Savings', 'Bank', 5500.00, 'USD', 'Active');

-- Michael Chen accounts (user_id = 5)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(5, 'Bank of America', 'Bank', 9320.45, 'USD', 'Active'),
(5, 'Credit Card', 'Credit Card', 0.00, 'USD', 'Active'),
(5, 'Cash Reserve', 'Cash', 500.00, 'USD', 'Active');

-- Emily Davis accounts (user_id = 6)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(6, 'Citibank Account', 'Bank', 18500.00, 'USD', 'Active'),
(6, 'Investment Account', 'Other', 35000.00, 'USD', 'Active');

-- David Wilson accounts (user_id = 7)
INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) VALUES
(7, 'TD Bank Checking', 'Bank', 6700.80, 'USD', 'Active'),
(7, 'Vacation Fund', 'Bank', 4200.00, 'USD', 'Active');

-- =====================================================
-- SAMPLE TRANSACTIONS - INCOME
-- =====================================================
-- Admin user income transactions
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
-- January 2026
(1, 1, 1, 'Income', 8500.00, 'Monthly Salary - January', '2026-01-01', 'Completed', 'TXN20260101000001'),
(1, 4, 3, 'Income', 1200.00, 'Investment Returns - Q4 2025', '2026-01-05', 'Completed', 'TXN20260105000002'),
(1, 1, 2, 'Income', 2500.00, 'Freelance Project - Website Development', '2026-01-15', 'Completed', 'TXN20260115000003'),
(1, 1, 5, 'Income', 500.00, 'Birthday Gift', '2026-01-20', 'Completed', 'TXN20260120000004'),
-- February 2026
(1, 1, 1, 'Income', 8500.00, 'Monthly Salary - February', '2026-02-01', 'Completed', 'TXN20260201000005'),
(1, 4, 3, 'Income', 850.00, 'Investment Dividends', '2026-02-10', 'Completed', 'TXN20260210000006'),
(1, 1, 2, 'Income', 1800.00, 'Freelance Project - Mobile App', '2026-02-14', 'Completed', 'TXN20260214000007');

-- John Smith income (user_id = 3)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(3, 8, 1, 'Income', 5400.00, 'Salary - January', '2026-01-01', 'Completed', 'TXN20260101100001'),
(3, 8, 2, 'Income', 750.00, 'Side Hustle Payment', '2026-01-18', 'Completed', 'TXN20260118100002'),
(3, 8, 1, 'Income', 5400.00, 'Salary - February', '2026-02-01', 'Completed', 'TXN20260201100003'),
(3, 8, 6, 'Income', 200.00, 'Gift from Parents', '2026-02-05', 'Completed', 'TXN20260205100004');

-- Sarah Johnson income (user_id = 4)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(4, 11, 1, 'Income', 6200.00, 'Monthly Salary - January', '2026-01-01', 'Completed', 'TXN20260101200001'),
(4, 12, 2, 'Income', 1500.00, 'Consulting Fees', '2026-01-22', 'Completed', 'TXN20260122200002'),
(4, 11, 1, 'Income', 6200.00, 'Monthly Salary - February', '2026-02-01', 'Completed', 'TXN20260201200003');

-- Michael Chen income (user_id = 5)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(5, 14, 1, 'Income', 7800.00, 'Salary - January', '2026-01-01', 'Completed', 'TXN20260101300001'),
(5, 14, 4, 'Income', 3200.00, 'Business Revenue', '2026-01-25', 'Completed', 'TXN20260125300002'),
(5, 14, 1, 'Income', 7800.00, 'Salary - February', '2026-02-01', 'Completed', 'TXN20260201300003');

-- Emily Davis income (user_id = 6)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(6, 17, 1, 'Income', 9500.00, 'Manager Salary - January', '2026-01-01', 'Completed', 'TXN20260101400001'),
(6, 18, 3, 'Income', 2100.00, 'Investment Returns', '2026-01-15', 'Completed', 'TXN20260115400002'),
(6, 17, 1, 'Income', 9500.00, 'Manager Salary - February', '2026-02-01', 'Completed', 'TXN20260201400003');

-- David Wilson income (user_id = 7)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(7, 19, 1, 'Income', 5800.00, 'Salary - January', '2026-01-01', 'Completed', 'TXN20260101500001'),
(7, 19, 1, 'Income', 5800.00, 'Salary - February', '2026-02-01', 'Completed', 'TXN20260201500002');

-- =====================================================
-- SAMPLE TRANSACTIONS - EXPENSES
-- =====================================================
-- Admin user expenses
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
-- January 2026
(1, 1, 14, 'Expense', 2200.00, 'Monthly Rent Payment', '2026-01-01', 'Completed', 'TXN20260101000010'),
(1, 1, 13, 'Expense', 280.50, 'Electricity & Water Bills', '2026-01-05', 'Completed', 'TXN20260105000011'),
(1, 3, 7, 'Expense', 145.80, 'Grocery Shopping - Walmart', '2026-01-07', 'Completed', 'TXN20260107000012'),
(1, 1, 8, 'Expense', 85.00, 'Gasoline - Shell Station', '2026-01-08', 'Completed', 'TXN20260108000013'),
(1, 3, 7, 'Expense', 62.50, 'Dinner at Italian Restaurant', '2026-01-10', 'Completed', 'TXN20260110000014'),
(1, 1, 9, 'Expense', 120.00, 'Online Shopping - Amazon', '2026-01-12', 'Completed', 'TXN20260112000015'),
(1, 1, 10, 'Expense', 45.00, 'Movie Tickets', '2026-01-14', 'Completed', 'TXN20260114000016'),
(1, 1, 11, 'Expense', 150.00, 'Doctor Visit', '2026-01-18', 'Completed', 'TXN20260118000017'),
(1, 1, 15, 'Expense', 380.00, 'Car Insurance Premium', '2026-01-20', 'Completed', 'TXN20260120000018'),
(1, 3, 7, 'Expense', 89.20, 'Lunch at Cafe', '2026-01-25', 'Completed', 'TXN20260125000019'),
(1, 1, 8, 'Expense', 55.00, 'Uber Rides', '2026-01-28', 'Completed', 'TXN20260128000020'),
-- February 2026
(1, 1, 14, 'Expense', 2200.00, 'Monthly Rent Payment', '2026-02-01', 'Completed', 'TXN20260201000021'),
(1, 1, 13, 'Expense', 295.00, 'Utility Bills', '2026-02-05', 'Completed', 'TXN20260205000022'),
(1, 3, 7, 'Expense', 138.90, 'Grocery Shopping', '2026-02-07', 'Completed', 'TXN20260207000023'),
(1, 1, 9, 'Expense', 250.00, 'New Shoes & Clothes', '2026-02-09', 'Completed', 'TXN20260209000024'),
(1, 3, 7, 'Expense', 75.00, 'Valentine Dinner', '2026-02-14', 'Completed', 'TXN20260214000025');

-- John Smith expenses (user_id = 3)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(3, 8, 14, 'Expense', 1500.00, 'Rent', '2026-01-01', 'Completed', 'TXN20260101100010'),
(3, 8, 7, 'Expense', 320.00, 'Groceries', '2026-01-08', 'Completed', 'TXN20260108100011'),
(3, 10, 7, 'Expense', 45.00, 'Coffee & Snacks', '2026-01-12', 'Completed', 'TXN20260112100012'),
(3, 8, 8, 'Expense', 120.00, 'Gas & Transit', '2026-01-15', 'Completed', 'TXN20260115100013'),
(3, 8, 9, 'Expense', 180.00, 'Electronics Store', '2026-01-20', 'Completed', 'TXN20260120100014'),
(3, 8, 13, 'Expense', 150.00, 'Internet & Phone', '2026-01-25', 'Completed', 'TXN20260125100015'),
(3, 8, 14, 'Expense', 1500.00, 'Rent', '2026-02-01', 'Completed', 'TXN20260201100016'),
(3, 8, 7, 'Expense', 280.00, 'Groceries', '2026-02-08', 'Completed', 'TXN20260208100017');

-- Sarah Johnson expenses (user_id = 4)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(4, 11, 14, 'Expense', 1800.00, 'Apartment Rent', '2026-01-01', 'Completed', 'TXN20260101200010'),
(4, 11, 7, 'Expense', 420.00, 'Food & Dining', '2026-01-10', 'Completed', 'TXN20260110200011'),
(4, 12, 9, 'Expense', 350.00, 'Shopping Spree', '2026-01-15', 'Completed', 'TXN20260115200012'),
(4, 11, 13, 'Expense', 185.00, 'Utilities', '2026-01-20', 'Completed', 'TXN20260120200013'),
(4, 11, 10, 'Expense', 95.00, 'Concert Tickets', '2026-01-28', 'Completed', 'TXN20260128200014'),
(4, 11, 14, 'Expense', 1800.00, 'Apartment Rent', '2026-02-01', 'Completed', 'TXN20260201200015');

-- Michael Chen expenses (user_id = 5)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(5, 14, 14, 'Expense', 2100.00, 'Mortgage Payment', '2026-01-01', 'Completed', 'TXN20260101300010'),
(5, 16, 7, 'Expense', 85.00, 'Restaurant', '2026-01-12', 'Completed', 'TXN20260112300011'),
(5, 14, 8, 'Expense', 160.00, 'Car Maintenance', '2026-01-18', 'Completed', 'TXN20260118300012'),
(5, 14, 12, 'Expense', 450.00, 'Online Course', '2026-01-22', 'Completed', 'TXN20260122300013'),
(5, 14, 13, 'Expense', 320.00, 'HOA Fees', '2026-01-28', 'Completed', 'TXN20260128300014'),
(5, 14, 14, 'Expense', 2100.00, 'Mortgage Payment', '2026-02-01', 'Completed', 'TXN20260201300015');

-- Emily Davis expenses (user_id = 6)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(6, 17, 14, 'Expense', 2500.00, 'Monthly Rent', '2026-01-01', 'Completed', 'TXN20260101400010'),
(6, 17, 7, 'Expense', 580.00, 'Fine Dining & Groceries', '2026-01-15', 'Completed', 'TXN20260115400011'),
(6, 17, 9, 'Expense', 420.00, 'Designer Clothes', '2026-01-20', 'Completed', 'TXN20260120400012'),
(6, 17, 11, 'Expense', 250.00, 'Dental Checkup', '2026-01-25', 'Completed', 'TXN20260125400013'),
(6, 17, 14, 'Expense', 2500.00, 'Monthly Rent', '2026-02-01', 'Completed', 'TXN20260201400014');

-- David Wilson expenses (user_id = 7)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, reference_number) VALUES
(7, 19, 14, 'Expense', 1600.00, 'Rent', '2026-01-01', 'Completed', 'TXN20260101500010'),
(7, 19, 7, 'Expense', 380.00, 'Groceries & Dining', '2026-01-14', 'Completed', 'TXN20260114500011'),
(7, 19, 8, 'Expense', 95.00, 'Public Transit Pass', '2026-01-20', 'Completed', 'TXN20260120500012'),
(7, 19, 13, 'Expense', 165.00, 'Utility Bills', '2026-01-28', 'Completed', 'TXN20260128500013'),
(7, 19, 14, 'Expense', 1600.00, 'Rent', '2026-02-01', 'Completed', 'TXN20260201500014');

-- =====================================================
-- PENDING APPROVAL TRANSACTIONS (Large Amounts)
-- =====================================================
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date, status, approval_required, reference_number) VALUES
(3, 8, 9, 'Expense', 1500000.00, 'Property Down Payment', '2026-02-12', 'Pending', TRUE, 'TXN20260212100100'),
(4, 11, 4, 'Income', 1250000.00, 'Business Sale Proceeds', '2026-02-13', 'Pending', TRUE, 'TXN20260213200100'),
(5, 14, 3, 'Income', 2000000.00, 'Investment Maturity', '2026-02-14', 'Pending', TRUE, 'TXN20260214300100');

-- =====================================================
-- SAMPLE AUDIT LOG ENTRIES
-- =====================================================
INSERT INTO audit_log (user_id, action_type, action_description, ip_address, user_agent, table_affected, record_id) VALUES
(1, 'LOGIN', 'User logged in: admin@ftts.com', '192.168.1.100', 'Mozilla/5.0', NULL, NULL),
(3, 'LOGIN', 'User logged in: john.smith@example.com', '192.168.1.101', 'Mozilla/5.0', NULL, NULL),
(1, 'CREATE', 'New transaction created: TXN20260214000025', '192.168.1.100', 'Mozilla/5.0', 'transactions', 1),
(3, 'CREATE', 'New account created: Chase Bank Account', '192.168.1.101', 'Mozilla/5.0', 'accounts', 8),
(4, 'UPDATE', 'Profile information updated', '192.168.1.102', 'Mozilla/5.0', 'users', 4),
(1, 'LOGIN', 'User logged in: admin@ftts.com', '192.168.1.100', 'Mozilla/5.0', NULL, NULL),
(6, 'LOGIN', 'Manager logged in: emily.davis@example.com', '192.168.1.105', 'Mozilla/5.0', NULL, NULL);

-- =====================================================
-- SAMPLE NOTIFICATIONS
-- =====================================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES
(1, 'Large Transaction Detected', 'A transaction of $8,500.00 has been recorded in your Main Checking Account.', 'Info', FALSE),
(1, 'Login from New Device', 'Your account was accessed from a new device on February 14, 2026. If this was not you, please secure your account immediately.', 'Warning', FALSE),
(3, 'Transaction Pending Approval', 'Your large transaction of $1,500,000.00 is pending manager approval. You will be notified once reviewed.', 'Warning', FALSE),
(4, 'Transaction Pending Approval', 'Your income transaction of $1,250,000.00 requires approval. Please wait for manager review.', 'Warning', FALSE),
(6, 'New Pending Approvals', 'You have 3 transactions pending your approval. Please review them in the approvals section.', 'Info', FALSE),
(1, 'Salary Credited', 'Your salary of $8,500.00 has been credited to Main Checking Account.', 'Success', TRUE);

-- =====================================================
-- SAMPLE SESSIONS
-- =====================================================
INSERT INTO sessions (session_id, user_id, ip_address, user_agent, csrf_token, expires_at) VALUES
(UUID(), 1, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', UUID(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(UUID(), 3, '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', UUID(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(UUID(), 6, '192.168.1.105', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', UUID(), DATE_ADD(NOW(), INTERVAL 1 DAY));

-- =====================================================
-- VERIFY DATA INSERTION
-- =====================================================
SELECT 'Database Statistics' AS info;
SELECT 'Total Users:' AS metric, COUNT(*) AS count FROM users
UNION ALL
SELECT 'Total Accounts:', COUNT(*) FROM accounts
UNION ALL
SELECT 'Total Transactions:', COUNT(*) FROM transactions
UNION ALL
SELECT 'Total Completed Transactions:', COUNT(*) FROM transactions WHERE status = 'Completed'
UNION ALL
SELECT 'Total Pending Approvals:', COUNT(*) FROM transactions WHERE status = 'Pending'
UNION ALL
SELECT 'Total Categories:', COUNT(*) FROM categories
UNION ALL
SELECT 'Total Audit Logs:', COUNT(*) FROM audit_log
UNION ALL
SELECT 'Total Notifications:', COUNT(*) FROM notifications;

SELECT CHAR(10) AS separator;
SELECT 'Sample Users Created:' AS info;
SELECT user_id, full_name, email, role, status FROM users ORDER BY user_id;

SELECT CHAR(10) AS separator;
SELECT 'Sample Accounts Summary:' AS info;
SELECT u.full_name, COUNT(a.account_id) AS total_accounts, SUM(a.balance) AS total_balance
FROM users u
LEFT JOIN accounts a ON u.user_id = a.user_id
GROUP BY u.user_id, u.full_name
ORDER BY u.user_id;

-- =====================================================
-- END OF SAMPLE DATA
-- =====================================================
