package com.garaman.dao;

import com.garaman.model.ImportOrderItem;
import com.garaman.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC Implementation: ImportOrderItemDAO
 */
public class ImportOrderItemDAOImpl implements ImportOrderItemDAO {
    
    @Override
    public int insert(ImportOrderItem item) {
        String sql = "INSERT INTO import_order_item (import_id, part_id, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, item.getImportId());
            stmt.setInt(2, item.getPartId());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getUnitPrice());
            stmt.setDouble(5, item.getLineTotal());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    @Override
    public List<ImportOrderItem> getByImportId(int importId) {
        List<ImportOrderItem> items = new ArrayList<>();
        String sql = "SELECT import_item_id, import_id, part_id, quantity, unit_price, line_total FROM import_order_item WHERE import_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, importId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ImportOrderItem item = new ImportOrderItem(
                    rs.getInt("import_item_id"),
                    rs.getInt("import_id"),
                    rs.getInt("part_id"),
                    rs.getInt("quantity"),
                    rs.getDouble("unit_price"),
                    rs.getDouble("line_total")
                );
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
    
    @Override
    public List<ImportOrderItem> getAll() {
        List<ImportOrderItem> items = new ArrayList<>();
        String sql = "SELECT import_item_id, import_id, part_id, quantity, unit_price, line_total FROM import_order_item";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ImportOrderItem item = new ImportOrderItem(
                    rs.getInt("import_item_id"),
                    rs.getInt("import_id"),
                    rs.getInt("part_id"),
                    rs.getInt("quantity"),
                    rs.getDouble("unit_price"),
                    rs.getDouble("line_total")
                );
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return items;
    }
}
