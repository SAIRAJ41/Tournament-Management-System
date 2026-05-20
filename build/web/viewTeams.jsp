<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Teams - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <%
        String role = (String) session.getAttribute("role");
        String _username = (String) session.getAttribute("username");
        if (_username == null) {
            response.sendRedirect("login.jsp?error=Please login to view teams");
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
            <a href="<%= isAdmin ? "TournamentServlet?action=view" : "TournamentServlet?action=viewActive" %>" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> Tournaments
            </a>
            <% if (isAdmin) { %>
            <a href="addTournament.jsp" class="nav-link">
                <span class="material-symbols-outlined">add_circle</span> Add Tournament
            </a>
            <a href="scheduleMatch.jsp" class="nav-link">
                <span class="material-symbols-outlined">event_upcoming</span> Schedule Match
            </a>
            <% } else { %>
            <a href="registerTeam.jsp" class="nav-link">
                <span class="material-symbols-outlined">group_add</span> Register Team
            </a>
            <% } %>
            <a href="#" class="nav-link active">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <a href="<%= isAdmin ? "MatchServlet?action=view" : "MatchServlet?action=viewPublic" %>" class="nav-link">
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
            <span class="topbar-title">Teams</span>
            <div class="topbar-actions">
                <a href="<%= dashLink %>" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <% if (!isAdmin) { %>
                <a href="registerTeam.jsp" class="btn btn-primary btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">add</span> Register Team
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
                    <h2>Teams List</h2>
                    <p>All registered teams across tournaments in the system.</p>
                </div>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <div class="table-card-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;vertical-align:middle;margin-right:6px;">groups</span>Registered Teams</h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Team ID</th>
                            <th>Tournament</th>
                            <th>Team Name</th>
                            <th>Captain</th>
                            <th>Contact</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> teams = (List<Map<String, String>>) request.getAttribute("teams");
                        if (teams != null && !teams.isEmpty()) {
                            for (Map<String, String> t : teams) {
                    %>
                        <tr>
                            <td><%= t.get("team_id") %></td>
                            <td class="fw-bold"><%= t.get("tournament_name") %></td>
                            <td>
                                <span style="display:inline-flex;align-items:center;gap:8px;">
                                    <span style="width:30px;height:30px;border-radius:50%;background:var(--primary-container);color:var(--on-primary-container);display:inline-flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;flex-shrink:0;">
                                        <%= t.get("team_name") != null && !t.get("team_name").isEmpty() ? t.get("team_name").substring(0,1).toUpperCase() : "T" %>
                                    </span>
                                    <span style="font-weight:600;"><%= t.get("team_name") %></span>
                                </span>
                            </td>
                            <td class="text-muted"><%= t.get("captain_name") %></td>
                            <td class="text-muted"><%= t.get("contact") %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5" style="text-align:center;color:var(--on-surface-variant);padding:32px;">
                                <span class="material-symbols-outlined" style="font-size:36px;display:block;margin-bottom:8px;">group_off</span>
                                No teams registered yet.
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
