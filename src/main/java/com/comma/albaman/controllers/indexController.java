package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class indexController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"index.do"},method=RequestMethod.GET)
	public String index(String mid, Model model) {
		
		return "index";
	}

	@RequestMapping(value={"store/calendar.do"},method=RequestMethod.GET)
	public String calendar() {
		
		return "calendar";
	}
}
