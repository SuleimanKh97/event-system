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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reservations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>My Reservations</h1>
        <p>Your booked events and ratings</p>
    </div>
</div>

<div class="container">
    <div class="table-card">
        <div class="table-scroll">
            <table>
                <thead>
                    <tr>
                        <th>Event</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Cancel</th>
                        <th>Rate</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<Event> events = (List<Event>) request.getAttribute("events");
                    if (events != null && !events.isEmpty()) {
                        for (Event e : events) {
                            String evtStatus = e.getEventStatus() != null ? e.getEventStatus() : "";
                            boolean canRate = ("COMPLETED".equalsIgnoreCase(evtStatus) || "EXPIRED".equalsIgnoreCase(evtStatus))
                                              && !ratingDAO.hasRated(user.getId(), e.getId());
                            boolean canCancel = "UPCOMING".equalsIgnoreCase(evtStatus);

                            String badgeClass = "badge-upcoming";
                            if ("COMPLETED".equalsIgnoreCase(evtStatus)) badgeClass = "badge-completed";
                            else if ("EXPIRED".equalsIgnoreCase(evtStatus)) badgeClass = "badge-expired";
                %>
                    <tr>
                        <td>
                            <a href="${pageContext.request.contextPath}/event-detail?id=<%= e.getId() %>" style="font-weight:600;color:var(--primary);text-decoration:none;"><%= e.getTitle() %></a>
                            <div style="font-size:0.82rem;color:var(--text-muted);max-width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"><%= e.getDescription() %></div>
                        </td>
                        <td><%= e.getDate() %></td>
                        <td><%= e.getType() %></td>
                        <td><span class="badge <%= badgeClass %>"><%= evtStatus %></span></td>
                        <td>
                            <% if (canCancel) { %>
                                <a class="action-link action-link-danger" href="${pageContext.request.contextPath}/cancel-reservation?eventId=<%= e.getId() %>">Cancel</a>
                            <% } else { %>
                                <span style="color:var(--text-muted);font-size:0.82rem;">-</span>
                            <% } %>
                        </td>
                        <td>
                            <% if (canRate) { %>
                            <form action="${pageContext.request.contextPath}/rate-event" method="post" style="display:flex;align-items:center;gap:0.4rem;">
                                <input type="hidden" name="eventId" value="<%= e.getId() %>">
                                <select name="rating" style="max-width:60px;padding:0.3rem;">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                                <input type="text" name="comment" placeholder="Comment" style="max-width:120px;padding:0.3rem 0.5rem;">
                                <button type="submit" style="padding:0.3rem 0.7rem;font-size:0.78rem;">Rate</button>
                            </form>
                            <% } else if (ratingDAO.hasRated(user.getId(), e.getId())) { %>
                                <span class="badge badge-open">Rated</span>
                            <% } else { %>
                                <span style="color:var(--text-muted);font-size:0.82rem;">-</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>

            <% if (events == null || events.isEmpty()) { %>
            <div style="text-align:center;padding:3rem 2rem;color:var(--text-muted);">
                <p>No reservations yet</p>
            </div>
            <% } %>
        </div>

        <div class="card-footer">
            <a class="back-link" href="${pageContext.request.contextPath}/student/home">Back to Dashboard</a>
        </div>
    </div>
</div>

</body>
</html>