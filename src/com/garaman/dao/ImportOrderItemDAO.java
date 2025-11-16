package com.garaman.dao;

import com.garaman.model.ImportOrderItem;
import java.util.List;

/**
 * DAO Interface: ImportOrderItemDAO
 * Defines operations for ImportOrderItem entity
 */
public interface ImportOrderItemDAO {
    
    /**
     * Insert new import item
     * @param item ImportOrderItem object
     * @return Generated ID of new item
     */
    int insert(ImportOrderItem item);
    
    /**
     * Get items by import order ID
     * @param importId Import order ID
     * @return List of import items for the order
     */
    List<ImportOrderItem> getByImportId(int importId);
    
    /**
     * Get all import items
     * @return List of all import items
     */
    List<ImportOrderItem> getAll();
}
