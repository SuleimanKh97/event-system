package com.campus.eventsystem.controller;

import com.campus.eventsystem.model.User;
import com.campus.eventsystem.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session & role guard — admin only
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load departments
        List<String> departments = getAll("departments");
        List<String> categories = getAll("categories");

        request.setAttribute("departments", departments);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin-settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session & role guard — admin only
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String table = request.getParameter("table"); // "departments" or "categories"
        String name = request.getParameter("name");

        if ("add".equals(action) && name != null && !name.trim().isEmpty()) {
            addItem(table, name.trim());
        } else if ("delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                deleteItem(table, Integer.parseInt(idParam));
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }

    private List<String> getAll(String table) {
        List<String> items = new ArrayList<>();
        String sql = "SELECT name FROM " + table + " ORDER BY name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                items.add(rs.getString("name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    private void addItem(String table, String name) {
        if (!"departments".equals(table) && !"categories".equals(table)) return;

        String sql = "INSERT IGNORE INTO " + table + " (name) VALUES (?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void deleteItem(String table, int id) {
        if (!"departments".equals(table) && !"categories".equals(table)) return;

        String sql = "DELETE FROM " + table + " WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
