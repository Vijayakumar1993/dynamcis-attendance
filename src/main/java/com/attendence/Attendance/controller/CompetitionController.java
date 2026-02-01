package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.constants.CompetitionTeamStatus;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.services.*;
import com.attendence.Attendance.util.EventUtility;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("competition")
public class CompetitionController {

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private MedalReportService medalReportService;

    @Autowired
    private CompetitionTeamService competitionTeamService;

    @Autowired
    private CompetitionCategoriesService competitionCategoriesService;

    @Autowired
    private TemCompetionCustomerServices temCompetionCustomerServices;


    @Autowired
    private EventUtility eventUtility;

    @Autowired
    private Utility utility;

    @Autowired
    private EventServices eventServices;

    @Autowired
    private TeamServices teamServices;

    @GetMapping("createCompetition")
    public String createCompetion(){
        return "createCompetition";
    }
    @PostMapping("createCompetition")
    @Transactional
    public String createCompetion(@RequestParam(value = "requestedTeams", required = false) List<Long> teamIds,
                                  @RequestParam(value = "categories", required = false) List<Long> categoryIds,
                                  HttpSession session,@RequestParam(value = "matchImage", required = false)  MultipartFile image ,  @ModelAttribute Competition competition) throws IOException {
        List<CompetitionTeam> competitionTeams = new LinkedList<>();
        Customer customer = (Customer) session.getAttribute("userLogin");

        competition.setCreatedBy(customer);
        if(competition.getId()==null)
            competition.setStatus(CompetitionStatus.INPROGRESS);

        if (image != null && !image.isEmpty()) {
            competition.setImage(image.getBytes());
        }else{
            if(competition!=null && competition.getId()!=null){
                Competition existingCompetition = competitionService.find(competition.getId());
                if (existingCompetition.getImage() != null) {
                    competition.setImage(existingCompetition.getImage());
                }if (existingCompetition.getStatus() != null) {
                    competition.setStatus(existingCompetition.getStatus());
                }
            }
        }

        Competition competition1 = competitionService.create(competition);

        List<Long> existingCompetitionTeams = competitionTeamService.findByCompetition(competition1).stream()
                .map(CompetitionTeam::getTeam)
                .map(Team::getId).toList();
        if(existingCompetitionTeams.size()>0){
            existingCompetitionTeams.stream()
                    .filter(item -> !teamIds.contains(item))
                    .forEach(competitionTeam->{
                        Team team = teamServices.findTeam(competitionTeam);
                        if(team!=null){
                            temCompetionCustomerServices.removeByCompetitionAndTeam(competition1,team );
                            competitionTeamService.deleteByCompetitionAndTeam(competition1, team);
                        }
                    });
        }


        if(teamIds!=null && teamIds.size()>0){
            competitionTeams = teamIds.stream()
                    .filter(team->!existingCompetitionTeams.contains(team))
                    .map(team->{
                        CompetitionTeam competitionTeam = new CompetitionTeam();
                        competitionTeam.setCompetition(competition1);
                        competitionTeam.setTeam(teamServices.findTeam(team));
                        competitionTeam.setRequestedDate(LocalDate.now());
                        competitionTeam.setStatus(CompetitionTeamStatus.REQUESTED);
                        competitionTeam.setRemarks(competition.getRemarks());
                        return competitionTeam;
                    }).toList();

        }else{
            //if any old measn lets remove because it is not required in the competition.
            competitionTeamService.removeCompetitionTEams();
        }


        //remove exisiting categories if we have
        competitionCategoriesService.removeByCompetition(competition);

        //create competition categories
        categoryIds.forEach(category->{
            CompetitionCategories competitionCategories = new CompetitionCategories();
            competitionCategories.setCompetition(competition);
            competitionCategories.setCategory(utility.getConfig(category));
            competitionCategoriesService.create(competitionCategories);
        });

        if(!competitionTeams.isEmpty())
            competitionTeamService.createAll(competitionTeams);
        return "redirect:/competition/display/"+competition1.getId();
    }

