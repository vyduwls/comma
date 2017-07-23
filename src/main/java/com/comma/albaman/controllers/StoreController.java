package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/store/*")
public class StoreController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"calendar.do"},method=RequestMethod.GET)
	public String calendar() {
		System.out.println("\nStoreController의 calendar.do(GET)");
		
		return "store.calendar";
	}
	
	@RequestMapping(value={"editSchedule.do"},method=RequestMethod.GET)
	public String edit_Schedule() {
		System.out.println("\nStoreController의 editSchedule.do(GET)");
		
		return "store.editSchedule";
	}
	
	@RequestMapping(value={"test.do"},method=RequestMethod.GET)
	public String test() {
		System.out.println("\nStoreController의 test.do(GET)");
		
		return "store.test";
	}
	
	@RequestMapping(value={"recruit.do"},method=RequestMethod.GET)
	public String recruit() {
		System.out.println("\nStoreController의 recruit.do(GET)");
		
		return "store.recruit";
	}
}
