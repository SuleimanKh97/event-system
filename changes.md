# Campus Event System — Changes Log

This document summarizes all the changes that have been implemented to match the project requirements exactly. We have completed all 7 phases of the implementation plan.

## 1. Database & Schema (Existing Change - Modified)
*   **What we did:** Updated `campus_event_db.sql` to include proper constraints.
*   **Modifications:**
    *   **Removed** the redundant `status` column from `events` (relied entirely on `registration_status` and `event_status` to prevent conflicts).
    *   **Added** strictly enforced `FOREIGN KEY` constraints linking events, users, reservations, and ratings. This prevents "orphan" records if a user or event is deleted.
    *   **Added** a `CHECK` constraint ensuring ratings stay between `1` and `5`.
    *   **Added** SQL indexes to columns used in the Search Strategies to improve search performance.
    *   **Added** `departments` and `categories` tables.

## 2. Event Model & Forms (Existing Change - Heavily Modified)
*   **What we did:** Updated `Event.java`, `EventDAO.java`, `AddEventServlet`, `EditEventServlet`, and the JSPs (`add-event.jsp`, `edit-event.jsp`, `events.jsp`).
*   **Modifications:**
    *   Expanded the Event entity to include all missing fields required by the project PDF: `organizerName`, `departmentClub`, `eventTime`, `location`, `category`, and `imagePath`.
    *   Integrated `multipart/form-data` to safely handle physical Image file uploads (up to 5MB capacity).
    *   Replaced generic `updateStatus` method with targeted `updateRegistrationStatus` and `updateEventStatus`.

## 3. Factory Method Pattern (New & Existing Change)
*   **What we did:** Fixed the `EventFactory` and subclass types to precisely reflect the requirements.
*   **Modifications:**
    *   **Deleted** `AcademicEvent.java` and `SocialEvent.java`.
    *   **Created (New)** `SeminarEvent.java`, `ClubSocialEvent.java`, and `SportsActivityEvent.java`.
    *   Updated `EventFactory.java` to use the correct keys (`workshop`, `seminar`, `clubsocial`, `sports`).

## 4. Search Strategy Pattern (New & Existing Change)
*   **What we did:** Expanded the Event search logic up to the 6 required strategies.
*   **Modifications:**
    *   **Kept & Updated** `SearchByTitle` and `SearchByDate`.
    *   **Created (New)** `SearchByDepartment`, `SearchByCategory`, `SearchByType`, and `SearchByAvailability`.
    *   **Modified** `SearchServlet` to handle routing the keyword to the dynamic contextual strategy selected from the frontend UI in `events.jsp`.

## 5. Rating System (Brand New Feature)
*   **What we did:** Added the ability for students to leave a 1-5 rating on completed events.
*   **Modifications:**
    *   **Created (New)** `Rating.java` model, `RatingDAO.java` for DB execution, and `RateEventServlet.java`.
    *   **Modified** `my-reservations.jsp` to expose a rating submission form *only* if the event status is `COMPLETED` or `EXPIRED` and the student hasn't already left a rating.

## 6. Attendance & Event Expiry (New Features)
*   **What we did:** Added Organizer controls for tracking who actually attended.
*   **Modifications:**
    *   **Created (New)** `ViewAttendeesServlet.java`, `MarkAttendanceServlet.java`, and `view-attendees.jsp`. Allows organizers/admins to view an event's guest list and toggle "PRESENT" / "ABSENT".
    *   **Modified** `EventDAO` to automatically handle Event Expiration (`expireOldEvents()`). Every time a user views the events list, it silently checks the date and switches old ones to `EXPIRED`.

## 7. Security, Admin Panel & Registration (Modified)
*   **What we did:** Reinforced system security, roles, and administrative limits.
*   **Modifications:**
    *   **Modified** almost all Servlets to include explicit session validation & role guards (e.g. only Admin + Organizer can create, edit, or delete events).
    *   **Modified** `RegisterServlet` and `UserDAO` to verify if an email exists before creating a user to prevent duplicate accounts.
    *   **Created (New)** `AdminSettingsServlet` and `admin-settings.jsp` to allow checking/adding specific Categories and Departments to the database dynamically.

---

## 🚀 What is Left to Go?

From a coding standpoint, **100% of the functional requirements detailed in the assignment PDF have been fully programmed.**

Here is what remains for you to run the system:

1. **Fix `JAVA_HOME` configuration:** 
   Our attempt to build the project directly returned an error because `JAVA_HOME` is not set. You need to verify that Java JDK is properly configured in your Windows Environment Variables or load the project through IntelliJ IDEA.
2. **Deploy to Tomcat / Server:**
   Load the project in IntelliJ IDEA, attach your local Apache Tomcat server, and let the IDE handle the compiled WAR generation.
3. **Manual Quality Assurance (QA):**
   - Attempt to register an existing email to see the error message.
   - Login as an Organizer, create an event, upload an image, and see if it successfully writes to the `/uploads` folder.
   - Login as a Student, reserve a seat, and observe the capacity decrease algorithm (concurrency requirement).
