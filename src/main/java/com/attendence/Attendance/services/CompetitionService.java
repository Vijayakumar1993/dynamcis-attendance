package com.attendence.Attendance.services;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.CompetitionRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Month;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class CompetitionService {

    @Autowired
    private CompetitionRepositary repositary;

    public Competition create(Competition competition){
        return repositary.save(competition);
    }

    public  Competition find(Long id){
        return repositary.findById(id).get();
    }

    @Transactional
    public  void deleteById(Long id){
         repositary.deleteById(id);
    }
    public List<Competition> findAll(){
        return repositary.findAll();
    }
    public List<Competition> findByStatus(CompetitionStatus competitionStatus){
        return repositary.findByStatus(competitionStatus);
    }
    public List<Competition> findByCreatedBy(Customer createdBy){
         return repositary.findByCreatedBy(createdBy);
    }

    public void clearCreatedBy(Customer customer){
        repositary.clearCreatedBy(customer);
    }
    // Year-wise map (Year -> Count)
    public Map<Integer, Long> getCompetitionsByYear() {

        List<Object[]> results = repositary.countCompetitionsByYear();
        Map<Integer, Long> yearMap = new LinkedHashMap<>();

        for (Object[] row : results) {
            Integer year = ((Number) row[0]).intValue();
            Long count = ((Number) row[1]).longValue();
            yearMap.put(year, count);
        }

        return yearMap;
    }

    // Month-wise map (MonthName -> Count)
    public Map<String, Long> getCompetitionsByMonth(int year) {

        List<Object[]> results = repositary.countCompetitionsByMonthYear();
        Map<String, Long> monthMap = new LinkedHashMap<>();

        for (Object[] row : results) {
            int yearNumber = ((Number) row[0]).intValue();
            int monthNumber = ((Number) row[1]).intValue();
            Long count = ((Number) row[2]).longValue();

            String monthName = Month.of(monthNumber).name();
            monthMap.put(yearNumber+" - "+capitalize(monthName), count);
        }

        return monthMap;
    }

    private String capitalize(String text) {
        return text.charAt(0) + text.substring(1).toLowerCase();
    }
}
