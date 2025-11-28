package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Configuration;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConfigurationRepostiary extends JpaRepository<Configuration, Long> {
}
