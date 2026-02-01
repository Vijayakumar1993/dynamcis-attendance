package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepositary extends JpaRepository<Payment,Long> {
    List<Payment> findByCustomerId(Customer customerId);
    void deleteByCustomerId(Customer customerId);
    List<Payment> findByCustomerIdAndStatusOrderByPaymentIdDesc(Customer customerId, String status);
    List<Payment> findByCustomerIdOrderByPaymentIdDesc(Customer customerId);
}
