package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Payment;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.PaymentRepositary;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Controller
public class HomeController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @GetMapping("/")
    public String home(HttpServletRequest request, HttpSession session, Model model){
        List<Customer> customers = customerRepostitary.findAll();
        model.addAttribute("total", customers.size());
        LocalDate currentDate = LocalDate.now();
        model.addAttribute("presents",attendanceRepositary.countByDate(currentDate));
        List<Long> customerIds = customers.stream()
                .map(Customer::getId).toList();
        List<Long> attCustomerIds = attendanceRepositary.getCustomerIdByDate(currentDate);
        List<Long> immutableCustomerIds = new LinkedList<>();
        immutableCustomerIds.addAll(customerIds);
        immutableCustomerIds.removeAll(attCustomerIds);
        model.addAttribute("absents",immutableCustomerIds.size());

        //recent attendence
        List<Attendance> attendanceList = attendanceRepositary.findByDate(currentDate);
        List<Map<String, String>> lists = new LinkedList<>();
        attendanceList.forEach(attendance -> {
            Map<String, String> entries = new LinkedHashMap<>();
            entries.put("id", attendance.getCustomerId().toString());
            entries.put("name", customerRepostitary.findById(attendance.getCustomerId()).get().getName());
            entries.put("date", attendance.getDate().toString());
            lists.add(entries);
        });
        model.addAttribute("attendance", lists);

        //find the fees pending from the customer
        List<Map<String, String>> thirtyDays = new LinkedList<>();
        List<Map<String, String>> sixtyDays = new LinkedList<>();
        List<Map<String, String>> nintyDays = new LinkedList<>();
        List<Map<String, String>> otherDays = new LinkedList<>();
        List<Map<String, String>> pendings = new LinkedList<>();

        customers.forEach(customer -> {
            List<Payment> payments = paymentRepositary.findByCustomerIdOrderByPaymentIdDesc(customer.getId());
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
                    if(currentDate.isAfter(customerDate)){
                        Long daysDiff = ChronoUnit.DAYS.between(customerDate,currentDate);
                        if(daysDiff<=30){
                            thirtyDays.add(details);
                        }else if(daysDiff>=31 && daysDiff<=60){
                            sixtyDays.add(details);
                        }else if(daysDiff>=61 && daysDiff<=90){
                            nintyDays.add(details);
                        }else {
                            otherDays.add(details);
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
        model.addAttribute("pendings", pendings);
        return "dashboard";
    }

}
