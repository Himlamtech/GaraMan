package com.garaman.dao;

import com.garaman.entity.Discount;
import java.util.List;

public interface DiscountDAO {
    List<Discount> getAllActive();

    Discount getById(int discountId);

    List<Discount> getAll();

    int insert(Discount discount);

    boolean update(Discount discount);

    boolean incrementUsageCount(int discountId);

    boolean delete(int discountId);
}
