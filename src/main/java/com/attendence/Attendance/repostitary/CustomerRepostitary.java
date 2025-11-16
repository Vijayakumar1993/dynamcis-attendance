package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CustomerRepostitary extends JpaRepository<Customer, Long> {
    List<Customer> findByNameContaining(String name);
    @Query("""
SELECT c FROM Customer c
WHERE (:name IS NULL OR :name = '' OR LOWER(c.name) LIKE LOWER(CONCAT('%', :name, '%')))
AND   (:email IS NULL OR :email = '' OR LOWER(c.email) LIKE LOWER(CONCAT('%', :email, '%')))
AND   (:gender IS NULL OR :gender = '' OR LOWER(c.gender) LIKE LOWER(CONCAT('%', :gender, '%')))
AND   (:status IS NULL OR :status = '' OR LOWER(c.status) LIKE LOWER(CONCAT('%', :status, '%')))
""")
    List<Customer> searchCustomers(String name, String email, String gender, String status);
}
