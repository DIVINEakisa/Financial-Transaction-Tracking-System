package com.ftts.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Ensures user is logged in before accessing protected resources
 */
@WebFilter(filterName = "AuthenticationFilter")
public class AuthenticationFilter implements Filter {
    
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
        
        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        
        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean loginRequest = httpRequest.getRequestURI().equals(loginURI);
        
        if (loggedIn || loginRequest) {
            // User is logged in or requesting login page, proceed
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code
    }
}
