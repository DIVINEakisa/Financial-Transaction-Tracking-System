<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ftts.model.*" %>
<%@ page import="com.ftts.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    TransactionDAO transactionDAO = new TransactionDAO();
    AccountDAO accountDAO = new AccountDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    
    List<Transaction> transactions = transactionDAO.getTransactionsByUserId(user.getUserId());
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getUserId());
    List<Category> categories = categoryDAO.getAllCategories();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions - FTTS</title>
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
            <a href="transactions.jsp" class="nav-item active">
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
            <h1>Transactions</h1>
            <div class="topbar-right">
                <button class="btn btn-primary" onclick="showAddModal()">
                    <i class="fas fa-plus"></i> Add Transaction
                </button>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="card" style="margin-bottom: 20px;">
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 5px; color: var(--text-secondary);">Type</label>
                    <select id="filterType" class="form-input" onchange="filterTransactions()">
                        <option value="">All Types</option>
                        <option value="Income">Income</option>
                        <option value="Expense">Expense</option>
                        <option value="Transfer">Transfer</option>
                    </select>
                </div>
                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 5px; color: var(--text-secondary);">Account</label>
                    <select id="filterAccount" class="form-input" onchange="filterTransactions()">
                        <option value="">All Accounts</option>
                        <% for (Account acc : accounts) { %>
                        <option value="<%= acc.getAccountId() %>"><%= acc.getAccountName() %></option>
                        <% } %>
                    </select>
                </div>
                <div style="flex: 1; min-width: 200px;">
                    <label style="display: block; margin-bottom: 5px; color: var(--text-secondary);">Status</label>
                    <select id="filterStatus" class="form-input" onchange="filterTransactions()">
                        <option value="">All Status</option>
                        <option value="Completed">Completed</option>
                        <option value="Pending">Pending</option>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Transactions Table -->
        <div class="card">
            <% if (transactions == null || transactions.isEmpty()) { %>
                <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                    <i class="fas fa-inbox" style="font-size: 48px; margin-bottom: 15px; opacity: 0.5;"></i>
                    <p>No transactions found</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Account</th>
                                <th>Category</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="transactionsTableBody">
                            <% 
                            AccountDAO tempAccDAO = new AccountDAO();
                            CategoryDAO tempCatDAO = new CategoryDAO();
                            for (Transaction trans : transactions) { 
                                Account acc = tempAccDAO.getAccountById(trans.getAccountId());
                                Category cat = tempCatDAO.getCategoryById(trans.getCategoryId());
                            %>
                            <tr data-type="<%= trans.getTransactionType() %>" 
                                data-account="<%= trans.getAccountId() %>" 
                                data-status="<%= trans.getStatus() %>">
                                <td><%= dateFormat.format(trans.getTransactionDate()) %></td>
                                <td><%= trans.getDescription() %></td>
                                <td><%= acc != null ? acc.getAccountName() : "N/A" %></td>
                                <td><%= cat != null ? cat.getCategoryName() : "N/A" %></td>
                                <td>
                                    <span class="badge <%= trans.getTransactionType().toLowerCase() %>">
                                        <%= trans.getTransactionType() %>
                                    </span>
                                </td>
                                <td class="<%= "Income".equals(trans.getTransactionType()) ? "text-success" : "text-danger" %>">
                                    <%= "Income".equals(trans.getTransactionType()) ? "+" : "-" %>
                                    $<%= String.format("%,.2f", trans.getAmount()) %>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= trans.getStatus().toLowerCase() %>">
                                        <%= trans.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <button class="btn-icon" onclick="viewTransaction(<%= trans.getTransactionId() %>)" title="View">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <% if ("Completed".equals(trans.getStatus())) { %>
                                    <button class="btn-icon text-danger" onclick="deleteTransaction(<%= trans.getTransactionId() %>)" title="Delete">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Add Transaction Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Add Transaction</h2>
                <span class="close" onclick="closeAddModal()">&times;</span>
            </div>
            <form action="<%= request.getContextPath() %>/transaction" method="POST">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label>Transaction Type <span style="color: red;">*</span></label>
                    <select name="transactionType" class="form-input" required onchange="updateCategories(this.value)">
                        <option value="">Select Type</option>
                        <option value="Income">Income</option>
                        <option value="Expense">Expense</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Account <span style="color: red;">*</span></label>
                    <select name="accountId" class="form-input" required>
                        <option value="">Select Account</option>
                        <% for (Account acc : accounts) { 
                            if ("Active".equals(acc.getStatus())) { %>
                        <option value="<%= acc.getAccountId() %>">
                            <%= acc.getAccountName() %> ($<%= String.format("%,.2f", acc.getBalance()) %>)
                        </option>
                        <% }} %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Category <span style="color: red;">*</span></label>
                    <select name="categoryId" id="categorySelect" class="form-input" required>
                        <option value="">Select Category</option>
                        <% for (Category cat : categories) { %>
                        <option value="<%= cat.getCategoryId() %>" data-type="<%= cat.getCategoryType() %>">
                            <%= cat.getCategoryName() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Amount <span style="color: red;">*</span></label>
                    <input type="number" name="amount" class="form-input" step="0.01" min="0.01" required>
                </div>

                <div class="form-group">
                    <label>Date <span style="color: red;">*</span></label>
                    <input type="date" name="transactionDate" class="form-input" required value="<%= new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" class="form-input" rows="3"></textarea>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeAddModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Transaction</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }

        function updateCategories(type) {
            const categorySelect = document.getElementById('categorySelect');
            const options = categorySelect.querySelectorAll('option');
            
            options.forEach(option => {
                if (option.value === '') {
                    option.style.display = 'block';
                } else {
                    const optionType = option.getAttribute('data-type');
                    option.style.display = (optionType === type || type === '') ? 'block' : 'none';
                }
            });
            
            categorySelect.value = '';
        }

        function filterTransactions() {
            const type = document.getElementById('filterType').value;
            const account = document.getElementById('filterAccount').value;
            const status = document.getElementById('filterStatus').value;
            
            const rows = document.querySelectorAll('#transactionsTableBody tr');
            
            rows.forEach(row => {
                const rowType = row.getAttribute('data-type');
                const rowAccount = row.getAttribute('data-account');
                const rowStatus = row.getAttribute('data-status');
                
                const matchType = !type || rowType === type;
                const matchAccount = !account || rowAccount === account;
                const matchStatus = !status || rowStatus === status;
                
                row.style.display = (matchType && matchAccount && matchStatus) ? '' : 'none';
            });
        }

        function viewTransaction(id) {
            // Implement view transaction details
            alert('View transaction: ' + id);
        }

        function deleteTransaction(id) {
            if (confirm('Are you sure you want to delete this transaction?')) {
                window.location.href = '<%= request.getContextPath() %>/transaction?action=delete&id=' + id;
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('addModal');
            if (event.target == modal) {
                closeAddModal();
            }
        }
    </script>
</body>
</html>
