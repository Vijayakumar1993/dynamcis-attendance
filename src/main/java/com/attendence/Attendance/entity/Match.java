package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.Corner;
import jakarta.persistence.*;

@Entity
@Table(name = "Matches")
public class Match {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long matchId;

    @ManyToOne
    @JoinColumn(name = "event_id")
    private Event event;

    @ManyToOne
    @JoinColumn(name = "from_fixture_id")
    private Fixture from;

    @Enumerated(EnumType.STRING)
    private Corner fromCorner;

    @ManyToOne
    @JoinColumn(name = "to_fixture_id")
    private Fixture to;

    @Enumerated(EnumType.STRING)
    private Corner toCorner;

    private Boolean isBye;

    @ManyToOne
    @JoinColumn(name = "successor_fixture_id")
    private Fixture successor ;

    @Enumerated(EnumType.STRING)
    private Corner successorCorner;

    public Long getMatchId() {
        return matchId;
    }

    public void setMatchId(Long matchId) {
        this.matchId = matchId;
    }

    public Fixture getFrom() {
        return from;
    }

    public void setFrom(Fixture from) {
        this.from = from;
    }

    public Fixture getTo() {
        return to;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public Corner getFromCorner() {
        return fromCorner;
    }

    public void setFromCorner(Corner fromCorner) {
        this.fromCorner = fromCorner;
    }

    public Corner getToCorner() {
        return toCorner;
    }

    public void setToCorner(Corner toCorner) {
        this.toCorner = toCorner;
    }

    public Fixture getSuccessor() {
        return successor;
    }

    public void setSuccessor(Fixture successor) {
        this.successor = successor;
    }

    public void setTo(Fixture to) {
        this.to = to;
    }

    public Corner getSuccessorCorner() {
        return successorCorner;
    }

    public void setSuccessorCorner(Corner successorCorner) {
        this.successorCorner = successorCorner;
    }

    public Boolean getBye() {
        return isBye;
    }

    public void setBye(Boolean bye) {
        isBye = bye;
    }
}
