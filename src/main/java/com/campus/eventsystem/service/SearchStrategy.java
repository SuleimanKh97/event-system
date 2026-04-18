package com.campus.eventsystem.service;

import com.campus.eventsystem.model.Event;
import java.util.List;

public interface SearchStrategy {
    List<Event> search(String keyword);
}