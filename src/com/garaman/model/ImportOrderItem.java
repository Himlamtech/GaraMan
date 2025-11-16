package com.garaman.model;

/**
 * Domain Model: ImportOrderItem
 * Maps to table import_order_item
 */
public class ImportOrderItem {
    private int importItemId;
    private int importId;
    private int partId;
    private int quantity;
    private double unitPrice;
    private double lineTotal;

    public ImportOrderItem() {
    }

    public ImportOrderItem(int importItemId, int importId, int partId, int quantity,
                           double unitPrice, double lineTotal) {
        this.importItemId = importItemId;
        this.importId = importId;
        this.partId = partId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }

    public ImportOrderItem(int importId, int partId, int quantity,
                           double unitPrice, double lineTotal) {
        this.importId = importId;
        this.partId = partId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }

    public int getImportItemId() {
        return importItemId;
    }

    public void setImportItemId(int importItemId) {
        this.importItemId = importItemId;
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public int getPartId() {
        return partId;
    }

    public void setPartId(int partId) {
        this.partId = partId;
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

    public double getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(double lineTotal) {
        this.lineTotal = lineTotal;
    }
}
