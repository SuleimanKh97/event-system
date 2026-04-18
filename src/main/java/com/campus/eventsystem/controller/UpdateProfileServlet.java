package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.UserDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        user.setFullName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setFaculty(request.getParameter("faculty"));
        user.setDepartment(request.getParameter("department"));
        user.setAdmissionYear(Integer.parseInt(request.getParameter("year")));

        userDAO.updateUser(user);

        session.setAttribute("loggedUser", user);

        response.sendRedirect(request.getContextPath() + "/views/profile.jsp");
    }
}