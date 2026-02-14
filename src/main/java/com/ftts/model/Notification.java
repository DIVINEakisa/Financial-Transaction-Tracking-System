package com.ftts.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Notification Model Class
 * Represents a user notification
 */
public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int notificationId;
    private int userId;
    private String title;
    private String message;
    private String notificationType; // Info, Warning, Success, Error
    private boolean isRead;
    private String link;
    private Timestamp createdAt;
    
    // Constructors
    public Notification() {
        this.isRead = false;
        this.notificationType = "Info";
    }
    
    public Notification(int userId, String title, String message, String notificationType) {
        this();
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.notificationType = notificationType;
    }
    
    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getNotificationType() {
        return notificationType;
    }
    
    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean read) {
        isRead = read;
    }
    
    public String getLink() {
        return link;
    }
    
    public void setLink(String link) {
        this.link = link;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Notification{" +
                "notificationId=" + notificationId +
                ", title='" + title + '\'' +
                ", notificationType='" + notificationType + '\'' +
                ", isRead=" + isRead +
                '}';
    }
}
