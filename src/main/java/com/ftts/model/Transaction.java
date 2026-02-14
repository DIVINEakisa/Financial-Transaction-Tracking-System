package com.ftts.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Transaction Model Class
 * Represents a financial transaction
 */
public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int transactionId;
    private int userId;
    private int accountId;
    private int categoryId;
    private String transactionType; // Income, Expense, Transfer
    private BigDecimal amount;
    private String description;
    private Date transactionDate;
    private String status; // Pending, Approved, Rejected, Completed
    private boolean approvalRequired;
    private Integer approvedBy;
    private Timestamp approvedAt;
    private String approvalNotes;
    private String referenceNumber;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display purposes (not in DB)
    private String userName;
    private String accountName;
    private String categoryName;
    private String approverName;
    
    // Constructors
    public Transaction() {
        this.status = "Completed";
        this.approvalRequired = false;
    }
    
    public Transaction(int userId, int accountId, int categoryId, String transactionType, 
                      BigDecimal amount, String description, Date transactionDate) {
        this();
        this.userId = userId;
        this.accountId = accountId;
        this.categoryId = categoryId;
        this.transactionType = transactionType;
        this.amount = amount;
        this.description = description;
        this.transactionDate = transactionDate;
    }
    
    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getAccountId() {
        return accountId;
    }
    
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getTransactionType() {
        return transactionType;
    }
    
    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getTransactionDate() {
        return transactionDate;
    }
    
    public void setTransactionDate(Date transactionDate) {
        this.transactionDate = transactionDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isApprovalRequired() {
        return approvalRequired;
    }
    
    public void setApprovalRequired(boolean approvalRequired) {
        this.approvalRequired = approvalRequired;
    }
    
    public Integer getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public Timestamp getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public String getApprovalNotes() {
        return approvalNotes;
    }
    
    public void setApprovalNotes(String approvalNotes) {
        this.approvalNotes = approvalNotes;
    }
    
    public String getReferenceNumber() {
        return referenceNumber;
    }
    
    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
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
    
    // Additional fields
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getAccountName() {
        return accountName;
    }
    
    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getApproverName() {
        return approverName;
    }
    
    public void setApproverName(String approverName) {
        this.approverName = approverName;
    }
    
    // Utility methods
    public boolean isPending() {
        return "Pending".equals(this.status);
    }
    
    public boolean isApproved() {
        return "Approved".equals(this.status);
    }
    
    public boolean isCompleted() {
        return "Completed".equals(this.status);
    }
    
    public boolean isRejected() {
        return "Rejected".equals(this.status);
    }
    
    @Override
    public String toString() {
        return "Transaction{" +
                "transactionId=" + transactionId +
                ", transactionType='" + transactionType + '\'' +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", referenceNumber='" + referenceNumber + '\'' +
                '}';
    }
}
