package com.attendence.Attendance.util;

import com.attendence.Attendance.entity.Attendance;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AttendanceRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.services.AuthorityServices;
import com.attendence.Attendance.services.ConfigurationServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.time.temporal.WeekFields;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class Utility {
    @Autowired
    private ConfigurationServices configurationServices;

    @Autowired
    private AttendanceRepositary attendanceRepositary;

    @Autowired
    private CustomerRepostitary repostitary;

    @Autowired
    private AuthorityServices services;

    public Customer getCustomer(String id){
        return repostitary.findById(Long.parseLong(id)).get();
    }

    public  List<Configuration> getConfigs(String name, String key){
        return configurationServices.findByConfigNameAndConfigKey(name,key);
    }

    public Configuration getConfig(String configId){
        if(configId!=null)
            return configurationServices.findByid(Long.parseLong(configId));
        return null;
    }
    public List<String> getCurrentUserRoles() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());
    }

    public List<Authorities> getAuthorites(String customerId){
        return services.findByCustomerId(Long.parseLong(customerId));
    }
    public void studentCountChart(String type,LocalDate from, LocalDate to, Model model){
        List<Customer> customers = repostitary.findByJoiningDateBetween(from,to);
        if(customers.size()>0 && type!=null){
            Map<String, Long> customersByJoinedDate = customers.stream()
                    .collect(Collectors.groupingBy(
                            c -> {
                                if(type.equalsIgnoreCase("Month")){
                                    return c.getJoiningDate()
                                            .getMonth()
                                            .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                                }else if(type.equalsIgnoreCase("Year")){
                                    return c.getJoiningDate()
                                            .getYear()+"";
                                }else{
                                    return c.getJoiningDate().toString();
                                }
                            },
                            Collectors.counting()
                    ));
            model.addAttribute("monthCountMap", customersByJoinedDate);
        }


        model.addAttribute("type", type);
        model.addAttribute("from",from);
        model.addAttribute("to",to);}

public void studentAttendanceChart(String type,LocalDate from, LocalDate to, Model model){
    List<Attendance> atts = attendanceRepositary.findByDateBetween(from,to);
    if(atts.size()>0 && type!=null){
        Map<String, Long> customersByAttendanceDate = atts.stream()
                .collect(Collectors.groupingBy(
                        c -> {
                            if(type.equalsIgnoreCase("Month")){
                                return c.getDate()
                                        .getMonth()
                                        .getDisplayName(TextStyle.FULL, Locale.ENGLISH);
                            }else if(type.equalsIgnoreCase("Year")){
                                return c.getDate()
                                        .getYear()+"";
                            }else{
                                return c.getDate().toString();
                            }
                        },
                        Collectors.counting()
                ));
        model.addAttribute("atMonthCountMap", customersByAttendanceDate);
    }


    model.addAttribute("atType", type);
    model.addAttribute("atFrom",from);
    model.addAttribute("atTo",to);}
}
