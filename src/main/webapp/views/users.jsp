<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.campus.eventsystem.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Manage Users</h1>
        <p>View, edit roles, and manage user accounts</p>
    </div>
</div>

<div class="container">
    <div class="table-card">
        <div class="table-scroll">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Change Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null) {
                        for (User u : users) {
                            String roleBadge = "badge-student";
                            if ("organizer".equalsIgnoreCase(u.getRole())) roleBadge = "badge-organizer";
                            else if ("admin".equalsIgnoreCase(u.getRole())) roleBadge = "badge-admin";
                %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td style="font-weight:600;"><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge <%= roleBadge %>"><%= u.getRole() %></span></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/update-user-role" method="post" style="display:flex;align-items:center;gap:0.4rem;">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <select name="role" style="max-width:120px;padding:0.3rem;">
                                    <option value="student">student</option>
                                    <option value="organizer">organizer</option>
                                    <option value="admin">admin</option>
                                </select>
                                <button type="submit" style="padding:0.3rem 0.7rem;font-size:0.78rem;">Update</button>
                            </form>
                        </td>
                        <td>
                            <div style="display:flex;gap:0.35rem;flex-wrap:wrap;">
                                <a class="action-link action-link-primary" href="${pageContext.request.contextPath}/edit-user?id=<%= u.getId() %>">Edit</a>
                                <a class="action-link action-link-danger" href="${pageContext.request.contextPath}/delete-user?id=<%= u.getId() %>">Delete</a>
                                <a class="action-link action-link-warning" href="${pageContext.request.contextPath}/toggle-user?id=<%= u.getId() %>">
                                    <%= u.isBlocked() ? "Unblock" : "Block" %>
                                </a>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>

        <div class="card-footer">
            <a class="back-link" href="${pageContext.request.contextPath}/admin/home">Back to Dashboard</a>
        </div>
    </div>
</div>

</body>
</html>