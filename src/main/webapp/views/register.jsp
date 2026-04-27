<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Campus Event System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">
        <h2>Create Account</h2>
        <p class="auth-subtitle">Join the Campus Event System</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error-msg"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="Your full name" required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Choose a password" required>
            </div>

            <div class="form-group">
                <label>Faculty</label>
                <input type="text" name="faculty" placeholder="e.g. Engineering" required>
            </div>

            <div class="form-group">
                <label>Department</label>
                <input type="text" name="department" placeholder="e.g. Computer Science" required>
            </div>

            <div class="form-group">
                <label>Admission Year</label>
                <input type="number" name="year" placeholder="e.g. 2023" required>
            </div>

            <button type="submit" style="width:100%; margin-top:0.5rem;">Create Account</button>
        </form>

        <div class="auth-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign In</a>
        </div>
    </div>
</div>

</body>
</html>