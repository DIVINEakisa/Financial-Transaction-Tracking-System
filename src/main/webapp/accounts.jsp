<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ftts.model.*" %>
<%@ page import="com.ftts.dao.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    AccountDAO accountDAO = new AccountDAO();
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accounts - FTTS</title>
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
            <a href="accounts.jsp" class="nav-item active">
                <i class="fas fa-wallet"></i> Accounts
            </a>
            <a href="reports.jsp" class="nav-item">
                <i class="fas fa-chart-bar"></i> Reports
            </a>
            <a href="profile.jsp" class="nav-item">
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
            <h1>My Accounts</h1>
            <div class="topbar-right">
                <button class="btn btn-primary" onclick="showAddModal()">
                    <i class="fas fa-plus"></i> Add Account
                </button>
            </div>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Accounts Grid -->
        <div class="cards-grid">
            <% if (accounts.isEmpty()) { %>
                <div class="empty-state" style="grid-column: 1 / -1;">
                    <i class="fas fa-wallet"></i>
                    <p>No accounts yet</p>
                    <button class="btn btn-primary" onclick="showAddModal()">Add Your First Account</button>
                </div>
            <% } else { %>
                <% for (Account account : accounts) { %>
                    <div class="card">
                        <div class="card-icon" style="background: 
                            <%= account.getAccountType().equals("Bank") ? "var(--gradient-primary)" : 
                                account.getAccountType().equals("Cash") ? "var(--gradient-success)" : 
                                "linear-gradient(135deg, #F39C12 0%, #E67E22 100%)" %>;">
                            <i class="fas fa-<%= account.getAccountType().equals("Bank") ? "university" : 
                                                 account.getAccountType().equals("Cash") ? "money-bill" : 
                                                 "mobile-alt" %>"></i>
                        </div>
                        <div class="card-content">
                            <h3><%= account.getAccountName() %></h3>
                            <p class="card-value">$<%= String.format("%,.2f", account.getBalance()) %></p>
                            <small><%= account.getAccountType() %> • <%= account.getCurrency() %></small>
                            <div style="margin-top: 1rem;">
                                <span class="badge badge-<%= account.getStatus().toLowerCase() %>">
                                    <%= account.getStatus() %>
                                </span>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- Account Details Table -->
        <% if (!accounts.isEmpty()) { %>
        <div class="content-card" style="margin-top: 2rem;">
            <h2><i class="fas fa-list"></i> Account Details</h2>
            <table style="width: 100%; border-collapse: collapse;">
                <thead style="background: var(--light-gray);">
                    <tr>
                        <th style="padding: 1rem; text-align: left;">Account Name</th>
                        <th style="padding: 1rem; text-align: left;">Type</th>
                        <th style="padding: 1rem; text-align: right;">Balance</th>
                        <th style="padding: 1rem; text-align: center;">Status</th>
                        <th style="padding: 1rem; text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Account account : accounts) { %>
                        <tr style="border-bottom: 1px solid var(--border-color);">
                            <td style="padding: 1rem;"><strong><%= account.getAccountName() %></strong></td>
                            <td style="padding: 1rem;"><%= account.getAccountType() %></td>
                            <td style="padding: 1rem; text-align: right; font-weight: bold;">
                                $<%= String.format("%,.2f", account.getBalance()) %>
                            </td>
                            <td style="padding: 1rem; text-align: center;">
                                <span class="badge badge-<%= account.getStatus().toLowerCase() %>">
                                    <%= account.getStatus() %>
                                </span>
                            </td>
                            <td style="padding: 1rem; text-align: center;">
                                <button class="btn btn-secondary" style="padding: 0.5rem 1rem; margin-right: 0.5rem;">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-danger" style="padding: 0.5rem 1rem;">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </main>

    <!-- Add Account Modal -->
    <div id="addModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
         background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
        <div style="background: white; padding: 2rem; border-radius: 12px; width: 90%; max-width: 500px;">
            <h2 style="margin-bottom: 1.5rem; color: var(--navy-blue);">
                <i class="fas fa-plus-circle"></i> Add New Account
            </h2>
            
            <form action="<%= request.getContextPath() %>/account" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="accountName">Account Name *</label>
                    <input type="text" id="accountName" name="accountName" class="form-control" 
                           placeholder="e.g., My Bank Account" required>
                </div>
                
                <div class="form-group">
                    <label for="accountType">Account Type *</label>
                    <select id="accountType" name="accountType" class="form-control" required>
                        <option value="">Select Type</option>
                        <option value="Bank">Bank Account</option>
                        <option value="Cash">Cash</option>
                        <option value="Mobile Money">Mobile Money</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="balance">Initial Balance</label>
                    <input type="number" id="balance" name="balance" class="form-control" 
                           placeholder="0.00" step="0.01" min="0" value="0">
                    <small class="form-text">Optional: Enter initial balance if any</small>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
                        <i class="fas fa-save"></i> Create Account
                    </button>
                    <button type="button" class="btn btn-secondary" style="flex: 1;" onclick="hideAddModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('addModal').style.display = 'flex';
        }
        
        function hideAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }
    </script>
</body>
</html>
