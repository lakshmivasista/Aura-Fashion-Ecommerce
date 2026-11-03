
<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map, com.aura.model.Product" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aura - My Wishlist</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px;
            font-family: 'Poppins', sans-serif;
            color: #302923;
            background:
                linear-gradient(
                    rgba(255, 255, 255, 0.30),
                    rgba(255, 255, 255, 0.30)
                ),
                url("<%= request.getContextPath() %>/assets/images/Myorders.jpg")
                no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
        }

        .page-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        /* PAGE HEADER */

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 32px;
            margin: 0 0 7px;
        }

        .subtitle {
            margin: 0;
            color: #655951;
            font-size: 13px;
        }

        .shop-btn {
            display: inline-block;
            padding: 11px 17px;
            background: #51352f;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12px;
            transition: background 0.2s ease;
        }

        .shop-btn:hover {
            background: #754d43;
        }

        /* ONE-TIME FEEDBACK MESSAGE */

        .message {
            padding: 13px 17px;
            margin-bottom: 20px;
            border-radius: 9px;
            font-size: 13px;
            font-weight: 500;
        }

        .message-success {
            background: #e5f4e8;
            color: #286c3c;
            border: 1px solid #c8e7ce;
        }

        .message-error {
            background: #fde9e7;
            color: #a2342c;
            border: 1px solid #f4c9c5;
        }

        /* WISHLIST COUNT */

        .wishlist-summary {
            background: rgba(255, 255, 255, 0.96);
            border-radius: 11px;
            padding: 18px 22px;
            margin-bottom: 24px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.07);
        }

        .wishlist-summary p {
            margin: 0 0 4px;
            color: #777;
            font-size: 12px;
        }

        .wishlist-summary h2 {
            margin: 0;
            font-size: 25px;
        }

        /* PRODUCT GRID */

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(225px, 1fr));
            align-items: stretch;
            gap: 22px;
        }

        .product-card {
            min-width: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 11px;
            box-shadow: 0 3px 13px rgba(0, 0, 0, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 7px 18px rgba(0, 0, 0, 0.12);
        }

        .product-image {
            display: block;
            width: 100%;
            height: 255px;
            padding: 8px;
            flex-shrink: 0;
            object-fit: contain;
            object-position: center;
            background: #f8f5f2;
        }

        .image-placeholder {
            width: 100%;
            height: 255px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f5f2;
            font-size: 38px;
        }

        /* PRODUCT INFORMATION */

        .product-info {
            display: flex;
            flex: 1;
            flex-direction: column;
            padding: 15px;
        }

        .product-name {
            min-height: 44px;
            font-family: 'Playfair Display', serif;
            font-size: 16px;
            line-height: 1.4;
            margin: 0 0 9px;
            overflow-wrap: anywhere;
        }

        .product-price {
            color: #51352f;
            font-size: 17px;
            font-weight: 600;
            margin: 0 0 15px;
        }

        /* ADD TO CART */

        .add-cart-form {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 12px;
        }

        .size-label {
            font-size: 12px;
            font-weight: 500;
            color: #51352f;
        }

        .size-select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d8c9c1;
            border-radius: 7px;
            background: #fff;
            color: #302923;
            font-family: 'Poppins', sans-serif;
            font-size: 12px;
            outline: none;
        }

        .size-select:focus {
            border-color: #754d43;
        }

        .add-cart-btn {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #51352f;
            border-radius: 7px;
            background: #51352f;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .add-cart-btn:hover {
            background: #754d43;
        }

        .no-sizes {
            color: #a2342c;
            font-size: 12px;
            margin: 0 0 12px;
        }

        /* REMOVE FROM WISHLIST */

        .remove-form {
            margin: auto 0 0;
            padding-top: 2px;
        }

        .remove-btn {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #a2342c;
            border-radius: 7px;
            background: white;
            color: #a2342c;
            font-family: 'Poppins', sans-serif;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .remove-btn:hover {
            background: #a2342c;
            color: white;
        }

        /* EMPTY WISHLIST */

        .empty-state {
            text-align: center;
            padding: 55px 20px;
            background: rgba(255, 255, 255, 0.97);
            border-radius: 13px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
        }

        .empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }

        .empty-state h2 {
            font-family: 'Playfair Display', serif;
            font-size: 25px;
            margin: 0 0 10px;
        }

        .empty-state p {
            color: #777;
            margin: 0 0 23px;
            font-size: 13px;
        }

        /* RESPONSIVE DESIGN */

        @media (max-width: 600px) {
            body {
                padding: 20px 14px;
                background-attachment: scroll;
            }

            .page-header h1 {
                font-size: 27px;
            }

            .product-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                gap: 13px;
            }

            .product-image,
            .image-placeholder {
                height: 190px;
            }

            .product-info {
                padding: 11px;
            }

            .product-name {
                font-size: 14px;
                min-height: 40px;
            }

            .product-price {
                font-size: 15px;
            }

            .remove-btn,
            .add-cart-btn {
                padding: 9px 5px;
                font-size: 11px;
            }

            .size-select {
                padding: 9px 5px;
                font-size: 11px;
            }
        }

        @media (max-width: 360px) {
            .product-grid {
                grid-template-columns: 1fr;
            }

            .product-image,
            .image-placeholder {
                height: 240px;
            }
        }
    </style>
</head>

<body>

