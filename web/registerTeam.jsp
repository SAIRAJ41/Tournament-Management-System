<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.tournament.util.DBConnection" %>
<%
    // Ensure user is logged in to register a team
    String _username = (String) session.getAttribute("username");
    if (_username == null) {
        response.sendRedirect("login.jsp?error=Please login to register a team");
        return;
    }
%>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Team - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub">College Sports Portal</span>
        </div>
        <nav class="sidebar-nav">
            <a href="userDashboard.jsp" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <a href="TournamentServlet?action=viewActive" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <a href="#" class="nav-link active">
                <span class="material-symbols-outlined">group_add</span> Register Team
            </a>
            <a href="TeamServlet?action=viewMyTeams" class="nav-link">
                <span class="material-symbols-outlined">groups</span> My Teams
            </a>
            <a href="MatchServlet?action=viewPublic" class="nav-link">
                <span class="material-symbols-outlined">calendar_month</span> View Matches
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="logout" class="nav-link">
                <span class="material-symbols-outlined">logout</span> Logout
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="main-content">

        <!-- Top Bar -->
        <header class="topbar">
            <span class="topbar-title">Register a New Team</span>
            <div class="topbar-actions">
                <a href="userDashboard.jsp" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <div class="topbar-user"><%= _username.substring(0,1).toUpperCase() %></div>
                <span style="font-size:14px;font-weight:600;color:var(--on-surface-variant);">User: <%= _username %></span>
            </div>
        </header>

        <!-- Content Canvas -->
        <div class="content-canvas">
            <div class="page-header">
                <div>
                    <h2>Register a New Team</h2>
                    <p>Join an upcoming tournament by registering your team below.</p>
                </div>
            </div>

            <!-- Form Card -->
            <div class="form-card">

                <%
                    String message = request.getParameter("message");
                    if (message != null) {
                %>
                <div class="alert alert-success">
                    <span class="material-symbols-outlined" style="font-size:18px;">check_circle</span>
                    <%= message %>
                </div>
                <% } %>

                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                <div class="alert alert-error">
                    <span class="material-symbols-outlined" style="font-size:18px;">error</span>
                    <%= error %>
                </div>
                <% } %>

                <form action="TeamServlet" method="post">
                    <input type="hidden" name="action" value="register">

                    <div class="form-group">
                        <label>Select Tournament</label>
                        <select name="tournament_id" required>
                            <%
                                try (Connection conn = DBConnection.getConnection()) {
                                    String sql = "SELECT tournament_id, name FROM tournaments WHERE status = 'Upcoming'";
                                    PreparedStatement stmt = conn.prepareStatement(sql);
                                    ResultSet rs = stmt.executeQuery();
                                    while (rs.next()) {
                            %>
                                <option value="<%= rs.getInt("tournament_id") %>"><%= rs.getString("name") %></option>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Team Name</label>
                        <input type="text" name="team_name" placeholder="Enter your team name" required>
                    </div>
                    <div class="form-group">
                        <label>Captain Name</label>
                        <input type="text" name="captain_name" placeholder="Enter captain's full name" required>
                    </div>
                    <div class="form-group">
                        <label>Contact Info</label>
                        <input type="text" name="contact" placeholder="Phone number or email" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">
                        <span class="material-symbols-outlined" style="font-size:18px;">group_add</span>
                        Register Team
                    </button>
                </form>
            </div>
        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->
</body>
</html>
