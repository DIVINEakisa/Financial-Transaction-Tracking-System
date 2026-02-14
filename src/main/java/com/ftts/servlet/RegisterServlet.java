package com.ftts.servlet;

import com.ftts.dao.AuditLogDAO;
import com.ftts.dao.UserDAO;
import com.ftts.model.AuditLog;
import com.ftts.model.User;
import com.ftts.util.SecurityUtil;
import com.ftts.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Registration Servlet
 * Handles user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private AuditLogDAO auditLogDAO = new AuditLogDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        
        // Validation
        if (!ValidationUtil.isNotEmpty(fullName) || !ValidationUtil.isNotEmpty(email) ||
            !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "All required fields must be filled");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidFullName(fullName)) {
            request.setAttribute("error", "Invalid full name format");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!SecurityUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!SecurityUtil.isStrongPassword(password)) {
            request.setAttribute("error", SecurityUtil.getPasswordStrengthMessage(password));
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (phone != null && !phone.isEmpty() && !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("error", "Invalid phone number format");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create user
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(SecurityUtil.hashPassword(password));
        user.setPhone(phone);
        user.setRole("User");
        user.setStatus("Active");
        
        if (userDAO.registerUser(user)) {
            // Log registration
            AuditLog log = new AuditLog();
            log.setUserId(user.getUserId());
            log.setActionType("REGISTER");
            log.setActionDescription("User registered: " + email);
            log.setIpAddress(request.getRemoteAddr());
            log.setUserAgent(request.getHeader("User-Agent"));
            log.setTableAffected("users");
            log.setRecordId(user.getUserId());
            auditLogDAO.logAction(log);
            
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
