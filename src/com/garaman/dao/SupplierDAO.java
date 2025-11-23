package com.garaman.dao;

import com.garaman.entity.Supplier;
import java.util.List;

public interface SupplierDAO {
    List<Supplier> getAll();
    Supplier getById(int supplierId);
    int insert(Supplier supplier);
}
