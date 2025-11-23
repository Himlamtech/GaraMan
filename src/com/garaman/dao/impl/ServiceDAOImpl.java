package com.garaman.dao.impl;

import com.garaman.dao.ServiceDAO;
import com.garaman.entity.Service;
import com.garaman.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ServiceDAOImpl implements ServiceDAO {

    @Override
    public List<Service> searchByName(String keyword) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM tbl_service WHERE serviceName LIKE ? AND status = 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    @Override
    public Service getById(int serviceId) {
        String sql = "SELECT * FROM tbl_service WHERE serviceId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Service> getAll() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM tbl_service WHERE status = 1";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                services.add(mapResultSetToService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        return new Service(
            rs.getInt("serviceId"),
            rs.getString("serviceName"),
            rs.getString("description"),
            rs.getDouble("unitPrice"),
            rs.getInt("estimatedTime"),
            rs.getInt("status")
        );
    }
}
