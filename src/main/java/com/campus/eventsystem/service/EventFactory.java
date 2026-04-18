package com.campus.eventsystem.service;

import com.campus.eventsystem.model.*;

public class EventFactory {

    public static Event createEvent(String type) {

        if ("workshop".equalsIgnoreCase(type)) {
            return new WorkshopEvent();
        } else if ("seminar".equalsIgnoreCase(type)) {
            return new SeminarEvent();
        } else if ("clubsocial".equalsIgnoreCase(type)) {
            return new ClubSocialEvent();
        } else if ("sports".equalsIgnoreCase(type)) {
            return new SportsActivityEvent();
        }

        return new Event();
    }
}