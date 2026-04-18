<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.eventsystem.model.Event" %>

<%
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/events");
        return;
    }
%>

<html>
<head>
    <title>Edit Event</title>
</head>
<body>

<h2>Edit Event</h2>

<form action="${pageContext.request.contextPath}/edit-event" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%= event.getId() %>">
    <input type="hidden" name="existingImagePath" value="<%= event.getImagePath() != null ? event.getImagePath() : "" %>">

    Type:
    <select name="type">
        <option value="workshop" <%= "Workshop".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Workshop</option>
        <option value="seminar" <%= "Seminar".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Seminar</option>
        <option value="clubsocial" <%= "Club Social Event".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Club Social Event</option>
        <option value="sports" <%= "Sports Activity".equalsIgnoreCase(event.getType()) ? "selected" : "" %>>Sports Activity</option>
    </select>
    <br><br>

    Title: <input type="text" name="title" value="<%= event.getTitle() %>" required><br><br>
    Organizer Name: <input type="text" name="organizerName" value="<%= event.getOrganizerName() != null ? event.getOrganizerName() : "" %>"><br><br>
    Description: <textarea name="description" rows="3" cols="40" required><%= event.getDescription() %></textarea><br><br>
    Department/Club: <input type="text" name="departmentClub" value="<%= event.getDepartmentClub() != null ? event.getDepartmentClub() : "" %>"><br><br>
    Date: <input type="date" name="date" value="<%= event.getDate() %>" required><br><br>
    Time: <input type="time" name="eventTime" value="<%= event.getEventTime() != null ? event.getEventTime() : "" %>"><br><br>
    Location: <input type="text" name="location" value="<%= event.getLocation() != null ? event.getLocation() : "" %>"><br><br>
    Capacity: <input type="number" name="capacity" value="<%= event.getCapacity() %>" min="1" required><br><br>

    Category:
    <select name="category">
        <option value="Educational" <%= "Educational".equals(event.getCategory()) ? "selected" : "" %>>Educational</option>
        <option value="Social" <%= "Social".equals(event.getCategory()) ? "selected" : "" %>>Social</option>
        <option value="Sports" <%= "Sports".equals(event.getCategory()) ? "selected" : "" %>>Sports</option>
        <option value="Cultural" <%= "Cultural".equals(event.getCategory()) ? "selected" : "" %>>Cultural</option>
        <option value="Technical" <%= "Technical".equals(event.getCategory()) ? "selected" : "" %>>Technical</option>
    </select>
    <br><br>

    <% if (event.getImagePath() != null && !event.getImagePath().isEmpty()) { %>
        Current Image: <img src="${pageContext.request.contextPath}/<%= event.getImagePath() %>" width="80" height="80" alt="current"><br><br>
    <% } %>
    New Image (max 5MB): <input type="file" name="eventImage" accept="image/*"><br><br>

    <button type="submit">Update Event</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/events">Back</a>

</body>
</html>