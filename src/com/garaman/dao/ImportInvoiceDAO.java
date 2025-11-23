package com.garaman.dao;

import com.garaman.entity.ImportInvoice;

public interface ImportInvoiceDAO {
    int insert(ImportInvoice invoice);
    void updateTotalAmount(int invoiceId, double amount);
}
