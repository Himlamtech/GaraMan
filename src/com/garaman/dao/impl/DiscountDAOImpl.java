package com.garaman.dao.impl;

import com.garaman.dao.DiscountDAO;
import com.garaman.entity.Discount;
import com.garaman.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DiscountDAOImpl implements DiscountDAO {

    @Override
    public List<Discount> getAllActive() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM tbl_discount WHERE status = 1 ORDER BY discountName";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Discount discount = mapResultSetToDiscount(rs);
                // Only include if actually active (check dates and usage)
                if (discount.isActive()) {
                    discounts.add(discount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    @Override
    public Discount getById(int discountId) {
        String sql = "SELECT * FROM tbl_discount WHERE discountId = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, discountId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToDiscount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Discount> getAll() {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM tbl_discount ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                discounts.add(mapResultSetToDiscount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    @Override
    public int insert(Discount discount) {
        String sql = "INSERT INTO tbl_discount (discountName, discountType, discountValue, description, " +
                "maxUsageCount, usageCount, startDate, endDate, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, discount.getDiscountName());
            stmt.setString(2, discount.getDiscountType());
            stmt.setDouble(3, discount.getDiscountValue());
            stmt.setString(4, discount.getDescription());
            stmt.setInt(5, discount.getMaxUsageCount());
            stmt.setInt(6, discount.getUsageCount());

            if (discount.getStartDate() != null) {
                stmt.setTimestamp(7, new Timestamp(discount.getStartDate().getTime()));
            } else {
                stmt.setNull(7, Types.TIMESTAMP);
            }

            if (discount.getEndDate() != null) {
                stmt.setTimestamp(8, new Timestamp(discount.getEndDate().getTime()));
            } else {
                stmt.setNull(8, Types.TIMESTAMP);
            }

            stmt.setInt(9, discount.getStatus());

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
    public boolean update(Discount discount) {
        String sql = "UPDATE tbl_discount SET discountName = ?, discountType = ?, discountValue = ?, " +
                "description = ?, maxUsageCount = ?, usageCount = ?, startDate = ?, endDate = ?, status = ? " +
                "WHERE discountId = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, discount.getDiscountName());
            stmt.setString(2, discount.getDiscountType());
            stmt.setDouble(3, discount.getDiscountValue());
            stmt.setString(4, discount.getDescription());
            stmt.setInt(5, discount.getMaxUsageCount());
            stmt.setInt(6, discount.getUsageCount());

            if (discount.getStartDate() != null) {
                stmt.setTimestamp(7, new Timestamp(discount.getStartDate().getTime()));
            } else {
                stmt.setNull(7, Types.TIMESTAMP);
            }

            if (discount.getEndDate() != null) {
                stmt.setTimestamp(8, new Timestamp(discount.getEndDate().getTime()));
            } else {
                stmt.setNull(8, Types.TIMESTAMP);
            }

            stmt.setInt(9, discount.getStatus());
            stmt.setInt(10, discount.getDiscountId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean incrementUsageCount(int discountId) {
        String sql = "UPDATE tbl_discount SET usageCount = usageCount + 1 WHERE discountId = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, discountId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int discountId) {
        String sql = "UPDATE tbl_discount SET status = 0 WHERE discountId = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, discountId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
        return new Discount(
                rs.getInt("discountId"),
                rs.getString("discountName"),
                rs.getString("discountType"),
                rs.getDouble("discountValue"),
                rs.getString("description"),
                rs.getInt("maxUsageCount"),
                rs.getInt("usageCount"),
                rs.getTimestamp("startDate"),
                rs.getTimestamp("endDate"),
                rs.getInt("status"),
                rs.getTimestamp("createdAt"));
    }
}
