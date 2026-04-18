package com.campus.eventsystem.dao;

import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    /**
     * Helper: maps a ResultSet row to an Event object (all fields).
     */
    private Event mapEvent(ResultSet rs) throws Exception {
        Event event = new Event();
        event.setId(rs.getInt("id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setDate(rs.getString("event_date"));
        event.setCapacity(rs.getInt("capacity"));
        event.setType(rs.getString("type"));
        event.setOrganizerId(rs.getInt("organizer_id"));
        event.setOrganizerName(rs.getString("organizer_name"));
        event.setDepartmentClub(rs.getString("department_club"));
        event.setEventTime(rs.getString("event_time"));
        event.setLocation(rs.getString("location"));
        event.setCategory(rs.getString("category"));
        event.setImagePath(rs.getString("image_path"));
        event.setRegistrationStatus(rs.getString("registration_status"));
        event.setEventStatus(rs.getString("event_status"));
        return event;
    }

    // ─── CREATE ──────────────────────────────────────────

    public boolean addEvent(Event event) {
        String sql = "INSERT INTO events (title, description, event_date, capacity, type, " +
                     "organizer_id, organizer_name, department_club, event_time, location, " +
                     "category, image_path, registration_status, event_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setString(3, event.getDate());
            stmt.setInt(4, event.getCapacity());
            stmt.setString(5, event.getType());
            stmt.setInt(6, event.getOrganizerId());
            stmt.setString(7, event.getOrganizerName());
            stmt.setString(8, event.getDepartmentClub());
            stmt.setString(9, event.getEventTime());
            stmt.setString(10, event.getLocation());
            stmt.setString(11, event.getCategory());
            stmt.setString(12, event.getImagePath());
            stmt.setString(13, "OPEN");       // default
            stmt.setString(14, "UPCOMING");   // default

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ─── READ ────────────────────────────────────────────

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                events.add(mapEvent(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return events;
    }

    public Event getEventById(int id) {
        String sql = "SELECT * FROM events WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapEvent(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── UPDATE ──────────────────────────────────────────

    public void updateEvent(Event event) {
        String sql = "UPDATE events SET title=?, description=?, event_date=?, capacity=?, type=?, " +
                     "organizer_name=?, department_club=?, event_time=?, location=?, category=?, image_path=? " +
                     "WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setString(3, event.getDate());
            stmt.setInt(4, event.getCapacity());
            stmt.setString(5, event.getType());
            stmt.setString(6, event.getOrganizerName());
            stmt.setString(7, event.getDepartmentClub());
            stmt.setString(8, event.getEventTime());
            stmt.setString(9, event.getLocation());
            stmt.setString(10, event.getCategory());
            stmt.setString(11, event.getImagePath());
            stmt.setInt(12, event.getId());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateRegistrationStatus(int eventId, String status) {
        String sql = "UPDATE events SET registration_status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, eventId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateEventStatus(int eventId, String status) {
        String sql = "UPDATE events SET event_status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, eventId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─── DELETE ──────────────────────────────────────────

    public void deleteEvent(int id) {
        String sql = "DELETE FROM events WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─── RESERVATION (with concurrency control) ──────────

    public boolean reserveEvent(int userId, int eventId) {

        String checkSql = "SELECT capacity, registration_status, event_status FROM events WHERE id = ? FOR UPDATE";
        String updateSql = "UPDATE events SET capacity = capacity - 1 WHERE id = ?";
        String insertSql = "INSERT INTO reservations (user_id, event_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try (
                    PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    PreparedStatement insertStmt = conn.prepareStatement(insertSql)
            ) {

                checkStmt.setInt(1, eventId);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    int capacity = rs.getInt("capacity");
                    String regStatus = rs.getString("registration_status");
                    String evtStatus = rs.getString("event_status");

                    // Block reservation if not OPEN or not UPCOMING
                    if (!"OPEN".equalsIgnoreCase(regStatus)) {
                        conn.rollback();
                        return false;
                    }
                    if (!"UPCOMING".equalsIgnoreCase(evtStatus)) {
                        conn.rollback();
                        return false;
                    }
                    if (capacity <= 0) {
                        conn.rollback();
                        return false;
                    }
                }

                updateStmt.setInt(1, eventId);
                updateStmt.executeUpdate();

                insertStmt.setInt(1, userId);
                insertStmt.setInt(2, eventId);
                insertStmt.executeUpdate();

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ─── EXPIRATION ──────────────────────────────────────

    /**
     * Marks past events as EXPIRED (unless already COMPLETED).
     * Call this before listing events.
     */
    public void expireOldEvents() {
        String sql = "UPDATE events SET event_status = 'EXPIRED' " +
                     "WHERE event_date < CURDATE() AND event_status <> 'COMPLETED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─── ATTENDEES COUNT ─────────────────────────────────

    public int getAttendeesCount(int eventId) {
        String sql = "SELECT COUNT(*) FROM reservations WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}