<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <title>Aura - Address</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style5.css">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Poppins:wght@300;400;500&display=swap"
          rel="stylesheet">

</head>


<body style="
    background: url('${pageContext.request.contextPath}/assets/images/delivery.jpg')
    no-repeat center center fixed;
    background-size: cover;
">


<!-- =========================================================
     BLUR OVERLAY
     ========================================================= -->

<div class="blur-overlay"></div>


<!-- =========================================================
     TOP BAR
     ========================================================= -->

<div class="address-topbar">

    <a href="${pageContext.request.contextPath}/cart"
       class="back-btn">
        &#8592;
    </a>

    <h2>Delivery Address</h2>

</div>


<!-- =========================================================
     MAIN CONTAINER
     ========================================================= -->

<div class="address-container">


    <!-- =====================================================
         LEFT SIDE - ADDRESS FORM
         ===================================================== -->

    <div class="address-form">

        <h3>Add New Address</h3>


        <!-- ✅ FORM NOW SUBMITS TO /address -->

        <form action="${pageContext.request.contextPath}/address"
              method="post">


            <!-- FULL NAME -->

            <input type="text"
                   name="name"
                   placeholder="Full Name"
                   required>


            <!-- PHONE -->

            <input type="tel"
                   name="phone"
                   placeholder="Phone Number"
                   required>


            <!-- PINCODE -->

            <input type="text"
                   name="pincode"
                   placeholder="Pincode"
                   required>


            <!-- CITY + STATE -->

            <div class="row">

                <input type="text"
                       name="city"
                       placeholder="City"
                       required>

                <input type="text"
                       name="state"
                       placeholder="State"
                       required>

            </div>


            <!-- FULL ADDRESS -->

            <textarea name="address"
                      placeholder="Full Address"
                      required></textarea>


            <!-- DEFAULT ADDRESS -->

            <label class="checkbox">

                <input type="checkbox"
                       name="defaultAddress">

                <span>
                    Make this default address
                </span>

            </label>


            <!-- ✅ SAVE & CONTINUE -->

            <button type="submit"
                    class="save-btn">

                Save & Continue

            </button>

        </form>

    </div>


    <!-- =====================================================
         RIGHT SIDE - ORDER SUMMARY
         ===================================================== -->

    <div class="address-summary">

        <h3>Order Summary</h3>


        <!-- SUBTOTAL -->

        <div class="summary-row">

            <span>Subtotal</span>

            <span>
                ₹<%= request.getAttribute("total") %>
            </span>

        </div>


        <!-- DELIVERY -->

        <div class="summary-row">

            <span>Delivery</span>

            <span>FREE</span>

        </div>


        <hr>


        <!-- TOTAL -->

        <div class="summary-row total">

            <span>Total</span>

            <span>
                ₹<%= request.getAttribute("total") %>
            </span>

        </div>


        <!-- =================================================
             NOTE

             The actual form submission happens using
             "Save & Continue" on the left.
             ================================================= -->

        <p style="
            margin-top: 20px;
            color: #777;
            font-size: 14px;
        ">

            Enter your delivery address to continue to payment.

        </p>

    </div>


</div>


</body>

</html>