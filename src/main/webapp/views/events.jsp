<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.eventsystem.model.Event" %>
<%@ page import="com.campus.eventsystem.model.User" %>

<%
    User user = (User) session.getAttribute("loggedUser");
    List<Event> events = (List<Event>) request.getAttribute("events");
    String role = (user != null) ? user.getRole() : "";
    boolean isOrganizer = "organizer".equalsIgnoreCase(role);
    boolean isAdmin = "admin".equalsIgnoreCase(role);
    boolean canManage = isOrganizer || isAdmin;
%>

<html>
<head>
    <title>Events</title>
</head>
<body>

<h2>All Events</h2>

<!-- Search Form with 6 strategies -->
<form action="${pageContext.request.contextPath}/search" method="get">
    <input type="text" name="keyword" placeholder="Search...">

    <select name="type">
        <option value="title">Title</option>
        <option value="date">Date</option>
        <option value="department">Department/Club</option>
        <option value="category">Category</option>
        <option value="type">Event Type</option>
        <option value="availability">Available Seats</option>
    </select>

    <button type="submit">Search</button>
</form>

<br>

<table border="1">
    <tr>
        <th>Title</th>
        <th>Organizer</th>
        <th>Dept/Club</th>
        <th>Description</th>
        <th>Date</th>
        <th>Time</th>
        <th>Location</th>
        <th>Capacity</th>
        <th>Type</th>
        <th>Category</th>
        <th>Registration</th>
        <th>Event Status</th>
        <th>Image</th>
        <th>Reserve</th>

        <% if (canManage) { %>
        <th>Attendees</th>
        <th>Edit</th>
        <th>Delete</th>
        <th>Close Reg.</th>
        <th>Complete</th>
        <% } %>
    </tr>

    <%
        if (events != null) {
            for (Event e : events) {
                String regStatus = e.getRegistrationStatus() != null ? e.getRegistrationStatus() : "";
                String evtStatus = e.getEventStatus() != null ? e.getEventStatus() : "";
                boolean canReserve = "OPEN".equalsIgnoreCase(regStatus) && "UPCOMING".equalsIgnoreCase(evtStatus) && e.getCapacity() > 0;
    %>
    <tr>
        <td><%= e.getTitle() %></td>
        <td><%= e.getOrganizerName() != null ? e.getOrganizerName() : "" %></td>
        <td><%= e.getDepartmentClub() != null ? e.getDepartmentClub() : "" %></td>
        <td><%= e.getDescription() %></td>
        <td><%= e.getDate() %></td>
        <td><%= e.getEventTime() != null ? e.getEventTime() : "" %></td>
        <td><%= e.getLocation() != null ? e.getLocation() : "" %></td>
        <td><%= e.getCapacity() %></td>
        <td><%= e.getType() != null ? e.getType() : "" %></td>
        <td><%= e.getCategory() != null ? e.getCategory() : "" %></td>
        <td><%= regStatus %></td>
        <td><%= evtStatus %></td>
        <td>
            <% if (e.getImagePath() != null && !e.getImagePath().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= e.getImagePath() %>" width="60" height="60" alt="event">
            <% } else { %>
                -
            <% } %>
        </td>

        <td>
            <% if (canReserve && user != null && "student".equalsIgnoreCase(user.getRole())) { %>
            <form action="${pageContext.request.contextPath}/reserve" method="post">
                <input type="hidden" name="eventId" value="<%= e.getId() %>">
                <button type="submit">Reserve</button>
            </form>
            <% } else if (!canReserve) { %>
                -
            <% } %>
        </td>

        <% if (canManage) { %>
        <td>
            <a href="${pageContext.request.contextPath}/view-attendees?eventId=<%= e.getId() %>">
                View
            </a>
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/edit-event?id=<%= e.getId() %>">Edit</a>
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/delete-event?id=<%= e.getId() %>">Delete</a>
        </td>
        <td>
            <% if ("OPEN".equalsIgnoreCase(regStatus)) { %>
            <a href="${pageContext.request.contextPath}/close-event?id=<%= e.getId() %>">Close</a>
            <% } else { %>
                Closed
            <% } %>
        </td>
        <td>
            <% if (!"COMPLETED".equalsIgnoreCase(evtStatus)) { %>
            <a href="${pageContext.request.contextPath}/complete-event?id=<%= e.getId() %>">Complete</a>
            <% } else { %>
                Done
            <% } %>
        </td>
        <% } %>
    </tr>
    <%
            }
        }
    %>
</table>

<br>
<% if (user != null) { %>
    <% if ("student".equalsIgnoreCase(user.getRole())) { %>
        <a href="${pageContext.request.contextPath}/student/home">Back</a>
    <% } else if ("organizer".equalsIgnoreCase(user.getRole())) { %>
        <a href="${pageContext.request.contextPath}/organizer/home">Back</a>
    <% } else if ("admin".equalsIgnoreCase(user.getRole())) { %>
        <a href="${pageContext.request.contextPath}/admin/home">Back</a>
    <% } %>
<% } %>

</body>
</html>