package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("")
    public String customer(){
        return "customer";
    }
    @PostMapping("/createCustomer")
    public String createCustomer(@ModelAttribute Customer customer){
        customerRepostitary.save(customer);
        System.out.println("Create customer is under constructions...!");
        return "customer";
    }

    @GetMapping("/customer/{id}")
    public String getCustomer(@PathVariable("id") String id, Model model){
        Customer customer = customerRepostitary.getById(Integer.parseInt(id));
        model.addAttribute("customer",customer);
        System.out.println("Customer  is "+customer.getName());
        return "customer";
    }
    @GetMapping("find")
    public String findCustomers(Model model){
        List<Customer> customers = customerRepostitary.findAll();
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @GetMapping("find/{id}")
    public Customer findByCustomerId(@PathVariable("id") String id){
        return customerRepostitary.findById(Integer.parseInt(id)).get();
    }
}
