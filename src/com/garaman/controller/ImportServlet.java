package com.garaman.controller;

import com.garaman.dao.ImportOrderDAO;
import com.garaman.dao.ImportOrderDAOImpl;
import com.garaman.dao.ImportOrderItemDAO;
import com.garaman.dao.ImportOrderItemDAOImpl;
import com.garaman.dao.PartDAO;
import com.garaman.dao.PartDAOImpl;
import com.garaman.dao.SupplierDAO;
import com.garaman.dao.SupplierDAOImpl;
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
import java.util.Date;
import java.util.List;

/**
 * Controller: ImportServlet
 * Handles warehouse staff import operations
 */
public class ImportServlet extends HttpServlet {

    private SupplierDAO supplierDAO;
    private PartDAO partDAO;
    private ImportOrderDAO orderDAO;
    private ImportOrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAOImpl();
        partDAO = new PartDAOImpl();
        orderDAO = new ImportOrderDAOImpl();
        orderItemDAO = new ImportOrderItemDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Prepare suppliers and parts for selection
        List<Supplier> suppliers = supplierDAO.getAll();
        List<Part> parts = partDAO.getAll();
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("parts", parts);

        // Forward to import form page
        request.getRequestDispatcher("/import-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        boolean isAjax = isAjax(request);
        try {
            // DEBUG: Log ALL parameters
            System.out.println("=== ALL REQUEST PARAMETERS ===");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String[] paramValues = request.getParameterValues(paramName);
                System.out.println("  " + paramName + " = " + java.util.Arrays.toString(paramValues));
            }
            System.out.println("=== END PARAMETERS ===");

            // Build import request
            ImportRequest importRequest = new ImportRequest();

            // Supplier information - with validation
            String supplierName = request.getParameter("supplierName");
            String supplierNameNew = request.getParameter("supplierNameNew");

            // DEBUG: Log received parameters
            System.out.println("DEBUG ImportServlet.doPost:");
            System.out.println("  supplierName parameter: [" + supplierName + "]");
            System.out.println("  supplierNameNew parameter: [" + supplierNameNew + "]");
            System.out.println("  supplierName == null: " + (supplierName == null));
            System.out.println("  supplierName isEmpty: " + (supplierName != null && supplierName.isEmpty()));

            boolean addingNewSupplier = "__NEW__".equals(supplierName);
            String supplierNameToUse = addingNewSupplier ? supplierNameNew : supplierName;

            System.out.println("  addingNewSupplier: " + addingNewSupplier);
            System.out.println("  supplierNameToUse: [" + supplierNameToUse + "]");

            if (supplierNameToUse == null || supplierNameToUse.trim().isEmpty()) {
                System.out.println("  VALIDATION FAILED: Supplier name is required");
                handleError(response, isAjax, "Supplier name is required", request);
                return;
            }

            importRequest.setSupplierName(supplierNameToUse.trim());
            importRequest.setSupplierContactName(request.getParameter("supplierContactName"));
            importRequest.setSupplierPhone(request.getParameter("supplierPhone"));
            importRequest.setSupplierEmail(request.getParameter("supplierEmail"));
            importRequest.setSupplierAddress(request.getParameter("supplierAddress"));
            importRequest.setSupplierTaxCode(request.getParameter("supplierTaxCode"));
            importRequest.setNote(request.getParameter("note"));

            // TEMPORARY FIX: Use default staff ID for testing
            Object staffIdObj = request.getSession().getAttribute("userId");
            if (staffIdObj instanceof Integer) {
                importRequest.setWarehouseStaffId((Integer) staffIdObj);
            } else {
                // For testing without login, use default staff ID = 1
                System.out.println("  WARNING: No userId in session, using default staffId = 1");
                importRequest.setWarehouseStaffId(1);
                // TODO: Remove this and require proper login before deployment
                // handleError(response, isAjax, "Invalid warehouse staff session", request);
                // return;
            }

            // Get number of items
            String itemCountStr = request.getParameter("itemCount");
            int itemCount;
            try {
                itemCount = Integer.parseInt(itemCountStr);
            } catch (NumberFormatException e) {
                handleError(response, isAjax, "Invalid item count", request);
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

                if ((existingPartChosen || (partCode != null && !partCode.trim().isEmpty() && partName != null
                        && !partName.trim().isEmpty() && unit != null && !unit.trim().isEmpty())) &&
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
                handleError(response, isAjax, "At least one valid item is required", request);
                return;
            }

            importRequest.setItems(items);

            // Process import
            ImportProcessingResult result = processImport(importRequest);

            if (result.isSuccess()) {
                ImportOrder order = getOrderById(result.getOrderId());
                List<ImportOrderItem> itemsWithPrice = getOrderItems(result.getOrderId());

                Supplier supplier = null;
                if (order != null) {
                    supplier = supplierDAO.getById(order.getSupplierId());
                }

                List<Part> partsWithDetails = getPartsForItems(itemsWithPrice);

                if (isAjax) {
                    writeJson(response, HttpServletResponse.SC_OK, String.format(
                            "{\"success\":true,\"orderId\":%d,\"totalAmount\":%.2f,\"supplierName\":\"%s\"}",
                            result.getOrderId(), result.getTotalAmount(),
                            escapeJson(supplier != null ? supplier.getName() : "")));
                } else {
                    request.setAttribute("success", true);
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", itemsWithPrice);
                    request.setAttribute("supplier", supplier);
                    request.setAttribute("parts", partsWithDetails);
                }

            } else {
                handleError(response, isAjax, "Failed to process import. Please try again.", request);
                return;
            }

            // Forward to result page
            if (!isAjax) {
                request.getRequestDispatcher("/import-result.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            handleError(response, isAjax, "Error: " + e.getMessage(), request);
        }
    }

    private ImportProcessingResult processImport(ImportRequest importRequest) {
        try {
            Supplier supplier = getOrCreateSupplier(importRequest);

            ImportOrder order = new ImportOrder(
                    supplier.getSupplierId(),
                    importRequest.getWarehouseStaffId(),
                    new Date(),
                    0.0,
                    "CONFIRMED",
                    importRequest.getNote());
            int orderId = orderDAO.insert(order);

            if (orderId <= 0) {
                return ImportProcessingResult.failure();
            }

            double totalAmount = 0.0;

            for (ImportItemRequest itemRequest : importRequest.getItems()) {
                Part part = getOrCreatePart(itemRequest);

                double lineTotal = itemRequest.getQuantity() * itemRequest.getUnitPrice();

                ImportOrderItem item = new ImportOrderItem(
                        orderId,
                        part.getPartId(),
                        itemRequest.getQuantity(),
                        itemRequest.getUnitPrice(),
                        lineTotal);
                orderItemDAO.insert(item);

                partDAO.updateStock(part.getPartId(), itemRequest.getQuantity());
                partDAO.updateUnitPrice(part.getPartId(), itemRequest.getUnitPrice());

                totalAmount += lineTotal;
            }

            orderDAO.updateTotalAmount(orderId, totalAmount);

            return ImportProcessingResult.success(orderId, totalAmount);

        } catch (Exception e) {
            e.printStackTrace();
            return ImportProcessingResult.failure();
        }
    }

    private Supplier getOrCreateSupplier(ImportRequest importRequest) {
        Supplier supplier = supplierDAO.getByName(importRequest.getSupplierName());

        if (supplier == null) {
            supplier = new Supplier();
            supplier.setName(importRequest.getSupplierName());
            supplier.setContactName(importRequest.getSupplierContactName());
            supplier.setPhone(importRequest.getSupplierPhone());
            supplier.setEmail(importRequest.getSupplierEmail());
            supplier.setAddress(importRequest.getSupplierAddress());
            supplier.setTaxCode(importRequest.getSupplierTaxCode());
            supplier.setActive(true);
            int supplierId = supplierDAO.insert(supplier);
            supplier.setSupplierId(supplierId);
        }

        return supplier;
    }

    private Part getOrCreatePart(ImportItemRequest itemRequest) {
        Part part = partDAO.getByCode(itemRequest.getPartCode());
        if (part == null && itemRequest.getPartName() != null && !itemRequest.getPartName().isEmpty()) {
            part = partDAO.getByName(itemRequest.getPartName());
        }

        if (part == null) {
            part = new Part();
            part.setCode(itemRequest.getPartCode());
            part.setName(itemRequest.getPartName());
            part.setDescription(itemRequest.getDescription());
            part.setUnit(itemRequest.getUnit());
            part.setUnitPrice(itemRequest.getUnitPrice());
            part.setStockQty(0);
            part.setMinStockQty(0);
            part.setActive(true);
            int partId = partDAO.insert(part);
            part.setPartId(partId);
        }

        return part;
    }

    private ImportOrder getOrderById(int orderId) {
        return orderDAO.getById(orderId);
    }

    private List<ImportOrderItem> getOrderItems(int orderId) {
        return orderItemDAO.getByImportId(orderId);
    }

    private List<Part> getPartsForItems(List<ImportOrderItem> items) {
        List<Part> parts = new ArrayList<>();
        for (ImportOrderItem item : items) {
            Part part = partDAO.getById(item.getPartId());
            if (part != null) {
                parts.add(part);
            }
        }
        return parts;
    }

    private boolean isAjax(HttpServletRequest request) {
        String header = request.getHeader("X-Requested-With");
        return header != null && "XMLHttpRequest".equalsIgnoreCase(header);
    }

    private void handleError(HttpServletResponse response, boolean isAjax, String message, HttpServletRequest request)
            throws IOException, ServletException {
        if (isAjax) {
            writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    String.format("{\"success\":false,\"message\":\"%s\"}", escapeJson(message)));
        } else {
            request.setAttribute("success", false);
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("/import-result.jsp").forward(request, response);
        }
    }

    private void writeJson(HttpServletResponse response, int status, String json) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(json);
    }

