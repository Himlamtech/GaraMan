package com.garaman.model;

/**
 * Domain Model: Service
 * Maps to table service
 */
public class Service {
    private int serviceId;
    private String code;
    private String name;
    private String description;
    private double basePrice;
    private int durationMin;
    private boolean active;

    public Service() {
    }

    public Service(int serviceId, String code, String name, String description,
                   double basePrice, int durationMin, boolean active) {
        this.serviceId = serviceId;
        this.code = code;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.durationMin = durationMin;
        this.active = active;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
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

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public int getDurationMin() {
        return durationMin;
    }

    public void setDurationMin(int durationMin) {
        this.durationMin = durationMin;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
