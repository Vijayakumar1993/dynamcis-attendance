package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/financials")
public class FinancialsController {

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private Utility utility;

    @Autowired
    private AuthorityServices authorityServices;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @GetMapping("aging")
    public String home(HttpServletRequest request, HttpSession session, Model model){
        List<Customer> customers = customerRepostitary.findAll();
        LocalDate currentDate = LocalDate.now();
        customers = customers.stream().filter(customer->{
            List<Authorities> authorities = authorityServices
                    .findByCustomerId(customer.getId());
            return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.ROLE_STUDENT);
        }).toList();

        //find the fees pending from the customer
        List<Map<String,String>> priorThirtyDays = new LinkedList<>();
        List<Map<String, String>> thirtyDays = new LinkedList<>();
        List<Map<String, String>> sixtyDays = new LinkedList<>();
        List<Map<String, String>> nintyDays = new LinkedList<>();
        List<Map<String, String>> otherDays = new LinkedList<>();
        List<Map<String, String>> pendings = new LinkedList<>();

        customers.forEach(customer -> {
            List<Payment> payments = paymentRepositary.findByCustomerIdOrderByPaymentIdDesc(customer);
            if(payments.size()>0){
                payments.stream().filter(payment -> payment.getStatus().equalsIgnoreCase("open")).forEach(payment -> {
                    Map<String, String> details = new LinkedHashMap<>();
                    details.put("id",customer.getId().toString());
                    details.put("name",customer.getName());
                    details.put("email",customer.getEmail());
                    details.put("phone",customer.getPhone());
                    details.put("joiningDate",payment.getPaymentDate().toString());
                    details.put("amount",payment.getAmount().toString());
                    details.put("balance",payment.getBalance().toString());

                    LocalDate compareDate = payment.getPaymentDate();
                    Long tenure = payment.getTenure();
                    LocalDate customerDate =  compareDate.plusMonths(tenure);
                    Long daysDiff = Math.abs(ChronoUnit.DAYS.between(customerDate,currentDate));
                    if(currentDate.isAfter(customerDate)){
                        if(daysDiff<=30){
                            thirtyDays.add(details);
                        }else if(daysDiff>=31 && daysDiff<=60){
                            sixtyDays.add(details);
                        }else if(daysDiff>=61 && daysDiff<=90){
                            nintyDays.add(details);
                        }else {
                            otherDays.add(details);
                        }
                    }else {
                        if(daysDiff<=30){
                            priorThirtyDays.add(details);
                        }
                    }
                    if(payment.getBalance()>0){
                        pendings.add(details);
                    }
                });

            }
        });
        model.addAttribute("fees", thirtyDays.size()+sixtyDays.size()+nintyDays.size()+otherDays.size()+pendings.size());
        model.addAttribute("thirtyDays", thirtyDays);
        model.addAttribute("sixtyDays", sixtyDays);
        model.addAttribute("nintyDays", nintyDays);
        model.addAttribute("otherDays", otherDays);
        model.addAttribute("priorThirtyDays", priorThirtyDays);
        model.addAttribute("pendings", pendings);
        return "agingReport";
    }

    @GetMapping("/summary")
    public String summary(Model model) {

        List<Payment> payments = paymentRepositary.findAll();

        long totalReceived = payments.stream()
                .mapToLong(p -> p.getAmount() != null ? p.getAmount() : 0)
                .sum();

        long totalPending = payments.stream()
                .mapToLong(p -> p.getBalance() != null ? p.getBalance() : 0)
                .sum();

        long totalExpected = totalReceived + totalPending;

        // Monthly collection
        Map<String, Long> monthlyCollection = payments.stream()
                .filter(p -> p.getPaymentDate() != null)
                .collect(Collectors.groupingBy(
                        p -> p.getPaymentDate().getMonth().name() + "-" + p.getPaymentDate().getYear(),
                        LinkedHashMap::new,
                        Collectors.summingLong(p -> p.getAmount() != null ? p.getAmount() : 0)
                ));

        // Student-wise pending
        Map<Customer, Long> pendingByStudent = payments.stream()
                .filter(p -> p.getBalance() != null && p.getBalance() > 0)
                .collect(Collectors.groupingBy(
                        p -> p.getCustomerId(),
                        Collectors.summingLong(Payment::getBalance)
                ));

        model.addAttribute("totalReceived", totalReceived);
        model.addAttribute("totalPending", totalPending);
        model.addAttribute("totalExpected", totalExpected);
        model.addAttribute("monthlyCollection", monthlyCollection);
        model.addAttribute("pendingByStudent", pendingByStudent);
        return "financeSummary";
    }
}
