<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Map<String, Object>> attendees = (List<Map<String, Object>>) request.getAttribute("attendees");
    Integer eventId = (Integer) request.getAttribute("eventId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Attendees</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Event Attendees</h1>
        <p>Manage attendance for this event</p>
    </div>
</div>

<div class="container">
    <div class="table-card">
        <div class="table-scroll">
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Attendance</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (attendees != null && !attendees.isEmpty()) {
                        for (Map<String, Object> a : attendees) {
                            int userId = (Integer) a.get("userId");
                            String fullName = (String) a.get("fullName");
                            String email = (String) a.get("email");
                            String attendance = (String) a.get("attendanceStatus");
                            String attendBadge = "PRESENT".equalsIgnoreCase(attendance) ? "badge-present" : "badge-absent";
                %>
                    <tr>
                        <td style="font-weight:600;"><%= fullName %></td>
                        <td><%= email %></td>
                        <td><span class="badge <%= attendBadge %>"><%= attendance %></span></td>
                        <td>
                            <% if ("ABSENT".equalsIgnoreCase(attendance)) { %>
                                <a class="action-link action-link-success"
                                   href="${pageContext.request.contextPath}/mark-attendance?userId=<%= userId %>&eventId=<%= eventId %>&status=PRESENT">
                                    Mark Present
                                </a>
                            <% } else { %>
                                <a class="action-link action-link-warning"
                                   href="${pageContext.request.contextPath}/mark-attendance?userId=<%= userId %>&eventId=<%= eventId %>&status=ABSENT">
                                    Mark Absent
                                </a>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>

            <% if (attendees == null || attendees.isEmpty()) { %>
            <div style="text-align:center;padding:3rem 2rem;color:var(--text-muted);">
                <p>No attendees yet</p>
            </div>
            <% } %>
        </div>

        <div class="card-footer">
            <a class="back-link" href="${pageContext.request.contextPath}/events">Back to Events</a>
        </div>
    </div>
</div>

</body>
</html>
