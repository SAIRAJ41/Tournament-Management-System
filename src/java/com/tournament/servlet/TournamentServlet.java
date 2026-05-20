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
 * TournamentServlet handles backend request processing for tournaments.
 * POST (add tournament) is restricted to ADMIN role only.
 */
@WebServlet("/TournamentServlet")
public class TournamentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Role guard: only ADMIN can add tournaments
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

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String sport = request.getParameter("sport");
            String startDate = request.getParameter("start_date");
            String endDate = request.getParameter("end_date");
            String venue = request.getParameter("venue");
            String status = request.getParameter("status");

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO tournaments (name, sport, start_date, end_date, venue, status) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, sport);
                stmt.setString(3, startDate);
                stmt.setString(4, endDate);
                stmt.setString(5, venue);
                stmt.setString(6, status);

                stmt.executeUpdate();
                response.sendRedirect("addTournament.jsp?message=Tournament added successfully");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("addTournament.jsp?error=Error adding tournament");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Session guard: must be logged in to view tournaments
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp?error=Please login to view tournaments");
            return;
        }

        String action = request.getParameter("action");

        List<Map<String, String>> tournaments = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM tournaments";
            if ("viewActive".equals(action)) {
                sql += " WHERE status = 'Upcoming' OR status = 'Ongoing'";
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> t = new HashMap<>();
                t.put("id", String.valueOf(rs.getInt("tournament_id")));
                t.put("name", rs.getString("name"));
                t.put("sport", rs.getString("sport"));
                t.put("start_date", rs.getString("start_date"));
                t.put("end_date", rs.getString("end_date"));
                t.put("venue", rs.getString("venue"));
                t.put("status", rs.getString("status"));
                tournaments.add(t);
            }

            request.setAttribute("tournaments", tournaments);
            request.getRequestDispatcher("viewTournaments.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error retrieving tournaments.");
        }
    }
}
