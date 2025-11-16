package com.garaman.dao;

import com.garaman.model.Supplier;
import java.util.List;

/**
 * DAO Interface: SupplierDAO
 * Defines operations for Supplier entity
 */
public interface SupplierDAO {
    
    /**
     * Get supplier by ID
     * @param id Supplier ID
     * @return Supplier object or null if not found
     */
    Supplier getById(int id);

    /**
     * Get supplier by name (exact match)
     * @param name Supplier name
     * @return Supplier object or null if not found
     */
    Supplier getByName(String name);

    /**
     * Get all active suppliers
     * @return List of all suppliers
     */
    List<Supplier> getAll();

    /**
     * Insert new supplier
     * @param supplier Supplier object
     * @return Generated ID of new supplier
     */
    int insert(Supplier supplier);
}
