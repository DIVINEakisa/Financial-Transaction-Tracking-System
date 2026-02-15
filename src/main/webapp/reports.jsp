<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ftts.model.*" %>
<%@ page import="com.ftts.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Authentication check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    TransactionDAO transactionDAO = new TransactionDAO();
    AccountDAO accountDAO = new AccountDAO();
    
    // Get user's data
    List<Transaction> transactions = transactionDAO.getTransactionsByUserId(user.getUserId());
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getUserId());
    
    // Calculate totals
    BigDecimal totalIncome = BigDecimal.ZERO;
    BigDecimal totalExpense = BigDecimal.ZERO;
    
    for (Transaction t : transactions) {
        if ("Income".equals(t.getTransactionType()) && "Approved".equals(t.getStatus())) {
            totalIncome = totalIncome.add(t.getAmount());
        } else if ("Expense".equals(t.getTransactionType()) && "Approved".equals(t.getStatus())) {
            totalExpense = totalExpense.add(t.getAmount());
        }
    }
    
    BigDecimal netBalance = totalIncome.subtract(totalExpense);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - FTTS</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <li><a href="<%= request.getContextPath() %>/dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/transactions.jsp"><i class="fas fa-exchange-alt"></i> Transactions</a></li>
                <li><a href="<%= request.getContextPath() %>/accounts.jsp"><i class="fas fa-wallet"></i> Accounts</a></li>
                <li><a href="<%= request.getContextPath() %>/reports.jsp" class="active"><i class="fas fa-chart-bar"></i> Reports</a></li>
                <li><a href="<%= request.getContextPath() %>/profile.jsp"><i class="fas fa-user"></i> Profile</a></li>
                <li><a href="<%= request.getContextPath() %>/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-chart-bar"></i> Financial Reports</h1>
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="exportPDF()">
                    <i class="fas fa-file-pdf"></i> Export PDF
                </button>
                <button class="btn btn-success" onclick="exportExcel()">
                    <i class="fas fa-file-excel"></i> Export Excel
                </button>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="cards-grid">
            <div class="card">
                <div class="card-icon" style="background: var(--gradient-success);">
                    <i class="fas fa-arrow-up"></i>
                </div>
                <div class="card-content">
                    <h3>Total Income</h3>
                    <p class="card-value">$<%= String.format("%,.2f", totalIncome) %></p>
                    <small>All approved income</small>
                </div>
            </div>

            <div class="card">
                <div class="card-icon" style="background: var(--gradient-danger);">
                    <i class="fas fa-arrow-down"></i>
                </div>
                <div class="card-content">
                    <h3>Total Expenses</h3>
                    <p class="card-value">$<%= String.format("%,.2f", totalExpense) %></p>
                    <small>All approved expenses</small>
                </div>
            </div>

            <div class="card">
                <div class="card-icon" style="background: var(--gradient-primary);">
                    <i class="fas fa-wallet"></i>
                </div>
                <div class="card-content">
                    <h3>Net Balance</h3>
                    <p class="card-value" style="color: <%= netBalance.compareTo(BigDecimal.ZERO) >= 0 ? "#2ECC71" : "#E74C3C" %>;">
                        $<%= String.format("%,.2f", netBalance) %>
                    </p>
                    <small>Income - Expenses</small>
                </div>
            </div>

            <div class="card">
                <div class="card-icon" style="background: linear-gradient(135deg, #9B59B6 0%, #8E44AD 100%);">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="card-content">
                    <h3>Total Transactions</h3>
                    <p class="card-value"><%= transactions.size() %></p>
                    <small>All time records</small>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="reports-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(500px, 1fr)); gap: 2rem; margin-top: 2rem;">
            <!-- Income vs Expense Chart -->
            <div class="content-card">
                <h2><i class="fas fa-chart-pie"></i> Income vs Expense</h2>
                <canvas id="pieChart" style="max-height: 300px;"></canvas>
            </div>

            <!-- Monthly Trend Chart -->
            <div class="content-card">
                <h2><i class="fas fa-chart-line"></i> Monthly Trend</h2>
                <canvas id="lineChart" style="max-height: 300px;"></canvas>
            </div>
        </div>

        <!-- Transaction Type Breakdown -->
        <div class="content-card" style="margin-top: 2rem;">
            <h2><i class="fas fa-list-alt"></i> Transaction Type Breakdown</h2>
            <canvas id="barChart" style="max-height: 400px;"></canvas>
        </div>

        <!-- Detailed Report Table -->
        <div class="content-card" style="margin-top: 2rem;">
            <h2><i class="fas fa-table"></i> Detailed Transaction Report</h2>
            <div class="filters" style="margin-bottom: 1.5rem; display: flex; gap: 1rem; flex-wrap: wrap;">
                <select id="filterType" class="form-input" onchange="filterTransactions()">
                    <option value="">All Types</option>
                    <option value="Income">Income</option>
                    <option value="Expense">Expense</option>
                </select>
                
                <select id="filterStatus" class="form-input" onchange="filterTransactions()">
                    <option value="">All Status</option>
                    <option value="Pending">Pending</option>
                    <option value="Approved">Approved</option>
                    <option value="Rejected">Rejected</option>
                </select>
                
                <input type="date" id="filterStartDate" class="form-input" onchange="filterTransactions()" placeholder="Start Date">
                <input type="date" id="filterEndDate" class="form-input" onchange="filterTransactions()" placeholder="End Date">
                
                <button class="btn btn-secondary" onclick="resetFilters()">
                    <i class="fas fa-redo"></i> Reset Filters
                </button>
            </div>

            <table style="width: 100%; border-collapse: collapse;">
                <thead style="background: var(--light-gray);">
                    <tr>
                        <th style="padding: 1rem; text-align: left;">Date</th>
                        <th style="padding: 1rem; text-align: left;">Type</th>
                        <th style="padding: 1rem; text-align: left;">Category</th>
                        <th style="padding: 1rem; text-align: right;">Amount</th>
                        <th style="padding: 1rem; text-align: center;">Status</th>
                        <th style="padding: 1rem; text-align: left;">Description</th>
                    </tr>
                </thead>
                <tbody id="transactionTableBody">
                    <% 
                    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                    for (Transaction t : transactions) { 
                    %>
                        <tr class="transaction-row" 
                            data-type="<%= t.getTransactionType() %>" 
                            data-status="<%= t.getStatus() %>"
                            data-date="<%= t.getTransactionDate() %>"
                            style="border-bottom: 1px solid var(--border-color);">
                            <td style="padding: 1rem;"><%= sdf.format(t.getTransactionDate()) %></td>
                            <td style="padding: 1rem;">
                                <span class="badge badge-<%= t.getTransactionType().toLowerCase() %>">
                                    <i class="fas fa-<%= t.getTransactionType().equals("Income") ? "arrow-up" : "arrow-down" %>"></i>
                                    <%= t.getTransactionType() %>
                                </span>
                            </td>
                            <td style="padding: 1rem;"><%= t.getCategoryName() != null ? t.getCategoryName() : "N/A" %></td>
                            <td style="padding: 1rem; text-align: right; font-weight: bold; color: <%= t.getTransactionType().equals("Income") ? "#2ECC71" : "#E74C3C" %>;">
                                $<%= String.format("%,.2f", t.getAmount()) %>
                            </td>
                            <td style="padding: 1rem; text-align: center;">
                                <span class="badge badge-<%= t.getStatus().toLowerCase() %>">
                                    <%= t.getStatus() %>
                                </span>
                            </td>
                            <td style="padding: 1rem;"><%= t.getDescription() != null ? t.getDescription() : "-" %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        // Pie Chart - Income vs Expense
        const pieCtx = document.getElementById('pieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Income', 'Expenses'],
                datasets: [{
                    data: [<%= totalIncome %>, <%= totalExpense %>],
                    backgroundColor: ['#2ECC71', '#E74C3C'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Line Chart - Monthly Trend (sample data)
        const lineCtx = document.getElementById('lineChart').getContext('2d');
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Income',
                    data: [5000, 6200, 5800, 7100, 6500, 7500],
                    borderColor: '#2ECC71',
                    backgroundColor: 'rgba(46, 204, 113, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Expenses',
                    data: [3500, 4200, 3800, 4500, 4100, 4800],
                    borderColor: '#E74C3C',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'bottom'
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

        // Bar Chart - Transaction Categories
        const barCtx = document.getElementById('barChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['Salary', 'Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Healthcare', 'Other'],
                datasets: [{
                    label: 'Amount ($)',
                    data: [8000, 1200, 800, 450, 300, 950, 400, 250],
                    backgroundColor: [
                        '#2ECC71', '#E74C3C', '#3498DB', '#F39C12',
                        '#9B59B6', '#1ABC9C', '#E67E22', '#95A5A6'
                    ],
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
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

        // Filter functionality
        function filterTransactions() {
            const typeFilter = document.getElementById('filterType').value;
            const statusFilter = document.getElementById('filterStatus').value;
            const startDate = document.getElementById('filterStartDate').value;
            const endDate = document.getElementById('filterEndDate').value;
            
            const rows = document.querySelectorAll('.transaction-row');
            
            rows.forEach(row => {
                const type = row.dataset.type;
                const status = row.dataset.status;
                const date = new Date(row.dataset.date);
                
                let showRow = true;
                
                if (typeFilter && type !== typeFilter) showRow = false;
                if (statusFilter && status !== statusFilter) showRow = false;
                if (startDate && date < new Date(startDate)) showRow = false;
                if (endDate && date > new Date(endDate)) showRow = false;
                
                row.style.display = showRow ? '' : 'none';
            });
        }

        function resetFilters() {
            document.getElementById('filterType').value = '';
            document.getElementById('filterStatus').value = '';
            document.getElementById('filterStartDate').value = '';
            document.getElementById('filterEndDate').value = '';
            filterTransactions();
        }

        function exportPDF() {
            alert('PDF export functionality will be implemented with iText library.');
            // This would connect to a servlet that generates PDF using iText
        }

        function exportExcel() {
            alert('Excel export functionality will be implemented with Apache POI library.');
            // This would connect to a servlet that generates Excel using Apache POI
        }
    </script>
</body>
</html>
