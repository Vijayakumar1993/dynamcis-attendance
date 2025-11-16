package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Attendance;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface AttendanceRepositary extends CrudRepository<Attendance,Long> {
    List<Attendance> findAll();
}
