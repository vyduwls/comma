package com.comma.albaman.controllers;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class IndexController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"index.do"},method=RequestMethod.GET)
	public String index(Model model) {
		System.out.println("\nIndexController의 index.do(GET)");
		
		return "index";
	}
}
