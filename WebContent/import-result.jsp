<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Result</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(circle at 20% 20%, rgba(76, 175, 80, 0.08), transparent 35%),
                        radial-gradient(circle at 80% 10%, rgba(255, 255, 255, 0.8), transparent 30%),
                        radial-gradient(circle at 50% 80%, rgba(0, 0, 0, 0.06), transparent 40%),
                        linear-gradient(135deg, #ffffff 0%, #f5f5f5 100%);
            min-height: 100vh;
        }
        
        /* Navigation Bar */
        .navbar {
            background: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 0 40px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }
        
        .nav-logo {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
        }
        
        .nav-logo span {
            color: #8BC34A;
        }
        
        .nav-links {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        
        .nav-link {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            color: #424242;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .nav-link.search {
            background: #8BC34A;
            color: white;
        }
        
        .nav-link.search:hover {
            background: #7CB342;
        }
        
        .nav-link.home {
            background: #e0e0e0;
            color: #424242;
        }
        
        .nav-link.home:hover {
            background: #d0d0d0;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 16px;
            padding-left: 24px;
            border-left: 1px solid #e0e0e0;
            margin-left: 16px;
        }
        
        .user-name {
            color: #424242;
            font-weight: 500;
        }
        
        .btn-logout {
            padding: 8px 16px;
            background: #e0e0e0;
            color: #424242;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-logout:hover {
            background: #d0d0d0;
        }
        
        /* Main Content */
        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .alert {
            padding: 20px 24px;
            border-radius: 12px;
            margin-bottom: 32px;
            font-weight: 500;
            font-size: 16px;
        }
        
        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #8BC34A;
        }
        
        .alert-error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }
        
        .invoice-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            margin-bottom: 24px;
        }
        
        .invoice-header {
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 20px;
            margin-bottom: 24px;
        }
        
        .invoice-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .invoice-id {
            color: #757575;
            font-size: 14px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }
        
        .info-item {
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .info-label {
            font-size: 12px;
            color: #757575;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        
        .info-value {
            font-size: 16px;
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .total-amount {
            text-align: center;
            padding: 24px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 32px;
        }
        
        .total-amount .label {
            font-size: 14px;
            color: #757575;
            margin-bottom: 8px;
        }
        
        .total-amount .amount {
            font-size: 36px;
            color: #8BC34A;
            font-weight: 700;
        }
        
        .items-header {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }
        
        th {
            background: #1a1a1a;
            color: white;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
            color: #424242;
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        .total-row {
            background: #f8f9fa;
            font-weight: 700;
            font-size: 18px;
            color: #1a1a1a;
        }
        
        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 32px;
        }
        
        .btn {
            flex: 1;
            padding: 16px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            font-size: 15px;
        }
        
        .btn-primary {
            background: #1a1a1a;
            color: white;
        }
        
        .btn-primary:hover {
            background: #000;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }
        
        .btn-secondary {
            background: #e0e0e0;
            color: #424242;
        }
        
        .btn-secondary:hover {
            background: #d0d0d0;
        }
        
        @media (max-width: 768px) {
            .navbar {
                padding: 0 20px;
            }
            
            .nav-container {
                flex-wrap: wrap;
                height: auto;
                padding: 12px 0;
            }
            
            .user-info {
                width: 100%;
                justify-content: space-between;
                padding-left: 0;
                border-left: none;
                border-top: 1px solid #e0e0e0;
                margin-left: 0;
                margin-top: 12px;
                padding-top: 12px;
            }
            
            .invoice-card {
                padding: 24px 20px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="modal-overlay" style="display:flex;">
        <div class="modal">
            <div class="modal-header">
                <h2>${success ? 'Import Success' : 'Import Failed'}</h2>
                <button class="modal-close" onclick="window.location.href='import'">×</button>
            </div>
            <c:choose>
                <c:when test="${success}">
                    <p style="color:#2e7d32;">Order has been created and stock updated.</p>
                    <p><strong>Order #</strong> ${order.importId}</p>
                    <p><strong>Supplier:</strong> <c:out value="${supplier.name}"/></p>
                    <p><strong>Total:</strong> $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                    <div style="margin-top:16px; display:flex; gap:8px;">
                        <a href="import" class="btn btn-primary" style="flex:1;text-align:center;background:#8BC34A;color:#fff;padding:10px;border-radius:6px;text-decoration:none;">New Import</a>
                        <a href="search" class="btn btn-secondary" style="flex:1;text-align:center;background:#e0e0e0;color:#1a1a1a;padding:10px;border-radius:6px;text-decoration:none;">Go to Search</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color:#c62828;">✗ Import failed: <c:out value="${errorMessage}"/></p>
                    <div style="margin-top:16px; display:flex; gap:8px;">
                        <a href="import" class="btn btn-primary" style="flex:1;text-align:center;background:#8BC34A;color:#fff;padding:10px;border-radius:6px;text-decoration:none;">Try Again</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
