package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.constants.Status;
import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface EventRepositary extends JpaRepository<Event, Long> {
    @Query("""
    SELECT e FROM Event e
    WHERE (:id IS NULL OR e.id = :id)
      AND (:eventDate IS NULL OR e.eventDate = :eventDate)
      AND (:roundOf IS NULL OR e.roundOf = :roundOf)
      AND (:category IS NULL OR e.categoryDefination = :category)
      AND (:gender IS NULL OR e.genderDefination = :gender)
      AND (:status IS NULL OR e.status = :status)
      AND (:competition IS NULL OR e.competition = :competition)
    ORDER BY e.id DESC
""")
    List<Event> filterEvents(
            @Param("id") Long id,
            @Param("eventDate") LocalDate eventDate,
            @Param("competition") Competition competition,
            @Param("roundOf") Integer roundOf,
            @Param("gender") String gender,
            @Param("category") String category,
            @Param("status") Status status
    );

    List<Event> findByCompetitionAndParentEventId(Competition competition, Event parentEventId);
}
