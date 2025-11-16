<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Part Detail</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: radial-gradient(circle at 15% 20%, rgba(76, 175, 80, 0.08), transparent 35%),
                        radial-gradient(circle at 70% 10%, rgba(0, 0, 0, 0.04), transparent 30%),
                        radial-gradient(circle at 45% 75%, rgba(0, 0, 0, 0.05), transparent 40%),
                        radial-gradient(circle at 85% 70%, rgba(255, 255, 255, 0.7), transparent 30%),
                        linear-gradient(135deg, #ffffff 0%, #f5f5f5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 12px 32px rgba(0,0,0,0.12);
            padding: 28px;
            width: min(680px, 100%);
        }
        h1 { margin-bottom: 16px; color: #1a1a1a; }
        p { margin: 8px 0; color: #424242; }
        a { color: #1a1a1a; text-decoration: none; font-weight: 600; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Part Detail</h1>
        <c:if test="${not empty part}">
            <p><strong>Code:</strong> <c:out value="${part.code}"/></p>
            <p><strong>Name:</strong> <c:out value="${part.name}"/></p>
            <p><strong>Description:</strong> <c:out value="${part.description}"/></p>
            <p><strong>Unit:</strong> <c:out value="${part.unit}"/></p>
            <p><strong>Stock:</strong> ${part.stockQty} (Min: ${part.minStockQty})</p>
            <p><strong>Unit Price:</strong> $<fmt:formatNumber value="${part.unitPrice}" pattern="#,##0.00"/></p>
        </c:if>
        <p style="margin-top:16px;"><a href="search">Back to search</a></p>
    </div>
</body>
</html>
