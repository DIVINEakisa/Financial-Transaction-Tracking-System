-- =====================================================
-- FINANCIAL TRANSACTION TRACKING SYSTEM - DATABASE SCHEMA
-- =====================================================

-- Drop database if exists and create new
DROP DATABASE IF EXISTS ftts_db;
CREATE DATABASE ftts_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ftts_db;

-- =====================================================
-- TABLE: users
-- Purpose: Store user information with secure authentication
-- =====================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('User', 'Manager', 'Admin') DEFAULT 'User',
    status ENUM('Active', 'Suspended', 'Locked') DEFAULT 'Active',
    failed_login_attempts INT DEFAULT 0,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: accounts
-- Purpose: Store financial accounts (Bank, Cash, Mobile Money)
-- =====================================================
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type ENUM('Bank', 'Cash', 'Mobile Money', 'Credit Card', 'Other') NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'USD',
    status ENUM('Active', 'Inactive', 'Closed') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    CONSTRAINT chk_balance CHECK (balance >= 0)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: categories
-- Purpose: Transaction categories (Income/Expense)
-- =====================================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    category_type ENUM('Income', 'Expense') NOT NULL,
    description VARCHAR(255),
    icon VARCHAR(50),
    color VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: transactions
-- Purpose: Store all financial transactions
-- =====================================================
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    category_id INT NOT NULL,
    transaction_type ENUM('Income', 'Expense', 'Transfer') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Completed',
    approval_required BOOLEAN DEFAULT FALSE,
    approved_by INT,
    approved_at DATETIME,
    approval_notes TEXT,
    reference_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_account_id (account_id),
    INDEX idx_status (status),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_reference_number (reference_number),
    CONSTRAINT chk_amount CHECK (amount > 0)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: transfers
-- Purpose: Store transfer details between accounts
-- =====================================================
CREATE TABLE transfers (
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NOT NULL,
    from_account_id INT NOT NULL,
    to_account_id INT NOT NULL,
    transfer_fee DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE,
    FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(account_id),
    INDEX idx_transaction_id (transaction_id)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: audit_log
-- Purpose: Track all actions for security and compliance
-- =====================================================
CREATE TABLE audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action_type VARCHAR(50) NOT NULL,
    action_description TEXT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    table_affected VARCHAR(50),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: suspicious_activities
-- Purpose: Flag suspicious account activities
-- =====================================================
CREATE TABLE suspicious_activities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    account_id INT,
    activity_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    severity ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Medium',
    status ENUM('New', 'Under Review', 'Resolved', 'False Positive') DEFAULT 'New',
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INT,
    reviewed_at DATETIME,
    resolution_notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE SET NULL,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_severity (severity)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: notifications
-- Purpose: User notifications
-- =====================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('Info', 'Warning', 'Success', 'Error') DEFAULT 'Info',
    is_read BOOLEAN DEFAULT FALSE,
    link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read)
) ENGINE=InnoDB;

