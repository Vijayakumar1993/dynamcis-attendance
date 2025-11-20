package com.attendence.Attendance.services;


import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.repostitary.AuthoritiesRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuthorityServices {

    @Autowired
    private AuthoritiesRepositary authoritiesRepositary;

    public void createAuthority(String username, String role, Long customerId){
        authoritiesRepositary.save(new Authorities(username, role, customerId));
    }
    public List<Authorities> findByIds(String username){
        return authoritiesRepositary.findByUsername(username);
    }

    public List<Authorities> findByCustomerId(Long customerId){
        return  authoritiesRepositary.findByCustomerId(customerId);
    }

    public int deleteByCustomerId(Long customerId){
        return  authoritiesRepositary.deleteByCustomerId(customerId);
    }
    public void deleteById(Long id){
          authoritiesRepositary.deleteById(id);
    }



}
