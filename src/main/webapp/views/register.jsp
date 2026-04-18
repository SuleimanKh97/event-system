<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>Register</title>
</head>
<body>

<h2>Register</h2>

<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<p style="color:red;"><%= error %></p>
<% } %>

<form action="${pageContext.request.contextPath}/register" method="post">

    Name: <input type="text" name="name" required><br><br>

    Email: <input type="email" name="email" required><br><br>

    Password: <input type="password" name="password" required><br><br>

    Faculty: <input type="text" name="faculty" required><br><br>

    Department: <input type="text" name="department" required><br><br>

    Admission Year: <input type="number" name="year" required><br><br>

    <button type="submit">Register</button>

</form>
<br>
<a href="${pageContext.request.contextPath}/login">Already have an account? Login</a>

</body>
</html>