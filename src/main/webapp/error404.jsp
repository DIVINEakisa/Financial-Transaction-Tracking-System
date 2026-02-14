<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-box">
            <div class="auth-header">
                <i class="fas fa-exclamation-triangle" style="color: var(--soft-gold);"></i>
                <h1>Page Not Found</h1>
                <p>The page you're looking for doesn't exist</p>
            </div>
            
            <div style="text-align: center; padding: 2rem; background: var(--light-gray); border-radius: var(--border-radius);">
                <p style="font-size: 4rem; margin: 0; color: var(--soft-gold);">404</p>
                <p style="margin-top: 1rem; color: var(--text-light);">Not Found</p>
            </div>
            
            <div style="margin-top: 2rem; text-align: center;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
                    <i class="fas fa-home"></i> Go to Homepage
                </a>
            </div>
        </div>
    </div>
</body>
</html>
