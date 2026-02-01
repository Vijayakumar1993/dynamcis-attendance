package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.reports.EventListReport;
import com.attendence.Attendance.reports.EventReport;
import com.attendence.Attendance.reports.FixturesPdf;
import com.attendence.Attendance.services.CompetitionService;
import com.attendence.Attendance.services.EventServices;
import com.itextpdf.text.DocumentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

@Controller
@RequestMapping("/reports")
public class ReportsController {

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private FixturesPdf fixturesPdf;

    @Autowired
    private EventReport eventReport;

    @Autowired
    private EventListReport eventListReport;

    @Autowired
    private EventServices eventServices;

    @GetMapping("/fixture/{id}")
    public ResponseEntity<byte[]> fixtureReport(@PathVariable Long id) throws DocumentException, IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        // Initialize PDF to write into memory
        fixturesPdf.init(outputStream);
        fixturesPdf.generateReport(competitionService.find(id));

        return download(outputStream,"Fixture-"+id);
    }
    @PostMapping("event")
    public ResponseEntity<byte[]> eventReport(@RequestParam("compId") Long compId, @RequestParam("eventId") Long eventId) throws DocumentException, IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        // Initialize PDF to write into memory
        eventReport.init(outputStream);
        eventReport.generateReport(competitionService.find(compId), eventServices.findById(eventId));

        return download(outputStream,"Bout-"+compId+"-"+eventId);
    }
    @PostMapping("eventList")
    public ResponseEntity<byte[]> eventListReport(@RequestParam("eventId") String eventIds, @RequestParam("bout") Integer bout) throws DocumentException, IOException {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        eventListReport.init(outputStream);
        List<String> evIds = new LinkedList<>();
        if(eventIds!=null && !eventIds.isBlank() && !eventIds.isEmpty()){
            if(eventIds.contains(",")){
                evIds = Arrays.stream(eventIds.split(",")).toList();
            }else{
                evIds.add(eventIds);
            }
        }
        List<Event> events = evIds.stream().map(eventId->eventServices.findById(Long.parseLong(eventId))).toList();
        eventListReport.generateReport(events,"Bout_List_"+bout,bout);

        return download(outputStream,"Bout-List-");
    }

    public ResponseEntity download(ByteArrayOutputStream stream, String fileName){
        byte[] pdfBytes = stream.toByteArray();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDisposition(
                ContentDisposition.inline()
                        .filename(fileName+"pdf")
                        .build()
        );
        headers.setContentLength(pdfBytes.length);
        return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);
    }
}
