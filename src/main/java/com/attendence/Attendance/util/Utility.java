package com.attendence.Attendance.util;

import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.services.ConfigurationServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class Utility {
    @Autowired
    private ConfigurationServices configurationServices;

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
}
