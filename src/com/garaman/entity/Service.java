package com.garaman.entity;

import java.io.Serializable;

public class Service implements Serializable {
    private int serviceId;
    private String serviceName;
    private String description;
    private double unitPrice;
    private int estimatedTime;
    private int status;

    public Service() {}

    public Service(int serviceId, String serviceName, String description, double unitPrice, int estimatedTime, int status) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.unitPrice = unitPrice;
        this.estimatedTime = estimatedTime;
        this.status = status;
    }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getEstimatedTime() { return estimatedTime; }
    public void setEstimatedTime(int estimatedTime) { this.estimatedTime = estimatedTime; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", unitPrice=" + unitPrice +
                '}';
    }
}
