<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <title>Aura Payment</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style6.css">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap"
          rel="stylesheet">

</head>


<body style="
    background: url('${pageContext.request.contextPath}/assets/images/payment.jpg')
    no-repeat center center fixed;
    background-size: cover;
">


<!-- =========================================================
     BLUR OVERLAY
     ========================================================= -->

<div class="blur-overlay"></div>


<!-- =========================================================
     PAYMENT CONTAINER
     ========================================================= -->

<div class="payment-container">


    <!-- =====================================================
         LEFT SIDE
         ===================================================== -->

    <div class="payment-left">

        <h3>Choose Payment Method</h3>


        <!-- =================================================
             PAYMENT OPTIONS
             ================================================= -->

        <div class="payment-option active"
             data-method="Cash on Delivery">

            Cash on Delivery

        </div>


        <div class="payment-option"
             data-method="Credit / Debit Card">

            Credit / Debit Card

        </div>


        <div class="payment-option"
             data-method="UPI / PhonePe">

            UPI / PhonePe

        </div>


        <div class="payment-option"
             data-method="Net Banking">

            Net Banking

        </div>


        <div class="payment-option"
             data-method="Wallets">

            Wallets

        </div>


        <!-- =================================================
             PAY FORM
             ================================================= -->

        <form action="${pageContext.request.contextPath}/checkout"
              method="post"
              onsubmit="return validatePaymentMethod()">


            <!-- Selected payment method -->

            <input type="hidden"
                   name="paymentMethod"
                   id="paymentMethod"
                   value="Cash on Delivery">


            <!-- PAY BUTTON -->

            <button type="submit"
                    class="pay-btn">

                PAY

            </button>

        </form>

    </div>


    <!-- =====================================================
         RIGHT SIDE
         ===================================================== -->

    <div class="payment-right">

        <h3>Order Summary</h3>


        <!-- TOTAL -->

        <div class="row">

            <span>Total</span>

            <span>
                ₹<%= request.getAttribute("total") %>
            </span>

        </div>

    </div>


</div>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


/* =========================================================
   PAYMENT METHOD SELECTION
   ========================================================= */

document.querySelectorAll(".payment-option")
    .forEach(function(option) {

        option.addEventListener("click", function() {


            // Remove active from every option

            document.querySelectorAll(".payment-option")
                .forEach(function(item) {

                    item.classList.remove("active");

                });


            // Make clicked option active

            option.classList.add("active");


            // Get payment method

            let method =
                option.getAttribute("data-method");


            // Store selected method

            document.getElementById("paymentMethod").value =
                method;

        });

    });


/* =========================================================
   VALIDATE PAYMENT METHOD
   ========================================================= */

function validatePaymentMethod() {

    let method =
        document.getElementById("paymentMethod").value;


    if (!method || method.trim() === "") {

        alert("Please select a payment method.");

        return false;
    }


    return true;
}

</script>


</body>

</html>