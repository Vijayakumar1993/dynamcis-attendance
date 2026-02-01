package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Team;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeamRepositary extends JpaRepository<Team, Long> {
     List<Team> findByCustomer(Customer customer);
     List<Team> findByCreatedBy(Customer customer);

    @Modifying
    @Query("update Team t set t.createdBy = null where t.createdBy = :customer")
    void clearCreatedBy(Customer customer);
}
