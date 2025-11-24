<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Details - Garage Manager</title>
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
                <h2>${service.serviceName}</h2>
                
                <div class="detail-info">
                    <div class="info-section">
                        <label>Description</label>
                        <p>${service.description}</p>
                    </div>

                    <div class="info-section">
                        <label>Service Price</label>
                        <p class="highlight-price">$${String.format("%.2f", service.unitPrice)}</p>
                    </div>

                    <div class="info-section">
                        <label>Estimated Time</label>
                        <p>${service.estimatedTime} minutes</p>
                    </div>

                    <div class="info-section">
                        <label>Status</label>
                        <p class="status-badge"><c:if test="${service.status == 1}">Available</c:if><c:if test="${service.status != 1}">Unavailable</c:if></p>
                    </div>
                </div>

                <button class="btn btn-primary" onclick="alert('Booking feature coming soon!')">Book This Service</button>
            </div>
        </main>
    </div>
</body>
</html>
