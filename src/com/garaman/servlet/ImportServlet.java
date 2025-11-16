package com.garaman.servlet;

import com.garaman.service.ImportService;
import com.garaman.service.ImportService.ImportItem;
import com.garaman.service.ImportService.ImportResult;
import com.garaman.entity.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/import")
public class ImportServlet extends HttpServlet {

    private ImportService importService = new ImportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Supplier> suppliers = importService.getAllSuppliers();
        List<SparePart> parts = importService.getAllParts();
        List<Discount> discounts = importService.getAvailableDiscounts();

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("parts", parts);
        request.setAttribute("discounts", discounts);

        request.getRequestDispatcher("/view/import-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("createSupplier".equals(action)) {
            handleCreateSupplier(request, response);
        } else if ("createPart".equals(action)) {
            handleCreatePart(request, response);
        } else if ("processImport".equals(action)) {
            handleProcessImport(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void handleCreateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String supplierName = request.getParameter("supplierName");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        // Validate that required field is not empty
        if (supplierName == null || supplierName.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Supplier name is required\"}");
            return;
        }

        int newSupplierId = importService.createSupplier(supplierName, address, phone, email);

        if (newSupplierId > 0) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"supplierId\": " + newSupplierId + "}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Failed to create supplier\"}");
        }
    }

    private void handleCreatePart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String partName = request.getParameter("partName");
        String description = request.getParameter("description");
        String unitPrice = request.getParameter("unitPrice");

        // Validate required fields
        if (partName == null || partName.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Part name is required\"}");
            return;
        }

        if (unitPrice == null || unitPrice.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Unit price is required\"}");
            return;
        }

        try {
            double price = Double.parseDouble(unitPrice);
            int newPartId = importService.createPart(partName, description, price);

            if (newPartId > 0) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"partId\": " + newPartId + "}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to create part\"}");
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid price format\"}");
        }
    }

    private void handleProcessImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));

            // Get discount ID if provided
            int discountId = 0;
            String discountIdParam = request.getParameter("discountId");
            if (discountIdParam != null && !discountIdParam.trim().isEmpty()) {
                try {
                    discountId = Integer.parseInt(discountIdParam);
                } catch (NumberFormatException e) {
                    discountId = 0;
                }
            }

            List<ImportItem> items = new ArrayList<>();
            String[] partIds = request.getParameterValues("partId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] prices = request.getParameterValues("price[]");

            if (partIds != null) {
                for (int i = 0; i < partIds.length; i++) {
                    if (!partIds[i].isEmpty() && !quantities[i].isEmpty() && !prices[i].isEmpty()) {
                        int partId = Integer.parseInt(partIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);
                        double price = Double.parseDouble(prices[i]);

                        items.add(new ImportItem(partId, quantity, price));
                    }
                }
            }

            ImportResult result = importService.processImport(supplierId, items, discountId);

            request.setAttribute("importResult", result);

            if (result.success && result.invoiceId > 0) {
                List<ImportInvoiceDetail> details = importService.getInvoiceDetails(result.invoiceId);
                request.setAttribute("invoiceDetails", details);
            }

            request.getRequestDispatcher("/view/import-result.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input data");
            doGet(request, response);
        }
    }
}