-- =====================================================
-- TABLE: sessions
-- Purpose: Track active sessions
-- =====================================================
CREATE TABLE sessions (
    session_id VARCHAR(100) PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    csrf_token VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB;

-- =====================================================
-- INSERT DEFAULT CATEGORIES
-- =====================================================
INSERT INTO categories (category_name, category_type, description, icon, color) VALUES
-- Income Categories
('Salary', 'Income', 'Monthly salary', 'fas fa-money-bill-wave', '#2ECC71'),
('Freelance', 'Income', 'Freelance work income', 'fas fa-laptop-code', '#3498DB'),
('Investment', 'Income', 'Investment returns', 'fas fa-chart-line', '#9B59B6'),
('Business', 'Income', 'Business revenue', 'fas fa-briefcase', '#1ABC9C'),
('Gift', 'Income', 'Received gifts', 'fas fa-gift', '#E91E63'),
('Other Income', 'Income', 'Other sources of income', 'fas fa-plus-circle', '#95A5A6'),

-- Expense Categories
('Food & Dining', 'Expense', 'Food and restaurant expenses', 'fas fa-utensils', '#E74C3C'),
('Transportation', 'Expense', 'Transport and fuel costs', 'fas fa-car', '#E67E22'),
('Shopping', 'Expense', 'Shopping and retail', 'fas fa-shopping-cart', '#F39C12'),
('Entertainment', 'Expense', 'Entertainment and leisure', 'fas fa-film', '#8E44AD'),
('Healthcare', 'Expense', 'Medical and health expenses', 'fas fa-heartbeat', '#C0392B'),
('Education', 'Expense', 'Education and learning', 'fas fa-graduation-cap', '#2980B9'),
('Bills & Utilities', 'Expense', 'Bills and utility payments', 'fas fa-file-invoice-dollar', '#16A085'),
('Rent', 'Expense', 'Rent payments', 'fas fa-home', '#D35400'),
('Insurance', 'Expense', 'Insurance premiums', 'fas fa-shield-alt', '#7F8C8D'),
('Other Expense', 'Expense', 'Other expenses', 'fas fa-minus-circle', '#95A5A6');

-- =====================================================
-- INSERT DEFAULT ADMIN USER
-- Password: Admin@123 (hashed with BCrypt)
-- =====================================================
INSERT INTO users (full_name, email, password_hash, role, status) VALUES
('System Administrator', 'admin@ftts.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', 'Admin', 'Active'),
('Manager User', 'manager@ftts.com', '$2a$10$8K1p/a0dL3.KzBVzVqsXXu7LMN/1V2E9P3VG4J8M4/aF2kSQHO2Y.', 'Manager', 'Active');

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to update account balance
DELIMITER //
CREATE PROCEDURE update_account_balance(
    IN p_account_id INT,
    IN p_amount DECIMAL(15, 2),
    IN p_operation VARCHAR(10)
)
BEGIN
    IF p_operation = 'ADD' THEN
        UPDATE accounts SET balance = balance + p_amount WHERE account_id = p_account_id;
    ELSEIF p_operation = 'SUBTRACT' THEN
        UPDATE accounts SET balance = balance - p_amount WHERE account_id = p_account_id;
    END IF;
END //
DELIMITER ;

-- Procedure to check suspicious activity
DELIMITER //
CREATE PROCEDURE check_suspicious_activity(
    IN p_user_id INT,
    IN p_time_window INT,
    IN p_transaction_count INT
)
BEGIN
    DECLARE transaction_count INT;
    
    SELECT COUNT(*) INTO transaction_count
    FROM transactions
    WHERE user_id = p_user_id
    AND created_at >= DATE_SUB(NOW(), INTERVAL p_time_window SECOND);
    
    IF transaction_count >= p_transaction_count THEN
        INSERT INTO suspicious_activities (user_id, activity_type, description, severity)
        VALUES (p_user_id, 'Rapid Transactions', 
                CONCAT('User performed ', transaction_count, ' transactions within ', p_time_window, ' seconds'),
                'High');
                
        UPDATE users SET status = 'Locked' WHERE user_id = p_user_id;
    END IF;
END //
DELIMITER ;

-- =====================================================
-- VIEWS FOR REPORTING
-- =====================================================

-- View: Monthly transaction summary
CREATE VIEW v_monthly_summary AS
SELECT 
    u.user_id,
    u.full_name,
    DATE_FORMAT(t.transaction_date, '%Y-%m') AS month,
    SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN t.transaction_type = 'Expense' THEN t.amount ELSE 0 END) AS total_expense,
    SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END) - 
    SUM(CASE WHEN t.transaction_type = 'Expense' THEN t.amount ELSE 0 END) AS net_balance
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id AND t.status = 'Completed'
GROUP BY u.user_id, u.full_name, DATE_FORMAT(t.transaction_date, '%Y-%m');

-- View: Account summary
CREATE VIEW v_account_summary AS
SELECT 
    a.account_id,
    a.user_id,
    a.account_name,
    a.account_type,
    a.balance,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN t.transaction_type = 'Expense' THEN t.amount ELSE 0 END) AS total_expense
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id AND t.status = 'Completed'
GROUP BY a.account_id, a.user_id, a.account_name, a.account_type, a.balance;

-- View: Pending approvals
CREATE VIEW v_pending_approvals AS
SELECT 
    t.transaction_id,
    t.user_id,
    u.full_name,
    u.email,
    t.transaction_type,
    t.amount,
    c.category_name,
    t.description,
    t.transaction_date,
    a.account_name,
    t.created_at,
    DATEDIFF(NOW(), t.created_at) AS days_pending
FROM transactions t
JOIN users u ON t.user_id = u.user_id
JOIN accounts a ON t.account_id = a.account_id
JOIN categories c ON t.category_id = c.category_id
WHERE t.status = 'Pending' AND t.approval_required = TRUE
ORDER BY t.created_at DESC;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger: Generate reference number before insert
DELIMITER //
CREATE TRIGGER before_transaction_insert
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.reference_number IS NULL THEN
        SET NEW.reference_number = CONCAT('TXN', YEAR(NOW()), LPAD(MONTH(NOW()), 2, '0'), 
                                          LPAD(DAY(NOW()), 2, '0'), 
                                          LPAD(FLOOR(RAND() * 1000000), 6, '0'));
    END IF;
END //
DELIMITER ;

-- Trigger: Audit log for user changes
DELIMITER //
CREATE TRIGGER after_user_update
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (user_id, action_type, action_description, table_affected, record_id)
    VALUES (NEW.user_id, 'UPDATE', 
            CONCAT('User ', NEW.email, ' information updated'),
            'users', NEW.user_id);
END //
DELIMITER ;

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================
CREATE INDEX idx_transaction_user_date ON transactions(user_id, transaction_date);
CREATE INDEX idx_transaction_status_type ON transactions(status, transaction_type);
CREATE INDEX idx_audit_user_date ON audit_log(user_id, created_at);

-- =====================================================
-- GRANT PERMISSIONS (Adjust as needed)
-- =====================================================
-- GRANT ALL PRIVILEGES ON ftts_db.* TO 'ftts_user'@'localhost' IDENTIFIED BY 'secure_password';
-- FLUSH PRIVILEGES;

-- =====================================================
-- END OF SCHEMA
-- =====================================================
