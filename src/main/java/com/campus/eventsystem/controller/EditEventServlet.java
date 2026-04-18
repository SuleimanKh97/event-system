package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.EventDAO;
import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/edit-event")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5 * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
public class EditEventServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();

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

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        int id = Integer.parseInt(idParam);
        Event event = eventDAO.getEventById(id);

        if (event == null) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        request.setAttribute("event", event);
        request.getRequestDispatcher("/views/edit-event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("date");
        String capacityParam = request.getParameter("capacity");
        String type = request.getParameter("type");
        String organizerName = request.getParameter("organizerName");
        String departmentClub = request.getParameter("departmentClub");
        String eventTime = request.getParameter("eventTime");
        String location = request.getParameter("location");
        String category = request.getParameter("category");

        if (idParam == null || idParam.isEmpty()
                || title == null || title.isEmpty()
                || description == null || description.isEmpty()
                || date == null || date.isEmpty()
                || capacityParam == null || capacityParam.isEmpty()) {

            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        int id = Integer.parseInt(idParam);
        int capacity = Integer.parseInt(capacityParam);

        // Handle image upload
        String imagePath = request.getParameter("existingImagePath");
        Part filePart = request.getPart("eventImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }
            filePart.write(uploadDir + File.separator + fileName);
            imagePath = "uploads/" + fileName;
        }

        Event event = new Event();
        event.setId(id);
        event.setTitle(title);
        event.setDescription(description);
        event.setDate(date);
        event.setCapacity(capacity);
        event.setType(type);
        event.setOrganizerName(organizerName);
        event.setDepartmentClub(departmentClub);
        event.setEventTime(eventTime);
        event.setLocation(location);
        event.setCategory(category);
        event.setImagePath(imagePath);

        eventDAO.updateEvent(event);

        response.sendRedirect(request.getContextPath() + "/events");
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}