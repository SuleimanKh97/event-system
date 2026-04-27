<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>

<%
    List<String> departments = (List<String>) request.getAttribute("departments");
    List<String> categories = (List<String>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Settings</h1>
        <p>Manage departments and event categories</p>
    </div>
</div>

<div class="container">
    <!-- Departments -->
    <div class="card" style="margin-bottom:1.5rem;">
        <div class="card-body">
            <h3>Departments</h3>

            <form action="${pageContext.request.contextPath}/admin/settings" method="post" style="display:flex;gap:0.5rem;align-items:center;margin-bottom:1.25rem;flex-wrap:wrap;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="table" value="departments">
                <input type="text" name="name" placeholder="New department name" required style="flex:1;min-width:200px;">
                <button type="submit">Add Department</button>
            </form>

            <ul class="settings-list">
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

            <% if (departments == null || departments.isEmpty()) { %>
                <p style="color:var(--text-muted);font-size:0.9rem;">No departments added yet</p>
            <% } %>
        </div>
    </div>

    <!-- Categories -->
    <div class="card">
        <div class="card-body">
            <h3>Event Categories</h3>

            <form action="${pageContext.request.contextPath}/admin/settings" method="post" style="display:flex;gap:0.5rem;align-items:center;margin-bottom:1.25rem;flex-wrap:wrap;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="table" value="categories">
                <input type="text" name="name" placeholder="New category name" required style="flex:1;min-width:200px;">
                <button type="submit">Add Category</button>
            </form>

            <ul class="settings-list">
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

            <% if (categories == null || categories.isEmpty()) { %>
                <p style="color:var(--text-muted);font-size:0.9rem;">No categories added yet</p>
            <% } %>
        </div>
    </div>

    <div style="margin-top:1.5rem;">
        <a class="back-link" href="${pageContext.request.contextPath}/admin/home">Back to Dashboard</a>
    </div>
</div>

</body>
</html>
