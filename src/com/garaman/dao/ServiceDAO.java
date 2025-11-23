package com.garaman.dao;

import com.garaman.entity.Service;
import java.util.List;

public interface ServiceDAO {
    List<Service> searchByName(String keyword);
    Service getById(int serviceId);
    List<Service> getAll();
}
