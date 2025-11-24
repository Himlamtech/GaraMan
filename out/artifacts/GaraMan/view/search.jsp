<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="com.garaman.service.SearchService" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Search Services & Parts - Garage Manager</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
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

                <!-- Main Content -->
                <main class="search-container">
                    <div class="search-header">
                        <h2>Search Services & Parts</h2>
                        <p>Find services or spare parts quickly by keyword</p>
                    </div>

                    <!-- Search Form -->
                    <div class="search-box">
                        <form method="GET" action="${pageContext.request.contextPath}/search" class="search-form">
                            <div class="form-group">
                                <label>SEARCH KEYWORD</label>
                                <input type="text" name="keyword"
                                    placeholder="Enter service or part name (e.g., oil, brake, filter)..."
                                    value="${keyword}" class="search-input">
                            </div>

                            <div class="form-group">
                                <label>TYPE</label>
                                <div class="radio-group">
                                    <label class="radio">
                                        <input type="radio" name="type" value="all" <c:if
                                            test="${empty type || type == 'all'}">checked</c:if>>
                                        <span>ALL</span>
                                    </label>
                                    <label class="radio">
                                        <input type="radio" name="type" value="services" <c:if
                                            test="${type == 'services'}">checked</c:if>>
                                        <span>SERVICES</span>
                                    </label>
                                    <label class="radio">
                                        <input type="radio" name="type" value="parts" <c:if
                                            test="${type == 'parts'}">checked</c:if>>
                                        <span>SPARE PARTS</span>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-search">SEARCH NOW</button>
                        </form>

                        <!-- Search Tips -->
                        <div class="search-tips">
                            <strong>Search Tips:</strong>
                            <ul>
                                <li>Enter any keyword related to services or parts</li>
                                <li>System searches across all services and spare parts</li>
                                <li>Results show real-time pricing and stock availability</li>
                                <li>Minimum 2 characters required for search</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Search Results -->
                    <c:if test="${not empty searchResults}">
                        <div class="results-section">
                            <h3>Search Results for "
                                <c:out value='${keyword}' />"
                            </h3>

                            <!-- Services Results -->
                            <c:if test="${not empty searchResults.services}">
                                <div class="results-category">
                                    <h4>Services</h4>
                                    <table class="results-grid">
                                        <thead>
                                            <tr>
                                                <th class="col-code">Code</th>
                                                <th class="col-name">Service Name</th>
                                                <th class="col-description">Description</th>
                                                <th class="col-duration">Duration (Min)</th>
                                                <th class="col-price">Base Price</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${searchResults.services}" var="service">
                                                <tr>
                                                    <td class="col-code">SV-${String.format("%03d", service.serviceId)}
                                                    </td>
                                                    <td class="col-name"><a href="javascript:void(0)"
                                                            onclick="showServiceDetail(${service.serviceId}, '${service.serviceName}', '${service.description}', ${service.estimatedTime}, ${service.unitPrice})">${service.serviceName}</a>
                                                    </td>
                                                    <td class="col-description">${service.description}</td>
                                                    <td class="col-duration">${service.estimatedTime}</td>
                                                    <td class="col-price">$${String.format("%.2f", service.unitPrice)}
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>

                            <!-- Parts Results -->
                            <c:if test="${not empty searchResults.spareParts}">
                                <div class="results-category">
                                    <h4>Spare Parts</h4>
                                    <table class="results-grid">
                                        <thead>
                                            <tr>
                                                <th class="col-code">Code</th>
                                                <th class="col-name">Part Name</th>
                                                <th class="col-description">Description</th>
                                                <th class="col-stock">Stock</th>
                                                <th class="col-price">Unit Price</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${searchResults.spareParts}" var="part">
                                                <tr>
                                                    <td class="col-code">PT-${String.format("%03d", part.partId)}</td>
                                                    <td class="col-name"><a href="javascript:void(0)"
                                                            onclick="showPartDetail(${part.partId}, '${part.partName}', '${part.description}', ${part.stock}, ${part.unitPrice})">${part.partName}</a>
                                                    </td>
                                                    <td class="col-description">${part.description}</td>
                                                    <td class="col-stock">
                                                        <c:choose>
                                                            <c:when test="${part.stock > 0}">
                                                                <span class="stock-badge stock-in">${part.stock}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="stock-badge stock-out">Out</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="col-price">$${String.format("%.2f", part.unitPrice)}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>

                            <!-- No Results Message -->
                            <c:if test="${searchResults.isEmpty()}">
                                <div class="no-results">
                                    <p>No services or parts found matching "
                                        <c:out value='${keyword}' />"
                                    </p>
                                    <p>Try using different keywords</p>
                                </div>
                            </c:if>
                        </div>
                    </c:if>
                </main>

                <!-- Service Detail Modal -->
                <div id="serviceDetailModal" class="modal">
                    <div class="modal-content detail-modal">
                        <span class="modal-close" onclick="closeServiceDetail()">&times;</span>
                        <div class="modal-body">
                            <h2 id="serviceDetailName"></h2>
                            <div class="detail-info">
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Code:</label>
                                    <span class="detail-info-value" id="serviceDetailCode"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Description:</label>
                                    <span class="detail-info-value" id="serviceDetailDescription"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Duration:</label>
                                    <span class="detail-info-value" id="serviceDetailDuration"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Base Price:</label>
                                    <span class="detail-info-value price" id="serviceDetailPrice"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Part Detail Modal -->
                <div id="partDetailModal" class="modal">
                    <div class="modal-content detail-modal">
                        <span class="modal-close" onclick="closePartDetail()">&times;</span>
                        <div class="modal-body">
                            <h2 id="partDetailName"></h2>
                            <div class="detail-info">
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Code:</label>
                                    <span class="detail-info-value" id="partDetailCode"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Description:</label>
                                    <span class="detail-info-value" id="partDetailDescription"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Stock:</label>
                                    <span class="detail-info-value" id="partDetailStock"></span>
                                </div>
                                <div class="detail-info-row">
                                    <label class="detail-info-label">Unit Price:</label>
                                    <span class="detail-info-value price" id="partDetailPrice"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // Service Detail Modal Functions
                    function showServiceDetail(serviceId, serviceName, description, estimatedTime, unitPrice) {
                        document.getElementById('serviceDetailName').textContent = serviceName;
                        document.getElementById('serviceDetailCode').textContent = 'SV-' + String(serviceId).padStart(3, '0');
                        document.getElementById('serviceDetailDescription').textContent = description;
                        document.getElementById('serviceDetailDuration').textContent = estimatedTime + ' minutes';
                        document.getElementById('serviceDetailPrice').textContent = '$' + parseFloat(unitPrice).toFixed(2);

                        const modal = document.getElementById('serviceDetailModal');
                        modal.classList.add('show');
                    }

                    function closeServiceDetail() {
                        const modal = document.getElementById('serviceDetailModal');
                        modal.classList.remove('show');
                    }

                    // Part Detail Modal Functions
                    function showPartDetail(partId, partName, description, stock, unitPrice) {
                        document.getElementById('partDetailName').textContent = partName;
                        document.getElementById('partDetailCode').textContent = 'PT-' + String(partId).padStart(3, '0');
                        document.getElementById('partDetailDescription').textContent = description;
                        document.getElementById('partDetailStock').textContent = stock > 0 ? stock + ' units' : 'Out of Stock';
                        document.getElementById('partDetailPrice').textContent = '$' + parseFloat(unitPrice).toFixed(2);

                        const modal = document.getElementById('partDetailModal');
                        modal.classList.add('show');
                    }

                    function closePartDetail() {
                        const modal = document.getElementById('partDetailModal');
                        modal.classList.remove('show');
                    }

                    // Close modals when clicking outside
                    window.onclick = function (event) {
                        const serviceModal = document.getElementById('serviceDetailModal');
                        const partModal = document.getElementById('partDetailModal');

                        if (event.target === serviceModal) {
                            serviceModal.classList.remove('show');
                        }
                        if (event.target === partModal) {
                            partModal.classList.remove('show');
                        }
                    }
                </script>
            </body>

            </html>