package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.ReservationDAO;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        int eventId = Integer.parseInt(request.getParameter("eventId"));

        reservationDAO.cancelReservation(user.getId(), eventId);

        response.sendRedirect(request.getContextPath() + "/my-reservations");
    }
}