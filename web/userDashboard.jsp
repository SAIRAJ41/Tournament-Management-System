<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.tournament.util.DBConnection, java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    if (username == null || userRole == null) {
        response.sendRedirect("login.jsp?error=Please login to access dashboard");
        return;
    }
    if ("ADMIN".equals(userRole)) {
        response.sendRedirect("adminDashboard.jsp");
        return;
    }

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
    <title>Dashboard - Tournament Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <!-- ── Sidebar ── -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub">College Sports Portal</span>
        </div>
        <nav class="sidebar-nav">
            <a href="userDashboard.jsp" class="nav-link active">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <a href="TournamentServlet?action=viewActive" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <a href="registerTeam.jsp" class="nav-link">
                <span class="material-symbols-outlined">group_add</span> Register Team
            </a>
            <a href="TeamServlet?action=viewMyTeams" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View My Teams
            </a>
            <a href="MatchServlet?action=viewPublic" class="nav-link">
                <span class="material-symbols-outlined">calendar_month</span> View Matches
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
                <div class="topbar-user"><%= username.substring(0,1).toUpperCase() %></div>
                <span class="topbar-username">User: <%= username %></span>
            </div>
        </header>

        <!-- Content -->
        <div class="content-canvas">

            <!-- Welcome Banner -->
            <div class="hero-banner">
                <span class="material-symbols-outlined hero-icon">sports_basketball</span>
                <h2>Welcome back, <%= username %>!</h2>
                <p>Manage your campus sports journey. From registering teams to tracking real-time match results, everything you need is right here at your fingertips.</p>
            </div>

            <!-- Feature Cards Grid (2 col) -->
            <div class="feature-grid">

                <!-- View Tournaments -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-blue">
                            <span class="material-symbols-outlined">emoji_events</span>
                        </div>
                        <div>
                            <h3>View Tournaments</h3>
                            <p>Explore upcoming varsity games, local college leagues, and intramural competitions scheduled for this semester.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="TournamentServlet?action=viewActive" class="browse-link">
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
                            <h3>View Results</h3>
                            <p>Check standings and match history. See who won and track team progress across the season.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="MatchServlet?action=viewPublic" class="browse-link">
                            Check Records <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- Register Team -->
                <div class="feature-card">
                    <div class="feature-card-header">
                        <div class="feature-icon-wrap fi-green">
                            <span class="material-symbols-outlined">group_add</span>
                        </div>
                        <div>
                            <h3>Register Team</h3>
                            <p>Form your squad and enter the arena. Early bird registration is open for the Spring Fest.</p>
                        </div>
                    </div>
                    <div class="feature-card-footer">
                        <a href="registerTeam.jsp" class="btn btn-primary btn-sm">
                            <span class="material-symbols-outlined" style="font-size:14px;">add</span> Register Now
                        </a>
                        <a href="TeamServlet?action=viewMyTeams" class="browse-link">
                            My Teams <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- View Matches -->
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
                        <a href="MatchServlet?action=viewPublic" class="browse-link">
                            View Schedule <span class="material-symbols-outlined">arrow_forward</span>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Upcoming Matches Table -->
            <div class="section-header">
                <h3>Upcoming Matches</h3>
                <a href="MatchServlet?action=viewPublic" class="view-all-link">View All</a>
            </div>

            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Tournament</th>
                            <th>Match-up</th>
                            <th>Date &amp; Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (recentMatches.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="4" style="text-align:center;padding:32px;color:var(--on-surface-variant);">
                                <span class="material-symbols-outlined" style="font-size:32px;display:block;margin-bottom:8px;">event_busy</span>
                                No matches scheduled yet.
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String,String> m : recentMatches) {
                                String res = m.get("result");
                                boolean pending = (res == null || res.isEmpty() || res.equals("Pending") || res.equals("null"));
                                String winner = m.get("winner");
                                boolean hasWinner = (winner != null && !winner.isEmpty() && !winner.equals("None") && !winner.equals("null"));
                    %>
                        <tr>
                            <td class="fw-bold"><%= m.get("tournament_name") %></td>
                            <td>
                                <span style="font-weight:600;"><%= m.get("team1") %></span>
                                <span class="text-muted" style="margin:0 5px;">vs</span>
                                <span style="font-weight:600;"><%= m.get("team2") %></span>
                            </td>
                            <td class="text-muted"><%= m.get("match_date") %> <%= m.get("match_time") != null ? m.get("match_time") : "" %></td>
                            <td>
                                <% if (hasWinner) { %>
                                    <span class="badge badge-grey">Completed</span>
                                <% } else if (pending) { %>
                                    <span class="badge badge-orange">Upcoming</span>
                                <% } else { %>
                                    <span class="badge badge-green"><%= res %></span>
                                <% } %>
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
