package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.CompetitionTeam;
import com.attendence.Attendance.entity.Team;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompetitionTeamRepositary extends JpaRepository<CompetitionTeam, Long> {
    List<CompetitionTeam> findByCompetitionAndTeam(Competition competition, Team team);
    List<CompetitionTeam> findByCompetition(Competition competition);
    int deleteByCompetition(Competition competition);
    int deleteByCompetitionAndTeam(Competition competition, Team team);
}
