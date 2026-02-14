package com.ftts.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Configuration Utility
 * Loads and provides access to application configuration
 */
public class ConfigUtil {
    
    private static Properties properties;
    
    static {
        loadProperties();
    }
    
    /**
     * Load properties from db.properties file
     */
    private static void loadProperties() {
        properties = new Properties();
        try (InputStream input = ConfigUtil.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get property value
     * @param key Property key
     * @return Property value
     */
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    /**
     * Get property value with default
     * @param key Property key
     * @param defaultValue Default value if key not found
     * @return Property value or default
     */
    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }
    
    /**
     * Get integer property
     * @param key Property key
     * @param defaultValue Default value if key not found or invalid
     * @return Integer value
     */
    public static int getIntProperty(String key, int defaultValue) {
        String value = properties.getProperty(key);
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Get boolean property
     * @param key Property key
     * @param defaultValue Default value if key not found
     * @return Boolean value
     */
    public static boolean getBooleanProperty(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        if (value == null) {
            return defaultValue;
        }
        return Boolean.parseBoolean(value);
    }
    
    /**
     * Get large transaction threshold
     * @return Threshold amount
     */
    public static double getLargeTransactionThreshold() {
        return getIntProperty("app.large.transaction.threshold", 1000000);
    }
    
    /**
     * Get suspicious activity time window (in seconds)
     * @return Time window
     */
    public static int getSuspiciousActivityTimeWindow() {
        return getIntProperty("app.suspicious.activity.time.window", 60);
    }
    
    /**
     * Get suspicious activity transaction count
     * @return Transaction count threshold
     */
    public static int getSuspiciousActivityTransactionCount() {
        return getIntProperty("app.suspicious.activity.transaction.count", 3);
    }
    
    /**
     * Check if email is enabled
     * @return true if enabled
     */
    public static boolean isEmailEnabled() {
        return getBooleanProperty("email.enabled", false);
    }
}
