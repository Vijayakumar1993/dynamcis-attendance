package com.attendence.Attendance.controller;

import com.attendence.Attendance.entity.Configuration;
import com.attendence.Attendance.services.ConfigurationServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("settings")
public class ConfigurationController {
    @Autowired
    private ConfigurationServices services;

    @GetMapping("")
    public String home(){
        return "configuration";
    }
    @GetMapping("editConfig/{id}")
    public String editConfig(@PathVariable("id") String id, Model model){
        Configuration configuration = services.findByid(Long.parseLong(id));
        model.addAttribute("configuration",configuration);
        return "configuration";
    }

    @GetMapping("deleteConfig/{id}")
    public String deleteConfig(@PathVariable("id") String id, Model model){
        services.remove(Long.parseLong(id));
        return "redirect:/settings/viewConfigurations";
    }



    @PostMapping("createConfiguration")
    public String createConfiguration(@ModelAttribute Configuration configuration){
        services.createOrUpdate(configuration);
        return "redirect:/settings/viewConfigurations";
    }

    @GetMapping("viewConfigurations")
    public String findConfiguration(Model model){
        List<Configuration> configurations = services.findAll();
        model.addAttribute("configList",configurations);
        return "findConfigurations";
    }
}
