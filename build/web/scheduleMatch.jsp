<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.tournament.util.DBConnection" %>
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
    <title>Schedule Match - Tournament Management System</title>
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
            <a href="addTournament.jsp" class="nav-link">
                <span class="material-symbols-outlined">add_circle</span> Add Tournament
            </a>
            <a href="TournamentServlet?action=view" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <a href="TeamServlet?action=viewAll" class="nav-link">
                <span class="material-symbols-outlined">groups</span> View Teams
            </a>
            <a href="#" class="nav-link active">
                <span class="material-symbols-outlined">event_upcoming</span> Schedule Match
            </a>
            <a href="MatchServlet?action=view" class="nav-link">
                <span class="material-symbols-outlined">calendar_month</span> View Matches
            </a>
            <a href="MatchServlet?action=view" class="nav-link">
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
            <span class="topbar-title">Schedule a New Match</span>
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
                    <h2>Schedule a New Match</h2>
                    <p>Select a tournament and set up the match between two registered teams.</p>
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

                <form action="MatchServlet" method="post" id="scheduleForm" onsubmit="return validateTeams()">
                    <input type="hidden" name="action" value="schedule">

                    <div class="form-group">
                        <label>Select Tournament</label>
                        <select name="tournament_id" id="tournament_id" required>
                            <option value="">-- Select Tournament --</option>
                            <%
                                try (Connection conn = DBConnection.getConnection()) {
                                    String sql = "SELECT tournament_id, name FROM tournaments WHERE status != 'Completed'";
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
                        <label>Select Team 1</label>
                        <select name="team1" id="team1Select" required onchange="checkSameTeam()">
                            <option value="">-- Select Team 1 --</option>
                            <%
                                try (Connection conn2 = DBConnection.getConnection()) {
                                    String sql2 = "SELECT team_id, team_name FROM teams ORDER BY team_name ASC";
                                    PreparedStatement stmt2 = conn2.prepareStatement(sql2);
                                    ResultSet rs2 = stmt2.executeQuery();
                                    while (rs2.next()) {
                            %>
                                <option value="<%= rs2.getString("team_name") %>"><%= rs2.getString("team_name") %></option>
                            <%
                                    }
                                } catch (Exception e2) {
                                    e2.printStackTrace();
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Select Team 2</label>
                        <select name="team2" id="team2Select" required onchange="checkSameTeam()">
                            <option value="">-- Select Team 2 --</option>
                            <%
                                try (Connection conn3 = DBConnection.getConnection()) {
                                    String sql3 = "SELECT team_id, team_name FROM teams ORDER BY team_name ASC";
                                    PreparedStatement stmt3 = conn3.prepareStatement(sql3);
                                    ResultSet rs3 = stmt3.executeQuery();
                                    while (rs3.next()) {
                            %>
                                <option value="<%= rs3.getString("team_name") %>"><%= rs3.getString("team_name") %></option>
                            <%
                                    }
                                } catch (Exception e3) {
                                    e3.printStackTrace();
                                }
                            %>
                        </select>
                        <span id="sameTeamError" style="color:#d32f2f;font-size:13px;display:none;">
                            &#9888; Team 1 and Team 2 cannot be the same!
                        </span>
                    </div>

                    <div class="form-group">
                        <label>Match Date</label>
                        <input type="date" name="match_date" required>
                    </div>
                    <div class="form-group">
                        <label>Match Time</label>
                        <input type="time" name="match_time" required>
                    </div>
                    <div class="form-group">
                        <label>Venue</label>
                        <input type="text" name="venue" placeholder="e.g. Main Sports Ground" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:12px;">
                        <span class="material-symbols-outlined" style="font-size:18px;">event_available</span>
                        Schedule Match
                    </button>
                </form>
            </div>
        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->

<script>
    function checkSameTeam() {
        var t1 = document.getElementById('team1Select').value;
        var t2 = document.getElementById('team2Select').value;
        var errorSpan = document.getElementById('sameTeamError');
        if (t1 && t2 && t1 === t2) {
            errorSpan.style.display = 'block';
        } else {
            errorSpan.style.display = 'none';
        }
    }

    function validateTeams() {
        var t1 = document.getElementById('team1Select').value;
        var t2 = document.getElementById('team2Select').value;
        if (t1 && t2 && t1 === t2) {
            alert('Team 1 and Team 2 cannot be the same! Please select different teams.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>
