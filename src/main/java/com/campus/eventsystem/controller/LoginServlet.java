package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.UserDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

            String role = user.getRole();

            if ("student".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/student/home");
            } else if ("organizer".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/organizer/home");
            } else if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/home");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } else {
            // ✨ هذا الجزء الجديد
            request.setAttribute("error", "Invalid credentials or user is blocked");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}