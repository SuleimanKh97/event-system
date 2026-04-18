<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Add Event</title>
</head>
<body>

<h2>Add Event</h2>

<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<p style="color:red;"><%= error %></p>
<% } %>

<form action="${pageContext.request.contextPath}/add-event" method="post" enctype="multipart/form-data">

    Type:
    <select name="type">
        <option value="workshop">Workshop</option>
        <option value="seminar">Seminar</option>
        <option value="clubsocial">Club Social Event</option>
        <option value="sports">Sports Activity</option>
    </select>
    <br><br>

    Title: <input type="text" name="title" required><br><br>
    Organizer Name: <input type="text" name="organizerName" required><br><br>
    Description: <textarea name="description" rows="3" cols="40" required></textarea><br><br>
    Department/Club: <input type="text" name="departmentClub"><br><br>
    Date: <input type="date" name="date" required><br><br>
    Time: <input type="time" name="eventTime"><br><br>
    Location: <input type="text" name="location"><br><br>
    Capacity: <input type="number" name="capacity" min="1" required><br><br>

    Category:
    <select name="category">
        <option value="Educational">Educational</option>
        <option value="Social">Social</option>
        <option value="Sports">Sports</option>
        <option value="Cultural">Cultural</option>
        <option value="Technical">Technical</option>
    </select>
    <br><br>

    Event Image (max 5MB): <input type="file" name="eventImage" accept="image/*"><br><br>

    <button type="submit">Add Event</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/events">Back to Events</a>

</body>
</html>