package com.garaman.dao;

import com.garaman.entity.ImportInvoiceDetail;
import java.util.List;

public interface ImportInvoiceDetailDAO {
    int insert(ImportInvoiceDetail detail);
    List<ImportInvoiceDetail> getByInvoiceId(int invoiceId);
}
