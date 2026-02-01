package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {
    @Autowired
    private AttendanceRepositary repositary;

    @Autowired
    private AuthorityServices authorityServices;
    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("")
    public String home(@RequestParam(value = "customerIdInput", required = false) String name, @RequestParam(value = "customerId", required = false) String id, @RequestParam(value = "from", required = false) String fromDate, @RequestParam(value = "to", required = false) String toDate,Model model){
        System.out.println("id "+id);
        System.out.println("date "+fromDate);
        System.out.println("date "+toDate);
        model.addAttribute("customers", customerRepostitary.findAll());
        model.addAttribute("customerIdInput",name);
        model.addAttribute("customerId",id);
        model.addAttribute("from",fromDate);
        model.addAttribute("to",toDate);
        LocalDate from = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
        LocalDate to = LocalDate.now().with(TemporalAdjusters.lastDayOfMonth());
        if(fromDate!=null && fromDate.length()!=0)
            from = LocalDate.parse(fromDate);

        if(toDate!=null && toDate.length() != 0)
            to = LocalDate.parse(toDate);

        Map<Customer, List<Attendance>> entries = new LinkedHashMap<>();
        List<Attendance> attendanceList = repositary.findAll();
        if(id!=null && id.length() != 0 ) {
            attendanceList = attendanceList.stream().filter(attendance -> attendance.getCustomerId().equals(Long.parseLong(id))).toList();
            if (attendanceList.size() <= 0) {
                entries.put(customerRepostitary.getById(Long.parseLong(id)), new LinkedList<>());
            }
        }
        else if(name!=null && name.length()!=0){
            List<Customer> customersList = customerRepostitary.findByNameContaining(name);
            attendanceList = attendanceList.stream().filter(at->customersList.stream().map(Customer::getId).toList().contains(at.getCustomerId())).toList();
            if (attendanceList.size() <= 0) {
                customersList.forEach(customer -> {
                    entries.put(customer, new LinkedList<>());
                });
            }
        }else{
            customerRepostitary.findAll().stream().forEach(customer->{
                entries.put(customer,new LinkedList<>());
            });
        }

        Map<Customer, List<Attendance>> groupedAttendanceList = attendanceList.stream().collect(Collectors.groupingBy(Attendance::getCustomerId));
        for (Map.Entry<Customer, List<Attendance>> integerListEntry : groupedAttendanceList.entrySet()) {
            entries.put(integerListEntry.getKey(), integerListEntry.getValue());
        }
        model.addAttribute("dates",entries.entrySet()
                .stream()
                .filter(att -> att.getKey().getStatus().equalsIgnoreCase("active"))
                        .filter(att->{
                            List<Authorities> authorities =
                                    authorityServices.findByCustomerId(att.getKey().getId());
                            if (authorities != null && !authorities.isEmpty()) {
                                return authorities.stream()
                                        .map(Authorities::getAuthority)
                                        .anyMatch(role -> role.equals(Roles.ROLE_STUDENT));
                            }
                            return false;
                        })
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue)));
        List<String> days = new LinkedList<>();
        LocalDate currentDate = from;
        while (!currentDate.isAfter(to)) {
            days.add(currentDate.toString());
            currentDate = currentDate.plusDays(1);
        }
        model.addAttribute("days", days);
        return "attendance";
    }

    @GetMapping("addAttendance")
    public String AddAttendance(HttpSession session, Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        Customer customer = (Customer) session.getAttribute("userLogin");
        if(customer!=null){
            List<Attendance> attendanceList = repositary.findByCustomerIdOrderByDateDesc(customer);
            model.addAttribute("attendanceList", attendanceList);
            model.addAttribute("customer", customer);
        }
        return  "AddAttendance";
    }
    @GetMapping("removeAttendance")
    public String removeAttendance( Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        return  "DeleteAttendance";
    }
    @PostMapping("createAttendance")
    @Transactional
    public String createAttendance(@RequestParam("customerId") String id, @RequestParam("attendanceDate") String attendanceDate, HttpSession session, Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        Customer userLogin = (Customer) session.getAttribute("userLogin");
        if(id==null || id==""){
            model.addAttribute("error_msg","Invalid Customer");
            return "AddAttendance";
        }
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        model.addAttribute("customer",customer);
        LocalDate attandenceDate = LocalDate.parse(attendanceDate);


        List<Attendance> atts = repositary.findByCustomerIdAndDate(customer,attandenceDate);
        if(atts.size()>0){
            List<Attendance> attendanceList = repositary.findByCustomerIdOrderByDateDesc(customer);
            model.addAttribute("attendanceList", attendanceList);
            model.addAttribute("error_msg","Attendance done for the given date "+attendanceDate+" for the student "+customer.getName());
            return "AddAttendance";
        }
        Attendance att = new Attendance(customer, attandenceDate);
        att.setCreatedBy(userLogin.getId().toString());
        repositary.save(att);
        List<Attendance> attendanceList = repositary.findByCustomerIdOrderByDateDesc(customer);
        model.addAttribute("attendanceList", attendanceList);
        return "AddAttendance";
    }

    @GetMapping("removeSingleAttendance/{attId}")
    @Transactional
    public String removeSingleAttendance(@PathVariable("attId") String attId,HttpSession session, Model model){
        Customer customer = (Customer) session.getAttribute("userLogin");
        model.addAttribute("customer",customer);
        repositary.findById(Long.parseLong(attId)).ifPresent(ac->{
            model.addAttribute("customer",ac.getCustomerId());
            repositary.deleteById(Long.parseLong(attId));
            List<Attendance> attendanceList = repositary.findByCustomerIdOrderByDateDesc(ac.getCustomerId());
            model.addAttribute("attendanceList", attendanceList);
        });

        model.addAttribute("customers", customerRepostitary.findAll());
        return "AddAttendance";
    }


    @PostMapping("deleteAttendance")
    @Transactional
    public String deleteAttendance(@RequestParam("customerId") String id, @RequestParam("attendanceDate") String attendanceDate, Model model){
        if(id==null || id==""){
            model.addAttribute("error_msg","Invalid Customer");
            return "AddAttendance";
        }
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        LocalDate attandenceDate = LocalDate.parse(attendanceDate);
        repositary.deleteByCustomerIdAndDate(customer,attandenceDate);
        List<Attendance> attendanceList = repositary.findByCustomerIdOrderByDateDesc(customer);
        model.addAttribute("attendanceList", attendanceList);
        return "redirect:/attendance";
    }


    @GetMapping("/reports")
    public String attendanceDashboard(Model model) {

        model.addAttribute("dailyAttendance",
                repositary.dailyAttendance());

        model.addAttribute("monthlyAttendance",
                repositary.monthlyAttendance());

        model.addAttribute("attendanceByCustomer",
                repositary.attendanceByCustomer());

        model.addAttribute("attendanceByStaff",
                repositary.attendanceByStaff());

        model.addAttribute("todayList",
                repositary.todayAttendance(LocalDate.now()));

        model.addAttribute("absentees",
                repositary.absentees(LocalDate.now()));

        return "attendance-reports";
    }

    @GetMapping("/history/{customerId}")
    public String customerHistory(
            @PathVariable Long customerId,
            Model model) {

        Customer customer = customerRepostitary.findById(customerId)
                .orElseThrow();

        List<LocalDate> history =
                repositary.customerHistory(customerId);

        model.addAttribute("customer", customer);
        model.addAttribute("history", history);
        model.addAttribute("totalDays", history.size());

        return "customer-attendance-history";
    }
}
