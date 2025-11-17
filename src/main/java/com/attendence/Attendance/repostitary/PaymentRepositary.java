package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepositary extends JpaRepository<Payment,Long> {
    List<Payment> findByCustomerId(Long customerId);
    List<Payment> findByCustomerIdOrderByPaymentIdDesc(Long customerId);
}
