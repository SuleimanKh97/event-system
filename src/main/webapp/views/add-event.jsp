<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Create New Event</h1>
        <p>Fill in the details to add a new campus event</p>
    </div>
</div>

<div class="container">
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error-msg"><%= error %></div>
    <% } %>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/add-event" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>Event Type</label>
                <select name="type">
                    <option value="workshop">Workshop</option>
                    <option value="seminar">Seminar</option>
                    <option value="clubsocial">Club Social Event</option>
                    <option value="sports">Sports Activity</option>
                </select>
            </div>

            <div class="form-group">
                <label>Title</label>
                <input type="text" name="title" placeholder="Event title" required>
            </div>

            <div class="form-group">
                <label>Organizer Name</label>
                <input type="text" name="organizerName" placeholder="Who is organizing?" required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" rows="3" placeholder="Describe the event..." required></textarea>
            </div>

            <div class="form-group">
                <label>Department / Club</label>
                <input type="text" name="departmentClub" placeholder="e.g. CS Club">
            </div>

            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" required>
            </div>

            <div class="form-group">
                <label>Time</label>
                <input type="time" name="eventTime">
            </div>

            <div class="form-group">
                <label>Location</label>
                <input type="text" name="location" placeholder="e.g. Hall A">
            </div>

            <div class="form-group">
                <label>Capacity</label>
                <input type="number" name="capacity" min="1" placeholder="Max attendees" required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="category">
                    <option value="Educational">Educational</option>
                    <option value="Social">Social</option>
                    <option value="Sports">Sports</option>
                    <option value="Cultural">Cultural</option>
                    <option value="Technical">Technical</option>
                </select>
            </div>

            <div class="form-group">
                <label>Event Image (max 5MB)</label>
                <input type="file" name="eventImage" accept="image/*">
            </div>

            <button type="submit">Create Event</button>
        </form>
    </div>

    <div style="margin-top:1rem;">
        <a class="back-link" href="${pageContext.request.contextPath}/events">Back to Events</a>
    </div>
</div>

</body>
</html>