package com.garaman.service;

import com.garaman.dao.UserDAO;
import com.garaman.dao.UserDAOImpl;
import com.garaman.model.User;

/**
 * Authentication Service
 * Handles user authentication logic
 */
public class AuthService {
    
    private UserDAO userDAO;
    
    public AuthService() {
        this.userDAO = new UserDAOImpl();
    }
    
    /**
     * Authenticate user
     * @param username User's username
     * @param password User's password
     * @return User object if successful, null otherwise
     */
    public User login(String username, String password) {
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            return null;
        }
        
        // Authenticate
        return userDAO.authenticate(username.trim(), password);
    }
    
    /**
     * Check if user has specific role
     * @param user User to check
     * @param role Role to verify
     * @return true if user has the role
     */
    public boolean hasRole(User user, String role) {
        return user != null && role.equals(user.getRole());
    }
}
