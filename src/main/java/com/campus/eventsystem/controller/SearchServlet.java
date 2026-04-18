package com.campus.eventsystem.controller;

import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String keyword = request.getParameter("keyword");

        SearchContext context = new SearchContext();

        if ("title".equals(type)) {
            context.setStrategy(new SearchByTitle());
        } else if ("date".equals(type)) {
            context.setStrategy(new SearchByDate());
        } else if ("department".equals(type)) {
            context.setStrategy(new SearchByDepartment());
        } else if ("category".equals(type)) {
            context.setStrategy(new SearchByCategory());
        } else if ("type".equals(type)) {
            context.setStrategy(new SearchByType());
        } else if ("availability".equals(type)) {
            context.setStrategy(new SearchByAvailability());
        } else {
            // default: search by title
            context.setStrategy(new SearchByTitle());
        }

        List<Event> events = context.executeSearch(keyword);

        request.setAttribute("events", events);
        request.getRequestDispatcher("/views/events.jsp").forward(request, response);
    }
}