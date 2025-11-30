package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import com.attendence.Attendance.util.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private Utility utility;

    @GetMapping("/receivePayment/{id}")
    public String receivePayment(@PathVariable("id") String customerId, @RequestParam(value = "paymentId", required = false) String paymentId, Model model){
        Customer customer = repostitary.findById(Long.parseLong(customerId)).get();
        if(paymentId!=null){
            Payment payment = paymentRepositary.findById(Long.parseLong(paymentId)).get();
            model.addAttribute("payment",payment);
        }

        Configuration configuration = utility.getConfig(customer.getPack());
        String packageName = configuration.getConfigValue();
        List<Configuration> tenures = utility.getConfigs(packageName, "tenure");
        if(tenures.size()>0){
            Configuration tenureConfiguration = tenures.get(0);
            model.addAttribute("tenure",tenureConfiguration.getConfigValue());
        }

        List<Configuration> amounts = utility.getConfigs(packageName, "amount");
        if(amounts.size()>0){
            Configuration amountConfiguration = amounts.get(0);
            model.addAttribute("amount", Long.parseLong(amountConfiguration.getConfigValue()));
        }
        model.addAttribute("customer",customer);
        return "ReceivePayment";
    }

    @PostMapping("completePayment")
    public String completePayment(@ModelAttribute Payment payment, @RequestParam( value = "closePayment", required = false) Boolean close){
        if(close!=null && close){
            List<Payment> existingPayments = paymentRepositary.findByCustomerIdAndStatusOrderByPaymentIdDesc(payment.getCustomerId(),"open");
            existingPayments.forEach(payment1 -> {
                payment1.setStatus("close");
                paymentRepositary.save(payment1);
            });
        }
        paymentRepositary.save(payment);
        return "redirect:/customer/viewCustomer/"+payment.getCustomerId();
    }

    @GetMapping("/removePayment/{id}")
    public String removePayment(@PathVariable("id") String paymentId, @RequestParam("customerId") String customerId){
        paymentRepositary.deleteById(Long.parseLong(paymentId));
        return "redirect:/customer/viewCustomer/"+customerId;
    }
}
