package com.garaman.dao.impl;

import com.garaman.dao.SupplierDAO;
import com.garaman.entity.Supplier;
import com.garaman.util.DBConnection;
import java.sql.*;
import java.util.*;

public class SupplierDAOImpl implements SupplierDAO {

    @Override
    public List<Supplier> getAll() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM tbl_supplier WHERE status = 1";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                suppliers.add(mapResultSetToSupplier(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    @Override
    public Supplier getById(int supplierId) {
        String sql = "SELECT * FROM tbl_supplier WHERE supplierId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, supplierId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSupplier(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int insert(Supplier supplier) {
        String sql = "INSERT INTO tbl_supplier (supplierName, address, phone, email, status) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, supplier.getSupplierName());
            stmt.setString(2, supplier.getAddress());
            stmt.setString(3, supplier.getPhone());
            stmt.setString(4, supplier.getEmail());
            stmt.setInt(5, supplier.getStatus());
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

    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        return new Supplier(
            rs.getInt("supplierId"),
            rs.getString("supplierName"),
            rs.getString("address"),
            rs.getString("phone"),
            rs.getString("email"),
            rs.getInt("status")
        );
    }
}
