package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import com.attendence.Attendance.services.LoginServices;
import com.attendence.Attendance.util.Utility;
import jdk.jshell.execution.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerRepostitary customerRepostitary;


    @Autowired
    private LoginRepositary loginRepositary;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private LoginServices loginServices;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private Utility utility;

    @GetMapping("createCustomer")
    public String customer(Model model){
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        return "customer";
    }
    @PostMapping("addCustomer")
    public String createCustomer(@ModelAttribute Customer customer, Model model){
        List<Customer> existingCustomer  = customerRepostitary.findByPhone(customer.getPhone());
        model.addAttribute("customer",customer);
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        if(existingCustomer.size()>0 && customer.getId()==null){
            model.addAttribute("error_msg","Already Student registered, please use different phone number");
            return "customer";
        }
        customerRepostitary.save(customer);

        List<Users> existingUsers = loginServices.findUsers(customer.getId().toString());
        if(existingUsers.size()>0){
            existingUsers.forEach(user->{
                user.setEnabled(customer.getStatus().equalsIgnoreCase("INACTIVE")?false: true);
                loginRepositary.save(user);
            });
            return "redirect:/customer/viewCustomer/"+customer.getId();
        }else{
            Users user = new Users(customer.getPhone().toString(), customer.getPhone().toString(), customer.getStatus()=="INACTIVE"?false: true);
            user.setCustomerId(customer.getId());
            boolean result = loginServices.createLogin(user);
            if(!result){
                model.addAttribute("error_msg","User Login creation failed, may be username "+user.getUsername()+" already exists");
                return "redirect:/customer/viewCustomers";
            }
            return "redirect:/customer/viewCustomer/"+customer.getId();
        }

    }

    @GetMapping("viewCustomers")
    public String viewCustomers(Model model){
        List<Customer> customers  = customerRepostitary.findAll().stream().map(customer->{
            if(customer.getCreatedBy()!=null){
                customer.setCreatedBy(customerRepostitary.findById(Long.parseLong(customer.getCreatedBy())).get().getName());
                return customer;
            }else
                return customer;
        }).toList();
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @PostMapping("viewCustomers")
    public String viewCustomers(@RequestParam(value = "name",required = false) String name,@RequestParam(value = "phone",required = false) String phone, @RequestParam(value = "email",required = false) String email,
                                @RequestParam(value = "gender",required = false) String gender, @RequestParam(value = "status",required = false) String status,
                                @RequestParam(value = "guardianName",required = false) String guardianName, @RequestParam(value = "pack",required = false) String pack, @RequestParam(value = "createdBy",required = false) String createdBy, Model model){
        model.addAttribute("name", name);
        model.addAttribute("phone",phone);
        model.addAttribute("email",email);
        model.addAttribute("gender",gender);
        model.addAttribute("status",status);
        model.addAttribute("guardianName",guardianName);
        model.addAttribute("createdBy",createdBy);
        model.addAttribute("pack",pack);
        if (name != null && name.isBlank()) name = null;
        if (email != null && email.isBlank()) email = null;
        if (phone != null && phone.isBlank()) phone = null;
        if (gender != null && gender.isBlank()) gender = null;
        if (status != null && status.isBlank()) status = null;
        if (pack != null && pack.isBlank()) pack = null;
        if (guardianName != null && guardianName.isBlank()) guardianName = null;
        if (createdBy != null && createdBy.isBlank()) createdBy = null;
        List<Customer> customers = customerRepostitary.searchCustomer(name,email, phone, gender, status,guardianName,createdBy,pack);
        model.addAttribute("customers",customers);
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        return "findCustomers";
    }

    @GetMapping("editCustomer/{id}")
    public String editCustomer(@PathVariable("id") String id, Model model){
        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        model.addAttribute("customer",customer);
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        return "customer";
    }
    @GetMapping("viewCustomer/{id}")
    public String viewCustomerById(@PathVariable("id") String id, Model model){
        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        List<Payment> payments = paymentRepositary.findByCustomerId(Long.parseLong(id));
        List<Users> users = loginServices.findUsers(id);
        if(customer.getCreatedDate()!=null)
            customer.setCreatedBy(customerRepostitary.findById(Long.parseLong(customer.getCreatedBy())).get().getName());

        //renewal date calculation
        payments.sort(Comparator.comparing(Payment::getPaymentDate));
        if(payments.size()>0){
            Payment latestPayment = payments.get(0);
            LocalDate paymentDate = latestPayment.getPaymentDate();
            LocalDate nextRenewel = ChronoUnit.MONTHS.addTo(paymentDate,latestPayment.getTenure());
            customer.setRenewalDate(nextRenewel);
        }
        model.addAttribute("customer",customer);
        model.addAttribute("pack", utility.getConfig(customer.getPack()));
        model.addAttribute("payments",payments);
        model.addAttribute("users",users);
        return "viewCustomers";
    }

    @GetMapping("deleteCustomer/{id}")
    public String deleteCustomer(@PathVariable("id") String id){
        Customer customer = customerRepostitary.findById(Long.parseLong(id)).get();
        customer.setStatus("INACTIVE");
        customerRepostitary.save(customer);

        List<Users> users = loginServices.findUsers(customer.getId().toString());
        users.stream().forEach(user->{
            user.setEnabled(false);
            loginRepositary.save(user);
        });


        return "redirect:/customer/viewCustomers";
    }

}
