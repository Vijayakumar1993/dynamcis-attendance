package com.attendence.Attendance.repostitary;

import com.attendence.Attendance.entity.Competition;
import com.attendence.Attendance.entity.MedalReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MedalRepositary extends JpaRepository<MedalReport, Long> {
    MedalReport findFirstByWeightDefinationAndCategoryDefinationAndGenderDefinationAndCompetition(String weight, String category, String gender, Competition competition);
    List<MedalReport> findByCompetition(Competition competition);
    int deleteByCompetition(Competition competition);

    @Query("""
        SELECT 
            COUNT(m.gold),
            COUNT(m.silver),
            COUNT(m.bronze1) + COUNT(m.bronze2),
            COUNT(m)
        FROM MedalReport m
    """)
    Object[] getOverallMedalStats();
    @Query("""
    SELECT m.genderDefination,
           COUNT(m.gold),
           COUNT(m.silver),
           COUNT(m.bronze1) + COUNT(m.bronze2)
    FROM MedalReport m
    GROUP BY m.genderDefination
""")
    List<Object[]> medalsByGender();
    @Query("""
    SELECT m.categoryDefination,
           COUNT(m.gold),
           COUNT(m.silver),
           COUNT(m.bronze1) + COUNT(m.bronze2)
    FROM MedalReport m
    GROUP BY m.categoryDefination
""")
    List<Object[]> medalsByCategory();
    @Query("""
    SELECT m.weightDefination,
           COUNT(m.gold),
           COUNT(m.silver),
           COUNT(m.bronze1) + COUNT(m.bronze2)
    FROM MedalReport m
    GROUP BY m.weightDefination
""")
    List<Object[]> medalsByWeight();

    @Query("""
    SELECT m.gold, COUNT(m)
    FROM MedalReport m
    GROUP BY m.gold
    ORDER BY COUNT(m) DESC
""")
    List<Object[]> topGoldWinners();

    @Query(value = """
    SELECT t.team_name, COUNT(*) AS total_medals
    FROM (
        SELECT c.team_id
        FROM medal_report mr
        JOIN customers c ON c.id = mr.gold_customer

        UNION ALL
        SELECT c.team_id
        FROM medal_report mr
        JOIN customers c ON c.id = mr.silver_customer

        UNION ALL
        SELECT c.team_id
        FROM medal_report mr
        JOIN customers c ON c.id = mr.bronze1_customer

        UNION ALL
        SELECT c.team_id
        FROM medal_report mr
        JOIN customers c ON c.id = mr.bronze2_customer
    ) medals
    JOIN team t ON t.id = medals.team_id
    GROUP BY t.team_name
    ORDER BY total_medals DESC 
""", nativeQuery = true)
    List<Object[]> medalsByTeam();
}
