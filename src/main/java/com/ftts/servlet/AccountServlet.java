package com.ftts.servlet;

import com.ftts.dao.AccountDAO;
import com.ftts.dao.AuditLogDAO;
import com.ftts.model.Account;
import com.ftts.model.AuditLog;
import com.ftts.model.User;
import com.ftts.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Account Servlet
 * Handles account operations
 */
@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();
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
            addAccount(request, response, user);
        } else if ("update".equals(action)) {
            updateAccount(request, response, user);
        } else if ("delete".equals(action)) {
            deleteAccount(request, response, user);
        }
    }
    
    private void addAccount(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        String accountName = request.getParameter("accountName");
        String accountType = request.getParameter("accountType");
        String balanceStr = request.getParameter("balance");
        
        // Validation
        if (!ValidationUtil.isValidAccountName(accountName)) {
            request.setAttribute("error", "Invalid account name");
            request.getRequestDispatcher("/accounts.jsp").forward(request, response);
            return;
        }
        
        if (!ValidationUtil.isValidAccountType(accountType)) {
            request.setAttribute("error", "Invalid account type");
            request.getRequestDispatcher("/accounts.jsp").forward(request, response);
            return;
        }
        
        BigDecimal balance = BigDecimal.ZERO;
        if (balanceStr != null && !balanceStr.isEmpty()) {
            try {
                balance = new BigDecimal(balanceStr);
                if (balance.compareTo(BigDecimal.ZERO) < 0) {
                    request.setAttribute("error", "Balance cannot be negative");
                    request.getRequestDispatcher("/accounts.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid balance format");
                request.getRequestDispatcher("/accounts.jsp").forward(request, response);
                return;
            }
        }
        
        // Create account
        Account account = new Account();
        account.setUserId(user.getUserId());
        account.setAccountName(accountName);
        account.setAccountType(accountType);
        account.setBalance(balance);
        account.setCurrency("USD");
        account.setStatus("Active");
        
        if (accountDAO.createAccount(account)) {
            // Log action
            AuditLog log = new AuditLog();
            log.setUserId(user.getUserId());
            log.setActionType("ACCOUNT_ADD");
            log.setActionDescription("Account created: " + accountName);
            log.setIpAddress(request.getRemoteAddr());
            log.setTableAffected("accounts");
            log.setRecordId(account.getAccountId());
            auditLogDAO.logAction(log);
            
            request.setAttribute("success", "Account created successfully");
        } else {
            request.setAttribute("error", "Failed to create account");
        }
        
        request.getRequestDispatcher("/accounts.jsp").forward(request, response);
    }
    
    private void updateAccount(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            String accountName = request.getParameter("accountName");
            String accountType = request.getParameter("accountType");
            
            // Verify ownership
            if (!accountDAO.verifyAccountOwnership(accountId, user.getUserId())) {
                request.setAttribute("error", "Unauthorized action");
                request.getRequestDispatcher("/accounts.jsp").forward(request, response);
                return;
            }
            
            Account account = accountDAO.getAccountById(accountId);
            account.setAccountName(accountName);
            account.setAccountType(accountType);
            
            if (accountDAO.updateAccount(account)) {
                // Log action
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("ACCOUNT_UPDATE");
                log.setActionDescription("Account updated: " + accountName);
                log.setIpAddress(request.getRemoteAddr());
                log.setTableAffected("accounts");
                log.setRecordId(accountId);
                auditLogDAO.logAction(log);
                
                request.setAttribute("success", "Account updated successfully");
            } else {
                request.setAttribute("error", "Failed to update account");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input");
        }
        
        request.getRequestDispatcher("/accounts.jsp").forward(request, response);
    }
    
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            
            // Verify ownership
            if (!accountDAO.verifyAccountOwnership(accountId, user.getUserId())) {
                request.setAttribute("error", "Unauthorized action");
                request.getRequestDispatcher("/accounts.jsp").forward(request, response);
                return;
            }
            
            if (accountDAO.deleteAccount(accountId)) {
                // Log action
                AuditLog log = new AuditLog();
                log.setUserId(user.getUserId());
                log.setActionType("ACCOUNT_DELETE");
                log.setActionDescription("Account deleted: ID " + accountId);
                log.setIpAddress(request.getRemoteAddr());
                log.setTableAffected("accounts");
                log.setRecordId(accountId);
                auditLogDAO.logAction(log);
                
                request.setAttribute("success", "Account deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete account");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input");
        }
        
        request.getRequestDispatcher("/accounts.jsp").forward(request, response);
    }
}
