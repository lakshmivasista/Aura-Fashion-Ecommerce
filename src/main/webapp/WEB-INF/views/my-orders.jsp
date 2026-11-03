
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat, com.aura.model.Order, com.aura.model.OrderItem, com.aura.model.Address" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Aura - My Orders</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 35px;
            font-family: 'Poppins', sans-serif;
            color: #302923;
            background-image:
                linear-gradient(
                    rgba(255, 255, 255, 0.28),
                    rgba(255, 255, 255, 0.28)
                ),
                url("<%= request.getContextPath() %>/assets/images/Myorders.jpg");
            background-repeat: no-repeat;
            background-position: center center;
            background-size: cover;
            background-attachment: fixed;
            min-height: 100vh;
        }

        .page-container {
            max-width: 1100px;
            margin: auto;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
        }

        .topbar h1 {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            margin: 0 0 8px;
        }

        .subtitle {
            margin: 0;
            color: #615750;
            font-size: 14px;
        }

        .back-btn,
        .shop-btn {
            display: inline-block;
            padding: 12px 18px;
            border: none;
            border-radius: 8px;
            background: #51352f;
            color: white;
            text-decoration: none;
            font-size: 13px;
            transition: background 0.2s ease;
            cursor: pointer;
        }

        .back-btn:hover,
        .shop-btn:hover {
            background: #754d43;
        }

        .orders-summary {
            background: rgba(255, 255, 255, 0.96);
            border-radius: 12px;
            padding: 22px 25px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }

        .orders-summary p {
            margin: 0 0 6px;
            color: #777;
            font-size: 14px;
        }

        .orders-summary h2 {
            margin: 0;
            font-size: 29px;
        }

        .order-card {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 22px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 15px;
            padding-bottom: 18px;
            border-bottom: 1px solid #eee8e3;
        }

        .order-label {
            margin: 0 0 5px;
            color: #777;
            font-size: 12px;
        }

        .order-id {
            margin: 0;
            font-size: 19px;
            font-weight: 600;
        }

        /* ORDER STATUS BADGES */

        .status-badge {
            display: inline-block;
            padding: 8px 13px;
            border-radius: 20px;
            background: #f1e9dc;
            color: #76572c;
            font-size: 12px;
            font-weight: 600;
        }

        .status-placed {
            background: #f1e9dc;
            color: #76572c;
        }

        .status-processing {
            background: #e9edff;
            color: #354c9b;
        }

        .status-shipped {
            background: #e2f2fb;
            color: #176385;
        }

        .status-delivered {
            background: #e5f4e8;
            color: #286c3c;
        }

        .status-cancelled {
            background: #fde9e7;
            color: #a2342c;
        }

        /* CANCEL ORDER BUTTON */

        .cancel-order-row {
            display: flex;
            justify-content: flex-end;
            padding-top: 18px;
        }

        .cancel-btn {
            padding: 11px 17px;
            border: 1px solid #a2342c;
            border-radius: 8px;
            background: #fff;
            color: #a2342c;
            font-family: 'Poppins', sans-serif;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .cancel-btn:hover {
            background: #a2342c;
            color: #fff;
        }

        /* CANCELLATION FEEDBACK */

        .cancel-message {
            padding: 14px 18px;
            margin-bottom: 20px;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 500;
        }

        .cancel-success {
            background: #e5f4e8;
            color: #286c3c;
            border: 1px solid #c8e7ce;
        }

        .cancel-error {
            background: #fde9e7;
            color: #a2342c;
            border: 1px solid #f4c9c5;
        }

        /* ORDER TRACKING TIMELINE */

        .tracking-section {
            padding: 22px 0;
            border-bottom: 1px solid #eee8e3;
        }

        .tracking-heading {
            font-family: 'Playfair Display', serif;
            font-size: 19px;
            margin: 0 0 22px;
        }

        .tracking-timeline {
            display: flex;
            width: 100%;
            margin-top: 8px;
        }

        .tracking-step {
            flex: 1;
            min-width: 0;
            position: relative;
            text-align: center;
            padding-top: 25px;
            color: #948a84;
            font-size: 11px;
            line-height: 1.5;
            z-index: 1;
        }

        .tracking-step::before {
            content: "";
            position: absolute;
            top: 0;
            left: calc(50% - 7px);
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: #e4ddd8;
            border: 2px solid #e4ddd8;
            z-index: 2;
        }

        .tracking-step:not(:last-child)::after {
            content: "";
            position: absolute;
            top: 5px;
            left: 50%;
            width: 100%;
            height: 4px;
            background: #e4ddd8;
            z-index: -1;
        }

        .tracking-step.completed {
            color: #51352f;
            font-weight: 600;
        }

        .tracking-step.completed::before {
            background: #51352f;
            border-color: #51352f;
        }

        .tracking-step.connector-complete:not(:last-child)::after {
            background: #51352f;
        }

        .cancelled-state {
            margin-top: 20px;
            padding: 15px;
            background: #fde9e7;
            color: #a2342c;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
        }

        /* PURCHASED PRODUCTS */

        .items-section {
            padding: 22px 0;
            border-bottom: 1px solid #eee8e3;
        }

        .items-title {
            font-family: 'Playfair Display', serif;
            font-size: 20px;
            margin: 0 0 18px;
        }

        .order-item {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 15px 0;
            border-bottom: 1px solid #f0ebe7;
        }

        .order-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .item-image {
            width: 100px;
            height: 120px;
            flex-shrink: 0;
            object-fit: cover;
            border-radius: 8px;
            background: #f5f0ec;
        }

        .item-info {
            flex: 1;
            min-width: 0;
        }

        .item-name {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 9px;
            overflow-wrap: anywhere;
        }

        .item-meta {
            color: #777;
            font-size: 13px;
            line-height: 1.9;
        }

        .item-price {
            text-align: right;
            min-width: 110px;
        }

        .item-unit-price {
            color: #777;
            font-size: 12px;
            margin-bottom: 7px;
        }

        .item-line-total {
            color: #51352f;
            font-size: 17px;
            font-weight: 600;
        }

        /* ORDER SUMMARY DETAILS */

        .order-details {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            padding-top: 20px;
        }

        .detail-label {
            display: block;
            color: #777;
            font-size: 12px;
            margin-bottom: 7px;
        }

        .detail-value {
            font-size: 14px;
            font-weight: 500;
            overflow-wrap: anywhere;
        }

        .order-total {
            font-size: 18px;
            font-weight: 600;
            color: #51352f;
        }

        /* DELIVERY ADDRESS */

        .delivery-address-section {
            padding-top: 22px;
        }

        .delivery-address-title {
            font-family: 'Playfair Display', serif;
            font-size: 19px;
            margin: 0 0 15px;
        }

        .delivery-address-card {
            background: #faf7f4;
            border: 1px solid #eee4dd;
            border-radius: 10px;
            padding: 17px 20px;
            line-height: 1.8;
        }

        .delivery-address-card p {
            margin: 0;
            font-size: 13px;
            color: #655951;
            overflow-wrap: anywhere;
        }

        .delivery-address-card .delivery-name {
            color: #51352f;
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .delivery-address-card .delivery-phone {
            margin-top: 7px;
            font-weight: 500;
        }

        /* EMPTY ORDER HISTORY */

        .empty-state {
            text-align: center;
            background: rgba(255, 255, 255, 0.96);
            border-radius: 12px;
            padding: 55px 20px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
        }

        .empty-icon {
            font-size: 42px;
            margin-bottom: 15px;
        }

        .empty-state h2 {
            font-family: 'Playfair Display', serif;
            margin: 0 0 10px;
        }

        .empty-state p {
            color: #777;
            font-size: 14px;
            margin-bottom: 25px;
        }

        /* RESPONSIVE LAYOUT */

        @media (max-width: 650px) {
            body {
                padding: 22px 14px;
                background-attachment: scroll;
            }

            .topbar h1 {
                font-size: 27px;
            }

            .order-card {
                padding: 19px;
            }

            .order-details {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 20px 12px;
            }

            .order-item {
                gap: 12px;
                align-items: flex-start;
            }

            .item-image {
                width: 76px;
                height: 95px;
            }

            .item-name {
                font-size: 14px;
            }

            .item-meta {
                font-size: 12px;
            }

            .item-price {
                min-width: 75px;
            }

            .item-line-total {
                font-size: 14px;
            }

            .tracking-step {
                font-size: 9px;
            }

            .delivery-address-card {
                padding: 14px;
            }
        }

        @media (max-width: 420px) {
            .item-image {
                width: 65px;
                height: 85px;
            }

            .item-price {
                min-width: 65px;
            }

            .item-unit-price {
                font-size: 11px;
            }
        }
    </style>
</head>

<body>

<div class="page-container">

    <!-- PAGE HEADER -->

    <div class="topbar">
        <div>
            <h1>My Orders</h1>
            <p class="subtitle">
                Track your Aura purchases and order status.
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/products"
           class="back-btn">
            &#8592; Continue Shopping
        </a>
    </div>

    <%
        List<Order> orders =
                (List<Order>) request.getAttribute("orders");

        Map<Integer, List<OrderItem>> orderItemsMap =
                (Map<Integer, List<OrderItem>>)
                        request.getAttribute("orderItemsMap");

        Map<Integer, Address> orderAddressesMap =
                (Map<Integer, Address>)
                        request.getAttribute("orderAddressesMap");

        int orderCount = orders == null ? 0 : orders.size();

        SimpleDateFormat dateFormat =
                new SimpleDateFormat("dd MMM yyyy, hh:mm a");

        String contextPath = request.getContextPath();
    %>

    <!-- ONE-TIME CANCELLATION RESULT MESSAGE -->

    <%
        String cancelOrderMessage =
                (String) session.getAttribute("cancelOrderMessage");

        if (cancelOrderMessage != null) {
            session.removeAttribute("cancelOrderMessage");
        }
    %>

    <% if ("success".equals(cancelOrderMessage)) { %>

        <div class="cancel-message cancel-success">
            &#10003; Your order has been cancelled successfully.
        </div>

    <% } else if ("invalid".equals(cancelOrderMessage)) { %>

        <div class="cancel-message cancel-error">
            Invalid order request. Please try again.
        </div>

    <% } else if ("failed".equals(cancelOrderMessage)) { %>

        <div class="cancel-message cancel-error">
            This order could not be cancelled. It may already be processing,
            shipped, delivered, or cancelled.
        </div>

    <% } %>

    <!-- ORDER COUNT -->

    <div class="orders-summary">
        <p>Total orders</p>
        <h2><%= orderCount %></h2>
    </div>

    <!-- CUSTOMER ORDER HISTORY -->

    <% if (orders != null && !orders.isEmpty()) { %>

        <% for (Order order : orders) {

            String status = order.getStatus();

            if (status == null || status.trim().isEmpty()) {
                status = "UNKNOWN";
            }

            String statusClass;

            switch (status) {
                case "PROCESSING":
                    statusClass = "status-processing";
                    break;
                case "SHIPPED":
                    statusClass = "status-shipped";
                    break;
                case "DELIVERED":
                    statusClass = "status-delivered";
                    break;
                case "CANCELLED":
                    statusClass = "status-cancelled";
                    break;
                case "PLACED":
                    statusClass = "status-placed";
                    break;
                default:
                    statusClass = "";
                    break;
            }

            List<OrderItem> items =
                    orderItemsMap == null
                    ? null
                    : orderItemsMap.get(order.getOrderId());

            Address deliveryAddress =
                    orderAddressesMap == null
                    ? null
                    : orderAddressesMap.get(order.getOrderId());

            boolean isCancelled =
                    "CANCELLED".equalsIgnoreCase(status);

            boolean placedComplete =
                    "PLACED".equalsIgnoreCase(status)
                    || "PROCESSING".equalsIgnoreCase(status)
                    || "SHIPPED".equalsIgnoreCase(status)
                    || "DELIVERED".equalsIgnoreCase(status);

            boolean processingComplete =
                    "PROCESSING".equalsIgnoreCase(status)
                    || "SHIPPED".equalsIgnoreCase(status)
                    || "DELIVERED".equalsIgnoreCase(status);

            boolean shippedComplete =
                    "SHIPPED".equalsIgnoreCase(status)
                    || "DELIVERED".equalsIgnoreCase(status);

            boolean deliveredComplete =
                    "DELIVERED".equalsIgnoreCase(status);
        %>

            <div class="order-card">

                <!-- ORDER NUMBER AND CURRENT STATUS -->

                <div class="order-header">

                    <div>
                        <p class="order-label">Order number</p>

                        <h2 class="order-id">
                            #<%= order.getOrderId() %>
                        </h2>
                    </div>

                    <div>
                        <p class="order-label">Current status</p>

                        <span class="status-badge <%= statusClass %>">
                            <%= status %>
                        </span>
                    </div>

                </div>

                <!-- CUSTOMER CANCEL ORDER ACTION -->

                <% if ("PLACED".equalsIgnoreCase(status)) { %>

                    <div class="cancel-order-row">

                        <form action="${pageContext.request.contextPath}/cancel-order"
                              method="post"
                              onsubmit="return confirm('Are you sure you want to cancel this order?');">

                            <input type="hidden"
                                   name="orderId"
                                   value="<%= order.getOrderId() %>">

                            <button type="submit" class="cancel-btn">
                                &#10005; Cancel Order
                            </button>

                        </form>

                    </div>

                <% } %>

                <!-- ORDER TRACKING TIMELINE -->

                <% if (isCancelled) { %>

                    <div class="tracking-section">

                        <h3 class="tracking-heading">
                            Order Tracking
                        </h3>

                        <div class="cancelled-state">
                            &#10006; This order has been cancelled.
                        </div>

                    </div>

                <% } else { %>

                    <div class="tracking-section">

                        <h3 class="tracking-heading">
                            Order Tracking
                        </h3>

                        <div class="tracking-timeline">

                            <div class="tracking-step <%= placedComplete ? "completed" : "" %> <%= processingComplete ? "connector-complete" : "" %>">
                                Order Placed
                            </div>

                            <div class="tracking-step <%= processingComplete ? "completed" : "" %> <%= shippedComplete ? "connector-complete" : "" %>">
                                Processing
                            </div>

                            <div class="tracking-step <%= shippedComplete ? "completed" : "" %> <%= deliveredComplete ? "connector-complete" : "" %>">
                                Shipped
                            </div>

                            <div class="tracking-step <%= deliveredComplete ? "completed" : "" %>">
                                Delivered
                            </div>

                        </div>

                    </div>

                <% } %>

                <!-- PURCHASED PRODUCTS -->

                <div class="items-section">

                    <h3 class="items-title">
                        Items in this order
                    </h3>

                    <% if (items != null && !items.isEmpty()) { %>

                        <% for (OrderItem item : items) {

                            String imageSrc = item.getImageUrl();

                            if (imageSrc != null
                                    && !imageSrc.trim().isEmpty()) {

                                imageSrc = imageSrc.trim();

                                if (imageSrc.startsWith("http://")
                                        || imageSrc.startsWith("https://")
                                        || imageSrc.startsWith("data:")) {

                                    // Keep full image URLs unchanged.

                                } else if (imageSrc.startsWith(contextPath + "/")) {

                                    // Context path is already included.

                                } else if (imageSrc.startsWith("/")) {

                                    imageSrc = contextPath + imageSrc;

                                } else if (imageSrc.startsWith("assets/")) {

                                    imageSrc = contextPath + "/" + imageSrc;

                                } else if (imageSrc.startsWith("images/")) {

                                    imageSrc = contextPath + "/assets/" + imageSrc;

                                } else {

                                    // Product images are in assets/images/products.
                                    imageSrc = contextPath
                                            + "/assets/images/products/"
                                            + imageSrc;
                                }
                            }

                            String size = item.getSize() == null
                                    || item.getSize().trim().isEmpty()
                                    ? "Not specified"
                                    : item.getSize();
                        %>

                            <div class="order-item">

                                <!-- PRODUCT IMAGE -->

                                <% if (imageSrc != null
                                        && !imageSrc.trim().isEmpty()) { %>

                                    <img class="item-image"
                                         src="<%= imageSrc %>"
                                         alt="<%= item.getProductName() == null
                                                    ? "Product image"
                                                    : item.getProductName() %>"
                                         loading="lazy"
                                         onerror="this.style.display='none';">

                                <% } else { %>

                                    <div class="item-image"
                                         style="display:flex; justify-content:center; align-items:center;">
                                        &#128717;
                                    </div>

                                <% } %>

                                <!-- PRODUCT INFORMATION -->

                                <div class="item-info">

                                    <h4 class="item-name">
                                        <%= item.getProductName() == null
                                                ? "Product"
                                                : item.getProductName() %>
                                    </h4>

                                    <div class="item-meta">

                                        <div>
                                            Size:
                                            <strong><%= size %></strong>
                                        </div>

                                        <div>
                                            Quantity:
                                            <strong><%= item.getQuantity() %></strong>
                                        </div>

                                    </div>

                                </div>

                                <!-- PRODUCT PRICE -->

                                <div class="item-price">

                                    <div class="item-unit-price">
                                        ₹<%= String.format(
                                                java.util.Locale.US,
                                                "%.2f",
                                                item.getPrice()) %>
                                        each
                                    </div>

                                    <div class="item-line-total">
                                        ₹<%= String.format(
                                                java.util.Locale.US,
                                                "%.2f",
                                                item.getLineTotal()) %>
                                    </div>

                                </div>

                            </div>

                        <% } %>

                    <% } else { %>

                        <p class="subtitle">
                            Product details are unavailable for this order.
                        </p>

                    <% } %>

                </div>

                <!-- ORDER SUMMARY DETAILS -->

                <div class="order-details">

                    <div>
                        <span class="detail-label">
                            Order date
                        </span>

                        <span class="detail-value">
                            <%= order.getCreatedAt() == null
                                    ? "—"
                                    : dateFormat.format(order.getCreatedAt()) %>
                        </span>
                    </div>

                    <div>
                        <span class="detail-label">
                            Payment method
                        </span>

                        <span class="detail-value">
                            <%= order.getPaymentMethod() == null
                                    ? "—"
                                    : order.getPaymentMethod() %>
                        </span>
                    </div>

                    <div>
                        <span class="detail-label">
                            Order total
                        </span>

                        <span class="detail-value order-total">
                            ₹<%= String.format(
                                    java.util.Locale.US,
                                    "%.2f",
                                    order.getTotalAmount()) %>
                        </span>
                    </div>

                </div>

                <!-- DELIVERY ADDRESS -->

                <div class="delivery-address-section">

                    <h3 class="delivery-address-title">
                        &#128205; Delivery Address
                    </h3>

                    <% if (deliveryAddress != null) { %>

                        <div class="delivery-address-card">

                            <p class="delivery-name">
                                <%= deliveryAddress.getFullName() == null
                                        ? ""
                                        : deliveryAddress.getFullName() %>
                            </p>

                            <p>
                                <%= deliveryAddress.getAddressLine() == null
                                        ? ""
                                        : deliveryAddress.getAddressLine() %>
                            </p>

                            <p>
                                <%= deliveryAddress.getCity() == null
                                        ? ""
                                        : deliveryAddress.getCity() %>,
                                <%= deliveryAddress.getState() == null
                                        ? ""
                                        : deliveryAddress.getState() %>
                                - <%= deliveryAddress.getPincode() == null
                                        ? ""
                                        : deliveryAddress.getPincode() %>
                            </p>

                            <p>
                                <%= deliveryAddress.getCountry() == null
                                        ? ""
                                        : deliveryAddress.getCountry() %>
                            </p>

                            <p class="delivery-phone">
                                Phone:
                                <%= deliveryAddress.getPhone() == null
                                        ? "—"
                                        : deliveryAddress.getPhone() %>
                            </p>

                        </div>

                    <% } else { %>

                        <p class="subtitle">
                            Delivery address is unavailable for this order.
                        </p>

                    <% } %>

                </div>

            </div>

        <% } %>

    <% } else { %>

        <!-- EMPTY ORDER HISTORY -->

        <div class="empty-state">

            <div class="empty-icon">&#128717;</div>

            <h2>No orders yet</h2>

            <p>
                Your Aura purchases will appear here
                after you successfully place an order.
            </p>

            <a href="${pageContext.request.contextPath}/products"
               class="shop-btn">
                Explore Collection
            </a>

        </div>

    <% } %>

</div>

</body>
</html>
