package com.garaman.dao.impl;

import com.garaman.dao.ImportInvoiceDetailDAO;
import com.garaman.entity.ImportInvoiceDetail;
import com.garaman.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ImportInvoiceDetailDAOImpl implements ImportInvoiceDetailDAO {

    @Override
    public int insert(ImportInvoiceDetail detail) {
        String sql = "INSERT INTO tbl_import_invoice_detail (invoiceId, partId, quantity, importPrice, lineTotal) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, detail.getInvoiceId());
            stmt.setInt(2, detail.getPartId());
            stmt.setInt(3, detail.getQuantity());
            stmt.setDouble(4, detail.getImportPrice());
            stmt.setDouble(5, detail.getLineTotal());
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
    public List<ImportInvoiceDetail> getByInvoiceId(int invoiceId) {
        List<ImportInvoiceDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM tbl_import_invoice_detail WHERE invoiceId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, invoiceId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                details.add(mapResultSetToDetail(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return details;
    }

    private ImportInvoiceDetail mapResultSetToDetail(ResultSet rs) throws SQLException {
        return new ImportInvoiceDetail(
            rs.getInt("detailId"),
            rs.getInt("invoiceId"),
            rs.getInt("partId"),
            rs.getInt("quantity"),
            rs.getDouble("importPrice"),
            rs.getDouble("lineTotal")
        );
    }
}
