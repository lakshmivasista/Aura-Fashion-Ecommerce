
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Aura Fashion</title>

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/assets/css/style.css">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&display=swap"
          rel="stylesheet">
</head>

<body>

    <!-- NAVBAR -->
    <div class="nav-links-left">
        <a href="home">Home</a>
        <a href="products">Shop</a>
        <a href="cart">Cart</a>

        <!-- My Orders -->
        <a href="${pageContext.request.contextPath}/my-orders">
            My Orders
        </a>

        <a href="logout">Logout</a>
    </div>

    <!-- HERO SECTION -->
    <div class="hero">
        <div class="hero-content">

            <h1 class="luxury-fade luxury-title">AURA</h1>

            <p class="luxury-fade luxury-sub">
                WHERE STYLE MEETS AFFORDABILITY
            </p>

            <a href="products">
                <button class="shop-btn luxury-fade luxury-btn"
                        onclick="window.location.href='${pageContext.request.contextPath}/products'">
                    Shop Now
                </button>
            </a>

        </div>
    </div>

</body>
</html>
