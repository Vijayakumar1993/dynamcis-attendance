package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Documents;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.repostitary.DocumentRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Service
public class DocumentServices {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private DocumentRepositary repositary;

    public void upload(Documents documents){
        repositary.save(documents);
    }

    public List<Documents> findByCustomerId(Long customerId){
        List<Documents> documents = new LinkedList<>();
        customerRepostitary.findById(customerId).ifPresent(customer -> {
            documents.addAll(repositary.findByCustomerId(customer));
        });
        return documents;
    }
    public Documents findById(Long docId){
        return repositary.findById(docId).get();
    }
    public void remove(Long id){
        repositary.deleteById(id);
    }
    public Optional<Documents> findFirstByCustomerIdAndDocumentTypeOrderByDocumentIdDesc(Long customerId, String documentType){
      return  repositary.findFirstByCustomerIdAndDocumentTypeOrderByDocumentIdDesc(customerRepostitary.findById(customerId).get(), documentType);
    }
}

