package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompetitionRepositary extends JpaRepository<Competition, Long> {
    List<Competition> findByStatus(CompetitionStatus competitionStatus);
    List<Competition> findByCreatedBy(Customer createdBy);
    @Modifying
    @Query("update Competition c set c.createdBy = null where c.createdBy = :customer")
    void clearCreatedBy(Customer customer);


    // Year-wise competition count
    @Query("""
           SELECT YEAR(c.competitionDate), COUNT(c)
           FROM Competition c
           GROUP BY YEAR(c.competitionDate)
           ORDER BY YEAR(c.competitionDate)
           """)
    List<Object[]> countCompetitionsByYear();

    @Query("""
       SELECT YEAR(c.competitionDate),
              MONTH(c.competitionDate),
              COUNT(c)
       FROM Competition c
       GROUP BY YEAR(c.competitionDate),
                MONTH(c.competitionDate)
       ORDER BY YEAR(c.competitionDate),
                MONTH(c.competitionDate)
       """)
    List<Object[]> countCompetitionsByMonthYear();
}
