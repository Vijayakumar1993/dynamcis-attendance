package com.attendence.Attendance.services;

import com.attendence.Attendance.controller.CustomerController;
import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.exceptions.ValidationException;
import com.attendence.Attendance.model.UploadError;
import com.attendence.Attendance.model.UploadResult;
import com.attendence.Attendance.repostitary.CustomerRepostitary;
import com.attendence.Attendance.util.Utility;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.time.LocalDate;

@Service
public class PlayerUploadService {

    @Autowired
    private CustomerRepostitary customerRepostitary;

    @Autowired
    private Utility utility;

    private Customer mapToPlayer(
            String[] c, Long teamId, String category) {

        Customer p = new Customer();
        p.setName(c[0]);
        p.setGuardianName(c[1]);
        p.setPhone(c[2]);
        p.setGender(c[3]);
        p.setTeam(utility.getTeam(teamId));
        p.setEmail(c[4]);
        p.setDob(LocalDate.parse(c[5]));
        p.setWeight(Float.parseFloat(c[6]));
        p.setAddress(c[7]);
        p.setCategory(category);
        p.setStatus("ACTIVE");
        p.setPack("28");
        return p;
    }

    public UploadResult processFile(
            MultipartFile file,
            Long teamId,
            String category,
            HttpSession session, Model model) {

        UploadResult result = new UploadResult();

        try {
            String filename = file.getOriginalFilename();

            if (filename.endsWith(".csv")) {
                processCSV(file, teamId, category, result, session, model);
            } else {
                result.addError(new UploadError(
                        0, "file", filename, "Unsupported file format"));
            }

        } catch (Exception e) {
            result.addError(new UploadError(
                    0, "file", "", e.getMessage()));
        }

        return result;
    }

    @Autowired
    private CustomerController customerController;

    private void processCSV(
            MultipartFile file,
            Long teamId,
            String category,
            UploadResult result, HttpSession session, Model model) throws Exception {

        BufferedReader reader =
                new BufferedReader(new InputStreamReader(file.getInputStream()));

        String line;
        int row = 1; // header skipped
        reader.readLine();

        while ((line = reader.readLine()) != null) {
            row++;
            String[] cols = line.split(",");

            try {
                Customer player = mapToPlayer(cols, teamId, category);
                validate(player);
                customerController.createCustomer(teamId.toString(),"ROLE_PLAYER",session,player, model);
                result.incrementSuccess();

            } catch (ValidationException ex) {
                result.addError(new UploadError(
                        row, ex.getField(), ex.getValue(), ex.getMessage()));
            }
        }
    }
    private void validate(Customer p) {

        if (p.getName() == null || p.getName().isEmpty())
            throw new ValidationException("name", "", "Name is required");

        if (!p.getGender().matches("male|female|other"))
            throw new ValidationException("gender", p.getGender(),
                    "Invalid gender value");

        if (p.getPhone().length() != 10)
            throw new ValidationException("phone", p.getPhone(),
                    "Phone number must be 10 digits");

        if (customerRepostitary.findByPhone(p.getPhone()).size()>0)
            throw new ValidationException("phone", p.getPhone(),
                    "Phone already exists");
    }
}