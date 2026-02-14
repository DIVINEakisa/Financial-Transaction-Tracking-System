package com.ftts.dao;

import com.ftts.model.Transaction;
import com.ftts.util.ConfigUtil;
import com.ftts.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Transaction Data Access Object
 * Handles all database operations for Transaction entity
 */
public class TransactionDAO {
    
    private AccountDAO accountDAO = new AccountDAO();
    
    /**
     * Create a new transaction
     * @param transaction Transaction object
     * @return true if creation successful
     */
    public boolean createTransaction(Transaction transaction) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Check if approval is required for large transactions
            double threshold = ConfigUtil.getLargeTransactionThreshold();
            if (transaction.getAmount().doubleValue() > threshold) {
                transaction.setApprovalRequired(true);
                transaction.setStatus("Pending");
            }
            
            // For expense transactions, check balance
            if ("Expense".equals(transaction.getTransactionType())) {
                if (!accountDAO.hasSufficientBalance(transaction.getAccountId(), 
                                                     transaction.getAmount())) {
                    return false;
                }
            }
            
            // Insert transaction
            String sql = "INSERT INTO transactions (user_id, account_id, category_id, " +
                        "transaction_type, amount, description, transaction_date, status, " +
                        "approval_required) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, transaction.getUserId());
            stmt.setInt(2, transaction.getAccountId());
            stmt.setInt(3, transaction.getCategoryId());
            stmt.setString(4, transaction.getTransactionType());
            stmt.setBigDecimal(5, transaction.getAmount());
            stmt.setString(6, transaction.getDescription());
            stmt.setDate(7, transaction.getTransactionDate());
            stmt.setString(8, transaction.getStatus());
            stmt.setBoolean(9, transaction.isApprovalRequired());
            
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                transaction.setTransactionId(rs.getInt(1));
            }
            
            // Update account balance if not pending approval
            if (!transaction.isPending()) {
                updateAccountBalanceForTransaction(conn, transaction);
            }
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    /**
     * Update account balance based on transaction
     * @param conn Database connection
     * @param transaction Transaction object
     * @throws SQLException if update fails
     */
    private void updateAccountBalanceForTransaction(Connection conn, Transaction transaction) 
            throws SQLException {
        String sql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        
        BigDecimal amount = transaction.getAmount();
        if ("Expense".equals(transaction.getTransactionType())) {
            amount = amount.negate();
        }
        
        stmt.setBigDecimal(1, amount);
        stmt.setInt(2, transaction.getAccountId());
        stmt.executeUpdate();
        stmt.close();
    }
    
    /**
     * Get transaction by ID with details
     * @param transactionId Transaction ID
     * @return Transaction object with joined data
     */
    public Transaction getTransactionById(int transactionId) {
        String sql = "SELECT t.*, u.full_name as user_name, a.account_name, " +
                    "c.category_name, ap.full_name as approver_name " +
                    "FROM transactions t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN accounts a ON t.account_id = a.account_id " +
                    "JOIN categories c ON t.category_id = c.category_id " +
                    "LEFT JOIN users ap ON t.approved_by = ap.user_id " +
                    "WHERE t.transaction_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, transactionId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractTransactionFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all transactions for a user
     * @param userId User ID
     * @return List of transactions
     */
    public List<Transaction> getTransactionsByUserId(int userId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, a.account_name, c.category_name " +
                    "FROM transactions t " +
                    "JOIN accounts a ON t.account_id = a.account_id " +
                    "JOIN categories c ON t.category_id = c.category_id " +
                    "WHERE t.user_id = ? ORDER BY t.transaction_date DESC, t.created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
    
    /**
     * Get pending transactions requiring approval
     * @return List of pending transactions
     */
    public List<Transaction> getPendingTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name as user_name, a.account_name, c.category_name " +
                    "FROM transactions t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN accounts a ON t.account_id = a.account_id " +
                    "JOIN categories c ON t.category_id = c.category_id " +
                    "WHERE t.status = 'Pending' AND t.approval_required = TRUE " +
                    "ORDER BY t.created_at ASC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                transactions.add(extractTransactionFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
    
    /**
     * Approve transaction
     * @param transactionId Transaction ID
     * @param approverId Approver user ID
     * @param notes Approval notes
     * @return true if approval successful
     */
    public boolean approveTransaction(int transactionId, int approverId, String notes) {
        Connection conn = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Get transaction details
            Transaction transaction = getTransactionById(transactionId);
            if (transaction == null) {
                return false;
            }
            
            // Update transaction status
            String sql = "UPDATE transactions SET status = 'Approved', approved_by = ?, " +
                        "approved_at = CURRENT_TIMESTAMP, approval_notes = ? " +
                        "WHERE transaction_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, approverId);
            stmt.setString(2, notes);
            stmt.setInt(3, transactionId);
            stmt.executeUpdate();
            stmt.close();
            
            // Update account balance
            updateAccountBalanceForTransaction(conn, transaction);
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return false;
    }
    
    /**
     * Reject transaction
     * @param transactionId Transaction ID
     * @param approverId Approver user ID
     * @param notes Rejection notes
     * @return true if rejection successful
     */
    public boolean rejectTransaction(int transactionId, int approverId, String notes) {
        String sql = "UPDATE transactions SET status = 'Rejected', approved_by = ?, " +
                    "approved_at = CURRENT_TIMESTAMP, approval_notes = ? " +
                    "WHERE transaction_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, approverId);
            stmt.setString(2, notes);
            stmt.setInt(3, transactionId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get transaction summary for user
     * @param userId User ID
     * @param startDate Start date
     * @param endDate End date
     * @return Array with [totalIncome, totalExpense, netBalance]
     */
    public BigDecimal[] getTransactionSummary(int userId, Date startDate, Date endDate) {
        BigDecimal[] summary = new BigDecimal[3];
        summary[0] = BigDecimal.ZERO; // Total Income
        summary[1] = BigDecimal.ZERO; // Total Expense
        summary[2] = BigDecimal.ZERO; // Net Balance
        
        String sql = "SELECT " +
                    "SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) as total_income, " +
                    "SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) as total_expense " +
                    "FROM transactions " +
                    "WHERE user_id = ? AND status = 'Completed' " +
                    "AND transaction_date BETWEEN ? AND ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setDate(2, startDate);
            stmt.setDate(3, endDate);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                summary[0] = rs.getBigDecimal("total_income");
                summary[1] = rs.getBigDecimal("total_expense");
                
                if (summary[0] == null) summary[0] = BigDecimal.ZERO;
                if (summary[1] == null) summary[1] = BigDecimal.ZERO;
                
                summary[2] = summary[0].subtract(summary[1]);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return summary;
    }
    
    /**
     * Check for suspicious activity
     * @param userId User ID
     * @return true if suspicious activity detected
     */
    public boolean checkSuspiciousActivity(int userId) {
        int timeWindow = ConfigUtil.getSuspiciousActivityTimeWindow();
        int countThreshold = ConfigUtil.getSuspiciousActivityTransactionCount();
        
        String sql = "SELECT COUNT(*) FROM transactions " +
                    "WHERE user_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? SECOND)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, timeWindow);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) >= countThreshold;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Extract Transaction object from ResultSet
     * @param rs ResultSet
     * @return Transaction object
     * @throws SQLException if error occurs
     */
    private Transaction extractTransactionFromResultSet(ResultSet rs) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setTransactionId(rs.getInt("transaction_id"));
        transaction.setUserId(rs.getInt("user_id"));
        transaction.setAccountId(rs.getInt("account_id"));
        transaction.setCategoryId(rs.getInt("category_id"));
        transaction.setTransactionType(rs.getString("transaction_type"));
        transaction.setAmount(rs.getBigDecimal("amount"));
        transaction.setDescription(rs.getString("description"));
        transaction.setTransactionDate(rs.getDate("transaction_date"));
        transaction.setStatus(rs.getString("status"));
        transaction.setApprovalRequired(rs.getBoolean("approval_required"));
        
        int approvedBy = rs.getInt("approved_by");
        if (!rs.wasNull()) {
            transaction.setApprovedBy(approvedBy);
        }
        
        transaction.setApprovedAt(rs.getTimestamp("approved_at"));
        transaction.setApprovalNotes(rs.getString("approval_notes"));
        transaction.setReferenceNumber(rs.getString("reference_number"));
        transaction.setCreatedAt(rs.getTimestamp("created_at"));
        transaction.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional fields
        try {
            transaction.setUserName(rs.getString("user_name"));
        } catch (SQLException e) {}
        
        try {
            transaction.setAccountName(rs.getString("account_name"));
        } catch (SQLException e) {}
        
        try {
            transaction.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {}
        
        try {
            transaction.setApproverName(rs.getString("approver_name"));
        } catch (SQLException e) {}
        
        return transaction;
    }
}
