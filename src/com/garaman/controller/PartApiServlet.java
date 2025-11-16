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
 * Lightweight API for creating spare parts from the import screen.
 * Returns JSON responses only.
 */
public class PartApiServlet extends HttpServlet {

    private PartDAO partDAO;

    @Override
    public void init() throws ServletException {
        partDAO = new PartDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String code = trim(request.getParameter("code"));
        String name = trim(request.getParameter("name"));
        String unit = trim(request.getParameter("unit"));
        String description = trim(request.getParameter("description"));

        if (isEmpty(code) || isEmpty(name) || isEmpty(unit)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Code, name and unit are required.\"}");
            return;
        }

        Part existing = partDAO.getByCode(code);
        if (existing == null) {
            existing = partDAO.getByName(name);
        }

        if (existing != null) {
            response.getWriter().write(String.format(
                    "{\"success\":true,\"message\":\"Part already existed, reusing it.\",\"code\":\"%s\",\"name\":\"%s\",\"unit\":\"%s\"}",
                    escapeJson(existing.getCode()), escapeJson(existing.getName()), escapeJson(existing.getUnit())));
            return;
        }

        Part part = new Part();
        part.setCode(code);
        part.setName(name);
        part.setDescription(description);
        part.setUnit(unit);
        part.setUnitPrice(0); // initial price
        part.setStockQty(0);
        part.setMinStockQty(0);
        part.setActive(true);

        int id = partDAO.insert(part);
        part.setPartId(id);

        response.getWriter().write(String.format(
                "{\"success\":true,\"message\":\"Part created successfully.\",\"code\":\"%s\",\"name\":\"%s\",\"unit\":\"%s\"}",
                escapeJson(part.getCode()), escapeJson(part.getName()), escapeJson(part.getUnit())));
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private String escapeJson(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
