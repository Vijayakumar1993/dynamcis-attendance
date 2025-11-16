package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @GetMapping("/")
    public String home(HttpServletRequest request, HttpSession session, Model model){
        String baseUrl = request.getScheme() + "://" +
                request.getServerName() + ":" +
                request.getServerPort();

        session.setAttribute("baseUrl", baseUrl);
        List<Customer> customers = customerRepostitary.findAll();
        model.addAttribute("total", customers.size());
        model.addAttribute("presents",attendanceRepositary.countByDate(LocalDate.now()));
        List<Long> customerIds = customers.stream()
                .map(Customer::getId).toList();
        List<Long> attCustomerIds = attendanceRepositary.getCustomerIdByDate(LocalDate.now());
        List<Long> immutableCustomerIds = new LinkedList<>();
        immutableCustomerIds.addAll(customerIds);
        immutableCustomerIds.removeAll(attCustomerIds);
        model.addAttribute("absents",immutableCustomerIds.size());

        //recent attendence
        List<Attendance> attendanceList = attendanceRepositary.findByDate(LocalDate.now());
        List<Map<String, String>> lists = new LinkedList<>();
        attendanceList.forEach(attendance -> {
            Map<String, String> entries = new LinkedHashMap<>();
            entries.put("name", customerRepostitary.findById(attendance.getCustomerId()).get().getName());
            entries.put("date", attendance.getDate().toString());
            lists.add(entries);
        });
        model.addAttribute("attendance", lists);
        return "dashboard";
    }

}
