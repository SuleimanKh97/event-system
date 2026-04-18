package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.ReservationDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/mark-attendance")
public class MarkAttendanceServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session & role guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (!"organizer".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("userId"));
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String status = request.getParameter("status"); // PRESENT or ABSENT

        reservationDAO.updateAttendance(userId, eventId, status);

        response.sendRedirect(request.getContextPath() + "/view-attendees?eventId=" + eventId);
    }
}
