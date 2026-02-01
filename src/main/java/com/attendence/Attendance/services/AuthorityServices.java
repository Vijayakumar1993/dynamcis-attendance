package com.attendence.Attendance.services;


import com.attendence.Attendance.constants.Roles;
import com.attendence.Attendance.entity.Authorities;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.repostitary.AuthoritiesRepositary;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Service
public class AuthorityServices {

    @Autowired
    private AuthoritiesRepositary authoritiesRepositary;


    @Autowired
    private CustomerRepostitary customerRepostitary;

    public void createAuthority(String username, Roles role, Long customerId){
        Optional<Customer> customer = customerRepostitary.findById(customerId);
        customer.ifPresent(customer1 -> {
            authoritiesRepositary.save(new Authorities(username, role, customer1));
        });
    }
    public List<Authorities> findByIds(String username){
        return authoritiesRepositary.findByUsername(username);
    }

    @Transactional(readOnly = true)
    public List<Authorities> findByCustomerId(Long customerId){
        List<Authorities> authorities = new LinkedList<>();
        Optional<Customer> customer = customerRepostitary.findById(customerId);
        if(customer.isPresent()){
            authorities.addAll(authoritiesRepositary.findByCustomerId(customer.get()));
        }
        return authorities;
    }

    @Transactional
    public int deleteByCustomerId(Long customerId){
        customerRepostitary.findById(customerId).ifPresent(customer -> authoritiesRepositary.deleteByCustomerId(customer));
        return 0;
    }
    public void deleteById(Long id){
          authoritiesRepositary.deleteById(id);
    }



}
