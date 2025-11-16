package com.garaman.controller;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter
 * Protects pages that require authentication
 */
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Get current URI
        String uri = httpRequest.getRequestURI();
        
        // Allow access to login page and static resources
        if (uri.endsWith("/login") || uri.endsWith("/login.jsp") || 
            uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        HttpSession session = httpRequest.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        
        if (!loggedIn) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Role-based check for import operations
        String role = (String) session.getAttribute("role");
        boolean canImport = role != null && (
                "WAREHOUSE".equalsIgnoreCase(role) ||
                "WAREHOUSE_STAFF".equalsIgnoreCase(role) ||
                "MANAGER".equalsIgnoreCase(role)
        );

        if (uri.contains("/import") && !canImport) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
