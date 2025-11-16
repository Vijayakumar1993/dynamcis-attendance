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

    @GetMapping("createCustomer")
    public String customer(){
        return "customer";
    }
    @PostMapping("addCustomer")
    public String createCustomer(@ModelAttribute Customer customer){
        customerRepostitary.save(customer);
        return "redirect:/customer/viewCustomers";
    }


    @GetMapping("viewCustomers")
    public String viewCustomers(Model model){
        List<Customer> customers = customerRepostitary.findAll();
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @GetMapping("viewCustomer/{id}")
    public String viewCustomerById(@PathVariable("id") String id, Model model){
        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        model.addAttribute("customer",customer);
        return "customer";
    }

    @GetMapping("deleteCustomer/{id}")
    public String deleteCustomer(@PathVariable("id") String id){
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        customer.setStatus("INACTIVE");
        customerRepostitary.save(customer);
        return "redirect:/customer/viewCustomers";
    }

    @PostMapping("findCustomers")
    public String findCustomers(@RequestParam("name") String name, @RequestParam("email") String email,
                                @RequestParam("gender") String gender, @RequestParam("status") String status, Model model){
        List<Customer> customers = customerRepostitary.searchCustomers(name,email,gender,status);
        model.addAttribute("customers",customers);
        return "redirect:/customer/viewCustomers"; }
}
