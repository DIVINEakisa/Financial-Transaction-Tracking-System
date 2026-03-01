# Financial Transaction Tracking System (FTTS)

<div align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/Java-11-orange.svg" alt="Java">
  <img src="https://img.shields.io/badge/JSP-2.3-green.svg" alt="JSP">
  <img src="https://img.shields.io/badge/MySQL-8.0-blue.svg" alt="MySQL">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-success.svg" alt="Status">
</div>

## 📋 Overview

The **Financial Transaction Tracking System (FTTS)** is a comprehensive web-based application designed to help users securely record, manage, and monitor financial transactions including income, expenses, and transfers. Built with enterprise-grade security features, it implements a robust three-tier MVC architecture with role-based access control.

### Key Highlights
- ✅ **Secure Authentication** with BCrypt password hashing
- ✅ **Role-Based Access Control** (User, Manager, Admin)
- ✅ **Multi-level Approval System** for large transactions
- ✅ **Fraud Detection** with suspicious activity monitoring
- ✅ **Real-time Dashboard** with analytics
- ✅ **Comprehensive Audit Logging** for compliance
- ✅ **Professional UI** with Navy Blue & Emerald Green theme

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | JSP, HTML5, CSS3, JavaScript, Chart.js |
| **Backend** | Java 11, Servlets 4.0, JSTL |
| **Database** | MySQL 8.0 |
| **Security** | BCrypt, CSRF Tokens, Session Management |
| **Build Tool** | Maven 3.6+ |
| **Server** | Apache Tomcat 9.0+ |

## 📦 Quick Start

### Prerequisites
- JDK 11+
- Apache Tomcat 9.0+
- MySQL 8.0+
- Maven 3.6+

### Installation
```bash
# 1. Setup Database
mysql -u root -p < database/schema.sql

# 2. Configure
# Edit src/main/resources/db.properties with your MySQL credentials

# 3. Build
mvn clean install

# 4. Deploy
# Copy target/ftts.war to TOMCAT_HOME/webapps/

# 5. Access
# http://localhost:8080/ftts/
```

### Default Login
- **Admin**: admin@ftts.com / Admin@123
- **Manager**: manager@ftts.com / Admin@123

## ✨ Key Features

### Security
- BCrypt password hashing
- SQL injection prevention (PreparedStatements)
- XSS protection (input sanitization)
- CSRF token validation
- Session management (15-min timeout)
- Failed login attempt tracking
- Suspicious activity detection

### Business Features
- Multiple account types (Bank, Cash, Mobile Money)
- Income/Expense/Transfer tracking
- Category-based organization
- Large transaction approval (>$1M)
- Real-time balance tracking
- Monthly analytics & reports
- PDF/Excel export
- Complete audit trail

## 📁 Project Structure
```
├── database/schema.sql          # Database schema
├── src/main/java/com/ftts/
│   ├── dao/                     # Data Access Layer
│   ├── filter/                  # Security Filters
│   ├── model/                   # JavaBeans
│   ├── servlet/                 # Controllers
│   └── util/                    # Utilities
├── src/main/webapp/
│   ├── WEB-INF/web.xml         # Deployment descriptor
│   ├── css/style.css           # Professional styling
│   └── *.jsp                   # View pages
└── pom.xml                     # Maven config
```

## 🔒 Security Architecture

```
Request → XSS Filter → CSRF Filter → Auth Filter → Authorization Filter → Servlet
             ↓            ↓             ↓                ↓                  ↓
         Sanitize     Validate     Check Login      Check Role          Business
         Input        Token        Session          Permission          Logic
```

## 📊 Database Schema

**Core Tables:**
- `users` - Authentication & user info
- `accounts` - Financial accounts
- `transactions` - All transactions
- `categories` - Income/Expense categories
- `audit_log` - Activity tracking
- `suspicious_activities` - Fraud detection

## 🎨 Color Theme
- **Primary**: #0B3D91 (Navy Blue)
- **Secondary**: #2ECC71 (Emerald Green)
- **Accent**: #F1C40F (Gold)
- **Background**: #F4F6F9 (Light Gray)
- **Danger**: #E74C3C (Red)

## 📞 Support
Create an issue in the repository for support.

---
<div align="center">
  <strong>Built with ❤️ for Academic Excellence</strong><br>
  <sub>© 2026 Financial Transaction Tracking System</sub>
</div>
