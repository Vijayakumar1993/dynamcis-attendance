package com.attendence.Attendance.rest;

import com.attendence.Attendance.constants.LeadStatus;
import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.controller.LeadController;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.LeadFollowUp;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LeadFollowUpRepository;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.core.Local;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/web/lead")
public class LeadRestController {

    @Autowired
    private CustomerRepostitary customerRepostitary;


    @Autowired
    private Utility utility;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private LeadController leadController;

    @Autowired
    private LeadFollowUpRepository followUpRepository;

    /*
    curl -X POST http://localhost:8080/web/lead/createLead -i -H "Content-Type: application/json" -u admin:admin
    -d "{\"name\": \"Ramesh Kumar\",\"email\": \"ramesh@test.com\",\"phone\": \"9876543210\",\"guardianName\":
    \"Suresh Kumar\",\"dob\": \"1995-06-15\",\"weight\": 72.5,\"gender\": \"MALE\",\"status\": \"ACTIVE\",\"joiningDate\":
    \"2024-01-01\",\"renewalDate\": \"2024-06-01\",\"period\": 6,\"pack\": \"28\",\"address\": \"Chennai, Tamil Nadu\",\"category\":
    \"29\",\"createdDate\": \"2024-01-01\"}"
     */
    @PostMapping("/createLead")
    public Customer createLead(@RequestBody Customer customer, HttpSession session) {
        Customer userLogin = (Customer) session.getAttribute("userLogin");
        return utility.createLead(customer, LeadStatus.NEW,LocalDate.now(), LocalDate.now(),userLogin);
    }
}
