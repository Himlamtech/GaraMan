package com.garaman.entity;

import java.io.Serializable;

public class SparePart implements Serializable {
    private int partId;
    private String partName;
    private String description;
    private double unitPrice;
    private int stock;
    private int status;

    public SparePart() {}

    public SparePart(int partId, String partName, String description, double unitPrice, int stock, int status) {
        this.partId = partId;
        this.partName = partName;
        this.description = description;
        this.unitPrice = unitPrice;
        this.stock = stock;
        this.status = status;
    }

    public int getPartId() { return partId; }
    public void setPartId(int partId) { this.partId = partId; }

    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    @Override
    public String toString() {
        return "SparePart{" +
                "partId=" + partId +
                ", partName='" + partName + '\'' +
                ", unitPrice=" + unitPrice +
                ", stock=" + stock +
                '}';
    }
}