<div class="page-container">

    <!-- PAGE HEADER -->

    <div class="page-header">
        <div>
            <h1>
                My Wishlist
                <span style="color:#a2342c;">&#9829;</span>
            </h1>

            <p class="subtitle">
                Your favourite styles, saved in one place.
            </p>
        </div>

        <a href="<%= request.getContextPath() %>/products"
           class="shop-btn">
            &#8592; Continue Shopping
        </a>
    </div>

    <%
        List<Product> wishlistProducts =
                (List<Product>) request.getAttribute("wishlistProducts");

        Map<Integer, Map<Integer, String>> wishlistVariantsMap =
                (Map<Integer, Map<Integer, String>>)
                        request.getAttribute("wishlistVariantsMap");

        int wishlistCount =
                wishlistProducts == null ? 0 : wishlistProducts.size();

        String message =
                (String) request.getAttribute("wishlistMessage");

        String contextPath = request.getContextPath();
    %>

    <!-- ONE-TIME WISHLIST FEEDBACK -->

    <% if ("added".equals(message)) { %>

        <div class="message message-success">
            &#10003; Product added to your wishlist.
        </div>

    <% } else if ("removed".equals(message)) { %>

        <div class="message message-success">
            &#10003; Product removed from your wishlist.
        </div>

    <% } else if ("invalid".equals(message)) { %>

        <div class="message message-error">
            Invalid product request. Please try again.
        </div>

    <% } else if ("error".equals(message)) { %>

        <div class="message message-error">
            Something went wrong. Please try again.
        </div>

    <% } %>

    <!-- WISHLIST SUMMARY -->

    <div class="wishlist-summary">
        <p>Saved products</p>
        <h2><%= wishlistCount %></h2>
    </div>

    <!-- PRODUCT CARDS -->

    <% if (wishlistProducts != null && !wishlistProducts.isEmpty()) { %>

        <div class="product-grid">

            <% for (Product product : wishlistProducts) {

                String imageSrc = product.getImageUrl();

                if (imageSrc != null && !imageSrc.trim().isEmpty()) {

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

                        imageSrc = contextPath
                                + "/assets/images/products/"
                                + imageSrc;
                    }
                }

                boolean hasImage =
                        imageSrc != null && !imageSrc.trim().isEmpty();

                Map<Integer, String> productVariants =
                        wishlistVariantsMap == null
                        ? null
                        : wishlistVariantsMap.get(product.getProductId());
            %>

                <div class="product-card">

                    <!-- PRODUCT IMAGE -->

                    <% if (hasImage) { %>

                        <img class="product-image"
                             src="<%= imageSrc %>"
                             alt="Aura fashion product"
                             loading="lazy"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                        <div class="image-placeholder" style="display:none;">
                            &#128717;
                        </div>

                    <% } else { %>

                        <div class="image-placeholder">
                            &#128717;
                        </div>

                    <% } %>

                    <!-- PRODUCT DETAILS -->

                    <div class="product-info">

                        <h3 class="product-name">
                            <%= product.getName() == null
                                    ? "Aura Product"
                                    : product.getName() %>
                        </h3>

                        <p class="product-price">
                            &#8377;<%= String.format(
                                    java.util.Locale.US,
                                    "%.2f",
                                    product.getPrice()) %>
                        </p>

                        <!-- ADD TO CART WITH SIZE SELECTION -->

                        <% if (productVariants != null
                                && !productVariants.isEmpty()) { %>

                            <form class="add-cart-form"
                                  action="<%= contextPath %>/add-to-cart"
                                  method="post">

                                <input type="hidden"
                                       name="productId"
                                       value="<%= product.getProductId() %>">

                                <input type="hidden"
                                       name="returnTo"
                                       value="cart">

                                <label class="size-label"
                                       for="wishlist-size-<%= product.getProductId() %>">
                                    Select Size
                                </label>

                                <select class="size-select"
                                        id="wishlist-size-<%= product.getProductId() %>"
                                        name="variantId"
                                        required>

                                    <option value="" disabled selected>
                                        Choose your size
                                    </option>

                                    <% for (Map.Entry<Integer, String> variant
                                            : productVariants.entrySet()) { %>

                                        <option value="<%= variant.getKey() %>">
                                            <%= variant.getValue() %>
                                        </option>

                                    <% } %>

                                </select>

                                <button type="submit" class="add-cart-btn">
                                    Add to Cart
                                </button>

                            </form>

                        <% } else { %>

                            <p class="no-sizes">
                                No sizes currently available.
                            </p>

                        <% } %>

                        <!-- REMOVE FROM WISHLIST -->

                        <form class="remove-form"
                              action="<%= contextPath %>/wishlist"
                              method="post"
                              onsubmit="return confirm('Remove this product from your wishlist?');">

                            <input type="hidden"
                                   name="productId"
                                   value="<%= product.getProductId() %>">

                            <input type="hidden"
                                   name="action"
                                   value="remove">

                            <button type="submit" class="remove-btn">
                                &#9829; Remove from Wishlist
                            </button>

                        </form>

                    </div>

                </div>

            <% } %>

        </div>

    <% } else { %>

        <!-- EMPTY WISHLIST -->

        <div class="empty-state">

            <div class="empty-icon">&#9825;</div>

            <h2>Your wishlist is waiting</h2>

            <p>
                You haven't saved any products yet.
                Explore the collection and save the styles you love.
            </p>

            <a href="<%= contextPath %>/products"
               class="shop-btn">
                Explore Collection
            </a>

        </div>

    <% } %>

</div>

</body>
</html>
