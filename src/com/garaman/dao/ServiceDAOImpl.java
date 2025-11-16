package com.garaman.dao;

import com.garaman.model.Service;
import com.garaman.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC Implementation: ServiceDAO
 */
public class ServiceDAOImpl implements ServiceDAO {
    
    @Override
    public List<Service> search(String keyword) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, code, name, description, base_price, duration_min, is_active " +
                "FROM service WHERE is_active = 1 AND (name LIKE ? OR code LIKE ?) ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Service service = new Service(
                    rs.getInt("service_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("base_price"),
                    rs.getInt("duration_min"),
                    rs.getBoolean("is_active")
                );
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    @Override
    public Service getById(int id) {
        String sql = "SELECT service_id, code, name, description, base_price, duration_min, is_active FROM service WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return new Service(
                    rs.getInt("service_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("base_price"),
                    rs.getInt("duration_min"),
                    rs.getBoolean("is_active")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Service> getAll() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, code, name, description, base_price, duration_min, is_active FROM service WHERE is_active = 1 ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Service service = new Service(
                    rs.getInt("service_id"),
                    rs.getString("code"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("base_price"),
                    rs.getInt("duration_min"),
                    rs.getBoolean("is_active")
                );
                services.add(service);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }
}
