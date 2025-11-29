package com.attendence.Attendance.services;

import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.repostitary.ConfigurationRepostiary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ConfigurationServices {

    @Autowired
    private ConfigurationRepostiary repostiary;

    public void createOrUpdate(Configuration configuration){
        repostiary.save(configuration);
    }
    public void remove(Long id){
        repostiary.deleteById(id);
    }

    public List<Configuration> findAll(){
        return repostiary.findAll();
    }

    public Configuration findByid(Long id){
        return repostiary.findById(id).get();
    }

    public List<Configuration> findByConfigName(String configName){
        return repostiary.findByConfigName(configName);
    }

    public List<Configuration> findByConfigNameAndConfigKey(String configName, String configKey){
        return repostiary.findByConfigNameAndConfigKey(configName,configKey);
    }

}