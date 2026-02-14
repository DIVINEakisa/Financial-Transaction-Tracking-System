package com.ftts.dao;

import com.ftts.model.Account;
import com.ftts.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Account Data Access Object
 * Handles all database operations for Account entity
 */
public class AccountDAO {
    
    /**
     * Create a new account
     * @param account Account object
     * @return true if creation successful
     */
    public boolean createAccount(Account account) {
        String sql = "INSERT INTO accounts (user_id, account_name, account_type, balance, currency, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, account.getUserId());
            stmt.setString(2, account.getAccountName());
            stmt.setString(3, account.getAccountType());
            stmt.setBigDecimal(4, account.getBalance());
            stmt.setString(5, account.getCurrency());
            stmt.setString(6, account.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    account.setAccountId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get account by ID
     * @param accountId Account ID
     * @return Account object
     */
    public Account getAccountById(int accountId) {
        String sql = "SELECT * FROM accounts WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractAccountFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all accounts for a user
     * @param userId User ID
     * @return List of accounts
     */
    public List<Account> getAccountsByUserId(int userId) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                accounts.add(extractAccountFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return accounts;
    }
    
    /**
     * Get active accounts for a user
     * @param userId User ID
     * @return List of active accounts
     */
    public List<Account> getActiveAccounts(int userId) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE user_id = ? AND status = 'Active' " +
                    "ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                accounts.add(extractAccountFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return accounts;
    }
    
    /**
     * Update account
     * @param account Account object
     * @return true if update successful
     */
    public boolean updateAccount(Account account) {
        String sql = "UPDATE accounts SET account_name = ?, account_type = ?, " +
                    "currency = ?, updated_at = CURRENT_TIMESTAMP WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, account.getAccountName());
            stmt.setString(2, account.getAccountType());
            stmt.setString(3, account.getCurrency());
            stmt.setInt(4, account.getAccountId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update account balance
     * @param accountId Account ID
     * @param amount Amount to add (positive) or subtract (negative)
     * @return true if update successful
     */
    public boolean updateBalance(int accountId, BigDecimal amount) {
        String sql = "UPDATE accounts SET balance = balance + ?, " +
                    "updated_at = CURRENT_TIMESTAMP WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBigDecimal(1, amount);
            stmt.setInt(2, accountId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if account has sufficient balance
     * @param accountId Account ID
     * @param amount Amount to check
     * @return true if sufficient balance
     */
    public boolean hasSufficientBalance(int accountId, BigDecimal amount) {
        String sql = "SELECT balance FROM accounts WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal balance = rs.getBigDecimal("balance");
                return balance.compareTo(amount) >= 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update account status
     * @param accountId Account ID
     * @param status New status
     * @return true if update successful
     */
    public boolean updateAccountStatus(int accountId, String status) {
        String sql = "UPDATE accounts SET status = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, accountId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete account
     * @param accountId Account ID
     * @return true if deletion successful
     */
    public boolean deleteAccount(int accountId) {
        String sql = "DELETE FROM accounts WHERE account_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get total balance for user
     * @param userId User ID
     * @return Total balance
     */
    public BigDecimal getTotalBalance(int userId) {
        String sql = "SELECT SUM(balance) as total FROM accounts " +
                    "WHERE user_id = ? AND status = 'Active'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Verify account belongs to user
     * @param accountId Account ID
     * @param userId User ID
     * @return true if account belongs to user
     */
    public boolean verifyAccountOwnership(int accountId, int userId) {
        String sql = "SELECT COUNT(*) FROM accounts WHERE account_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, accountId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Extract Account object from ResultSet
     * @param rs ResultSet
     * @return Account object
     * @throws SQLException if error occurs
     */
    private Account extractAccountFromResultSet(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountId(rs.getInt("account_id"));
        account.setUserId(rs.getInt("user_id"));
        account.setAccountName(rs.getString("account_name"));
        account.setAccountType(rs.getString("account_type"));
        account.setBalance(rs.getBigDecimal("balance"));
        account.setCurrency(rs.getString("currency"));
        account.setStatus(rs.getString("status"));
        account.setCreatedAt(rs.getTimestamp("created_at"));
        account.setUpdatedAt(rs.getTimestamp("updated_at"));
        return account;
    }
}
