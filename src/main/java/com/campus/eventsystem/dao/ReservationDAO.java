package com.campus.eventsystem.dao;

import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.model.User;
import com.campus.eventsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReservationDAO {

    public List<Event> getUserReservations(int userId) {
        List<Event> events = new ArrayList<>();

        String sql = "SELECT e.* FROM reservations r JOIN events e ON r.event_id = e.id WHERE r.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Event event = new Event();
                event.setId(rs.getInt("id"));
                event.setTitle(rs.getString("title"));
                event.setDescription(rs.getString("description"));
                event.setDate(rs.getString("event_date"));
                event.setCapacity(rs.getInt("capacity"));
                event.setType(rs.getString("type"));
                event.setRegistrationStatus(rs.getString("registration_status"));
                event.setEventStatus(rs.getString("event_status"));

                events.add(event);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return events;
    }

    public boolean hasReservation(int userId, int eventId) {
        String sql = "SELECT id FROM reservations WHERE user_id = ? AND event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);

            ResultSet rs = stmt.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void cancelReservation(int userId, int eventId) {

        String deleteSql = "DELETE FROM reservations WHERE user_id = ? AND event_id = ?";
        String updateSql = "UPDATE events SET capacity = capacity + 1 WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                 PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {

                deleteStmt.setInt(1, userId);
                deleteStmt.setInt(2, eventId);
                deleteStmt.executeUpdate();

                updateStmt.setInt(1, eventId);
                updateStmt.executeUpdate();

                conn.commit();

            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─── ATTENDANCE ──────────────────────────────────────

    /**
     * Returns a list of maps, each containing user info + attendance_status
     * for a given event.
     */
    public List<Map<String, Object>> getReservationsForEvent(int eventId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT u.id AS user_id, u.full_name, u.email, r.attendance_status " +
                     "FROM reservations r JOIN users u ON r.user_id = u.id " +
                     "WHERE r.event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("userId", rs.getInt("user_id"));
                row.put("fullName", rs.getString("full_name"));
                row.put("email", rs.getString("email"));
                row.put("attendanceStatus", rs.getString("attendance_status"));
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateAttendance(int userId, int eventId, String status) {
        String sql = "UPDATE reservations SET attendance_status = ? WHERE user_id = ? AND event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, userId);
            stmt.setInt(3, eventId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}