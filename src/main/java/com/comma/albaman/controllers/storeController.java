package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/store/*")
public class storeController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"calendar.do"},method=RequestMethod.GET)
	public String calendar() {
		
		return "calendar";
	}
	
	@RequestMapping(value={"edit_Schedule.do"},method=RequestMethod.GET)
	public String edit_Schedule() {
		
		return "edit_Schedule";
	}
	
	@RequestMapping(value={"test.do"},method=RequestMethod.GET)
	public String test() {
		
		return "test";
	}
}
