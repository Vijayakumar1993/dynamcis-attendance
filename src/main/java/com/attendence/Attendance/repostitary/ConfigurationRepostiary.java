package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Configuration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ConfigurationRepostiary extends JpaRepository<Configuration, Long> {
    List<Configuration> findByConfigName(String configName);
    List<Configuration> findByConfigNameAndConfigKey(String configName, String configKey);
}
