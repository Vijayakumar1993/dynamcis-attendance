package com.attendence.Attendance.controller;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.*;
import com.attendence.Attendance.repostitary.*;
import com.attendence.Attendance.services.*;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private DocumentServices services;

    @Autowired
    private AuthorityServices authorityServices;


    @Autowired
    private DocumentServices documentServices;

    @Autowired
    private LoginRepositary loginRepositary;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private LoginServices loginServices;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private PaymentRepositary paymentRepositary;

    @Autowired
    private TemCompetionCustomerServices temCompetionCustomerServices;

    @Autowired
    private Utility utility;

    @GetMapping("createCustomer")
    public String customer(Model model){
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        return "customer";
    }
    @PostMapping("addCustomer")
    public String createCustomer(@RequestParam(value = "teamId", required = false) String teamId, @RequestParam("role") String role
            ,HttpSession session, @ModelAttribute Customer customer, Model model){
        if(teamId!=null && !teamId.isEmpty() && !teamId.isBlank())
            customer.setTeam(utility.getTeam(Long.parseLong(teamId)));

        if(customer.getJoiningDate()==null)
            customer.setJoiningDate(LocalDate.now());

        Customer userLogin = (Customer) session.getAttribute("userLogin");
        customer.setCreatedBy(userLogin);

        if(customer.getWeight()==null) customer.setWeight(0f);
        List<Customer> existingCustomer  = customerRepostitary.findByPhone(customer.getPhone());
        model.addAttribute("customer",customer);
        model.addAttribute("packages",utility.getConfigs("packages","name"));

        //based on role redirect the page
        Roles expectedRole = Roles.valueOf(role);
        var redirect = switch (expectedRole){
            case ROLE_ADMIN, ROLE_STUDENT, ROLE_EMPLOYEE, ROLE_LEAD -> "customer";
            case ROLE_PLAYER -> "createPlayer";
            case ROLE_COACH -> "createCoach";
        };


        //restrict by age should not below 18
        if(expectedRole.equals(Roles.ROLE_COACH)){
            LocalDate dob = customer.getDob();
            int age = Period.between(dob, LocalDate.now()).getYears();
            if (age < 18) {model.addAttribute(
                    "error_msg",
                    "Coach must be at least 18 years old. Current age is " + age + ", which does not meet the requirement."
            );
                return redirect;
            }
        }
        if(existingCustomer.size()>0 && customer.getId()==null){
            model.addAttribute("error_msg","Already Student registered, please use different phone number");
            return redirect;
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
            user.setCustomerId(customer);
            boolean result = loginServices.createLogin(user, expectedRole);
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
                customer.setCreatedBy(customer.getCreatedBy());
                return customer;
            }else
                return customer;
        }).toList();
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        model.addAttribute("documents",utility.getConfigs("documents","name"));
        model.addAttribute("customers",customers);
        return "findCustomers";
    }

    @PostMapping("viewCustomers")
    public String viewCustomers(@RequestParam(value = "name",required = false) String name,@RequestParam(value = "phone",required = false) String phone, @RequestParam(value = "email",required = false) String email,
                                @RequestParam(value = "gender",required = false) String gender, @RequestParam(value = "status",required = false) String status,
                                @RequestParam(value = "guardianName",required = false) String guardianName,
                                @RequestParam(value = "pack",required = false) String pack,
                                @RequestParam(value = "createdBy",required = false) String createdBy,
                                @RequestParam(value = "category", required = false) String category,
                                @RequestParam(value="from", required = false) String from,
                                @RequestParam(value = "to", required = false) String to,
                                @RequestParam(value = "role", required = false) String role,
                                @RequestParam(value = "team", required = false) String team,
                                Model model){
        model.addAttribute("name", name);
        model.addAttribute("phone",phone);
        model.addAttribute("email",email);
        model.addAttribute("gender",gender);
        model.addAttribute("status",status);
        model.addAttribute("guardianName",guardianName);
        model.addAttribute("createdBy",createdBy);
        model.addAttribute("pack",pack);
        model.addAttribute("category",category);
        model.addAttribute("from",from);
        model.addAttribute("to",to);
        model.addAttribute("selectedTeam",team);
        model.addAttribute("role",role);
        if (name != null && name.isBlank()) name = null;
        if (email != null && email.isBlank()) email = null;
        if (phone != null && phone.isBlank()) phone = null;
        if (gender != null && gender.isBlank()) gender = null;
        if (status != null && status.isBlank()) status = null;
        if (pack != null && pack.isBlank()) pack = null;
        if (guardianName != null && guardianName.isBlank()) guardianName = null;
        if (createdBy != null && createdBy.isBlank()) createdBy = null;
        if (category != null && category.isBlank()) category = null;
        if (from != null && from.isBlank()) from = "0";
        if (to != null && to.isBlank()) to = "100000";
        List<Customer> customers = customerRepostitary
                .searchCustomer(name,email, phone, gender, status,guardianName,pack,category,from==null?0f:Float.parseFloat(from),to==null?0f:Float.parseFloat(to));
        if(role!=null && !role.isEmpty() && !role.isBlank()){
            customers = customers.stream().filter(customer->{
                List<Authorities> authorities = authorityServices
                        .findByCustomerId(customer.getId());
                return authorities.stream().map(Authorities::getAuthority).toList().contains(Roles.valueOf(role));
            }).toList();
        }
        if(team!=null && !team.isEmpty() && !team.isBlank()){
            customers = customers.stream().filter(customer -> customer.getTeam().getId()==Long.parseLong(team)).toList();
        }
        model.addAttribute("customers",customers);
        model.addAttribute("packages",utility.getConfigs("packages","name"));
        model.addAttribute("documents",utility.getConfigs("documents","name"));
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
    public String viewCustomerById(@PathVariable("id") String id, HttpSession session, Model model){
        Customer userLogin = (Customer) session.getAttribute("userLogin");
        boolean hasAllowedRole =
                List.of("ROLE_ADMIN", "ROLE_COACH", "ROLE_EMPLOYEE")
                        .stream()
                        .anyMatch(utility.getCurrentUserRoles()::contains);

        boolean isSameUser =
                Objects.equals(String.valueOf(userLogin.getId()), id);

        if (!hasAllowedRole && !isSameUser) {
            return "error";
        }

        Customer customer =  customerRepostitary.findById(Long.parseLong(id)).get();
        List<Payment> payments = paymentRepositary.findByCustomerId(customer);
        List<Users> users = loginServices.findUsers(id);
        if(customer.getCreatedBy()!=null)
            customer.setCreatedBy(customer.getCreatedBy());

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
        model.addAttribute("documents",utility.getConfigs("documents","name"));
        model.addAttribute("docs",services.findByCustomerId(customer.getId()));
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

    @Autowired
    private TeamServices teamServices;

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private LeadFollowUpRepository followUpRepository;

    @GetMapping("removeCustomer/{id}")
    @Transactional
    public String removeCustomer(@PathVariable("id") String id,
                                 RedirectAttributes redirectAttributes) {

        Customer customer = customerRepostitary
                .findById(Long.parseLong(id))
                .orElse(null);



        if (customer == null) {
            redirectAttributes.addFlashAttribute(
                    "error_msg", "Customer not found");
            return "redirect:/customer/viewCustomers";
        }

        followUpRepository.removeByLead(customer);
        followUpRepository.clearCreatedBy(customer);
        List<TemCompetionCustomer> temCompetionCustomerServices1 = temCompetionCustomerServices.findByCustomer(customer);
        if(temCompetionCustomerServices1.size()>0){
            redirectAttributes.addFlashAttribute(
                    "error_msg",
                    customer.getName()+"is associated with Competition, So can't remove until competition is removed."
            );
            return "redirect:/customer/viewCustomers";
        }

        List<Team> teams = teamServices.findTeamByCustomerId(customer.getId());
        if(teams.size()>0){
            redirectAttributes.addFlashAttribute(
                    "error_msg",
                    customer.getName()+"is associated with Team, So can't remove until Team is removed."
            );
            return "redirect:/customer/viewCustomers";
        }


        List<Authorities> authorities =
                authorityServices.findByCustomerId(customer.getId());

        if (authorities != null && !authorities.isEmpty()) {
            boolean isAdmin = authorities.stream()
                    .map(Authorities::getAuthority)
                    .anyMatch(role -> role.equals(Roles.ROLE_ADMIN));

            if (isAdmin) {
                redirectAttributes.addFlashAttribute(
                        "error_msg",
                        "Admin role based persons can't be removed until they lose admin access."
                );
                return "redirect:/customer/viewCustomers";
            }
        }


        // Delete login users


        customerRepostitary.clearTeam(customer);
        attendanceRepositary.clearCustomer(customer);
        teamServices.clearCreatedBy(customer);
        competitionService.clearCreatedBy(customer);
        customerRepostitary.clearCreatedBy(customer);
        attendanceRepositary.clearCreatedBy(customer.getId().toString());

        // Cleanup related data
        loginRepositary.deleteByCustomerId(customer);
        authorityServices.deleteByCustomerId(customer.getId());
        paymentRepositary.deleteByCustomerId(customer);
        documentServices.findByCustomerId(customer.getId())
                .forEach(doc -> documentServices.remove(doc.getDocumentId()));
        attendanceRepositary.deleteByCustomerId(customer);



        //finally remove the customer.
        customerRepostitary.delete(customer);


        redirectAttributes.addFlashAttribute(
                "success_msg", "Person removed successfully");

        return "redirect:/customer/viewCustomers";
    }


}
