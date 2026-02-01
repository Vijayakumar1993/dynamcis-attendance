package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.services.CompetitionService;
import com.attendence.Attendance.services.CompetitionTeamService;
import com.attendence.Attendance.services.TeamServices;
import com.attendence.Attendance.util.EventUtility;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.Year;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Controller
@RequestMapping("/control")
public class HomeController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private EventUtility eventUtility;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private Utility utility;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private CompetitionTeamService competitionTeamService;

    @Autowired
    private TeamServices teamServices;

    @PostMapping("")
    public String home(@RequestParam(value = "type", required = false) String type,
                       @RequestParam(value = "from", required = false) String from,
                       @RequestParam(value = "to", required = false) String to,
                       @RequestParam(value = "atType", required = false) String atType,
                       @RequestParam(value = "atFrom", required = false) String atFrom,
                       @RequestParam(value = "atTo", required = false) String atTo,
                       @RequestParam(value = "chartType", required = false) String chartType,
                       @RequestParam(value = "atChartType", required = false) String atChartType
            ,HttpServletRequest request, HttpSession session, Model model){
        home(request,session, model);
        utility.studentCountChart(type, LocalDate.parse(from), LocalDate.parse(to),model);
        utility.studentAttendanceChart(atType, LocalDate.parse(atFrom), LocalDate.parse(atTo),model);
        model.addAttribute("competitionsByYear",
                competitionService.getCompetitionsByYear());

        model.addAttribute("competitionsByMonth",
                competitionService.getCompetitionsByMonth(Year.now().getValue()));
        eventUtility.medalDashboard(model);
        model.addAttribute("chartType",chartType);
        model.addAttribute("atChartType",atChartType);
        return "dashboard";
    }

    @GetMapping("")
    public String home(HttpServletRequest request, HttpSession session, Model model){
        List<Customer> customers = customerRepostitary.findAll();
        customers = customers.stream().filter(customer->{
            List<Authorities> authorities = authorityServices
                    .findByCustomerId(customer.getId());
            return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.ROLE_STUDENT);
        }).toList();
        model.addAttribute("totalActiveStudents", customers.stream().filter(customer -> customer.getStatus().equalsIgnoreCase("active")).toList().size());
        model.addAttribute("totalInactiveStudents", customers.stream().filter(customer -> !customer.getStatus().equalsIgnoreCase("active")).toList().size());
        LocalDate currentDate = LocalDate.now();
        model.addAttribute("presents",attendanceRepositary.countByDate(currentDate));
        List<Long> customerIds = customers.stream()
                .map(Customer::getId).toList();
        List<Customer> attCustomerIds = attendanceRepositary.getCustomerIdByDate(currentDate);
        List<Long> immutableCustomerIds = new LinkedList<>();
        immutableCustomerIds.addAll(customerIds);
        immutableCustomerIds.removeAll(attCustomerIds);
        model.addAttribute("absents",immutableCustomerIds.size());

        //recent attendence
        List<Attendance> attendanceList = attendanceRepositary.findByDate(currentDate);
        List<Map<String, Object>> lists = new LinkedList<>();
        attendanceList.forEach(attendance -> {
            Map<String, Object> entries = new LinkedHashMap<>();
            entries.put("id", attendance.getCustomerId());
            if(attendance.getCustomerId()!=null )
                entries.put("name", attendance.getCustomerId().getName());

            entries.put("date", attendance.getDate().toString());
            lists.add(entries);
        });
        model.addAttribute("attendance", lists);

        //find the fees pending from the customer
        List<Map<String,String>> priorThirtyDays = new LinkedList<>();
        List<Map<String, String>> thirtyDays = new LinkedList<>();
        List<Map<String, String>> sixtyDays = new LinkedList<>();
        List<Map<String, String>> nintyDays = new LinkedList<>();
        List<Map<String, String>> otherDays = new LinkedList<>();
        List<Map<String, String>> pendings = new LinkedList<>();

        customers.forEach(customer -> {
            List<Payment> payments = paymentRepositary.findByCustomerIdOrderByPaymentIdDesc(customer);
            if(payments.size()>0){
                payments.stream().filter(payment -> payment.getStatus().equalsIgnoreCase("open")).forEach(payment -> {
                    Map<String, String> details = new LinkedHashMap<>();
                    details.put("id",customer.getId().toString());
                    details.put("name",customer.getName());
                    details.put("email",customer.getEmail());
                    details.put("phone",customer.getPhone());
                    details.put("joiningDate",payment.getPaymentDate().toString());
                    details.put("amount",payment.getAmount().toString());
                    details.put("balance",payment.getBalance().toString());

                    LocalDate compareDate = payment.getPaymentDate();
                    Long tenure = payment.getTenure();
                    LocalDate customerDate =  compareDate.plusMonths(tenure);
                    Long daysDiff = Math.abs(ChronoUnit.DAYS.between(customerDate,currentDate));
                    if(currentDate.isAfter(customerDate)){
                        if(daysDiff<=30){
                            thirtyDays.add(details);
                        }else if(daysDiff>=31 && daysDiff<=60){
                            sixtyDays.add(details);
                        }else if(daysDiff>=61 && daysDiff<=90){
                            nintyDays.add(details);
                        }else {
                            otherDays.add(details);
                        }
                    }else {
                        if(daysDiff<=30){
                            priorThirtyDays.add(details);
                        }
                    }
                    if(payment.getBalance()>0){
                        pendings.add(details);
                    }
                });

            }
        });
        model.addAttribute("fees", thirtyDays.size()+sixtyDays.size()+nintyDays.size()+otherDays.size()+pendings.size());
        model.addAttribute("thirtyDays", thirtyDays);
        model.addAttribute("sixtyDays", sixtyDays);
        model.addAttribute("nintyDays", nintyDays);
        model.addAttribute("otherDays", otherDays);
        model.addAttribute("priorThirtyDays", priorThirtyDays);
        model.addAttribute("pendings", pendings);

        model.addAttribute("chartType","line");
        model.addAttribute("atChartType","line");
        utility.studentCountChart("Month", LocalDate.now().minusMonths(12), LocalDate.now(),model);
        utility.studentAttendanceChart("Month", LocalDate.now().minusMonths(12), LocalDate.now(),model);
        model.addAttribute("competitionsByYear",
                competitionService.getCompetitionsByYear());

        model.addAttribute("competitionsByMonth",
                competitionService.getCompetitionsByMonth(Year.now().getValue()));
        eventUtility.medalDashboard(model);
        return "dashboard";
    }

    @GetMapping("coachDashboard")
    public String coachDashboard(HttpSession session, Model model){
        Customer customer = (Customer)  session.getAttribute("userLogin");
        List<Team> teams = teamServices.findTeamByCustomerId(customer.getId());
        Optional<Team> team = teams.stream().findFirst();
        model.addAttribute("competitions",List.of());
        team.ifPresent(tm->{
            model.addAttribute("team",tm);
            List<Competition> competitions = utility.findScheduledCompetitionByTeam(tm);
            model.addAttribute("competitions",competitions);
        });

        return "coachDashboard";
    }
}
