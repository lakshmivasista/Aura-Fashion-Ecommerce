<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.aura.model.CartItem" %>

<!DOCTYPE html>

<html>

<head>

    <title>Aura Cart</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style4.css">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&family=Poppins:wght@300;400;500&display=swap"
          rel="stylesheet">

</head>

<body>

    <!-- BACKGROUND -->

    <div class="bg-layer"></div>


    <!-- TOP BAR -->

    <div class="cart-topbar">

        <a href="${pageContext.request.contextPath}/products"
           class="back-btn">
            &#8592;
        </a>

        <h2>CART</h2>

    </div>


    <!-- CONTAINER -->

    <div class="cart-container">

<%

    List<CartItem> items =
            (List<CartItem>) request.getAttribute("cartItems");

    double total = 0;


    if (items != null && !items.isEmpty()) {

        for (CartItem item : items) {

            double sub =
                    item.getPrice() * item.getQuantity();

            total += sub;

%>

        <!-- =====================================================
             ITEM CARD
             ===================================================== -->

        <div class="cart-item">


            <!-- IMAGE -->

            <img src="<%=request.getContextPath()%>/assets/images/products/<%=item.getImageUrl()%>"
                 class="cart-img">


            <!-- DETAILS -->

            <div class="cart-details">

                <h3>
                    <%=item.getProductName()%>
                </h3>


                <!-- ✅ ACTUAL SELECTED SIZE -->

                <p>
                    Size: <%=item.getSize()%>
                </p>


                <!-- PRICE -->

                <p class="price">
                    ₹<%=item.getPrice()%>
                </p>


                <!-- =================================================
                     QUANTITY
                     ================================================= -->

                <div class="quantity">


                    <!-- DECREASE -->

                    <form action="<%=request.getContextPath()%>/update-cart"
                          method="post">

                        <input type="hidden"
                               name="cartItemId"
                               value="<%=item.getCartItemId()%>">

                        <input type="hidden"
                               name="action"
                               value="decrease">

                        <button type="submit">
                            -
                        </button>

                    </form>


                    <!-- CURRENT QUANTITY -->

                    <span>
                        <%=item.getQuantity()%>
                    </span>


                    <!-- INCREASE -->

                    <form action="<%=request.getContextPath()%>/update-cart"
                          method="post">

                        <input type="hidden"
                               name="cartItemId"
                               value="<%=item.getCartItemId()%>">

                        <input type="hidden"
                               name="action"
                               value="increase">

                        <button type="submit">
                            +
                        </button>

                    </form>

                </div>


                <!-- SUBTOTAL -->

                <p>
                    Subtotal: ₹<%=sub%>
                </p>

            </div>


            <!-- =================================================
                 REMOVE
                 ================================================= -->

            <form action="<%=request.getContextPath()%>/remove-item"
                  method="post">

                <input type="hidden"
                       name="cartItemId"
                       value="<%=item.getCartItemId()%>">

                <button type="submit"
                        class="remove-btn">
                    ✕
                </button>

            </form>

        </div>


<%

        }

%>


        <!-- =====================================================
             TOTAL
             ===================================================== -->

        <h3 style="padding: 20px;">
            Total: ₹<%=total%>
        </h3>


        <!-- =====================================================
             CHECKOUT
             ===================================================== -->

        <div style="padding: 20px;">

            <button class="checkout-btn"
                    onclick="window.location.href='<%=request.getContextPath()%>/address'">

                Checkout

            </button>

        </div>


<%

    } else {

%>


        <!-- =====================================================
             EMPTY CART
             ===================================================== -->

        <div class="empty-cart">

            Your cart is empty

        </div>


<%

    }

%>

    </div>


    <!-- =========================================================
         CART BACKGROUND IMAGE
         ========================================================= -->

    <style>

        body {

            background:
                url('${pageContext.request.contextPath}/assets/images/cart.jpg')
                no-repeat center center fixed;

            background-size: cover;

        }

    </style>


</body>

</html>