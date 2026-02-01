package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Corner;
import com.attendence.Attendance.constants.Status;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.services.MatchService;
import com.attendence.Attendance.services.MedalReportService;
import com.attendence.Attendance.util.EventUtility;
import com.attendence.Attendance.util.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/matches")
public class MatchesController {

    @Autowired
    private MatchService matchService;

    @Autowired
    private MedalReportService medalReportService;

    @Autowired
    private EventUtility utility;

    @Autowired
    private Utility commonUtility;

    @GetMapping("")
    public String match(){
        return "viewMatches";
    }

    @GetMapping("/viewMatchPair/{matchId}")
    public String viewMatchPair(@PathVariable("matchId") String matchId, Model model){
        Match match = matchService.findMatch(Long.parseLong(matchId));
        if(match!=null){
            Customer customer1 = match.getFrom().getCustomerId();
            model.addAttribute("corner1",customer1);

            Customer customer2 = match.getTo().getCustomerId();
            model.addAttribute("corner2", customer2);
        }

        return "viewMatchPair";
    }
    @GetMapping("viewMatch/{id}")
    public String match(@PathVariable("id") String id, Model model){
        Event event = utility.getEvent(Long.parseLong(id));
        List<Event> parentEvents = utility.findListOfEvents(event);
        List<Match> matches = matchService.findByEvent(event);
        List<Fixture> fromFixtures = matches.stream().map(Match::getFrom).toList();
        List<Fixture> toFixtures = matches.stream().map(Match::getTo).toList();

        if(!matches.isEmpty()){
            model.addAttribute("matches", matches);
            var palyersList = new LinkedHashSet<>();
            palyersList.addAll(fromFixtures);
            palyersList.addAll(toFixtures);
            model.addAttribute("players",palyersList);
            List<Match> byes = matches.stream().filter(Match::getBye).toList();
            List<Match> nonByes = matches.stream().filter(m->!m.getBye()).toList();
            model.addAttribute("byes", byes);
            model.addAttribute("openMatches", nonByes.stream().filter(match -> match.getSuccessor()==null).toList());
            model.addAttribute("closedMatches", nonByes.stream().filter(match -> match.getSuccessor()!=null).toList());
        }
        model.addAttribute("event", event);
        return "viewMatches";
    }
    @PostMapping("removeMatchSuccessor")
    public String removeSuccessor(@RequestParam("event") String event, @RequestParam("match") String matchId){
        Match match = matchService.findMatch(Long.parseLong(matchId));
        if(match!=null){
            match.setSuccessor(null);
            match.setSuccessorCorner(null);
        }
        matchService.createMatch(match);
        return "redirect:/matches/viewMatch/"+event+"#"+match.getMatchId();
    }

    @PostMapping("updateMatch")
    public String match(@RequestParam("event") String event,@RequestParam("corner") String corner, @RequestParam("match") String matchId, @RequestParam("successor") String fixtureId){
        Match match = matchService.findMatch(Long.parseLong(matchId));
        if(match!=null){
            match.setSuccessor(utility.getFixture(Long.parseLong(fixtureId)));
            match.setSuccessorCorner(Corner.valueOf(corner));
        }
        matchService.createMatch(match);
        return "redirect:/matches/viewMatch/"+event+"#"+match.getMatchId();
    }

    @PostMapping("updateMatchFixture")
    public String updateMatchFixture(
            @RequestParam("event") String event,
            @RequestParam("matchId") String matchId,
            @RequestParam("from") String from,
            @RequestParam("to") String to,
            RedirectAttributes redirectAttributes) {

        Match match = matchService.findMatch(Long.parseLong(matchId));
        if (match == null) {
            redirectAttributes.addFlashAttribute("error_msg", "Match not found.");
            return "redirect:/matches/viewMatch/" + event;
        }

        Fixture fromFixture = utility.getFixture(Long.parseLong(from));
        Fixture toFixture   = utility.getFixture(Long.parseLong(to));

        if (fromFixture.getId().equals(toFixture.getId())) {
            redirectAttributes.addFlashAttribute(
                    "error_msg",
                    "Fixture can't be editable with the same opponent."
            );
            return "redirect:/matches/viewMatch/" + event;
        }

        List<Match> existingMatches = matchService
                .findByEvent(utility.getEvent(Long.parseLong(event)))
                .stream()
                .filter(m -> !m.getMatchId().equals(match.getMatchId()))
                .toList();

        for (Match m : existingMatches) {

            boolean updated = false;

            if (m.getFrom().equals(fromFixture)) {
                m.setFrom(match.getFrom());
                updated = true;
            } else if (m.getFrom().equals(toFixture)) {
                m.setFrom(match.getTo());
                updated = true;
            }

            if (m.getTo().equals(fromFixture)) {
                m.setTo(match.getFrom());
                updated = true;
            } else if (m.getTo().equals(toFixture)) {
                m.setTo(match.getTo());
                updated = true;
            }

            handleBye(m);

            if (updated) {
                matchService.createMatch(m);
            }
        }

        match.setFrom(fromFixture);
        match.setTo(toFixture);
        handleBye(match);
        matchService.createMatch(match);

        return "redirect:/matches/viewMatch/" + event + "#" + match.getMatchId();
    }
    private void handleBye(Match match) {
        if (match.getFrom().equals(match.getTo())) {
            match.setBye(true);
            match.setSuccessor(match.getFrom());
        } else {
            match.setBye(false);
            match.setSuccessor(null);
        }
    }


