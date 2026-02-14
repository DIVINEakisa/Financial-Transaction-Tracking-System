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
    session.setAttribute("user", user); // Update session
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - FTTS</title>
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
            <a href="profile.jsp" class="nav-item active">
                <i class="fas fa-user"></i> Profile
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
            <h1>My Profile</h1>
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
            <!-- Profile Information Card -->
            <div class="card">
                <div style="display: flex; align-items: center; margin-bottom: 20px;">
                    <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 32px; margin-right: 20px;">
                        <%= user.getFullName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div>
                        <h2 style="margin: 0 0 5px 0;"><%= user.getFullName() %></h2>
                        <p style="margin: 0; color: var(--text-secondary);">
                            <i class="fas fa-envelope"></i> <%= user.getEmail() %>
                        </p>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">Role</span>
                        <span class="info-value">
                            <span class="badge <%= user.getRole().toLowerCase() %>">
                                <%= user.getRole() %>
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Status</span>
                        <span class="info-value">
                            <span class="status-badge status-<%= user.getStatus().toLowerCase() %>">
                                <%= user.getStatus() %>
                            </span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Phone</span>
                        <span class="info-value"><%= user.getPhone() != null ? user.getPhone() : "Not set" %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Login</span>
                        <span class="info-value">
                            <%= user.getLastLogin() != null ? dateFormat.format(user.getLastLogin()) : "Never" %>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Member Since</span>
                        <span class="info-value"><%= dateFormat.format(user.getCreatedAt()) %></span>
                    </div>
                </div>

                <button class="btn btn-primary" style="width: 100%; margin-top: 20px;" onclick="showEditModal()">
                    <i class="fas fa-edit"></i> Edit Profile
                </button>
            </div>

            <!-- Security Card -->
            <div class="card">
                <h3 style="margin-top: 0;">Security Settings</h3>
                
                <div style="padding: 15px; background: var(--bg-secondary); border-radius: 8px; margin-bottom: 15px;">
                    <div style="display: flex; align-items: center; margin-bottom: 10px;">
                        <i class="fas fa-shield-alt" style="font-size: 20px; color: var(--primary-color); margin-right: 10px;"></i>
                        <strong>Password</strong>
                    </div>
                    <p style="margin: 0 0 10px 0; color: var(--text-secondary); font-size: 14px;">
                        Secure your account with a strong password
                    </p>
                    <button class="btn btn-secondary" onclick="showPasswordModal()">
                        <i class="fas fa-key"></i> Change Password
                    </button>
                </div>

                <div style="padding: 15px; background: var(--bg-secondary); border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 10px;">
                        <i class="fas fa-history" style="font-size: 20px; color: var(--primary-color); margin-right: 10px;"></i>
                        <strong>Activity Log</strong>
                    </div>
                    <p style="margin: 0 0 10px 0; color: var(--text-secondary); font-size: 14px;">
                        Failed login attempts: <strong><%= user.getFailedLoginAttempts() %></strong>
                    </p>
                    <% if (user.getFailedLoginAttempts() > 0) { %>
                    <small style="color: var(--warning-color);">
                        <i class="fas fa-exclamation-triangle"></i> 
                        Account will be locked after 5 failed attempts
                    </small>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Account Statistics -->
        <div class="card" style="margin-top: 20px;">
            <h3 style="margin-top: 0;">Account Statistics</h3>
            <% 
            AccountDAO accountDAO = new AccountDAO();
            TransactionDAO transactionDAO = new TransactionDAO();
            int totalAccounts = accountDAO.getAccountsByUserId(user.getUserId()).size();
            int totalTransactions = transactionDAO.getTransactionsByUserId(user.getUserId()).size();
            %>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                <div class="stat-card">
                    <div class="stat-icon" style="background: var(--gradient-primary);">
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div class="stat-details">
                        <div class="stat-value"><%= totalAccounts %></div>
                        <div class="stat-label">Total Accounts</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: var(--gradient-success);">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
                    <div class="stat-details">
                        <div class="stat-value"><%= totalTransactions %></div>
                        <div class="stat-label">Total Transactions</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Edit Profile Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Edit Profile</h2>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/profile" method="POST">
                <input type="hidden" name="action" value="update">
                
                <div class="form-group">
                    <label>Full Name <span style="color: red;">*</span></label>
                    <input type="text" name="fullName" class="form-input" value="<%= user.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label>Email <span style="color: red;">*</span></label>
                    <input type="email" name="email" class="form-input" value="<%= user.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label>Phone</label>
                    <input type="tel" name="phone" class="form-input" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

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
                    <input type="password" name="newPassword" class="form-input" required minlength="8">
                    <small style="color: var(--text-secondary);">
                        Must be at least 8 characters with uppercase, lowercase, number, and special character
                    </small>
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
        function showEditModal() {
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function showPasswordModal() {
            document.getElementById('passwordModal').style.display = 'block';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const editModal = document.getElementById('editModal');
            const passwordModal = document.getElementById('passwordModal');
            if (event.target == editModal) {
                closeEditModal();
            } else if (event.target == passwordModal) {
                closePasswordModal();
            }
        }
    </script>
</body>
</html>
