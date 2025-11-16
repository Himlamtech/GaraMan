package com.garaman.dao;

import com.garaman.model.User;

/**
 * User Data Access Object Interface
 */
public interface UserDAO {
    
    /**
     * Authenticate user with username and stored password hash/plaintext
     * @param username User's username
     * @param passwordHash Stored password hash/plaintext to compare
     * @return User object if authentication successful, null otherwise
     */
    User authenticate(String username, String passwordHash);
    
    /**
     * Get user by username
     * @param username User's username
     * @return User object if found, null otherwise
     */
    User getUserByUsername(String username);
}
