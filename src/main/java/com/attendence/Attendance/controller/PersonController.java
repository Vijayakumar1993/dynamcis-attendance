package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.util.EventUtility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Controller
@RequestMapping("/person")
public class PersonController {

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private EventUtility eventUtility;

    @GetMapping("")
    public String personDashboard(HttpSession session, Model model){
        Customer customer = (Customer) session.getAttribute("userLogin");
        if(customer!=null){
            model.addAttribute("customer",customer);
            eventUtility.playerDetail(customer, model);
        }
        return "playerDashboard";
    }
    @GetMapping("/student")
    public String studentDashboard(HttpSession session, Model model){
        Customer customer = (Customer) session.getAttribute("userLogin");
        if(customer!=null){
            List<Attendance> attendedSessions = attendanceRepositary.findByDateBetweenAndCustomerId(customer.getJoiningDate(), LocalDate.now(),customer);
            model.addAttribute("customer",customer);
            model.addAttribute("recentTrainings",attendedSessions);
            long totalSessions =
                    ChronoUnit.DAYS.between(customer.getJoiningDate(), LocalDate.now());
            if(totalSessions!=0){
                model.addAttribute("totalSessions", totalSessions);
                model.addAttribute("pendingSessions", totalSessions-attendedSessions.size());
            }
        }
        return "studentDashboard";
    }
}
