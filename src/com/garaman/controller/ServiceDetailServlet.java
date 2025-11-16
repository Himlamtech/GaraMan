package com.garaman.controller;

import com.garaman.dao.ServiceDAO;
import com.garaman.dao.ServiceDAOImpl;
import com.garaman.model.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: ServiceDetailServlet
 * Shows service detail for customers
 */
public class ServiceDetailServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Service id is required");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Service service = serviceDAO.getById(id);
            if (service == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found");
                return;
            }

            request.setAttribute("service", service);
            request.getRequestDispatcher("/service-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid service id");
        }
    }
}
