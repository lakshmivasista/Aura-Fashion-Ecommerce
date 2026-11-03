<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Aura Login</title>

    <!-- CSS (dynamic path - correct way) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style1.css">

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Poppins:wght@300;400;500&display=swap">
</head>

<body>

<div class="login-container">

    <!-- LEFT SIDE -->
    <div class="login-left">

        <div class="login-card">

            <h2>Login</h2>
            <p class="subtext">Access your account</p>

            <form action="login" method="post">

                <input type="email" name="email" placeholder="Enter your email" required>

                <input type="password" name="password" placeholder="Enter your password" required>

                <div class="login-options">
                    
                <label>
                   <input type="checkbox"> Remember me
                </label> 

                    <a href="forgot-password">Forgot password?</a>

                </div>

                <button type="submit">Login</button>

                <p class="register-link">
                    Not registered? <a href="register">Create an account</a>
                </p>

            </form>

        </div>

    </div>

    <!-- RIGHT SIDE IMAGE -->
    <div class="login-right"></div>

</div>

</body>
</html>