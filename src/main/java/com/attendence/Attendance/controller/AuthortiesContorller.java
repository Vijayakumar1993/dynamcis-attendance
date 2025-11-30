package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/authorities")
public class AuthortiesContorller {

    @Autowired
    private AuthorityServices services;

    @Autowired
    private CustomerRepostitary repositary;

    @PostMapping("/createAuthority")
    public String createAuthority(@RequestParam("role") String role, @RequestParam("customerId") String customerId, @RequestParam("username") String username, Model model){
        List<Authorities> existingRoles = services.findByCustomerId(Long.parseLong(customerId)).stream().filter(f->f.getAuthority().equalsIgnoreCase(role)).toList();
        Customer customer = repositary.findById(Long.parseLong(customerId)).get();
        if(!existingRoles.isEmpty()){
            model.addAttribute("error_msg","For the given username "+username+" and customer ID "+customer.getName()+", the user already has "+role+" access.");
            return "redirect:/customer/viewCustomer/"+customerId;
        }
        if(customer!=null)
            services.createAuthority(username,role,customer.getId());
        return "redirect:/customer/viewCustomer/"+customerId;
    }

    @GetMapping("/deleteAuthority/{id}")
    public String deleteByCustomerId(@PathVariable("id") String customerId){
        services.deleteByCustomerId(Long.parseLong(customerId));
        return "redirect:/customer/viewCustomer/"+customerId;
    }
    @GetMapping("/deleteAuthority/{id}/{customerId}")
    public String deleteById(@PathVariable("id") String id,@PathVariable("customerId") String customerId){
        services.deleteById(Long.parseLong(id));
        return "redirect:/customer/viewCustomer/"+customerId;

    }

}
