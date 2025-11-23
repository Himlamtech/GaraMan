package com.garaman.dao.impl;

import com.garaman.dao.SparePartDAO;
import com.garaman.entity.SparePart;
import com.garaman.util.DBConnection;
import java.sql.*;
import java.util.*;

public class SparePartDAOImpl implements SparePartDAO {

    @Override
    public List<SparePart> searchByName(String keyword) {
        List<SparePart> parts = new ArrayList<>();
        String sql = "SELECT * FROM tbl_spare_part WHERE partName LIKE ? AND status = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                parts.add(mapResultSetToPart(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parts;
    }

    @Override
    public SparePart getById(int partId) {
        String sql = "SELECT * FROM tbl_spare_part WHERE partId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, partId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<SparePart> getAll() {
        List<SparePart> parts = new ArrayList<>();
        String sql = "SELECT * FROM tbl_spare_part WHERE status = 1";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                parts.add(mapResultSetToPart(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return parts;
    }

    @Override
    public int insert(SparePart part) {
        String sql = "INSERT INTO tbl_spare_part (partName, description, unitPrice, stock, status) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, part.getPartName());
            stmt.setString(2, part.getDescription());
            stmt.setDouble(3, part.getUnitPrice());
            stmt.setInt(4, part.getStock());
            stmt.setInt(5, part.getStatus());
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    @Override
    public void updateStock(int partId, int quantity) {
        String sql = "UPDATE tbl_spare_part SET stock = stock + ? WHERE partId = ?";
        
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
    public void updateUnitPrice(int partId, double price) {
        String sql = "UPDATE tbl_spare_part SET unitPrice = ? WHERE partId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, price);
            stmt.setInt(2, partId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private SparePart mapResultSetToPart(ResultSet rs) throws SQLException {
        return new SparePart(
            rs.getInt("partId"),
            rs.getString("partName"),
            rs.getString("description"),
            rs.getDouble("unitPrice"),
            rs.getInt("stock"),
            rs.getInt("status")
        );
    }
}
