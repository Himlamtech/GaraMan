<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garage Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 900px;
            width: 100%;
            padding: 48px;
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        h1 {
            font-size: 36px;
            font-weight: 700;
            color: #1a202c;
            text-align: center;
            margin-bottom: 48px;
            letter-spacing: -0.5px;
        }
        
        .modules {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 24px;
        }
        
        .module-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 32px;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }
        
        .module-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 40px rgba(102, 126, 234, 0.4);
        }
        
        .module-card h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        
        .module-card p {
            font-size: 15px;
            line-height: 1.6;
            opacity: 0.95;
            margin-bottom: 24px;
        }
        
        .btn {
            display: inline-block;
            background: white;
            color: #667eea;
            padding: 12px 28px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        .btn:hover {
            background: #f7fafc;
            transform: scale(1.05);
        }
        
        .module-card.secondary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .module-card.secondary:hover {
            box-shadow: 0 12px 40px rgba(240, 147, 251, 0.4);
        }
        
        .module-card.secondary .btn {
            color: #f5576c;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 32px 24px;
            }
            
            h1 {
                font-size: 28px;
                margin-bottom: 32px;
            }
            
            .modules {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Garage Management System</h1>
        
        <div class="modules">
            <div class="module-card" onclick="location.href='search'">
                <h2>Search Services & Parts</h2>
                <p>Find service or spare part information quickly by keyword search.</p>
                <a href="search" class="btn">Go to Search</a>
            </div>
            
            <div class="module-card secondary" onclick="location.href='import'">
                <h2>Import Parts</h2>
                <p>Import spare parts from suppliers and manage inventory invoices.</p>
                <a href="import" class="btn">Go to Import</a>
            </div>
        </div>
    </div>
</body>
</html>

