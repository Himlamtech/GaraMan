package com.garaman.controller;

import com.garaman.dao.UserDAO;
import com.garaman.dao.UserDAOImpl;
import com.garaman.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Login Servlet
 * Handles user authentication
 */
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("search");
            return;
        }
        
        // Show login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean missingCredentials = username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty();
        if (missingCredentials) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(username.trim(), password);

        if (user != null) {
            // Login successful - create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getUserId());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Redirect to search page
            response.sendRedirect("search");
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
