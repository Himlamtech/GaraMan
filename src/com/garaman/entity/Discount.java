package com.garaman.entity;

import java.io.Serializable;
import java.util.Date;

public class Discount implements Serializable {
    private int discountId;
    private String discountName;
    private String discountType; // "percentage" or "fixed"
    private double discountValue;
    private String description;
    private int maxUsageCount;
    private int usageCount;
    private Date startDate;
    private Date endDate;
    private int status;
    private Date createdAt;

    public Discount() {
    }

    public Discount(int discountId, String discountName, String discountType, double discountValue,
            String description, int maxUsageCount, int usageCount,
            Date startDate, Date endDate, int status, Date createdAt) {
        this.discountId = discountId;
        this.discountName = discountName;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.description = description;
        this.maxUsageCount = maxUsageCount;
        this.usageCount = usageCount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Check if discount is currently active and available
    public boolean isActive() {
        if (status != 1)
            return false;

        Date now = new Date();
        if (startDate != null && now.before(startDate))
            return false;
        if (endDate != null && now.after(endDate))
            return false;
        if (maxUsageCount != -1 && usageCount >= maxUsageCount)
            return false;

        return true;
    }

    // Calculate discount amount based on total
    public double calculateDiscount(double totalAmount) {
        if ("percentage".equals(discountType)) {
            return totalAmount * discountValue / 100;
        } else {
            return Math.min(discountValue, totalAmount); // Fixed amount, but not more than total
        }
    }

    // Get display text for discount
    public String getDisplayText() {
        if ("percentage".equals(discountType)) {
            return discountName + " (" + discountValue + "%)";
        } else {
            return discountName + " ($" + discountValue + " OFF)";
        }
    }

    // Get usage info
    public String getUsageInfo() {
        if (maxUsageCount == -1) {
            return usageCount + "/∞";
        }
        return usageCount + "/" + maxUsageCount;
    }

    // Getters and Setters
    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public String getDiscountName() {
        return discountName;
    }

    public void setDiscountName(String discountName) {
        this.discountName = discountName;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getMaxUsageCount() {
        return maxUsageCount;
    }

    public void setMaxUsageCount(int maxUsageCount) {
        this.maxUsageCount = maxUsageCount;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Discount{" +
                "discountId=" + discountId +
                ", discountName='" + discountName + '\'' +
                ", discountType='" + discountType + '\'' +
                ", discountValue=" + discountValue +
                ", usageCount=" + usageCount +
                ", maxUsageCount=" + maxUsageCount +
                '}';
    }
}
