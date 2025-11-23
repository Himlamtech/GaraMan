package com.garaman.entity;

import java.io.Serializable;
import java.util.Date;

public class ImportInvoice implements Serializable {
    private int invoiceId;
    private int supplierId;
    private Date invoiceDate;
    private double totalAmount;
    private String note;
    private int status;

    public ImportInvoice() {}

    public ImportInvoice(int invoiceId, int supplierId, Date invoiceDate, double totalAmount, String note, int status) {
        this.invoiceId = invoiceId;
        this.supplierId = supplierId;
        this.invoiceDate = invoiceDate;
        this.totalAmount = totalAmount;
        this.note = note;
        this.status = status;
    }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public Date getInvoiceDate() { return invoiceDate; }
    public void setInvoiceDate(Date invoiceDate) { this.invoiceDate = invoiceDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    @Override
    public String toString() {
        return "ImportInvoice{" +
                "invoiceId=" + invoiceId +
                ", supplierId=" + supplierId +
                ", totalAmount=" + totalAmount +
                '}';
    }
}
