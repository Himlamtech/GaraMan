package com.garaman.dao.impl;

import com.garaman.dao.ImportInvoiceDAO;
import com.garaman.entity.ImportInvoice;
import com.garaman.util.DBConnection;
import java.sql.*;

public class ImportInvoiceDAOImpl implements ImportInvoiceDAO {

    @Override
    public int insert(ImportInvoice invoice) {
        String sql = "INSERT INTO tbl_import_invoice (supplierId, invoiceDate, totalAmount, note, status) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, invoice.getSupplierId());
            stmt.setTimestamp(2, new Timestamp(invoice.getInvoiceDate().getTime()));
            stmt.setDouble(3, invoice.getTotalAmount());
            stmt.setString(4, invoice.getNote());
            stmt.setInt(5, invoice.getStatus());
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
    public void updateTotalAmount(int invoiceId, double amount) {
        String sql = "UPDATE tbl_import_invoice SET totalAmount = ? WHERE invoiceId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, amount);
            stmt.setInt(2, invoiceId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
