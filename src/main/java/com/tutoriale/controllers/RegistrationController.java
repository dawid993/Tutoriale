package com.tutoriale.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tutoriale.model.User;

@Controller
public class RegistrationController {

	@RequestMapping("index")
	public String showRegistration(Model model){
		model.addAttribute("account", new User());
		return "registration";
	}
}
