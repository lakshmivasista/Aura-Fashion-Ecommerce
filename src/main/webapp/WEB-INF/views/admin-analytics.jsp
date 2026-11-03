
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.Map, java.util.Locale" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aura | Store Analytics</title>

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
            --green: #397650;
            --red: #AD4941;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            background:
                radial-gradient(
                    circle at 92% 5%,
                    rgba(220, 195, 179, 0.20),
                    transparent 27%
                ),
                var(--ivory);
            color: var(--text);
            font-family: 'Poppins', sans-serif;
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
            padding: 15px 5.5%;
            background: rgba(255, 255, 255, 0.94);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(14px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text);
        }

        .brand-mark {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            flex-shrink: 0;
            border-radius: 13px;
            background: var(--mocha);
            color: white;
            font-family: 'Playfair Display', serif;
            font-size: 25px;
            box-shadow: 0 5px 12px rgba(81, 53, 47, 0.16);
        }

        .brand-name {
            display: block;
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 1.2px;
        }

        .brand-caption {
            display: block;
            margin-top: 2px;
            color: var(--muted);
            font-size: 9px;
            letter-spacing: 1.8px;
            text-transform: uppercase;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 16px;
            border: 1px solid var(--mocha);
            border-radius: 8px;
            background: var(--mocha);
            color: white;
            text-decoration: none;
            font-size: 11px;
            font-weight: 500;
            transition: background 0.2s ease;
        }

        .back-btn:hover {
            background: var(--mocha-light);
        }

        /* MAIN LAYOUT */

        .page-container {
            width: 100%;
            max-width: 1260px;
            margin: 0 auto;
            padding: 38px 35px 25px;
        }

        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            flex-wrap: wrap;
            gap: 18px;
            margin-bottom: 31px;
        }

        .eyebrow {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 9px;
            color: var(--mocha-light);
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .eyebrow-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #B88A6C;
        }

        .page-heading h1 {
            margin: 0 0 9px;
            font-family: 'Playfair Display', serif;
            font-size: clamp(29px, 3vw, 39px);
            font-weight: 600;
        }

        .subtitle {
            margin: 0;
            max-width: 620px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.8;
        }

        .section-heading {
            margin: 0 0 7px;
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 600;
        }

        .section-description {
            margin: 0 0 20px;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.8;
        }

        /* STAT CARDS */

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 33px;
        }

        .stat-card {
            position: relative;
            min-width: 0;
            padding: 23px;
            overflow: hidden;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(48, 41, 35, 0.035);
            transition:
                transform 0.22s ease,
                box-shadow 0.22s ease,
                border-color 0.22s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            border-color: #D9C2B5;
            box-shadow: 0 12px 25px rgba(81, 53, 47, 0.075);
        }

        .stat-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 22px;
        }

        .stat-label {
            color: var(--muted);
            font-size: 11px;
            font-weight: 500;
            line-height: 1.6;
        }

        .stat-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 43px;
            height: 43px;
            flex-shrink: 0;
            border-radius: 13px;
            background: var(--rose);
            color: var(--mocha);
            font-size: 20px;
        }

        .stat-icon svg {
            width: 22px;
            height: 22px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.7;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .stat-value {
            margin: 0 0 8px;
            color: var(--text);
            font-size: clamp(25px, 2.4vw, 32px);
            font-weight: 600;
            letter-spacing: -0.8px;
            line-height: 1.25;
            overflow-wrap: anywhere;
        }

        .stat-note {
            margin: 0;
            color: #968980;
            font-size: 10px;
            line-height: 1.8;
        }

        .stat-card.delivered .stat-icon {
            background: #E7F3E9;
            color: var(--green);
        }

        .stat-card.cancelled .stat-icon {
            background: #FDE9E7;
            color: var(--red);
        }

        .stat-card.revenue .stat-icon {
            background: #F1E9F5;
            color: #76538E;
        }

        /* ORDER STATUS PANEL */

        .panel {
            padding: 27px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 17px;
            box-shadow: 0 4px 16px rgba(48, 41, 35, 0.035);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 29px;
        }

        .panel-header h2 {
            margin: 0 0 7px;
            font-family: 'Playfair Display', serif;
            font-size: 23px;
            font-weight: 600;
        }

        .panel-header p {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.8;
        }

        .panel-tag {
            padding: 7px 12px;
            border: 1px solid var(--border);
            border-radius: 20px;
            background: #FCFAF8;
            color: var(--mocha);
            font-size: 10px;
            font-weight: 500;
            white-space: nowrap;
        }

        .status-list {
            display: flex;
            flex-direction: column;
            gap: 23px;
        }

        .status-row {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .status-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .status-name {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #51443D;
            font-size: 11px;
            font-weight: 500;
            overflow-wrap: anywhere;
        }

        .status-dot {
            width: 9px;
            height: 9px;
            flex-shrink: 0;
            border-radius: 50%;
        }

        .status-count {
            min-width: 25px;
            padding: 5px 9px;
            border: 1px solid var(--border);
            border-radius: 7px;
            color: var(--text);
            background: #FCFAF8;
            text-align: center;
            font-size: 10px;
            font-weight: 600;
        }

        .status-track {
            width: 100%;
            height: 9px;
            overflow: hidden;
            background: #F1ECE8;
            border-radius: 10px;
        }

        .status-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.4s ease;
        }

        .status-placed {
            background: #B08A60;
        }

        .status-processing {
            background: #638BB7;
        }

        .status-shipped {
            background: #9276B6;
        }

        .status-delivered {
            background: #53966C;
        }

        .status-cancelled {
            background: #C76D65;
        }

        .status-default {
            background: #8B827C;
        }

        .empty-orders {
            padding: 18px;
            border: 1px dashed #D9C9C0;
            border-radius: 10px;
            color: var(--muted);
            font-size: 12px;
            text-align: center;
        }

        /* FOOTER */

        .page-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 28px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
            color: #968980;
            font-size: 10px;
        }

        .footer-brand {
            color: var(--mocha);
            font-family: 'Playfair Display', serif;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 1px;
        }

        @media (max-width: 900px) {
            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 560px) {
            .topbar {
                padding: 13px 17px;
            }

            .brand-name {
                font-size: 20px;
            }

            .page-container {
                padding: 25px 15px;
            }

            .page-heading h1 {
                font-size: 30px;
            }

            .stats-grid {
                gap: 12px;
                margin-bottom: 25px;
            }

            .stat-card {
                padding: 16px;
                border-radius: 13px;
            }

            .stat-top {
                align-items: flex-start;
                margin-bottom: 18px;
            }

            .stat-icon {
                width: 35px;
                height: 35px;
                border-radius: 10px;
                font-size: 17px;
            }

            .stat-icon svg {
                width: 19px;
                height: 19px;
            }

            .stat-value {
                font-size: 25px;
            }

            .stat-label {
                font-size: 10px;
            }

            .stat-note {
                font-size: 9px;
            }

            .panel {
                padding: 18px;
                border-radius: 14px;
            }

            .panel-header h2 {
                font-size: 21px;
            }

            .status-list {
                gap: 20px;
            }

            .page-footer {
                margin-top: 23px;
            }
        }

        @media (max-width: 350px) {
            .stats-grid {
                grid-template-columns: 1fr;
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

<%
    Map<String, Object> summary =
            (Map<String, Object>) request.getAttribute("summary");

    Map<String, Integer> orderStatusCounts =
            (Map<String, Integer>)
                    request.getAttribute("orderStatusCounts");

    int totalUsers = 0;
    int totalProducts = 0;
    int totalOrders = 0;
    int deliveredOrders = 0;
    int cancelledOrders = 0;
    double deliveredOrderValue = 0.0;

    if (summary != null) {
        Object value;

        value = summary.get("totalUsers");
        if (value instanceof Number) {
            totalUsers = ((Number) value).intValue();
        }

        value = summary.get("totalProducts");
        if (value instanceof Number) {
            totalProducts = ((Number) value).intValue();
        }

        value = summary.get("totalOrders");
        if (value instanceof Number) {
            totalOrders = ((Number) value).intValue();
        }

        value = summary.get("deliveredOrders");
        if (value instanceof Number) {
            deliveredOrders = ((Number) value).intValue();
        }

        value = summary.get("cancelledOrders");
        if (value instanceof Number) {
            cancelledOrders = ((Number) value).intValue();
        }

        value = summary.get("deliveredOrderValue");
        if (value instanceof Number) {
            deliveredOrderValue = ((Number) value).doubleValue();
        }
    }

    int maxStatusCount = 1;

    if (orderStatusCounts != null) {
        for (Integer count : orderStatusCounts.values()) {
            if (count != null && count > maxStatusCount) {
                maxStatusCount = count;
            }
        }
    }

    String[] standardStatuses = {
        "PLACED", "PROCESSING", "SHIPPED",
        "DELIVERED", "CANCELLED"
    };

    String contextPath = request.getContextPath();
%>

<!-- TOP NAVIGATION -->

<header class="topbar">

    <a class="brand"
       href="<%= contextPath %>/admin/dashboard"
       aria-label="Aura Admin Dashboard">

        <span class="brand-mark">A</span>

        <span>
            <span class="brand-name">AURA</span>
            <span class="brand-caption">Admin Studio</span>
        </span>
    </a>

    <a href="<%= contextPath %>/admin/dashboard"
       class="back-btn">
        &#8592; Back to Dashboard
    </a>

</header>

<main class="page-container">

    <!-- PAGE HEADING -->

    <section class="page-heading">

        <div>
            <div class="eyebrow">
                <span class="eyebrow-dot"></span>
                Aura Control Center
            </div>

            <h1>Store Analytics</h1>

            <p class="subtitle">
                Understand your store performance through real database statistics.
            </p>
        </div>

    </section>

    <!-- STORE OVERVIEW -->

    <section>

        <h2 class="section-heading">Store Overview</h2>

        <p class="section-description">
            Key figures retrieved from your store database.
        </p>

        <div class="stats-grid">

            <!-- USERS -->

            <article class="stat-card">

                <div class="stat-top">
                    <span class="stat-label">Registered Users</span>

                    <span class="stat-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <circle cx="9" cy="8" r="3"/>
                            <path d="M3 20v-1a6 6 0 0 1 12 0v1"/>
                            <path d="M16 5a3 3 0 0 1 0 6"/>
                            <path d="M18 14a5 5 0 0 1 3 5v1"/>
                        </svg>
                    </span>
                </div>

                <h3 class="stat-value">
                    <%= String.format(Locale.US, "%,d", totalUsers) %>
                </h3>

                <p class="stat-note">Total accounts registered</p>

            </article>

            <!-- PRODUCTS -->

            <article class="stat-card">

                <div class="stat-top">
                    <span class="stat-label">Total Products</span>

                    <span class="stat-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="m3 7 9-4 9 4-9 4-9-4Z"/>
                            <path d="M3 7v10l9 4 9-4V7"/>
                            <path d="M12 11v10"/>
                        </svg>
                    </span>
                </div>

                <h3 class="stat-value">
                    <%= String.format(Locale.US, "%,d", totalProducts) %>
                </h3>

                <p class="stat-note">Products in the catalogue</p>

            </article>

            <!-- ORDERS -->

            <article class="stat-card">

                <div class="stat-top">
                    <span class="stat-label">Total Orders</span>

                    <span class="stat-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 4h2l2.2 11h9.5l2-7H7"/>
                            <circle cx="10" cy="19" r="1.5"/>
                            <circle cx="17" cy="19" r="1.5"/>
                        </svg>
                    </span>
                </div>

                <h3 class="stat-value">
                    <%= String.format(Locale.US, "%,d", totalOrders) %>
                </h3>

                <p class="stat-note">All recorded orders</p>

            </article>

            <!-- DELIVERED -->

            <article class="stat-card delivered">

                <div class="stat-top">
                    <span class="stat-label">Delivered Orders</span>

                    <span class="stat-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="m5 12 4 4L19 6"/>
                        </svg>
                    </span>
                </div>

                <h3 class="stat-value">
                    <%= String.format(Locale.US, "%,d", deliveredOrders) %>
                </h3>

                <p class="stat-note">Orders marked DELIVERED</p>

            </article>

            <!-- CANCELLED -->

            <article class="stat-card cancelled">

                <div class="stat-top">
                    <span class="stat-label">Cancelled Orders</span>

                    <span class="stat-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="m6 6 12 12M18 6 6 18"/>
                        </svg>
                    </span>
                </div>

                <h3 class="stat-value">
                    <%= String.format(Locale.US, "%,d", cancelledOrders) %>
                </h3>

                <p class="stat-note">Orders marked CANCELLED</p>

            </article>

            <!-- DELIVERED ORDER VALUE -->

            <article class="stat-card revenue">

                <div class="stat-top">
                    <span class="stat-label">Delivered Order Value</span>

                    <span class="stat-icon" aria-hidden="true">
                        &#8377;
                    </span>
                </div>

                <h3 class="stat-value">
                    &#8377;<%= String.format(
                            Locale.US, "%,.2f", deliveredOrderValue) %>
                </h3>

                <p class="stat-note">
                    Recorded totals for delivered orders
                </p>

            </article>

        </div>

    </section>

    <!-- ORDER STATUS BREAKDOWN -->

    <section class="panel">

        <div class="panel-header">

            <div>
                <h2>Order Status Breakdown</h2>

                <p>
                    Compare the number of orders in each current status.
                </p>
            </div>

            <span class="panel-tag">Order overview</span>

        </div>

        <% if (totalOrders == 0) { %>

            <div class="empty-orders">
                No orders have been recorded yet.
            </div>

        <% } else { %>

            <div class="status-list">

                <% for (String status : standardStatuses) {

                    int count = 0;

                    if (orderStatusCounts != null
                            && orderStatusCounts.containsKey(status)
                            && orderStatusCounts.get(status) != null) {

                        count = orderStatusCounts.get(status);
                    }

                    int percentage = (int) Math.round(
                            (count * 100.0) / maxStatusCount
                    );

                    String cssClass = "status-default";

                    if ("PLACED".equals(status)) {
                        cssClass = "status-placed";
                    } else if ("PROCESSING".equals(status)) {
                        cssClass = "status-processing";
                    } else if ("SHIPPED".equals(status)) {
                        cssClass = "status-shipped";
                    } else if ("DELIVERED".equals(status)) {
                        cssClass = "status-delivered";
                    } else if ("CANCELLED".equals(status)) {
                        cssClass = "status-cancelled";
                    }
                %>

                    <div class="status-row">

                        <div class="status-info">

                            <span class="status-name">
                                <span class="status-dot <%= cssClass %>"></span>

                                <%= status.substring(0, 1)
                                        + status.substring(1).toLowerCase(
                                                Locale.ROOT) %>
                            </span>

                            <span class="status-count">
                                <%= count %>
                            </span>

                        </div>

                        <div class="status-track"
                             role="img"
                             aria-label="<%= status %>: <%= count %> orders">

                            <div class="status-fill <%= cssClass %>"
                                 style="width:<%= percentage %>%;"></div>

                        </div>

                    </div>

                <% } %>

                <!-- OTHER STATUSES, IF PRESENT -->

                <% if (orderStatusCounts != null) {

                    for (Map.Entry<String, Integer> entry
                            : orderStatusCounts.entrySet()) {

                        String status = entry.getKey();

                        if (status == null) {
                            continue;
                        }

                        boolean standard = false;

                        for (String known : standardStatuses) {
                            if (known.equals(status)) {
                                standard = true;
                                break;
                            }
                        }

                        if (!standard) {

                            int count = entry.getValue() == null
                                    ? 0
                                    : entry.getValue();

                            int percentage = (int) Math.round(
                                    (count * 100.0) / maxStatusCount
                            );
                %>

                            <div class="status-row">

                                <div class="status-info">

                                    <span class="status-name">
                                        <span class="status-dot status-default"></span>
                                        <%= status %>
                                    </span>

                                    <span class="status-count">
                                        <%= count %>
                                    </span>

                                </div>

                                <div class="status-track">
                                    <div class="status-fill status-default"
                                         style="width:<%= percentage %>%;"></div>
                                </div>

                            </div>

                <%
                        }
                    }
                } %>

            </div>

        <% } %>

    </section>

    <!-- FOOTER -->

    <footer class="page-footer">
        <span class="footer-brand">AURA</span>
        <span>Admin Studio &bull; Store Analytics</span>
    </footer>

</main>

</body>
</html>
