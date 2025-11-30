package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface CustomerRepostitary extends JpaRepository<Customer, Long> {
    List<Customer> findByNameContaining(String name);
    @Query("""
SELECT c FROM Customer c
WHERE (:name IS NULL OR LOWER(c.name) LIKE LOWER(CONCAT('%', :name, '%')))
AND   (:email IS NULL OR LOWER(c.email) LIKE LOWER(CONCAT('%', :email, '%')))
AND   (:phone IS NULL OR LOWER(c.phone) LIKE LOWER(CONCAT('%', :phone, '%')))
AND   (:gender IS NULL OR LOWER(c.gender) = LOWER(:gender))
AND   (:status IS NULL OR LOWER(c.status) = LOWER(:status))
AND   (:guardianName IS NULL OR LOWER(c.guardianName) = LOWER(:guardianName))
AND   (:createdBy IS NULL OR LOWER(c.status) = LOWER(:createdBy))
AND   (:pack IS NULL OR LOWER(c.pack) = LOWER(:pack))
""")
    List<Customer> searchCustomer(
            @Param("name") String name,
            @Param("email") String email,
            @Param("phone") String phone,
            @Param("gender") String gender,
            @Param("status") String status,
            @Param("guardianName") String guardianName,
            @Param("createdBy") String createdBy,
            @Param("pack") String pack
    );

    List<Customer> findByJoiningDateBetween(LocalDate from, LocalDate to);
    List<Customer> findByPhone(String phone);
}
