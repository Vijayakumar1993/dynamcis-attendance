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

    @PostMapping("updateLoginSetup")
    public String updateLogin(@ModelAttribute Users user, Model model){
        boolean result = loginServices.createLogin(user);
        if(!result){
            model.addAttribute("user", user);
            model.addAttribute("error_msg","User Login creation failed, may be username "+user.getUsername()+" already exists");
            return "updateLogin";
        }
        return "redirect:/customer/viewCustomer/"+user.getCustomerId();
    }
    @PostMapping("createLoginSetup")
    public String createLoginSetup(@RequestParam("customerId") String customerId,@RequestParam("username") String username, @RequestParam("password") String password, Model model){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        Users users = new Users(username, password, true);
        users.setCustomerId(customer.getId());
        boolean result = loginServices.createLogin(users);
        if(!result){
            model.addAttribute("customer", customer);
            model.addAttribute("error_msg","User Login creation failed, may be username "+users.getUsername()+" already exists");
            return "createLogin";
        }
        return "redirect:/customer/viewCustomer/"+customerId;
    }
    @GetMapping("removeLogin/{id}")
    public String removeLogin(@PathVariable("id") String id){
        Users user = repositary.findById(Long.parseLong(id)).get();
        repositary.delete(user);
        return "redirect:/customer/viewCustomer/"+user.getCustomerId();
    }

    @GetMapping("updateLogin/{id}")
    public String updateLogin(@PathVariable("id") String userId, Model model){
        Users user = repositary.findById(Long.parseLong(userId)).get();
        model.addAttribute("user", user);
        return "updateLogin";
    }

}
