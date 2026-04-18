package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.RatingDAO;
import com.campus.eventsystem.dao.ReservationDAO;
import com.campus.eventsystem.model.Rating;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/rate-event")
public class RateEventServlet extends HttpServlet {

    private RatingDAO ratingDAO = new RatingDAO();
    private ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int ratingValue = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        // Check student has reservation
        if (!reservationDAO.hasReservation(user.getId(), eventId)) {
            response.sendRedirect(request.getContextPath() + "/my-reservations");
            return;
        }

        // Check not already rated
        if (ratingDAO.hasRated(user.getId(), eventId)) {
            response.sendRedirect(request.getContextPath() + "/my-reservations");
            return;
        }

        Rating rating = new Rating();
        rating.setUserId(user.getId());
        rating.setEventId(eventId);
        rating.setRating(ratingValue);
        rating.setComment(comment);

        ratingDAO.addRating(rating);

        response.sendRedirect(request.getContextPath() + "/my-reservations");
    }
}
