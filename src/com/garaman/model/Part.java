package com.garaman.model;

/**
 * Domain Model: SparePart
 * Maps to table spare_part
 */
public class Part {
    private int partId;
    private String code;
    private String name;
    private String description;
    private String unit;
    private double unitPrice;
    private int stockQty;
    private int minStockQty;
    private boolean active;

    public Part() {
    }

    public Part(int partId, String code, String name, String description, String unit,
                double unitPrice, int stockQty, int minStockQty, boolean active) {
        this.partId = partId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.unit = unit;
        this.unitPrice = unitPrice;
        this.stockQty = stockQty;
        this.minStockQty = minStockQty;
        this.active = active;
    }

    public int getPartId() {
        return partId;
    }

    public void setPartId(int partId) {
        this.partId = partId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getStockQty() {
        return stockQty;
    }

    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public int getMinStockQty() {
        return minStockQty;
    }

    public void setMinStockQty(int minStockQty) {
        this.minStockQty = minStockQty;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
