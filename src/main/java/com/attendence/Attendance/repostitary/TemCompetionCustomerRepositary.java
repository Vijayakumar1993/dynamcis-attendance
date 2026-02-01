package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Team;
import com.attendence.Attendance.entity.TemCompetionCustomer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TemCompetionCustomerRepositary extends JpaRepository<TemCompetionCustomer, Long> {
    List<TemCompetionCustomer> findByTeamAndCompetitionAndCustomer(Team team, Competition competition, Customer customer);
    List<TemCompetionCustomer> findByTeamAndCustomer(Team team,  Customer customer);
    List<TemCompetionCustomer> findByCustomer(Customer customer);
    List<TemCompetionCustomer> findByCompetition(Competition competition);
    List<TemCompetionCustomer> removeByCompetitionAndTeam(Competition competition, Team team);
    int deleteByCompetition(Competition competition);
}
