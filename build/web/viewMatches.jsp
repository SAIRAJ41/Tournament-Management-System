<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<!-- JSP handles the UI presentation -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Matches - Tournament Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <%
        String role = (String) session.getAttribute("role");
        String _username = (String) session.getAttribute("username");
        if (_username == null) {
            response.sendRedirect("login.jsp?error=Please login to view matches");
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
            <a href="TeamServlet?action=viewAll" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <% } else { %>
            <a href="registerTeam.jsp" class="nav-link">
                <span class="material-symbols-outlined">group_add</span> Register Team
            </a>
            <a href="TeamServlet?action=viewMyTeams" class="nav-link">
                <span class="material-symbols-outlined">groups</span> My Teams
            </a>
            <% } %>
            <a href="#" class="nav-link active">
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
            <span class="topbar-title">Match Schedule &amp; Results</span>
            <div class="topbar-actions">
                <a href="<%= dashLink %>" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <% if (isAdmin) { %>
                <a href="scheduleMatch.jsp" class="btn btn-primary btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">add</span> Schedule Match
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
                    <h2>Match Schedule &amp; Results</h2>
                    <p>View all scheduled matches, live scores, and final results.</p>
                </div>
            </div>

            <!-- Table Card -->
            <div class="table-card">
                <div class="table-card-header">
                    <h3><span class="material-symbols-outlined" style="font-size:18px;vertical-align:middle;margin-right:6px;">calendar_month</span>All Matches</h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Match ID</th>
                            <th>Tournament</th>
                            <th>Match-up</th>
                            <th>Date &amp; Time</th>
                            <th>Venue</th>
                            <th>Result</th>
                            <th>Winner</th>
                            <% if (isAdmin) { %><th>Action</th><% } %>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> matches = (List<Map<String, String>>) request.getAttribute("matches");
                        if (matches != null && !matches.isEmpty()) {
                            for (Map<String, String> m : matches) {
                    %>
                        <tr>
                            <td><%= m.get("match_id") %></td>
                            <td class="fw-bold"><%= m.get("tournament_name") %></td>
                            <td>
                                <span style="font-weight:600;"><%= m.get("team1") %></span>
                                <span class="text-muted" style="margin:0 6px;">vs</span>
                                <span style="font-weight:600;"><%= m.get("team2") %></span>
                            </td>
                            <td><%= m.get("match_date") %> <span class="text-muted"><%= m.get("match_time") %></span></td>
                            <td class="text-muted"><%= m.get("venue") %></td>
                            <td>
                                <% String result = m.get("result");
                                   if (result != null && !result.isEmpty() && !result.equals("null")) { %>
                                    <span class="badge badge-green"><%= result %></span>
                                <% } else { %>
                                    <span class="badge badge-orange">Pending</span>
                                <% } %>
                            </td>
                            <td>
                                <% String winner = m.get("winner");
                                   if (winner != null && !winner.isEmpty() && !winner.equals("null")) { %>
                                    <span style="font-weight:600;color:var(--primary);"><%= winner %></span>
                                <% } else { %>
                                    <span class="text-muted">—</span>
                                <% } %>
                            </td>
                            <% if (isAdmin) { %>
                            <td>
                                <a href="updateResult.jsp?match_id=<%= m.get("match_id") %>&team1=<%= m.get("team1") %>&team2=<%= m.get("team2") %>"
                                   class="btn btn-primary btn-sm">
                                    <span class="material-symbols-outlined" style="font-size:14px;">edit</span> Update
                                </a>
                            </td>
                            <% } %>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="8" style="text-align:center;color:var(--on-surface-variant);padding:32px;">
                                <span class="material-symbols-outlined" style="font-size:36px;display:block;margin-bottom:8px;">event_busy</span>
                                No matches scheduled yet.
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
