package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Team;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.TeamRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TeamServices {

    @Autowired
    private TeamRepositary teamRepositary;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    public Team create(Team team){
        return  teamRepositary.save(team);
    }

    public List<Team> findTeams(){
        return teamRepositary.findAll();
    }

    public Team findTeam(Long id){
        return teamRepositary.findById(id).orElse(null);
    }

    public List<Team> findTeamByCustomerId(Long custoemrId){
        return teamRepositary.findByCustomer(customerRepostitary.findById(custoemrId).get());
    }
    public List<Team> findByCreatedBy(Customer createdBy){
        return teamRepositary.findByCreatedBy(createdBy);
    }
    public Boolean isValidCustomerId(Long customerId){
        return findTeamByCustomerId(customerId).isEmpty();
    }
    public void clearCreatedBy(Customer customer){
        teamRepositary.clearCreatedBy(customer);
    }
    @Transactional
    public void removeByTeam(Team team){
        teamRepositary.delete(team);
    }

}
