package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.Status;
import jakarta.persistence.*;

import java.util.Objects;
import java.util.Set;

@Entity
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String teamName;

    @OneToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;
    private String location;
    private String description;

    @OneToMany(mappedBy = "team")
    private Set<CompetitionTeam> competitions;

    @ManyToOne
    @JoinColumn(name = "created_by")
    private Customer createdBy;

    @Enumerated(EnumType.STRING)
    private Status status;  // ACTIVE, INACTIVE

    public Team(){}
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Customer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Customer createdBy) {
        this.createdBy = createdBy;
    }

    public Set<CompetitionTeam> getCompetitions() {
        return competitions;
    }

    public void setCompetitions(Set<CompetitionTeam> competitions) {
        this.competitions = competitions;
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Team)) return false;
        Team team = (Team) o;
        return Objects.equals(id, team.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
