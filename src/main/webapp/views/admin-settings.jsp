<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<%
    List<String> departments = (List<String>) request.getAttribute("departments");
    List<String> categories = (List<String>) request.getAttribute("categories");
%>

<html>
<head>
    <title>Admin Settings</title>
</head>
<body>

<h2>Manage Departments & Categories</h2>

<!-- Departments Section -->
<h3>Departments</h3>

<form action="${pageContext.request.contextPath}/admin/settings" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="table" value="departments">
    <input type="text" name="name" placeholder="New department name" required>
    <button type="submit">Add Department</button>
</form>

<ul>
<%
    if (departments != null) {
        for (String d : departments) {
%>
    <li><%= d %></li>
<%
        }
    }
%>
</ul>

<hr>

<!-- Categories Section -->
<h3>Event Categories</h3>

<form action="${pageContext.request.contextPath}/admin/settings" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="table" value="categories">
    <input type="text" name="name" placeholder="New category name" required>
    <button type="submit">Add Category</button>
</form>

<ul>
<%
    if (categories != null) {
        for (String c : categories) {
%>
    <li><%= c %></li>
<%
        }
    }
%>
</ul>

<br>
<a href="${pageContext.request.contextPath}/admin/home">Back</a>

</body>
</html>
