package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AttendanceRepositary extends JpaRepository<Attendance,Long> {
    List<Attendance> findAll();
    Integer deleteByCustomerIdAndDate(Customer customerId, LocalDate date);
    void deleteByCustomerId(Customer customerId);
    Integer countByDate(LocalDate date);
    List<Attendance> findByDate(LocalDate localDate);
    @Query("SELECT a.customerId FROM Attendance a WHERE a.date = :date")
    List<Customer> getCustomerIdByDate(@Param("date") LocalDate date);
    List<Attendance> findByCustomerIdOrderByDateDesc(Customer customerId);
    List<Attendance> findByCustomerIdAndDate(Customer customerId, LocalDate date);
    List<Attendance> findByDateBetween(LocalDate from, LocalDate to);
    List<Attendance> findByCreatedBy(String createdBy);
    @Modifying
    @Query("update Attendance a set a.createdBy = null where a.createdBy = :customerId")
    void clearCreatedBy(@Param("customerId") String customerId);

    @Modifying
    @Query("update Attendance a set a.customerId = null where a.customerId = :customer")
    void clearCustomer(@Param("customer") Customer customer);


    List<Attendance> findByDateBetweenAndCustomerId(LocalDate from, LocalDate to, Customer customer);

    @Query("""
SELECT a.date, COUNT(a)
FROM Attendance a
GROUP BY a.date
ORDER BY a.date DESC
""")
    List<Object[]> dailyAttendance();


    @Query("""
SELECT a.customerId.name, COUNT(a)
FROM Attendance a
GROUP BY a.customerId.name
ORDER BY COUNT(a) DESC
""")
    List<Object[]> attendanceByCustomer();
    @Query("""
SELECT FUNCTION('MONTH', a.date), COUNT(a)
FROM Attendance a
GROUP BY FUNCTION('MONTH', a.date)
ORDER BY FUNCTION('MONTH', a.date)
""")
    List<Object[]> monthlyAttendance();
    @Query("SELECT a FROM Attendance a WHERE a.date = :today")
    List<Attendance> todayAttendance(@Param("today") LocalDate today);
    @Query("""
SELECT c FROM Customer c
WHERE c.id NOT IN (
   SELECT a.customerId.id FROM Attendance a WHERE a.date = :today
)
""")
    List<Customer> absentees(@Param("today") LocalDate today);
    @Query("""
SELECT a.createdBy, COUNT(a)
FROM Attendance a
GROUP BY a.createdBy
""")
    List<Object[]> attendanceByStaff();
    @Query("""
SELECT a.date
FROM Attendance a
WHERE a.customerId.id = :customerId
ORDER BY a.date DESC
""")
    List<LocalDate> customerHistory(Long customerId);


}
