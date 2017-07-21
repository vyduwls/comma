package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/store/*")
public class StoreController {
	
	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"calendar.do"},method=RequestMethod.GET)
	public String calendar() {
		
		return "store.calendar";
	}
}
