package com.ftts.servlet;

import com.ftts.dao.AuditLogDAO;
import com.ftts.model.AuditLog;
import com.ftts.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Logout Servlet
 * Handles user logout
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    private AuditLogDAO auditLogDAO = new AuditLogDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            
            if (user != null) {
                // Log logout
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("LOGOUT");
                log.setActionDescription("User logged out: " + user.getEmail());
                log.setIpAddress(request.getRemoteAddr());
                log.setUserAgent(request.getHeader("User-Agent"));
                auditLogDAO.logAction(log);
            }
            
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
