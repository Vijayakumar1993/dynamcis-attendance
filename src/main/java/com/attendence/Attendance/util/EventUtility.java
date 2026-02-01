package com.attendence.Attendance.util;

import com.attendence.Attendance.constants.CompetitionTeamStatus;
import com.attendence.Attendance.constants.Corner;
import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.constants.Status;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.services.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import java.util.*;
import java.util.function.Function;

@Component
public class EventUtility {

    private Logger logger = LoggerFactory.getLogger(this.getClass().getName());

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private CompetitionService competitionService;


    @Autowired
    private EventServices eventServices;

    @Autowired
    private TemCompetionCustomerServices services;

    @Autowired
    private FixtureServices fixtureServices;

    @Autowired
    private MatchService matchService;

    @Autowired
    private MedalReportService medalReportService;

    public Event getEvent(Long id){
        return eventServices.findById(id);
    }
    @Transactional
    public Event createEvent(Event event){
        return eventServices.save(event);
    }

    public List<Event> events(){
        return eventServices.findAll();
    }

    public Fixture getFixture(Long id){
        return fixtureServices.findById(id);
    }
    public Event createEvent(Event event, Fixture fixture){
        Event event1 = createEvent(event);
        fixture.setEventId(event1);
        return event1;
    }

    public Event createEvent(Event event, List<Fixture> fixtureList){
        Event event1 = createEvent(event);
        fixtureList.stream().map(fixture -> {
            try {
                return (Fixture)fixture.clone();
            } catch (CloneNotSupportedException e) {
                throw new RuntimeException(e);
            }
        }).forEach(newFixture->{
            newFixture.setId(null);
            newFixture.setEventId(event1);
            fixtureServices.createFixture(newFixture);
        });
        return event1;
    }

    @Transactional
    public void deleteEvent(Event event){
        eventServices.removeById(event.getId());
    }


    public  Map<String, Integer> fixtureAndMatcher(int size){
        Function<Integer,Integer> powerOf = a-> (int)Math.pow((double) 2,a);
        int set = 2;
        Map<String, Integer> keyPair = new LinkedHashMap<>();
        for(int i=1; i<=size; i=i+1){
            set = powerOf.apply(i);
            if(set>=size){
                break;
            }
        }

        logger.info("Chosen Set "+set);
        Integer fixture = set-size;
        Integer matcher = size-fixture;
        keyPair.put("fixture",fixture);
        keyPair.put("matcher", matcher);
        keyPair.put("roundOf", set);
        return keyPair;
    }


    public boolean shuffleEvent(Event event){
        if(event!=null && event.getParentEventId()==null){
            matchService.deleteByEvent(event);
            createOrUpdateMatchWithEvent(event, true);
        }
        return true;
    }

    public boolean isEventStarted(Event event){
        List<Match> matches = matchService.findByEvent(event);
        return Optional.of(matches.stream().map(Match::getSuccessor)).isPresent();
    }
    public  void createOrUpdateMatchWithEvent(Event event, Boolean shuffle){
        List<Fixture> fixtures = fixtureServices.findByEvent(event);
        Map<String, Integer> keyPair = fixtureAndMatcher(fixtures.size());
        Integer fixtureSize = keyPair.get("fixture");
        Integer matcher = keyPair.get("matcher");
        Integer roundOf = keyPair.get("roundOf");

        logger.info("Matcher List " + matcher);
        logger.info("Fixture List "+fixtureSize);

        if(shuffle){
            Collections.shuffle(fixtures);
        }
        List<Fixture> matcherList = fixtures.subList(0,matcher);
        List<Fixture> fixtureList = fixtures.subList(matcher,fixtures.size());
        for(int i=0;i<matcherList.size();i=i+2){
            Match match = new Match();
            match.setEvent(event);
            match.setFromCorner(Corner.BLUE);
            match.setToCorner(Corner.RED);
            match.setBye(false);
            match.setFrom(matcherList.get(i));
            match.setTo(matcherList.get(i+1));
            matchService.createMatch(match);
        }

        //fixture matches
        for(int i=0;i<fixtureList.size();i=i+1){
            Fixture fr = fixtureList.get(i);
            Fixture tr = fixtureList.get(i);
            Match match = new Match();
            match.setEvent(event);
            match.setFromCorner(Corner.BLUE);
            match.setToCorner(Corner.RED);
            match.setSuccessorCorner(Corner.BLUE);
            match.setSuccessor(fr);
            match.setBye(true);
            match.setFrom(fr);
            match.setTo(tr);
            matchService.createMatch(match);
        }
        event.setStatus(Status.OPEN);
        event.setRoundOf(roundOf);
        eventServices.save(event);
    }


    public List<Event> findListOfEvents(Event event){
        List<Event> listOfEvents = new LinkedList<>();
        listOfEvents.add(event);
        while(event.getNextEvent()!=null){
            listOfEvents.add(event.getNextEvent());
            event = event.getNextEvent();
        }
        Collections.reverse(listOfEvents);
        return listOfEvents;
    }

    public List<Event> findListOfEventsNoReverse(Event event){
        List<Event> listOfEvents = new LinkedList<>();
        listOfEvents.add(event);
        while(event.getNextEvent()!=null){
            listOfEvents.add(event.getNextEvent());
            event = event.getNextEvent();
        }
        Collections.reverse(listOfEvents);
        return listOfEvents;
    }

