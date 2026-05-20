<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // ADMIN-only page: protect against non-admin access
    String _role = (String) session.getAttribute("role");
    String _adminName = (String) session.getAttribute("username");
    if (_role == null || !_role.equals("ADMIN")) {
        response.sendRedirect("userDashboard.jsp");
        return;
    }
%>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Tournament - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub">Admin Panel</span>
        </div>
        <nav class="sidebar-nav">
            <a href="adminDashboard.jsp" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <a href="#" class="nav-link active">
                <span class="material-symbols-outlined">add_circle</span> Add Tournament
            </a>
            <a href="TournamentServlet?action=view" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <a href="TeamServlet?action=viewAll" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <a href="scheduleMatch.jsp" class="nav-link">
                <span class="material-symbols-outlined">event_upcoming</span> Schedule Match
            </a>
            <a href="MatchServlet?action=view" class="nav-link">
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
            <span class="topbar-title">Add New Tournament</span>
            <div class="topbar-actions">
                <a href="adminDashboard.jsp" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <div class="topbar-user"><%= _adminName != null ? _adminName.substring(0,1).toUpperCase() : "A" %></div>
                <span style="font-size:14px;font-weight:600;color:var(--on-surface-variant);">User: <%= _adminName %></span>
            </div>
        </header>

        <!-- Content Canvas -->
        <div class="content-canvas">
            <div class="page-header">
                <div>
                    <h2>Add New Tournament</h2>
                    <p>Fill in the details below to create a new tournament in the system.</p>
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

                <form action="TournamentServlet" method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label>Tournament Name</label>
                        <input type="text" name="name" placeholder="e.g. Inter-Collegiate Football 2025" required>
                    </div>
                    <div class="form-group">
                        <label>Sport</label>
                        <input type="text" name="sport" placeholder="e.g. Football, Basketball, Cricket" required>
                    </div>
                    <div class="form-group">
                        <label>Start Date</label>
                        <input type="date" name="start_date" required>
                    </div>
                    <div class="form-group">
                        <label>End Date</label>
                        <input type="date" name="end_date" required>
                    </div>
                    <div class="form-group">
                        <label>Venue</label>
                        <input type="text" name="venue" placeholder="e.g. College Sports Complex" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="Upcoming">Upcoming</option>
                            <option value="Ongoing">Ongoing</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">
                        <span class="material-symbols-outlined" style="font-size:18px;">add_circle</span>
                        Add Tournament
                    </button>
                </form>
            </div>
        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->
</body>
</html>
