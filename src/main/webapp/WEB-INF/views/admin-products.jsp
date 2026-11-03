
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Locale, com.aura.model.Product" %>

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
%>

<%
    List<Product> products =
        (List<Product>) request.getAttribute("products");

    int productCount = products == null ? 0 : products.size();
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aura | Product Management</title>

    <style>
        :root {
            --bg: #f8f5f2;
            --surface: #ffffff;
            --primary: #51352f;
            --primary-dark: #39251f;
            --text: #302923;
            --muted: #847970;
            --border: #eee6df;
            --shadow: 0 12px 35px rgba(64, 43, 34, 0.07);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.5;
        }

        a {
            -webkit-tap-highlight-color: transparent;
        }

        .navbar {
            position: sticky;
            top: 0;
            z-index: 10;
            min-height: 78px;
            padding: 16px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
            background: var(--primary);
            color: white;
            border-radius: 13px;
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
            gap: 12px;
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
            color: var(--primary);
            background: white;
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
            width: min(1440px, 92%);
            margin: 0 auto;
            padding: 38px 0 60px;
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
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 36px 38px;
            margin-bottom: 28px;
            background: linear-gradient(120deg, #493029, #725448);
            border-radius: 20px;
            color: white;
            box-shadow: var(--shadow);
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            right: 7%;
            top: -155px;
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
            font-size: clamp(27px, 3vw, 39px);
            font-weight: 500;
            letter-spacing: -0.6px;
        }

        .hero p {
            max-width: 550px;
            margin: 0;
            color: #eee2da;
            font-size: 14px;
            line-height: 1.8;
        }

        .hero-count {
            position: relative;
            z-index: 1;
            min-width: 125px;
            padding: 18px 22px;
            text-align: center;
            background: rgba(255, 255, 255, 0.10);
            border: 1px solid rgba(255, 255, 255, 0.19);
            border-radius: 15px;
        }

        .hero-count strong {
            display: block;
            font-family: Georgia, serif;
            font-size: 36px;
            font-weight: 500;
        }

        .hero-count span {
            display: block;
            margin-top: 3px;
            color: #eee2da;
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .section-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .section-heading h2 {
            margin: 0 0 5px;
            font-family: Georgia, serif;
            font-size: 26px;
            font-weight: 500;
        }

        .section-heading p {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

        .add-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 13px 19px;
            border-radius: 10px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .add-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        .toolbar-line {
            height: 1px;
            margin-bottom: 24px;
            background: var(--border);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            align-items: stretch;
            gap: 24px;
        }

        .product-card {
            min-width: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            background: var(--surface);
            border: 1px solid rgba(224, 212, 202, 0.7);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(64, 43, 34, 0.035);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(64, 43, 34, 0.10);
        }

        /*
         * IMAGE DISPLAY FIX:
         * Use a portrait-shaped display area instead of a fixed height.
         * The entire product image is fitted inside this area.
         */
        .product-image-wrap {
            position: relative;
            width: 100%;
            aspect-ratio: 3 / 4;
            overflow: hidden;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            background: #f3eee8;
        }

        .image-fallback {
            position: absolute;
            inset: 0;
            display: grid;
            place-content: center;
            justify-items: center;
            gap: 8px;
            color: #9c8879;
            font-family: Georgia, serif;
            font-size: 12px;
            letter-spacing: 2px;
            text-align: center;
        }

        .image-fallback span {
            font-size: 30px;
        }

        .product-image {
            position: relative;
            z-index: 1;
            display: block;
            width: 100%;
            height: 100%;

            /* Main fix: show the full image without cropping */
            object-fit: contain;
            object-position: center center;

            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.02);
        }

        .product-number {
            position: absolute;
            top: 13px;
            left: 13px;
            z-index: 2;
            padding: 6px 10px;
            border: 1px solid rgba(255, 255, 255, 0.7);
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.92);
            color: var(--primary);
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.6px;
        }

        .product-info {
            display: flex;
            flex: 1;
            flex-direction: column;
            padding: 19px;
        }

        .product-label {
            margin-bottom: 7px;
            color: #a18b7b;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.7px;
            text-transform: uppercase;
        }

        .product-name {
            margin: 0 0 8px;
            font-family: Georgia, serif;
            font-size: 19px;
            font-weight: 500;
            line-height: 1.4;
            overflow-wrap: anywhere;
        }

        .product-price {
            margin-bottom: 17px;
            color: var(--primary);
            font-size: 20px;
            font-weight: 700;
        }

        .sizes-title {
            margin-bottom: 8px;
            color: var(--muted);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.6px;
            text-transform: uppercase;
        }

        .sizes {
            display: flex;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 6px;
            min-height: 28px;
            margin-bottom: 20px;
        }

        .size-chip {
            padding: 5px 9px;
            background: #f8f4f0;
            border: 1px solid #e9ded5;
            border-radius: 6px;
            color: #655349;
            font-size: 11px;
        }

        .no-sizes {
            color: var(--muted);
            font-size: 12px;
        }

        .product-actions {
            display: flex;
            gap: 9px;
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid #f0eae5;
        }

        .edit-btn,
        .delete-btn {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 40px;
            padding: 9px 10px;
            border: 1px solid transparent;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            font-size: 12px;
            font-weight: 700;
            transition: 0.2s ease;
        }

        .edit-btn {
            background: var(--primary);
            color: white;
        }

        .edit-btn:hover {
            background: var(--primary-dark);
        }

        .delete-btn {
            background: #fff;
            color: #9d443b;
            border-color: #ead6d2;
        }

        .delete-btn:hover {
            background: #fff0ed;
            border-color: #d9aca5;
        }

        .empty-state {
            grid-column: 1 / -1;
            padding: 65px 20px;
            background: white;
            border: 1px dashed #d9c9bd;
            border-radius: 16px;
            text-align: center;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            display: grid;
            place-items: center;
            margin: 0 auto 17px;
            border-radius: 50%;
            background: #f3eae3;
            color: var(--primary);
            font-family: Georgia, serif;
            font-size: 29px;
        }

        .empty-state h3 {
            margin: 0 0 8px;
            font-family: Georgia, serif;
            font-size: 24px;
            font-weight: 500;
        }

        .empty-state p {
            margin: 0 0 22px;
            color: var(--muted);
            font-size: 13px;
        }

        .footer {
            margin-top: 45px;
            padding-top: 22px;
            border-top: 1px solid var(--border);
            color: var(--muted);
            text-align: center;
            font-size: 11px;
            letter-spacing: 0.5px;
        }

        @media (max-width: 1150px) {
            .products-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: 20px;
            }

            .product-info {
                padding: 16px;
            }
        }

        @media (max-width: 850px) {
            .products-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 18px;
            }

            .hero {
                padding: 28px;
            }
        }

        @media (max-width: 580px) {
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
                padding: 26px 22px;
                border-radius: 15px;
            }

            .hero-count {
                min-width: 105px;
                padding: 10px 15px;
            }

            .hero-count strong {
                font-size: 28px;
            }

            .section-toolbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .add-btn {
                width: 100%;
            }

            .products-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 12px;
            }

            /* Keep the same portrait ratio on smaller screens. */
            .product-image-wrap {
                aspect-ratio: 3 / 4;
            }

            .product-info {
                padding: 12px;
            }

            .product-name {
                font-size: 16px;
            }

            .product-price {
                font-size: 17px;
                margin-bottom: 12px;
            }

            .product-actions {
                gap: 6px;
            }

            .edit-btn,
            .delete-btn {
                padding: 8px 5px;
                font-size: 11px;
            }

            .product-number {
                top: 8px;
                left: 8px;
                padding: 5px 7px;
                font-size: 9px;
            }
        }

        @media (max-width: 350px) {
            .products-grid {
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
            <span class="admin-label">Product Management</span>

            <a class="back-btn"
               href="<%= contextPath %>/admin/dashboard">
                &#8592; Dashboard
            </a>
        </div>
    </nav>

    <main class="page-container">

        <div class="breadcrumb">
            ADMINISTRATION &nbsp;/&nbsp; <span>PRODUCTS</span>
        </div>

        <section class="hero">
            <div class="hero-content">
                <p class="eyebrow">Your Storefront Collection</p>

                <h1>Product Management</h1>

                <p>
                    Curate your collection, keep product details up to date,
                    and manage the pieces that define the Aura experience.
                </p>
            </div>

            <div class="hero-count">
                <strong><%= productCount %></strong>
                <span>Products Listed</span>
            </div>
        </section>

        <section class="section-toolbar">
            <div class="section-heading">
                <h2>Your Collection</h2>
                <p>
                    Manage product details, pricing, available sizes and listings.
                </p>
            </div>

            <a class="add-btn"
               href="<%= contextPath %>/admin/products/add">
                <span aria-hidden="true">＋</span>
                Add New Product
            </a>
        </section>

        <div class="toolbar-line"></div>

        <section class="products-grid" aria-label="Product collection">

            <% if (products != null && !products.isEmpty()) { %>

                <% for (Product p : products) {
                    String productName = p.getName() == null
                        ? "Unnamed Product" : p.getName();

                    String imageUrl = p.getImageUrl() == null
                        ? "" : p.getImageUrl();

                    String sizesText = p.getSizes() == null
                        ? "" : p.getSizes().trim();
                %>

                    <article class="product-card">

                        <div class="product-image-wrap">

                            <div class="image-fallback" aria-hidden="true">
                                <span>✧</span>
                                AURA COLLECTION
                            </div>

                            <img
                                class="product-image"
                                src="<%= contextPath %>/assets/images/products/<%= escapeHtml(imageUrl) %>"
                                alt="<%= escapeHtml(productName) %>"
                                loading="lazy"
                                onerror="this.style.display='none';"
                            >

                            <span class="product-number">
                                PRODUCT #<%= p.getProductId() %>
                            </span>
                        </div>

                        <div class="product-info">

                            <div class="product-label">
                                Aura Collection
                            </div>

                            <h3 class="product-name">
                                <%= escapeHtml(productName) %>
                            </h3>

                            <div class="product-price">
                                ₹<%= String.format(
                                    Locale.US, "%.2f", p.getPrice()
                                ) %>
                            </div>

                            <div class="sizes-title">Available Sizes</div>

                            <div class="sizes">
                                <% if (!sizesText.isEmpty()) {
                                    String[] availableSizes =
                                        sizesText.split("[,\\s]+");

                                    for (String size : availableSizes) {
                                        if (!size.trim().isEmpty()) {
                                %>
                                            <span class="size-chip">
                                                <%= escapeHtml(size.trim()) %>
                                            </span>
                                <%
                                        }
                                    }
                                } else {
                                %>
                                    <span class="no-sizes">
                                        No sizes listed
                                    </span>
                                <% } %>
                            </div>

                            <div class="product-actions">

                                <a class="edit-btn"
                                   href="<%= contextPath %>/admin/products/edit?id=<%= p.getProductId() %>">
                                    <span aria-hidden="true">&#9998;</span>
                                    Edit
                                </a>

                                <a class="delete-btn"
                                   href="<%= contextPath %>/admin/products/delete?id=<%= p.getProductId() %>"
                                   onclick="return confirm('Are you sure you want to delete this product?');">
                                    <span aria-hidden="true">&#128465;</span>
                                    Delete
                                </a>

                            </div>
                        </div>
                    </article>

                <% } %>

            <% } else { %>

                <div class="empty-state">
                    <div class="empty-icon">✧</div>

                    <h3>Your collection starts here</h3>

                    <p>
                        There are no products to display yet.
                        Add your first product to get started.
                    </p>

                    <a class="add-btn"
                       href="<%= contextPath %>/admin/products/add">
                        ＋ Add Your First Product
                    </a>
                </div>

            <% } %>

        </section>

        <footer class="footer">
            AURA ADMIN STUDIO &nbsp;·&nbsp;
            THOUGHTFULLY MANAGING YOUR COLLECTION
        </footer>

    </main>

</body>
</html>
