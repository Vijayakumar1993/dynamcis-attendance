package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Documents;
import com.attendence.Attendance.services.ConfigurationServices;
import com.attendence.Attendance.services.DocumentServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Controller
@RequestMapping("/documents")
public class DocumentsController {

    @Autowired
    private DocumentServices services;

    @Autowired
    private ConfigurationServices configurationServices;

    @PostMapping("upload")
    public String upload(@RequestParam("customerId") String customerId, @RequestParam("documentType") String documentType, @RequestParam("comments") String comments, Model model, MultipartFile file) throws IOException {
        Documents documents = new Documents();
        documents.setCustomerId(Long.parseLong(customerId));
        documents.setDocumentType(documentType);
        documents.setComments(comments);
        documents.setDocument(file.getBytes());
        String originalName = file.getOriginalFilename();
        String extension = "";

        if (originalName != null && originalName.contains(".")) {
            extension = originalName.substring(originalName.lastIndexOf(".") + 1);
        }
        documents.setExt(extension);
        services.upload(documents);
        return "redirect:/customer/viewCustomer/"+customerId;
    }

    @GetMapping("deleteDocument/{id}/{customerId}")
    public String deleteDocument(@PathVariable("id") String id, @PathVariable("customerId") String customerId){
        services.remove(Long.parseLong(id));
        return "redirect:/customer/viewCustomer/"+customerId;
    }
    @GetMapping("/download/{id}")
    public ResponseEntity<byte[]> downloadFile(@PathVariable Long id) {

        Documents c = services.findById(id);

        if (c == null || c.getDocument() == null) {
            return ResponseEntity.notFound().build();
        }

        // You can store filename + type in DB, or set default
        String fileName = "document_" + id + "."+c.getExt();

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + fileName)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(c.getDocument());
    }
}
