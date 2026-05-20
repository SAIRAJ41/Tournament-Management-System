package com.tournament.servlet;

import com.tournament.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * RegisterServlet handles new user account creation.
 * New users are always assigned the role USER.
 *
 * Security note: In real applications, passwords should be stored using hashing
 * (e.g. BCrypt). Plain-text storage is used here for college assignment purposes only.
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username        = request.getParameter("username");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // --- Basic validation ---

        // Ensure fields are not empty
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=Username and password are required");
            return;
        }

        // Trim input
        username = username.trim();

        // Check password match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=Passwords do not match. Please try again.");
            return;
        }

        // --- Database operations ---
        try (Connection conn = DBConnection.getConnection()) {

            // Check if username already exists
            String checkSql = "SELECT user_id FROM users WHERE username = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Username is taken
                response.sendRedirect("register.jsp?error=Username already exists. Please choose a different one.");
                return;
            }

            // Insert new user with role USER
            // In real applications, passwords should be stored using hashing.
            String insertSql = "INSERT INTO users(username, password, role) VALUES (?, ?, 'USER')";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, username);
            insertStmt.setString(2, password);
            insertStmt.executeUpdate();

            // Redirect to login with success flag
            response.sendRedirect("login.jsp?registered=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Registration failed due to a server error. Please try again.");
        }
    }

    // Redirect GET requests to the register page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}
