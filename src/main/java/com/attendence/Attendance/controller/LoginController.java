package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import com.attendence.Attendance.services.LoginServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private LoginRepositary repositary;

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private LoginServices loginServices;

    @GetMapping("")
    public String home(){
        return "login";
    }

    @GetMapping("createLogin/{customerId}")
    public String createLogin(@PathVariable("customerId") String customerId, Model model){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        model.addAttribute("customer",customer);
        return "createLogin";
    }
    @PostMapping("createLoginSetup")
    public String createLoginSetup(@RequestParam("customerId") String customerId){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        loginServices.createLogin(new Users(customer.getPhone().toString(), customer.getPhone().toString(),true));
        return "redirect:/customer/viewCustomer/"+customerId;
    }
    @GetMapping("removeLogin/{id}")
    public String removeLogin(@PathVariable("id") String id, @RequestParam("customerId") String customerId){
        repositary.deleteById(Long.parseLong(id));
        return "redirect:/customer/viewCustomer/"+customerId;
    }


    @PostMapping("updateLogin")
    public String updateLogin(@ModelAttribute("user") Users users){
        loginServices.createLogin(users);
        return "redirect:/customer/viewCustomer/"+users.getCustomerId();
    }

}
