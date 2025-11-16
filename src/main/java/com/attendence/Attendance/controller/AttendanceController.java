package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
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
    public String home(Model model){
        LocalDate from = LocalDate.of(2025,11,01);
        LocalDate to = LocalDate.of(2025,11,30);
        List<Attendance> attendanceList = repositary.findAll();

        Map<Customer, List<Attendance>> entries = new LinkedHashMap<>();
        Map<Integer, List<Attendance>> groupedAttendanceList = attendanceList.stream().collect(Collectors.groupingBy(Attendance::getCustomerId));
        for (Map.Entry<Integer, List<Attendance>> integerListEntry : groupedAttendanceList.entrySet()) {
            entries.put(customerRepostitary.getReferenceById(integerListEntry.getKey()), integerListEntry.getValue());
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

    @GetMapping("AddAttendance")
    public String AddAttendance(){
        return  "AddAttendance";
    }
    @PostMapping("createAttendance")
    public String createAttendance(@RequestParam("id") String id, @RequestParam("attendanceDate") String attendanceDate){
        Customer customer = customerRepostitary.findById(Integer.parseInt(id)).get();
        LocalDate attandenceDate = LocalDate.parse(attendanceDate);
        repositary.save(new Attendance(Integer.parseInt(customer.getId().toString()),attandenceDate));
        return "AddAttendance";

    }
}
