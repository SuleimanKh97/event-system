<%@ page contentType="text/html;charset=UTF-8" %>

<%
    com.campus.eventsystem.model.User user =
            (com.campus.eventsystem.model.User) session.getAttribute("loggedUser");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>My Profile</h1>
        <p>Update your personal information</p>
    </div>
</div>

<div class="container">
    <div class="form-card">
        <form action="${pageContext.request.contextPath}/update-profile" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" value="<%= user.getFullName() %>">
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= user.getEmail() %>">
            </div>

            <div class="form-group">
                <label>Faculty</label>
                <input type="text" name="faculty" value="<%= user.getFaculty() %>">
            </div>

            <div class="form-group">
                <label>Department</label>
                <input type="text" name="department" value="<%= user.getDepartment() %>">
            </div>

            <div class="form-group">
                <label>Admission Year</label>
                <input type="number" name="year" value="<%= user.getAdmissionYear() %>">
            </div>

            <button type="submit">Update Profile</button>
        </form>
    </div>

    <div style="margin-top:1rem;">
        <% String role = user.getRole(); %>
        <% if ("student".equalsIgnoreCase(role)) { %>
            <a class="back-link" href="${pageContext.request.contextPath}/student/home">Back to Dashboard</a>
        <% } else if ("organizer".equalsIgnoreCase(role)) { %>
            <a class="back-link" href="${pageContext.request.contextPath}/organizer/home">Back to Dashboard</a>
        <% } else if ("admin".equalsIgnoreCase(role)) { %>
            <a class="back-link" href="${pageContext.request.contextPath}/admin/home">Back to Dashboard</a>
        <% } %>
    </div>
</div>

</body>
</html>