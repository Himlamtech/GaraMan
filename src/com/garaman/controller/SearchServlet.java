package com.garaman.controller;

import com.garaman.dao.PartDAO;
import com.garaman.dao.PartDAOImpl;
import com.garaman.dao.ServiceDAO;
import com.garaman.dao.ServiceDAOImpl;
import com.garaman.model.Part;
import com.garaman.model.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller: SearchServlet
 * Handles customer search for services and parts
 */
public class SearchServlet extends HttpServlet {

    private ServiceDAO serviceDAO;
    private PartDAO partDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAOImpl();
        partDAO = new PartDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Forward to search page
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get search keyword
        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type"); // service/part/all
        
        String trimmedKeyword = keyword != null ? keyword.trim() : null;
        boolean searchServices = type == null || "all".equalsIgnoreCase(type) || "service".equalsIgnoreCase(type);
        boolean searchParts = type == null || "all".equalsIgnoreCase(type) || "part".equalsIgnoreCase(type);

        List<Service> services = new ArrayList<>();
        List<Part> parts = new ArrayList<>();

        if (searchServices) {
            services = (trimmedKeyword == null || trimmedKeyword.isEmpty())
                    ? serviceDAO.getAll()
                    : serviceDAO.search(trimmedKeyword);
        }

        if (searchParts) {
            parts = (trimmedKeyword == null || trimmedKeyword.isEmpty())
                    ? partDAO.getAll()
                    : partDAO.search(trimmedKeyword);
        }
        
        // Set attributes for JSP
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("services", services);
        request.setAttribute("parts", parts);
        request.setAttribute("hasResults", !services.isEmpty() || !parts.isEmpty());
        
        // Forward to search results page
        request.getRequestDispatcher("/search-result.jsp").forward(request, response);
    }
}
