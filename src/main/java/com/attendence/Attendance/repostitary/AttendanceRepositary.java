package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AttendanceRepositary extends JpaRepository<Attendance,Long> {
    List<Attendance> findAll();
    Integer deleteByCustomerIdAndDate(Integer customerId, LocalDate date);
}
