package com.ftts.dao;

import com.ftts.model.AuditLog;
import com.ftts.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AuditLog Data Access Object
 * Handles all database operations for AuditLog entity
 */
public class AuditLogDAO {
    
    /**
     * Log an action
     * @param auditLog AuditLog object
     * @return true if logging successful
     */
    public boolean logAction(AuditLog auditLog) {
        String sql = "INSERT INTO audit_log (user_id, action_type, action_description, " +
                    "ip_address, user_agent, table_affected, record_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, auditLog.getUserId());
            stmt.setString(2, auditLog.getActionType());
            stmt.setString(3, auditLog.getActionDescription());
            stmt.setString(4, auditLog.getIpAddress());
            stmt.setString(5, auditLog.getUserAgent());
            stmt.setString(6, auditLog.getTableAffected());
            stmt.setObject(7, auditLog.getRecordId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public List<AuditLog> getRecentLogs(int limit) {
        List<AuditLog> logs = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as user_name FROM audit_log a " +
                    "LEFT JOIN users u ON a.user_id = u.user_id " +
                    "ORDER BY a.created_at DESC LIMIT ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                logs.add(extractAuditLogFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return logs;
    }
    
    private AuditLog extractAuditLogFromResultSet(ResultSet rs) throws SQLException {
        AuditLog log = new AuditLog();
        log.setAuditId(rs.getInt("audit_id"));
        
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            log.setUserId(userId);
        }
        
        log.setActionType(rs.getString("action_type"));
        log.setActionDescription(rs.getString("action_description"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setUserAgent(rs.getString("user_agent"));
        log.setTableAffected(rs.getString("table_affected"));
        
        int recordId = rs.getInt("record_id");
        if (!rs.wasNull()) {
            log.setRecordId(recordId);
        }
        
        log.setCreatedAt(rs.getTimestamp("created_at"));
        
        try {
            log.setUserName(rs.getString("user_name"));
        } catch (SQLException e) {}
        
        return log;
    }
}
