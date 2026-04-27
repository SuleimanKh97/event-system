<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Welcome, ${user.fullName}</h1>
        <p>Student Dashboard</p>
    </div>
</div>

<div class="container">
    <div class="dash-grid">
        <a class="dash-card" href="${pageContext.request.contextPath}/events">
            <div class="dash-icon dash-icon-purple">E</div>
            <div>
                <div class="dash-label">Browse Events</div>
                <div class="dash-desc">Discover campus events</div>
            </div>
        </a>

        <a class="dash-card" href="${pageContext.request.contextPath}/my-reservations">
            <div class="dash-icon dash-icon-blue">R</div>
            <div>
                <div class="dash-label">My Reservations</div>
                <div class="dash-desc">View your booked events</div>
            </div>
        </a>

        <a class="dash-card" href="${pageContext.request.contextPath}/views/profile.jsp">
            <div class="dash-icon dash-icon-green">P</div>
            <div>
                <div class="dash-label">My Profile</div>
                <div class="dash-desc">Update your information</div>
            </div>
        </a>

        <a class="dash-card" href="${pageContext.request.contextPath}/logout">
            <div class="dash-icon dash-icon-red">L</div>
            <div>
                <div class="dash-label">Logout</div>
                <div class="dash-desc">Sign out of your account</div>
            </div>
        </a>
    </div>
</div>

</body>
</html>