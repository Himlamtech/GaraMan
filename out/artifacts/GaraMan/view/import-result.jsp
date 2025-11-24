<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.garaman.service.ImportService" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import Result - Garage Manager</title>
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

        <!-- Result Content -->
        <main class="result-container">
            <div class="result-card">
                <c:if test="${importResult.success}">
                    <div class="success-alert">
                        <h2>Import Successful!</h2>
                        <p>${importResult.message}</p>
                    </div>

                    <div class="invoice-details">
                        <h3>Import Invoice #${importResult.invoiceId}</h3>
                        
                        <table class="invoice-table">
                            <thead>
                                <tr>
                                    <th>Part ID</th>
                                    <th>Quantity</th>
                                    <th>Import Price</th>
                                    <th>Line Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${invoiceDetails}" var="detail">
                                    <tr>
                                        <td>${detail.partId}</td>
                                        <td>${detail.quantity}</td>
                                        <td>$${String.format("%.2f", detail.importPrice)}</td>
                                        <td>$${String.format("%.2f", detail.lineTotal)}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="invoice-total">
                            <strong>Total Amount: $${String.format("%.2f", importResult.totalAmount)}</strong>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <button class="btn btn-primary" onclick="window.print()">Print Invoice</button>
                        <a href="${pageContext.request.contextPath}/import" class="btn btn-secondary">New Import</a>
                    </div>
                </c:if>

                <c:if test="${not importResult.success}">
                    <div class="error-alert">
                        <h2>Import Failed</h2>
                        <p>${importResult.message}</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/import" class="btn btn-primary">Try Again</a>
                </c:if>
            </div>
        </main>
    </div>
</body>
</html>
