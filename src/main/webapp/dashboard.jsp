<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ftts.model.*" %>
<%@ page import="com.ftts.dao.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Fetch data
    TransactionDAO transactionDAO = new TransactionDAO();
    AccountDAO accountDAO = new AccountDAO();
    
    // Get current month summary
    LocalDate now = LocalDate.now();
    Date startDate = Date.valueOf(now.withDayOfMonth(1));
    Date endDate = Date.valueOf(now.withDayOfMonth(now.lengthOfMonth()));
    
    BigDecimal[] summary = transactionDAO.getTransactionSummary(user.getUserId(), startDate, endDate);
    BigDecimal totalIncome = summary[0];
    BigDecimal totalExpense = summary[1];
    BigDecimal netBalance = summary[2];
    
    BigDecimal accountBalance = accountDAO.getTotalBalance(user.getUserId());
    List<Transaction> recentTransactions = transactionDAO.getTransactionsByUserId(user.getUserId());
    if (recentTransactions.size() > 10) {
        recentTransactions = recentTransactions.subList(0, 10);
    }
    
    List<Transaction> pendingTransactions = new ArrayList<Transaction>();
    for (Transaction t : recentTransactions) {
        if (t.isPending()) {
            pendingTransactions.add(t);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - FTTS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body class="dashboard-page">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-chart-line"></i>
            <span>FTTS</span>
        </div>
        <nav class="sidebar-nav">
            <a href="dashboard.jsp" class="nav-item active">
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
                <% if (pendingTransactions.size() > 0) { %>
                    <span class="badge"><%= pendingTransactions.size() %></span>
                <% } %>
            </a>
            <% } %>
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
        <!-- Top Bar -->
        <div class="topbar">
            <h1>Dashboard</h1>
            <div class="topbar-right">
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <span><%= user.getFullName() %></span>
                    <span class="badge badge-<%= user.getRole().toLowerCase() %>"><%= user.getRole() %></span>
                </div>
            </div>
        </div>

        <!-- Alert Messages -->
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

        <!-- Summary Cards -->
        <div class="cards-grid">
            <div class="card card-income">
                <div class="card-icon">
                    <i class="fas fa-arrow-up"></i>
                </div>
                <div class="card-content">
                    <h3>Total Income</h3>
                    <p class="card-value">$<%= String.format("%,.2f", totalIncome) %></p>
                    <small>This Month</small>
                </div>
            </div>

            <div class="card card-expense">
                <div class="card-icon">
                    <i class="fas fa-arrow-down"></i>
                </div>
                <div class="card-content">
                    <h3>Total Expense</h3>
                    <p class="card-value">$<%= String.format("%,.2f", totalExpense) %></p>
                    <small>This Month</small>
                </div>
            </div>

            <div class="card card-balance">
                <div class="card-icon">
                    <i class="fas fa-wallet"></i>
                </div>
                <div class="card-content">
                    <h3>Current Balance</h3>
                    <p class="card-value">$<%= String.format("%,.2f", accountBalance) %></p>
                    <small>All Accounts</small>
                </div>
            </div>

            <div class="card card-pending">
                <div class="card-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="card-content">
                    <h3>Pending Approvals</h3>
                    <p class="card-value"><%= pendingTransactions.size() %></p>
                    <small>Awaiting Review</small>
                </div>
            </div>
        </div>

        <!-- Charts and Recent Transactions -->
        <div class="content-grid">
            <div class="content-card chart-card">
                <h2><i class="fas fa-chart-bar"></i> Monthly Overview</h2>
                <canvas id="monthlyChart"></canvas>
            </div>

            <div class="content-card">
                <h2><i class="fas fa-history"></i> Recent Transactions</h2>
                <div class="transactions-list">
                    <% if (recentTransactions.isEmpty()) { %>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <p>No transactions yet</p>
                            <a href="transactions.jsp" class="btn btn-primary">Add Transaction</a>
                        </div>
                    <% } else { %>
                        <% for (Transaction transaction : recentTransactions) { %>
                            <div class="transaction-item">
                                <div class="transaction-icon <%= transaction.getTransactionType().toLowerCase() %>">
                                    <i class="fas fa-<%= transaction.getTransactionType().equals("Income") ? "arrow-up" : "arrow-down" %>"></i>
                                </div>
                                <div class="transaction-info">
                                    <strong><%= transaction.getCategoryName() %></strong>
                                    <small><%= transaction.getAccountName() %> • <%= transaction.getTransactionDate() %></small>
                                </div>
                                <div class="transaction-amount <%= transaction.getTransactionType().toLowerCase() %>">
                                    <%= transaction.getTransactionType().equals("Income") ? "+" : "-" %>$<%= String.format("%,.2f", transaction.getAmount()) %>
                                </div>
                                <div class="transaction-status">
                                    <span class="badge badge-<%= transaction.getStatus().toLowerCase() %>">
                                        <%= transaction.getStatus() %>
                                    </span>
                                </div>
                            </div>
                        <% } %>
                        <a href="transactions.jsp" class="btn btn-secondary btn-block">View All Transactions</a>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2><i class="fas fa-bolt"></i> Quick Actions</h2>
            <div class="actions-grid">
                <a href="transactions.jsp?action=add" class="action-btn">
                    <i class="fas fa-plus-circle"></i>
                    <span>Add Transaction</span>
                </a>
                <a href="accounts.jsp?action=add" class="action-btn">
                    <i class="fas fa-wallet"></i>
                    <span>Add Account</span>
                </a>
                <a href="reports.jsp" class="action-btn">
                    <i class="fas fa-file-pdf"></i>
                    <span>Generate Report</span>
                </a>
                <a href="profile.jsp" class="action-btn">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </a>
            </div>
        </div>
    </main>

    <script>
        // Monthly Chart
        const ctx = document.getElementById('monthlyChart').getContext('2d');
        const monthlyChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Income', 'Expense', 'Net Balance'],
                datasets: [{
                    label: 'Amount ($)',
                    data: [<%= totalIncome %>, <%= totalExpense %>, <%= netBalance %>],
                    backgroundColor: [
                        'rgba(46, 204, 113, 0.8)',
                        'rgba(231, 76, 60, 0.8)',
                        'rgba(52, 152, 219, 0.8)'
                    ],
                    borderColor: [
                        '#2ECC71',
                        '#E74C3C',
                        '#3498DB'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
