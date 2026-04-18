package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.EventDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.campus.eventsystem.dao.ReservationDAO;

@WebServlet("/reserve")
public class ReserveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        ReservationDAO reservationDAO = new ReservationDAO();

        if (reservationDAO.hasReservation(user.getId(), eventId)) {
            response.getWriter().println("You already reserved this event!");
            return;
        }

        EventDAO dao = new EventDAO();
        boolean success = dao.reserveEvent(user.getId(), eventId);

        if (success) {
            response.getWriter().println("Reservation successful!");
        } else {
            response.getWriter().println("No seats available!");
        }
    }
}