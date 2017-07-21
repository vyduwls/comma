package com.comma.albaman.controllers;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.vo.Member;

@Controller
public class IndexController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"index.do"},method=RequestMethod.GET)
	public String index(HttpServletRequest request, Model model) {
		System.out.println("\nIndexController의 index.do(GET)");
		
		String mid = (String) request.getSession().getAttribute("mid");
		if(mid!=null) {
			MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
			Member member = memberDAO.getMember(mid);
			model.addAttribute("member", member);			
		}
		
		return "index";
	}
}
