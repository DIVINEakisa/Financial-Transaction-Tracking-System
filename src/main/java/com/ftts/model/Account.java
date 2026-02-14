package com.ftts.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Account Model Class
 * Represents a financial account
 */
public class Account implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int accountId;
    private int userId;
    private String accountName;
    private String accountType; // Bank, Cash, Mobile Money, Credit Card, Other
    private BigDecimal balance;
    private String currency;
    private String status; // Active, Inactive, Closed
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructors
    public Account() {
        this.balance = BigDecimal.ZERO;
        this.currency = "USD";
        this.status = "Active";
    }
    
    public Account(int userId, String accountName, String accountType) {
        this();
        this.userId = userId;
        this.accountName = accountName;
        this.accountType = accountType;
    }
    
    // Getters and Setters
    public int getAccountId() {
        return accountId;
    }
    
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getAccountName() {
        return accountName;
    }
    
    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }
    
    public String getAccountType() {
        return accountType;
    }
    
    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }
    
    public BigDecimal getBalance() {
        return balance;
    }
    
    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    public void setCurrency(String currency) {
        this.currency = currency;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Utility methods
    public boolean isActive() {
        return "Active".equals(this.status);
    }
    
    public boolean hasSufficientBalance(BigDecimal amount) {
        return this.balance.compareTo(amount) >= 0;
    }
    
    @Override
    public String toString() {
        return "Account{" +
                "accountId=" + accountId +
                ", accountName='" + accountName + '\'' +
                ", accountType='" + accountType + '\'' +
                ", balance=" + balance +
                ", status='" + status + '\'' +
                '}';
    }
}
