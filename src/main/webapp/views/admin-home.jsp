<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Home</title>
</head>
<body>
<h2>Welcome Admin, ${loggedUser.fullName}</h2>
<a href="${pageContext.request.contextPath}/views/profile.jsp">My Profile</a><br><br>

<a href="${pageContext.request.contextPath}/users">Manage Users</a><br><br>
<a href="${pageContext.request.contextPath}/events">Manage Events</a><br><br>
<a href="${pageContext.request.contextPath}/admin/settings">Manage Departments & Categories</a><br><br>
<a href="${pageContext.request.contextPath}/logout">Logout</a>
</body>
</html>