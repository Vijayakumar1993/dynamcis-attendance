package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.entity.Fixture;
import com.attendence.Attendance.repostitary.FixtureRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class FixtureServices {
    @Autowired
    private FixtureRepositary repositary;

    public Fixture createFixture(Fixture fixture){
       return repositary.save(fixture);
    }

    @Transactional
    public void removeFixture(Long id){
        repositary.deleteById(id);
    }
    public List<Fixture> findAllFixtures(){
        return repositary.findAll();
    }

    @Transactional
    public int deleteByEvent(Event event){
        return repositary.deleteByEventId(event);
    }
    public List<Fixture> findByEvent(Event event){
        return repositary.findByEventId(event);
    }
    public Fixture findById(Long id){
        return repositary.findById(id).get();
    }
}
