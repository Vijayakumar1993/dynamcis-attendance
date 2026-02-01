package com.attendence.Attendance.services;

import com.attendence.Attendance.constants.Status;
import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.repostitary.EventRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class EventServices {

    @Autowired
    private EventRepositary repositary;

    @Transactional
    public Event save(Event event){
        return repositary.save(event);
    }
    public List<Event> findAll(){
        return repositary.findAll();
    }

    public Event findById(Long id){
        return  repositary.findById(id).get();
    }

    public void removeById(Long id){
          repositary.deleteById(id);
    }
   public List<Event> filterEvents(Long id, LocalDate eventDate, Competition competition, Integer roundOf, String category, String gender, Status status){
        return repositary.filterEvents(id,eventDate,competition,roundOf,gender,category, status);
   }

    public List<Event> findByCompetitionAndParentEventId(Competition competition, Event parentEventId){
        return repositary.findByCompetitionAndParentEventId(competition, parentEventId);
    }
}