    @GetMapping("/openEvent/{id}")
    public String openEvent(@PathVariable("id") String id, RedirectAttributes redirectAttributes, Model model){
        Event evnt = utility.getEvent(Long.parseLong(id));
        if(evnt!=null){
            evnt.setStatus(Status.OPEN);
            utility.createEvent(evnt);
            return "redirect:/matches/viewMatch/"+id;
        }
        return "redirect:/matches/viewMatch/"+id;
    }
    @GetMapping("/shuffleEvent/{id}")
    public String shuffleEvent(@PathVariable("id") String id, RedirectAttributes redirectAttributes, Model model){
        Event evnt = utility.getEvent(Long.parseLong(id));

        //ensure that the match not started
        if(evnt!=null){
            utility.shuffleEvent(evnt);
            return "redirect:/matches/viewMatch/"+id;
        }
        return "redirect:/matches/viewMatch/"+id;
    }


    @PostMapping("closeEvent")
    public String closeEvent(@RequestParam("event") String event, @RequestParam("description") String description, RedirectAttributes redirectAttributes, Model model){
        Event evnt = utility.getEvent(Long.parseLong(event));
        if(evnt!=null) {
            if (evnt.getStatus().equals(Status.CLOSE)) {
                redirectAttributes.addFlashAttribute("error_msg", "Fixture " + evnt.getId() + " already closed.");
                return "redirect:/matches/viewMatch/" + event;
            }


            evnt.setStatus(Status.CLOSE);
            utility.createEvent(evnt);

            //now lets initiate second event
            List<Match> matches = matchService.findByEvent(evnt);
            if (evnt.getRoundOf() == 2) {
                MedalReport medalReport = medalReportService.findFirstByWeightDefinationAndCategoryDefinationAndGenderDefinationAndCompetition
                        (evnt.getWeightDefination(), evnt.getCategoryDefination(), evnt.getGenderDefination(), evnt.getCompetition());
                if (medalReport == null) {
                    medalReport = new MedalReport();
                    medalReport.setCompetition(evnt.getCompetition());
                    medalReport.setCategoryDefination(evnt.getCategoryDefination());
                    medalReport.setGenderDefination(evnt.getGenderDefination());
                    medalReport.setWeightDefination(evnt.getWeightDefination());
                    medalReport.setEvent(evnt);
                }
                Optional<Match> match = matches.stream().findFirst();
                if(match.isPresent()){
                    Match match1 = match.get();
                    if(!match1.getBye()){
                        Fixture sucessor = match1.getSuccessor();
                        medalReport.setGold(sucessor.getCustomerId());
                        medalReport.setSilver(match1.getSuccessor().equals(match1.getFrom())?match1.getTo().getCustomerId():match1.getFrom().getCustomerId());
                        medalReportService.create(medalReport);
                    }
                }
            }

            if (evnt.getRoundOf() == 4) {
                if(matches.size()==2){
                    //update medal details
                    MedalReport medalReport = medalReportService.findFirstByWeightDefinationAndCategoryDefinationAndGenderDefinationAndCompetition
                            (evnt.getWeightDefination(), evnt.getCategoryDefination(), evnt.getGenderDefination(), evnt.getCompetition());
                    if (medalReport == null) {
                        medalReport = new MedalReport();
                        medalReport.setCompetition(evnt.getCompetition());
                        medalReport.setCategoryDefination(evnt.getCategoryDefination());
                        medalReport.setGenderDefination(evnt.getGenderDefination());
                        medalReport.setWeightDefination(evnt.getWeightDefination());
                        medalReport.setEvent(evnt);
                    }

                    Match match = matches.get(0);
                    Match match1 = matches.get(1);
                    if(match!=null && !match.getBye()){
                        medalReport.setBronze1(match.getSuccessor().equals(match.getFrom())?match.getTo().getCustomerId(): match.getFrom().getCustomerId());
                        medalReportService.create(medalReport);
                    }
                    if(match1!=null && !match1.getBye()){
                        medalReport.setBronze2(match1.getSuccessor().equals(match1.getFrom())?match1.getTo().getCustomerId(): match1.getFrom().getCustomerId());
                        medalReportService.create(medalReport);
                    }
                }
            }



            List<Fixture> newFixtures = matches.stream().map(Match::getSuccessor).toList();
            if (!newFixtures.isEmpty()) {
                if (newFixtures.size() <= 1) {
                    redirectAttributes.addFlashAttribute("success_msg", "Fixture " + evnt.getId() + " having no more players. So new Fixture not able to create.");
                    return "redirect:/matches/viewMatch/" + event;
                }
                Event newEvent = new Event();
                newEvent.setCategoryDefination(evnt.getCategoryDefination());
                newEvent.setWeightDefination(evnt.getCategoryDefination());
                newEvent.setParentEventId(evnt);
                newEvent.setEventDate(LocalDate.now());
                newEvent.setWeightDefination(evnt.getWeightDefination());
                newEvent.setGenderDefination(evnt.getGenderDefination());
                newEvent.setPrevEvent(evnt);
                newEvent.setDescription(evnt.getDescription());
                newEvent.setCompetition(evnt.getCompetition());
                if (!description.isEmpty())
                    newEvent.setDescription(description);
                utility.createEvent(newEvent, newFixtures);
                utility.createOrUpdateMatchWithEvent(newEvent, false);
                evnt.setNextEvent(newEvent);
                utility.createEvent(evnt);
                return "redirect:/matches/viewMatch/" + newEvent.getId();
            }
        }
        return "redirect:/matches/viewMatch/"+event;
    }
}
