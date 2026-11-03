
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Locale, java.util.Set, java.util.Map, java.util.LinkedHashMap, java.text.SimpleDateFormat, com.aura.model.Order" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String normalizeStatus(String value) {
        if (value == null) {
            return "PLACED";
        }

        String status = value.trim().toUpperCase(Locale.ROOT);

        if (Set.of(
                "PLACED",
                "PROCESSING",
                "SHIPPED",
                "DELIVERED",
                "CANCELLED"
        ).contains(status)) {
            return status;
        }

        return "PLACED";
    }

    private String statusLabel(String status) {
        switch (status) {
            case "PLACED":
                return "Placed";
            case "PROCESSING":
                return "Processing";
            case "SHIPPED":
                return "Shipped";
            case "DELIVERED":
                return "Delivered";
            case "CANCELLED":
                return "Cancelled";
            default:
                return "Placed";
        }
    }
%>

<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");

    int orderCount = orders == null ? 0 : orders.size();

    String contextPath = request.getContextPath();

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String updatedParam = request.getParameter("updated");
    String errorParam = request.getParameter("error");

    Map<String, Integer> statusCounts = new LinkedHashMap<>();

    statusCounts.put("PLACED", 0);
    statusCounts.put("PROCESSING", 0);
    statusCounts.put("SHIPPED", 0);
    statusCounts.put("DELIVERED", 0);
    statusCounts.put("CANCELLED", 0);

    if (orders != null) {
        for (Order order : orders) {
            String status = normalizeStatus(order.getStatus());

            statusCounts.put(
                status,
                statusCounts.get(status) + 1
            );
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Aura | Order Management</title>

    <style>
        :root {
            --bg: #f8f5f2;
            --surface: #ffffff;
            --primary: #51352f;
            --primary-dark: #39251f;
            --text: #302923;
            --muted: #847970;
            --border: #eee6df;
            --shadow: 0 12px 35px rgba(64, 43, 34, 0.06);

            --placed: #97651e;
            --placed-bg: #fbf1df;

            --processing: #6554a2;
            --processing-bg: #f0edfa;

            --shipped: #276c9c;
            --shipped-bg: #eaf4fb;

            --delivered: #277748;
            --delivered-bg: #eaf6ed;

            --cancelled: #a53d35;
            --cancelled-bg: #fff0ed;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--bg);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
            line-height: 1.5;
        }

        a {
            -webkit-tap-highlight-color: transparent;
        }

        button,
        input,
        select {
            font: inherit;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 10;
            min-height: 78px;
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            background: rgba(255, 255, 255, 0.96);
            border-bottom: 1px solid var(--border);
            backdrop-filter: blur(12px);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-mark {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 13px;
            background: var(--primary);
            color: white;
            font-family: Georgia, serif;
            font-size: 23px;
        }

        .brand-name {
            margin: 0;
            font-family: Georgia, serif;
            font-size: 24px;
            letter-spacing: 2px;
        }

        .brand-subtitle {
            display: block;
            margin-top: 2px;
            color: var(--muted);
            font-size: 11px;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .admin-label {
            color: var(--muted);
            font-size: 13px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 16px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: white;
            color: var(--primary);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .back-btn:hover {
            border-color: var(--primary);
            background: var(--bg);
        }

        .page-container {
            width: min(1500px, 92%);
            margin: 0 auto;
            padding: 36px 0 55px;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: var(--muted);
            font-size: 12px;
            letter-spacing: 0.5px;
        }

        .breadcrumb span {
            color: var(--primary);
            font-weight: 700;
        }

        .hero {
            position: relative;
            overflow: hidden;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 25px;
            padding: 35px 38px;
            margin-bottom: 27px;
            border-radius: 20px;
            background: linear-gradient(120deg, #493029, #725448);
            color: white;
            box-shadow: var(--shadow);
        }

        .hero::after {
            content: "";
            position: absolute;
            top: -155px;
            right: 8%;
            width: 260px;
            height: 260px;
            border: 1px solid rgba(255, 255, 255, 0.13);
            border-radius: 50%;
            box-shadow:
                0 0 0 30px rgba(255, 255, 255, 0.025),
                0 0 0 60px rgba(255, 255, 255, 0.025);
            pointer-events: none;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .eyebrow {
            margin: 0 0 10px;
            color: #e4cfc0;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2.5px;
            text-transform: uppercase;
        }

        .hero h1 {
            margin: 0 0 10px;
            font-family: Georgia, serif;
            font-size: clamp(28px, 3vw, 39px);
            font-weight: 500;
            letter-spacing: -0.6px;
        }

        .hero-description {
            max-width: 600px;
            margin: 0;
            color: #eee2da;
            font-size: 14px;
            line-height: 1.8;
        }

        .hero-count {
            position: relative;
            z-index: 1;
            min-width: 135px;
            padding: 18px 22px;
            border: 1px solid rgba(255, 255, 255, 0.19);
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.10);
            text-align: center;
        }

        .hero-count strong {
            display: block;
            font-family: Georgia, serif;
            font-size: 37px;
            font-weight: 500;
        }

        .hero-count span {
            display: block;
            margin-top: 3px;
            color: #eee2da;
            font-size: 10px;
            letter-spacing: 1.2px;
            text-transform: uppercase;
        }

        .section-heading {
            margin: 0 0 18px;
        }

        .section-heading h2 {
            margin: 0 0 5px;
            font-family: Georgia, serif;
            font-size: 25px;
            font-weight: 500;
        }

        .section-heading p {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 30px;
        }

        .summary-card {
            min-width: 0;
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 19px 17px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--surface);
            box-shadow: 0 5px 20px rgba(64, 43, 34, 0.025);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .summary-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow);
        }

        .summary-icon {
            flex-shrink: 0;
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            font-size: 19px;
            font-weight: 700;
        }

        .icon-placed {
            color: var(--placed);
            background: var(--placed-bg);
        }

        .icon-processing {
            color: var(--processing);
            background: var(--processing-bg);
        }

        .icon-shipped {
            color: var(--shipped);
            background: var(--shipped-bg);
        }

        .icon-delivered {
            color: var(--delivered);
            background: var(--delivered-bg);
        }

        .icon-cancelled {
            color: var(--cancelled);
            background: var(--cancelled-bg);
        }

        .summary-label {
            margin: 0 0 3px;
            color: var(--muted);
            font-size: 11px;
            font-weight: 600;
            line-height: 1.4;
        }

        .summary-value {
            margin: 0;
            color: var(--text);
            font-family: Georgia, serif;
            font-size: 27px;
            line-height: 1.2;
        }

        .message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 14px 17px;
            margin-bottom: 22px;
            border: 1px solid transparent;
            border-radius: 10px;
            font-size: 13px;
        }

        .success-message {
            color: #226536;
            background: #eaf6ed;
            border-color: #d5ead9;
        }

        .error-message {
            color: #a12d20;
            background: #fff0ed;
            border-color: #f1d5cf;
        }

        .orders-panel {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 17px;
            background: var(--surface);
            box-shadow: var(--shadow);
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            padding: 24px 25px;
            border-bottom: 1px solid var(--border);
        }

        .panel-title {
            margin: 0 0 5px;
            font-family: Georgia, serif;
            font-size: 23px;
            font-weight: 500;
        }

        .panel-subtitle {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
        }

        .filter-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .search-box {
            position: relative;
            min-width: 230px;
        }

        .search-box span {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            pointer-events: none;
        }

        .search-input,
        .filter-select {
            height: 42px;
            border: 1px solid #e4d9d0;
            border-radius: 9px;
            outline: none;
            background: #fff;
            color: var(--text);
            font-size: 12px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .search-input {
            width: 100%;
            padding: 10px 12px 10px 34px;
        }

        .filter-select {
            min-width: 145px;
            padding: 9px 30px 9px 12px;
            cursor: pointer;
        }

        .search-input:focus,
        .filter-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(81, 53, 47, 0.08);
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1120px;
            border-collapse: collapse;
        }

        thead th {
            padding: 16px 15px;
            background: #faf7f4;
            color: #796b60;
            text-align: left;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            white-space: nowrap;
            border-bottom: 1px solid var(--border);
        }

        tbody td {
            padding: 18px 15px;
            border-bottom: 1px solid #f0eae5;
            text-align: left;
            vertical-align: middle;
            font-size: 13px;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        tbody tr {
            transition: background 0.18s ease;
        }

        tbody tr:hover {
            background: #fcfaf8;
        }

        .order-number {
            color: var(--primary);
            font-size: 13px;
            font-weight: 800;
            white-space: nowrap;
        }

        .customer-name {
            margin-bottom: 4px;
            color: var(--text);
            font-size: 13px;
            font-weight: 700;
        }

        .customer-email {
            max-width: 230px;
            color: var(--muted);
            font-size: 11px;
            overflow-wrap: anywhere;
        }

        .order-date {
            min-width: 140px;
            color: #61564e;
            font-size: 12px;
            line-height: 1.7;
        }

        .amount {
            color: var(--primary);
            font-size: 14px;
            font-weight: 800;
            white-space: nowrap;
        }

        .payment-method {
            display: inline-block;
            padding: 6px 9px;
            border: 1px solid #ece2da;
            border-radius: 7px;
            background: #faf7f4;
            color: #655349;
            font-size: 11px;
            overflow-wrap: anywhere;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 9px;
            margin-bottom: 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 800;
            white-space: nowrap;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
        }

        .status-placed {
            color: var(--placed);
            background: var(--placed-bg);
        }

        .status-processing {
            color: var(--processing);
            background: var(--processing-bg);
        }

        .status-shipped {
            color: var(--shipped);
            background: var(--shipped-bg);
        }

        .status-delivered {
            color: var(--delivered);
            background: var(--delivered-bg);
        }

        .status-cancelled {
            color: var(--cancelled);
            background: var(--cancelled-bg);
        }

        .status-form {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 150px;
        }

        .status-select {
            width: 100%;
            min-height: 38px;
            padding: 9px 10px;
            border: 1px solid #e4d9d0;
            border-radius: 8px;
            background: #fff;
            color: var(--text);
            font-size: 12px;
            cursor: pointer;
            outline: none;
        }

        .status-select:focus {
            border-color: var(--primary);
        }

        .update-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            width: 100%;
            min-height: 37px;
            padding: 9px 12px;
            border: none;
            border-radius: 8px;
            background: var(--primary);
            color: white;
            cursor: pointer;
            font-size: 11px;
            font-weight: 700;
            transition: background 0.2s ease;
        }

        .update-btn:hover {
            background: var(--primary-dark);
        }

        .empty-state {
            padding: 65px 20px;
            text-align: center;
        }

        .empty-icon {
            width: 65px;
            height: 65px;
            display: grid;
            place-items: center;
            margin: 0 auto 17px;
            border-radius: 50%;
            background: #f3eae3;
            color: var(--primary);
            font-family: Georgia, serif;
            font-size: 30px;
        }

        .empty-state h3 {
            margin: 0 0 8px;
            font-family: Georgia, serif;
            font-size: 24px;
            font-weight: 500;
        }

        .empty-state p {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

        .no-results {
            display: none;
            padding: 35px 15px;
            color: var(--muted);
            text-align: center;
            font-size: 13px;
        }

        .table-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 15px 24px;
            border-top: 1px solid var(--border);
            background: #fdfbf9;
            color: var(--muted);
            font-size: 11px;
        }

        .footer {
            margin-top: 42px;
            padding-top: 22px;
            border-top: 1px solid var(--border);
            color: var(--muted);
            text-align: center;
            font-size: 11px;
            letter-spacing: 0.5px;
        }

        @media (max-width: 1150px) {
            .summary-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .panel-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .filter-controls {
                width: 100%;
            }

            .search-box {
                flex: 1;
            }
        }

        @media (max-width: 700px) {
            .navbar {
                padding: 14px 4%;
            }

            .brand-name {
                font-size: 19px;
            }

            .brand-subtitle {
                font-size: 9px;
                letter-spacing: 1px;
            }

            .brand-mark {
                width: 38px;
                height: 38px;
            }

            .admin-label {
                display: none;
            }

            .back-btn {
                padding: 10px;
                font-size: 11px;
            }

            .page-container {
                width: 92%;
                padding-top: 24px;
            }

            .hero {
                align-items: flex-start;
                flex-direction: column;
                padding: 27px 23px;
                border-radius: 15px;
            }

            .hero-count {
                min-width: 110px;
                padding: 11px 15px;
            }

            .hero-count strong {
                font-size: 29px;
            }

            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 11px;
            }

            .summary-card {
                gap: 10px;
                padding: 14px 12px;
            }

            .summary-icon {
                width: 36px;
                height: 36px;
                font-size: 16px;
            }

            .summary-value {
                font-size: 24px;
            }

            .summary-label {
                font-size: 10px;
            }

            .panel-header {
                padding: 20px 16px;
            }

            .filter-controls {
                flex-direction: column;
            }

            .search-box {
                min-width: 0;
                width: 100%;
            }

            .filter-select {
                width: 100%;
            }

            .table-footer {
                align-items: flex-start;
                flex-direction: column;
                padding: 14px 16px;
            }
        }

        @media (max-width: 360px) {
            .summary-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                transition: none !important;
                animation: none !important;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <div class="brand">
            <div class="brand-mark">A</div>

            <div>
                <h2 class="brand-name">AURA</h2>
                <span class="brand-subtitle">Admin Studio</span>
            </div>
        </div>

        <div class="nav-right">
            <span class="admin-label">Order Management</span>

            <a class="back-btn"
               href="<%= contextPath %>/admin/dashboard">
                &#8592; Dashboard
            </a>
        </div>
    </nav>

    <main class="page-container">

        <div class="breadcrumb">
            ADMINISTRATION &nbsp;/&nbsp; <span>ORDERS</span>
        </div>

        <section class="hero">
            <div class="hero-content">
                <p class="eyebrow">Your Store, At A Glance</p>

                <h1>Order Management</h1>

                <p class="hero-description">
                    Keep every order moving smoothly. Review customer purchases,
                    track order progress, and update delivery statuses from one place.
                </p>
            </div>

            <div class="hero-count">
                <strong><%= orderCount %></strong>
                <span>Orders Retrieved</span>
            </div>
        </section>

        <% if ("true".equals(updatedParam)) { %>

            <div class="message success-message" role="status">
                <span aria-hidden="true">&#10003;</span>
                <span>Order status updated successfully.</span>
            </div>

        <% } else if ("update".equals(errorParam)) { %>

            <div class="message error-message" role="alert">
                <span aria-hidden="true">&#9888;</span>
                <span>
                    Could not update the order status. Please try again.
                </span>
            </div>

        <% } else if ("invalid".equals(errorParam)) { %>

            <div class="message error-message" role="alert">
                <span aria-hidden="true">&#9888;</span>
                <span>Invalid order information.</span>
            </div>

        <% } %>

        <section>
            <div class="section-heading">
                <h2>Order Overview</h2>
                <p>Order counts by their current status.</p>
            </div>

            <div class="summary-grid">

                <div class="summary-card">
                    <div class="summary-icon icon-placed">&#9711;</div>
                    <div>
                        <p class="summary-label">Placed</p>
                        <p class="summary-value">
                            <%= statusCounts.get("PLACED") %>
                        </p>
                    </div>
                </div>

                <div class="summary-card">
                    <div class="summary-icon icon-processing">&#8635;</div>
                    <div>
                        <p class="summary-label">Processing</p>
                        <p class="summary-value">
                            <%= statusCounts.get("PROCESSING") %>
                        </p>
                    </div>
                </div>

                <div class="summary-card">
                    <div class="summary-icon icon-shipped">&#10148;</div>
                    <div>
                        <p class="summary-label">Shipped</p>
                        <p class="summary-value">
                            <%= statusCounts.get("SHIPPED") %>
                        </p>
                    </div>
                </div>

                <div class="summary-card">
                    <div class="summary-icon icon-delivered">&#10003;</div>
                    <div>
                        <p class="summary-label">Delivered</p>
                        <p class="summary-value">
                            <%= statusCounts.get("DELIVERED") %>
                        </p>
                    </div>
                </div>

                <div class="summary-card">
                    <div class="summary-icon icon-cancelled">&#10005;</div>
                    <div>
                        <p class="summary-label">Cancelled</p>
                        <p class="summary-value">
                            <%= statusCounts.get("CANCELLED") %>
                        </p>
                    </div>
                </div>

            </div>
        </section>

        <section class="orders-panel">

            <div class="panel-header">
                <div>
                    <h2 class="panel-title">Customer Orders</h2>
                    <p class="panel-subtitle">
                        Review order information and manage each order's status.
                    </p>
                </div>

                <div class="filter-controls">

                    <div class="search-box">
                        <span aria-hidden="true">&#9906;</span>

                        <input
                            type="search"
                            id="orderSearch"
                            class="search-input"
                            placeholder="Search order or customer..."
                            aria-label="Search orders"
                        >
                    </div>

                    <select
                        id="statusFilter"
                        class="filter-select"
                        aria-label="Filter orders by status"
                    >
                        <option value="">All statuses</option>
                        <option value="PLACED">Placed</option>
                        <option value="PROCESSING">Processing</option>
                        <option value="SHIPPED">Shipped</option>
                        <option value="DELIVERED">Delivered</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>

                </div>
            </div>

            <% if (orders != null && !orders.isEmpty()) { %>

                <div class="table-wrapper">

                    <table id="ordersTable">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Order Date</th>
                                <th>Total Amount</th>
                                <th>Payment Method</th>
                                <th>Order Status &amp; Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                        <% for (Order order : orders) {

                            String currentStatus =
                                normalizeStatus(order.getStatus());

                            String customerName =
                                order.getCustomerName() == null
                                ? "Customer"
                                : order.getCustomerName();

                            String customerEmail =
                                order.getCustomerEmail() == null
                                ? ""
                                : order.getCustomerEmail();

                            String paymentMethod =
                                order.getPaymentMethod() == null
                                ? "—"
                                : order.getPaymentMethod();

                            String orderDate =
                                order.getCreatedAt() == null
                                ? "—"
                                : dateFormat.format(order.getCreatedAt());

                            String statusCss =
                                currentStatus.toLowerCase(Locale.ROOT);
                        %>

                            <tr class="order-row"
                                data-status="<%= currentStatus %>"
                                data-search="<%= escapeHtml(
                                    ("#" + order.getOrderId() + " " +
                                    customerName + " " +
                                    customerEmail + " " +
                                    paymentMethod).toLowerCase(Locale.ROOT)
                                ) %>">

                                <td>
                                    <span class="order-number">
                                        #<%= order.getOrderId() %>
                                    </span>
                                </td>

                                <td>
                                    <div class="customer-name">
                                        <%= escapeHtml(customerName) %>
                                    </div>

                                    <div class="customer-email">
                                        <%= escapeHtml(customerEmail) %>
                                    </div>
                                </td>

                                <td>
                                    <div class="order-date">
                                        <%= escapeHtml(orderDate) %>
                                    </div>
                                </td>

                                <td>
                                    <span class="amount">
                                        ₹<%= String.format(
                                            Locale.US,
                                            "%.2f",
                                            order.getTotalAmount()
                                        ) %>
                                    </span>
                                </td>

                                <td>
                                    <span class="payment-method">
                                        <%= escapeHtml(paymentMethod) %>
                                    </span>
                                </td>

                                <td>
                                    <span class="status-pill status-<%= statusCss %>">
                                        <span class="status-dot"></span>
                                        <%= statusLabel(currentStatus) %>
                                    </span>

                                    <form
                                        class="status-form"
                                        action="<%= contextPath %>/admin/orders/update-status"
                                        method="post"
                                    >

                                        <input
                                            type="hidden"
                                            name="orderId"
                                            value="<%= order.getOrderId() %>"
                                        >

                                        <select
                                            name="status"
                                            class="status-select"
                                            aria-label="Change status for order <%= order.getOrderId() %>"
                                            required
                                        >
                                            <option value="PLACED"
                                                <%= "PLACED".equals(currentStatus)
                                                    ? "selected" : "" %>>
                                                Placed
                                            </option>

                                            <option value="PROCESSING"
                                                <%= "PROCESSING".equals(currentStatus)
                                                    ? "selected" : "" %>>
                                                Processing
                                            </option>

                                            <option value="SHIPPED"
                                                <%= "SHIPPED".equals(currentStatus)
                                                    ? "selected" : "" %>>
                                                Shipped
                                            </option>

                                            <option value="DELIVERED"
                                                <%= "DELIVERED".equals(currentStatus)
                                                    ? "selected" : "" %>>
                                                Delivered
                                            </option>

                                            <option value="CANCELLED"
                                                <%= "CANCELLED".equals(currentStatus)
                                                    ? "selected" : "" %>>
                                                Cancelled
                                            </option>
                                        </select>

                                        <button type="submit" class="update-btn">
                                            &#10003; Update Status
                                        </button>

                                    </form>
                                </td>

                            </tr>

                        <% } %>

                        </tbody>
                    </table>

                </div>

                <div id="noResults" class="no-results">
                    No orders match your search or selected status.
                </div>

                <div class="table-footer">
                    <span id="visibleCount">
                        Showing <%= orderCount %> orders
                    </span>

                    <span>
                        Aura Admin Studio &nbsp;·&nbsp; Order Management
                    </span>
                </div>

            <% } else { %>

                <div class="empty-state">
                    <div class="empty-icon">&#10003;</div>

                    <h3>No orders yet</h3>

                    <p>
                        Orders will appear here after customers
                        successfully complete checkout.
                    </p>
                </div>

            <% } %>

        </section>

        <footer class="footer">
            AURA ADMIN STUDIO &nbsp;·&nbsp;
            THOUGHTFULLY MANAGING EVERY ORDER
        </footer>

    </main>

    <script>
        (function () {
            const searchInput = document.getElementById("orderSearch");
            const statusFilter = document.getElementById("statusFilter");
            const rows = Array.from(document.querySelectorAll(".order-row"));
            const noResults = document.getElementById("noResults");
            const visibleCount = document.getElementById("visibleCount");

            if (!searchInput || !statusFilter) {
                return;
            }

            function filterOrders() {
                const query = searchInput.value.trim().toLowerCase();
                const selectedStatus = statusFilter.value;
                let visible = 0;

                rows.forEach(function (row) {
                    const searchableText = row.dataset.search || "";
                    const orderStatus = row.dataset.status || "";

                    const matchesSearch =
                        searchableText.includes(query);

                    const matchesStatus =
                        !selectedStatus || orderStatus === selectedStatus;

                    const showRow = matchesSearch && matchesStatus;

                    row.style.display = showRow ? "" : "none";

                    if (showRow) {
                        visible++;
                    }
                });

                if (noResults) {
                    noResults.style.display =
                        rows.length > 0 && visible === 0 ? "block" : "none";
                }

                if (visibleCount) {
                    visibleCount.textContent =
                        "Showing " + visible + " of " + rows.length + " orders";
                }
            }

            searchInput.addEventListener("input", filterOrders);
            statusFilter.addEventListener("change", filterOrders);
        })();
    </script>

</body>
</html>
