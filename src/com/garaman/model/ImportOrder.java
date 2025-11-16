package com.garaman.model;

import java.util.Date;

/**
 * Domain Model: ImportOrder
 * Maps to table import_order
 */
public class ImportOrder {
    private int importId;
    private int supplierId;
    private int warehouseStaffId;
    private Date importDate;
    private double totalAmount;
    private String status; // DRAFT/CONFIRMED/CANCELLED/PAID
    private String note;

    public ImportOrder() {
    }

    public ImportOrder(int importId, int supplierId, int warehouseStaffId, Date importDate,
                       double totalAmount, String status, String note) {
        this.importId = importId;
        this.supplierId = supplierId;
        this.warehouseStaffId = warehouseStaffId;
        this.importDate = importDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.note = note;
    }

    public ImportOrder(int supplierId, int warehouseStaffId, Date importDate,
                       double totalAmount, String status, String note) {
        this.supplierId = supplierId;
        this.warehouseStaffId = warehouseStaffId;
        this.importDate = importDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.note = note;
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public int getWarehouseStaffId() {
        return warehouseStaffId;
    }

    public void setWarehouseStaffId(int warehouseStaffId) {
        this.warehouseStaffId = warehouseStaffId;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
