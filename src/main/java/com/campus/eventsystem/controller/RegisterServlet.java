package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.UserDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String faculty = request.getParameter("faculty");
        String department = request.getParameter("department");
        int year = Integer.parseInt(request.getParameter("year"));

        // Check duplicate email
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole("student"); // default
        user.setFaculty(faculty);
        user.setDepartment(department);
        user.setAdmissionYear(year);

        boolean success = userDAO.registerUser(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}