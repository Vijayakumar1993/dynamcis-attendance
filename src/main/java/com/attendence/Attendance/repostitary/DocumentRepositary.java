package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Documents;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DocumentRepositary extends JpaRepository<Documents, Long> {
    List<Documents> findByCustomerId(Long customerId);
}
