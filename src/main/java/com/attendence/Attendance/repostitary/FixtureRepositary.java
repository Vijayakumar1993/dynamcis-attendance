package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.entity.Fixture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FixtureRepositary  extends JpaRepository<Fixture, Long> {
     List<Fixture> findByEventId(Event event);
     int deleteByEventId(Event event);
}
