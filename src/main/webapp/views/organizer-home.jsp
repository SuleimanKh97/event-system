<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Organizer Home</title>
</head>
<body>
<h2>Welcome Organizer, ${user.fullName}</h2>
<a href="${pageContext.request.contextPath}/views/profile.jsp">My Profile</a><br><br>

<a href="${pageContext.request.contextPath}/add-event">Create Event</a><br><br>
<a href="${pageContext.request.contextPath}/events">Manage Events</a><br><br>
<a href="${pageContext.request.contextPath}/logout">Logout</a>
</body>
</html>