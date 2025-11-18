package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
    public String receivePayment(@PathVariable("id") String customerId, @RequestParam(value = "paymentId", required = false) String paymentId, Model model){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        if(paymentId!=null){
            Payment payment = paymentRepositary.findById(Long.parseLong(paymentId)).get();
            model.addAttribute("payment",payment);
        }
        model.addAttribute("customer",customer);
        return "ReceivePayment";
    }

    @PostMapping("completePayment")
    public String completePayment(@ModelAttribute Payment payment){
            paymentRepositary.save(payment);
            return "redirect:/customer/viewCustomer/"+payment.getCustomerId();
    }

    @GetMapping("/removePayment/{id}")
    public String removePayment(@PathVariable("id") String paymentId, @RequestParam("customerId") String customerId){
        paymentRepositary.deleteById(Long.parseLong(paymentId));
        return "redirect:/customer/viewCustomer/"+customerId;
    }
}
