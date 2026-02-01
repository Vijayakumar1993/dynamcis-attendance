package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.services.CompetitionService;
import com.attendence.Attendance.services.TeamServices;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("teams")
public class TeamController {

    @Autowired
    private TeamServices teamServices;

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private Utility utility;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private CompetitionService competitionService;

    @GetMapping("")
    public String index( Model model){
        model.addAttribute("teams", teamServices.findTeams());
        return "createTeam";
    }

    @PostMapping("/createTeam")
    public String createTeam(@RequestParam("customerId") String customerId, @ModelAttribute Team team, HttpSession session, Model model){
        Customer userLogin = (Customer) session.getAttribute("userLogin");
        if(!utility.validateCustomerId(customerId,model))
        {
            return "createTeam";
        }
        if(!teamServices.isValidCustomerId(Long.parseLong(customerId)) && team.getId()==null)
        {
            model.addAttribute("error_msg","Mentioned Couch already associated with Team, Please check.");
            return "createTeam";
        }
        team.setCreatedBy(userLogin);
        team.setCustomer(customerRepostitary.findById(Long.parseLong(customerId)).get());

        teamServices.create(team);
        Customer customer = customerRepostitary.findById(Long.parseLong(customerId)).get();
        customer.setTeam(team);
        customerRepostitary.save(customer);
        model.addAttribute("success_msg","Team details created/update successfully...!");
        return "redirect:/teams/viewTeams";
    }

    @GetMapping("/viewTeams")
    public String viewTeams(HttpSession session, Model model){
        Boolean isCoach = utility.getCurrentUserRoles().contains("ROLE_COACH");
        Boolean isAdmin = utility.getCurrentUserRoles().contains("ROLE_ADMIN");
        if(isCoach && !isAdmin){
            Customer customer = (Customer) session.getAttribute("userLogin");
            Team team = customer.getTeam();
            if(team!=null){
                model.addAttribute("teams", List.of(customer.getTeam()));
            }else{
                model.addAttribute("teams", List.of());
            }
        }else{
            model.addAttribute("teams", teamServices.findTeams());
        }
        return "listTeams";
    }

    @PostMapping("/selection")
    public String selection(@RequestParam(value = "competitions", required = false) String competitions,
                            @RequestParam(value = "team", required = false) String id,@RequestParam(value = "gender", required = false) String gender
            , @RequestParam(value = "category", required = false) String category,
                            @RequestParam(value = "from", required = false) String from,
                            @RequestParam(value = "to", required = false) String to, Model model){
        model.addAttribute("gender", gender);
        model.addAttribute("category", category);
        model.addAttribute("from", from);
        model.addAttribute("to", to);
        Team team = teamServices.findTeam(Long.parseLong(id));
        if (gender != null && gender.isBlank()) gender = null;
        if (category != null && category.isBlank()) category = null;
        if (from != null && from.isBlank()) from = "0";
        if (to != null && to.isBlank()) to = "100000";
        if(competitions!=null && !competitions.isBlank() && !competitions.isEmpty()){
            Competition competition = competitionService.find(Long.parseLong(competitions));
            model.addAttribute("selectedCompetition", competition);
            Set<CompetitionCategories> competitionCategories = competition.getCompetitionCategories();
            if(competitionCategories!=null && competitionCategories.size()>0){
                List<String> categories = competitionCategories.stream()
                        .map(CompetitionCategories::getCategory)
                        .map(Configuration::getConfigId)
                        .map(Object::toString).toList();
                List<Customer> customers = repostitary.filterCustomers(team,gender,category,Float.parseFloat(from),Float.parseFloat(to));
                customers = customers.stream().filter(customer->categories.contains(customer.getCategory())).toList();

                customers = customers.stream().filter(customer->{
                    List<Authorities> authorities = authorityServices
                            .findByCustomerId(customer.getId());
                    return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.ROLE_PLAYER);
                }).toList();
                model.addAttribute("customers", customers);
                model.addAttribute("categories",competitionCategories.stream().map(CompetitionCategories::getCategory).toList());
            }
        }

        model.addAttribute("team", team);
        return "viewTeam";
    }

    @GetMapping("/viewTeam/{id}")
    public String viewTeam(@PathVariable("id") String id, HttpSession session, Model model){
        Team team = teamServices.findTeam(Long.parseLong(id));
        var op = utility.isCoachAccess((Customer) session.getAttribute("userLogin"),id);
        if(!op){
            return "error";
        }

        model.addAttribute("team", team);
//        model.addAttribute("customers", utility.filterByRoles(repostitary.findByTeam(team), Roles.ROLE_PLAYER));
        return "viewTeam";
    }

    @GetMapping("/edit/{id}")
    public String createTeam(@PathVariable("id") String id, Model model){
        model.addAttribute("team", teamServices.findTeam(Long.parseLong(id)));
        return "createTeam";
    }
    @GetMapping("/delete/{id}")
    @Transactional
    public String deleteTeam(@PathVariable("id") String id, Model model){
        Team team = teamServices.findTeam(Long.parseLong(id));
        if(team!=null){
            Set<CompetitionTeam> competionTeams = team.getCompetitions();
            if(competionTeams.size()>0){
                model.addAttribute(
                        "error_msg",
                        "Still Team is engaged with Competition, You can't remove until you remove the competition."
                );
            }else {
                customerRepostitary.findByTeam(team).forEach(customer -> {
                    customer.setTeam(null);
                    customerRepostitary.save(customer);
                });
                teamServices.removeByTeam(team);
            }

        }
        model.addAttribute("teams", teamServices.findTeams());
        return "listTeams";
    }
}
