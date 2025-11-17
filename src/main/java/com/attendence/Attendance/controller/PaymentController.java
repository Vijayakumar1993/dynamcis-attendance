package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @GetMapping("/receivePayment/{id}")
    public String receivePayment(@PathVariable("id") String customerId, Model model){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        model.addAttribute("customer",customer);
        return "ReceivePayment";
    }

    @PostMapping("completePayment")
    public String completePayment(@ModelAttribute Payment payment){
            paymentRepositary.save(payment);
            return "redirect:/customer/viewCustomer/"+payment.getCustomerId();
    }
}
