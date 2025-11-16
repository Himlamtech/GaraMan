package com.garaman.service;

import com.garaman.entity.*;
import com.garaman.dao.impl.*;
import java.util.*;

public class ImportService {

    private SupplierDAOImpl supplierDAO = new SupplierDAOImpl();
    private SparePartDAOImpl partDAO = new SparePartDAOImpl();
    private ImportInvoiceDAOImpl invoiceDAO = new ImportInvoiceDAOImpl();
    private ImportInvoiceDetailDAOImpl detailDAO = new ImportInvoiceDetailDAOImpl();
    private DiscountDAOImpl discountDAO = new DiscountDAOImpl();

    public List<Supplier> getAllSuppliers() {
        return supplierDAO.getAll();
    }

    public Supplier getSupplierById(int supplierId) {
        return supplierDAO.getById(supplierId);
    }

    public int createSupplier(String supplierName, String address, String phone, String email) {
        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName);
        supplier.setAddress(address);
        supplier.setPhone(phone);
        supplier.setEmail(email);
        supplier.setStatus(1);

        return supplierDAO.insert(supplier);
    }

    public List<SparePart> getAllParts() {
        return partDAO.getAll();
    }

    public SparePart getPartById(int partId) {
        return partDAO.getById(partId);
    }

    public int createPart(String partName, String description, double unitPrice) {
        SparePart part = new SparePart();
        part.setPartName(partName);
        part.setDescription(description);
        part.setUnitPrice(unitPrice);
        part.setStock(0);
        part.setStatus(1);

        return partDAO.insert(part);
    }

    public List<Discount> getAvailableDiscounts() {
        return discountDAO.getAllActive();
    }

    public Discount getDiscountById(int discountId) {
        return discountDAO.getById(discountId);
    }

    public ImportResult processImport(int supplierId, List<ImportItem> items) {
        return processImport(supplierId, items, 0);
    }

    public ImportResult processImport(int supplierId, List<ImportItem> items, int discountId) {
        ImportResult result = new ImportResult();

        if (items == null || items.isEmpty()) {
            result.success = false;
            result.message = "No items to import";
            return result;
        }

        try {
            // Create invoice
            ImportInvoice invoice = new ImportInvoice();
            invoice.setSupplierId(supplierId);
            invoice.setInvoiceDate(new Date());
            invoice.setStatus(1);

            int invoiceId = invoiceDAO.insert(invoice);
            if (invoiceId == -1) {
                result.success = false;
                result.message = "Failed to create invoice";
                return result;
            }

            double totalAmount = 0;
            int detailCount = 0;

            // Process each item
            for (ImportItem item : items) {
                double lineTotal = item.quantity * item.importPrice;
                totalAmount += lineTotal;

                // Create detail record
                ImportInvoiceDetail detail = new ImportInvoiceDetail();
                detail.setInvoiceId(invoiceId);
                detail.setPartId(item.partId);
                detail.setQuantity(item.quantity);
                detail.setImportPrice(item.importPrice);
                detail.setLineTotal(lineTotal);

                int detailId = detailDAO.insert(detail);
                if (detailId != -1) {
                    // Update stock and price
                    partDAO.updateStock(item.partId, item.quantity);
                    partDAO.updateUnitPrice(item.partId, item.importPrice);
                    detailCount++;
                }
            }

            // Handle discount if provided
            double discountAmount = 0;
            double finalAmount = totalAmount;
            Discount discount = null;

            if (discountId > 0) {
                discount = discountDAO.getById(discountId);
                if (discount != null && discount.isActive()) {
                    discountAmount = discount.calculateDiscount(totalAmount);
                    finalAmount = totalAmount - discountAmount;

                    // Update invoice with discount info
                    invoiceDAO.updateDiscount(invoiceId, discountId, discountAmount, finalAmount);

                    // Increment discount usage count
                    discountDAO.incrementUsageCount(discountId);
                } else {
                    // Invalid discount, just save without it
                    invoiceDAO.updateTotalAmount(invoiceId, totalAmount);
                    finalAmount = totalAmount;
                }
            } else {
                // No discount applied
                invoiceDAO.updateTotalAmount(invoiceId, totalAmount);
            }

            result.success = true;
            result.invoiceId = invoiceId;
            result.totalAmount = totalAmount;
            result.discountAmount = discountAmount;
            result.finalAmount = finalAmount;
            result.itemsProcessed = detailCount;
            result.discountName = (discount != null) ? discount.getDiscountName() : null;

            if (discountAmount > 0) {
                result.message = "Import successful: " + detailCount + " items, Subtotal: $"
                        + String.format("%.2f", totalAmount) + ", Discount: -$"
                        + String.format("%.2f", discountAmount) + ", Total: $"
                        + String.format("%.2f", finalAmount);
            } else {
                result.message = "Import successful: " + detailCount + " items, Total: $"
                        + String.format("%.2f", totalAmount);
            }

            return result;

        } catch (Exception e) {
            result.success = false;
            result.message = "Error: " + e.getMessage();
            e.printStackTrace();
            return result;
        }
    }

    public static class ImportItem {
        public int partId;
        public int quantity;
        public double importPrice;

        public ImportItem(int partId, int quantity, double importPrice) {
            this.partId = partId;
            this.quantity = quantity;
            this.importPrice = importPrice;
        }
    }

    public static class ImportResult {
        public boolean success;
        public int invoiceId;
        public double totalAmount;
        public double discountAmount;
        public double finalAmount;
        public String discountName;
        public int itemsProcessed;
        public String message;

        public boolean isSuccess() {
            return success;
        }

        public int getInvoiceId() {
            return invoiceId;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public double getDiscountAmount() {
            return discountAmount;
        }

        public double getFinalAmount() {
            return finalAmount;
        }

        public String getDiscountName() {
            return discountName;
        }

        public int getItemsProcessed() {
            return itemsProcessed;
        }

        public String getMessage() {
            return message;
        }
    }

    public List<ImportInvoiceDetail> getInvoiceDetails(int invoiceId) {
        return detailDAO.getByInvoiceId(invoiceId);
    }
}
