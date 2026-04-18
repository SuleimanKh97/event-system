package com.campus.eventsystem.controller;

import com.campus.eventsystem.dao.EventDAO;
import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.model.User;
import com.campus.eventsystem.service.EventFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/add-event")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize       = 5 * 1024 * 1024,  // 5 MB
    maxRequestSize    = 10 * 1024 * 1024  // 10 MB
)
public class AddEventServlet extends HttpServlet {

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

        request.getRequestDispatcher("/views/add-event.jsp").forward(request, response);
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
        User loggedUser = (User) session.getAttribute("loggedUser");
        if (!"organizer".equalsIgnoreCase(loggedUser.getRole()) && !"admin".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Read form fields
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("date");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String type = request.getParameter("type");
        String organizerName = request.getParameter("organizerName");
        String departmentClub = request.getParameter("departmentClub");
        String eventTime = request.getParameter("eventTime");
        String location = request.getParameter("location");
        String category = request.getParameter("category");

        // Handle image upload
        String imagePath = null;
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

        // Create event via Factory
        Event event = EventFactory.createEvent(type);
        event.setTitle(title);
        event.setDescription(description);
        event.setDate(date);
        event.setCapacity(capacity);
        event.setOrganizerId(loggedUser.getId());
        event.setOrganizerName(organizerName);
        event.setDepartmentClub(departmentClub);
        event.setEventTime(eventTime);
        event.setLocation(location);
        event.setCategory(category);
        event.setImagePath(imagePath);

        EventDAO dao = new EventDAO();
        boolean success = dao.addEvent(event);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/events");
        } else {
            request.setAttribute("error", "Error adding event");
            request.getRequestDispatcher("/views/add-event.jsp").forward(request, response);
        }
    }

    /**
     * Extract file name from Part header.
     */
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