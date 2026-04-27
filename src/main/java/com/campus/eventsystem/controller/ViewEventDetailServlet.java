package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.EventDAO;
import com.campus.eventsystem.dao.RatingDAO;
import com.campus.eventsystem.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/event-detail")
public class ViewEventDetailServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();
    private final RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        Event event = eventDAO.getEventById(eventId);
        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        double avgRating = ratingDAO.getAverageRating(eventId);
        int ratingCount = ratingDAO.getRatingCount(eventId);
        int attendeesCount = eventDAO.getAttendeesCount(eventId);

        request.setAttribute("event", event);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("ratingCount", ratingCount);
        request.setAttribute("attendeesCount", attendeesCount);

        request.getRequestDispatcher("/views/event-detail.jsp").forward(request, response);
    }
}
