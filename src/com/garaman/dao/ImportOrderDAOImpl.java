package com.garaman.dao;

import com.garaman.model.ImportOrder;
import com.garaman.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC Implementation: ImportOrderDAO
 */
public class ImportOrderDAOImpl implements ImportOrderDAO {

    @Override
    public int insert(ImportOrder order) {
        String sql = "INSERT INTO import_order (supplier_id, warehouse_staff_id, import_date, total_amount, status, note) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getSupplierId());
            stmt.setInt(2, order.getWarehouseStaffId());
            stmt.setTimestamp(3, new Timestamp(order.getImportDate().getTime()));
            stmt.setDouble(4, order.getTotalAmount());
            stmt.setString(5, order.getStatus());
            stmt.setString(6, order.getNote());

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
    public ImportOrder getById(int id) {
        String sql = "SELECT import_id, supplier_id, warehouse_staff_id, import_date, total_amount, status, note FROM import_order WHERE import_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new ImportOrder(
                        rs.getInt("import_id"),
                        rs.getInt("supplier_id"),
                        rs.getInt("warehouse_staff_id"),
                        rs.getTimestamp("import_date"),
                        rs.getDouble("total_amount"),
                        rs.getString("status"),
                        rs.getString("note"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public void updateTotalAmount(int orderId, double totalAmount) {
        String sql = "UPDATE import_order SET total_amount = ? WHERE import_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDouble(1, totalAmount);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateStatus(int orderId, String status) {
        String sql = "UPDATE import_order SET status = ? WHERE import_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<ImportOrder> getAll() {
        List<ImportOrder> orders = new ArrayList<>();
        String sql = "SELECT import_id, supplier_id, warehouse_staff_id, import_date, total_amount, status, note " +
                "FROM import_order ORDER BY import_date DESC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                ImportOrder order = new ImportOrder(
                        rs.getInt("import_id"),
                        rs.getInt("supplier_id"),
                        rs.getInt("warehouse_staff_id"),
                        rs.getTimestamp("import_date"),
                        rs.getDouble("total_amount"),
                        rs.getString("status"),
                        rs.getString("note"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }
}
