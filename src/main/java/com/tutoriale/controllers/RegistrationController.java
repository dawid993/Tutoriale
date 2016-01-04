package com.tutoriale.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tutoriale.model.User;
import com.tutoriale.repository.UserRepository;

@Controller
public class RegistrationController {

	@Autowired UserRepository userRepository;
	
	@RequestMapping("register")
	public String showRegistration(Model model){
		model.addAttribute("account", new User());
		return "registration";
	}
	
	@RequestMapping(value="register",method=RequestMethod.POST)
	public String evaluateRegister(@ModelAttribute("account")User newUser){
		System.out.println(newUser);
		newUser.setEnabled(1);
		userRepository.save(newUser);
		return "greating";
	}
}
