<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.eventsystem.model.Event" %>

<%
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/events");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Edit Event</h1>
        <p>Update event details for "<%= event.getTitle() %>"</p>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/edit-event" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= event.getId() %>">
            <input type="hidden" name="existingImagePath" value="<%= event.getImagePath() != null ? event.getImagePath() : "" %>">

            <div class="form-group">
                <label>Event Type</label>
                <select name="type">
                    <option value="workshop" <%= "Workshop".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Workshop</option>
                    <option value="seminar" <%= "Seminar".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Seminar</option>
                    <option value="clubsocial" <%= "Club Social Event".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Club Social Event</option>
                    <option value="sports" <%= "Sports Activity".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Sports Activity</option>
                </select>
            </div>

            <div class="form-group">
                <label>Title</label>
                <input type="text" name="title" value="<%= event.getTitle() %>" required>
            </div>

            <div class="form-group">
                <label>Organizer Name</label>
                <input type="text" name="organizerName" value="<%= event.getOrganizerName() != null ? event.getOrganizerName() : "" %>">
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" rows="3" required><%= event.getDescription() %></textarea>
            </div>

            <div class="form-group">
                <label>Department / Club</label>
                <input type="text" name="departmentClub" value="<%= event.getDepartmentClub() != null ? event.getDepartmentClub() : "" %>">
            </div>

            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" value="<%= event.getDate() %>" required>
            </div>

            <div class="form-group">
                <label>Time</label>
                <input type="time" name="eventTime" value="<%= event.getEventTime() != null ? event.getEventTime() : "" %>">
            </div>

            <div class="form-group">
                <label>Location</label>
                <input type="text" name="location" value="<%= event.getLocation() != null ? event.getLocation() : "" %>">
            </div>

            <div class="form-group">
                <label>Capacity</label>
                <input type="number" name="capacity" value="<%= event.getCapacity() %>" min="1" required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="category">
                    <option value="Educational" <%= "Educational".equals(event.getCategory()) ? "selected" : "" %>>Educational</option>
                    <option value="Social" <%= "Social".equals(event.getCategory()) ? "selected" : "" %>>Social</option>
                    <option value="Sports" <%= "Sports".equals(event.getCategory()) ? "selected" : "" %>>Sports</option>
                    <option value="Cultural" <%= "Cultural".equals(event.getCategory()) ? "selected" : "" %>>Cultural</option>
                    <option value="Technical" <%= "Technical".equals(event.getCategory()) ? "selected" : "" %>>Technical</option>
                </select>
            </div>

            <% if (event.getImagePath() != null && !event.getImagePath().isEmpty()) { %>
            <div class="form-group">
                <label>Current Image</label>
                <img src="${pageContext.request.contextPath}/<%= event.getImagePath() %>" width="120" style="border-radius:8px; border:1px solid var(--border);" alt="current">
            </div>
            <% } %>

            <div class="form-group">
                <label>New Image (max 5MB)</label>
                <input type="file" name="eventImage" accept="image/*">
            </div>

            <button type="submit">Update Event</button>
        </form>
    </div>

    <div style="margin-top:1rem;">
        <a class="back-link" href="${pageContext.request.contextPath}/events">Back to Events</a>
    </div>
</div>

</body>
</html>