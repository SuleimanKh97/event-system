<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.eventsystem.model.User" %>

<html>
<head>
    <title>Manage Users</title>
</head>
<body>

<h2>Manage Users</h2>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Role</th>
        <th>Change Role</th>
        <th>Delete</th>
        <th>Edit</th>
    </tr>

    <%
        List<User> users = (List<User>) request.getAttribute("users");
        if (users != null) {
            for (User u : users) {
    %>
    <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getFullName() %></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getRole() %></td>
        <td>
            <form action="${pageContext.request.contextPath}/update-user-role" method="post">
                <input type="hidden" name="id" value="<%= u.getId() %>">
                <select name="role">
                    <option value="student">student</option>
                    <option value="organizer">organizer</option>
                    <option value="admin">admin</option>
                </select>
                <button type="submit">Update</button>
            </form>
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/delete-user?id=<%= u.getId() %>">Delete</a>
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/edit-user?id=<%= u.getId() %>">Edit</a>
        </td>
        <td>
            <a href="${pageContext.request.contextPath}/toggle-user?id=<%= u.getId() %>">
                <%= u.isBlocked() ? "Unblock" : "Block" %>
            </a>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>

<br>
<a href="${pageContext.request.contextPath}/admin/home">Back</a>

</body>
</html>