package com.ftts.filter;

import com.ftts.util.SecurityUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * CSRF Protection Filter
 * Prevents Cross-Site Request Forgery attacks
 */
@WebFilter(filterName = "CSRFFilter")
public class CSRFFilter implements Filter {
    
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
        
        // Generate CSRF token if not present
        if (session != null && session.getAttribute("csrfToken") == null) {
            String csrfToken = SecurityUtil.generateCSRFToken();
            session.setAttribute("csrfToken", csrfToken);
        }
        
        // Validate CSRF token for POST requests
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            if (session != null) {
                String sessionToken = (String) session.getAttribute("csrfToken");
                String requestToken = httpRequest.getParameter("csrfToken");
                
                if (sessionToken == null || !sessionToken.equals(requestToken)) {
                    // Skip CSRF validation for login/register (first time)
                    String requestURI = httpRequest.getRequestURI();
                    if (!requestURI.contains("login") && !requestURI.contains("register")) {
                        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                                             "CSRF token validation failed");
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
