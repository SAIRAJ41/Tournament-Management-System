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
 * TeamServlet handles registering teams and viewing them.
 * Supports role-based team viewing: admin sees all teams, user sees only their teams.
 */
@WebServlet("/TeamServlet")
public class TeamServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("register".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("username") == null) {
                response.sendRedirect("login.jsp?error=Please login to register a team");
                return;
            }

            int tournamentId = Integer.parseInt(request.getParameter("tournament_id"));
            String teamName = request.getParameter("team_name");
            String captainName = request.getParameter("captain_name");
            String contact = request.getParameter("contact");
            String loggedInUser = (String) session.getAttribute("username");

            try (Connection conn = DBConnection.getConnection()) {
                // Look up user_id from the users table
                int userId = -1;
                String userSql = "SELECT user_id FROM users WHERE username = ?";
                PreparedStatement userStmt = conn.prepareStatement(userSql);
                userStmt.setString(1, loggedInUser);
                ResultSet userRs = userStmt.executeQuery();
                if (userRs.next()) {
                    userId = userRs.getInt("user_id");
                }

                String sql = "INSERT INTO teams (tournament_id, team_name, captain_name, contact, user_id) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, tournamentId);
                stmt.setString(2, teamName);
                stmt.setString(3, captainName);
                stmt.setString(4, contact);
                if (userId > 0) {
                    stmt.setInt(5, userId);
                } else {
                    stmt.setNull(5, java.sql.Types.INTEGER);
                }

                stmt.executeUpdate();

                // Also insert into points_table for this team
                String ptSql = "INSERT INTO points_table (tournament_id, team_name, played, won, lost, draw, points) VALUES (?, ?, 0, 0, 0, 0, 0)";
                PreparedStatement ptStmt = conn.prepareStatement(ptSql);
                ptStmt.setInt(1, tournamentId);
                ptStmt.setString(2, teamName);
                ptStmt.executeUpdate();

                response.sendRedirect("registerTeam.jsp?message=Team registered successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("registerTeam.jsp?error=Error registering team");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login to view teams");
            return;
        }

        List<Map<String, String>> teams = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            if ("viewMyTeams".equals(action)) {
                // User's own teams: look up by user_id joined from users table
                String loggedInUser = (String) session.getAttribute("username");
                String sql = "SELECT t.team_id, t.team_name, t.captain_name, t.contact, tr.name as tournament_name " +
                             "FROM teams t " +
                             "JOIN tournaments tr ON t.tournament_id = tr.tournament_id " +
                             "JOIN users u ON t.user_id = u.user_id " +
                             "WHERE u.username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, loggedInUser);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> team = new HashMap<>();
                    team.put("team_id", String.valueOf(rs.getInt("team_id")));
                    team.put("team_name", rs.getString("team_name"));
                    team.put("captain_name", rs.getString("captain_name"));
                    team.put("contact", rs.getString("contact"));
                    team.put("tournament_name", rs.getString("tournament_name"));
                    teams.add(team);
                }
            } else {
                // ADMIN: view all teams
                String sql = "SELECT t.team_id, t.team_name, t.captain_name, t.contact, tr.name as tournament_name " +
                             "FROM teams t JOIN tournaments tr ON t.tournament_id = tr.tournament_id";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Map<String, String> team = new HashMap<>();
                    team.put("team_id", String.valueOf(rs.getInt("team_id")));
                    team.put("team_name", rs.getString("team_name"));
                    team.put("captain_name", rs.getString("captain_name"));
                    team.put("contact", rs.getString("contact"));
                    team.put("tournament_name", rs.getString("tournament_name"));
                    teams.add(team);
                }
            }

            request.setAttribute("teams", teams);
            request.getRequestDispatcher("viewTeams.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving teams.");
        }
    }
}
