package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Authorities;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthoritiesRepositary extends JpaRepository<Authorities, Long> {
    List<Authorities> findByUsername(String username);
    List<Authorities> findByCustomerId(Long customerId);
    int deleteByCustomerId(Long customerId);
}
