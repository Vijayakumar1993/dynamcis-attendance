package com.attendence.Attendance.util;

import com.attendence.Attendance.constants.CompetitionStatus;
import com.attendence.Attendance.constants.LeadStatus;
import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LeadFollowUpRepository;
import com.attendence.Attendance.services.*;
import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;

@Component
public class Utility {

    private Logger logger = LoggerFactory.getLogger(Utility.class);
    @Autowired
    private ConfigurationServices configurationServices;


    @Autowired
    private CompetitionTeamService competitionTeamService;

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private TemCompetionCustomerServices temCompetionCustomerServices;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private TeamServices teamServices;

    @Autowired
    private DocumentServices documentServices;

    @Autowired
    private AuthorityServices services;


    public Competition findCompetition(Long id){
        return competitionService.find(id);
    }
    public Customer getCustomer(String id){
        return repostitary.findById(Long.parseLong(id)).get();
    }

    public  List<Configuration> getConfigs(String name, String key){
        return configurationServices.findByConfigNameAndConfigKey(name,key);
    }
    public  Optional<Configuration> getConfig(String name, String key){
        var configurations = configurationServices.findByConfigNameAndConfigKey(name,key);
        if(!configurations.isEmpty()){
            return Optional.ofNullable(configurations.get(0));
        }
        return Optional.empty();
    }
    public  List<Configuration> getConfigs(String name, String key,String value){
        return getConfigs(name,key).stream().filter(c->c.getConfigValue().equalsIgnoreCase(value)).toList();
    }


    public Documents getPhotoByCustomerId(String customerId){
        if(customerId!=null && customerId!=""){
            List<Configuration> configurations = getConfigs("documents","name","Photo");
            if(configurations.size()>0){
                Configuration photoConfiguration = configurations.get(0);
                Optional<Documents> document = documentServices
                        .findFirstByCustomerIdAndDocumentTypeOrderByDocumentIdDesc(Long.parseLong(customerId),
                                photoConfiguration.getConfigId()+"");
                return document.isPresent()?document.get():null;
            }
        }
        return null;
    }

