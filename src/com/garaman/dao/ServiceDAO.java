package com.garaman.dao;

import com.garaman.model.Service;
import java.util.List;

/**
 * DAO Interface: ServiceDAO
 * Defines operations for Service entity
 */
public interface ServiceDAO {
    
    /**
     * Search services by name or code (contains keyword)
     * @param keyword Search keyword
     * @return List of matching services
     */
    List<Service> search(String keyword);

    /**
     * Get service by ID
     * @param id Service ID
     * @return Service object or null if not found
     */
    Service getById(int id);

    /**
     * Get all active services
     * @return List of all services
     */
    List<Service> getAll();
}
