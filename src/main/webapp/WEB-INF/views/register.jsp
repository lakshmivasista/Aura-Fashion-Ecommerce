<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Aura Register</title>

    <link rel="stylesheet" href="/aura/assets/css/style2.css">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;700&family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
</head>

<body>

<div class="register-container">

    <div class="register-card">

        <h2>Create Account</h2>
        <p class="subtext">Join Aura today</p>

        <form action="register" method="post">

            <input type="text" name="name" placeholder="Full Name" required>

            <input type="email" name="email" placeholder="Email Address" required>

            <input type="password" name="password" placeholder="Password" required>

            <button type="submit">Sign Up</button>

            <p class="login-link">
                Already have an account? <a href="login">Login</a>
            </p>

        </form>

    </div>

</div>

</body>
</html>