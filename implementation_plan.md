# Campus Event System — Complete Implementation Plan

> **Goal**: Bring the project to full compliance with the assignment spec in the simplest way possible, building on the existing codebase.

## Current State Summary

| Feature | Status | Notes |
|---|---|---|
| Login / Register | ✅ Done | Missing email duplicate check |
| Session management | ⚠️ Partial | Many servlets don't verify session/role |
| User Profiles | ✅ Done | Profile update works, session refreshes |
| User Roles (student/organizer/admin) | ✅ Done | Redirect after login works |
| Event CRUD | ⚠️ Partial | Missing 8 fields the spec requires |
| Factory Pattern | ⚠️ Wrong types | Has Academic/Social/Workshop → needs Workshop/Seminar/ClubSocial/SportsActivity |
| Search (Strategy Pattern) | ⚠️ Partial | Only title + date → needs 4 more strategies |
| Reservation + Concurrency | ✅ Done | FOR UPDATE + transaction + rollback ✔ |
| Cancel Reservation | ✅ Done | Deletes row + restores capacity |
| Close/Complete Event | ⚠️ Broken | Uses `status` column, should use `registration_status` / `event_status` |
| Event Expiration | ❌ Missing | Auto-expire past events |
| Attendance Tracking | ❌ Missing | Mark present/absent per reservation |
| Rating System | ❌ Missing | Table exists but no model/DAO/servlet/JSP |
| Admin Event Management | ❌ Missing | Admin can't see/edit/delete events |
| Foreign Keys | ❌ Missing | No referential integrity |

---

## User Review Required

> [!IMPORTANT]
> **Dropping `events.status` column**: The DB currently has 3 status columns (`status`, `registration_status`, `event_status`). The plan is to **drop `status`** and use only `registration_status` (OPEN/CLOSED) + `event_status` (UPCOMING/COMPLETED/EXPIRED). This affects `EventDAO.updateStatus()`, `CloseEventServlet`, `CompleteEventServlet`, `reserveEvent()`, and `events.jsp`. All will be updated in Phase 1–2.

> [!WARNING]
> **Factory type names change**: Current types (Academic, Social, Workshop) will be **replaced** with the spec's types (Workshop, Seminar, Club Social Event, Sports Activity). Any existing event data with old types will still display but won't match the new dropdown. The one existing test event has `type=NULL` so this should be fine.

---

## Phase 1 — Database Fixes

