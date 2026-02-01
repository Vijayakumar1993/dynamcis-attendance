package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.MedalReport;
import com.attendence.Attendance.repostitary.MedalRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MedalReportService {

    @Autowired
    private MedalRepositary medalRepositary;

    public MedalReport findFirstByWeightDefinationAndCategoryDefinationAndGenderDefinationAndCompetition(String weight, String category, String gender, Competition competition){
        return medalRepositary.findFirstByWeightDefinationAndCategoryDefinationAndGenderDefinationAndCompetition(weight, category, gender,competition);
    }
    public List<MedalReport> findByCompetition(Competition competition){
        return medalRepositary.findByCompetition(competition);
    }
    public MedalReport create(MedalReport medalReport){
        return medalRepositary.save(medalReport);
    }

    public void removeByCompetition(Competition competition){
        medalRepositary.deleteByCompetition(competition);
    }

    public List<MedalReport> getMedalReports(){
        return medalRepositary.findAll();
    }
    public Object[] getOverallMedalStats(){
        return medalRepositary.getOverallMedalStats();
    }

    public List<Object[]> medalsByGender(){
        return  medalRepositary.medalsByGender();
    }

    public List<Object[]> medalsByCategory(){
        return medalRepositary.medalsByCategory();
    }

    public List<Object[]> medalsByWeight(){
        return medalRepositary.medalsByWeight();
    }

    public List<Object[]> topGoldWinners(){
        return medalRepositary.topGoldWinners();
    }
    public List<Object[]> medalsByTeam(){
        return medalRepositary.medalsByTeam();
    }
}
