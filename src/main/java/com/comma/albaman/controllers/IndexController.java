package com.comma.albaman.controllers;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.dao.ScheduleDAO;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Schedule;

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
			
			// 출근 시간 15분 전에 버튼 생기게 만들기
			ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
			int onWork = scheduleDAO.possibleOnWork(mid);
			model.addAttribute("onWork",onWork);
			System.out.println("출근 가능 : " + onWork);
			
			// 출근 완료 && 퇴근 시간 이후에 버튼 생기게 만들기
			int offWork = scheduleDAO.possibleOffWork(mid);
			model.addAttribute("offWork",offWork);
			System.out.println("퇴근 가능 : " + offWork);
		}
		
		return "index";
	}
}
