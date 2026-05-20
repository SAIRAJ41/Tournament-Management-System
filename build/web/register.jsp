<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box">

        <!-- Brand Logo -->
        <div class="login-logo">
            <div class="login-logo-icon">
                <span class="material-symbols-outlined">how_to_reg</span>
            </div>
            <h1>Create Account</h1>
            <p>Join the College Sports Management System</p>
        </div>

        <!-- Register Card -->
        <div class="login-card">

            <%
                // Show error if registration failed
                String error = request.getParameter("error");
            %>

            <% if (error != null) { %>
            <div class="alert alert-error">
                <span class="material-symbols-outlined" style="font-size:18px;">error</span>
                <%= error %>
            </div>
            <% } %>

            <!-- Form submits to RegisterServlet which handles backend request processing -->
            <!-- In real applications, passwords should be stored using hashing. -->
            <form action="RegisterServlet" method="post">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username"
                           placeholder="Choose a username" required
                           autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Create a password" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Re-enter your password" required>
                </div>

                <button type="submit"
                        class="btn btn-login"
                        style="width:100%;justify-content:center;padding:12px;font-size:15px;background:#3f51b5;color:#fff;border-radius:8px;margin-top:4px;">
                    <span class="material-symbols-outlined" style="font-size:18px;">person_add</span>
                    Register
                </button>
            </form>

            <div class="login-divider"></div>

            <!-- Back to login link -->
            <p style="text-align:center;margin:0;font-size:14px;color:var(--on-surface-variant);">
                Already have an account?
                <a href="login.jsp" style="color:#3f51b5;font-weight:600;text-decoration:none;">Sign In</a>
            </p>

            <p class="login-footer" style="margin-top:12px;">Official Tournament Management System</p>
        </div>
    </div>
</div>
</body>
</html>
