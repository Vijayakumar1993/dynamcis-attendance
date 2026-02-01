package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Team;
import com.attendence.Attendance.entity.TemCompetionCustomer;
import com.attendence.Attendance.repostitary.TemCompetionCustomerRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class TemCompetionCustomerServices {

    @Autowired
    private TemCompetionCustomerRepositary repositary;


    public TemCompetionCustomer save(TemCompetionCustomer temCompetionCustomer){
        return repositary.save(temCompetionCustomer);
    }
    public List<TemCompetionCustomer> findByTeamAndCompetitionAndCustomer(Team team, Customer customer, Competition competition){
        return repositary.findByTeamAndCompetitionAndCustomer(team,competition,customer);
    }
    public Optional<TemCompetionCustomer> findByTeamAndCompetitionAndCustomerFindFirst(Team team, Customer customer, Competition competition){
        return repositary.findByTeamAndCompetitionAndCustomer(team,competition,customer).stream().findFirst();
    }
    public List<TemCompetionCustomer> findByTeamAndCustomer(Team team, Customer customer){
        return repositary.findByTeamAndCustomer(team,customer);
    }
    public List<TemCompetionCustomer> findByCustomer(Customer customer){
        return repositary.findByCustomer(customer);
    }
    public List<TemCompetionCustomer> removeByCompetitionAndTeam(Competition competition,Team team ){
        return repositary.removeByCompetitionAndTeam(competition, team);
    }

    public List<TemCompetionCustomer> findByCompetition(Competition competition){
        return repositary.findByCompetition(competition);
    }
    public void removeByTemCompetionCustomer(List<TemCompetionCustomer> competionCustomerList){
        repositary.deleteAll(competionCustomerList);
    }

    @Transactional
    public void removeByCompetition(Competition competition){
        repositary.deleteByCompetition(competition);
    }

    @Transactional
    public void remove(Long id){
        repositary.deleteById(id);
    }
}
