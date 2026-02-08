package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.model.UploadResult;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.*;
import com.attendence.Attendance.util.EventUtility;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
@RequestMapping("/fixture")
public class FixtureController {

    private  final Logger log = LoggerFactory.getLogger(FixtureController.class);
    @Autowired
    private CustomerRepostitary customerRepostitary;


    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private TemCompetionCustomerServices services;

    @Autowired
    private FixtureServices fixtureServices;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private Utility utility;

    @Autowired
    private EventUtility eventUtility;

    @Autowired
    private MatchService matchService;

    @Autowired
    private PlayerUploadService playerUploadService;

    @GetMapping("")
    public String createFixture(Model model){
        List<Competition> competitions = competitionService.findByStatus(CompetitionStatus.SCHEDULED);
        model.addAttribute("competitions", competitions);
        return "createEvents";
    }

    @GetMapping("createPlayer")
    public String createPlayer(){
        return "createPlayer";
    }


    @GetMapping("createCoach")
    public String createCoach(){
        return "createCoach";
    }


    @PostMapping("viewFixtures")
    public String viewFixtures(@RequestParam(value = "category", required = false) String category,
                               @RequestParam(value = "gender", required = false) String gender,
                               @RequestParam(value="from", required = false) String from,
                               @RequestParam(value = "to", required = false) String to,
                               @RequestParam(value = "competitions", required = false) String compId,
                               Model model){

        List<Competition> competitions = competitionService.findByStatus(CompetitionStatus.SCHEDULED);
        model.addAttribute("competitions", competitions);
        model.addAttribute("compId", compId);
        Competition competition = competitionService.find(Long.parseLong(compId));
        if(competition!=null)
            model.addAttribute("categories",competition.getCompetitionCategories().stream().map(CompetitionCategories::getCategory).toList());

        model.addAttribute("category",category);
        model.addAttribute("from",from);
        model.addAttribute("gender",gender);
        model.addAttribute("to",to);
        if (gender != null && gender.isBlank()) gender = null;
        if (category != null && category.isBlank()) category = null;
        if (from != null && from.isBlank()) from = "0";
        if (to != null && to.isBlank()) to = "100000";
        model.addAttribute("customers",eventUtility.findCustomers(from,to,gender,category,compId));
        return "createEvents";
    }


    @PostMapping("/createFixture")
    public String createFixture(@RequestParam(value = "gender",required = false) String gender,
                                @RequestParam(value = "category", required = false) String category,
                                @RequestParam(value="from", required = false) String from,
                                @RequestParam(value = "to", required = false) String to,
                                @RequestParam(value = "compId", required = false) String compId,
                                @RequestParam(value = "description", required = false) String description,
                                RedirectAttributes model){

        if (gender != null && gender.isBlank()) gender = null;
        if (category != null && category.isBlank()) category = null;
        if (from != null && from.isBlank()) from = "0";
        if (to != null && to.isBlank()) to = "100000";

        List<Customer> customers = eventUtility.findCustomers(from,to,gender,category,compId);
        if(customers.size()<=1){
            model.addFlashAttribute("error_msg","Players count is not enough to create fixture, we expect at least 2 players to proceed");
            return "redirect:/fixture";
        }
        Event event = new Event();
        event.setEventDate(LocalDate.now());
        event.setDescription(description);
        event.setWeightDefination(utility.weightCombination(from,to));
        event.setCategoryDefination(category);
        event.setGenderDefination(gender);
        event.setCompetition(competitionService.find(Long.parseLong(compId)));
        eventUtility.createEvent(event, customers.stream().map(customer -> {
            Fixture fix = new Fixture();
            fix.setEventId(event);
            fix.setCustomerId(customer);
            fix.setEventDate(LocalDate.now());
            return fix;
        }).toList());
        eventUtility.createOrUpdateMatchWithEvent(event,false);
        return "redirect:/matches/viewMatch/"+event.getId();
    }

    @GetMapping("/removeFixture/{id}")
    public String deleteFixture(@PathVariable("id") Long id){
        fixtureServices.removeFixture(id);
        return "viewFixtures";
    }

    @PostMapping("/showFixtures")
    public String viewFixtures(@RequestParam(value = "show", required = false) Boolean show,Model model){
        List<Event> events = eventUtility.events();
        if(show!=null && show)
            events = events.stream().filter(x->x.getParentEventId()==null).toList();
        model.addAttribute("events", events);
        model.addAttribute("show", show);
        return "viewFixtures";
    }
    @GetMapping("/viewFixtures")
    public String viewFixtures(Model model){
        model.addAttribute("competitions",competitionService.findByStatus(CompetitionStatus.SCHEDULED));
        return "viewFixtures";
    }

    @GetMapping("deleteEvent/{id}")
    @Transactional
    public String deleteEvent(@PathVariable("id") String id, Model model) {
        model.addAttribute("competitions",competitionService.findByStatus(CompetitionStatus.SCHEDULED));
        eventUtility.removeEvents(Long.parseLong(id));
        return "viewFixtures";
    }


    @PostMapping("/filterFixtures")
    public String filterFixtures(@RequestParam(name = "show", required = false ) Boolean show, @ModelAttribute Event event, Model model){
        if(event.getCategoryDefination()!=null && event.getCategoryDefination().isEmpty() && event.getCategoryDefination().isBlank()) event.setCategoryDefination(null);
        if(event.getGenderDefination()!=null && event.getGenderDefination().isEmpty() && event.getGenderDefination().isBlank()) event.setGenderDefination(null);
        List<Event> events = eventUtility.filterEvents(event);
        if(show!=null && show)
            events = events.stream().filter(x->x.getParentEventId()==null).toList();
        model.addAttribute("competitions",competitionService.findByStatus(CompetitionStatus.SCHEDULED));
        model.addAttribute("events", events);
        model.addAttribute("event", event);
        model.addAttribute("show", show);

        Competition competition = event.getCompetition();
        if(competition!=null)
            model.addAttribute("categories",competition.getCompetitionCategories().stream().map(CompetitionCategories::getCategory).toList());

        return "viewFixtures";
    }
    @GetMapping("/upload")
    public String uploadPage() {
        return "uploadPlayers";
    }

    @PostMapping("/upload")
    public String uploadPlayers(
            @RequestParam("file") MultipartFile file,
            @RequestParam("teamId") Long teamId,
            @RequestParam("category") String category,
            HttpSession session,
            Model model) {

        UploadResult result = playerUploadService.processFile(file, teamId, category, session,model);
        model.addAttribute("successCount", result.successCount);
        model.addAttribute("failureCount", result.failureCount);
        model.addAttribute("errors", result.errors);


        return "uploadPlayers";
    }

    @GetMapping("/player-upload-template")
    public void downloadTemplate(HttpServletResponse response) throws Exception {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition",
                "attachment; filename=player_upload_template.csv");

        response.getWriter().write(
                "name,guardianName,phone,gender,email,dob,weight,address\n"
        );
    }

}
