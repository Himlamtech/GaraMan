package com.garaman.dao;

import com.garaman.entity.SparePart;
import java.util.List;

public interface SparePartDAO {
    List<SparePart> searchByName(String keyword);
    SparePart getById(int partId);
    List<SparePart> getAll();
    int insert(SparePart part);
    void updateStock(int partId, int quantity);
    void updateUnitPrice(int partId, double price);
}