    private String escapeJson(String value) {
        return value == null ? "" : value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static class ImportProcessingResult {
        private final int orderId;
        private final double totalAmount;

        private ImportProcessingResult(int orderId, double totalAmount) {
            this.orderId = orderId;
            this.totalAmount = totalAmount;
        }

        static ImportProcessingResult success(int orderId, double totalAmount) {
            return new ImportProcessingResult(orderId, totalAmount);
        }

        static ImportProcessingResult failure() {
            return new ImportProcessingResult(-1, 0.0);
        }

        boolean isSuccess() {
            return orderId > 0;
        }

        int getOrderId() {
            return orderId;
        }

        double getTotalAmount() {
            return totalAmount;
        }
    }

    /**
     * Data structure for import request
     */
    private static class ImportRequest {
        private String supplierName;
        private String supplierContactName;
        private String supplierPhone;
        private String supplierEmail;
        private String supplierAddress;
        private String supplierTaxCode;
        private int warehouseStaffId;
        private String note;
        private List<ImportItemRequest> items;

        public String getSupplierName() {
            return supplierName;
        }

        public void setSupplierName(String supplierName) {
            this.supplierName = supplierName;
        }

        public String getSupplierContactName() {
            return supplierContactName;
        }

        public void setSupplierContactName(String supplierContactName) {
            this.supplierContactName = supplierContactName;
        }

        public String getSupplierPhone() {
            return supplierPhone;
        }

        public void setSupplierPhone(String supplierPhone) {
            this.supplierPhone = supplierPhone;
        }

        public String getSupplierEmail() {
            return supplierEmail;
        }

        public void setSupplierEmail(String supplierEmail) {
            this.supplierEmail = supplierEmail;
        }

        public String getSupplierAddress() {
            return supplierAddress;
        }

        public void setSupplierAddress(String supplierAddress) {
            this.supplierAddress = supplierAddress;
        }

        public String getSupplierTaxCode() {
            return supplierTaxCode;
        }

        public void setSupplierTaxCode(String supplierTaxCode) {
            this.supplierTaxCode = supplierTaxCode;
        }

        public int getWarehouseStaffId() {
            return warehouseStaffId;
        }

        public void setWarehouseStaffId(int warehouseStaffId) {
            this.warehouseStaffId = warehouseStaffId;
        }

        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = note;
        }

        public List<ImportItemRequest> getItems() {
            return items;
        }

        public void setItems(List<ImportItemRequest> items) {
            this.items = items;
        }
    }

    /**
     * Data structure for import item request
     */
    private static class ImportItemRequest {
        private String partCode;
        private String partName;
        private String unit;
        private String description;
        private int quantity;
        private double unitPrice;

        public String getPartCode() {
            return partCode;
        }

        public void setPartCode(String partCode) {
            this.partCode = partCode;
        }

        public String getPartName() {
            return partName;
        }

        public void setPartName(String partName) {
            this.partName = partName;
        }

        public String getUnit() {
            return unit;
        }

        public void setUnit(String unit) {
            this.unit = unit;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public double getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(double unitPrice) {
            this.unitPrice = unitPrice;
        }
    }
}
