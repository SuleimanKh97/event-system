<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    List<Map<String, Object>> attendees = (List<Map<String, Object>>) request.getAttribute("attendees");
    Integer eventId = (Integer) request.getAttribute("eventId");
%>

<html>
<head>
    <title>Event Attendees</title>
</head>
<body>

<h2>Event Attendees</h2>

<table border="1">
    <tr>
        <th>Student Name</th>
        <th>Email</th>
        <th>Attendance</th>
        <th>Action</th>
    </tr>

    <%
        if (attendees != null) {
            for (Map<String, Object> a : attendees) {
                int userId = (Integer) a.get("userId");
                String fullName = (String) a.get("fullName");
                String email = (String) a.get("email");
                String attendance = (String) a.get("attendanceStatus");
    %>
    <tr>
        <td><%= fullName %></td>
        <td><%= email %></td>
        <td><%= attendance %></td>
        <td>
            <% if ("ABSENT".equalsIgnoreCase(attendance)) { %>
            <a href="${pageContext.request.contextPath}/mark-attendance?userId=<%= userId %>&eventId=<%= eventId %>&status=PRESENT">
                Mark Present
            </a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/mark-attendance?userId=<%= userId %>&eventId=<%= eventId %>&status=ABSENT">
                Mark Absent
            </a>
            <% } %>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>

<br>
<a href="${pageContext.request.contextPath}/events">Back to Events</a>

</body>
</html>
