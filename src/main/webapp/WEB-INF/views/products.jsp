
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.aura.model.Product, com.aura.model.ProductVariant" %>

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

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Aura Products</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style3.css">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Poppins:wght@300;400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        .product-card {
            position: relative;
        }

        .wishlist-form {
            position: absolute;
            top: 12px;
            right: 12px;
            z-index: 10;
            margin: 0;
        }

        .wishlist-btn {
            width: 43px;
            height: 43px;
            display: flex;
            justify-content: center;
            align-items: center;
            border: none;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.97);
            color: #a2342c;
            font-size: 27px;
            line-height: 1;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
            transition: transform 0.2s ease, background 0.2s ease;
        }

        .wishlist-btn:hover {
            transform: scale(1.08);
        }

        .wishlist-btn.wishlisted {
            color: #d62828;
        }

        .wishlist-btn.wishlisted:hover {
            background: #d62828;
            color: white;
        }

        .wishlist-btn:not(.wishlisted):hover {
            background: #a2342c;
            color: white;
        }

        .wishlist-btn:focus-visible {
            outline: 2px solid #51352f;
            outline-offset: 3px;
        }

        .wishlist-link {
            text-decoration: none;
        }

        /* AURA AI VIRTUAL TRY-ON BANNER */

        .virtual-tryon-wrap {
            width: min(1240px, 92%);
            margin: 26px auto 32px;
            font-family: 'Poppins', sans-serif;
        }

        .virtual-tryon-banner {
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 30px 34px;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 19px;
            background: linear-gradient(115deg, #432c27, #74564a);
            color: #fff;
            box-shadow: 0 12px 32px rgba(64, 43, 34, 0.12);
        }

        .virtual-tryon-banner::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            top: -145px;
            right: 18%;
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            box-shadow:
                0 0 0 25px rgba(255, 255, 255, 0.025),
                0 0 0 50px rgba(255, 255, 255, 0.025);
            pointer-events: none;
        }

        .virtual-tryon-content {
            position: relative;
            z-index: 1;
            flex: 1;
        }

        .virtual-tryon-eyebrow {
            margin: 0 0 7px;
            color: #e5c9b6;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .virtual-tryon-title {
            margin: 0 0 9px;
            color: #fff;
            font-family: 'Playfair Display', Georgia, serif;
            font-size: clamp(24px, 3vw, 34px);
            font-weight: 500;
            line-height: 1.25;
        }

        .virtual-tryon-description {
            max-width: 580px;
            margin: 0;
            color: #eadbd2;
            font-size: 12px;
            line-height: 1.9;
        }

        .virtual-tryon-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 16px;
        }

        .virtual-tryon-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 30px;
            background: rgba(255, 255, 255, 0.07);
            color: #f4e7df;
            font-size: 10px;
        }

        .virtual-tryon-action {
            position: relative;
            z-index: 1;
            flex-shrink: 0;
        }

        .virtual-tryon-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 48px;
            padding: 13px 20px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            background: #fff;
            color: #51352f;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
            transition: transform 0.2s ease,
                        background 0.2s ease,
                        box-shadow 0.2s ease;
        }

        .virtual-tryon-btn:hover {
            transform: translateY(-2px);
            background: #f5ece5;
            box-shadow: 0 7px 20px rgba(0, 0, 0, 0.15);
        }

        .virtual-tryon-btn:focus-visible {
            outline: 3px solid #e4cfc0;
            outline-offset: 4px;
        }

        @media (max-width: 650px) {
            .virtual-tryon-wrap {
                margin: 18px auto 24px;
            }

            .virtual-tryon-banner {
                align-items: flex-start;
                flex-direction: column;
                gap: 19px;
                padding: 25px 21px;
                border-radius: 15px;
            }

            .virtual-tryon-btn {
                width: 100%;
            }

            .virtual-tryon-action {
                width: 100%;
            }

            .virtual-tryon-banner::after {
                right: -80px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .virtual-tryon-btn,
            .wishlist-btn {
                transition: none;
            }
        }
    </style>
</head>

<body>

    <!-- TOP BAR -->

    <div class="top-bar">

        <a href="${pageContext.request.contextPath}/home"
           class="icon-btn back-btn"
           aria-label="Home">
            &#8592;
        </a>

        <a href="${pageContext.request.contextPath}/wishlist"
           class="icon-btn wishlist-link"
           aria-label="My Wishlist"
           title="My Wishlist">
            &#9829;
        </a>

        <a href="${pageContext.request.contextPath}/cart"
           class="icon-btn cart-btn"
           aria-label="Cart">
            &#128722;
        </a>

    </div>

    <!-- BACKGROUND -->

    <div class="bg-blur"></div>

    <!-- NEW AI VIRTUAL TRY-ON ENTRY POINT -->

    <section class="virtual-tryon-wrap"
             aria-label="Aura AI Virtual Try-On">

        <div class="virtual-tryon-banner">

            <div class="virtual-tryon-content">

                <p class="virtual-tryon-eyebrow">
                    Introducing Aura AI
                </p>

                <h1 class="virtual-tryon-title">
                    Love the outfit? See it on you
                </h1>

                <p class="virtual-tryon-description">
                    Your favourite Aura pieces, now with a virtual try-on.
                    Upload your photo, choose a garment, and let AI create
                    a preview of your new look
                </p>

                <div class="virtual-tryon-tags">
                    <span class="virtual-tryon-tag">
                        &#10024; AI-powered preview
                    </span>

                    <span class="virtual-tryon-tag">
                        &#9825; Choose your outfit
                    </span>

                    <span class="virtual-tryon-tag">
                        &#10003; Shop with confidence
                    </span>
                </div>

            </div>

            <div class="virtual-tryon-action">

                <a class="virtual-tryon-btn"
                   href="${pageContext.request.contextPath}/virtual-try-on">

                    <span aria-hidden="true">&#10024;</span>
                    Try It On With AI
                    <span aria-hidden="true">&#8594;</span>

                </a>

            </div>

        </div>

    </section>

    <!-- PRODUCTS -->

    <div class="products-container">

        <%
            List<Product> products =
                    (List<Product>) request.getAttribute("products");

            Set<Integer> wishlistProductIds =
                    (Set<Integer>) request.getAttribute("wishlistProductIds");

            Map<Integer, List<ProductVariant>> productVariantsMap =
                    (Map<Integer, List<ProductVariant>>)
                            request.getAttribute("productVariantsMap");

            if (products == null) {
                products = new ArrayList<>();
            }

            if (wishlistProductIds == null) {
                wishlistProductIds = new HashSet<>();
            }

            int index = 0;

            for (Product p : products) {

                boolean isWishlisted =
                        wishlistProductIds.contains(p.getProductId());
        %>

            <div class="product-card"
                 onclick="openModal(<%= index %>)">

                <!-- WISHLIST HEART -->

                <form class="wishlist-form"
                      method="post"
                      action="${pageContext.request.contextPath}/wishlist"
                      onclick="event.stopPropagation();">

                    <input type="hidden"
                           name="productId"
                           value="<%= p.getProductId() %>">

                    <input type="hidden"
                           name="action"
                           value="<%= isWishlisted ? "remove" : "add" %>">

                    <input type="hidden"
                           name="returnTo"
                           value="products">

                    <button type="submit"
                            class="wishlist-btn <%= isWishlisted ? "wishlisted" : "" %>"
                            title="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                            aria-label="<%= isWishlisted ? "Remove from Wishlist" : "Add to Wishlist" %>"
                            onclick="event.stopPropagation();">

                        <%= isWishlisted ? "&#9829;" : "&#9825;" %>

                    </button>

                </form>

                <!-- PRODUCT IMAGE -->

                <img
                    src="${pageContext.request.contextPath}/assets/images/products/<%= escapeHtml(p.getImageUrl()) %>"
                    alt="<%= escapeHtml(p.getName()) %>"
                    loading="lazy">

                <h3><%= escapeHtml(p.getName()) %></h3>

                <p>&#8377;<%= p.getPrice() %></p>

            </div>

        <%
                index++;
            }
        %>

    </div>

    <!-- PRODUCT MODAL -->

    <div id="productModal" class="modal">

        <span class="close"
              onclick="closeModal()"
              role="button"
              aria-label="Close product details">
            &times;
        </span>

        <div class="modal-content">

            <div class="modal-image">
                <img id="modalImg" alt="Selected product">
            </div>

            <div class="modal-info">

                <h2 id="modalName"></h2>

                <p id="modalPrice"></p>

                <!-- SIZES -->

                <div id="modalSizes"></div>

                <!-- ADD TO CART -->

                <form method="post"
                      action="${pageContext.request.contextPath}/add-to-cart"
                      onsubmit="return validateSizeSelection()">

                    <input type="hidden"
                           name="productId"
                           id="productIdField">

                    <input type="hidden"
                           name="variantId"
                           id="variantIdField">

                    <button type="submit" class="add-to-cart-btn">
                        Add to Cart
                    </button>

                </form>

            </div>

        </div>

        <button type="button"
                class="prev"
                onclick="prevProduct()"
                aria-label="Previous product">
            &#10094;
        </button>

        <button type="button"
                class="next"
                onclick="nextProduct()"
                aria-label="Next product">
            &#10095;
        </button>

    </div>

    <!-- JAVASCRIPT -->

    <script>

        <%
            /*
             * Escape product text for JavaScript string literals.
             */
            java.util.function.Function<String, String> jsEscape = value ->
                    value == null ? "" :
                    value.replace("\\", "\\\\")
                         .replace("\"", "\\\"")
                         .replace("\r", "")
                         .replace("\n", "");
        %>

        let products = [

        <%
            for (Product p : products) {

                List<ProductVariant> variants =
                        productVariantsMap == null
                        ? null
                        : productVariantsMap.get(p.getProductId());

                String safeName = jsEscape.apply(p.getName());
                String safeImage = jsEscape.apply(p.getImageUrl());
        %>

            {
                id: "<%= p.getProductId() %>",
                name: "<%= safeName %>",
                price: "<%= p.getPrice() %>",
                image: "${pageContext.request.contextPath}/assets/images/products/<%= safeImage %>",

                variants: [

                <%
                    if (variants != null) {
                        for (ProductVariant v : variants) {

                            String safeSize = jsEscape.apply(v.getSize());
                %>

                    {
                        id: "<%= v.getVariantId() %>",
                        size: "<%= safeSize %>"
                    },

                <%
                        }
                    }
                %>

                ]
            },

        <%
            }
        %>

        ];

        let currentIndex = 0;

        // OPEN PRODUCT MODAL

        function openModal(index) {

            if (products.length === 0) {
                return;
            }

            currentIndex = index;

            showProduct();

            document.getElementById("productModal").style.display = "flex";
        }

        // CLOSE PRODUCT MODAL

        function closeModal() {
            document.getElementById("productModal").style.display = "none";
        }

        // SHOW SELECTED PRODUCT

        function showProduct() {

            let p = products[currentIndex];

            document.getElementById("modalImg").src = p.image;
            document.getElementById("modalName").innerText = p.name;
            document.getElementById("modalPrice").innerText = "₹" + p.price;

            document.getElementById("productIdField").value = p.id;

            // Reset the previous size selection.
            document.getElementById("variantIdField").value = "";

            let sizesHTML = "";

            p.variants.forEach(function(v) {

                sizesHTML +=
                    "<button type='button' " +
                    "class='size-btn' " +
                    "data-variant-id='" + v.id + "'>" +
                    v.size +
                    "</button>";

            });

            document.getElementById("modalSizes").innerHTML = sizesHTML;
        }

        // NEXT PRODUCT

        function nextProduct() {

            if (products.length === 0) {
                return;
            }

            currentIndex = (currentIndex + 1) % products.length;

            showProduct();
        }

        // PREVIOUS PRODUCT

        function prevProduct() {

            if (products.length === 0) {
                return;
            }

            currentIndex =
                (currentIndex - 1 + products.length) % products.length;

            showProduct();
        }

        // SIZE SELECTION

        document.addEventListener("click", function(e) {

            if (e.target.classList.contains("size-btn")) {

                document.querySelectorAll(".size-btn")
                    .forEach(function(btn) {
                        btn.classList.remove("active");
                    });

                e.target.classList.add("active");

                document.getElementById("variantIdField").value =
                    e.target.getAttribute("data-variant-id");
            }

        });

        // VALIDATE SIZE BEFORE ADDING TO CART

        function validateSizeSelection() {

            let variantId =
                document.getElementById("variantIdField").value;

            if (!variantId || variantId.trim() === "") {

                alert("Please select a size before adding to cart");

                return false;
            }

            return true;
        }

    </script>

</body>
</html>
