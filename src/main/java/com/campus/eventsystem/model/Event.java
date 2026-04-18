package com.campus.eventsystem.model;

public class Event {

    private int id;
    private String title;
    private String description;
    private String date;
    private int capacity;
    private String type;

    // New fields matching DB
    private int organizerId;
    private String organizerName;
    private String departmentClub;
    private String eventTime;
    private String location;
    private String category;
    private String imagePath;
    private String registrationStatus;
    private String eventStatus;

    public Event() {}

    public Event(String title, String description, String date, int capacity) {
        this.title = title;
        this.description = description;
        this.date = date;
        this.capacity = capacity;
    }

    // getters & setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getDepartmentClub() { return departmentClub; }
    public void setDepartmentClub(String departmentClub) { this.departmentClub = departmentClub; }

    public String getEventTime() { return eventTime; }
    public void setEventTime(String eventTime) { this.eventTime = eventTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getRegistrationStatus() { return registrationStatus; }
    public void setRegistrationStatus(String registrationStatus) { this.registrationStatus = registrationStatus; }

    public String getEventStatus() { return eventStatus; }
    public void setEventStatus(String eventStatus) { this.eventStatus = eventStatus; }
}