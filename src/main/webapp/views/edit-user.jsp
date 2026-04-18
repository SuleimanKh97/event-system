<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit User</title>
</head>
<body>

<h2>Edit User</h2>

<form action="${pageContext.request.contextPath}/edit-user" method="post">
    <input type="hidden" name="id" value="${user.id}">

    Full Name:
    <input type="text" name="fullName" value="${user.fullName}">
    <br><br>

    Email:
    <input type="email" name="email" value="${user.email}">
    <br><br>

    Password:
    <input type="text" name="password" value="${user.password}">
    <br><br>

    Role:
    <select name="role">
        <option value="student" ${user.role == 'student' ? 'selected' : ''}>student</option>
        <option value="organizer" ${user.role == 'organizer' ? 'selected' : ''}>organizer</option>
        <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>admin</option>
    </select>
    <br><br>

    <button type="submit">Update User</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/users">Back</a>

</body>
</html>