package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.CompetitionTeam;
import com.attendence.Attendance.entity.Team;
import com.attendence.Attendance.repostitary.CompetitionTeamRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CompetitionTeamService {

    @Autowired
    private CompetitionTeamRepositary repositary;

    public CompetitionTeam create(CompetitionTeam competition){
        return repositary.save(competition);
    }
    public List<CompetitionTeam> createAll(List<CompetitionTeam> competitionTeams){
        return repositary.saveAll(competitionTeams);
    }
    public List<CompetitionTeam> findByCompetitionAndTeam(Competition competition, Team team){
        return repositary.findByCompetitionAndTeam(competition, team);
    }

    public List<CompetitionTeam> findByCompetition(Competition competition){
        return repositary.findByCompetition(competition);
    }
    public CompetitionTeam findById(String id){
        return repositary.findById(Long.parseLong(id)).get();
    }

    public void removeCompetitionTEams(){
        repositary.deleteAll();
    }
    @Transactional
    public void removeByCompetition(Competition competition){
        repositary.deleteByCompetition(competition);
    }
    public void removeById(Long id){
        repositary.deleteById(id);
    }

    @Transactional
    public void deleteByCompetitionAndTeam(Competition competition, Team team){
        repositary.deleteByCompetitionAndTeam(competition, team);
    }
}
