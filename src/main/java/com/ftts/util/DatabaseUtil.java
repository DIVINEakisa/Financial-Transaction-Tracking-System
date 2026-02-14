package com.ftts.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database Connection Utility
 * Provides database connection management
 */
public class DatabaseUtil {
    private static String DB_DRIVER;
    private static String DB_URL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;
    
    static {
        loadDatabaseProperties();
    }
    
    /**
     * Load database properties from db.properties file
     */
    private static void loadDatabaseProperties() {
        Properties props = new Properties();
        try (InputStream input = DatabaseUtil.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
                DB_DRIVER = props.getProperty("db.driver");
                DB_URL = props.getProperty("db.url");
                DB_USERNAME = props.getProperty("db.username");
                DB_PASSWORD = props.getProperty("db.password");
                
                // Load JDBC driver
                Class.forName(DB_DRIVER);
            } else {
                throw new RuntimeException("Unable to find db.properties");
            }
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Error loading database configuration", e);
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }
    
    /**
     * Close database connection
     * @param connection Connection object to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test database connection
     * @return true if connection is successful
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
