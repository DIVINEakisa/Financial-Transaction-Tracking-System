<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ftts.model.*" %>
<%@ page import="com.ftts.dao.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get fresh user data from database
    UserDAO userDAO = new UserDAO();
    user = userDAO.getUserById(user.getUserId());
    session.setAttribute("user", user);
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - FTTS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="dashboard-page">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-chart-line"></i>
            <span>FTTS</span>
        </div>
        <nav class="sidebar-nav">
            <a href="dashboard.jsp" class="nav-item">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="transactions.jsp" class="nav-item">
                <i class="fas fa-exchange-alt"></i> Transactions
            </a>
            <a href="accounts.jsp" class="nav-item">
                <i class="fas fa-wallet"></i> Accounts
            </a>
            <a href="reports.jsp" class="nav-item">
                <i class="fas fa-chart-bar"></i> Reports
            </a>
            <% if (user.isManager()) { %>
            <a href="manager/approvals.jsp" class="nav-item">
                <i class="fas fa-tasks"></i> Approvals
            </a>
            <% } %>
            <a href="profile.jsp" class="nav-item">
                <i class="fas fa-user"></i> Profile
            </a>
            <a href="settings.jsp" class="nav-item active">
                <i class="fas fa-cog"></i> Settings
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="<%= request.getContextPath() %>/logout" class="nav-item">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="topbar">
            <h1><i class="fas fa-cog"></i> Settings</h1>
        </div>

        <!-- Alert Messages -->
        <% 
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        if (message != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= message %>
            </div>
        <% } 
        if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <!-- Security Settings Card -->
            <div class="card">
                <div style="display: flex; align-items: center; margin-bottom: 20px;">
                    <div style="width: 50px; height: 50px; border-radius: 10px; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 24px; margin-right: 15px;">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div>
                        <h2 style="margin: 0;">Password</h2>
                        <p style="margin: 0; color: var(--text-secondary); font-size: 14px;">
                            Secure your account with a strong password
                        </p>
                    </div>
                </div>
                
                <button class="btn btn-primary" style="width: 100%;" onclick="showPasswordModal()">
                    <i class="fas fa-key"></i> Change Password
                </button>
            </div>

            <!-- Activity Log Card -->
            <div class="card">
                <div style="display: flex; align-items: center; margin-bottom: 20px;">
                    <div style="width: 50px; height: 50px; border-radius: 10px; background: var(--gradient-warning); display: flex; align-items: center; justify-content: center; color: white; font-size: 24px; margin-right: 15px;">
                        <i class="fas fa-history"></i>
                    </div>
                    <div>
                        <h2 style="margin: 0;">Activity Log</h2>
                        <p style="margin: 0; color: var(--text-secondary); font-size: 14px;">
                            Monitor your account security
                        </p>
                    </div>
                </div>
                
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Failed Login Attempts</span>
                        <span class="info-value">
                            <span class="badge <%= user.getFailedLoginAttempts() > 2 ? "danger" : "success" %>">
                                <%= user.getFailedLoginAttempts() %>
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Login</span>
                        <span class="info-value">
                            <%= user.getLastLogin() != null ? dateFormat.format(user.getLastLogin()) : "Never" %>
                        </span>
                    </div>
                </div>
                
                <% if (user.getFailedLoginAttempts() > 2) { %>
                <div style="padding: 10px; background: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px; margin-top: 15px;">
                    <i class="fas fa-exclamation-triangle" style="color: #ffc107;"></i>
                    <small style="color: #856404;">
                        Account will be locked after 5 failed attempts
                    </small>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Account Preferences -->
        <div class="card" style="margin-top: 20px;">
            <h3 style="margin-top: 0;"><i class="fas fa-user-cog"></i> Account Preferences</h3>
            
            <div style="display: grid; gap: 20px;">
                <!-- Email Notifications -->
                <div style="padding: 20px; background: var(--bg-secondary); border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <strong style="display: block; margin-bottom: 5px;">
                                <i class="fas fa-envelope"></i> Email Notifications
                            </strong>
                            <p style="margin: 0; color: var(--text-secondary); font-size: 14px;">
                                Receive email alerts for important activities
                            </p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" checked>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <!-- Transaction Alerts -->
                <div style="padding: 20px; background: var(--bg-secondary); border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <strong style="display: block; margin-bottom: 5px;">
                                <i class="fas fa-bell"></i> Transaction Alerts
                            </strong>
                            <p style="margin: 0; color: var(--text-secondary); font-size: 14px;">
                                Get notified for every transaction
                            </p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" checked>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <!-- Two-Factor Authentication -->
                <div style="padding: 20px; background: var(--bg-secondary); border-radius: 8px;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <strong style="display: block; margin-bottom: 5px;">
                                <i class="fas fa-lock"></i> Two-Factor Authentication
                            </strong>
                            <p style="margin: 0; color: var(--text-secondary); font-size: 14px;">
                                Add an extra layer of security (Coming Soon)
                            </p>
                        </div>
                        <label class="switch">
                            <input type="checkbox" disabled>
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Danger Zone -->
        <div class="card" style="margin-top: 20px; border: 2px solid var(--danger-color);">
            <h3 style="margin-top: 0; color: var(--danger-color);">
                <i class="fas fa-exclamation-triangle"></i> Danger Zone
            </h3>
            
            <div style="padding: 15px; background: #fff5f5; border-radius: 8px;">
                <strong style="display: block; margin-bottom: 5px;">Delete Account</strong>
                <p style="margin: 0 0 15px 0; color: var(--text-secondary); font-size: 14px;">
                    Once you delete your account, there is no going back. Please be certain.
                </p>
                <button class="btn btn-danger" onclick="confirmDelete()">
                    <i class="fas fa-trash"></i> Delete My Account
                </button>
            </div>
        </div>
    </main>

    <!-- Change Password Modal -->
    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Change Password</h2>
                <span class="close" onclick="closePasswordModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/profile" method="POST">
                <input type="hidden" name="action" value="changePassword">
                
                <div class="form-group">
                    <label>Current Password <span style="color: red;">*</span></label>
                    <input type="password" name="currentPassword" class="form-input" required>
                </div>

                <div class="form-group">
                    <label>New Password <span style="color: red;">*</span></label>
                    <input type="password" name="newPassword" id="newPassword" class="form-input" required minlength="8">
                    <small style="color: var(--text-secondary);">
                        Must be at least 8 characters with uppercase, lowercase, number, and special character
                    </small>
                    <div id="passwordStrength" style="margin-top: 5px; height: 4px; background: #e0e0e0; border-radius: 2px;">
                        <div id="strengthBar" style="height: 100%; width: 0%; background: #ccc; border-radius: 2px; transition: all 0.3s;"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Confirm New Password <span style="color: red;">*</span></label>
                    <input type="password" name="confirmPassword" class="form-input" required>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closePasswordModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Change Password</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showPasswordModal() {
            document.getElementById('passwordModal').style.display = 'block';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
        }

        function confirmDelete() {
            if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
                if (confirm('This will permanently delete all your data. Are you absolutely sure?')) {
                    alert('Account deletion feature will be implemented');
                }
            }
        }

        // Password strength checker
        document.getElementById('newPassword')?.addEventListener('input', function(e) {
            const password = e.target.value;
            const strengthBar = document.getElementById('strengthBar');
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;
            
            const width = (strength / 5) * 100;
            strengthBar.style.width = width + '%';
            
            if (strength <= 2) {
                strengthBar.style.background = '#e74c3c';
            } else if (strength <= 3) {
                strengthBar.style.background = '#f39c12';
            } else if (strength <= 4) {
                strengthBar.style.background = '#3498db';
            } else {
                strengthBar.style.background = '#2ecc71';
            }
        });

        // Close modal when clicking outside
        window.onclick = function(event) {
            const passwordModal = document.getElementById('passwordModal');
            if (event.target == passwordModal) {
                closePasswordModal();
            }
        }
    </script>
</body>
</html>
