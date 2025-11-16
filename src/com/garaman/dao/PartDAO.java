package com.garaman.dao;

import com.garaman.model.Part;
import java.util.List;

/**
 * DAO Interface: PartDAO
 * Defines operations for Part entity
 */
public interface PartDAO {

    /**
     * Search parts by name or code (contains keyword)
     * 
     * @param keyword Search keyword
     * @return List of matching parts
     */
    List<Part> search(String keyword);

    /**
     * Get part by ID
     * 
     * @param id Part ID
     * @return Part object or null if not found
     */
    Part getById(int id);

    /**
     * Get part by name (exact match)
     * 
     * @param name Part name
     * @return Part object or null if not found
     */
    Part getByName(String name);

    /**
     * Get part by code
     * 
     * @param code Part code
     * @return Part object or null if not found
     */
    Part getByCode(String code);

    /**
     * Get all parts
     * 
     * @return List of all parts
     */
    List<Part> getAll();

    /**
     * Insert new part
     * 
     * @param part Part object
     * @return Generated ID of new part
     */
    int insert(Part part);

    /**
     * Update part stock quantity
     * 
     * @param partId   Part ID
     * @param quantity Quantity to add
     */
    void updateStock(int partId, int quantity);

    /**
     * Update part unit price
     * 
     * @param partId    Part ID
     * @param unitPrice New unit price
     */
    void updateUnitPrice(int partId, double unitPrice);
}
