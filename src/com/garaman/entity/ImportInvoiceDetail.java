package com.garaman.entity;

import java.io.Serializable;

public class ImportInvoiceDetail implements Serializable {
    private int detailId;
    private int invoiceId;
    private int partId;
    private int quantity;
    private double importPrice;
    private double lineTotal;

    public ImportInvoiceDetail() {}

    public ImportInvoiceDetail(int detailId, int invoiceId, int partId, int quantity, double importPrice, double lineTotal) {
        this.detailId = detailId;
        this.invoiceId = invoiceId;
        this.partId = partId;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.lineTotal = lineTotal;
    }

    public int getDetailId() { return detailId; }
    public void setDetailId(int detailId) { this.detailId = detailId; }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public int getPartId() { return partId; }
    public void setPartId(int partId) { this.partId = partId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getImportPrice() { return importPrice; }
    public void setImportPrice(double importPrice) { this.importPrice = importPrice; }

    public double getLineTotal() { return lineTotal; }
    public void setLineTotal(double lineTotal) { this.lineTotal = lineTotal; }

    @Override
    public String toString() {
        return "ImportInvoiceDetail{" +
                "detailId=" + detailId +
                ", partId=" + partId +
                ", quantity=" + quantity +
                '}';
    }
}
