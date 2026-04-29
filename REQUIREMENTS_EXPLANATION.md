# System Requirements vs. Implementation Explanation

This document directly maps your 7-point project specification to the actual codebase, explaining exactly how the *Campus Event Management & Ticketing System* fulfills every single requirement.

---

## 1. Problem Statement
**Requirement:** Connect students with campus events in an organized way, allowing tracking and capacity management.
**Implementation:** The system achieves this by providing a unified dashboard based on user roles (`StudentHomeServlet`, `OrganizerHomeServlet`). Students can browse all events in one place (`events.jsp`), view current capacities, and reserve tickets, solving the discovery and management problem.

## 2. Technical Stack & Architecture
**Requirement:** Java Servlets, JSP, MySQL, MVC Architecture, Strategy Pattern, Factory Method Pattern.
**Implementation:**
- **Stack:** Built using pure Java Servlets mapped via `@WebServlet` and `JSP` pages handling dynamic view rendering.
- **Database:** Connects to MySQL using JDBC (`DBConnection.java`).
- **MVC Architecture:** Heavily enforced. `User.java`/`Event.java` are Models. JSPs in `/views` are Views. `LoginServlet.java`/`AddEventServlet.java` are Controllers.
- **Factory Pattern:** Implemented via `com.campus.eventsystem.service.EventFactory.java`. When adding an event, the code calls `EventFactory.createEvent(type)` to instantiate a specific subtype (`WorkshopEvent`, `SeminarEvent`, etc.).
- **Strategy Pattern:** Implemented via the `SearchStrategy` interface in the `service` package. Specific search behaviors are encapsulated in distinct classes like `SearchByTitle`, `SearchByCategory`, and `SearchByAvailability`.

## 3. Functional Requirements
**Requirement:** User registration, login, distinct user roles (Student, Organizer, Admin), session management, profile management.
**Implementation:**
- **Registration/Login:** Managed by `RegisterServlet` and `LoginServlet`. Data is validated against the `users` table via `UserDAO`.
- **Roles:** The database contains a `role` column. `LoginServlet` reads this and routes the user (`if ("student".equalsIgnoreCase(role)) { sendRedirect("/student/home"); }`).
- **Session Management:** Used extensively. `HttpSession session = request.getSession();` is called upon login. The `loggedUser` object is placed in the session so JSPs can recognize the user continuously (`${loggedUser.fullName}`).
- **Profiles:** Handled by `UpdateProfileServlet.java`, executing `UserDAO.updateUser()`. Admin functions are handled by `BlockUserServlet` and `DeleteUserServlet`.

## 4. Event Management (Factory Method Pattern)
**Requirement:** Event types (Workshop, Seminar, etc.), common fields, organizer features (create, edit, delete, mark completed, expiration).
**Implementation:**
- **Types:** The base class `Event.java` has subclasses `WorkshopEvent`, `SeminarEvent`, `ClubSocialEvent`, and `SportsActivityEvent`.
- **Fields:** Mapped fully in the `events` table (Title, Organizer, Category, Capacity, Image Path, etc.).
- **Organizer Controls:** `AddEventServlet`, `EditEventServlet`, `DeleteEventServlet` manage the CRUD cycle. `CloseEventServlet` updates the `registration_status` to CLOSED. `CompleteEventServlet` updates `event_status` to COMPLETED.
- **Expiration:** Implemented in `EventDAO.expireOldEvents()`. It executes an SQL `UPDATE` to mark events as 'EXPIRED' if the `event_date` is less than `CURDATE()`.

## 5. Ticket Reservation Workflow
**Requirement:** Reserve tickets, seat counts decrease, concurrency control (prevent overbooking), cancellation, attendance marking.
**Implementation:**
- **Reservation & Concurrency:** Handled in `EventDAO.reserveEvent()`. The database connection turns off auto-commit (`conn.setAutoCommit(false)`). The system runs a `SELECT ... FOR UPDATE` query locking that specific event row. It checks if `capacity > 0`. If yes, it runs `UPDATE events SET capacity = capacity - 1` and `INSERT INTO reservations`. Then it commits. This atomic lock ensures two users cannot grab the last seat simultaneously.
- **Cancellation:** `CancelReservationServlet` deletes the row from `reservations` and runs `UPDATE events SET capacity = capacity + 1`, restoring the seat.
- **Attendance:** `MarkAttendanceServlet` updates a status column in the `reservations` table to mark a user as PRESENT or ABSENT based on the organizer's input.

## 6. Event Search & Filter System (Strategy Pattern)
**Requirement:** Search by Title, Department, Date, Category, Type, Availability.
**Implementation:** 
This is handled dynamically by the Strategy Pattern. The `SearchServlet` receives a "filter by" parameter (e.g., 'title', 'category').
It instantiates a `SearchContext` and injects the proper strategy:
- `context.setStrategy(new SearchByTitle());`
- `context.setStrategy(new SearchByCategory());`
- `context.setStrategy(new SearchByAvailability());`
It then calls `context.executeSearch(keyword)`, allowing the application to seamlessly swap the SQL logic at runtime without messy `if/else` statements cluttering the Controller.

## 7. Admin Panel
**Requirement:** View users, block/unblock, edit/delete events, manage settings.
**Implementation:**
- Admin routes are protected. The `AdminUsersServlet` queries `UserDAO.getAllUsers()` sending the list to `users.jsp`.
- `BlockUserServlet` flips the boolean flag in the database `UPDATE users SET blocked = NOT blocked`.
- Admins share the `DeleteEventServlet` and `EditEventServlet` with organizers, but with elevated SQL privileges allowing them to alter *any* event, not just their own.
- System-wide settings are accessible via `AdminSettingsServlet`.
