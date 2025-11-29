package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Documents;
import com.attendence.Attendance.repostitary.DocumentRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DocumentServices {

    @Autowired
    private DocumentRepositary repositary;

    public void upload(Documents documents){
        repositary.save(documents);
    }

    public List<Documents> findByCustomerId(Long customerId){
        return repositary.findByCustomerId(customerId);
    }
    public Documents findById(Long docId){
        return repositary.findById(docId).get();
    }
    public void remove(Long id){
        repositary.deleteById(id);
    }
}

