package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.Status;
import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "parent_event_id")
    private Event parentEventId;

    @ManyToOne
    @JoinColumn(name = "prev_event_id")
    private Event prevEvent;

    @ManyToOne
    @JoinColumn(name = "next_event_id")
    private Event nextEvent;
    private LocalDate eventDate;
    private Integer roundOf;

    @ManyToOne
    @JoinColumn(name = "comp_id")
    private Competition competition;

    @Enumerated(EnumType.STRING)
    private Status status;
    private String description;
    private String categoryDefination;
    private String genderDefination;
    private String weightDefination;

    public Event() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Event getParentEventId() {
        return parentEventId;
    }

    public void setParentEventId(Event parentEventId) {
        this.parentEventId = parentEventId;
    }

    public LocalDate getEventDate() {
        return eventDate;
    }

    public void setEventDate(LocalDate eventDate) {
        this.eventDate = eventDate;
    }

    public Integer getRoundOf() {
        return roundOf;
    }

    public void setRoundOf(Integer roundOf) {
        this.roundOf = roundOf;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategoryDefination() {
        return categoryDefination;
    }

    public void setCategoryDefination(String categoryDefination) {
        this.categoryDefination = categoryDefination;
    }

    public String getWeightDefination() {
        return weightDefination;
    }

    public void setWeightDefination(String weightDefination) {
        this.weightDefination = weightDefination;
    }

    public Event getNextEvent() {
        return nextEvent;
    }

    public void setNextEvent(Event nextEvent) {
        this.nextEvent = nextEvent;
    }

    public Event getPrevEvent() {
        return prevEvent;
    }

    public void setPrevEvent(Event prevEvent) {
        this.prevEvent = prevEvent;
    }

    public Competition getCompetition() {
        return competition;
    }

    public void setCompetition(Competition competition) {
        this.competition = competition;
    }

    public String getGenderDefination() {
        return genderDefination;
    }

    public void setGenderDefination(String genderDefination) {
        this.genderDefination = genderDefination;
    }
}
