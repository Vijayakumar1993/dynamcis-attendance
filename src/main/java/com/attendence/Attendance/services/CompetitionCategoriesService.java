package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.CompetitionCategories;
import com.attendence.Attendance.repostitary.CompetitionCategoriesRepositary;
import jakarta.persistence.Entity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CompetitionCategoriesService {

    @Autowired
    private CompetitionCategoriesRepositary competitionCategoriesRepositary;

    @Transactional
    public void create(CompetitionCategories competitionCategories){
        competitionCategoriesRepositary.save(competitionCategories);
    }

    @Transactional
    public void removeByCompetition(Competition competition){
        List<CompetitionCategories> competitionCategoriesList = competitionCategoriesRepositary.findByCompetition(competition);
        if(competitionCategoriesList!=null && competitionCategoriesList.size()>0){
            competitionCategoriesList.forEach(competitionCategories -> competitionCategoriesRepositary.delete(competitionCategories));
        }
    }
}
