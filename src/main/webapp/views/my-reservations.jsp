<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.eventsystem.model.Event" %>
<%@ page import="com.campus.eventsystem.model.User" %>
<%@ page import="com.campus.eventsystem.dao.RatingDAO" %>

<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    RatingDAO ratingDAO = new RatingDAO();
%>

<html>
<head>
    <title>My Reservations</title>
</head>
<body>

<h2>My Reservations</h2>

<table border="1">
    <tr>
        <th>Title</th>
        <th>Description</th>
        <th>Date</th>
        <th>Type</th>
        <th>Event Status</th>
        <th>Cancel</th>
        <th>Rate</th>
    </tr>

    <%
        List<Event> events = (List<Event>) request.getAttribute("events");

        if (events != null) {
            for (Event e : events) {
                String evtStatus = e.getEventStatus() != null ? e.getEventStatus() : "";
                boolean canRate = ("COMPLETED".equalsIgnoreCase(evtStatus) || "EXPIRED".equalsIgnoreCase(evtStatus))
                                  && !ratingDAO.hasRated(user.getId(), e.getId());
                boolean canCancel = "UPCOMING".equalsIgnoreCase(evtStatus);
    %>
    <tr>
        <td><%= e.getTitle() %></td>
        <td><%= e.getDescription() %></td>
        <td><%= e.getDate() %></td>
        <td><%= e.getType() %></td>
        <td><%= evtStatus %></td>
        <td>
            <% if (canCancel) { %>
            <a href="${pageContext.request.contextPath}/cancel-reservation?eventId=<%= e.getId() %>">
                Cancel
            </a>
            <% } else { %>
                -
            <% } %>
        </td>
        <td>
            <% if (canRate) { %>
            <form action="${pageContext.request.contextPath}/rate-event" method="post" style="display:inline;">
                <input type="hidden" name="eventId" value="<%= e.getId() %>">
                <select name="rating">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
                <input type="text" name="comment" placeholder="Comment" size="15">
                <button type="submit">Rate</button>
            </form>
            <% } else if (ratingDAO.hasRated(user.getId(), e.getId())) { %>
                Rated ✓
            <% } else { %>
                -
            <% } %>
        </td>
    </tr>
    <%
            }
        }
    %>

</table>

<br>
<a href="${pageContext.request.contextPath}/student/home">Back</a>

</body>
</html>