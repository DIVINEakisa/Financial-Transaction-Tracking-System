<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - FTTS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-box">
            <div class="auth-header">
                <i class="fas fa-chart-line"></i>
                <h1>FTTS Login</h1>
                <p>Welcome back! Please login to your account</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post" class="auth-form">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") != null ? session.getAttribute("csrfToken") : "" %>">
                
                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="Enter your email" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required>
                </div>

                <div class="form-row">
                    <label class="checkbox-label">
                        <input type="checkbox" name="remember"> Remember me
                    </label>
                    <a href="#" class="link-text">Forgot password?</a>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>

            <div class="auth-footer">
                <p>Don't have an account? 
                    <a href="<%= request.getContextPath() %>/register.jsp">Register here</a>
                </p>
                <p>
                    <a href="<%= request.getContextPath() %>/index.jsp">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </p>
            </div>

            <!-- Demo Credentials -->
            <div class="demo-credentials">
                <h4><i class="fas fa-info-circle"></i> Demo Credentials</h4>
                <p><strong>Admin:</strong> admin@ftts.com / Admin@123</p>
                <p><strong>Manager:</strong> manager@ftts.com / Admin@123</p>
            </div>
        </div>
    </div>
</body>
</html>
