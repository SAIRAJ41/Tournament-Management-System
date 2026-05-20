<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.tournament.util.DBConnection, java.util.*" %>
<%
    // Session guard
    String _username = (String) session.getAttribute("username");
    String _role     = (String) session.getAttribute("role");
    if (_username == null) {
        response.sendRedirect("login.jsp?error=Please login to view points table");
        return;
    }
    boolean isAdmin = "ADMIN".equals(_role);
    String dashLink = isAdmin ? "adminDashboard.jsp" : "userDashboard.jsp";

    // Fetch all tournaments that have points_table entries
    List<Map<String,String>> tournaments = new ArrayList<>();
    // Fetch grouped points data: tournament_id -> list of team rows
    Map<String, List<Map<String,String>>> pointsMap = new LinkedHashMap<>();
    Map<String, String> tournamentNames = new LinkedHashMap<>();

    try (Connection conn = DBConnection.getConnection()) {
        // Get distinct tournaments from points_table
        String tSql = "SELECT DISTINCT p.tournament_id, t.name " +
                      "FROM points_table p JOIN tournaments t ON p.tournament_id = t.tournament_id " +
                      "ORDER BY t.name";
        PreparedStatement tStmt = conn.prepareStatement(tSql);
        ResultSet tRs = tStmt.executeQuery();
        while (tRs.next()) {
            String tid = String.valueOf(tRs.getInt("tournament_id"));
            tournamentNames.put(tid, tRs.getString("name"));
        }

        // For each tournament, fetch standings sorted by points DESC
        for (String tid : tournamentNames.keySet()) {
            String pSql = "SELECT team_name, played, won, lost, draw, points " +
                          "FROM points_table WHERE tournament_id = ? ORDER BY points DESC, won DESC";
            PreparedStatement pStmt = conn.prepareStatement(pSql);
            pStmt.setInt(1, Integer.parseInt(tid));
            ResultSet pRs = pStmt.executeQuery();
            List<Map<String,String>> rows = new ArrayList<>();
            while (pRs.next()) {
                Map<String,String> row = new HashMap<>();
                row.put("team_name", pRs.getString("team_name"));
                row.put("played",    String.valueOf(pRs.getInt("played")));
                row.put("won",       String.valueOf(pRs.getInt("won")));
                row.put("lost",      String.valueOf(pRs.getInt("lost")));
                row.put("draw",      String.valueOf(pRs.getInt("draw")));
                row.put("points",    String.valueOf(pRs.getInt("points")));
                rows.add(row);
            }
            pointsMap.put(tid, rows);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Points Table - Tournament Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200">
</head>
<body>
<div class="page-wrapper">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-name">Tournament Pro</span>
            <span class="brand-sub"><%= isAdmin ? "Admin Panel" : "College Sports Portal" %></span>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= dashLink %>" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span> Dashboard
            </a>
            <% if (isAdmin) { %>
            <a href="addTournament.jsp" class="nav-link">
                <span class="material-symbols-outlined">add_circle</span> Add Tournament
            </a>
            <% } %>
            <a href="<%= isAdmin ? "TournamentServlet?action=view" : "TournamentServlet?action=viewActive" %>" class="nav-link">
                <span class="material-symbols-outlined">emoji_events</span> View Tournaments
            </a>
            <% if (isAdmin) { %>
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
            <a href="<%= isAdmin ? "MatchServlet?action=view" : "MatchServlet?action=viewPublic" %>" class="nav-link">
                <span class="material-symbols-outlined">calendar_month</span> View Matches
            </a>
            <a href="pointsTable.jsp" class="nav-link active">
                <span class="material-symbols-outlined">leaderboard</span> Points Table
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
            <span class="topbar-title">Points Table</span>
            <div class="topbar-actions">
                <a href="<%= dashLink %>" class="btn btn-outline btn-sm">
                    <span class="material-symbols-outlined" style="font-size:16px;">arrow_back</span> Dashboard
                </a>
                <div class="topbar-user"><%= _username.substring(0,1).toUpperCase() %></div>
                <span class="topbar-username">User: <%= _username %></span>
            </div>
        </header>

        <!-- Content -->
        <div class="content-canvas">

            <div class="page-header">
                <div>
                    <h2>Tournament Standings</h2>
                    <p>Points table across all tournaments. Win = 2 pts, Draw = 1 pt, Loss = 0 pts.</p>
                </div>
            </div>

            <%
                if (tournamentNames.isEmpty()) {
            %>
                <div class="table-card" style="text-align:center;padding:48px;">
                    <span class="material-symbols-outlined" style="font-size:48px;color:var(--on-surface-variant);display:block;margin-bottom:12px;">leaderboard</span>
                    <p style="color:var(--on-surface-variant);font-size:15px;">No teams registered yet. Points table will appear once teams join tournaments.</p>
                </div>
            <%
                } else {
                    for (Map.Entry<String, String> entry : tournamentNames.entrySet()) {
                        String tid = entry.getKey();
                        String tName = entry.getValue();
                        List<Map<String,String>> rows = pointsMap.get(tid);
            %>

            <!-- Tournament: <%= tName %> -->
            <div class="table-card">
                <div class="table-card-header">
                    <h3>
                        <span class="material-symbols-outlined" style="font-size:18px;vertical-align:middle;margin-right:6px;">emoji_events</span>
                        <%= tName %>
                    </h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Team</th>
                            <th>Played</th>
                            <th>Won</th>
                            <th>Lost</th>
                            <th>Draw</th>
                            <th>Points</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (rows == null || rows.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" style="text-align:center;padding:24px;color:var(--on-surface-variant);">
                                No teams in this tournament yet.
                            </td>
                        </tr>
                    <%
                        } else {
                            int rank = 1;
                            for (Map<String,String> r : rows) {
                                int pts = Integer.parseInt(r.get("points"));
                    %>
                        <tr>
                            <td style="font-weight:700;color:var(--primary);"><%= rank %></td>
                            <td>
                                <span style="display:inline-flex;align-items:center;gap:8px;">
                                    <span style="width:28px;height:28px;border-radius:50%;background:var(--primary);color:#fff;display:inline-flex;align-items:center;justify-content:center;font-weight:700;font-size:11px;flex-shrink:0;">
                                        <%= r.get("team_name").substring(0,1).toUpperCase() %>
                                    </span>
                                    <span style="font-weight:600;"><%= r.get("team_name") %></span>
                                </span>
                            </td>
                            <td><%= r.get("played") %></td>
                            <td style="color:#1b6e3a;font-weight:600;"><%= r.get("won") %></td>
                            <td style="color:#ba1a1a;font-weight:600;"><%= r.get("lost") %></td>
                            <td><%= r.get("draw") %></td>
                            <td>
                                <span class="badge <%= pts > 0 ? "badge-green" : "badge-grey" %>" style="font-size:13px;padding:4px 14px;">
                                    <%= r.get("points") %>
                                </span>
                            </td>
                        </tr>
                    <%
                                rank++;
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <%
                    }
                }
            %>

        </div><!-- /content-canvas -->
    </div><!-- /main-content -->
</div><!-- /page-wrapper -->
</body>
</html>
