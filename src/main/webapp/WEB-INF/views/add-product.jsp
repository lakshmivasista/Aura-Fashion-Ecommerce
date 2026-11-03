<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Aura - Add Product</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f8f5f2;
        }

        .header {
            background: white;
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
            max-width: 700px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-card {
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="number"],
        input[type="file"] {
            width: 100%;
            box-sizing: border-box;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .sizes {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .sizes label {
            font-weight: normal;
        }

        .submit-btn {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 6px;
            background: #222;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background: #4a2c2a;
        }

    </style>

</head>

<body>

<div class="header">

    <h1>Aura - Add Product</h1>

    <a class="back-btn"
       href="${pageContext.request.contextPath}/admin/products">

        Back to Products

    </a>

</div>


<div class="container">

    <div class="form-card">

        <h2>Add New Product</h2>

        <form method="post"
              action="${pageContext.request.contextPath}/admin/products/add"
              enctype="multipart/form-data">

            <div class="form-group">

                <label for="name">
                    Product Name
                </label>

                <input type="text"
                       id="name"
                       name="name"
                       placeholder="Enter product name"
                       required>

            </div>


            <div class="form-group">

                <label for="price">
                    Price
                </label>

                <input type="number"
                       id="price"
                       name="price"
                       step="0.01"
                       min="0"
                       placeholder="Enter price"
                       required>

            </div>


            <div class="form-group">

                <label for="image">
                    Product Image
                </label>

                <input type="file"
                       id="image"
                       name="image"
                       accept="image/*"
                       required>

            </div>


            <div class="form-group">

                <label>
                    Available Sizes
                </label>

                <div class="sizes">

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="XS">
                        XS
                    </label>

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="S">
                        S
                    </label>

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="M">
                        M
                    </label>

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="L">
                        L
                    </label>

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="XL">
                        XL
                    </label>

                    <label>
                        <input type="checkbox"
                               name="sizes"
                               value="XXL">
                        XXL
                    </label>

                </div>

            </div>


            <button type="submit"
                    class="submit-btn">

                Add Product

            </button>

        </form>

    </div>

</div>

</body>

</html>