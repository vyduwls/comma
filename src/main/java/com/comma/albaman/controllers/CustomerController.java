package com.comma.albaman.controllers;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.util.SendMail;
import com.comma.albaman.vo.Member;

@Controller
@RequestMapping("/customer/*")
public class CustomerController {

	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping(value={"login.do"},method=RequestMethod.POST)
	@ResponseBody
	public String login(String mid, String pwd, HttpServletRequest request) {
		System.out.println("\nCustomerContoller의 login.do(AJAX)");
		
		System.out.println("mid : " + mid);
		System.out.println("pwd : " + pwd);
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member member = memberDAO.getMember(mid);
		
		String error = null;
		
		if(member==null || !member.getPwd().equals(pwd)) {
			System.out.println("로그인 실패");
			error = "1";
			
		} else {
			System.out.println("로그인 성공");
			request.getSession().setAttribute("mid", mid);
			error = "0";
		}
		
		return error;
	}
	
	@RequestMapping(value={"logout.do"},method=RequestMethod.GET)
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:../index.do";
	}
	
	@RequestMapping(value={"checkId.do"},method=RequestMethod.POST)
	@ResponseBody
	public String checkId(String mid) {
		System.out.println("\nCustomerContoller의 checkId.do(AJAX)");
		
		System.out.println("mid : " + mid);
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member member = memberDAO.getMember(mid);
		
		String result = null;
		
		if(member!=null) {
			System.out.println("아이디 중복");
			result = "1";
		} else {
			System.out.println("아이디 중복 X");
			result = "0";
		}
		
		return result;
	}
	
	@RequestMapping(value={"join.do"},method=RequestMethod.POST)
	public String join(Member member) {
		System.out.println("\nCustomerContoller의 join.do(POST)");
		
		System.out.println("mid : " + member.getMid());
		System.out.println("pwd : " + member.getPwd());
		System.out.println("name : " + member.getName());
		System.out.println("phone : " + member.getPhone());
		System.out.println("email : " + member.getEmail());
		System.out.println("position : " + member.getPosition());
		
		member.setPosition("점주");
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		int result = memberDAO.addMember(member);
		if(result == 1) {
			System.out.println("회원가입 성공");
		} else {
			System.out.println("회원가입 실패");
		}
		
		return "redirect:../index.do";
	}
	
	@RequestMapping(value={"sendAuthentication.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String sendAuthentication(String mid, String email, HttpServletRequest request){
		System.out.println("\nCustomerController의 sendAuthentication.do(AJAX)");
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member member = memberDAO.getMember(mid);
		
		String result = "0";
		
		if(member==null || !email.equals(member.getEmail())) {
			return result;
		} else {
			SendMail sm = new SendMail(email);
			sm.login("senseproject", "jang7102@");
			
			int authNum = (int) (Math.random()*1000000)+1;
			request.getSession().setAttribute("authNum", authNum);
			String content = "<div class='container' style='width:500px; border:1px solid lightGrey;'>"
					+ "<h4 style='background-color:rgb(66,133,244); color:white; margin-top:0px; padding:5px 0px 5px 10px'>ALBAMAN 이메일 인증</h4>"
					+ "<br>"
					+ "<h3 style='margin-left:15px; color:(66,133,244)'>인증번호(6자리) : </h3>"
					+ "<h2 style='margin-left:20px'><b>" + authNum
					+ "</b></h2>"
					+ "<p style='margin:20px 0px 20px 15px; color:grey'>발신 전용 이메일입니다. 궁금하신 사항은 <a href='www.naver.com'>ALBAMAN 고객센터</a>로 문의하시기 바랍니다.</p>"
					+ "</div>";
			
			
			result = sm.sendMail("ALBAMAN 인증번호", content, true);
			return result;
		}
	}
	
	@RequestMapping(value={"findPwd.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String checkAuthentication(HttpServletRequest request, String mid, String checkAuthNum, Model model) {
		System.out.println("\nCustomerController의 findPwd.do(AJAX)");
		
		int iAuthNum = (Integer) request.getSession().getAttribute("authNum");
		String authNum = Integer.toString(iAuthNum); 
		
		String result = null;
		
		if(authNum.equals(checkAuthNum)) {
			MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
			Member member = memberDAO.getMember(mid);
			result = member.getPwd();
		} else {
			result = "1";
		}
		return result;
	}
}
