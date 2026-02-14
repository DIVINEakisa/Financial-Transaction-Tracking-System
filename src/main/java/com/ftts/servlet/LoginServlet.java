package com.ftts.servlet;

import com.ftts.dao.AuditLogDAO;
import com.ftts.dao.UserDAO;
import com.ftts.model.AuditLog;
import com.ftts.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Login Servlet
 * Handles user authentication
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private AuditLogDAO auditLogDAO = new AuditLogDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.authenticateUser(email, password);
        
        if (user != null) {
            // Check user status
            if ("Locked".equals(user.getStatus())) {
                request.setAttribute("error", 
                    "Account is locked due to suspicious activity. Contact administrator.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            if ("Suspended".equals(user.getStatus())) {
                request.setAttribute("error", "Account is suspended. Contact administrator.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userRole", user.getRole());
            session.setMaxInactiveInterval(15 * 60); // 15 minutes
            
            // Log successful login
            AuditLog log = new AuditLog();
            log.setUserId(user.getUserId());
            log.setActionType("LOGIN");
            log.setActionDescription("User logged in: " + email);
            log.setIpAddress(request.getRemoteAddr());
            log.setUserAgent(request.getHeader("User-Agent"));
            auditLogDAO.logAction(log);
            
            // Redirect based on role
            if (user.isManager() || user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        } else {
            // Log failed login attempt
            AuditLog log = new AuditLog();
            log.setActionType("LOGIN_FAILED");
            log.setActionDescription("Failed login attempt: " + email);
            log.setIpAddress(request.getRemoteAddr());
            log.setUserAgent(request.getHeader("User-Agent"));
            auditLogDAO.logAction(log);
            
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
