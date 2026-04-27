<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.campus.eventsystem.model.Event" %>
<%@ page import="com.campus.eventsystem.model.User" %>

<%
    Event event = (Event) request.getAttribute("event");
    double avgRating = (Double) request.getAttribute("avgRating");
    int ratingCount = (Integer) request.getAttribute("ratingCount");
    int attendeesCount = (Integer) request.getAttribute("attendeesCount");

    User user = (User) session.getAttribute("loggedUser");
    boolean loggedIn = (user != null);

    String regStatus = event.getRegistrationStatus() != null ? event.getRegistrationStatus() : "";
    String evtStatus = event.getEventStatus() != null ? event.getEventStatus() : "";
    boolean canReserve = "OPEN".equalsIgnoreCase(regStatus) && "UPCOMING".equalsIgnoreCase(evtStatus) && event.getCapacity() > 0;

    // Build star display
    int fullStars = (int) avgRating;
    boolean halfStar = (avgRating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= event.getTitle() %> - Campus Event System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-hover: #4338CA;
            --accent: #8B5CF6;
            --success: #10B981;
            --warning: #F59E0B;
            --danger: #EF4444;
            --bg: #F0F2F5;
            --surface: #FFFFFF;
            --text-main: #1E293B;
            --text-muted: #64748B;
            --text-light: #94A3B8;
            --border: #E2E8F0;
            --star-filled: #F59E0B;
            --star-empty: #D1D5DB;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.08);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.1);
            --shadow-lg: 0 10px 40px rgba(0,0,0,0.12);
            --radius: 16px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text-main);
            line-height: 1.6;
            min-height: 100vh;
        }

        /* ─── Hero Banner ──────────────────────────── */
        .hero {
            background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 50%, #EC4899 100%);
            padding: 3rem 2rem 4rem;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50%; left: -50%;
            width: 200%; height: 200%;
            background: radial-gradient(circle at 30% 70%, rgba(255,255,255,0.08) 0%, transparent 60%);
            animation: shimmer 10s infinite alternate;
        }

        @keyframes shimmer {
            from { transform: rotate(0deg); }
            to { transform: rotate(10deg); }
        }

        .hero-content {
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            transition: var(--transition);
        }
        .back-link:hover { color: #fff; }

        .hero h1 {
            color: #fff;
            font-size: clamp(2rem, 5vw, 3rem);
            font-weight: 800;
            margin-bottom: 1rem;
            line-height: 1.1;
        }

        .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            color: rgba(255,255,255,0.85);
            font-size: 0.95rem;
        }

        .hero-meta span {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        /* ─── Main Layout ──────────────────────────── */
        .page-container {
            max-width: 900px;
            margin: -2rem auto 3rem;
            padding: 0 1.5rem;
            position: relative;
            z-index: 2;
        }

        /* ─── Card ─────────────────────────────────── */
        .card {
            background: var(--surface);
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: fadeUp 0.5s ease-out;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ─── Event Image ──────────────────────────── */
        .event-image-section {
            width: 100%;
            max-height: 350px;
            overflow: hidden;
            background: linear-gradient(135deg, #E0E7FF, #EDE9FE);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .event-image-section img {
            width: 100%;
            height: 350px;
            object-fit: cover;
        }

        .event-image-placeholder {
            padding: 4rem;
            text-align: center;
            color: var(--text-light);
            font-size: 3rem;
        }

        /* ─── Content ──────────────────────────────── */
        .event-body {
            padding: 2.5rem;
        }

        .section-title {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1rem;
            color: var(--primary);
            margin-bottom: 0.75rem;
        }

        .event-description {
            font-size: 1.05rem;
            color: var(--text-main);
            line-height: 1.8;
            margin-bottom: 2.5rem;
        }

        /* ─── Info Grid ────────────────────────────── */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2.5rem;
        }

        .info-item {
            background: #F8FAFC;
            border-radius: 12px;
            padding: 1.25rem;
            border: 1px solid var(--border);
            transition: var(--transition);
        }

        .info-item:hover {
            border-color: var(--primary);
            box-shadow: 0 2px 8px rgba(79, 70, 229, 0.08);
            transform: translateY(-2px);
        }

        .info-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05rem;
            color: var(--text-muted);
            margin-bottom: 0.35rem;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-main);
        }

        /* ─── Status Badges ────────────────────────── */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.3rem 0.8rem;
            border-radius: 100px;
            font-size: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.02rem;
        }

        .badge-open { background: #D1FAE5; color: #065F46; }
        .badge-closed { background: #FEE2E2; color: #991B1B; }
        .badge-upcoming { background: #DBEAFE; color: #1E40AF; }
        .badge-completed { background: #E0E7FF; color: #3730A3; }
        .badge-expired { background: #F3F4F6; color: #6B7280; }

        /* ─── Rating Section ───────────────────────── */
        .rating-section {
            background: linear-gradient(135deg, #FEF3C7, #FFFBEB);
            border: 1px solid #FDE68A;
            border-radius: 12px;
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .rating-score {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--text-main);
            line-height: 1;
        }

        .rating-details {
            flex: 1;
        }

        .stars {
            display: flex;
            gap: 3px;
            margin-bottom: 0.25rem;
        }

        .star {
            font-size: 1.3rem;
        }

        .star-filled { color: var(--star-filled); }
        .star-half { color: var(--star-filled); }
        .star-empty { color: var(--star-empty); }

        .rating-count {
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        /* ─── CTA Section ──────────────────────────── */
        .cta-section {
            border-top: 1px solid var(--border);
            padding: 2rem 2.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            background: #FAFBFC;
        }

        .cta-info {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        .cta-info strong {
            color: var(--text-main);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.9rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            color: #fff;
            box-shadow: 0 4px 14px rgba(79, 70, 229, 0.35);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.45);
        }

        .btn-disabled {
            background: #E2E8F0;
            color: #94A3B8;
            cursor: not-allowed;
        }

        .btn-outline {
            background: transparent;
            color: var(--primary);
            border: 2px solid var(--primary);
        }

        .btn-outline:hover {
            background: var(--primary);
            color: #fff;
        }

        /* ─── Responsive ───────────────────────────── */
        @media (max-width: 640px) {
            .hero { padding: 2rem 1.5rem 3rem; }
            .hero-meta { flex-direction: column; gap: 0.5rem; }
            .event-body { padding: 1.5rem; }
            .cta-section { padding: 1.5rem; flex-direction: column; text-align: center; }
            .rating-section { flex-direction: column; text-align: center; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- Hero -->
<div class="hero">
    <div class="hero-content">
        <a href="${pageContext.request.contextPath}/events" class="back-link">
            &#8592; All Events
        </a>
        <h1><%= event.getTitle() %></h1>
        <div class="hero-meta">
            <span>&#128197; <%= event.getDate() %></span>
            <% if (event.getEventTime() != null && !event.getEventTime().isEmpty()) { %>
                <span>&#128336; <%= event.getEventTime() %></span>
            <% } %>
            <% if (event.getLocation() != null && !event.getLocation().isEmpty()) { %>
                <span>&#128205; <%= event.getLocation() %></span>
            <% } %>
            <% if (event.getOrganizerName() != null && !event.getOrganizerName().isEmpty()) { %>
                <span>&#128100; <%= event.getOrganizerName() %></span>
            <% } %>
        </div>
    </div>
</div>

<!-- Content -->
<div class="page-container">
    <div class="card">

        <!-- Event Image -->
        <div class="event-image-section">
            <% if (event.getImagePath() != null && !event.getImagePath().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= event.getImagePath() %>" alt="<%= event.getTitle() %>">
            <% } else { %>
                <div class="event-image-placeholder">&#127915;</div>
            <% } %>
        </div>

        <div class="event-body">

            <!-- Rating -->
            <div class="rating-section">
                <div class="rating-score">
                    <%= String.format("%.1f", avgRating) %>
                </div>
                <div class="rating-details">
                    <div class="stars">
                        <% for (int i = 0; i < fullStars; i++) { %>
                            <span class="star star-filled">&#9733;</span>
                        <% } %>
                        <% if (halfStar) { %>
                            <span class="star star-half">&#9733;</span>
                        <% } %>
                        <% for (int i = 0; i < emptyStars; i++) { %>
                            <span class="star star-empty">&#9733;</span>
                        <% } %>
                    </div>
                    <div class="rating-count">
                        <% if (ratingCount > 0) { %>
                            Based on <strong><%= ratingCount %></strong> review<%= ratingCount > 1 ? "s" : "" %>
                        <% } else { %>
                            No ratings yet
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="section-title">About this event</div>
            <div class="event-description">
                <%= event.getDescription() != null ? event.getDescription() : "No description available." %>
            </div>

            <!-- Details Grid -->
            <div class="section-title">Event Details</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Date</div>
                    <div class="info-value"><%= event.getDate() %></div>
                </div>
                <% if (event.getEventTime() != null && !event.getEventTime().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label">Time</div>
                    <div class="info-value"><%= event.getEventTime() %></div>
                </div>
                <% } %>
                <% if (event.getLocation() != null && !event.getLocation().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label">Location</div>
                    <div class="info-value"><%= event.getLocation() %></div>
                </div>
                <% } %>
                <% if (event.getDepartmentClub() != null && !event.getDepartmentClub().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label">Department / Club</div>
                    <div class="info-value"><%= event.getDepartmentClub() %></div>
                </div>
                <% } %>
                <% if (event.getType() != null && !event.getType().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label">Type</div>
                    <div class="info-value"><%= event.getType() %></div>
                </div>
                <% } %>
                <% if (event.getCategory() != null && !event.getCategory().isEmpty()) { %>
                <div class="info-item">
                    <div class="info-label">Category</div>
                    <div class="info-value"><%= event.getCategory() %></div>
                </div>
                <% } %>
                <div class="info-item">
                    <div class="info-label">Available Seats</div>
                    <div class="info-value"><%= event.getCapacity() %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Registered</div>
                    <div class="info-value"><%= attendeesCount %> attendee<%= attendeesCount != 1 ? "s" : "" %></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Registration</div>
                    <div class="info-value">
                        <span class="badge <%= "OPEN".equalsIgnoreCase(regStatus) ? "badge-open" : "badge-closed" %>">
                            <%= regStatus.isEmpty() ? "N/A" : regStatus %>
                        </span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Event Status</div>
                    <div class="info-value">
                        <%
                            String badgeClass = "badge-upcoming";
                            if ("COMPLETED".equalsIgnoreCase(evtStatus)) badgeClass = "badge-completed";
                            else if ("EXPIRED".equalsIgnoreCase(evtStatus)) badgeClass = "badge-expired";
                        %>
                        <span class="badge <%= badgeClass %>">
                            <%= evtStatus.isEmpty() ? "N/A" : evtStatus %>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- CTA -->
        <div class="cta-section">
            <div class="cta-info">
                <% if (canReserve) { %>
                    <strong><%= event.getCapacity() %></strong> seats remaining &mdash; Registration is <strong>open</strong>
                <% } else if ("COMPLETED".equalsIgnoreCase(evtStatus)) { %>
                    This event has been <strong>completed</strong>
                <% } else if ("EXPIRED".equalsIgnoreCase(evtStatus)) { %>
                    This event has <strong>expired</strong>
                <% } else if ("CLOSED".equalsIgnoreCase(regStatus)) { %>
                    Registration is <strong>closed</strong>
                <% } else { %>
                    No seats available
                <% } %>
            </div>

            <% if (canReserve) { %>
                <% if (loggedIn && "student".equalsIgnoreCase(user.getRole())) { %>
                    <form action="${pageContext.request.contextPath}/reserve" method="post" style="margin:0;padding:0;background:none;box-shadow:none;">
                        <input type="hidden" name="eventId" value="<%= event.getId() %>">
                        <button type="submit" class="btn btn-primary">&#127919; Join This Event</button>
                    </form>
                <% } else if (!loggedIn) { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">&#128274; Login to Join</a>
                <% } else { %>
                    <span class="btn btn-disabled">Not Available</span>
                <% } %>
            <% } else { %>
                <span class="btn btn-disabled">Registration Unavailable</span>
            <% } %>
        </div>

    </div>
</div>

</body>
</html>
