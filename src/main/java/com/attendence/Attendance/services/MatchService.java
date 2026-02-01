package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Customer;
import com.attendence.Attendance.entity.Event;
import com.attendence.Attendance.entity.Fixture;
import com.attendence.Attendance.entity.Match;
import com.attendence.Attendance.repostitary.MatchRepositary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.function.Function;

@Service
public class MatchService {

    @Autowired
    private MatchRepositary repositary;
    public Function<Customer, List<Match>> totalMatch = customer ->
            repositary.findAll().stream().filter(x-> x.getFrom().getCustomerId()==customer || x.getTo().getCustomerId()==customer ).toList();
    public Function<Customer, List<Customer>> successMatch = customer ->
            totalMatch.apply(customer).stream().map(Match::getSuccessor).map(Fixture::getCustomerId).filter(x->x == customer).toList();
    public Function<Customer, List<Customer>> failureMatch = customer ->
            totalMatch.apply(customer).stream().map(Match::getSuccessor).map(Fixture::getCustomerId).filter(x->x != customer).toList();


    public Match createMatch(Match match){
        return repositary.save(match);
    }

    public Match findMatch(Long id){
        return  repositary.findById(id).get();
    }
    public List<Match> findByEvent(Event event){
        return repositary.findByEvent(event);
    }
    public List<Match> findAll(){
        return repositary.findAll();
    }

    @Transactional
    public void deleteByEvent(Event event){
        repositary.deleteByEvent(event);
    }

    public List<Match> getMatchsForCustomers(Customer customer){
        return repositary.findMatchesByCustomer(customer);
    }
    public Map<String, Integer> getMatchByCustomer(Customer customer) {
        return Map.of(
                "total", totalMatch.apply(customer).size(),
                "success", successMatch.apply(customer).size(),
                "failure", failureMatch.apply(customer).size()
        );
    }

}
