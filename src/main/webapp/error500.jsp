<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-box">
            <div class="auth-header">
                <i class="fas fa-server" style="color: var(--danger-red);"></i>
                <h1>Internal Server Error</h1>
                <p>Something went wrong on our end</p>
            </div>
            
            <div style="text-align: center; padding: 2rem; background: var(--light-gray); border-radius: var(--border-radius);">
                <p style="font-size: 4rem; margin: 0; color: var(--danger-red);">500</p>
                <p style="margin-top: 1rem; color: var(--text-light);">Internal Server Error</p>
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
