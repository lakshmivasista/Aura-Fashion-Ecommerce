
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Locale, com.aura.model.User" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Aura | User Management</title>

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
            color: var(--text);
            text-decoration: none;
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

        .back-btn:focus-visible {
            outline: 3px solid #B88A6C;
            outline-offset: 3px;
        }

        /* MAIN CONTENT */

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
            margin-bottom: 30px;
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
            max-width: 650px;
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.8;
        }

        /* SUMMARY CARD */

        .summary-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            padding: 24px 26px;
            margin-bottom: 28px;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: var(--white);
            box-shadow: 0 4px 16px rgba(48, 41, 35, 0.035);
        }

        .summary-label {
            margin: 0 0 8px;
            color: var(--muted);
            font-size: 11px;
            font-weight: 500;
        }

        .summary-count {
            margin: 0 0 6px;
            color: var(--mocha);
            font-size: 32px;
            font-weight: 600;
            line-height: 1.2;
        }

        .summary-note {
            margin: 0;
            color: #968980;
            font-size: 10px;
            line-height: 1.7;
        }

        .summary-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 55px;
            height: 55px;
            flex-shrink: 0;
            border-radius: 15px;
            background: var(--rose);
            color: var(--mocha);
        }

        .summary-icon svg {
            width: 27px;
            height: 27px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.7;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        /* USER TABLE PANEL */

        .table-card {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: var(--white);
            box-shadow: 0 4px 16px rgba(48, 41, 35, 0.035);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            padding: 23px 25px;
            border-bottom: 1px solid var(--border);
        }

        .table-header h2 {
            margin: 0 0 6px;
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            font-weight: 600;
        }

        .table-header p {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.8;
        }

        .table-tag {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 12px;
            border: 1px solid var(--border);
            border-radius: 20px;
            background: #FCFAF8;
            color: var(--mocha);
            font-size: 10px;
            font-weight: 500;
            white-space: nowrap;
        }

        .table-tag-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #8D9B76;
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        thead {
            background: #FAF7F5;
        }

        th {
            padding: 16px 23px;
            color: #82756D;
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        td {
            padding: 18px 23px;
            border-top: 1px solid #F0EBE7;
            font-size: 12px;
            vertical-align: middle;
        }

        tbody tr {
            transition: background 0.18s ease;
        }

        tbody tr:hover {
            background: #FDFBF9;
        }

        .user-id {
            color: #8B7B71;
            font-size: 11px;
            font-weight: 500;
        }

        .user-name {
            color: var(--text);
            font-size: 12px;
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .user-email {
            color: #655951;
            overflow-wrap: anywhere;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 11px;
            border: 1px solid #E8D7CD;
            border-radius: 20px;
            background: #F7EDE7;
            color: #754D43;
            font-size: 10px;
            font-weight: 600;
            white-space: nowrap;
        }

        .role-admin {
            border-color: #D6DFF2;
            background: #EDF1FA;
            color: #405C91;
        }

        .role-other {
            border-color: #EAE1DB;
            background: #F5F1EE;
            color: #756A63;
        }

        /* EMPTY STATE */

        .empty-state {
            padding: 52px 20px;
            text-align: center;
        }

        .empty-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 62px;
            height: 62px;
            margin: 0 auto 17px;
            border-radius: 18px;
            background: var(--rose);
            color: var(--mocha);
        }

        .empty-icon svg {
            width: 30px;
            height: 30px;
            fill: none;
            stroke: currentColor;
            stroke-width: 1.6;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .empty-state h3 {
            margin: 0 0 9px;
            font-family: 'Playfair Display', serif;
            font-size: 23px;
            font-weight: 600;
        }

        .empty-state p {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.8;
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

        @media (max-width: 700px) {
            .topbar {
                padding: 13px 17px;
            }

            .brand-name {
                font-size: 20px;
            }

            .page-container {
                padding: 26px 15px;
            }

            .page-heading h1 {
                font-size: 30px;
            }

            .summary-card {
                padding: 20px;
            }

            .table-header {
                padding: 20px;
            }

            th, td {
                padding: 14px 16px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                transition: none !important;
            }
        }
    </style>
</head>

<body>

<%
    List<User> users =
            (List<User>) request.getAttribute("users");

    int totalUsers = users == null ? 0 : users.size();

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

    <a class="back-btn"
       href="<%= contextPath %>/admin/dashboard">
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

            <h1>User Management</h1>

            <p class="subtitle">
                View registered accounts and their roles in the Aura store.
            </p>
        </div>

    </section>

    <!-- USER SUMMARY -->

    <section class="summary-card">

        <div>
            <p class="summary-label">Total Registered Users</p>

            <h2 class="summary-count">
                <%= String.format(Locale.US, "%,d", totalUsers) %>
            </h2>

            <p class="summary-note">
                Accounts retrieved from your store database.
            </p>
        </div>

        <div class="summary-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24">
                <circle cx="9" cy="8" r="3"/>
                <path d="M3 20v-1a6 6 0 0 1 12 0v1"/>
                <path d="M16 5a3 3 0 0 1 0 6"/>
                <path d="M18 14a5 5 0 0 1 3 5v1"/>
            </svg>
        </div>

    </section>

    <!-- REGISTERED USERS TABLE -->

    <section class="table-card">

        <div class="table-header">

            <div>
                <h2>Registered Accounts</h2>

                <p>
                    Account identifiers, names, email addresses, and roles.
                </p>
            </div>

            <span class="table-tag">
                <span class="table-tag-dot"></span>
                Account directory
            </span>

        </div>

        <% if (users != null && !users.isEmpty()) { %>

            <div class="table-scroll">

                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Name</th>
                            <th>Email Address</th>
                            <th>Role</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% for (User user : users) {

                            String role = user.getRole();

                            if (role == null || role.trim().isEmpty()) {
                                role = "Not assigned";
                            }

                            boolean isAdmin =
                                    "ADMIN".equalsIgnoreCase(role);

                            String roleClass;

                            if (isAdmin) {
                                roleClass = "role-admin";
                            } else if ("USER".equalsIgnoreCase(role)
                                    || "CUSTOMER".equalsIgnoreCase(role)) {
                                roleClass = "";
                            } else {
                                roleClass = "role-other";
                            }
                        %>

                            <tr>

                                <td class="user-id">
                                    #<%= user.getUserId() %>
                                </td>

                                <td class="user-name">
                                    <%= escapeHtml(user.getName()) %>
                                </td>

                                <td class="user-email">
                                    <%= escapeHtml(user.getEmail()) %>
                                </td>

                                <td>
                                    <span class="role-badge <%= roleClass %>">
                                        <%= escapeHtml(role) %>
                                    </span>
                                </td>

                            </tr>

                        <% } %>

                    </tbody>
                </table>

            </div>

        <% } else { %>

            <div class="empty-state">

                <div class="empty-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24">
                        <circle cx="9" cy="8" r="3"/>
                        <path d="M3 20v-1a6 6 0 0 1 12 0v1"/>
                        <path d="M16 5a3 3 0 0 1 0 6"/>
                        <path d="M18 14a5 5 0 0 1 3 5v1"/>
                    </svg>
                </div>

                <h3>No registered users found</h3>

                <p>
                    Registered accounts will appear here when available.
                </p>

            </div>

        <% } %>

    </section>

    <!-- FOOTER -->

    <footer class="page-footer">

        <span class="footer-brand">AURA</span>

        <span>Admin Studio &bull; User Management</span>

    </footer>

</main>

</body>
</html>
