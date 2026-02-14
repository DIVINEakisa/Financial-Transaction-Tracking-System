package com.ftts.util;

import org.mindrot.jbcrypt.BCrypt;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Security Utility Class
 * Provides password hashing, CSRF token generation, and input sanitization
 */
public class SecurityUtil {
    
    private static final int BCRYPT_ROUNDS = 10;
    private static final SecureRandom secureRandom = new SecureRandom();
    
    /**
     * Hash password using BCrypt
     * @param plainPassword Plain text password
     * @return Hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }
    
    /**
     * Verify password against hash
     * @param plainPassword Plain text password
     * @param hashedPassword Hashed password
     * @return true if password matches
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Generate CSRF token
     * @return Random CSRF token
     */
    public static String generateCSRFToken() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return Base64.getEncoder().encodeToString(randomBytes);
    }
    
    /**
     * Generate session ID
     * @return Random session ID
     */
    public static String generateSessionId() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
    
    /**
     * Sanitize input to prevent XSS attacks
     * @param input User input
     * @return Sanitized input
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        
        return input
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;")
            .replace("/", "&#x2F;");
    }
    
    /**
     * Sanitize SQL input (additional safety measure)
     * @param input User input
     * @return Sanitized input
     */
    public static String sanitizeSQLInput(String input) {
        if (input == null) {
            return null;
        }
        
        // Remove common SQL injection patterns
        return input
            .replaceAll("(?i)(--|;|/\\*|\\*/|xp_|sp_|exec|execute|select|insert|update|delete|drop|create|alter|union|script)", "")
            .trim();
    }
    
    /**
     * Validate email format
     * @param email Email address
     * @return true if valid
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }
    
    /**
     * Validate password strength
     * Requirements:
     * - At least 8 characters
     * - At least one uppercase letter
     * - At least one lowercase letter
     * - At least one digit
     * - At least one special character
     * 
     * @param password Password to validate
     * @return true if password meets requirements
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUpper = true;
            else if (Character.isLowerCase(c)) hasLower = true;
            else if (Character.isDigit(c)) hasDigit = true;
            else if (!Character.isWhitespace(c)) hasSpecial = true;
        }
        
        return hasUpper && hasLower && hasDigit && hasSpecial;
    }
    
    /**
     * Get password strength message
     * @param password Password to check
     * @return Strength message
     */
    public static String getPasswordStrengthMessage(String password) {
        if (password == null || password.length() < 8) {
            return "Password must be at least 8 characters long";
        }
        
        StringBuilder message = new StringBuilder("Password must contain: ");
        boolean needsComma = false;
        
        if (!password.matches(".*[A-Z].*")) {
            message.append("uppercase letter");
            needsComma = true;
        }
        
        if (!password.matches(".*[a-z].*")) {
            if (needsComma) message.append(", ");
            message.append("lowercase letter");
            needsComma = true;
        }
        
        if (!password.matches(".*\\d.*")) {
            if (needsComma) message.append(", ");
            message.append("digit");
            needsComma = true;
        }
        
        if (!password.matches(".*[^a-zA-Z0-9\\s].*")) {
            if (needsComma) message.append(", ");
            message.append("special character");
        }
        
        return needsComma ? message.toString() : "";
    }
    
    /**
     * Mask sensitive data for logging
     * @param data Sensitive data
     * @return Masked data
     */
    public static String maskSensitiveData(String data) {
        if (data == null || data.length() <= 4) {
            return "****";
        }
        
        return data.substring(0, 2) + "****" + data.substring(data.length() - 2);
    }
}
