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
    <title>Update Match Result - Tournament Management System</title>
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
            <a href="TournamentServlet?action=view" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <a href="TeamServlet?action=viewAll" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <a href="scheduleMatch.jsp" class="nav-link">
                <span class="material-symbols-outlined">event_upcoming</span> Schedule Match
            </a>
            <a href="MatchServlet?action=view" class="nav-link active">
                <span class="material-symbols-outlined">edit_calendar</span> Update Result
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
            <span class="topbar-title">Update Match Result</span>
            <div class="topbar-actions">
                <a href="MatchServlet?action=view" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Back to Matches
                </a>
                <div class="topbar-user"><%= _adminName != null ? _adminName.substring(0,1).toUpperCase() : "A" %></div>
                <span style="font-size:14px;font-weight:600;color:var(--on-surface-variant);">User: <%= _adminName %></span>
            </div>
        </header>

        <!-- Content Canvas -->
        <div class="content-canvas">
            <div class="page-header">
                <div>
                    <h2>Update Match Result</h2>
                    <p>Enter the result and winner for this match. This action cannot be undone easily.</p>
                </div>
            </div>

            <!-- Match Info Banner -->
            <% String team1 = request.getParameter("team1");
               String team2 = request.getParameter("team2");
               if (team1 != null && team2 != null) { %>
            <div style="background:var(--surface-container);border:1px solid var(--outline-variant);border-radius:var(--radius-lg);padding:var(--space-lg);margin-bottom:var(--space-xl);display:flex;align-items:center;gap:var(--space-md);">
                <span class="material-symbols-outlined" style="font-size:28px;color:var(--primary);">sports</span>
                <div>
                    <div style="font-weight:700;font-size:16px;color:var(--on-surface);"><%= team1 %> <span style="color:var(--on-surface-variant);font-weight:400;">vs</span> <%= team2 %></div>
                    <div class="text-muted">Match ID: <%= request.getParameter("match_id") %></div>
                </div>
            </div>
            <% } %>

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

                <form action="MatchServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="match_id" value="<%= request.getParameter("match_id") %>">

                    <div class="form-group">
                        <label>Result Summary (e.g. 2-1)</label>
                        <input type="text" name="result" placeholder="e.g. 3-1, 2-0, Draw" required>
                    </div>
                    <div class="form-group">
                        <label>Winner</label>
                        <select name="winner">
                            <option value="Draw">Draw</option>
                            <option value="<%= request.getParameter("team1") %>"><%= request.getParameter("team1") %></option>
                            <option value="<%= request.getParameter("team2") %>"><%= request.getParameter("team2") %></option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">
                        <span class="material-symbols-outlined" style="font-size:18px;">save</span>
                        Update Result
                    </button>
                </form>
            </div>
        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->
</body>
</html>
