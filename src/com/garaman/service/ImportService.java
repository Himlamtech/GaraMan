package com.garaman.service;

import com.garaman.dao.*;
import com.garaman.model.*;

import java.util.Date;
import java.util.List;

/**
 * Service Layer: ImportService
 * Business logic for importing parts from suppliers
 */
public class ImportService {

    private SupplierDAO supplierDAO;
    private PartDAO partDAO;
    private ImportOrderDAO orderDAO;
    private ImportOrderItemDAO orderItemDAO;

    public ImportService() {
        this.supplierDAO = new SupplierDAOImpl();
        this.partDAO = new PartDAOImpl();
        this.orderDAO = new ImportOrderDAOImpl();
        this.orderItemDAO = new ImportOrderItemDAOImpl();
    }

    /**
     * Get all suppliers
     * 
     * @return List of suppliers
     */
    public List<Supplier> getAllSuppliers() {
        return supplierDAO.getAll();
    }

    /**
     * Get or create supplier by name
     * 
     * @param supplierName Supplier name
     * @param phone        Phone number (for new supplier)
     * @param address      Address (for new supplier)
     * @return Supplier object
     */
    public Supplier getOrCreateSupplier(String supplierName, String contactName, String phone, String email, String address, String taxCode) {
        Supplier supplier = supplierDAO.getByName(supplierName);

        if (supplier == null) {
            // Create new supplier
            supplier = new Supplier();
            supplier.setName(supplierName);
            supplier.setContactName(contactName);
            supplier.setPhone(phone);
            supplier.setEmail(email);
            supplier.setAddress(address);
            supplier.setTaxCode(taxCode);
            supplier.setActive(true);
            int supplierId = supplierDAO.insert(supplier);
            supplier.setSupplierId(supplierId);
        }

        return supplier;
    }

    /**
     * Get all parts
     * 
     * @return List of parts
     */
    public List<Part> getAllParts() {
        return partDAO.getAll();
    }

    /**
     * Get or create part by name
     * 
     * @param partCode  Part code
     * @param partName  Part name
     * @param unit      Unit
     * @param unitPrice Unit price (for new part)
     * @return Part object
     */
    public Part getOrCreatePart(String partCode, String partName, String unit, double unitPrice, String description) {
        Part part = partDAO.getByCode(partCode);
        if (part == null) {
            part = partDAO.getByName(partName);
        }

        if (part == null) {
            // Create new part with initial stock = 0
            part = new Part();
            part.setCode(partCode);
            part.setName(partName);
            part.setDescription(description);
            part.setUnit(unit);
            part.setUnitPrice(unitPrice);
            part.setStockQty(0);
            part.setMinStockQty(0);
            part.setActive(true);
            int partId = partDAO.insert(part);
            part.setPartId(partId);
        }

        return part;
    }

    /**
     * Process import transaction
     * Creates invoice, adds items, updates stock
     * 
     * @param importRequest Import request data
     * @return Order ID if successful, -1 if failed
     */
    public int processImport(ImportRequest importRequest) {
        try {
            // 1. Get or create supplier
            Supplier supplier = getOrCreateSupplier(
                    importRequest.getSupplierName(),
                    importRequest.getSupplierContactName(),
                    importRequest.getSupplierPhone(),
                    importRequest.getSupplierEmail(),
                    importRequest.getSupplierAddress(),
                    importRequest.getSupplierTaxCode());

            // 2. Create import order (initial amount 0)
            ImportOrder order = new ImportOrder(
                    supplier.getSupplierId(),
                    importRequest.getWarehouseStaffId(),
                    new Date(),
                    0.0,
                    "CONFIRMED",
                    importRequest.getNote()
            );
            int orderId = orderDAO.insert(order);

            if (orderId <= 0) {
                return -1;
            }

            // 3. Process each import item
            double totalAmount = 0.0;

            for (ImportItemRequest itemRequest : importRequest.getItems()) {
                // Get or create part
                Part part = getOrCreatePart(
                        itemRequest.getPartCode(),
                        itemRequest.getPartName(),
                        itemRequest.getUnit(),
                        itemRequest.getUnitPrice(),
                        itemRequest.getDescription());

                double lineTotal = itemRequest.getQuantity() * itemRequest.getUnitPrice();

                // Create import item
                ImportOrderItem item = new ImportOrderItem(
                        orderId,
                        part.getPartId(),
                        itemRequest.getQuantity(),
                        itemRequest.getUnitPrice(),
                        lineTotal);
                orderItemDAO.insert(item);

                // Update part stock
                partDAO.updateStock(part.getPartId(), itemRequest.getQuantity());

                // Update part unit price (in case it changed)
                partDAO.updateUnitPrice(part.getPartId(), itemRequest.getUnitPrice());

                // Calculate total
                totalAmount += lineTotal;
            }

            // 4. Update order total amount
            orderDAO.updateTotalAmount(orderId, totalAmount);

            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Get order details by ID
     * 
     * @param orderId Order ID
     * @return ImportOrder object
     */
    public ImportOrder getOrderById(int orderId) {
        return orderDAO.getById(orderId);
    }

    /**
     * Get order items by order ID
     * 
     * @param orderId Order ID
     * @return List of ImportOrderItem objects
     */
    public List<ImportOrderItem> getOrderItems(int orderId) {
        return orderItemDAO.getByImportId(orderId);
    }

    /**
     * Inner class: ImportRequest
     * Data structure for import request
     */
    public static class ImportRequest {
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
     * Inner class: ImportItemRequest
     * Data structure for import item request
     */
    public static class ImportItemRequest {
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