    @GetMapping("display/{id}")
    public String createCompetion(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        Map<String,String> medals = new LinkedHashMap<>();
        if(competition!=null){
            Event event = new Event();
            event.setCompetition(competition);
            List<Event> events = eventUtility.filterEvents(event);

            List<MedalReport> medalReports = medalReportService.findByCompetition(competition);

            Map<Team, Map<String, Long>> teamMedals = new LinkedHashMap<>();

            medalReports.forEach(report -> {

                if (report.getGold() != null) {
                    Team team = report.getGold().getTeam();
                    teamMedals
                            .computeIfAbsent(team, t -> new LinkedHashMap<>())
                            .merge("GOLD", 1L, Long::sum);
                }

                if (report.getSilver() != null) {
                    Team team = report.getSilver().getTeam();
                    teamMedals
                            .computeIfAbsent(team, t -> new LinkedHashMap<>())
                            .merge("SILVER", 1L, Long::sum);
                }

                if (report.getBronze1() != null) {
                    Team team = report.getBronze1().getTeam();
                    teamMedals
                            .computeIfAbsent(team, t -> new LinkedHashMap<>())
                            .merge("BRONZE1", 1L, Long::sum);
                }

                if (report.getBronze2() != null) {
                    Team team = report.getBronze2().getTeam();
                    teamMedals
                            .computeIfAbsent(team, t -> new LinkedHashMap<>())
                            .merge("BRONZE2", 1L, Long::sum);
                }
            });
            model.addAttribute("teamMedals", teamMedals);
            model.addAttribute("medalReports", medalReports);
            model.addAttribute("events", events);
        }
        model.addAttribute("competition", competition);


        return "viewCompetition";
    }
    @GetMapping("edit/{id}")
    public String editCompetition(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        model.addAttribute("competition", competition);
        return "createCompetition";
    }

    @GetMapping("listCompetition")
    public String listCompetition(Model model){
        List<Competition> competitions = competitionService.findAll();
        model.addAttribute("competitions", competitions);
        return "listCompetition";
    }
    @GetMapping("scheduleCompetition/{id}")
    public String updateCompetitionStatus(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        competition.setStatus(CompetitionStatus.SCHEDULED);
        competitionService.create(competition);
        return "redirect:/competition/listCompetition";
    }
    @GetMapping("scheduleInprogress/{id}")
    public String scheduleInprogress(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        competition.setStatus(CompetitionStatus.INPROGRESS);
        competitionService.create(competition);
        return "redirect:/competition/listCompetition";
    }
    @GetMapping("closeCompetition/{id}")
    public String closeCompetition(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        competition.setStatus(CompetitionStatus.COMPLETED);
        competitionService.create(competition);
        return "redirect:/competition/listCompetition";
    }
    @GetMapping("enrollCompetition/{id}")
    public String enrollCompetition(@PathVariable("id") String id, Model model){
        CompetitionTeam competition = competitionTeamService.findById(id);
        competition.setStatus(CompetitionTeamStatus.APPROVED);
        competitionTeamService.create(competition);
        return "redirect:/control/coachDashboard";
    }
    @GetMapping("revokeCompetition/{id}")
    public String revokeCompetition(@PathVariable("id") String id, Model model){
        CompetitionTeam competition = competitionTeamService.findById(id);
        competition.setStatus(CompetitionTeamStatus.REQUESTED);
        competitionTeamService.create(competition);
        return "redirect:/control/coachDashboard";
    }
    @GetMapping("rejectCompetition/{id}")
    public String rejectCompetition(@PathVariable("id") String id, Model model){
        CompetitionTeam competition = competitionTeamService.findById(id);
        competition.setStatus(CompetitionTeamStatus.REJECTED);
        competitionTeamService.create(competition);
        return "redirect:/control/coachDashboard";
    }

    @GetMapping("delete/{id}")
    @Transactional
    public String deleteCompetition(@PathVariable("id") String id, Model model){
        Competition competition = competitionService.find(Long.parseLong(id));
        if(competition!=null){

            //remove medal details
            medalReportService.removeByCompetition(competition);
            //remove the events.
            List<Event> removalEvents = eventServices.findByCompetitionAndParentEventId(competition,null);
            for(Event ev: removalEvents){
                eventUtility.removeEvents(ev.getId());
            }


            //fixture associated
            temCompetionCustomerServices.removeByCompetition(competition);

            //lets remove the team and competion association
            competitionTeamService.removeByCompetition(competition);
            competitionService.deleteById(competition.getId());

        }

        List<Competition> competitions = competitionService.findAll();
        model.addAttribute("competitions", competitions);
        return "redirect:/competition/listCompetition";
    }


}
