package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import com.attendence.Attendance.services.LoginServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private LoginServices loginServices;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private LoginRepositary loginRepositary;

    @GetMapping("createCustomer")
    public String customer(){
        return "customer";
    }
    @PostMapping("addCustomer")
    public String createCustomer(@ModelAttribute Customer customer, Model model){
        List<Customer> existingCustomer  = customerRepostitary.findByPhone(customer.getPhone());
        if(existingCustomer.size()>0){
            model.addAttribute("customer",customer);
            model.addAttribute("error_msg","Already Student registered, please use different phone number");
            return "customer";
        }
        customerRepostitary.save(customer);
        Users user = new Users(customer.getPhone().toString(), encoder.encode(customer.getPhone().toString()), true);
        user.setCustomerId(customer.getId());
        loginServices.createLogin(user);
        return "redirect:/customer/viewCustomers";
    }

    @GetMapping("viewCustomers")
    public String viewCustomers(Model model){
        List<Customer> customers = customerRepostitary.findAll();
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @PostMapping("viewCustomers")
    public String viewCustomers(@RequestParam(value = "name",required = false) String name,@RequestParam(value = "phone",required = false) String phone, @RequestParam(value = "email",required = false) String email,
                                @RequestParam(value = "gender",required = false) String gender, @RequestParam(value = "status",required = false) String status, Model model){
        model.addAttribute("name", name);
        model.addAttribute("phone",phone);
        model.addAttribute("email",email);
        model.addAttribute("gender",gender);
        model.addAttribute("status",status);
        if (name != null && name.isBlank()) name = null;
        if (email != null && email.isBlank()) email = null;
        if (phone != null && phone.isBlank()) phone = null;
        if (gender != null && gender.isBlank()) gender = null;
        if (status != null && status.isBlank()) status = null;
        List<Customer> customers = customerRepostitary.searchCustomer(name,email, phone, gender, status);
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @GetMapping("editCustomer/{id}")
    public String editCustomer(@PathVariable("id") String id, Model model){
        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        model.addAttribute("customer",customer);
        return "customer";
    }
    @GetMapping("viewCustomer/{id}")
    public String viewCustomerById(@PathVariable("id") String id, Model model){
        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        List<Payment> payments = paymentRepositary.findByCustomerId(Long.parseLong(id));
        List<Users> users = loginRepositary.findByUsername(customer.getName());
        model.addAttribute("customer",customer);
        model.addAttribute("payments",payments);
        model.addAttribute("users",users);
        return "viewCustomers";
    }

    @GetMapping("deleteCustomer/{id}")
    public String deleteCustomer(@PathVariable("id") String id){
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        customer.setStatus("INACTIVE");
        customerRepostitary.save(customer);
        return "redirect:/customer/viewCustomers";
    }

}
