package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.LeadFollowUp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface LeadFollowUpRepository
        extends JpaRepository<LeadFollowUp, Long> {

    List<LeadFollowUp> findByLeadOrderByCallDateDesc(Customer lead);
    List<LeadFollowUp> findByStatus(Configuration status);
    List<LeadFollowUp> findByNextCallDateGreaterThanEqualOrderByNextCallDateAsc(LocalDate date);
    List<LeadFollowUp> findByNextCallDateLessThanOrderByNextCallDateDesc(LocalDate date);

    @Query("""
   SELECT f FROM LeadFollowUp f
   WHERE f.id IN (
       SELECT MAX(f2.id)
       FROM LeadFollowUp f2
       GROUP BY f2.lead.id
   )
""")
    List<LeadFollowUp> findLatestFollowUpPerLead();

    @Query("""
SELECT f.callDate, COUNT(f)
FROM LeadFollowUp f
GROUP BY f.callDate
ORDER BY f.callDate DESC
""")
    List<Object[]> dailyActivity();

    @Query("""
SELECT f.status.configValue, COUNT(f)
FROM LeadFollowUp f
GROUP BY f.status
""")
    List<Object[]> statusSummary();
    @Query("""
SELECT f.interest.configValue, COUNT(f)
FROM LeadFollowUp f
GROUP BY f.interest
""")
    List<Object[]> interestSummary();
    @Query("""
SELECT f.createdBy.name, COUNT(f)
FROM LeadFollowUp f
 WHERE f.status.id = :convertedId
GROUP BY f.createdBy
""")
    List<Object[]> conversionByUser(@Param("convertedId") Long convertedId);
    @Query("""
SELECT f.lead.name, MIN(f.callDate), MAX(f.callDate)
FROM LeadFollowUp f
WHERE f.status.id = :convertedId
GROUP BY f.lead.id
""")
    List<Object[]> conversionTime(@Param("convertedId") Long convertedId);

    void removeByLead(Customer customer);
    @Modifying
    @Query("""
update LeadFollowUp t 
set t.createdBy = null 
where (:customer is not null and t.createdBy = :customer)
""")
    int clearCreatedBy(Customer customer);


}
