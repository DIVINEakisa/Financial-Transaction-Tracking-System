package com.ftts.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Category Model Class
 * Represents a transaction category
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int categoryId;
    private String categoryName;
    private String categoryType; // Income, Expense
    private String description;
    private String icon;
    private String color;
    private Timestamp createdAt;
    
    // Constructors
    public Category() {}
    
    public Category(String categoryName, String categoryType) {
        this.categoryName = categoryName;
        this.categoryType = categoryType;
    }
    
    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getCategoryType() {
        return categoryType;
    }
    
    public void setCategoryType(String categoryType) {
        this.categoryType = categoryType;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Utility methods
    public boolean isIncome() {
        return "Income".equals(this.categoryType);
    }
    
    public boolean isExpense() {
        return "Expense".equals(this.categoryType);
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", categoryType='" + categoryType + '\'' +
                '}';
    }
}
