package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Authorities;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthoritiesRepositary extends JpaRepository<Authorities, Long> {
}
