package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepostitary extends JpaRepository<Customer, Integer> {
}
