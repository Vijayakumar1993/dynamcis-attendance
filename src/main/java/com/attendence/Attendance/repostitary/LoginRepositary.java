package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LoginRepositary extends JpaRepository<Users, Long> {
    List<Users> findByUsername(String username);
}
