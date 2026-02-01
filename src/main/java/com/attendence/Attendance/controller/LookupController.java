package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.util.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("lookup")
public class LookupController {


    @Autowired
    private Utility utility;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("viewCustomers/{role}")
    public String viewCustomers(@PathVariable(value = "role", required = false) String role, RedirectAttributes model){
        List<Customer> customers  = customerRepostitary.findAll().stream().filter(customer -> customer.getStatus().equalsIgnoreCase("ACTIVE"))
                .toList();
        if(role!=null && !role.isEmpty() && !role.isBlank()){
            customers = customers.stream().filter(customer->{
                List<Authorities> authorities = authorityServices
                        .findByCustomerId(customer.getId());
                return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.valueOf(role));
            }).toList();
        }
        model.addAttribute("customers",customers);
        model.addAttribute("role",role);
        return "lookupCustomers";
    }
    @GetMapping("viewCustomers")
    public String viewAllCustomers( RedirectAttributes model){
        List<Customer> customers  = customerRepostitary.findAll().stream().filter(customer -> customer.getStatus().equalsIgnoreCase("ACTIVE"))
                .toList();
        model.addAttribute("customers",customers);
        return "lookupCustomers";
    }

    @PostMapping("viewCustomers")
    public String viewCustomers(@RequestParam(value = "name",required = false) String name,
                                @RequestParam(value = "phone",required = false) String phone,
                                @RequestParam(value = "email",required = false) String email,
                                @RequestParam(value = "gender",required = false) String gender,
                                @RequestParam(value = "status",required = false) String status,
                                @RequestParam(value = "guardianName",required = false) String guardianName,
                                @RequestParam(value = "role",required = false) String role,
                                @RequestParam(value = "team", required = false) String team,
                                Model model){
        model.addAttribute("name", name);
        model.addAttribute("phone",phone);
        model.addAttribute("email",email);
        model.addAttribute("gender",gender);
        model.addAttribute("status",status);
        model.addAttribute("guardianName",guardianName);
        model.addAttribute("selectedTeam",team);
        model.addAttribute("role",role);
        if (name != null && name.isBlank()) name = null;
        if (email != null && email.isBlank()) email = null;
        if (phone != null && phone.isBlank()) phone = null;
        if (gender != null && gender.isBlank()) gender = null;
        if (status != null && status.isBlank()) status = null;
        if (guardianName != null && guardianName.isBlank()) guardianName = null;
        List<Customer> customers = customerRepostitary.searchCustomer(name,email, phone, gender, status,guardianName,null,null,null, null);
        customers = customers.stream().filter(customer -> customer.getStatus().equalsIgnoreCase("ACTIVE")).toList();
        if(role!=null && !role.isEmpty() && !role.isBlank()){
            customers = customers.stream().filter(customer->{
                List<Authorities> authorities = authorityServices
                        .findByCustomerId(customer.getId());
                return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.valueOf(role));
            }).toList();
        }

        if(team!=null && !team.isEmpty() && !team.isBlank()){
            customers = customers.stream().filter(customer -> customer.getTeam().getId()==Long.parseLong(team)).toList();
        }
        model.addAttribute("customers",customers);
        return "lookupCustomers";
    }

}
