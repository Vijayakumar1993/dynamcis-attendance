package com.attendence.Attendance.services;

import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class LoginServices {

    @Autowired
    private LoginRepositary loginRepositary;

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private AuthorityServices authorityServices;
    @Autowired
    private PasswordEncoder encoder;

    @Transactional
    public Boolean createLogin(Users users, Roles roles){
        List<Users> existingUsers = loginRepositary.findByUsername(users.getUsername());
        if(existingUsers.size()>0 && users.getId()==null){
            return false;
        }

        List<Authorities> existingAuthorites = authorityServices.findByCustomerId(users.getCustomerId().getId());
        if(existingAuthorites.size()>0){
            existingAuthorites.stream().filter(x->x.getUsername()==users.getUsername()).forEach(authorities -> {
                authorityServices.deleteByCustomerId(authorities.getId());
            });
            existingAuthorites.stream().map(Authorities::getAuthority)
                    .collect(Collectors.toSet())
                    .forEach(authorities -> authorityServices.createAuthority(users.getUsername(),authorities, users.getCustomerId().getId()));
        }else{
            authorityServices.createAuthority(users.getUsername(), roles, users.getCustomerId().getId());
        }
        users.setPassword(encoder.encode(users.getPassword()));
        loginRepositary.save(users);
        return true;
    }


    public List<Users> findUsers(String customerId){
        List<Users> users  = new LinkedList<>();
        customerRepostitary.findById(Long.parseLong(customerId)).ifPresent(customer -> {
            users.addAll(loginRepositary.findByCustomerId(customer));
        });
        return  users;
    }
    public void disable(Users user,Boolean isEnable){
        Users existingUser  = loginRepositary.findById(user.getId()).get();
        if(existingUser!=null){
            existingUser.setEnabled(isEnable);
            loginRepositary.save(existingUser);
        }
    }

    public void updatePassword(Users user){
        Users existingUser  = loginRepositary.findById(user.getId()).get();
        if(existingUser!=null){
            existingUser.setPassword(encoder.encode(user.getPassword()));
            loginRepositary.save(existingUser);
        }
    }
}
