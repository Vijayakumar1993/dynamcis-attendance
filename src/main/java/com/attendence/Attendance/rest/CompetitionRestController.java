package com.attendence.Attendance.rest;

import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.CompetitionService;
import com.attendence.Attendance.services.TeamServices;
import com.attendence.Attendance.services.TemCompetionCustomerServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class CompetitionRestController {


    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private TemCompetionCustomerServices services;

    @Autowired
    private TeamServices teamServices;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("/categories/{compId}")
    public List<Configuration> getCategories(@PathVariable Long compId) {
        Set<CompetitionCategories> competitionCategories = competitionService.find(compId).getCompetitionCategories();
        return competitionCategories.stream().map(CompetitionCategories::getCategory).toList();
    }
    @PostMapping("/createTeamCompCustomer")
    @ResponseBody
    public String createTeamCompetitionCustomer(
            @RequestParam(value = "remove", required = false) Boolean isChecked,
            @RequestParam(value = "teamId", required = false) String teamId,
            @RequestParam(value = "compId", required = false) String competitionId,
            @RequestParam(value = "customer", required = false) String customer) {

        Team team = teamServices.findTeam(Long.parseLong(teamId));
        Optional<Customer> customer1 = customerRepostitary.findById(Long.parseLong(customer));
        customer1.ifPresent(customer2 -> {
            List<TemCompetionCustomer> existing = services.findByTeamAndCustomer(team, customer2);
            if (!existing.isEmpty())
                services.removeByTemCompetionCustomer(existing);
        });

        if (competitionId != null && !competitionId.isBlank()) {
            Competition competition = competitionService.find(Long.parseLong(competitionId));
            if(isChecked!=null && isChecked){
                services
                        .findByTeamAndCompetitionAndCustomerFindFirst(team,customer1.get(),competition)
                        .stream()
                        .toList()
                        .forEach(temCompetionCustomer -> services.remove(temCompetionCustomer.getId()));
            }else{
                TemCompetionCustomer entry = new TemCompetionCustomer();
                entry.setCompetition(competition);
                entry.setCustomer(customer1.get());
                entry.setTeam(team);
                services.save(entry);
            }

        }
        return "saved";   // JS will read this
    }

    @GetMapping("db")
    public Map<String, Object> getDatabaseSize() {
        String sql = "SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb "
                + "FROM information_schema.tables "
                + "WHERE table_schema = DATABASE()";
        Double sizeMb = jdbcTemplate.queryForObject(sql, Double.class);
        Map<String, Object> map = new HashMap<>();
        map.put("database", jdbcTemplate.queryForObject("SELECT DATABASE()", String.class));
        map.put("size_mb", sizeMb);
        return map;
    }
}
