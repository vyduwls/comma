package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/admin/*")
public class AdminController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"adminPage.do"},method=RequestMethod.GET)
	public String adminPage() {
		System.out.println("\nAdminController의 adminPage.do(GET)");
		
		return "admin.adminPage";
	}
}
