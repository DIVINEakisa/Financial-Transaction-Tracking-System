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
            <a href="settings.jsp" class="nav-item">
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
            <h1><i class="fas fa-user-circle"></i> My Profile</h1>
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

        <!-- Profile Card -->
        <div class="card" style="max-width: 800px; margin: 0 auto;">
            <div style="text-align: center; margin-bottom: 30px;">
                <div style="width: 120px; height: 120px; border-radius: 50%; background: var(--gradient-primary); display: inline-flex; align-items: center; justify-content: center; color: white; font-size: 48px; margin-bottom: 15px; box-shadow: 0 4px 12px rgba(11, 61, 145, 0.3);">
                    <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <h2 style="margin: 0 0 5px 0; font-size: 28px;"><%= user.getFullName() %></h2>
                <p style="margin: 0; color: var(--text-secondary); font-size: 16px;">
                    <i class="fas fa-envelope"></i> <%= user.getEmail() %>
                </p>
                <div style="margin-top: 15px;">
                    <span class="badge <%= user.getRole().toLowerCase() %>" style="font-size: 14px; padding: 6px 15px;">
                        <i class="fas fa-user-tag"></i> <%= user.getRole() %>
                    </span>
                    <span class="status-badge status-<%= user.getStatus().toLowerCase() %>" style="font-size: 14px; padding: 6px 15px; margin-left: 10px;">
                        <%= user.getStatus() %>
                    </span>
                </div>
            </div>

            <hr style="border: none; border-top: 1px solid var(--border-color); margin: 30px 0;">

            <h3 style="margin: 0 0 20px 0;"><i class="fas fa-info-circle"></i> Personal Information</h3>
            
            <div class="info-grid" style="margin-bottom: 30px;">
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-phone"></i> Phone</span>
                    <span class="info-value"><%= user.getPhone() != null ? user.getPhone() : "Not set" %></span>
                </div>
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-calendar-alt"></i> Member Since</span>
                    <span class="info-value"><%= dateFormat.format(user.getCreatedAt()) %></span>
                </div>
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-clock"></i> Last Login</span>
                    <span class="info-value">
                        <%= user.getLastLogin() != null ? dateFormat.format(user.getLastLogin()) : "Never" %>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label"><i class="fas fa-id-badge"></i> User ID</span>
                    <span class="info-value">#<%= user.getUserId() %></span>
                </div>
            </div>

            <div style="display: flex; gap: 10px; justify-content: center;">
                <button class="btn btn-primary" onclick="showEditModal()">
                    <i class="fas fa-edit"></i> Edit Profile
                </button>
                <a href="settings.jsp" class="btn btn-secondary">
                    <i class="fas fa-cog"></i> Go to Settings
                </a>
            </div>
        </div>

        <!-- Account Statistics -->
        <div class="card" style="margin-top: 20px; max-width: 800px; margin-left: auto; margin-right: auto;">
            <h3 style="margin-top: 0;"><i class="fas fa-chart-pie"></i> Account Statistics</h3>
            <% 
            AccountDAO accountDAO = new AccountDAO();
            TransactionDAO transactionDAO = new TransactionDAO();
            int totalAccounts = accountDAO.getAccountsByUserId(user.getUserId()).size();
            int totalTransactions = transactionDAO.getTransactionsByUserId(user.getUserId()).size();
            %>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                <div style="text-align: center; padding: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 10px; color: white;">
                    <i class="fas fa-wallet" style="font-size: 32px; margin-bottom: 10px; opacity: 0.9;"></i>
                    <div style="font-size: 32px; font-weight: bold; margin-bottom: 5px;"><%= totalAccounts %></div>
                    <div style="font-size: 14px; opacity: 0.9;">Total Accounts</div>
                </div>
                <div style="text-align: center; padding: 20px; background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%); border-radius: 10px; color: white;">
                    <i class="fas fa-exchange-alt" style="font-size: 32px; margin-bottom: 10px; opacity: 0.9;"></i>
                    <div style="font-size: 32px; font-weight: bold; margin-bottom: 5px;"><%= totalTransactions %></div>
                    <div style="font-size: 14px; opacity: 0.9;">Total Transactions</div>
                </div>
            </div>
        </div>
    </main>

    <!-- Edit Profile Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/profile" method="POST">
                <input type="hidden" name="action" value="update">
                
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Full Name <span style="color: red;">*</span></label>
                    <input type="text" name="fullName" class="form-input" value="<%= user.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email <span style="color: red;">*</span></label>
                    <input type="email" name="email" class="form-input" value="<%= user.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-phone"></i> Phone</label>
                    <input type="tel" name="phone" class="form-input" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="e.g., 0792502568">
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
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

        // Close modal when clicking outside
        window.onclick = function(event) {
            const editModal = document.getElementById('editModal');
            if (event.target == editModal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>
