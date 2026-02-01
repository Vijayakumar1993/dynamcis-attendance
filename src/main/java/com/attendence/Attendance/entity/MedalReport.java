package com.attendence.Attendance.entity;

import jakarta.persistence.*;

@Entity
public class MedalReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "competition")
    public Competition competition;
    @ManyToOne
    @JoinColumn(name = "event")
    public Event event;
    public String weightDefination;
    public String categoryDefination;
    public String genderDefination;

    @ManyToOne
    @JoinColumn(name = "gold_customer")
    public Customer gold;

    @ManyToOne
    @JoinColumn(name = "silver_customer")
    public Customer silver;

    @ManyToOne
    @JoinColumn(name = "bronze1_customer")
    public Customer bronze1;

    @ManyToOne
    @JoinColumn(name = "bronze2_customer")
    public Customer bronze2;

    public MedalReport(){}
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Competition getCompetition() {
        return competition;
    }

    public void setCompetition(Competition competition) {
        this.competition = competition;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public String getWeightDefination() {
        return weightDefination;
    }

    public void setWeightDefination(String weightDefination) {
        this.weightDefination = weightDefination;
    }

    public String getCategoryDefination() {
        return categoryDefination;
    }

    public void setCategoryDefination(String categoryDefination) {
        this.categoryDefination = categoryDefination;
    }

    public String getGenderDefination() {
        return genderDefination;
    }

    public void setGenderDefination(String genderDefination) {
        this.genderDefination = genderDefination;
    }

    public Customer getGold() {
        return gold;
    }

    public void setGold(Customer gold) {
        this.gold = gold;
    }

    public Customer getSilver() {
        return silver;
    }

    public void setSilver(Customer silver) {
        this.silver = silver;
    }

    public Customer getBronze1() {
        return bronze1;
    }

    public void setBronze1(Customer bronze1) {
        this.bronze1 = bronze1;
    }

    public Customer getBronze2() {
        return bronze2;
    }

    public void setBronze2(Customer bronze2) {
        this.bronze2 = bronze2;
    }
}
