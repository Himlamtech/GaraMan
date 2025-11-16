package com.garaman.controller;

import com.garaman.service.ImportService;
import com.garaman.service.ImportService.ImportRequest;
import com.garaman.service.ImportService.ImportItemRequest;
import com.garaman.model.ImportOrder;
import com.garaman.model.ImportOrderItem;
import com.garaman.model.Part;
import com.garaman.model.Supplier;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller: ImportServlet
 * Handles warehouse staff import operations
 */
public class ImportServlet extends HttpServlet {

    private ImportService importService;

    @Override
    public void init() throws ServletException {
        importService = new ImportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Prepare suppliers and parts for selection
        List<Supplier> suppliers = importService.getAllSuppliers();
        List<Part> parts = importService.getAllParts();
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("parts", parts);

        // Forward to import form page
        request.getRequestDispatcher("/import-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Build import request
            ImportRequest importRequest = new ImportRequest();

            // Supplier information - with validation
            String supplierName = request.getParameter("supplierName");
            String supplierNameNew = request.getParameter("supplierNameNew");

            boolean addingNewSupplier = "__NEW__".equals(supplierName);
            String supplierNameToUse = addingNewSupplier ? supplierNameNew : supplierName;

            if (supplierNameToUse == null || supplierNameToUse.trim().isEmpty()) {
                request.setAttribute("success", false);
                request.setAttribute("errorMessage", "Supplier name is required");
                request.getRequestDispatcher("/import-result.jsp").forward(request, response);
                return;
            }

            importRequest.setSupplierName(supplierNameToUse.trim());
            importRequest.setSupplierContactName(request.getParameter("supplierContactName"));
            importRequest.setSupplierPhone(request.getParameter("supplierPhone"));
            importRequest.setSupplierEmail(request.getParameter("supplierEmail"));
            importRequest.setSupplierAddress(request.getParameter("supplierAddress"));
            importRequest.setSupplierTaxCode(request.getParameter("supplierTaxCode"));
            importRequest.setNote(request.getParameter("note"));

            Object staffIdObj = request.getSession().getAttribute("userId");
            if (staffIdObj instanceof Integer) {
                importRequest.setWarehouseStaffId((Integer) staffIdObj);
            } else {
                request.setAttribute("success", false);
                request.setAttribute("errorMessage", "Invalid warehouse staff session");
                request.getRequestDispatcher("/import-result.jsp").forward(request, response);
                return;
            }

            // Get number of items
            String itemCountStr = request.getParameter("itemCount");
            int itemCount;
            try {
                itemCount = Integer.parseInt(itemCountStr);
            } catch (NumberFormatException e) {
                request.setAttribute("success", false);
                request.setAttribute("errorMessage", "Invalid item count");
                request.getRequestDispatcher("/import-result.jsp").forward(request, response);
                return;
            }

            // Build item list
            List<ImportItemRequest> items = new ArrayList<>();

            for (int i = 0; i < itemCount; i++) {
                String partExisting = request.getParameter("partExisting_" + i);
                String partCode = request.getParameter("partCode_" + i);
                String partName = request.getParameter("partName_" + i);
                String unit = request.getParameter("unit_" + i);
                String description = request.getParameter("description_" + i);
                String quantityStr = request.getParameter("quantity_" + i);
                String unitPriceStr = request.getParameter("unitPrice_" + i);

                boolean addNewPart = "__NEW__".equals(partExisting);
                boolean existingPartChosen = partExisting != null && !partExisting.trim().isEmpty() && !addNewPart;

                if ((existingPartChosen || (partCode != null && !partCode.trim().isEmpty() && partName != null && !partName.trim().isEmpty() && unit != null && !unit.trim().isEmpty())) &&
                        quantityStr != null && !quantityStr.trim().isEmpty() &&
                        unitPriceStr != null && !unitPriceStr.trim().isEmpty()) {

                    try {
                        // Parse and validate quantity
                        int quantity = Integer.parseInt(quantityStr);
                        if (quantity <= 0) {
                            continue; // Skip invalid quantity
                        }

                        // Parse and validate unit price
                        double unitPrice = Double.parseDouble(unitPriceStr);
                        if (unitPrice <= 0) {
                            continue; // Skip invalid price
                        }

                        ImportItemRequest item = new ImportItemRequest();
                        if (existingPartChosen) {
                            item.setPartCode(partExisting.trim());
                            item.setPartName("");
                            item.setUnit("");
                            item.setDescription("");
                        } else {
                            item.setPartCode(partCode.trim());
                            item.setPartName(partName.trim());
                            item.setUnit(unit.trim());
                            item.setDescription(description);
                        }
                        item.setQuantity(quantity);
                        item.setUnitPrice(unitPrice);

                        items.add(item);
                    } catch (NumberFormatException e) {
                        // Skip items with invalid numbers
                        continue;
                    }
                }
            }

            // Validate at least one item
            if (items.isEmpty()) {
                request.setAttribute("success", false);
                request.setAttribute("errorMessage", "At least one valid item is required");
                request.getRequestDispatcher("/import-result.jsp").forward(request, response);
                return;
            }

            importRequest.setItems(items);

            // Process import
            int orderId = importService.processImport(importRequest);

            if (orderId > 0) {
                // Success - retrieve order and items
                ImportOrder order = importService.getOrderById(orderId);
                List<ImportOrderItem> itemsWithPrice = importService.getOrderItems(orderId);

                // Get supplier for display
                Supplier supplier = importService.getOrCreateSupplier(
                        importRequest.getSupplierName(),
                        importRequest.getSupplierContactName(),
                        importRequest.getSupplierPhone(),
                        importRequest.getSupplierEmail(),
                        importRequest.getSupplierAddress(),
                        importRequest.getSupplierTaxCode());

                // Get parts for display
                List<Part> partsWithDetails = new ArrayList<>();
                List<Part> allParts = importService.getAllParts();
                for (ImportOrderItem item : itemsWithPrice) {
                    Part part = allParts.stream()
                            .filter(p -> p.getPartId() == item.getPartId())
                            .findFirst()
                            .orElse(null);
                    if (part != null) {
                        partsWithDetails.add(part);
                    }
                }

                // Set attributes for result page
                request.setAttribute("success", true);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", itemsWithPrice);
                request.setAttribute("supplier", supplier);
                request.setAttribute("parts", partsWithDetails);

            } else {
                // Failed
                request.setAttribute("success", false);
                request.setAttribute("errorMessage", "Failed to process import. Please try again.");
            }

            // Forward to result page
            request.getRequestDispatcher("/import-result.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("success", false);
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/import-result.jsp").forward(request, response);
        }
    }
}
