<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Garage Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            background: #f8f9fa;
        }
        
        /* Left Section - 70% */
        .left-section {
            flex: 0 0 70%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 80px;
            position: relative;
            overflow: hidden;
        }
        
        .left-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 600px;
            height: 600px;
            background: rgba(139, 195, 74, 0.1);
            border-radius: 50%;
        }
        
        .left-section::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -10%;
            width: 500px;
            height: 500px;
            background: rgba(244, 67, 54, 0.1);
            border-radius: 50%;
        }
        
        .content {
            position: relative;
            z-index: 1;
            max-width: 600px;
        }
        
        .logo {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 24px;
            letter-spacing: -1px;
        }
        
        .logo span {
            background: linear-gradient(135deg, #8BC34A 0%, #4CAF50 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .tagline {
            font-size: 24px;
            color: #b0b0b0;
            margin-bottom: 48px;
            font-weight: 300;
        }
        
        .features {
            list-style: none;
        }
        
        .feature-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 32px;
            animation: fadeInUp 0.6s ease-out forwards;
            opacity: 0;
        }
        
        .feature-item:nth-child(1) { animation-delay: 0.2s; }
        .feature-item:nth-child(2) { animation-delay: 0.4s; }
        .feature-item:nth-child(3) { animation-delay: 0.6s; }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .feature-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-right: 20px;
            flex-shrink: 0;
        }
        
        .feature-icon.green {
            background: linear-gradient(135deg, #8BC34A 0%, #4CAF50 100%);
        }
        
        .feature-icon.red {
            background: linear-gradient(135deg, #FF6B6B 0%, #F44336 100%);
        }
        
        .feature-icon.gray {
            background: linear-gradient(135deg, #78909C 0%, #607D8B 100%);
        }
        
        .feature-content h3 {
            font-size: 20px;
            margin-bottom: 8px;
            font-weight: 600;
        }
        
        .feature-content p {
            color: #9e9e9e;
            line-height: 1.6;
            font-size: 15px;
        }
        
        /* Right Section - 30% */
        .right-section {
            flex: 0 0 30%;
            background: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 40px;
            box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
        }
        
        .auth-container {
            width: 100%;
            max-width: 400px;
        }
        
        .auth-header {
            margin-bottom: 40px;
        }
        
        .auth-header h2 {
            font-size: 32px;
            color: #1a1a1a;
            margin-bottom: 8px;
            font-weight: 700;
        }
        
        .auth-header p {
            color: #757575;
            font-size: 15px;
        }
        
        .error-message {
            background: #ffebee;
            border-left: 4px solid #f44336;
            padding: 16px;
            margin-bottom: 24px;
            border-radius: 4px;
            color: #c62828;
            font-size: 14px;
            animation: shake 0.5s;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .form-group {
            margin-bottom: 24px;
        }
        
        label {
            display: block;
            color: #424242;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: inherit;
        }
        
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #8BC34A;
            box-shadow: 0 0 0 4px rgba(139, 195, 74, 0.1);
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
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }
        
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #8BC34A 0%, #4CAF50 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(76, 175, 80, 0.3);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        @media (max-width: 1200px) {
            .left-section {
                padding: 60px 40px;
            }
            
            .logo {
                font-size: 36px;
            }
        }
        
        @media (max-width: 968px) {
            body {
                flex-direction: column;
            }
            
            .left-section {
                flex: 0 0 auto;
                min-height: 40vh;
                padding: 40px 24px;
            }
            
            .right-section {
                flex: 1;
                padding: 40px 24px;
            }
            
            .logo {
                font-size: 32px;
            }
            
            .tagline {
                font-size: 18px;
                margin-bottom: 32px;
            }
            
            .feature-item {
                margin-bottom: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="left-section">
        <div class="content">
            <h1 class="logo">Garage <span>Management</span></h1>
            <p class="tagline">Professional Auto Service & Parts Management</p>
            
            <ul class="features">
                <li class="feature-item">
                    <div class="feature-icon green">🔍</div>
                    <div class="feature-content">
                        <h3>Smart Search</h3>
                        <p>Quickly find services and spare parts with our powerful search system. Real-time inventory tracking and pricing.</p>
                    </div>
                </li>
                <li class="feature-item">
                    <div class="feature-icon red">📦</div>
                    <div class="feature-content">
                        <h3>Inventory Management</h3>
                        <p>Efficiently manage your parts inventory, track suppliers, and handle import operations seamlessly.</p>
                    </div>
                </li>
                <li class="feature-item">
                    <div class="feature-icon gray">📊</div>
                    <div class="feature-content">
                        <h3>Professional Dashboard</h3>
                        <p>Access comprehensive analytics and reporting tools to optimize your garage operations.</p>
                    </div>
                </li>
            </ul>
        </div>
    </div>
    
    <div class="right-section">
        <div class="auth-container">
            <div class="auth-header">
                <h2>Welcome Back</h2>
                <p>Sign in to continue to your dashboard</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form action="login" method="post" id="loginForm" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" 
                           value="${username}" 
                           placeholder="Enter your username"
                           autocomplete="username">
                    <div class="input-error" id="usernameError">Username is required</div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" 
                           placeholder="Enter your password"
                           autocomplete="current-password">
                    <div class="input-error" id="passwordError">Password is required</div>
                </div>
                
                <button type="submit" class="btn-login">Sign In</button>
            </form>
        </div>
    </div>
    
    <script>
        function validateForm() {
            let valid = true;
            
            // Username validation
            const username = document.getElementById('username');
            const usernameError = document.getElementById('usernameError');
            if (username.value.trim() === '') {
                username.classList.add('error');
                usernameError.style.display = 'block';
                valid = false;
            } else {
                username.classList.remove('error');
                usernameError.style.display = 'none';
            }
            
            // Password validation
            const password = document.getElementById('password');
            const passwordError = document.getElementById('passwordError');
            if (password.value.trim() === '') {
                password.classList.add('error');
                passwordError.style.display = 'block';
                valid = false;
            } else {
                password.classList.remove('error');
                passwordError.style.display = 'none';
            }
            
            return valid;
        }
        
        // Clear error on input
        document.getElementById('username').addEventListener('input', function() {
            this.classList.remove('error');
            document.getElementById('usernameError').style.display = 'none';
        });
        
        document.getElementById('password').addEventListener('input', function() {
            this.classList.remove('error');
            document.getElementById('passwordError').style.display = 'none';
        });
    </script>
</body>
</html>
