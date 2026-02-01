package com.attendence.Attendance.entity;

import com.attendence.Attendance.constants.Roles;
import jakarta.persistence.*;

import java.util.Objects;

@Entity
public class Authorities {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;

    @Enumerated(EnumType.STRING)
    private Roles authority;
    @ManyToOne
    @JoinColumn(name="customer_id")
    private Customer customerId;

    public Authorities(){}

    public Authorities( String username, Roles authority) {
        this.username = username;
        this.authority = authority;
    }
    public Authorities( String username, Roles authority, Customer customerId) {
        this.username = username;
        this.authority = authority;
        this.customerId = customerId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Roles getAuthority() {
        return authority;
    }

    public void setAuthority(Roles authority) {
        this.authority = authority;
    }

    public Customer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Customer customerId) {
        this.customerId = customerId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Authorities that = (Authorities) o;
        return Objects.equals(id, that.id) && Objects.equals(username, that.username) && Objects.equals(authority, that.authority) && Objects.equals(customerId, that.customerId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, username, authority, customerId);
    }
}
