<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>

<h2>Welcome, ${user.fullName}</h2>
<p>Role: ${user.role}</p>
<a href="${pageContext.request.contextPath}/views/profile.jsp">
    My Profile
</a>
<br><br>
<a href="${pageContext.request.contextPath}/events">View Events</a>

<a href="${pageContext.request.contextPath}/logout">Logout</a>

</body>
</html>