<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Aura | Admin Studio</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --ivory: #F8F5F2;
            --white: #FFFFFF;
            --mocha: #51352F;
            --mocha-light: #754D43;
            --text: #302923;
            --muted: #82756D;
            --border: #EAE1DB;
            --rose: #F2E5DF;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            color: var(--text);
            background:
                radial-gradient(
                    circle at 92% 5%,
                    rgba(220, 195, 179, 0.24),
                    transparent 27%
                ),
                var(--ivory);
        }

        a {
            color: inherit;
        }

        /* TOP NAVIGATION */

        .topbar {
            position: sticky;
            top: 0;
            z-index: 10;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            padding: 17px 5.5%;
            background: rgba(255, 255, 255, 0.93);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(14px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
        }

        .brand-mark {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            flex-shrink: 0;
            background: var(--mocha);
            color: white;
            border-radius: 13px;
            font-family: 'Playfair Display', serif;
            font-size: 25px;
            box-shadow: 0 5px 12px rgba(81, 53, 47, 0.18);
        }

        .brand-name {
            display: block;
            font-family: 'Playfair Display', serif;
            font-size: 23px;
            font-weight: 700;
            letter-spacing: 1.2px;
        }

        .brand-caption {
            display: block;
            margin-top: 2px;
            color: var(--muted);
            font-size: 9px;
            font-weight: 500;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .topbar-actions {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 13px 8px 8px;
            background: #F8F4F1;
            border: 1px solid var(--border);
            border-radius: 30px;
        }

        .profile-avatar {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: var(--mocha);
            color: white;
            font-size: 12px;
            font-weight: 600;
        }

        .profile-name {
            font-size: 12px;
            font-weight: 600;
        }

        .profile-role {
            margin-top: 2px;
            color: var(--muted);
            font-size: 10px;
        }

        .logout-form {
            margin: 0;
        }

        .logout-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 16px;
            border: 1px solid #E4CEC4;
            border-radius: 26px;
            background: #FFFFFF;
            color: var(--mocha);
            font-family: 'Poppins', sans-serif;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
            transition: background 0.2s ease,
                        color 0.2s ease,
                        transform 0.2s ease;
        }

        .logout-btn:hover {
            background: var(--mocha);
            border-color: var(--mocha);
            color: #FFFFFF;
            transform: translateY(-1px);
        }

        .logout-btn svg {
            width: 16px;
            height: 16px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.8;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .logout-btn:focus-visible {
            outline: 3px solid var(--mocha-light);
            outline-offset: 3px;
        }

        /* MAIN LAYOUT */

        .dashboard {
            width: 100%;
            max-width: 1260px;
            margin: 0 auto;
            padding: 45px 35px 30px;
        }

        /* WELCOME SECTION */

        .hero {
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 25px;
            padding: 37px 40px;
            margin-bottom: 37px;
            border-radius: 22px;
            background:
                linear-gradient(
                    115deg,
                    #51352F 0%,
                    #68473F 58%,
                    #805D51 100%
                );
            color: white;
            box-shadow: 0 12px 30px rgba(81, 53, 47, 0.13);
        }

        .hero::after {
            content: "A";
            position: absolute;
            right: 42px;
            top: -83px;
            color: rgba(255, 255, 255, 0.055);
            font-family: 'Playfair Display', serif;
            font-size: 300px;
            line-height: 1.2;
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 13px;
            color: #EBD6C9;
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 2.3px;
            text-transform: uppercase;
        }

        .eyebrow-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #DDBB9C;
        }

        .hero h1 {
            margin: 0 0 12px;
            font-family: 'Playfair Display', serif;
            font-size: clamp(28px, 3.2vw, 43px);
            font-weight: 600;
            line-height: 1.2;
        }

        .hero p {
            max-width: 520px;
            margin: 0;
            color: #E9DCD5;
            font-size: 13px;
            line-height: 1.9;
        }

        .hero-decoration {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            width: 104px;
            height: 104px;
            border: 1px solid rgba(255, 255, 255, 0.23);
            border-radius: 50%;
            color: #F0DDD1;
            font-family: 'Playfair Display', serif;
            font-size: 48px;
        }

        /* SECTION HEADER */

        .section-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 21px;
        }

        .section-heading h2 {
            margin: 0 0 6px;
            font-family: 'Playfair Display', serif;
            font-size: 25px;
            font-weight: 600;
        }

        .section-heading p {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.7;
        }

        .module-count {
            padding: 8px 12px;
            border: 1px solid var(--border);
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.75);
            color: var(--mocha);
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* MODULE CARDS */

        .cards {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 19px;
        }

        .card {
            position: relative;
            display: flex;
            flex-direction: column;
            min-width: 0;
            min-height: 235px;
            padding: 24px 20px 20px;
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 17px;
            background: var(--white);
            box-shadow: 0 4px 16px rgba(48, 41, 35, 0.035);
            text-decoration: none;
            transition:
                transform 0.23s ease,
                box-shadow 0.23s ease,
                border-color 0.23s ease;
        }

        .card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--mocha);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.23s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            border-color: #D9C2B5;
            box-shadow: 0 15px 30px rgba(81, 53, 47, 0.09);
        }

        .card:hover::before {
            transform: scaleX(1);
        }

        .card:focus-visible {
            outline: 3px solid var(--mocha-light);
            outline-offset: 4px;
        }

        .card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 25px;
        }

        .card-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 53px;
            height: 53px;
            flex-shrink: 0;
            border-radius: 15px;
            background: var(--rose);
            color: var(--mocha);
            transition:
                transform 0.23s ease,
                background 0.23s ease;
        }

        .card:hover .card-icon {
            transform: scale(1.06);
            background: #EBD8CE;
        }

        .card-icon svg {
            width: 25px;
            height: 25px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.7;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .card-arrow {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border: 1px solid #EEE7E2;
            border-radius: 50%;
            color: #927F74;
            font-size: 16px;
            transition:
                color 0.23s ease,
                background 0.23s ease,
                transform 0.23s ease;
        }

        .card:hover .card-arrow {
            transform: translate(2px, -2px);
            background: var(--mocha);
            border-color: var(--mocha);
            color: white;
        }

        .card-label {
            margin-bottom: 7px;
            color: var(--muted);
            font-size: 10px;
            font-weight: 500;
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        .card h3 {
            margin: 0 0 9px;
            font-family: 'Playfair Display', serif;
            font-size: 23px;
            font-weight: 600;
        }

        .card p {
            margin: 0;
            color: #82756D;
            font-size: 11px;
            line-height: 1.8;
        }

        .card-footer {
            display: flex;
            align-items: center;
            gap: 7px;
            margin-top: auto;
            padding-top: 22px;
            color: var(--mocha);
            font-size: 11px;
            font-weight: 600;
        }

        .footer-arrow {
            font-size: 15px;
            transition: transform 0.2s ease;
        }

        .card:hover .footer-arrow {
            transform: translateX(4px);
        }

        /* FOOTER */

        .dashboard-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 39px;
            padding-top: 19px;
            border-top: 1px solid var(--border);
            color: #93847B;
            font-size: 10px;
        }

        .footer-brand {
            color: var(--mocha);
            font-family: 'Playfair Display', serif;
            font-size: 15px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        /* RESPONSIVE DESIGN */

        @media (max-width: 1050px) {
            .cards {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .card {
                min-height: 220px;
            }
        }

        @media (max-width: 600px) {
            .topbar {
                padding: 14px 18px;
            }

            .brand-name {
                font-size: 20px;
            }

            .topbar-actions {
                gap: 8px;
            }

            .admin-profile {
                padding: 6px;
            }

            .profile-details {
                display: none;
            }

            .logout-btn {
                padding: 9px 11px;
                font-size: 11px;
            }

            .dashboard {
                padding: 25px 16px;
            }

            .hero {
                padding: 27px 23px;
                margin-bottom: 30px;
                border-radius: 17px;
            }

            .hero-decoration {
                width: 65px;
                height: 65px;
                font-size: 34px;
            }

            .hero::after {
                right: -15px;
                top: -45px;
                font-size: 200px;
            }

            .hero h1 {
                font-size: 29px;
            }

            .hero p {
                font-size: 12px;
            }

            .section-heading h2 {
                font-size: 23px;
            }

            .cards {
                gap: 12px;
            }

            .card {
                min-height: 215px;
                padding: 17px 14px;
                border-radius: 13px;
            }

            .card-top {
                margin-bottom: 19px;
            }

            .card-icon {
                width: 44px;
                height: 44px;
            }

            .card h3 {
                font-size: 21px;
            }

            .card p {
                font-size: 10px;
            }

            .card-footer {
                padding-top: 17px;
                font-size: 10px;
            }

            .dashboard-footer {
                margin-top: 28px;
            }
        }

        @media (max-width: 350px) {
            .cards {
                grid-template-columns: 1fr;
            }

            .card {
                min-height: 195px;
                padding: 22px;
            }

            .hero-decoration {
                display: none;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                transition: none !important;
            }
        }
    </style>
</head>

<body>

<header class="topbar">

    <a class="brand"
       href="${pageContext.request.contextPath}/admin/dashboard"
       aria-label="Aura Admin Dashboard">

        <span class="brand-mark">A</span>

        <span>
            <span class="brand-name">AURA</span>
            <span class="brand-caption">Admin Studio</span>
        </span>
    </a>

    <div class="topbar-actions">

        <div class="admin-profile">
            <div class="profile-avatar">A</div>
            <div class="profile-details">
                <div class="profile-name">Administrator</div>
                <div class="profile-role">Store Management</div>
            </div>
        </div>

        <form class="logout-form"
              method="post"
              action="${pageContext.request.contextPath}/logout">

            <button type="submit" class="logout-btn">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                    <polyline points="16 17 21 12 16 7"/>
                    <line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
                Logout
            </button>

        </form>

    </div>

</header>

<main class="dashboard">

    <!-- WELCOME HERO -->

    <section class="hero">

        <div class="hero-content">

            <div class="eyebrow">
                <span class="eyebrow-dot"></span>
                Aura Control Center
            </div>

            <h1>Welcome back, Admin</h1>

            <p>
                Manage your collection, oversee customer orders,
                explore registered accounts, and understand your
                store performance—all from one place
            </p>

        </div>

        <div class="hero-decoration" aria-hidden="true">
            A
        </div>

    </section>

    <!-- MODULES -->

    <section aria-labelledby="modules-heading">

        <div class="section-heading">

            <div>
                <h2 id="modules-heading">Your Workspace</h2>
                <p>Everything you need to manage the Aura store</p>
            </div>

            <span class="module-count">04 MODULES</span>

        </div>

        <div class="cards">

            <!-- PRODUCTS -->

            <a href="${pageContext.request.contextPath}/admin/products"
               class="card">

                <div class="card-top">
                    <div class="card-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M8 4.5 12 3l4 1.5 4 4-3 3-2-2v11H9V9.5l-2 2-3-3 4-4Z"/>
                            <path d="M9 9.5 12 12l3-2.5"/>
                        </svg>
                    </div>
                    <span class="card-arrow" aria-hidden="true">↗</span>
                </div>

                <div class="card-label">Catalogue</div>
                <h3>Products</h3>
                <p>Manage dresses, product details, prices, and available sizes</p>

                <div class="card-footer">
                    Manage collection <span class="footer-arrow">→</span>
                </div>

            </a>

            <!-- ORDERS -->

            <a href="${pageContext.request.contextPath}/admin/orders"
               class="card">

                <div class="card-top">
                    <div class="card-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 8 12 4l8 4-8 4-8-4Z"/>
                            <path d="M4 8v9l8 4 8-4V8"/>
                            <path d="M12 12v9"/>
                            <path d="m8 6 8 4"/>
                        </svg>
                    </div>
                    <span class="card-arrow" aria-hidden="true">↗</span>
                </div>

                <div class="card-label">Fulfilment</div>
                <h3>Orders</h3>
                <p>Review customer purchases and manage order statuses</p>

                <div class="card-footer">
                    View orders <span class="footer-arrow">→</span>
                </div>

            </a>

            <!-- USERS -->

            <a href="${pageContext.request.contextPath}/admin/users"
               class="card">

                <div class="card-top">
                    <div class="card-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <circle cx="9" cy="8" r="3.2"/>
                            <path d="M3 20v-1.5A5.5 5.5 0 0 1 8.5 13h1A5.5 5.5 0 0 1 15 18.5V20"/>
                            <path d="M16 5.2a3.2 3.2 0 0 1 0 6.1"/>
                            <path d="M17 14a5 5 0 0 1 4 4.9V20"/>
                        </svg>
                    </div>
                    <span class="card-arrow" aria-hidden="true">↗</span>
                </div>

                <div class="card-label">Community</div>
                <h3>Users</h3>
                <p>View registered accounts, customer details, and account roles</p>

                <div class="card-footer">
                    View customers <span class="footer-arrow">→</span>
                </div>

            </a>

            <!-- ANALYTICS -->

            <a href="${pageContext.request.contextPath}/admin/analytics"
               class="card">

                <div class="card-top">
                    <div class="card-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 19V5"/>
                            <path d="M4 19h17"/>
                            <rect x="7" y="11" width="3" height="5" rx=".5"/>
                            <rect x="12" y="7" width="3" height="9" rx=".5"/>
                            <rect x="17" y="4" width="3" height="12" rx=".5"/>
                        </svg>
                    </div>
                    <span class="card-arrow" aria-hidden="true">↗</span>
                </div>

                <div class="card-label">Insights</div>
                <h3>Analytics</h3>
                <p>Explore store statistics and understand your order performance</p>

                <div class="card-footer">
                    View insights <span class="footer-arrow">→</span>
                </div>

            </a>

        </div>

    </section>

    <!-- FOOTER -->

    <footer class="dashboard-footer">

        <span class="footer-brand">AURA</span>

        <span>Admin Studio &bull; Fashion, thoughtfully managed</span>

    </footer>

</main>

</body>
</html>
