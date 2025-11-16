package com.garaman.dao;

import com.garaman.model.ImportOrder;
import java.util.List;

/**
 * DAO Interface: ImportOrderDAO
 * Defines operations for ImportOrder entity
 */
public interface ImportOrderDAO {

    /**
     * Insert new import order
     * @param order ImportOrder object
     * @return Generated ID of new order
     */
    int insert(ImportOrder order);

    /**
     * Get order by ID
     * @param id Order ID
     * @return ImportOrder object or null if not found
     */
    ImportOrder getById(int id);

    /**
     * Update order total amount
     * @param orderId Order ID
     * @param totalAmount New total amount
     */
    void updateTotalAmount(int orderId, double totalAmount);

    /**
     * Update status
     * @param orderId order id
     * @param status new status
     */
    void updateStatus(int orderId, String status);

    /**
     * Get all orders
     * @return List of all orders
     */
    List<ImportOrder> getAll();
}
