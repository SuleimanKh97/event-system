package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.EventDAO;
import com.campus.eventsystem.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/events")
public class ViewEventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EventDAO dao = new EventDAO();

        // Auto-expire past events before listing
        dao.expireOldEvents();

        List<Event> events = dao.getAllEvents();

        request.setAttribute("events", events);
        request.getRequestDispatcher("/views/events.jsp").forward(request, response);
    }
}