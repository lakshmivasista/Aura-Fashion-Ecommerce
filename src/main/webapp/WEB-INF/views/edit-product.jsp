<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aura.model.Product" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Aura - Edit Product</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f8f5f2;
        }

        .header {
            background: #ffffff;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .header h1 {
            margin: 0;
        }

        .back-btn {
            text-decoration: none;
            background: rgb(74, 44, 42);
            color: white;
            padding: 10px 18px;
            border-radius: 6px;
        }

        .container {
            max-width: 650px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        .form-card h2 {
            margin-top: 0;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-group input[type="text"],
        .form-group input[type="number"] {
            width: 100%;
            padding: 12px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        .sizes {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .size-option {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .current-image {
            margin-bottom: 20px;
        }

        .current-image img {
            width: 180px;
            height: 220px;
            object-fit: cover;
            border-radius: 8px;
            display: block;
            margin-top: 10px;
        }

        .submit-btn {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 6px;
            background: #222;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .submit-btn:hover {
            background: #444;
        }

    </style>

</head>

<body>

<%
    Product product = (Product) request.getAttribute("product");
%>


<div class="header">

    <h1>Aura - Edit Product</h1>

    <a class="back-btn"
       href="${pageContext.request.contextPath}/admin/products">

        Back to Products

    </a>

</div>


<div class="container">

    <div class="form-card">

        <h2>Edit Product</h2>


        <form method="post"
              action="${pageContext.request.contextPath}/admin/products/edit">


            <!-- Product ID -->

            <input type="hidden"
                   name="productId"
                   value="<%=product.getProductId()%>">


            <!-- Product Name -->

            <div class="form-group">

                <label>Product Name</label>

                <input type="text"
                       name="name"
                       value="<%=product.getName()%>"
                       required>

            </div>


            <!-- Price -->

            <div class="form-group">

                <label>Price</label>

                <input type="number"
                       name="price"
                       step="0.01"
                       min="0"
                       value="<%=product.getPrice()%>"
                       required>

            </div>


            <!-- Current Image -->

            <div class="current-image">

                <label><strong>Current Image</strong></label>

                <img src="${pageContext.request.contextPath}/assets/images/products/<%=product.getImageUrl()%>"
                     alt="<%=product.getName()%>">

            </div>


            <!-- Sizes -->

            <div class="form-group">

                <label>Available Sizes</label>

                <div class="sizes">

                    <%
                        String existingSizes = product.getSizes();

                        boolean xs = existingSizes != null && existingSizes.contains("XS");
                        boolean s  = existingSizes != null && existingSizes.contains("S");
                        boolean m  = existingSizes != null && existingSizes.contains("M");
                        boolean l  = existingSizes != null && existingSizes.contains("L");
                        boolean xl = existingSizes != null && existingSizes.contains("XL");
                        boolean xxl = existingSizes != null && existingSizes.contains("XXL");
                    %>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="XS"
                               <%=xs ? "checked" : ""%>>

                        XS

                    </label>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="S"
                               <%=s ? "checked" : ""%>>

                        S

                    </label>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="M"
                               <%=m ? "checked" : ""%>>

                        M

                    </label>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="L"
                               <%=l ? "checked" : ""%>>

                        L

                    </label>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="XL"
                               <%=xl ? "checked" : ""%>>

                        XL

                    </label>


                    <label class="size-option">

                        <input type="checkbox"
                               name="sizes"
                               value="XXL"
                               <%=xxl ? "checked" : ""%>>

                        XXL

                    </label>

                </div>

            </div>


            <!-- Submit -->

            <button type="submit"
                    class="submit-btn">

                Update Product

            </button>


        </form>

    </div>

</div>


</body>

</html>