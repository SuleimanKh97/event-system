package com.campus.eventsystem.service;

import com.campus.eventsystem.model.Event;
import java.util.List;

public class SearchContext {

    private SearchStrategy strategy;

    public void setStrategy(SearchStrategy strategy) {
        this.strategy = strategy;
    }

    public List<Event> executeSearch(String keyword) {
        return strategy.search(keyword);
    }
}