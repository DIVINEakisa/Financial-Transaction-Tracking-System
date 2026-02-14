<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - FTTS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-box auth-box-large">
            <div class="auth-header">
                <i class="fas fa-user-plus"></i>
                <h1>Create Account</h1>
                <p>Join FTTS for secure financial tracking</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post" class="auth-form" 
                  onsubmit="return validateRegistration()">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") != null ? session.getAttribute("csrfToken") : "" %>">
                
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user"></i> Full Name *
                    </label>
                    <input type="text" id="fullName" name="fullName" class="form-control" 
                           placeholder="Enter your full name" required minlength="2" maxlength="100">
                </div>

                <div class="form-group">
                    <label for="email">
                        <i class="fas fa-envelope"></i> Email Address *
                    </label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <label for="phone">
                        <i class="fas fa-phone"></i> Phone Number
                    </label>
                    <input type="tel" id="phone" name="phone" class="form-control" 
                           placeholder="Enter your phone number">
                </div>

                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Password *
                    </label>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Create a strong password" required minlength="8">
                    <small class="form-text">
                        Password must be at least 8 characters with uppercase, lowercase, digit, and special character
                    </small>
                    <div id="passwordStrength" class="password-strength"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Confirm Password *
                    </label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           placeholder="Confirm your password" required>
                </div>

                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="terms" required>
                        I agree to the <a href="#">Terms and Conditions</a>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? 
                    <a href="<%= request.getContextPath() %>/login.jsp">Login here</a>
                </p>
                <p>
                    <a href="<%= request.getContextPath() %>/index.jsp">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </p>
            </div>
        </div>
    </div>

    <script>
        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthDiv = document.getElementById('passwordStrength');
            
            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            const strengthTexts = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
            const strengthColors = ['#E74C3C', '#E67E22', '#F1C40F', '#2ECC71', '#27AE60'];
            
            if (password.length > 0) {
                strengthDiv.textContent = 'Strength: ' + strengthTexts[strength - 1];
                strengthDiv.style.color = strengthColors[strength - 1];
            } else {
                strengthDiv.textContent = '';
            }
        });

        function validateRegistration() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>
