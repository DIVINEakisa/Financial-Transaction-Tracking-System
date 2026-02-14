package com.ftts.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * AuditLog Model Class
 * Represents an audit log entry
 */
public class AuditLog implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int auditId;
    private Integer userId;
    private String actionType;
    private String actionDescription;
    private String ipAddress;
    private String userAgent;
    private String tableAffected;
    private Integer recordId;
    private String oldValue;
    private String newValue;
    private Timestamp createdAt;
    
    // Additional field for display
    private String userName;
    
    // Constructors
    public AuditLog() {}
    
    public AuditLog(Integer userId, String actionType, String actionDescription) {
        this.userId = userId;
        this.actionType = actionType;
        this.actionDescription = actionDescription;
    }
    
    // Getters and Setters
    public int getAuditId() {
        return auditId;
    }
    
    public void setAuditId(int auditId) {
        this.auditId = auditId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getActionType() {
        return actionType;
    }
    
    public void setActionType(String actionType) {
        this.actionType = actionType;
    }
    
    public String getActionDescription() {
        return actionDescription;
    }
    
    public void setActionDescription(String actionDescription) {
        this.actionDescription = actionDescription;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public String getTableAffected() {
        return tableAffected;
    }
    
    public void setTableAffected(String tableAffected) {
        this.tableAffected = tableAffected;
    }
    
    public Integer getRecordId() {
        return recordId;
    }
    
    public void setRecordId(Integer recordId) {
        this.recordId = recordId;
    }
    
    public String getOldValue() {
        return oldValue;
    }
    
    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }
    
    public String getNewValue() {
        return newValue;
    }
    
    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    @Override
    public String toString() {
        return "AuditLog{" +
                "auditId=" + auditId +
                ", actionType='" + actionType + '\'' +
                ", actionDescription='" + actionDescription + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
