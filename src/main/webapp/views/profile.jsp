<%@ page contentType="text/html;charset=UTF-8" %>

<%
    com.campus.eventsystem.model.User user =
            (com.campus.eventsystem.model.User) session.getAttribute("loggedUser");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<html>
<head>
    <title>Profile</title>
</head>
<body>

<h2>My Profile</h2>

<form action="${pageContext.request.contextPath}/update-profile" method="post">

    Name:
    <input type="text" name="name" value="<%= user.getFullName() %>"><br><br>

    Email:
    <input type="email" name="email" value="<%= user.getEmail() %>"><br><br>

    Faculty:
    <input type="text" name="faculty" value="<%= user.getFaculty() %>"><br><br>

    Department:
    <input type="text" name="department" value="<%= user.getDepartment() %>"><br><br>

    Year:
    <input type="number" name="year" value="<%= user.getAdmissionYear() %>"><br><br>

    <button type="submit">Update</button>

</form>

</body>
</html>