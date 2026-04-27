<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Edit User</h1>
        <p>Update user account details</p>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/edit-user" method="post">
            <input type="hidden" name="id" value="${user.id}">

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="${user.fullName}">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="${user.email}">
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="text" name="password" value="${user.password}">
            </div>

            <div class="form-group">
                <label>Role</label>
                <select name="role">
                    <option value="student" ${user.role == 'student' ? 'selected' : ''}>student</option>
                    <option value="organizer" ${user.role == 'organizer' ? 'selected' : ''}>organizer</option>
                    <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>admin</option>
                </select>
            </div>

            <button type="submit">Update User</button>
        </form>
    </div>

    <div style="margin-top:1rem;">
        <a class="back-link" href="${pageContext.request.contextPath}/users">Back to Users</a>
    </div>
</div>

</body>
</html>