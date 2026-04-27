<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.campus.eventsystem.model.Event" %>
            <%@ page import="com.campus.eventsystem.model.User" %>

                <% User user=(User) session.getAttribute("loggedUser"); List<Event> events = (List<Event>)
                        request.getAttribute("events");
                        String role = (user != null) ? user.getRole() : "";
                        boolean isOrganizer = "organizer".equalsIgnoreCase(role);
                        boolean isAdmin = "admin".equalsIgnoreCase(role);
                        boolean canManage = isOrganizer || isAdmin;
                        %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Events - Campus Event System</title>
                            <link rel="preconnect" href="https://fonts.googleapis.com">
                            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
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
                                    --border: #E2E8F0;
                                    --shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
                                    --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.1);
                                    --radius: 12px;
                                    --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
                                }

                                * {
                                    margin: 0;
                                    padding: 0;
                                    box-sizing: border-box;
                                }

                                body {
                                    font-family: 'Inter', sans-serif;
                                    background: var(--bg);
                                    color: var(--text-main);
                                    line-height: 1.6;
                                    min-height: 100vh;
                                }

                                /* ─── Page Header ──────────────────────────── */
                                .page-header {
                                    background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
                                    padding: 2rem 2rem 3rem;
                                }

                                .page-header-inner {
                                    max-width: 1200px;
                                    margin: 0 auto;
                                }

                                .page-header h1 {
                                    color: #fff;
                                    font-size: 2rem;
                                    font-weight: 700;
                                    margin-bottom: 0.25rem;
                                }

                                .page-header p {
                                    color: rgba(255, 255, 255, 0.7);
                                    font-size: 0.95rem;
                                }

                                /* ─── Container ────────────────────────────── */
                                .container {
                                    max-width: 1400px;
                                    margin: -1.5rem auto 2rem;
                                    padding: 0 1.5rem;
                                }

                                /* ─── Search Card ──────────────────────────── */
                                .search-card {
                                    background: var(--surface);
                                    border-radius: var(--radius);
                                    box-shadow: var(--shadow-md);
                                    padding: 1.25rem 1.5rem;
                                    margin-bottom: 1.5rem;
                                    display: flex;
                                    align-items: center;
                                    gap: 0.75rem;
                                    flex-wrap: wrap;
                                }

                                .search-card input[type="text"] {
                                    flex: 1;
                                    min-width: 200px;
                                    padding: 0.65rem 1rem;
                                    border: 1px solid var(--border);
                                    border-radius: 8px;
                                    font-size: 0.9rem;
                                    font-family: inherit;
                                    transition: var(--transition);
                                    background: #F8FAFC;
                                }

                                .search-card input[type="text"]:focus {
                                    outline: none;
                                    border-color: var(--primary);
                                    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                                }

                                .search-card select {
                                    padding: 0.65rem 1rem;
                                    border: 1px solid var(--border);
                                    border-radius: 8px;
                                    font-size: 0.9rem;
                                    font-family: inherit;
                                    background: #F8FAFC;
                                    cursor: pointer;
                                    transition: var(--transition);
                                }

                                .search-card select:focus {
                                    outline: none;
                                    border-color: var(--primary);
                                }

                                .search-card button {
                                    padding: 0.65rem 1.5rem;
                                    background: var(--primary);
                                    color: #fff;
                                    border: none;
                                    border-radius: 8px;
                                    font-weight: 600;
                                    font-size: 0.9rem;
                                    cursor: pointer;
                                    transition: var(--transition);
                                }

                                .search-card button:hover {
                                    background: var(--primary-hover);
                                    transform: translateY(-1px);
                                }

                                /* ─── Table Wrapper ────────────────────────── */
                                .table-card {
                                    background: var(--surface);
                                    border-radius: var(--radius);
                                    box-shadow: var(--shadow-md);
                                    overflow: hidden;
                                }

                                .table-scroll {
                                    overflow-x: auto;
                                    overflow-y: hidden;
                                    -webkit-overflow-scrolling: touch;
                                }

                                /* Top scrollbar mirror */
                                .table-scroll-top {
                                    overflow-x: auto;
                                    overflow-y: hidden;
                                    height: 18px;
                                    margin-bottom: -1px;
                                }

                                .table-scroll-top-inner {
                                    height: 1px;
                                }

                                table {
                                    width: 100%;
                                    min-width: 1100px;
                                    border-collapse: collapse;
                                    white-space: nowrap;
                                    font-size: 0.88rem;
                                }

                                thead th {
                                    background: #F8FAFC;
                                    color: var(--text-muted);
                                    text-align: left;
                                    padding: 0.85rem 1rem;
                                    font-weight: 600;
                                    font-size: 0.75rem;
                                    text-transform: uppercase;
                                    letter-spacing: 0.05rem;
                                    border-bottom: 2px solid var(--border);
                                    position: sticky;
                                    top: 0;
                                }

                                tbody td {
                                    padding: 0.8rem 1rem;
                                    border-bottom: 1px solid #F1F5F9;
                                    color: var(--text-main);
                                    vertical-align: middle;
                                }

                                tbody tr {
                                    transition: var(--transition);
                                }

                                tbody tr:hover {
                                    background: #F8FAFC;
                                }

                                tbody tr:last-child td {
                                    border-bottom: none;
                                }

                                /* ─── Event Title Link ─────────────────────── */
                                .event-title {
                                    font-weight: 600;
                                    color: var(--primary);
                                    text-decoration: none;
                                    transition: var(--transition);
                                }

                                .event-title:hover {
                                    color: var(--primary-hover);
                                    text-decoration: underline;
                                }

                                /* ─── Description Cell ─────────────────────── */
                                .desc-cell {
                                    max-width: 220px;
                                    white-space: nowrap;
                                    overflow: hidden;
                                    text-overflow: ellipsis;
                                    color: var(--text-muted);
                                    font-size: 0.85rem;
                                }

                                /* ─── Badges ───────────────────────────────── */
                                .badge {
                                    display: inline-block;
                                    padding: 0.2rem 0.6rem;
                                    border-radius: 100px;
                                    font-size: 0.72rem;
                                    font-weight: 600;
                                    letter-spacing: 0.02rem;
                                }

                                .badge-open {
                                    background: #D1FAE5;
                                    color: #065F46;
                                }

                                .badge-closed {
                                    background: #FEE2E2;
                                    color: #991B1B;
                                }

                                .badge-upcoming {
                                    background: #DBEAFE;
                                    color: #1E40AF;
                                }

                                .badge-completed {
                                    background: #E0E7FF;
                                    color: #3730A3;
                                }

                                .badge-expired {
                                    background: #F3F4F6;
                                    color: #6B7280;
                                }

                                /* ─── Image Thumbnail ──────────────────────── */
                                .thumb {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: 8px;
                                    object-fit: cover;
                                    border: 1px solid var(--border);
                                }

                                .thumb-placeholder {
                                    width: 40px;
                                    height: 40px;
                                    border-radius: 8px;
                                    background: #F1F5F9;
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    color: var(--text-muted);
                                    font-size: 1rem;
                                }

                                /* ─── Action Links ─────────────────────────── */
                                .action-link {
                                    display: inline-block;
                                    padding: 0.3rem 0.65rem;
                                    border-radius: 6px;
                                    font-size: 0.78rem;
                                    font-weight: 600;
                                    text-decoration: none;
                                    transition: var(--transition);
                                    white-space: nowrap;
                                }

                                .action-link-primary {
                                    color: var(--primary);
                                    background: rgba(79, 70, 229, 0.08);
                                }

                                .action-link-primary:hover {
                                    background: rgba(79, 70, 229, 0.15);
                                }

                                .action-link-danger {
                                    color: var(--danger);
                                    background: rgba(239, 68, 68, 0.08);
                                }

                                .action-link-danger:hover {
                                    background: rgba(239, 68, 68, 0.15);
                                }

                                .action-link-warning {
                                    color: #B45309;
                                    background: rgba(245, 158, 11, 0.1);
                                }

                                .action-link-warning:hover {
                                    background: rgba(245, 158, 11, 0.18);
                                }

                                .action-link-success {
                                    color: #047857;
                                    background: rgba(16, 185, 129, 0.1);
                                }

                                .action-link-success:hover {
                                    background: rgba(16, 185, 129, 0.18);
                                }

                                .action-muted {
                                    color: var(--text-muted);
                                    font-size: 0.78rem;
                                }

                                /* ─── Reserve Button ───────────────────────── */
                                .reserve-form {
                                    margin: 0;
                                    padding: 0;
                                    background: none;
                                    box-shadow: none;
                                }

                                .btn-reserve {
                                    padding: 0.35rem 0.8rem;
                                    background: var(--primary);
                                    color: #fff;
                                    border: none;
                                    border-radius: 6px;
                                    font-weight: 600;
                                    font-size: 0.78rem;
                                    cursor: pointer;
                                    transition: var(--transition);
                                }

                                .btn-reserve:hover {
                                    background: var(--primary-hover);
                                    transform: translateY(-1px);
                                }

                                /* ─── Management Actions Cell ──────────────── */
                                .manage-actions {
                                    display: flex;
                                    gap: 0.35rem;
                                    flex-wrap: wrap;
                                }

                                /* ─── Footer Nav ───────────────────────────── */
                                .footer-nav {
                                    padding: 1rem 1.5rem;
                                    border-top: 1px solid var(--border);
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .back-btn {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 0.4rem;
                                    padding: 0.5rem 1rem;
                                    color: var(--primary);
                                    font-weight: 600;
                                    font-size: 0.88rem;
                                    text-decoration: none;
                                    border-radius: 8px;
                                    transition: var(--transition);
                                }

                                .back-btn:hover {
                                    background: rgba(79, 70, 229, 0.08);
                                }

                                .event-count {
                                    font-size: 0.85rem;
                                    color: var(--text-muted);
                                }

                                /* ─── Empty State ──────────────────────────── */
                                .empty-state {
                                    text-align: center;
                                    padding: 3rem 2rem;
                                    color: var(--text-muted);
                                }

                                .empty-state-icon {
                                    font-size: 3rem;
                                    margin-bottom: 0.75rem;
                                }

                                /* ─── Animation ────────────────────────────── */
                                @keyframes fadeUp {
                                    from {
                                        opacity: 0;
                                        transform: translateY(10px);
                                    }

                                    to {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }
                                }

                                .container>* {
                                    animation: fadeUp 0.4s ease-out forwards;
                                }

                                /* ─── Responsive ───────────────────────────── */
                                @media (max-width: 768px) {
                                    .page-header {
                                        padding: 1.5rem 1rem 2.5rem;
                                    }

                                    .container {
                                        max-width: 1400px;
                                        margin: -1.5rem auto 2rem;
                                        padding: 0 1.5rem;
                                    }

                                    .search-card {
                                        flex-direction: column;
                                    }

                                    .search-card input[type="text"],
                                    .search-card select,
                                    .search-card button {
                                        width: 100%;
                                    }
                                }
                            </style>
                        </head>

                        <body>

                            <!-- Header -->
                            <div class="page-header">
                                <div class="page-header-inner">
                                    <h1>All Events</h1>
                                    <p>Browse and discover campus events</p>
                                </div>
                            </div>

                            <div class="container">

                                <!-- Search -->
                                <form class="search-card" action="${pageContext.request.contextPath}/search"
                                    method="get">
                                    <input type="text" name="keyword" placeholder="Search events...">
                                    <select name="type">
                                        <option value="title">Title</option>
                                        <option value="date">Date</option>
                                        <option value="department">Department/Club</option>
                                        <option value="category">Category</option>
                                        <option value="type">Event Type</option>
                                        <option value="availability">Available Seats</option>
                                    </select>
                                    <button type="submit">Search</button>
                                </form>

                                <!-- Table -->
                                <div class="table-card">
                                    <div class="table-scroll-top" id="scrollTop">
                                        <div class="table-scroll-top-inner" id="scrollTopInner"></div>
                                    </div>
                                    <div class="table-scroll" id="scrollBottom">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th></th>
                                                    <th>Event</th>
                                                    <th>Date</th>
                                                    <th>Location</th>
                                                    <th>Category</th>
                                                    <th>Seats</th>
                                                    <th>Status</th>
                                                    <th>Registration</th>
                                                    <th>Action</th>
                                                    <% if (canManage) { %>
                                                        <th>Manage</th>
                                                        <% } %>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% if (events !=null && !events.isEmpty()) { for (Event e : events) {
                                                    String regStatus=e.getRegistrationStatus() !=null ?
                                                    e.getRegistrationStatus() : "" ; String evtStatus=e.getEventStatus()
                                                    !=null ? e.getEventStatus() : "" ; boolean canReserve="OPEN"
                                                    .equalsIgnoreCase(regStatus) && "UPCOMING"
                                                    .equalsIgnoreCase(evtStatus) && e.getCapacity()> 0;

                                                    String evtBadge = "badge-upcoming";
                                                    if ("COMPLETED".equalsIgnoreCase(evtStatus)) evtBadge =
                                                    "badge-completed";
                                                    else if ("EXPIRED".equalsIgnoreCase(evtStatus)) evtBadge =
                                                    "badge-expired";

                                                    String regBadge = "OPEN".equalsIgnoreCase(regStatus) ? "badge-open"
                                                    : "badge-closed";
                                                    %>
                                                    <tr>
                                                        <!-- Thumbnail -->
                                                        <td>
                                                            <% if (e.getImagePath() !=null &&
                                                                !e.getImagePath().isEmpty()) { %>
                                                                <img class="thumb"
                                                                    src="${pageContext.request.contextPath}/<%= e.getImagePath() %>"
                                                                    alt="">
                                                                <% } else { %>
                                                                    <div class="thumb-placeholder">--</div>
                                                                    <% } %>
                                                        </td>

                                                        <!-- Title + Description -->
                                                        <td>
                                                            <a class="event-title"
                                                                href="${pageContext.request.contextPath}/event-detail?id=<%= e.getId() %>">
                                                                <%= e.getTitle() %>
                                                            </a>
                                                            <div class="desc-cell">
                                                                <%= e.getDescription() !=null ? e.getDescription() : ""
                                                                    %>
                                                            </div>
                                                        </td>

                                                        <!-- Date + Time -->
                                                        <td>
                                                            <%= e.getDate() %>
                                                                <% if (e.getEventTime() !=null &&
                                                                    !e.getEventTime().isEmpty()) { %>
                                                                    <br><span
                                                                        style="color:var(--text-muted);font-size:0.8rem;">
                                                                        <%= e.getEventTime() %>
                                                                    </span>
                                                                    <% } %>
                                                        </td>

                                                        <!-- Location -->
                                                        <td>
                                                            <%= e.getLocation() !=null ? e.getLocation() : "-" %>
                                                        </td>

                                                        <!-- Category -->
                                                        <td>
                                                            <%= e.getCategory() !=null ? e.getCategory() : "-" %>
                                                        </td>

                                                        <!-- Seats -->
                                                        <td><strong>
                                                                <%= e.getCapacity() %>
                                                            </strong></td>

                                                        <!-- Event Status -->
                                                        <td><span class="badge <%= evtBadge %>">
                                                                <%= evtStatus.isEmpty() ? "N/A" : evtStatus %>
                                                            </span></td>

                                                        <!-- Registration Status -->
                                                        <td><span class="badge <%= regBadge %>">
                                                                <%= regStatus.isEmpty() ? "N/A" : regStatus %>
                                                            </span></td>

                                                        <!-- Reserve Action -->
                                                        <td>
                                                            <% if (canReserve && user !=null && "student"
                                                                .equalsIgnoreCase(user.getRole())) { %>
                                                                <form class="reserve-form"
                                                                    action="${pageContext.request.contextPath}/reserve"
                                                                    method="post">
                                                                    <input type="hidden" name="eventId"
                                                                        value="<%= e.getId() %>">
                                                                    <button class="btn-reserve"
                                                                        type="submit">Reserve</button>
                                                                </form>
                                                                <% } else if (canReserve && user==null) { %>
                                                                    <a class="action-link action-link-primary"
                                                                        href="${pageContext.request.contextPath}/login">Login</a>
                                                                    <% } else { %>
                                                                        <span class="action-muted">-</span>
                                                                        <% } %>
                                                        </td>

                                                        <!-- Manage Actions (organizer/admin only) -->
                                                        <% if (canManage) { %>
                                                            <td>
                                                                <div class="manage-actions">
                                                                    <a class="action-link action-link-primary"
                                                                        href="${pageContext.request.contextPath}/view-attendees?eventId=<%= e.getId() %>">Attendees</a>
                                                                    <a class="action-link action-link-primary"
                                                                        href="${pageContext.request.contextPath}/edit-event?id=<%= e.getId() %>">Edit</a>
                                                                    <a class="action-link action-link-danger"
                                                                        href="${pageContext.request.contextPath}/delete-event?id=<%= e.getId() %>">Delete</a>
                                                                    <% if ("OPEN".equalsIgnoreCase(regStatus)) { %>
                                                                        <a class="action-link action-link-warning"
                                                                            href="${pageContext.request.contextPath}/close-event?id=<%= e.getId() %>">Close</a>
                                                                        <% } %>
                                                                            <% if
                                                                                (!"COMPLETED".equalsIgnoreCase(evtStatus))
                                                                                { %>
                                                                                <a class="action-link action-link-success"
                                                                                    href="${pageContext.request.contextPath}/complete-event?id=<%= e.getId() %>">Complete</a>
                                                                                <% } %>
                                                                </div>
                                                            </td>
                                                            <% } %>
                                                    </tr>
                                                    <% } } %>
                                            </tbody>
                                        </table>

                                        <% if (events==null || events.isEmpty()) { %>
                                            <div class="empty-state">
                                                <div class="empty-state-icon"></div>
                                                <p>No events found</p>
                                            </div>
                                            <% } %>
                                    </div>

                                    <!-- Footer -->
                                    <div class="footer-nav">
                                        <div>
                                            <% if (user !=null) { %>
                                                <% if ("student".equalsIgnoreCase(user.getRole())) { %>
                                                    <a class="back-btn"
                                                        href="${pageContext.request.contextPath}/student/home">
                                                        Back to Dashboard</a>
                                                    <% } else if ("organizer".equalsIgnoreCase(user.getRole())) { %>
                                                        <a class="back-btn"
                                                            href="${pageContext.request.contextPath}/organizer/home">
                                                            Back to Dashboard</a>
                                                        <% } else if ("admin".equalsIgnoreCase(user.getRole())) { %>
                                                            <a class="back-btn"
                                                                href="${pageContext.request.contextPath}/admin/home">
                                                                Back to Dashboard</a>
                                                            <% } %>
                                                                <% } else { %>
                                                                    <a class="back-btn"
                                                                        href="${pageContext.request.contextPath}/">
                                                                        Home</a>
                                                                    <% } %>
                                        </div>
                                        <% if (events !=null) { %>
                                            <span class="event-count">
                                                <%= events.size() %> event<%= events.size() !=1 ? "s" : "" %>
                                            </span>
                                            <% } %>
                                    </div>
                                </div>

                            </div>

                        <script>
                            (function() {
                                var top = document.getElementById('scrollTop');
                                var bottom = document.getElementById('scrollBottom');
                                var inner = document.getElementById('scrollTopInner');
                                if (!top || !bottom || !inner) return;

                                // Match the top scrollbar's inner width to the table's actual width
                                function syncWidth() {
                                    inner.style.width = bottom.scrollWidth + 'px';
                                }
                                syncWidth();
                                window.addEventListener('resize', syncWidth);

                                var isSyncingTop = false;
                                var isSyncingBottom = false;

                                top.addEventListener('scroll', function() {
                                    if (isSyncingTop) { isSyncingTop = false; return; }
                                    isSyncingBottom = true;
                                    bottom.scrollLeft = top.scrollLeft;
                                });

                                bottom.addEventListener('scroll', function() {
                                    if (isSyncingBottom) { isSyncingBottom = false; return; }
                                    isSyncingTop = true;
                                    top.scrollLeft = bottom.scrollLeft;
                                });
                            })();
                        </script>

                        </body>

                        </html>