<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Home</title>
</head>
<body>
<h2>Welcome Student, ${user.fullName}</h2>
<a href="${pageContext.request.contextPath}/views/profile.jsp">
    My Profile
</a>

<a href="${pageContext.request.contextPath}/events">Browse Events</a><br><br>
<a href="${pageContext.request.contextPath}/my-reservations">My Reservations</a><br><br>
<a href="${pageContext.request.contextPath}/logout">Logout</a>
</body>
</html>