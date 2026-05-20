package com.tournament.servlet;

import com.tournament.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * MatchServlet handles backend logic for scheduling and updating matches.
 * POST actions (schedule, update) are restricted to ADMIN role only.
 */
@WebServlet("/MatchServlet")
public class MatchServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Role guard: only ADMIN can schedule or update match results
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp?error=Please login to continue");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect("userDashboard.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("schedule".equals(action)) {
            int tournamentId = Integer.parseInt(request.getParameter("tournament_id"));
            String team1 = request.getParameter("team1");
            String team2 = request.getParameter("team2");
            String matchDate = request.getParameter("match_date");
            String matchTime = request.getParameter("match_time");
            String venue = request.getParameter("venue");

            // Prevent same team match
            if (team1 != null && team1.equals(team2)) {
                response.sendRedirect("scheduleMatch.jsp?error=Team 1 and Team 2 cannot be the same");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO matches (tournament_id, team1, team2, match_date, match_time, venue, result, winner) VALUES (?, ?, ?, ?, ?, ?, 'Pending', 'None')";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, tournamentId);
                stmt.setString(2, team1);
                stmt.setString(3, team2);
                stmt.setString(4, matchDate);
                stmt.setString(5, matchTime);
                stmt.setString(6, venue);

                stmt.executeUpdate();
                response.sendRedirect("scheduleMatch.jsp?message=Match scheduled successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("scheduleMatch.jsp?error=Error scheduling match");
            }
        } else if ("update".equals(action)) {
            int matchId = Integer.parseInt(request.getParameter("match_id"));
            String result = request.getParameter("result");
            String winner = request.getParameter("winner");

            try (Connection conn = DBConnection.getConnection()) {
                // Update match result
                String sql = "UPDATE matches SET result = ?, winner = ? WHERE match_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, result);
                stmt.setString(2, winner);
                stmt.setInt(3, matchId);
                stmt.executeUpdate();

                // Fetch team names and tournament_id for this match
                String fetchSql = "SELECT tournament_id, team1, team2 FROM matches WHERE match_id = ?";
                PreparedStatement fetchStmt = conn.prepareStatement(fetchSql);
                fetchStmt.setInt(1, matchId);
                ResultSet fetchRs = fetchStmt.executeQuery();

                if (fetchRs.next()) {
                    int tid = fetchRs.getInt("tournament_id");
                    String team1 = fetchRs.getString("team1");
                    String team2 = fetchRs.getString("team2");

                    if ("Draw".equalsIgnoreCase(winner)) {
                        // Draw: both teams get played+1, draw+1, points+1
                        String drawSql = "UPDATE points_table SET played = played + 1, draw = draw + 1, points = points + 1 WHERE tournament_id = ? AND team_name = ?";
                        PreparedStatement d1 = conn.prepareStatement(drawSql);
                        d1.setInt(1, tid); d1.setString(2, team1); d1.executeUpdate();
                        PreparedStatement d2 = conn.prepareStatement(drawSql);
                        d2.setInt(1, tid); d2.setString(2, team2); d2.executeUpdate();
                    } else {
                        // Determine winner and loser
                        String loser = winner.equals(team1) ? team2 : team1;

                        // Winner: played+1, won+1, points+2
                        String winSql = "UPDATE points_table SET played = played + 1, won = won + 1, points = points + 2 WHERE tournament_id = ? AND team_name = ?";
                        PreparedStatement ws = conn.prepareStatement(winSql);
                        ws.setInt(1, tid); ws.setString(2, winner); ws.executeUpdate();

                        // Loser: played+1, lost+1
                        String loseSql = "UPDATE points_table SET played = played + 1, lost = lost + 1 WHERE tournament_id = ? AND team_name = ?";
                        PreparedStatement ls = conn.prepareStatement(loseSql);
                        ls.setInt(1, tid); ls.setString(2, loser); ls.executeUpdate();
                    }
                }

                response.sendRedirect("updateResult.jsp?message=Result updated successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("updateResult.jsp?error=Error updating result");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Session guard: must be logged in to view matches
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login to view matches");
            return;
        }

        String action = request.getParameter("action");

        List<Map<String, String>> matches = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT m.*, t.name as tournament_name FROM matches m JOIN tournaments t ON m.tournament_id = t.tournament_id";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> match = new HashMap<>();
                match.put("match_id", String.valueOf(rs.getInt("match_id")));
                match.put("tournament_name", rs.getString("tournament_name"));
                match.put("team1", rs.getString("team1"));
                match.put("team2", rs.getString("team2"));
                match.put("match_date", rs.getString("match_date"));
                match.put("match_time", rs.getString("match_time"));
                match.put("venue", rs.getString("venue"));
                match.put("result", rs.getString("result"));
                match.put("winner", rs.getString("winner"));
                matches.add(match);
            }

            request.setAttribute("matches", matches);
            request.getRequestDispatcher("viewMatches.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving matches.");
        }
    }
}
