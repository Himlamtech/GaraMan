package com.garaman.servlet;

import com.garaman.service.SearchService;
import com.garaman.entity.Service;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/service-detail")
public class ServiceDetailServlet extends HttpServlet {
    
    private SearchService searchService = new SearchService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String serviceIdParam = request.getParameter("id");
        
        if (serviceIdParam != null && !serviceIdParam.isEmpty()) {
            try {
                int serviceId = Integer.parseInt(serviceIdParam);
                Service service = searchService.getServiceDetails(serviceId);
                
                if (service != null) {
                    request.setAttribute("service", service);
                    request.getRequestDispatcher("/view/service-detail.jsp").forward(request, response);
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
