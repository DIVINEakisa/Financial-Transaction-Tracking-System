<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FTTS - Financial Transaction Tracking System | Secure Financial Management</title>
    <meta name="description" content="Professional financial transaction tracking system with advanced security, real-time analytics, and role-based access control.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css">
    <style>
        /* Hero Section Enhancement */
        .hero-modern {
            background: linear-gradient(135deg, #0B3D91 0%, #2ECC71 100%);
            padding: 120px 0 100px;
            position: relative;
            overflow: hidden;
            color: white;
        }
        
        .hero-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%23ffffff" fill-opacity="0.1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-size: cover;
            background-position: bottom;
            animation: wave 15s ease-in-out infinite;
        }
        
        @keyframes wave {
            0%, 100% { transform: translateX(0) translateY(0); }
            50% { transform: translateX(-25px) translateY(-10px); }
        }
        
        .hero-modern .container {
            position: relative;
            z-index: 2;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }
        
        .hero-text h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
            line-height: 1.2;
            animation: fadeInUp 1s ease;
        }
        
        .hero-text p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.95;
            animation: fadeInUp 1s ease 0.2s both;
        }
        
        .hero-buttons {
            display: flex;
            gap: 1rem;
            animation: fadeInUp 1s ease 0.4s both;
        }
        
        .hero-buttons .btn {
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        
        .hero-buttons .btn-primary {
            background: white;
            color: var(--navy-blue);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .hero-buttons .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        
        .hero-buttons .btn-secondary {
            background: transparent;
            border: 2px solid white;
            color: white;
        }
        
        .hero-buttons .btn-secondary:hover {
            background: white;
            color: var(--navy-blue);
        }
        
        .hero-image {
            position: relative;
            animation: fadeInRight 1s ease;
        }
        
        .hero-image img {
            width: 100%;
            max-width: 600px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .floating-card {
            position: absolute;
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: float 3s ease-in-out infinite;
        }
        
        .floating-card-1 {
            top: 10%;
            right: -10%;
            animation-delay: 0s;
        }
        
        .floating-card-2 {
            bottom: 15%;
            left: -10%;
            animation-delay: 1s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        /* About Section */
        .about-section {
            padding: 100px 0;
            background: white;
        }
        
        .about-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }
        
        .about-image img {
            width: 100%;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
        }
        
        .about-content h2 {
            font-size: 2.5rem;
            color: var(--navy-blue);
            margin-bottom: 1.5rem;
        }
        
        .about-content p {
            font-size: 1.1rem;
            color: var(--text-light);
            line-height: 1.8;
            margin-bottom: 1.5rem;
        }
        
        .about-features {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-top: 2rem;
        }
        
        .about-feature {
            display: flex;
            gap: 1rem;
            align-items: start;
        }
        
        .about-feature-icon {
            width: 50px;
            height: 50px;
            background: var(--gradient-primary);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        
        /* Services Section */
        .services-section {
            padding: 100px 0;
            background: var(--light-gray);
        }
        
        .section-header {
            text-align: center;
            max-width: 700px;
            margin: 0 auto 4rem;
        }
        
        .section-header h2 {
            font-size: 2.5rem;
            color: var(--navy-blue);
            margin-bottom: 1rem;
        }
        
        .section-header p {
            font-size: 1.1rem;
            color: var(--text-light);
        }
        
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .service-card {
            background: white;
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
        }
        
        .service-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient-primary);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            color: white;
        }
        
        .service-card h3 {
            font-size: 1.5rem;
            color: var(--navy-blue);
            margin-bottom: 1rem;
        }
        
        .service-card p {
            color: var(--text-light);
            line-height: 1.7;
        }
        
        /* How It Works */
        .how-it-works {
            padding: 100px 0;
            background: white;
        }
        
        .steps-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .step-card {
            text-align: center;
            position: relative;
        }
        
        .step-number {
            width: 80px;
            height: 80px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2rem;
            font-weight: bold;
            color: white;
            position: relative;
        }
        
        .step-card::after {
            content: '→';
            position: absolute;
            top: 40px;
            right: -1rem;
            font-size: 2rem;
            color: var(--emerald-green);
            opacity: 0.3;
        }
        
        .step-card:last-child::after {
            display: none;
        }
        
        .step-card h3 {
            font-size: 1.3rem;
            color: var(--navy-blue);
            margin-bottom: 0.5rem;
        }
        
        /* Testimonials */
        .testimonials-section {
            padding: 100px 0;
            background: var(--light-gray);
        }
        
        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }
        
        .testimonial-card {
            background: white;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            position: relative;
        }
        
        .quote-icon {
            font-size: 3rem;
            color: var(--emerald-green);
            opacity: 0.2;
            position: absolute;
            top: 1rem;
            right: 1rem;
        }
        
        .testimonial-text {
            font-style: italic;
            color: var(--text-light);
            margin-bottom: 1.5rem;
            line-height: 1.7;
        }
        
        .testimonial-author {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .author-avatar {
            width: 50px;
            height: 50px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
        }
        
        .author-info h4 {
            color: var(--navy-blue);
            font-size: 1rem;
            margin-bottom: 0.2rem;
        }
        
        .author-info p {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        /* CTA Section */
        .cta-section {
            padding: 80px 0;
            background: var(--gradient-primary);
            color: white;
            text-align: center;
        }
        
        .cta-section h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        
        .cta-section p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.95;
        }
        
        /* Enhanced Footer */
        .footer-enhanced {
            background: #0A2F6E;
            color: white;
            padding: 60px 0 20px;
        }
        
        .footer-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }
        
        .footer-section h4 {
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
        }
        
        .footer-section p, .footer-section a {
            color: rgba(255,255,255,0.8);
            margin-bottom: 0.8rem;
            display: block;
            transition: all 0.3s ease;
        }
        
        .footer-section a:hover {
            color: var(--emerald-green);
            padding-left: 5px;
        }
        
        .social-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .social-links a {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .social-links a:hover {
            background: var(--emerald-green);
            transform: translateY(-3px);
        }
        
        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 2rem;
            text-align: center;
            color: rgba(255,255,255,0.7);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hero-modern .container,
            .about-grid,
            .footer-grid {
                grid-template-columns: 1fr;
            }
            
            .hero-text h1 {
                font-size: 2.5rem;
            }
            
            .floating-card {
                display: none;
            }
        }
    </style>
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
                <li><a href="#home" class="active">Home</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="<%= request.getContextPath() %>/login.jsp">Login</a></li>
                <li><a href="<%= request.getContextPath() %>/register.jsp" class="btn-register">Register</a></li>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-modern" id="home">
        <div class="container">
            <div class="hero-text">
                <h1>Master Your Financial Future</h1>
                <p>Experience enterprise-grade financial management with cutting-edge security, real-time analytics, and intelligent automation. Take control of every transaction with confidence.</p>
                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary">
                        <i class="fas fa-rocket"></i> Get Started Free
                    </a>
                    <a href="#about" class="btn btn-secondary">
                        <i class="fas fa-play-circle"></i> Learn More
                    </a>
                </div>
            </div>
            <div class="hero-image">
                <svg viewBox="0 0 600 400" style="width: 100%; max-width: 600px;">
                    <!-- Dashboard Screen -->
                    <rect x="50" y="30" width="500" height="340" rx="20" fill="#fff" filter="url(#shadow)"/>
                    <rect x="50" y="30" width="500" height="60" rx="20" fill="#0B3D91"/>
                    
                    <!-- Charts -->
                    <circle cx="150" cy="180" r="60" fill="#2ECC71" opacity="0.3"/>
                    <circle cx="150" cy="180" r="40" fill="#2ECC71" opacity="0.6"/>
                    <circle cx="150" cy="180" r="20" fill="#2ECC71"/>
                    
                    <!-- Bar Chart -->
                    <rect x="280" y="240" width="40" height="100" rx="5" fill="#3498DB"/>
                    <rect x="330" y="180" width="40" height="160" rx="5" fill="#2ECC71"/>
                    <rect x="380" y="220" width="40" height="120" rx="5" fill="#F39C12"/>
                    <rect x="430" y="200" width="40" height="140" rx="5" fill="#E74C3C"/>
                    
                    <!-- Cards -->
                    <rect x="280" y="100" width="90" height="60" rx="10" fill="#E8F5E9"/>
                    <text x="325" y="130" text-anchor="middle" fill="#2ECC71" font-size="20" font-weight="bold">$24K</text>
                    <text x="325" y="150" text-anchor="middle" fill="#666" font-size="12">Income</text>
                    
                    <rect x="380" y="100" width="90" height="60" rx="10" fill="#FFEBEE"/>
                    <text x="425" y="130" text-anchor="middle" fill="#E74C3C" font-size="20" font-weight="bold">$18K</text>
                    <text x="425" y="150" text-anchor="middle" fill="#666" font-size="12">Expenses</text>
                    
                    <!-- Filter/Shadow -->
                    <defs>
                        <filter id="shadow">
                            <feDropShadow dx="0" dy="10" stdDeviation="20" flood-opacity="0.3"/>
                        </filter>
                    </defs>
                </svg>
                
                <!-- Floating Cards -->
                <div class="floating-card floating-card-1">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <div style="width: 50px; height: 50px; background: var(--gradient-success); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white;">
                            <i class="fas fa-check-circle" style="font-size: 1.5rem;"></i>
                        </div>
                        <div>
                            <div style="font-weight: bold; color: var(--navy-blue);">Transaction Approved</div>
                            <div style="font-size: 0.9rem; color: var(--text-light);">+$5,420.00</div>
                        </div>
                    </div>
                </div>
                
                <div class="floating-card floating-card-2">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <div style="width: 50px; height: 50px; background: var(--gradient-primary); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white;">
                            <i class="fas fa-shield-alt" style="font-size: 1.5rem;"></i>
                        </div>
                        <div>
                            <div style="font-weight: bold; color: var(--navy-blue);">Secure & Protected</div>
                            <div style="font-size: 0.9rem; color: var(--text-light);">256-bit Encryption</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="about-section" id="about" data-aos="fade-up">
        <div class="container">
            <div class="about-grid">
                <div class="about-image" data-aos="fade-right">
                    <svg viewBox="0 0 500 500">
                        <!-- Team Collaboration Illustration -->
                        <circle cx="250" cy="250" r="200" fill="#E8F5E9"/>
                        <!-- Person 1 -->
                        <circle cx="180" cy="200" r="40" fill="#0B3D91"/>
                        <rect x="150" y="240" width="60" height="80" rx="10" fill="#2ECC71"/>
                        <!-- Person 2 -->
                        <circle cx="320" cy="200" r="40" fill="#2ECC71"/>
                        <rect x="290" y="240" width="60" height="80" rx="10" fill="#0B3D91"/>
                        <!-- Documents -->
                        <rect x="210" y="320" width="80" height="60" rx="5" fill="#fff" stroke="#0B3D91" stroke-width="3"/>
                        <line x1="220" y1="340" x2="280" y2="340" stroke="#2ECC71" stroke-width="3"/>
                        <line x1="220" y1="355" x2="270" y2="355" stroke="#ccc" stroke-width="2"/>
                        <line x1="220" y1="365" x2="280" y2="365" stroke="#ccc" stroke-width="2"/>
                    </svg>
                </div>
                <div class="about-content" data-aos="fade-left">
                    <h2><i class="fas fa-building"></i> About FTTS</h2>
                    <p>The <strong>Financial Transaction Tracking System (FTTS)</strong> is an enterprise-grade platform designed to revolutionize how businesses and individuals manage their financial operations. Built with security-first principles and cutting-edge technology, FTTS provides comprehensive financial oversight with complete transparency.</p>
                    <p>Our system empowers organizations with intelligent approval workflows, real-time fraud detection, and detailed audit trails. Whether you're managing personal finances or overseeing complex corporate transactions, FTTS delivers the tools you need to make informed financial decisions.</p>
                    
                    <div class="about-features">
                        <div class="about-feature" data-aos="fade-up" data-aos-delay="100">
                            <div class="about-feature-icon">
                                <i class="fas fa-award"></i>
                            </div>
                            <div>
                                <h4 style="color: var(--navy-blue); margin-bottom: 0.3rem;">Trusted Platform</h4>
                                <p style="color: var(--text-light); font-size: 0.95rem;">Used by thousands of businesses worldwide</p>
                            </div>
                        </div>
                        <div class="about-feature" data-aos="fade-up" data-aos-delay="200">
                            <div class="about-feature-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div>
                                <h4 style="color: var(--navy-blue); margin-bottom: 0.3rem;">24/7 Support</h4>
                                <p style="color: var(--text-light); font-size: 0.95rem;">Round-the-clock customer assistance</p>
                            </div>
                        </div>
                        <div class="about-feature" data-aos="fade-up" data-aos-delay="300">
                            <div class="about-feature-icon">
                                <i class="fas fa-globe"></i>
                            </div>
                            <div>
                                <h4 style="color: var(--navy-blue); margin-bottom: 0.3rem;">Global Reach</h4>
                                <p style="color: var(--text-light); font-size: 0.95rem;">Multi-currency support for international transactions</p>
                            </div>
                        </div>
                        <div class="about-feature" data-aos="fade-up" data-aos-delay="400">
                            <div class="about-feature-icon">
                                <i class="fas fa-certificate"></i>
                            </div>
                            <div>
                                <h4 style="color: var(--navy-blue); margin-bottom: 0.3rem;">Certified Secure</h4>
                                <p style="color: var(--text-light); font-size: 0.95rem;">ISO 27001 and SOC 2 compliant</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section class="services-section" id="services">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <h2><i class="fas fa-concierge-bell"></i> Our Services</h2>
                <p>Comprehensive financial management solutions tailored to your needs</p>
            </div>
            
            <div class="services-grid">
                <div class="service-card" data-aos="fade-up" data-aos-delay="100">
                    <div class="service-icon">
                        <i class="fas fa-money-check-alt"></i>
                    </div>
                    <h3>Transaction Management</h3>
                    <p>Track income and expenses with automated categorization, receipt attachments, and instant notifications for every transaction.</p>
                </div>
                
                <div class="service-card" data-aos="fade-up" data-aos-delay="200">
                    <div class="service-icon">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <h3>Approval Workflows</h3>
                    <p>Multi-level approval system with configurable thresholds. Large transactions automatically route to managers for authorization.</p>
                </div>
                
                <div class="service-card" data-aos="fade-up" data-aos-delay="300">
                    <div class="service-icon">
                        <i class="fas fa-chart-pie"></i>
                    </div>
                    <h3>Financial Analytics</h3>
                    <p>Interactive dashboards with real-time charts, spending patterns, income trends, and customizable financial reports.</p>
                </div>
                
                <div class="service-card" data-aos="fade-up" data-aos-delay="400">
                    <div class="service-icon">
                        <i class="fas fa-file-export"></i>
                    </div>
                    <h3>Report Generation</h3>
                    <p>Export detailed financial reports in PDF and Excel formats. Generate monthly statements, tax documents, and compliance reports.</p>
                </div>
                
                <div class="service-card" data-aos="fade-up" data-aos-delay="500">
                    <div class="service-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3>Fraud Detection</h3>
                    <p>AI-powered suspicious activity monitoring with automatic alerts for unusual patterns, duplicate transactions, and potential threats.</p>
                </div>
                
                <div class="service-card" data-aos="fade-up" data-aos-delay="600">
                    <div class="service-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3>Audit Trails</h3>
                    <p>Complete activity logging for compliance. Track every action, modification, and access with timestamps and user information.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <h2><i class="fas fa-cogs"></i> How It Works</h2>
                <p>Get started in minutes with our simple 4-step process</p>
            </div>
            
            <div class="steps-grid">
                <div class="step-card" data-aos="zoom-in" data-aos-delay="100">
                    <div class="step-number">1</div>
                    <h3>Create Account</h3>
                    <p>Sign up with your email and create a secure password. It takes less than 2 minutes to get started.</p>
                </div>
                
                <div class="step-card" data-aos="zoom-in" data-aos-delay="200">
                    <div class="step-number">2</div>
                    <h3>Add Accounts</h3>
                    <p>Connect your bank accounts, cash wallets, and credit cards to start tracking all your finances in one place.</p>
                </div>
                
                <div class="step-card" data-aos="zoom-in" data-aos-delay="300">
                    <div class="step-number">3</div>
                    <h3>Record Transactions</h3>
                    <p>Add income and expenses with categorization. Upload receipts and add descriptions for better tracking.</p>
                </div>
                
                <div class="step-card" data-aos="zoom-in" data-aos-delay="400">
                    <div class="step-number">4</div>
                    <h3>Monitor & Analyze</h3>
                    <p>View real-time dashboards, generate reports, and gain insights into your spending patterns and savings.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <h2><i class="fas fa-star"></i> Key Features</h2>
                <p>Everything you need to manage your finances effectively</p>
            </div>
            <div class="features-grid">
                <div class="feature-card" data-aos="flip-left" data-aos-delay="100">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Bank-Level Security</h3>
                    <p>256-bit AES encryption, BCrypt password hashing, CSRF protection, and XSS filtering for complete security.</p>
                </div>
                
                <div class="feature-card" data-aos="flip-left" data-aos-delay="200">
                    <div class="feature-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <h3>Real-Time Reports</h3>
                    <p>Interactive dashboards with income/expense analytics, spending patterns, and exportable PDF/Excel reports.</p>
                </div>
                
                <div class="feature-card" data-aos="flip-left" data-aos-delay="300">
                    <div class="feature-icon">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <h3>Role-Based Access</h3>
                    <p>Multi-level user roles (User, Manager, Admin) with granular permissions and approval workflows.</p>
                </div>
                
                <div class="feature-card" data-aos="flip-left" data-aos-delay="400">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Fraud Prevention</h3>
                    <p>Automated suspicious activity detection with real-time alerts and automatic account locking mechanisms.</p>
                </div>
                
                <div class="feature-card" data-aos="flip-left" data-aos-delay="500">
                    <div class="feature-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h3>Smart Approvals</h3>
                    <p>Configurable transaction thresholds with automatic routing to managers for large amount approvals.</p>
                </div>
                
                <div class="feature-card" data-aos="flip-left" data-aos-delay="600">
                    <div class="feature-icon">
                        <i class="fas fa-history"></i>
                    </div>
                    <h3>Complete Audit Trail</h3>
                    <p>Every action logged with timestamps, user info, and IP addresses for compliance and security monitoring.</p>
                </div>

                <div class="feature-card" data-aos="flip-left" data-aos-delay="700">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>Responsive Design</h3>
                    <p>Works seamlessly across all devices - desktop, tablet, and mobile for on-the-go financial management.</p>
                </div>

                <div class="feature-card" data-aos="flip-left" data-aos-delay="800">
                    <div class="feature-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <h3>Smart Notifications</h3>
                    <p>Get instant alerts for transactions, approvals, suspicious activities, and important financial events.</p>
                </div>

                <div class="feature-card" data-aos="flip-left" data-aos-delay="900">
                    <div class="feature-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <h3>Category Management</h3>
                    <p>Organize transactions with customizable categories for better tracking and detailed financial insights.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials-section" id="testimonials">
        <div class="container">
            <div class="section-header" data-aos="fade-up">
                <h2><i class="fas fa-comments"></i> What Our Users Say</h2>
                <p>Join thousands of satisfied customers managing their finances with FTTS</p>
            </div>
            
            <div class="testimonials-grid">
                <div class="testimonial-card" data-aos="fade-up" data-aos-delay="100">
                    <i class="fas fa-quote-right quote-icon"></i>
                    <p class="testimonial-text">"FTTS has completely transformed how we manage our company finances. The approval workflow and audit trails have made compliance so much easier. Highly recommended!"</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">SJ</div>
                        <div class="author-info">
                            <h4>Sarah Johnson</h4>
                            <p>CFO, Tech Innovations Inc</p>
                        </div>
                    </div>
                </div>
                
                <div class="testimonial-card" data-aos="fade-up" data-aos-delay="200">
                    <i class="fas fa-quote-right quote-icon"></i>
                    <p class="testimonial-text">"The fraud detection feature saved us from a major financial loss. The system caught suspicious activity that we wouldn't have noticed. Best investment we've made!"</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">MC</div>
                        <div class="author-info">
                            <h4>Michael Chen</h4>
                            <p>Financial Manager, Global Corp</p>
                        </div>
                    </div>
                </div>
                
                <div class="testimonial-card" data-aos="fade-up" data-aos-delay="300">
                    <i class="fas fa-quote-right quote-icon"></i>
                    <p class="testimonial-text">"As a small business owner, FTTS gives me complete visibility into my finances. The reports are detailed and easy to understand. It's like having a financial advisor 24/7!"</p>
                    <div class="testimonial-author">
                        <div class="author-avatar">ED</div>
                        <div class="author-info">
                            <h4>Emily Davis</h4>
                            <p>Owner, Davis Consulting</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Active Users</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-number">$50M+</div>
                    <div class="stat-label">Transactions Tracked</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Uptime</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="400">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Support</div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section" data-aos="zoom-in">
        <div class="container">
            <h2>Ready to Take Control of Your Finances?</h2>
            <p>Join thousands of users who trust FTTS for their financial management needs</p>
            <div class="hero-buttons">
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> Create Free Account
                </a>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-secondary">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </a>
            </div>
        </div>
    </section>

    <!-- Enhanced Footer -->
    <footer class="footer-enhanced">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-section">
                    <h4><i class="fas fa-chart-line"></i> FTTS</h4>
                    <p>Professional Financial Transaction Tracking System. Secure, intelligent, and reliable financial management for businesses and individuals.</p>
                    <div class="social-links">
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="GitHub"><i class="fab fa-github"></i></a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <a href="#about"><i class="fas fa-chevron-right"></i> About Us</a>
                    <a href="#services"><i class="fas fa-chevron-right"></i> Services</a>
                    <a href="#features"><i class="fas fa-chevron-right"></i> Features</a>
                    <a href="#testimonials"><i class="fas fa-chevron-right"></i> Testimonials</a>
                </div>
                
                <div class="footer-section">
                    <h4>Support</h4>
                    <a href="#"><i class="fas fa-chevron-right"></i> Help Center</a>
                    <a href="#"><i class="fas fa-chevron-right"></i> Documentation</a>
                    <a href="#"><i class="fas fa-chevron-right"></i> Privacy Policy</a>
                    <a href="#"><i class="fas fa-chevron-right"></i> Terms of Service</a>
                </div>
                
                <div class="footer-section">
                    <h4>Contact</h4>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Financial Street, Business District</p>
                    <p><i class="fas fa-envelope"></i> support@ftts.com</p>
                    <p><i class="fas fa-phone"></i> +1 (555) 123-4567</p>
                    <p><i class="fas fa-clock"></i> Mon-Fri: 9:00 AM - 6:00 PM</p>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2026 Financial Transaction Tracking System. All rights reserved. | Built with <i class="fas fa-heart" style="color: #E74C3C;"></i> for better financial management</p>
            </div>
        </div>
    </footer>

    <!-- AOS Animation Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 800,
            offset: 100,
            once: true
        });

        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Active nav link on scroll
        window.addEventListener('scroll', () => {
            let current = '';
            const sections = document.querySelectorAll('section[id]');
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.clientHeight;
                if (pageYOffset >= (sectionTop - 200)) {
                    current = section.getAttribute('id');
                }
            });

            document.querySelectorAll('.nav-menu a').forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('href').includes(current)) {
                    link.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>
