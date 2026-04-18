package com.campus.eventsystem.service;

import com.campus.eventsystem.model.Event;
import com.campus.eventsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SearchByDepartment implements SearchStrategy {

    @Override
    public List<Event> search(String keyword) {
        List<Event> events = new ArrayList<>();

        String sql = "SELECT * FROM events WHERE department_club LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setDate(rs.getString("event_date"));
                e.setCapacity(rs.getInt("capacity"));
                e.setType(rs.getString("type"));
                e.setDepartmentClub(rs.getString("department_club"));
                e.setCategory(rs.getString("category"));
                e.setRegistrationStatus(rs.getString("registration_status"));
                e.setEventStatus(rs.getString("event_status"));
                events.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return events;
    }
}
