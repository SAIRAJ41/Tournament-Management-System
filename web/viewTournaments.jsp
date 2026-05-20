<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Tournaments - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <%
        String role = (String) session.getAttribute("role");
        String _username = (String) session.getAttribute("username");
        if (_username == null) {
            response.sendRedirect("login.jsp?error=Please login to view tournaments");
            return;
        }
        boolean isAdmin = "ADMIN".equals(role);
        String dashLink = isAdmin ? "adminDashboard.jsp" : "userDashboard.jsp";
    %>

    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub"><%= isAdmin ? "Admin Panel" : "College Sports Portal" %></span>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= dashLink %>" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <a href="#" class="nav-link active">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <% if (isAdmin) { %>
            <a href="addTournament.jsp" class="nav-link">
                <span class="material-symbols-outlined">add_circle</span> Add Tournament
            </a>
            <a href="TeamServlet?action=viewAll" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <a href="scheduleMatch.jsp" class="nav-link">
                <span class="material-symbols-outlined">event_upcoming</span> Schedule Match
            </a>
            <% } else { %>
            <a href="registerTeam.jsp" class="nav-link">
                <span class="material-symbols-outlined">group_add</span> Register Team
            </a>
            <a href="TeamServlet?action=viewMyTeams" class="nav-link">
                <span class="material-symbols-outlined">groups</span> My Teams
            </a>
            <% } %>
            <a href="MatchServlet?action=<%= isAdmin ? "view" : "viewPublic" %>" class="nav-link">
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
            <span class="topbar-title">Tournaments</span>
            <div class="topbar-actions">
                <a href="<%= dashLink %>" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <% if (isAdmin) { %>
                <a href="addTournament.jsp" class="btn btn-primary btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">add</span> Add Tournament
                </a>
                <% } %>
                <div class="topbar-user"><%= _username.substring(0,1).toUpperCase() %></div>
                <span style="font-size:14px;font-weight:600;color:var(--on-surface-variant);">User: <%= _username %></span>
            </div>
        </header>

        <!-- Content Canvas -->
        <div class="content-canvas">
            <div class="page-header">
                <div>
                    <h2>Tournament Management</h2>
                    <p>Review and manage all active and upcoming college athletic events.</p>
                </div>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <div class="table-card-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;vertical-align:middle;margin-right:6px;">emoji_events</span>All Tournaments</h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Sport</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Venue</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> tournaments = (List<Map<String, String>>) request.getAttribute("tournaments");
                        if (tournaments != null && !tournaments.isEmpty()) {
                            for (Map<String, String> t : tournaments) {
                                String status = t.get("status");
                                String badgeClass = "badge-grey";
                                if ("Ongoing".equalsIgnoreCase(status))  badgeClass = "badge-green";
                                else if ("Upcoming".equalsIgnoreCase(status)) badgeClass = "badge-blue";
                                else if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-grey";
                    %>
                        <tr>
                            <td><%= t.get("id") %></td>
                            <td class="fw-bold"><%= t.get("name") %></td>
                            <td class="text-muted"><%= t.get("sport") %></td>
                            <td><%= t.get("start_date") %></td>
                            <td><%= t.get("end_date") %></td>
                            <td><%= t.get("venue") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="7" style="text-align:center;color:var(--on-surface-variant);padding:32px;">
                                <span class="material-symbols-outlined" style="font-size:36px;display:block;margin-bottom:8px;">search_off</span>
                                No tournaments found.
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->
</body>
</html>
