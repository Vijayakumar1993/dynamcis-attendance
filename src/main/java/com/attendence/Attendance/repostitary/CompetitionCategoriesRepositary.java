package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.CompetitionCategories;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompetitionCategoriesRepositary extends JpaRepository<CompetitionCategories, Long> {
    List<CompetitionCategories> findByCompetition(Competition competition);
}
