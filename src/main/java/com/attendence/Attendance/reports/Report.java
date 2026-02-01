package com.attendence.Attendance.reports;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Event;
import com.itextpdf.text.DocumentException;

import java.util.List;

public interface Report {
    void generateReport(Competition event) throws DocumentException;
    void generateReport(List<Event> event, String title) throws DocumentException;
}