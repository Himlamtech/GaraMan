package com.garaman.servlet;

import com.garaman.service.SearchService;
import com.garaman.service.SearchService.SearchResult;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private SearchService searchService = new SearchService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        // Default type to "all" if not specified
        if (type == null || type.trim().isEmpty()) {
            type = "all";
        }

        if (keyword != null && keyword.trim().length() >= 2) {
            try {
                SearchResult result = searchService.search(keyword.trim(), type);
                request.setAttribute("searchResults", result);
                request.setAttribute("keyword", keyword);
                request.setAttribute("type", type);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred during search. Please try again.");
            }
        }

        request.getRequestDispatcher("/view/search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
