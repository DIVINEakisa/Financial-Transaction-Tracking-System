<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FTTS - Financial Transaction Tracking System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="container">
            <div class="nav-brand">
                <i class="fas fa-chart-line"></i>
                <span>FTTS</span>
            </div>
            <ul class="nav-menu">
                <li><a href="<%= request.getContextPath() %>/index.jsp" class="active">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/login.jsp">Login</a></li>
                <li><a href="<%= request.getContextPath() %>/register.jsp" class="btn-register">Register</a></li>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">Secure & Smart Financial Tracking</h1>
                <p class="hero-subtitle">Manage income, expenses, and approvals securely with advanced role-based control</p>
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary btn-large">
                    <i class="fas fa-rocket"></i> Get Started
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <h2 class="section-title">Why Choose FTTS?</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Secure Transactions</h3>
                    <p>Bank-level security with encrypted data, password hashing, and fraud detection systems</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <h3>Real-Time Reports</h3>
                    <p>Interactive dashboards with income/expense analytics and exportable PDF/Excel reports</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <h3>Role-Based Control</h3>
                    <p>Multi-level approval system with user, manager, and admin roles for enhanced security</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Fraud Prevention</h3>
                    <p>Automated suspicious activity detection and account locking mechanisms</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h3>Smart Approvals</h3>
                    <p>Large transactions require manager approval to prevent unauthorized spending</p>
                </div>
                
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3>Audit Trail</h3>
                    <p>Complete activity logging for compliance and security monitoring</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Uptime</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">256-bit</div>
                    <div class="stat-label">Encryption</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Monitoring</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">ISO</div>
                    <div class="stat-label">Certified</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4><i class="fas fa-chart-line"></i> FTTS</h4>
                    <p>Secure Financial Transaction Tracking System</p>
                </div>
                <div class="footer-section">
                    <h4>Contact</h4>
                    <p><i class="fas fa-envelope"></i> support@ftts.com</p>
                    <p><i class="fas fa-phone"></i> +1 (555) 123-4567</p>
                </div>
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <p><a href="#">Privacy Policy</a></p>
                    <p><a href="#">Terms of Service</a></p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 Financial Transaction Tracking System. All rights reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html>
