package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {
    @Autowired
    private AttendanceRepositary repositary;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("")
    public String home(@RequestParam(value = "name", required = false) String name, @RequestParam(value = "id", required = false) String id, @RequestParam(value = "from", required = false) String fromDate, @RequestParam(value = "to", required = false) String toDate,Model model){
        System.out.println("id "+id);
        System.out.println("date "+fromDate);
        System.out.println("date "+toDate);
        model.addAttribute("customers", customerRepostitary.findAll());
        model.addAttribute("name",name);
        model.addAttribute("id",id);
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

        Map<Long, List<Attendance>> groupedAttendanceList = attendanceList.stream().collect(Collectors.groupingBy(Attendance::getCustomerId));
        for (Map.Entry<Long, List<Attendance>> integerListEntry : groupedAttendanceList.entrySet()) {
            entries.put(customerRepostitary.getById(integerListEntry.getKey()), integerListEntry.getValue());
        }
        model.addAttribute("dates",entries);
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
    public String AddAttendance(Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        return  "AddAttendance";
    }
    @GetMapping("removeAttendance")
    public String removeAttendance( Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        return  "DeleteAttendance";
    }
    @PostMapping("createAttendance")
    @Transactional
    public String createAttendance(@RequestParam("id") String id, @RequestParam("attendanceDate") String attendanceDate, Model model){
        model.addAttribute("customers", customerRepostitary.findAll());
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        LocalDate attandenceDate = LocalDate.parse(attendanceDate);
        repositary.save(new Attendance(Long.parseLong(customer.getId().toString()),attandenceDate));
        return "redirect:/attendance";
    }
    @PostMapping("deleteAttendance")
    @Transactional
    public String deleteAttendance(@RequestParam("id") String id, @RequestParam("attendanceDate") String attendanceDate, Model model){
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        LocalDate attandenceDate = LocalDate.parse(attendanceDate);
        repositary.deleteByCustomerIdAndDate(Integer.parseInt(customer.getId().toString()),attandenceDate);
        return "redirect:/attendance";
    }
}
