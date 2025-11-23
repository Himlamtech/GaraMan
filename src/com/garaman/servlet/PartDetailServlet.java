package com.garaman.servlet;

import com.garaman.service.SearchService;
import com.garaman.entity.SparePart;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/part-detail")
public class PartDetailServlet extends HttpServlet {
    
    private SearchService searchService = new SearchService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String partIdParam = request.getParameter("id");
        
        if (partIdParam != null && !partIdParam.isEmpty()) {
            try {
                int partId = Integer.parseInt(partIdParam);
                SparePart part = searchService.getPartDetails(partId);
                
                if (part != null) {
                    request.setAttribute("part", part);
                    request.getRequestDispatcher("/view/part-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/search");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/search");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/search");
        }
    }
}
