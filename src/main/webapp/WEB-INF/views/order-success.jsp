<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Success</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style7.css">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap"
          rel="stylesheet">
</head>

<body style="
    background: url('${pageContext.request.contextPath}/assets/images/final.jpg')
    no-repeat center center fixed;
    background-size: cover;
">

    <!-- Blur Overlay -->
    <div class="blur-overlay"></div>

    <div class="success-container">

        <div class="success-card">

            <div class="check-icon">✔</div>

            <h2>Thank you for ordering!</h2>

            <p>Your order has been placed successfully</p>

            <div class="btn-group"
                 style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">

                <!-- View Order History -->
                <a href="${pageContext.request.contextPath}/my-orders"
                   class="continue-btn">
                    View My Orders
                </a>

                <!-- Continue Shopping -->
                <a href="${pageContext.request.contextPath}/products"
                   class="continue-btn">
                    Continue Shopping
                </a>

            </div>

        </div>

    </div>

</body>
</html>