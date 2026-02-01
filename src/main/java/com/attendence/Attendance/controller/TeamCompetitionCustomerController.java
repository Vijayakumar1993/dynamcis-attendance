package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Team;
import com.attendence.Attendance.entity.TemCompetionCustomer;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.CompetitionService;
import com.attendence.Attendance.services.TeamServices;
import com.attendence.Attendance.services.TemCompetionCustomerServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("fixtureGateway")
public class TeamCompetitionCustomerController {

    @Autowired
    private TemCompetionCustomerServices services;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private TeamServices teamServices;

    @PostMapping("createTeamCompCustomer")
    public String createTeamCompetitionCustomer(@RequestParam(value = "teamId", required = false) String teamId
            , @RequestParam(value = "compId",required = false) String competitionId
            , @RequestParam(value = "customer", required = false) String customer, Model model){

        Team team = teamServices.findTeam(Long.parseLong(teamId));
        Optional<Customer> customer1 = customerRepostitary.findById(Long.parseLong(customer));
        customer1.ifPresent(customer2 -> {
            List<TemCompetionCustomer> existingTemCompetionCustomers = services.findByTeamAndCustomer(team,customer2);
            if(!existingTemCompetionCustomers.isEmpty())
                services.removeByTemCompetionCustomer(existingTemCompetionCustomers);
        });
        if(competitionId!=null && !competitionId.isBlank() && !competitionId.isEmpty()){
            Arrays.stream(competitionId.split(",")).forEach(compId->{
                TemCompetionCustomer temCompetionCustomer = new TemCompetionCustomer();
                temCompetionCustomer.setCompetition(competitionService.find(Long.parseLong(compId)));
                temCompetionCustomer.setCustomer(customer1.get());
                temCompetionCustomer.setTeam(team);
                services.save(temCompetionCustomer);
            });
        }
        return "redirect:/teams/viewTeam/"+teamId;
    }
}
