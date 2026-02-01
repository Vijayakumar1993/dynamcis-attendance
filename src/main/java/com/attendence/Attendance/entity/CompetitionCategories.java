package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.CompetitionTeamStatus;
import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
public class CompetitionCategories {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "competition_id", nullable = false)
    private Competition competition;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Configuration category;

    public CompetitionCategories(){}

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

    public Configuration getCategory() {
        return category;
    }

    public void setCategory(Configuration category) {
        this.category = category;
    }
}
