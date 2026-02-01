package com.attendence.Attendance.entity;
import com.attendence.Attendance.constants.InterestLevel;
import com.attendence.Attendance.constants.LeadPriority;
import com.attendence.Attendance.constants.LeadSource;
import com.attendence.Attendance.constants.LeadStatus;
import jakarta.persistence.*;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "lead_followups")
public class LeadFollowUp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "lead_id")
    private Customer lead;

    @ManyToOne
    private Configuration status;

    @ManyToOne
    private Configuration interest;

    private LocalDate callDate;

    private LocalDate nextCallDate;

    @Column(length = 1000)
    private String comments;

    @ManyToOne
    private Configuration priority;

    @ManyToOne
    private Configuration source;

    @UpdateTimestamp
    private LocalDateTime lastUpdatedTx;

    private LocalDate expectedJoinDate;

    @ManyToOne
    @JoinColumn(name="created_by")
    private Customer createdBy;

    @ManyToOne
    private Configuration budgetRange;

    @ManyToOne
    private Configuration preferredCallTime;

    public LeadFollowUp() {}

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Customer getLead() {
        return lead;
    }

    public void setLead(Customer lead) {
        this.lead = lead;
    }

    public Configuration getStatus() {
        return status;
    }

    public void setStatus(Configuration status) {
        this.status = status;
    }

    public Configuration getInterest() {
        return interest;
    }

    public void setInterest(Configuration interest) {
        this.interest = interest;
    }

    public LocalDate getCallDate() {
        return callDate;
    }

    public void setCallDate(LocalDate callDate) {
        this.callDate = callDate;
    }

    public LocalDate getNextCallDate() {
        return nextCallDate;
    }

    public void setNextCallDate(LocalDate nextCallDate) {
        this.nextCallDate = nextCallDate;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Configuration getPriority() {
        return priority;
    }

    public void setPriority(Configuration priority) {
        this.priority = priority;
    }

    public Configuration getSource() {
        return source;
    }

    public void setSource(Configuration source) {
        this.source = source;
    }

    public LocalDateTime getLastUpdatedTx() {
        return lastUpdatedTx;
    }

    public void setLastUpdatedTx(LocalDateTime lastUpdatedTx) {
        this.lastUpdatedTx = lastUpdatedTx;
    }

    public LocalDate getExpectedJoinDate() {
        return expectedJoinDate;
    }

    public void setExpectedJoinDate(LocalDate expectedJoinDate) {
        this.expectedJoinDate = expectedJoinDate;
    }

    public Configuration getBudgetRange() {
        return budgetRange;
    }

    public void setBudgetRange(Configuration budgetRange) {
        this.budgetRange = budgetRange;
    }

    public Configuration getPreferredCallTime() {
        return preferredCallTime;
    }

    public void setPreferredCallTime(Configuration preferredCallTime) {
        this.preferredCallTime = preferredCallTime;
    }

    public Customer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Customer createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "LeadFollowUp{" +
                "id=" + id +
                ", lead=" + lead +
                ", status=" + status +
                ", interest=" + interest +
                ", callDate=" + callDate +
                ", nextCallDate=" + nextCallDate +
                ", comments='" + comments + '\'' +
                ", priority=" + priority +
                ", source=" + source +
                ", lastUpdatedTx=" + lastUpdatedTx +
                ", expectedJoinDate=" + expectedJoinDate +
                ", createdBy=" + createdBy +
                ", budgetRange=" + budgetRange +
                ", preferredCallTime=" + preferredCallTime +
                '}';
    }
}
