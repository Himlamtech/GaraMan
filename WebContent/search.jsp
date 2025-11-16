<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Services & Parts</title>
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
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
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
                max-width: 900px;
                margin: 60px auto;
                padding: 0 20px;
            }

            .page-header {
                text-align: center;
                margin-bottom: 48px;
            }

            .page-header h1 {
                font-size: 42px;
                font-weight: 700;
                color: #1a1a1a;
                margin-bottom: 12px;
            }

            .page-header p {
                font-size: 18px;
                color: #757575;
            }

            .search-card {
                background: white;
                border-radius: 16px;
                padding: 48px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }

            .form-group {
                margin-bottom: 32px;
            }

            label {
                display: block;
                font-weight: 600;
                color: #424242;
                margin-bottom: 12px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            input[type="text"] {
                width: 100%;
                padding: 16px 20px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s ease;
                font-family: inherit;
            }

            input[type="text"]:focus {
                outline: none;
                border-color: #1a1a1a;
                box-shadow: 0 0 0 3px rgba(26, 26, 26, 0.05);
            }

            input.error {
                border-color: #f44336;
            }

            input.error:focus {
                border-color: #f44336;
                box-shadow: 0 0 0 4px rgba(244, 67, 54, 0.1);
            }

            .input-error {
                color: #f44336;
                font-size: 14px;
                margin-top: 8px;
                display: none;
            }

            .btn-search {
                width: 100%;
                padding: 18px;
                background: #1a1a1a;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .btn-search:hover {
                background: #000;
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            }

            .btn-search:active {
                transform: translateY(0);
            }

            .info-box {
                background: #f5f5f5;
                border-left: 4px solid #1a1a1a;
                padding: 24px;
                border-radius: 8px;
                margin-top: 32px;
            }

            .info-box h3 {
                color: #424242;
                margin-bottom: 12px;
                font-size: 16px;
                font-weight: 600;
            }

            .info-box ul {
                list-style: none;
                color: #616161;
                line-height: 1.8;
            }

            .info-box ul li:before {
                content: "•";
                color: #1a1a1a;
                font-weight: bold;
                display: inline-block;
                width: 24px;
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

                .container {
                    margin: 40px auto;
                }

                .page-header h1 {
                    font-size: 32px;
                }

                .search-card {
                    padding: 32px 24px;
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
            <div class="page-header">
                <h1>Search Services & Parts</h1>
                <p>Find services or spare parts quickly by keyword</p>
            </div>

            <div class="search-card">
                <form action="search" method="post" id="searchForm" onsubmit="return validateSearch()">
                    <div class="form-group">
                        <label for="keyword">Search Keyword</label>
                        <input type="text" id="keyword" name="keyword"
                            placeholder="Enter service or part name (e.g., oil, brake, filter)..." autofocus>
                        <div class="input-error" id="keywordError">Please enter a search keyword</div>
                    </div>
                    <div class="form-group">
                        <label>Type</label>
                        <div class="type-selection" style="display:flex;gap:16px;">
                            <label><input type="radio" name="type" value="all" checked> All</label>
                            <label><input type="radio" name="type" value="service"> Services</label>
                            <label><input type="radio" name="type" value="part"> Spare Parts</label>
                        </div>
                    </div>

                    <button type="submit" class="btn-search">Search Now</button>
                </form>

                <div class="info-box">
                    <h3>Search Tips:</h3>
                    <ul>
                        <li>Enter any keyword related to services or parts</li>
                        <li>System searches across all services and spare parts</li>
                        <li>Results show real-time pricing and stock availability</li>
                        <li>Minimum 2 characters required for search</li>
                    </ul>
                </div>
            </div>
        </div>

        <script>
            function validateSearch() {
                const keyword = document.getElementById('keyword');
                const error = document.getElementById('keywordError');

                keyword.classList.remove('error');
                error.style.display = 'none';
                return true;
            }

            document.getElementById('keyword').addEventListener('input', function () {
                this.classList.remove('error');
                document.getElementById('keywordError').style.display = 'none';
            });
        </script>
    </body>

    </html>
