package com.garaman.controller;

import com.garaman.dao.PartDAO;
import com.garaman.dao.PartDAOImpl;
import com.garaman.model.Part;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller: PartDetailServlet
 * Shows spare part detail for customers
 */
public class PartDetailServlet extends HttpServlet {

    private PartDAO partDAO;

    @Override
    public void init() throws ServletException {
        partDAO = new PartDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Part id is required");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Part part = partDAO.getById(id);
            if (part == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Part not found");
                return;
            }

            request.setAttribute("part", part);
            request.getRequestDispatcher("/part-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid part id");
        }
    }
}
