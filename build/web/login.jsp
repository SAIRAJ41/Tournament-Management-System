<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box">

        <!-- Brand Logo -->
        <div class="login-logo">
            <div class="login-logo-icon">
                <span class="material-symbols-outlined">emoji_events</span>
            </div>
            <h1>Tournament Portal</h1>
            <p>College Sports Management System</p>
        </div>

        <!-- Login Card -->
        <div class="login-card">

            <%
                // --- Alert Logic ---
                // Show red error alert only when "error" param is present
                String error = request.getParameter("error");

                // Show green alert for logout: only when logout=true
                String logout = request.getParameter("logout");

                // Show green alert for successful registration: only when registered=true
                String registered = request.getParameter("registered");
            %>

            <% if (error != null) { %>
            <div class="alert alert-error">
                <span class="material-symbols-outlined" style="font-size:18px;">error</span>
                <%= error %>
            </div>
            <% } %>

            <% if ("true".equals(logout)) { %>
            <div class="alert alert-success">
                <span class="material-symbols-outlined" style="font-size:18px;">check_circle</span>
                Logged out successfully.
            </div>
            <% } %>

            <% if ("true".equals(registered)) { %>
            <div class="alert alert-success">
                <span class="material-symbols-outlined" style="font-size:18px;">how_to_reg</span>
                Registration successful. Please login.
            </div>
            <% } %>

            <!-- Form submits to Servlet which handles backend request processing -->
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="btn btn-login" style="width:100%;justify-content:center;padding:12px;font-size:15px;background:#3f51b5;color:#fff;border-radius:8px;margin-top:4px;">
                    <span class="material-symbols-outlined" style="font-size:18px;">login</span>
                    Sign In
                </button>
            </form>

            <div class="login-divider"></div>

            <!-- Register link -->
            <p style="text-align:center;margin:0;font-size:14px;color:var(--on-surface-variant);">
                New user?
                <a href="register.jsp" style="color:#3f51b5;font-weight:600;text-decoration:none;">Register here</a>
            </p>

            <p class="login-footer" style="margin-top:12px;">Official Tournament Management System</p>
        </div>
    </div>
</div>
</body>
</html>
