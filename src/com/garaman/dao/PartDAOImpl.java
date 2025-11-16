package com.garaman.dao;

import com.garaman.model.Part;
import com.garaman.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC Implementation: PartDAO
 */
public class PartDAOImpl implements PartDAO {
    
    @Override
    public List<Part> search(String keyword) {
        List<Part> parts = new ArrayList<>();
        String sql = "SELECT part_id, code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active " +
                "FROM spare_part WHERE is_active = 1 AND (name LIKE ? OR code LIKE ?) ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Part part = new Part(
                    rs.getInt("part_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("unit"),
                    rs.getDouble("unit_price"),
                    rs.getInt("stock_qty"),
                    rs.getInt("min_stock_qty"),
                    rs.getBoolean("is_active")
                );
                parts.add(part);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parts;
    }
    
    @Override
    public Part getById(int id) {
        String sql = "SELECT part_id, code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active FROM spare_part WHERE part_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Part(
                    rs.getInt("part_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("unit"),
                    rs.getDouble("unit_price"),
                    rs.getInt("stock_qty"),
                    rs.getInt("min_stock_qty"),
                    rs.getBoolean("is_active")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public Part getByName(String name) {
        String sql = "SELECT part_id, code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active FROM spare_part WHERE name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Part(
                    rs.getInt("part_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("unit"),
                    rs.getDouble("unit_price"),
                    rs.getInt("stock_qty"),
                    rs.getInt("min_stock_qty"),
                    rs.getBoolean("is_active")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public Part getByCode(String code) {
        String sql = "SELECT part_id, code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active " +
                "FROM spare_part WHERE code = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Part(
                    rs.getInt("part_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("unit"),
                    rs.getDouble("unit_price"),
                    rs.getInt("stock_qty"),
                    rs.getInt("min_stock_qty"),
                    rs.getBoolean("is_active")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    @Override
    public List<Part> getAll() {
        List<Part> parts = new ArrayList<>();
        String sql = "SELECT part_id, code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active FROM spare_part WHERE is_active = 1 ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Part part = new Part(
                    rs.getInt("part_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("unit"),
                    rs.getDouble("unit_price"),
                    rs.getInt("stock_qty"),
                    rs.getInt("min_stock_qty"),
                    rs.getBoolean("is_active")
                );
                parts.add(part);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return parts;
    }
    
    @Override
    public int insert(Part part) {
        String sql = "INSERT INTO spare_part (code, name, description, unit, unit_price, stock_qty, min_stock_qty, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, part.getCode());
            stmt.setString(2, part.getName());
            stmt.setString(3, part.getDescription());
            stmt.setString(4, part.getUnit());
            stmt.setDouble(5, part.getUnitPrice());
            stmt.setInt(6, part.getStockQty());
            stmt.setInt(7, part.getMinStockQty());
            stmt.setBoolean(8, part.isActive());
            
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
    public void updateStock(int partId, int quantity) {
        String sql = "UPDATE spare_part SET stock_qty = stock_qty + ? WHERE part_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, partId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void updateUnitPrice(int partId, double unitPrice) {
        String sql = "UPDATE spare_part SET unit_price = ? WHERE part_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, unitPrice);
            stmt.setInt(2, partId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
