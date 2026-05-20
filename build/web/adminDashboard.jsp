<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.tournament.util.DBConnection, java.util.*" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("login.jsp?error=Please login as Admin");
        return;
    }
    String adminName = (String) session.getAttribute("username");

    // Fetch recent matches for the dashboard table
    List<Map<String,String>> recentMatches = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT m.match_id, t.name as tournament_name, m.team1, m.team2, " +
                     "m.match_date, m.match_time, m.result, m.winner " +
                     "FROM matches m JOIN tournaments t ON m.tournament_id = t.tournament_id " +
                     "ORDER BY m.match_id DESC LIMIT 5";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> row = new HashMap<>();
            row.put("tournament_name", rs.getString("tournament_name"));
            row.put("team1",  rs.getString("team1"));
            row.put("team2",  rs.getString("team2"));
            row.put("match_date", rs.getString("match_date"));
            row.put("match_time", rs.getString("match_time"));
            row.put("result", rs.getString("result"));
            row.put("winner", rs.getString("winner"));
            row.put("match_id", String.valueOf(rs.getInt("match_id")));
            recentMatches.add(row);
        }
    } catch (Exception e) { /* silent — table may be empty */ }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Tournament Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <!-- ── Sidebar ── -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub">Admin Panel</span>
        </div>
        <nav class="sidebar-nav">
            <a href="adminDashboard.jsp" class="nav-link active">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <a href="addTournament.jsp" class="nav-link">
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
            <a href="MatchServlet?action=view" class="nav-link">
                <span class="material-symbols-outlined">edit_calendar</span> Update Result
            </a>
            <a href="pointsTable.jsp" class="nav-link">
                <span class="material-symbols-outlined">leaderboard</span> Points Table
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="logout" class="nav-link">
                <span class="material-symbols-outlined">logout</span> Logout
            </a>
        </div>
    </aside>

    <!-- ── Main Content ── -->
    <div class="main-content">

        <!-- Top Bar -->
        <header class="topbar">
            <span class="topbar-title">Dashboard</span>
            <div class="topbar-actions">
                <div class="topbar-user"><%= adminName != null ? adminName.substring(0,1).toUpperCase() : "A" %></div>
                <span class="topbar-username">User: <%= adminName %></span>
            </div>
        </header>

        <!-- Content -->
        <div class="content-canvas">

            <!-- Welcome Banner -->
            <div class="hero-banner">
                <span class="material-symbols-outlined hero-icon">admin_panel_settings</span>
                <h2>Welcome back, <%= adminName %>!</h2>
                <p>Manage tournaments, teams, and match schedules from your central administration panel.</p>
            </div>

            <!-- Feature Cards Grid (2 col) -->
            <div class="feature-grid">

                <!-- Add Tournament -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-blue">
                            <span class="material-symbols-outlined">emoji_events</span>
                        </div>
                        <div>
                            <h3>Tournaments</h3>
                            <p>Create and manage college tournaments. Set dates, venue, sport type and status.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="addTournament.jsp" class="btn btn-primary btn-sm">
                            <span class="material-symbols-outlined" style="font-size:14px;">add</span> Add Tournament
                        </a>
                        <a href="TournamentServlet?action=view" class="browse-link">
                            Browse All <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- View Results -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-purple">
                            <span class="material-symbols-outlined">leaderboard</span>
                        </div>
                        <div>
                            <h3>Results &amp; Standings</h3>
                            <p>Check match results, update scores and review match history for all tournaments.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="MatchServlet?action=view" class="browse-link">
                            Check Records <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- Register/View Teams -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-green">
                            <span class="material-symbols-outlined">groups</span>
                        </div>
                        <div>
                            <h3>Teams</h3>
                            <p>View all registered teams across every active tournament in the system.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="TeamServlet?action=viewAll" class="browse-link">
                            View All Teams <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- Schedule Match -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-orange">
                            <span class="material-symbols-outlined">calendar_month</span>
                        </div>
                        <div>
                            <h3>View Matches</h3>
                            <p>Don't miss a single second. View live schedules and track progression of all matches.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="scheduleMatch.jsp" class="btn btn-primary btn-sm">
                            <span class="material-symbols-outlined" style="font-size:14px;">add</span> Schedule
                        </a>
                        <a href="MatchServlet?action=view" class="browse-link">
                            View All <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Upcoming / Recent Matches Table -->
            <div class="section-header">
                <h3>Recent Matches</h3>
                <a href="MatchServlet?action=view" class="view-all-link">View All</a>
            </div>

            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Tournament</th>
                            <th>Match-up</th>
                            <th>Date &amp; Time</th>
                            <th>Result</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (recentMatches.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="5" style="text-align:center;padding:32px;color:var(--on-surface-variant);">
                                <span class="material-symbols-outlined" style="font-size:32px;display:block;margin-bottom:8px;">event_busy</span>
                                No matches scheduled yet. <a href="scheduleMatch.jsp" style="color:var(--primary);font-weight:600;">Schedule one →</a>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String,String> m : recentMatches) {
                                String res = m.get("result");
                                boolean pending = (res == null || res.isEmpty() || res.equals("Pending") || res.equals("null"));
                    %>
                        <tr>
                            <td class="fw-bold"><%= m.get("tournament_name") %></td>
                            <td>
                                <span style="font-weight:600;"><%= m.get("team1") %></span>
                                <span class="text-muted" style="margin:0 6px;">vs</span>
                                <span style="font-weight:600;"><%= m.get("team2") %></span>
                            </td>
                            <td class="text-muted"><%= m.get("match_date") %> <%= m.get("match_time") != null ? m.get("match_time") : "" %></td>
                            <td>
                                <% if (pending) { %>
                                    <span class="badge badge-orange">Pending</span>
                                <% } else { %>
                                    <span class="badge badge-green"><%= res %></span>
                                <% } %>
                            </td>
                            <td>
                                <a href="updateResult.jsp?match_id=<%= m.get("match_id") %>&team1=<%= m.get("team1") %>&team2=<%= m.get("team2") %>"
                                   class="btn btn-outline btn-sm">
                                    <span class="material-symbols-outlined" style="font-size:13px;">edit</span> Update
                                </a>
                            </td>
                        </tr>
                    <%
                            }
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
