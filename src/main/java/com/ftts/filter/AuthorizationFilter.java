package com.ftts.filter;

import com.ftts.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authorization Filter
 * Ensures user has required role to access certain resources
 */
@WebFilter(filterName = "AuthorizationFilter")
public class AuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            
            if (user != null) {
                String requestURI = httpRequest.getRequestURI();
                
                // Check if user has manager/admin role for manager pages
                if (requestURI.contains("/manager/")) {
                    if (user.isManager() || user.isAdmin()) {
                        chain.doFilter(request, response);
                        return;
                    } else {
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/error403.jsp");
                        return;
                    }
                }
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code
    }
}
