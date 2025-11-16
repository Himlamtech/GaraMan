<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(circle at 15% 20%, rgba(76, 175, 80, 0.08), transparent 35%),
                        radial-gradient(circle at 70% 10%, rgba(0, 0, 0, 0.04), transparent 30%),
                        radial-gradient(circle at 45% 75%, rgba(0, 0, 0, 0.05), transparent 40%),
                        radial-gradient(circle at 85% 70%, rgba(255, 255, 255, 0.7), transparent 30%),
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
        
        .nav-link:hover {
            background: #f5f5f5;
            color: #1a1a1a;
        }
        
        .nav-link.active {
            background: #8BC34A;
            color: white;
        }
        
        .nav-link.import {
            background: #1a1a1a;
            color: white;
        }
        
        .nav-link.import:hover {
            background: #000;
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
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .search-info {
            background: white;
            padding: 20px 24px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            margin-bottom: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .search-info span {
            font-size: 16px;
            color: #424242;
        }
        
        .search-info strong {
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .btn-new-search {
            padding: 10px 20px;
            background: #8BC34A;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-new-search:hover {
            background: #7CB342;
        }
        
        .section {
            margin-bottom: 40px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .count-badge {
            background: #e0e0e0;
            color: #424242;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        table {
            width: 100%;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }

        /* Modal */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 999;
        }

        .modal {
            background: #fff;
            border-radius: 16px;
            padding: 28px;
            width: min(600px, 90%);
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.18);
            position: relative;
        }

        .modal-close {
            position: absolute;
            right: 14px;
            top: 10px;
            border: none;
            background: transparent;
            font-size: 22px;
            cursor: pointer;
            color: #555;
        }

        .modal h3 {
            margin-bottom: 12px;
            font-size: 22px;
            color: #1a1a1a;
        }

        .modal p {
            margin: 6px 0;
            color: #424242;
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
        
        tbody tr {
            transition: all 0.3s ease;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
        }
        
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #757575;
            font-size: 16px;
            background: white;
            border-radius: 12px;
        }
        
        .price {
            color: #8BC34A;
            font-weight: 700;
            font-size: 16px;
        }
        
        .stock {
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-left: 8px;
        }
        
        .badge-available {
            background: #e8f5e9;
            color: #2e7d32;
        }
        
        .badge-low {
            background: #ffebee;
            color: #c62828;
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
            
            .search-info {
                flex-direction: column;
                gap: 16px;
                text-align: center;
            }
            
            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">Garage <span>Manager</span></div>
            <div class="nav-links">
                <a href="search" class="nav-link active">🔍 Search</a>
                <a href="import" class="nav-link import">📦 Import Parts</a>
                <div class="user-info">
                    <span class="user-name">👤 ${sessionScope.fullName}</span>
                    <form action="logout" method="get" style="display: inline;">
                        <button type="submit" class="btn-logout">Logout</button>
                    </form>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="search-info">
            <span>Search keyword: <strong>"<c:out value="${keyword}"/>"</strong></span>
            <a href="search" class="btn-new-search">New Search</a>
        </div>
        
        <!-- Services Results -->
        <div class="section">
            <div class="section-header">
                <h2>Services</h2>
                <span class="count-badge">${services.size()} found</span>
            </div>
            <c:choose>
                <c:when test="${not empty services}">
                    <table>
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Service Name</th>
                                <th>Description</th>
                                <th>Duration (min)</th>
                                <th>Base Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${services}">
                                <tr>
                                    <td><c:out value="${service.code}"/></td>
                                    <td><strong><a href="#" class="service-link"
                                        data-code="${service.code}"
                                        data-name="${service.name}"
                                        data-description="${service.description}"
                                        data-duration="${service.durationMin}"
                                        data-price="${service.basePrice}">
                                        <c:out value="${service.name}"/></a></strong></td>
                                    <td><c:out value="${service.description}"/></td>
                                    <td>${service.durationMin}</td>
                                    <td class="price">$<fmt:formatNumber value="${service.basePrice}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-results">No services found</div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Parts Results -->
        <div class="section">
            <div class="section-header">
                <h2>Spare Parts</h2>
                <span class="count-badge">${parts.size()} found</span>
            </div>
            <c:choose>
                <c:when test="${not empty parts}">
                    <table>
                        <thead>
                            <tr>
                                <th>Code</th>
                                <th>Part Name</th>
                                <th>Unit</th>
                                <th>Stock</th>
                                <th>Unit Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="part" items="${parts}">
                                <tr>
                                    <td><c:out value="${part.code}"/></td>
                                    <td><strong><c:out value="${part.name}"/></strong></td>
                                    <td><c:out value="${part.unit}"/></td>
                                    <td>
                                        <span class="stock">${part.stockQty}</span>
                                        <c:choose>
                                            <c:when test="${part.stockQty > part.minStockQty}">
                                                <span class="badge badge-available">Available</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-low">Low Stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="price">$<fmt:formatNumber value="${part.unitPrice}" pattern="#,##0.00"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-results">No parts found</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="modal-overlay" id="serviceModal">
        <div class="modal" role="dialog" aria-modal="true">
            <button class="modal-close" id="serviceModalClose" aria-label="Close">×</button>
            <h3 id="modalServiceName">Service Detail</h3>
            <p><strong>Code:</strong> <span id="modalServiceCode"></span></p>
            <p><strong>Description:</strong> <span id="modalServiceDesc"></span></p>
            <p><strong>Duration:</strong> <span id="modalServiceDuration"></span> minutes</p>
            <p><strong>Base Price:</strong> $<span id="modalServicePrice"></span></p>
        </div>
    </div>

    <script>
        const modal = document.getElementById('serviceModal');
        const modalClose = document.getElementById('serviceModalClose');
        const nameEl = document.getElementById('modalServiceName');
        const codeEl = document.getElementById('modalServiceCode');
        const descEl = document.getElementById('modalServiceDesc');
        const durEl = document.getElementById('modalServiceDuration');
        const priceEl = document.getElementById('modalServicePrice');

        function closeModal() {
            modal.style.display = 'none';
        }

        modalClose.addEventListener('click', closeModal);
        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });

        document.querySelectorAll('.service-link').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                nameEl.textContent = link.dataset.name;
                codeEl.textContent = link.dataset.code;
                descEl.textContent = link.dataset.description;
                durEl.textContent = link.dataset.duration;
                priceEl.textContent = Number(link.dataset.price).toFixed(2);
                modal.style.display = 'flex';
            });
        });
    </script>
</body>
</html>
