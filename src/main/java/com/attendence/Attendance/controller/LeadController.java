package com.attendence.Attendance.controller;


import com.attendence.Attendance.constants.InterestLevel;
import com.attendence.Attendance.constants.LeadPriority;
import com.attendence.Attendance.constants.LeadSource;
import com.attendence.Attendance.constants.LeadStatus;
import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.LeadFollowUp;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LeadFollowUpRepository;
import com.attendence.Attendance.rest.LeadRestController;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("lead-management")
public class LeadController {

    @Autowired
    private CustomerRepostitary customerRepository;

    @Autowired
    private Utility utility;

    @Autowired
    private LeadFollowUpRepository followUpRepository;

    @GetMapping("viewLead/{id}")
    public String viewLead(@PathVariable("id") Long id, Model model){
        Customer lead = customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Lead not found"));

        List<LeadFollowUp> history =
                followUpRepository.findByLeadOrderByCallDateDesc(lead);
        model.addAttribute("lead",lead);
        if(!history.isEmpty()){
            history.sort(Comparator.comparing(LeadFollowUp::getLastUpdatedTx).reversed());
            model.addAttribute("callHistoryList", history);
        }
        return "lead-followup";
    }

    @GetMapping("viewFollowUp/{id}")
    public String updateFollowup(@PathVariable("id") Long id, Model model){
        LeadFollowUp leadFollowUp =
                followUpRepository.findById(id).orElseThrow(() -> new RuntimeException("Lead followup not found"));
        if(leadFollowUp!=null){
            model.addAttribute("latest", leadFollowUp);
            model.addAttribute("lead",leadFollowUp.getLead());
        }
        return "lead-followup";
    }

    @GetMapping("/deleteLead/{id}")
    public String deleteLead(@PathVariable("id") Long id, Model model){
        LeadFollowUp followUp =
                Optional.ofNullable(id)
                        .flatMap(followUpRepository::findById)
                        .orElseThrow(() -> new RuntimeException("Followup not found."));

        followUpRepository.delete(followUp);
        viewLead(followUp.getLead().getId(),model);
        return "lead-followup";
    }

    @PostMapping("/updateLead")
    public String saveFollowUp(
            @RequestParam(required = false) Long followUpId,
            @RequestParam Long leadId,
            @RequestParam Long status,
            @RequestParam Long interest,
            @RequestParam Long priority,
            @RequestParam Long source,
            @RequestParam Long budget,
            @RequestParam(required = false) LocalDate expectedJoinDate,
            @RequestParam(required = false) LocalDate nextCallDate,
            @RequestParam String comments,
            @RequestParam String callTime,
            HttpSession session,
            Model model
    ) {

        Customer lead = customerRepository.findById(leadId)
                .orElseThrow(() -> new RuntimeException("Lead not found"));

        LeadFollowUp followUp =
                Optional.ofNullable(followUpId)
                        .flatMap(followUpRepository::findById)
                        .orElseGet(LeadFollowUp::new);

        followUp.setLead(lead);
        followUp.setStatus(utility.getConfig(status));
        followUp.setInterest(utility.getConfig(interest));
        followUp.setPriority(utility.getConfig(priority));
        followUp.setSource(utility.getConfig(source));
        followUp.setBudgetRange(utility.getConfig(budget));
        followUp.setCallDate(LocalDate.now());
        followUp.setNextCallDate(nextCallDate);
        followUp.setExpectedJoinDate(expectedJoinDate);
        followUp.setComments(comments);
        followUp.setPreferredCallTime(utility.getConfig(callTime));
        followUp.setCreatedBy((Customer) session.getAttribute("userLogin"));
        followUpRepository.save(followUp);
        return "redirect:/lead-management/viewLead/" + leadId;
    }

    @GetMapping("/findLeads")
    public String findLeads(Model model){
        LocalDate today = LocalDate.now();

        //  New Leads (no followups yet or status NEW)
        Configuration leadStatusConfiguration = utility.getConfig(LeadStatus.NEW.getCode());


        List<LeadFollowUp> followUps = followUpRepository.findLatestFollowUpPerLead();


        List<LeadFollowUp> next = followUps.stream()
                .filter(x->!x.getStatus().equals(utility.getConfig(LeadStatus.NEW.getCode())))
                .filter(f -> f.getNextCallDate() != null &&
                        !f.getNextCallDate().isBefore(today))
                .toList();

        List<LeadFollowUp> missed = followUps.stream()
                .filter(x->!x.getStatus().equals(utility.getConfig(LeadStatus.NEW.getCode())))
                .filter(f -> f.getNextCallDate() != null &&
                        f.getNextCallDate().isBefore(today))
                .toList();
        model.addAttribute("newLeads", followUps.stream().filter(x->x.getStatus().equals(utility.getConfig(LeadStatus.NEW.getCode())))
                .map(LeadFollowUp::getLead).toList());
        model.addAttribute("nextFollowUps", next);
        model.addAttribute("missedFollowUps", missed);

        return "leads-list";
    }


    @GetMapping("/reports")
    public String reports(Model model){
            model.addAttribute("dailyActivity", followUpRepository.dailyActivity());
            model.addAttribute("statusSummary", followUpRepository.statusSummary());
            model.addAttribute("interestSummary", followUpRepository.interestSummary());
            model.addAttribute("missedFollowups",
                    followUpRepository.findByNextCallDateLessThanOrderByNextCallDateDesc(LocalDate.now()));
            model.addAttribute("conversionByUser", followUpRepository.conversionByUser(LeadStatus.CONTACTED.getCode()));
            model.addAttribute("conversionTime", followUpRepository.conversionTime(LeadStatus.CONTACTED.getCode()));
            return "lead-reports";
    }
    @GetMapping("/lead")
    public String Lead(Model model){
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        return "createLead";
    }
    @PostMapping("/createOrStoreLead")
    public String createLead(HttpSession session, @ModelAttribute Customer customer, RedirectAttributes model){
        List<Customer> existingCustomer  = customerRepository.findByPhone(customer.getPhone());
        Customer userLogin = (Customer) session.getAttribute("userLogin");
        model.addAttribute("customer",customer);
        if(existingCustomer.size()>0 && customer.getId()==null){
            model.addAttribute("error_msg","Already Lead registered, please use different phone number");
            return "createLead";
        }
        customer.setStatus("ACTIVE");
        customer.setWeight(0f);
        utility.createLead(customer, LeadStatus.NEW, LocalDate.now(), LocalDate.now(),userLogin);
        return "redirect:/lead-management/viewLead/"+customer.getId();
    }

}
