package com.ftts.dao;

import com.ftts.model.Category;
import com.ftts.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Category Data Access Object
 * Handles all database operations for Category entity
 */
public class CategoryDAO {
    
    /**
     * Get all categories
     * @return List of categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_type, category_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * Get categories by type
     * @param type Category type (Income/Expense)
     * @return List of categories
     */
    public List<Category> getCategoriesByType(String type) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE category_type = ? ORDER BY category_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * Get category by ID
     * @param categoryId Category ID
     * @return Category object
     */
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Extract Category object from ResultSet
     * @param rs ResultSet
     * @return Category object
     * @throws SQLException if error occurs
     */
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setCategoryType(rs.getString("category_type"));
        category.setDescription(rs.getString("description"));
        category.setIcon(rs.getString("icon"));
        category.setColor(rs.getString("color"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    }
}
import com.ftts.model.Category;
import com.ftts.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Category Data Access Object
 */
public class CategoryDAO {
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_type, category_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    public List<Category> getCategoriesByType(String type) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE category_type = ? ORDER BY category_name";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setCategoryType(rs.getString("category_type"));
        category.setDescription(rs.getString("description"));
        category.setIcon(rs.getString("icon"));
        category.setColor(rs.getString("color"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    }
}
