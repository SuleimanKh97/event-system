package com.campus.eventsystem.dao;

import com.campus.eventsystem.model.Rating;
import com.campus.eventsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RatingDAO {

    public boolean addRating(Rating rating) {
        String sql = "INSERT INTO ratings (user_id, event_id, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rating.getUserId());
            stmt.setInt(2, rating.getEventId());
            stmt.setInt(3, rating.getRating());
            stmt.setString(4, rating.getComment());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean hasRated(int userId, int eventId) {
        String sql = "SELECT id FROM ratings WHERE user_id = ? AND event_id = ?";

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

    public List<Rating> getRatingsForEvent(int eventId) {
        List<Rating> ratings = new ArrayList<>();
        String sql = "SELECT * FROM ratings WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rating r = new Rating();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setEventId(rs.getInt("event_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                ratings.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ratings;
    }

    public double getAverageRating(int eventId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM ratings WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    public int getRatingCount(int eventId) {
        String sql = "SELECT COUNT(*) AS cnt FROM ratings WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("cnt");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