**Files**: [campus_event_db.sql](file:///c:/Users/ENG.K/IdeaProjects/event-system/campus_event_db.sql)

Run these SQL statements on the database:

### 1.1 Drop the redundant `status` column
```sql
ALTER TABLE events DROP COLUMN status;
```

### 1.2 Add Foreign Keys
```sql
ALTER TABLE events
ADD CONSTRAINT fk_events_organizer
FOREIGN KEY (organizer_id) REFERENCES users(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE reservations
ADD CONSTRAINT fk_reservations_user
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE reservations
ADD CONSTRAINT fk_reservations_event
FOREIGN KEY (event_id) REFERENCES events(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ratings
ADD CONSTRAINT fk_ratings_user
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ratings
ADD CONSTRAINT fk_ratings_event
FOREIGN KEY (event_id) REFERENCES events(id)
ON DELETE CASCADE ON UPDATE CASCADE;
```

### 1.3 Rating check constraint
```sql
ALTER TABLE ratings
ADD CONSTRAINT chk_rating_range CHECK (rating >= 1 AND rating <= 5);
```

### 1.4 Search indexes
```sql
ALTER TABLE events ADD INDEX idx_events_title (title);
ALTER TABLE events ADD INDEX idx_events_date (event_date);
ALTER TABLE events ADD INDEX idx_events_type (type);
ALTER TABLE events ADD INDEX idx_events_category (category);
ALTER TABLE events ADD INDEX idx_events_department_club (department_club);
ALTER TABLE events ADD INDEX idx_events_registration_status (registration_status);
ALTER TABLE events ADD INDEX idx_events_event_status (event_status);
```

### 1.5 Update the SQL dump file
Update `campus_event_db.sql` to include all of the above so the schema is reproducible.

---

## Phase 2 — Expand Event Model + DAO + Servlets + JSPs

This is the biggest change. The DB already has the columns; the Java code ignores them.

### 2.1 [MODIFY] [Event.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/Event.java)

Add these fields + getters/setters:
- `int organizerId`
- `String organizerName`
- `String departmentClub`
- `String eventTime`
- `String location`
- `String category`
- `String imagePath`
- `String registrationStatus`
- `String eventStatus`

**Remove** the `status` field and its getter/setter (replaced by `registrationStatus` + `eventStatus`).

### 2.2 [MODIFY] [EventDAO.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/dao/EventDAO.java)

- **`addEvent()`**: INSERT all new columns (organizer_id, organizer_name, department_club, event_time, location, category, image_path, type, registration_status, event_status)
- **`getAllEvents()`**: SELECT and map all new fields
- **`getEventById()`**: SELECT and map all new fields
- **`updateEvent()`**: UPDATE all new fields
- **`updateStatus()`** → split into two methods:
  - `updateRegistrationStatus(int eventId, String status)` — updates `registration_status`
  - `updateEventStatus(int eventId, String status)` — updates `event_status`
- **`reserveEvent()`**: Change check from `status` → `registration_status = 'OPEN'` AND `event_status = 'UPCOMING'`
- **Add** `expireOldEvents()` method:
  ```sql
  UPDATE events SET event_status='EXPIRED' WHERE event_date < CURDATE() AND event_status <> 'COMPLETED'
  ```
- **Add** `getAttendeesCount(int eventId)` method:
  ```sql
  SELECT COUNT(*) FROM reservations WHERE event_id = ?
  ```

### 2.3 [MODIFY] [add-event.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/add-event.jsp)

Add input fields for: Organizer Name, Department/Club, Time, Location, Category (select: Educational/Social/Sports/Cultural/Technical), Image upload (file input).

### 2.4 [MODIFY] [AddEventServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/AddEventServlet.java)

- Read all new parameters
- Set `organizerId` from session user
- Set `registrationStatus = "OPEN"`, `eventStatus = "UPCOMING"`
- Handle image upload (save to a folder, store path)
- Add session/role guard (only organizer or admin)

### 2.5 [MODIFY] [edit-event.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/edit-event.jsp)

Add all new fields pre-populated with current values.

### 2.6 [MODIFY] [EditEventServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/EditEventServlet.java)

Read and pass all new fields to `updateEvent()`. Add session/role guard.

### 2.7 [MODIFY] [events.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/events.jsp)

- Show new columns in table: Organizer, Department, Time, Location, Category, Registration Status, Event Status
- Replace `e.getStatus()` with `e.getRegistrationStatus()` / `e.getEventStatus()`
- Show organizer controls for **organizer OR admin**
- Hide Reserve button if `registrationStatus != OPEN` or `eventStatus != UPCOMING`

### 2.8 [MODIFY] [CloseEventServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/CloseEventServlet.java)

Change to call `updateRegistrationStatus(eventId, "CLOSED")` instead of `updateStatus(eventId, "CLOSED")`. Add session/role guard.

### 2.9 [MODIFY] [CompleteEventServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/CompleteEventServlet.java)

Change to call `updateEventStatus(eventId, "COMPLETED")`. Add session/role guard.

### 2.10 [MODIFY] [ViewEventsServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/ViewEventsServlet.java)

Call `eventDAO.expireOldEvents()` before `getAllEvents()` so expired events auto-update.

---

## Phase 3 — Fix Factory Pattern Types

### 3.1 [DELETE] [AcademicEvent.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/AcademicEvent.java)

### 3.2 [MODIFY] [SocialEvent.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/SocialEvent.java) → Rename to **ClubSocialEvent.java**
- `setType("Club Social Event")`

### 3.3 [MODIFY] [WorkshopEvent.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/WorkshopEvent.java)
- Keep as is, `setType("Workshop")` ✔

### 3.4 [NEW] [SeminarEvent.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/SeminarEvent.java)
```java
public class SeminarEvent extends Event {
    public SeminarEvent() { setType("Seminar"); }
}
```

### 3.5 [NEW] [SportsActivityEvent.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/SportsActivityEvent.java)
```java
public class SportsActivityEvent extends Event {
    public SportsActivityEvent() { setType("Sports Activity"); }
}
```

### 3.6 [MODIFY] [EventFactory.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/service/EventFactory.java)

Update to create:
- `"workshop"` → `WorkshopEvent`
- `"seminar"` → `SeminarEvent`
- `"clubsocial"` → `ClubSocialEvent`
- `"sports"` → `SportsActivityEvent`
- default → `Event`

### 3.7 [MODIFY] [add-event.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/add-event.jsp)

Update `<select name="type">` options:
- Workshop
- Seminar
- Club Social Event
- Sports Activity

---

## Phase 4 — Complete Search Strategies

### 4.1 [NEW] [SearchByDepartment.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/service/SearchByDepartment.java)
```sql
SELECT * FROM events WHERE department_club LIKE ?
```

### 4.2 [NEW] [SearchByCategory.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/service/SearchByCategory.java)
```sql
SELECT * FROM events WHERE category = ?
```

### 4.3 [NEW] [SearchByType.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/service/SearchByType.java)
```sql
SELECT * FROM events WHERE type = ?
```

### 4.4 [NEW] [SearchByAvailability.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/service/SearchByAvailability.java)
```sql
SELECT * FROM events WHERE capacity > 0 AND registration_status = 'OPEN'
```

### 4.5 [MODIFY] [SearchServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/SearchServlet.java)

Add cases for: `"department"`, `"category"`, `"type"`, `"availability"`

### 4.6 [MODIFY] [events.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/events.jsp)

Update search `<select>` to include all 6 options:
- Title, Date, Department/Club, Category, Type, Availability

---

## Phase 5 — Rating System

### 5.1 [NEW] [Rating.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/model/Rating.java)
Fields: `id`, `userId`, `eventId`, `rating` (1-5), `comment`

### 5.2 [NEW] [RatingDAO.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/dao/RatingDAO.java)
Methods:
- `addRating(Rating rating)` — INSERT, uses UNIQUE constraint to prevent duplicates
- `hasRated(int userId, int eventId)` — check if already rated
- `getRatingsForEvent(int eventId)` — returns list for display

### 5.3 [NEW] [RateEventServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/RateEventServlet.java)
- Verify session + student role
- Verify student has reservation for event
- Verify event is COMPLETED or EXPIRED
- Call `RatingDAO.addRating()`
- Redirect back to my-reservations

### 5.4 [MODIFY] [my-reservations.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/my-reservations.jsp)

Add a "Rate" column. Show a small form (select 1-5 + comment input + submit button) only for events with `eventStatus = COMPLETED` or `EXPIRED`.

---

## Phase 6 — Attendance + Expiration + Session Guards

### 6.1 Attendance Tracking

#### [NEW] [ViewAttendeesServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/ViewAttendeesServlet.java)
- Gets list of users who reserved a specific event
- Forwards to `view-attendees.jsp`

#### [NEW] [MarkAttendanceServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/MarkAttendanceServlet.java)
- Receives `userId`, `eventId`, `attendanceStatus` (PRESENT/ABSENT)
- Calls `ReservationDAO.updateAttendance()`

#### [MODIFY] [ReservationDAO.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/dao/ReservationDAO.java)
- Add `getReservationsForEvent(int eventId)` → returns list of users + attendance status
- Add `updateAttendance(int userId, int eventId, String status)`

#### [NEW] [view-attendees.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/view-attendees.jsp)
Table showing: user name, email, attendance status, button to toggle Present/Absent.

#### [MODIFY] [events.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/events.jsp)
Add "Attendees" link for organizer (and admin) next to each event.

### 6.2 Session & Role Guards

Add session + role check to **every** sensitive servlet that's currently missing it:

| Servlet | Required Role |
|---|---|
| `AddEventServlet` | organizer, admin |
| `EditEventServlet` | organizer, admin |
| `DeleteEventServlet` | organizer, admin |
| `CloseEventServlet` | organizer, admin |
| `CompleteEventServlet` | organizer, admin |
| `BlockUserServlet` | admin |
| `AdminUsersServlet` | admin |
| `UpdateUserRoleServlet` | admin |
| `ReserveServlet` | student (already has session check ✔) |
| `CancelReservationServlet` | student (already has session check ✔) |
| `ViewAttendeesServlet` | organizer, admin |
| `MarkAttendanceServlet` | organizer, admin |

Pattern for each:
```java
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("loggedUser") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
User user = (User) session.getAttribute("loggedUser");
if (!"organizer".equalsIgnoreCase(user.getRole()) && !"admin".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
```

---

## Phase 7 — Admin Event Control + Registration Improvements

### 7.1 Admin Event Management

#### [MODIFY] [admin-home.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/admin-home.jsp)
Add link: `Manage Events` → `/events`

#### [MODIFY] [events.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/events.jsp)
Show edit/delete/close/complete buttons when role is `organizer` **OR** `admin`.

### 7.2 Email Duplicate Check on Registration

#### [MODIFY] [UserDAO.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/dao/UserDAO.java)
Add `emailExists(String email)`:
```sql
SELECT id FROM users WHERE email = ?
```

#### [MODIFY] [RegisterServlet.java](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/java/com/campus/eventsystem/controller/RegisterServlet.java)
Before registering, check `emailExists()`. If true → forward back to register.jsp with error message.

#### [MODIFY] [register.jsp](file:///c:/Users/ENG.K/IdeaProjects/event-system/src/main/webapp/views/register.jsp)
Show error message area + add doGet to RegisterServlet + add link to login page.

---

## Execution Order

| # | Phase | Priority | Estimated Effort |
|---|---|---|---|
| 1 | Database fixes | 🔴 Critical | Small — SQL only |
| 2 | Expand Event model/DAO/JSP | 🔴 Critical | Large — biggest change |
| 3 | Fix Factory types | 🔴 Critical | Small — rename/create classes |
| 4 | Search strategies | 🟡 High | Medium — 4 new classes + servlet update |
| 5 | Rating system | 🟡 High | Medium — new model/DAO/servlet/JSP |
| 6 | Attendance + Guards | 🟡 High | Medium — new servlet/JSP + guard code |
| 7 | Admin events + email check | 🟢 Medium | Small — minor changes |

---

## Files Summary

### New Files (10)
- `SeminarEvent.java`
- `SportsActivityEvent.java`
- `ClubSocialEvent.java` (rename from SocialEvent)
- `SearchByDepartment.java`
- `SearchByCategory.java`
- `SearchByType.java`
- `SearchByAvailability.java`
- `Rating.java`
- `RatingDAO.java`
- `RateEventServlet.java`
- `ViewAttendeesServlet.java`
- `MarkAttendanceServlet.java`
- `view-attendees.jsp`

### Modified Files (19)
- `campus_event_db.sql`
- `Event.java`
- `EventDAO.java`
- `ReservationDAO.java`
- `UserDAO.java`
- `EventFactory.java`
- `AddEventServlet.java`
- `EditEventServlet.java`
- `CloseEventServlet.java`
- `CompleteEventServlet.java`
- `ViewEventsServlet.java`
- `SearchServlet.java`
- `RegisterServlet.java`
- `DeleteEventServlet.java`
- `BlockUserServlet.java`
- `add-event.jsp`, `edit-event.jsp`, `events.jsp`
- `my-reservations.jsp`, `admin-home.jsp`, `register.jsp`

### Deleted Files (1)
- `AcademicEvent.java`

---

## Verification Plan

### Automated
- Build with `mvn clean package` — must compile without errors
- Deploy to Tomcat and test each URL pattern

### Manual Testing Checklist
1. Register → check duplicate email is rejected
2. Login as student → browse events → reserve → cancel → rate
3. Login as organizer → create event (all fields) → edit → close registration → mark completed → view attendees → mark attendance
4. Login as admin → manage users → block/unblock → manage events → edit/delete any event
5. Verify expired events auto-update when visiting `/events`
6. Verify reserve button is hidden when registration is CLOSED
7. Verify non-logged-in users can't access protected servlets

---

## Open Questions

> [!IMPORTANT]
> **Image upload**: The spec says "Event image (max 5MB)". Do you want actual file upload with `multipart/form-data`, or is storing an image **path/URL** in a text field enough for now? File upload requires adding `@MultipartConfig` to the servlet and saving to disk. A text field path is much simpler.

> [!NOTE]
> **Departments/categories management page**: The spec mentions "Manage departments, event categories, and system-wide settings" for admin. This is the **lowest priority** item. We can skip it or add a very simple page later. Should we include it or defer?
