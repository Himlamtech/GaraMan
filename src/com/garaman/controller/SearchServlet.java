package com.garaman.controller;

import com.garaman.service.SearchService;
import com.garaman.service.SearchService.SearchResult;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: SearchServlet
 * Handles customer search for services and parts
 */
public class SearchServlet extends HttpServlet {
    
    private SearchService searchService;
    
    @Override
    public void init() throws ServletException {
        searchService = new SearchService();
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
        
        // Perform search
        SearchResult result = searchService.search(keyword, type);
        
        // Set attributes for JSP
        request.setAttribute("keyword", keyword);
        request.setAttribute("type", type);
        request.setAttribute("services", result.getServices());
        request.setAttribute("parts", result.getParts());
        request.setAttribute("hasResults", result.hasResults());
        
        // Forward to search results page
        request.getRequestDispatcher("/search-result.jsp").forward(request, response);
    }
}
