package com.ftts.filter;

import com.ftts.util.SecurityUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.IOException;

/**
 * XSS Protection Filter
 * Sanitizes user input to prevent Cross-Site Scripting attacks
 */
@WebFilter(filterName = "XSSFilter")
public class XSSFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        chain.doFilter(new XSSRequestWrapper((HttpServletRequest) request), response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code
    }
    
    /**
     * Request wrapper that sanitizes parameter values
     */
    private static class XSSRequestWrapper extends HttpServletRequestWrapper {
        
        public XSSRequestWrapper(HttpServletRequest request) {
            super(request);
        }
        
        @Override
        public String getParameter(String parameter) {
            String value = super.getParameter(parameter);
            return sanitize(value);
        }
        
        @Override
        public String[] getParameterValues(String parameter) {
            String[] values = super.getParameterValues(parameter);
            
            if (values == null) {
                return null;
            }
            
            String[] sanitizedValues = new String[values.length];
            for (int i = 0; i < values.length; i++) {
                sanitizedValues[i] = sanitize(values[i]);
            }
            
            return sanitizedValues;
        }
        
        private String sanitize(String value) {
            if (value == null) {
                return null;
            }
            
            return SecurityUtil.sanitizeInput(value);
        }
    }
}
