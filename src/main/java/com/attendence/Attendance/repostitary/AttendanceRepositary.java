package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AttendanceRepositary extends JpaRepository<Attendance,Long> {
    List<Attendance> findAll();
    Integer deleteByCustomerIdAndDate(Long customerId, LocalDate date);
    Integer countByDate(LocalDate date);
    List<Attendance> findByDate(LocalDate localDate);
    @Query("SELECT a.customerId FROM Attendance a WHERE a.date = :date")
    List<Long> getCustomerIdByDate(@Param("date") LocalDate date);
}
