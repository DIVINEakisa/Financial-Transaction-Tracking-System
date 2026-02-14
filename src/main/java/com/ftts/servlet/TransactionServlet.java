package com.ftts.servlet;

import com.ftts.dao.*;
import com.ftts.model.*;
import com.ftts.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

/**
 * Transaction Servlet
 * Handles transaction operations
 */
@WebServlet("/transaction")
public class TransactionServlet extends HttpServlet {
    
    private TransactionDAO transactionDAO = new TransactionDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private AuditLogDAO auditLogDAO = new AuditLogDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addTransaction(request, response, user);
        } else if ("approve".equals(action)) {
            approveTransaction(request, response, user);
        } else if ("reject".equals(action)) {
            rejectTransaction(request, response, user);
        }
    }
    
    private void addTransaction(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String transactionType = request.getParameter("transactionType");
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String description = request.getParameter("description");
            Date transactionDate = Date.valueOf(request.getParameter("transactionDate"));
            
            // Validation
            if (!ValidationUtil.isValidAmount(amount)) {
                request.setAttribute("error", "Invalid amount");
                request.getRequestDispatcher("/transactions.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidTransactionType(transactionType)) {
                request.setAttribute("error", "Invalid transaction type");
                request.getRequestDispatcher("/transactions.jsp").forward(request, response);
                return;
            }
            
            // Verify account ownership
            if (!accountDAO.verifyAccountOwnership(accountId, user.getUserId())) {
                request.setAttribute("error", "Unauthorized action");
                request.getRequestDispatcher("/transactions.jsp").forward(request, response);
                return;
            }
            
            // Check balance for expenses
            if ("Expense".equals(transactionType)) {
                if (!accountDAO.hasSufficientBalance(accountId, amount)) {
                    request.setAttribute("error", "Insufficient balance");
                    request.getRequestDispatcher("/transactions.jsp").forward(request, response);
                    return;
                }
            }
            
            // Check suspicious activity
            if (transactionDAO.checkSuspiciousActivity(user.getUserId())) {
                request.setAttribute("error", 
                    "Suspicious activity detected. Account locked. Contact administrator.");
                request.getRequestDispatcher("/transactions.jsp").forward(request, response);
                return;
            }
            
            // Create transaction
            Transaction transaction = new Transaction();
            transaction.setUserId(user.getUserId());
            transaction.setAccountId(accountId);
            transaction.setCategoryId(categoryId);
            transaction.setTransactionType(transactionType);
            transaction.setAmount(amount);
            transaction.setDescription(description);
            transaction.setTransactionDate(transactionDate);
            
            if (transactionDAO.createTransaction(transaction)) {
                // Log action
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("TRANSACTION_ADD");
                log.setActionDescription("Transaction added: " + transactionType + 
                                        " " + amount + " (" + transaction.getStatus() + ")");
                log.setIpAddress(request.getRemoteAddr());
                log.setTableAffected("transactions");
                log.setRecordId(transaction.getTransactionId());
                auditLogDAO.logAction(log);
                
                if (transaction.isPending()) {
                    request.setAttribute("success", 
                        "Transaction requires approval. Pending review.");
                } else {
                    request.setAttribute("success", "Transaction added successfully");
                }
            } else {
                request.setAttribute("error", "Failed to add transaction");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/transactions.jsp").forward(request, response);
    }
    
    private void approveTransaction(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        if (!user.isManager()) {
            response.sendRedirect(request.getContextPath() + "/error403.jsp");
            return;
        }
        
        try {
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            String notes = request.getParameter("notes");
            
           if (transactionDAO.approveTransaction(transactionId, user.getUserId(), notes)) {
                // Log action
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("TRANSACTION_APPROVE");
                log.setActionDescription("Transaction approved: ID " + transactionId);
                log.setIpAddress(request.getRemoteAddr());
                log.setTableAffected("transactions");
                log.setRecordId(transactionId);
                auditLogDAO.logAction(log);
                
                request.setAttribute("success", "Transaction approved successfully");
            } else {
                request.setAttribute("error", "Failed to approve transaction");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input");
        }
        
        request.getRequestDispatcher("/manager/approvals.jsp").forward(request, response);
    }
    
    private void rejectTransaction(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        if (!user.isManager()) {
            response.sendRedirect(request.getContextPath() + "/error403.jsp");
            return;
        }
        
        try {
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            String notes = request.getParameter("notes");
            
            if (transactionDAO.rejectTransaction(transactionId, user.getUserId(), notes)) {
                // Log action
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("TRANSACTION_REJECT");
                log.setActionDescription("Transaction rejected: ID " + transactionId);
                log.setIpAddress(request.getRemoteAddr());
                log.setTableAffected("transactions");
                log.setRecordId(transactionId);
                auditLogDAO.logAction(log);
                
                request.setAttribute("success", "Transaction rejected");
            } else {
                request.setAttribute("error", "Failed to reject transaction");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input");
        }
        
        request.getRequestDispatcher("/manager/approvals.jsp").forward(request, response);
    }
}
