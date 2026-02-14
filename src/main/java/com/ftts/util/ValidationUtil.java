package com.ftts.util;

import java.math.BigDecimal;
import java.util.regex.Pattern;

/**
 * Validation Utility Class
 * Provides input validation methods
 */
public class ValidationUtil {
    
    /**
     * Validate if string is not null and not empty
     * @param value String to validate
     * @return true if valid
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }
    
    /**
     * Validate if string matches pattern
     * @param value String to validate
     * @param pattern Regex pattern
     * @return true if matches
     */
    public static boolean matchesPattern(String value, String pattern) {
        if (value == null) {
            return false;
        }
        return Pattern.matches(pattern, value);
    }
    
    /**
     * Validate phone number
     * @param phone Phone number
     * @return true if valid
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true; // Phone is optional
        }
        
        // Accept various phone formats
        String phoneRegex = "^[+]?[(]?[0-9]{1,4}[)]?[-\\s.]?[(]?[0-9]{1,4}[)]?[-\\s.]?[0-9]{1,9}$";
        return phone.matches(phoneRegex);
    }
    
    /**
     * Validate amount is positive
     * @param amount Amount to validate
     * @return true if valid
     */
    public static boolean isValidAmount(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }
    
    /**
     * Validate amount is within range
     * @param amount Amount to validate
     * @param min Minimum value
     * @param max Maximum value
     * @return true if within range
     */
    public static boolean isAmountInRange(BigDecimal amount, BigDecimal min, BigDecimal max) {
        if (amount == null) {
            return false;
        }
        
        boolean aboveMin = min == null || amount.compareTo(min) >= 0;
        boolean belowMax = max == null || amount.compareTo(max) <= 0;
        
        return aboveMin && belowMax;
    }
    
    /**
     * Validate string length
     * @param value String to validate
     * @param minLength Minimum length
     * @param maxLength Maximum length
     * @return true if within length range
     */
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) {
            return false;
        }
        
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Validate account name
     * @param accountName Account name
     * @return true if valid
     */
    public static boolean isValidAccountName(String accountName) {
        return isNotEmpty(accountName) && isValidLength(accountName, 3, 100);
    }
    
    /**
     * Validate category name
     * @param categoryName Category name
     * @return true if valid
     */
    public static boolean isValidCategoryName(String categoryName) {
        return isNotEmpty(categoryName) && isValidLength(categoryName, 2, 50);
    }
    
    /**
     * Validate full name
     * @param fullName Full name
     * @return true if valid
     */
    public static boolean isValidFullName(String fullName) {
        if (!isNotEmpty(fullName) || !isValidLength(fullName, 2, 100)) {
            return false;
        }
        
        // Only letters, spaces, hyphens, and apostrophes
        String nameRegex = "^[a-zA-Z\\s'-]+$";
        return fullName.matches(nameRegex);
    }
    
    /**
     * Validate integer is positive
     * @param value Integer to validate
     * @return true if positive
     */
    public static boolean isPositiveInteger(Integer value) {
        return value != null && value > 0;
    }
    
    /**
     * Validate enum value
     * @param value Value to validate
     * @param allowedValues Array of allowed values
     * @return true if value is in allowed values
     */
    public static boolean isValidEnum(String value, String[] allowedValues) {
        if (value == null) {
            return false;
        }
        
        for (String allowed : allowedValues) {
            if (allowed.equals(value)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Validate transaction type
     * @param type Transaction type
     * @return true if valid
     */
    public static boolean isValidTransactionType(String type) {
        String[] validTypes = {"Income", "Expense", "Transfer"};
        return isValidEnum(type, validTypes);
    }
    
    /**
     * Validate account type
     * @param type Account type
     * @return true if valid
     */
    public static boolean isValidAccountType(String type) {
        String[] validTypes = {"Bank", "Cash", "Mobile Money", "Credit Card", "Other"};
        return isValidEnum(type, validTypes);
    }
    
    /**
     * Validate user role
     * @param role User role
     * @return true if valid
     */
    public static boolean isValidRole(String role) {
        String[] validRoles = {"User", "Manager", "Admin"};
        return isValidEnum(role, validRoles);
    }
    
    /**
     * Get validation error message
     * @param fieldName Field name
     * @param errorType Error type
     * @return Error message
     */
    public static String getErrorMessage(String fieldName, String errorType) {
        switch (errorType) {
            case "required":
                return fieldName + " is required";
            case "invalid":
                return fieldName + " is invalid";
            case "too_short":
                return fieldName + " is too short";
            case "too_long":
                return fieldName + " is too long";
            case "invalid_format":
                return fieldName + " has invalid format";
            case "not_positive":
                return fieldName + " must be positive";
            default:
                return fieldName + " validation failed";
        }
    }
}
