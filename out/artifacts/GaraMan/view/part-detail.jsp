<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Part Details - Garage Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <h1><span class="brand">Garage</span> <span class="accent">Manager</span></h1>
                <div class="header-buttons">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">Search</a>
                    <a href="${pageContext.request.contextPath}/import" class="btn btn-dark">Import Parts</a>
                </div>
            </div>
        </header>

        <!-- Detail Content -->
        <main class="detail-container">
            <a href="${pageContext.request.contextPath}/search" class="back-link">← Back to Search</a>

            <div class="detail-card">
                <h2>${part.partName}</h2>
                
                <div class="detail-info">
                    <div class="info-section">
                        <label>Description</label>
                        <p>${part.description}</p>
                    </div>

                    <div class="info-section">
                        <label>Unit Price</label>
                        <p class="highlight-price">$${String.format("%.2f", part.unitPrice)}</p>
                    </div>

                    <div class="info-section">
                        <label>Current Stock</label>
                        <p class="stock-info">
                            <c:if test="${part.stock > 0}">
                                <span class="in-stock">${part.stock} units available</span>
                            </c:if>
                            <c:if test="${part.stock == 0}">
                                <span class="out-of-stock">Out of Stock</span>
                            </c:if>
                        </p>
                    </div>

                    <div class="info-section">
                        <label>Status</label>
                        <p class="status-badge"><c:if test="${part.status == 1}">Active</c:if><c:if test="${part.status != 1}">Inactive</c:if></p>
                    </div>
                </div>

                <button class="btn btn-primary" onclick="alert('Order feature coming soon!')">Order This Part</button>
            </div>
        </main>
    </div>
</body>
</html>
