package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.entity.Match;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MatchRepositary extends JpaRepository<Match, Long> {
    List<Match> findByEvent(Event event);
    void deleteByEvent(Event event);
    @Query("""
    select m from Match m
    where m.from.customerId = :customer
       or m.to.customerId = :customer
""")
    List<Match> findMatchesByCustomer(@Param("customer") Customer customer);
}