    public List<Customer> findCustomers(String from, String to, String gender, String category, String compId){
        Competition competition = competitionService.find(Long.parseLong(compId));
        List<Team> competitionTeams = competition.getCompetitionTeams()
                .stream()
                .filter(competitionTeam -> competitionTeam.getStatus().equals(CompetitionTeamStatus.APPROVED))
                .map(CompetitionTeam::getTeam).toList();
        List<TemCompetionCustomer> temCompetionCustomers = services.findByCompetition(competition);
        if(!temCompetionCustomers.isEmpty()){
            List<Customer> customers  = temCompetionCustomers.stream()
                    .filter(temCompetionCustomer ->competitionTeams.contains(temCompetionCustomer.getTeam()))
                    .map(TemCompetionCustomer::getCustomer).toList();
            customers = customers.stream()
                    .filter(customer -> customer.getStatus().equalsIgnoreCase("ACTIVE")).filter(customer->{
                        List<Authorities> authorities = authorityServices
                                .findByCustomerId(customer.getId());
                        return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.ROLE_PLAYER);
                    })
                    .filter(cus -> cus.getGender().equalsIgnoreCase(gender))
                    .filter(cus -> cus.getCategory().equalsIgnoreCase(category))
                    .filter(customer -> customer.getWeight()>=Float.parseFloat(from) && customer.getWeight()<=Float.parseFloat(to))
                    .toList();
            return customers;
        }
        return List.of();
    }

    public List<Event> filterEvents(Event filter) {
        if (filter == null) {
            return eventServices.findAll();
        }
        return eventServices.filterEvents(
                filter.getId(),
                filter.getEventDate(),
                filter.getCompetition(),
                filter.getRoundOf(),
                filter.getCategoryDefination(),
                filter.getGenderDefination(),
                filter.getStatus()
        );
    }

    public void removeEvents(Long id){
        if (id != null) {
            Event event = getEvent(id);
            if(event!= null){
                List<Event> childEvents = findListOfEventsNoReverse(event);

                for (Event evnt : childEvents) {

                    Event preEvent = evnt.getPrevEvent();
                    if (preEvent != null) {
                        preEvent.setNextEvent(null);
                    }

                    evnt.setParentEventId(null);
                    evnt.setPrevEvent(null);

                    // DELETE DEPENDENTS FIRST
                    matchService.deleteByEvent(evnt);
                    fixtureServices.deleteByEvent(evnt);

                    //since if any medal are reprsented means those also need to be removed.
                    medalReportService.removeByCompetition(evnt.getCompetition());

                    // THEN DELETE EVENT
                    deleteEvent(evnt);
                }
            }

        }
    }

    public void playerDetail(Customer customer, Model model){
        if(customer!=null){
            List<Match> allMatches = matchService.getMatchsForCustomers(customer).stream().filter(m->!m.getBye()).toList();
            model.addAttribute("totalMatches", allMatches);
            if(!allMatches.isEmpty()){
                List<Match> wonMatches = allMatches.stream()
                        .filter(match -> {
                            Customer winner = getWinner(match);
                            if(winner!=null)
                                return customer.getId().equals(winner.getId());

                            return false;
                        })
                        .toList();

                List<Match> lostMatches = allMatches.stream()
                        .filter(match -> !wonMatches.contains(match))
                        .toList();
                model.addAttribute("successorMatches",wonMatches);
                model.addAttribute("failureMatches", lostMatches);
                model.addAttribute("pendingMatches",allMatches.stream().filter(match-> match.getSuccessor()==null).toList());
            }
        }
    }

    public String medalDashboard(Model model) {

        /* ================= KPI COUNTS ================= */
        Object[] statsWrapper = medalReportService.getOverallMedalStats();

        if(statsWrapper.length >0){
            Object[] stats = (Object[]) statsWrapper[0];
            if(stats.length >0){
                model.addAttribute("goldCount", stats[0]);
                model.addAttribute("silverCount", stats[1]);
                model.addAttribute("bronzeCount", stats[2]);
                model.addAttribute("eventCount", stats[3]);
            }
        }
        /* ================= MEDALS BY GENDER ================= */
        model.addAttribute("medalsByGender", mapResults(
                medalReportService.medalsByGender()
        ));

        /* ================= MEDALS BY CATEGORY ================= */
        model.addAttribute("medalsByCategory", mapResults(
                medalReportService.medalsByCategory()
        ));

        /* ================= MEDALS BY WEIGHT ================= */
        model.addAttribute("medalsByWeight", mapResults(
                medalReportService.medalsByWeight()
        ));

        /* ================= MEDALS BY Team ================= */
        List<Map<String, Object>> medalsByTeam = new ArrayList<>();
        for (Object[] row : medalReportService.medalsByTeam()) {
            String teamName = (String) row[0];
            Long count = ((Number) row[1]).longValue();

            if (teamName != null) {
                Map<String, Object> map = new HashMap<>();
                map.put("label", teamName);
                map.put("count", count);
                medalsByTeam.add(map);
            }
        }

        model.addAttribute("medalsByTeam", medalsByTeam);
        return "medalDashboard";
    }

    private List<Map<String, Object>> mapResults(List<Object[]> rows) {

        List<Map<String, Object>> list = new ArrayList<>();

        for (Object[] r : rows) {
            Map<String, Object> map = new HashMap<>();
            map.put("label", r[0]);
            map.put("gold", r[1]);
            map.put("silver", r[2]);
            map.put("bronze", r[3]);
            list.add(map);
        }
        return list;
    }
    private Customer getWinner(Match match) {
        Fixture successor = match.getSuccessor();
        return successor != null ? successor.getCustomerId() : null;
    }

}