    public Configuration getConfig(String configId){
      return getConfig(Long.parseLong(configId));
    }
    public Configuration getConfig(Long configId){
        if(configId!=null)
            return configurationServices.findByid(configId);
        return null;
    }
    public List<String> getCurrentUserRoles() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
    }

    public List<Authorities> getAuthorites(String customerId){
        return services.findByCustomerId(Long.parseLong(customerId));
    }
    public void studentCountChart(String type,LocalDate from, LocalDate to, Model model){
        List<Customer> customers = repostitary.findByJoiningDateBetween(from,to);
        if(customers.size()>0 && type!=null){
            Map<String, Long> customersByJoinedDate = customers.stream()
                    .collect(Collectors.groupingBy(
                            c -> {
                                if(type.equalsIgnoreCase("Month")){
                                    return c.getJoiningDate()
                                            .getMonth()
                                            .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                                }else if(type.equalsIgnoreCase("Year")){
                                    return c.getJoiningDate()
                                            .getYear()+"";
                                }else{
                                    return c.getJoiningDate().toString();
                                }
                            },
                            Collectors.counting()
                    ));
            model.addAttribute("monthCountMap", customersByJoinedDate);
        }


        model.addAttribute("type", type);
        model.addAttribute("from",from);
        model.addAttribute("to",to);}

    public void studentAttendanceChart(String type,LocalDate from, LocalDate to, Model model){
        List<Attendance> atts = attendanceRepositary.findByDateBetween(from,to);
        if(atts.size()>0 && type!=null){
            Map<String, Long> customersByAttendanceDate = atts.stream()
                    .collect(Collectors.groupingBy(
                            c -> {
                                if(type.equalsIgnoreCase("Month")){
                                    return c.getDate()
                                            .getMonth()
                                            .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                                }else if(type.equalsIgnoreCase("Year")){
                                    return c.getDate()
                                            .getYear()+"";
                                }else{
                                    return c.getDate().toString();
                                }
                            },
                            Collectors.counting()
                    ));
            model.addAttribute("atMonthCountMap", customersByAttendanceDate);
        }


        model.addAttribute("atType", type);
        model.addAttribute("atFrom",from);
        model.addAttribute("atTo",to);}

    public String weightCombination(String from, String to){
        return from+" - "+to;
    }

    public List<Team> teams(){
        return teamServices.findTeams();
    }

    public Team getTeam(Long id){
        return teamServices.findTeam(id);
    }

    public Boolean validateCustomerId(String customerId, Model model){
        try{
            Customer customer = getCustomer(customerId);
            if(customer==null){
                model.addAttribute("error_msg","Invalid Customer "+customerId);
                return  false;
            }
            return true;
        }catch (Exception e){
            model.addAttribute("error_msg","Invalid Customer "+customerId);
            return false;
        }
    }

    public List<Roles> roles(){
        return Arrays.asList(Roles.values());
    }

    public CompetitionTeam getCompetetionTeam(Competition competition, Team team){
        return competitionTeamService.findByCompetitionAndTeam(competition,team).stream().findFirst().get();
    }

    public List<Competition> findScheduledCompetitionByTeam(Team team){
        return competitionService.findByStatus(CompetitionStatus.SCHEDULED).stream()
                .filter(competition -> {
                    List<Team> compTeams = competition.getCompetitionTeams().stream().map(CompetitionTeam::getTeam).toList();
                    return compTeams.contains(team);
                }).toList();
    }
    public List<TemCompetionCustomer> findByTeamAndCustomer(Team team,Customer customer){
        return temCompetionCustomerServices.findByTeamAndCustomer(team, customer);
    }

    public Optional<TemCompetionCustomer> findByTeamAndCompetitionAndCustomerFindFirst(Team team, Customer customer, Competition competition){
        return temCompetionCustomerServices.findByTeamAndCompetitionAndCustomerFindFirst(team,customer,competition);
    }

    public List<Customer> filterByRoles(List<Customer> customers,Roles role){
        return customers.stream().filter(customer->{
            List<Authorities> authorities = services
                    .findByCustomerId(customer.getId());
            return authorities.stream().map(Authorities::getAuthority).toList().contains(role);
        }).toList();
    }

    public String getEventDefination(Event event){
        Configuration category = getConfig(event.getCategoryDefination());
        String weightDef = event.getWeightDefination();
        return capitalize(category.getConfigValue())+" "+capitalize(event.getGenderDefination())+" Category ("+weightDef+" kg)";
    }

    public String capitalize(String input){
        if (input == null || input.isEmpty()) {
            return input;
        }
        return input.substring(0, 1).toUpperCase() + input.substring(1);
    }

    public boolean isCoachAccess(Customer userLogin, String id){
        Boolean isCoach = getCurrentUserRoles().contains("ROLE_COACH");
        Boolean isAdmin = getCurrentUserRoles().contains("ROLE_ADMIN");
        Team team = teamServices.findTeam(Long.parseLong(id));
        if(isCoach && !isAdmin){
            if(!userLogin.getTeam().getId().equals(team.getId())){
                return false;
            }
        }
        return true;
    }

    public void addLogo(Document doc) {
        try {
            Image logo = Image.getInstance(
                    getClass().getClassLoader()
                            .getResource("static/images/logo.png")
            );

            logo.scaleToFit(80, 80);          // adjust size
            logo.setAlignment(Image.ALIGN_CENTER);
            logo.setSpacingAfter(10);

            doc.add(logo);

        } catch (Exception e) {
            logger.warn("Logo not found, skipping logo rendering", e);
        }
    }

    @Autowired
    private LeadFollowUpRepository followUpRepository;

    @Autowired
    private AuthorityServices authorityServices;

    public Customer createLead(Customer customer, LeadStatus role, LocalDate callDate, LocalDate nextCallDate, Customer userLogin){
        if (customer == null) {
            throw new IllegalArgumentException("Customer cannot be null");
        }

        Customer lead = repostitary.save(customer);

        if(lead!=null){
            LeadFollowUp followUp = new LeadFollowUp();
            followUp.setStatus(getConfig(role.getCode()));
            followUp.setLead(lead);
            followUp.setCallDate(LocalDate.now());
            followUp.setNextCallDate(LocalDate.now());
            followUp.setExpectedJoinDate(null);
            followUp.setCreatedBy(userLogin);
            followUpRepository.save(followUp);
        }
        authorityServices.createAuthority(
                null,
                Roles.ROLE_LEAD,
                lead.getId()
        );

        return lead;
    }
}
