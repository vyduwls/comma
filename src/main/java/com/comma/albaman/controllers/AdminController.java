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
	
	// 회원 관리 페이지
	@RequestMapping(value={"manageMember.do"},method=RequestMethod.GET)
	public String manageMember() {
		System.out.println("\nAdminController의 manageMember.do(GET)");
		
		return "admin.manageMember";
	}
	
	// 점포 관리 페이지
	@RequestMapping(value={"manageStore.do"},method=RequestMethod.GET)
	public String manageStore() {
		System.out.println("\nAdminController의 manageStore.do(GET)");
		
		return "admin.manageStore";
	}
	
	// 문의 게시판 페이지
	@RequestMapping(value={"manageQNA.do"},method=RequestMethod.GET)
	public String manageQNA() {
		System.out.println("\nAdminController의 manageQNA.do(GET)");
		
		return "admin.manageQNA";
	}
}
