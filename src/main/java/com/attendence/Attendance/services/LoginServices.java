package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Users;
import com.attendence.Attendance.repostitary.AuthoritiesRepositary;
import com.attendence.Attendance.repostitary.LoginRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginServices {

    @Autowired
    private LoginRepositary loginRepositary;

    @Autowired
    private AuthoritiesRepositary authoritiesRepositary;

    @Autowired
    private PasswordEncoder encoder;

    @Transactional
    public void createLogin(Users users){
        loginRepositary.save(users);
        authoritiesRepositary.save(new Authorities(users.getUsername(),"ROLE_USER"));
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
