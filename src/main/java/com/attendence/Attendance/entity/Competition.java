package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.CompetitionStatus;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.util.Set;

@Entity
public class Competition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String competitionName;

    @Column(nullable = false)
    private LocalDate competitionDate;

    @Column(nullable = false)
    private String competitionType;

    @Enumerated(EnumType.STRING)
    private CompetitionStatus status;

    private String venue;
    private String city;

    @ManyToOne
    @JoinColumn(name="organized_by")
    private Team organizedBy;

    private int rounds;
    private int roundDuration;         // minutes

    @OneToMany(mappedBy = "competition", cascade = CascadeType.ALL)
    private Set<CompetitionTeam> competitionTeams;

    @OneToMany(mappedBy = "competition", cascade = CascadeType.ALL)
    private Set<CompetitionCategories> competitionCategories;

    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] image;

    @CreationTimestamp
    private LocalDate createdDate;

    @ManyToOne
    @JoinColumn(name="created_by")
    private Customer createdBy;

    @Column(length = 500)
    private String remarks;

    public Competition(){}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCompetitionName() {
        return competitionName;
    }

    public void setCompetitionName(String competitionName) {
        this.competitionName = competitionName;
    }

    public LocalDate getCompetitionDate() {
        return competitionDate;
    }

    public void setCompetitionDate(LocalDate competitionDate) {
        this.competitionDate = competitionDate;
    }

    public String getCompetitionType() {
        return competitionType;
    }

    public void setCompetitionType(String competitionType) {
        this.competitionType = competitionType;
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Team getOrganizedBy() {
        return organizedBy;
    }

    public void setOrganizedBy(Team organizedBy) {
        this.organizedBy = organizedBy;
    }

    public int getRounds() {
        return rounds;
    }

    public void setRounds(int rounds) {
        this.rounds = rounds;
    }

    public int getRoundDuration() {
        return roundDuration;
    }

    public void setRoundDuration(int roundDuration) {
        this.roundDuration = roundDuration;
    }

    public Set<CompetitionTeam> getCompetitionTeams() {
        return competitionTeams;
    }

    public void setCompetitionTeams(Set<CompetitionTeam> competitionTeams) {
        this.competitionTeams = competitionTeams;
    }

    public LocalDate getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDate createdDate) {
        this.createdDate = createdDate;
    }

    public Customer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Customer createdBy) {
        this.createdBy = createdBy;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public CompetitionStatus getStatus() {
        return status;
    }

    public void setStatus(CompetitionStatus status) {
        this.status = status;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public Set<CompetitionCategories> getCompetitionCategories() {
        return competitionCategories;
    }

    public void setCompetitionCategories(Set<CompetitionCategories> competitionCategories) {
        this.competitionCategories = competitionCategories;
    }
}
