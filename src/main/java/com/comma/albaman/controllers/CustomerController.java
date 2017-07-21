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
@RequestMapping("/customer/*")
public class CustomerController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"login.do"},method=RequestMethod.POST)
	public String login(String mid, String pwd, Model model, HttpServletRequest request) {
		System.out.println("\nCustomerContoller의 login.do(POST)");
		
		System.out.println("mid : " + mid);
		System.out.println("pwd : " + pwd);
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member member = memberDAO.getMember(mid);
		
		if(member==null || !member.getPwd().equals(pwd)) {
			System.out.println("로그인 실패");
			model.addAttribute("error","1");
			
		} else {
			System.out.println("로그인 성공");
			request.getSession().setAttribute("mid", mid);
			model.addAttribute("error","0");
		}
		return "login.jsp";
	}
	
	@RequestMapping(value={"join.do"},method=RequestMethod.POST)
	public String join(String mid, Model model) {
		
		return "redirect:../index.do";
	}
}
