package com.comma.albaman.controllers;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.dao.RecruitDAO;
import com.comma.albaman.dao.ScheduleDAO;
import com.comma.albaman.dao.StoreDAO;
import com.comma.albaman.util.SendMail;
import com.comma.albaman.vo.Employee;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Recruit;
import com.comma.albaman.vo.Schedule;
import com.comma.albaman.vo.Store;

@Controller
@RequestMapping("/customer/*")
public class CustomerController {

	@Autowired
	private SqlSession sqlSession;
	
	// 로그인
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
			if(member.getPosition().equals("점주")){
				request.getSession().setAttribute("mid", mid);
				request.getSession().setAttribute("checkPosition", "1");
				error = "0";
			}else{
				request.getSession().setAttribute("mid", mid);
				request.getSession().setAttribute("checkPosition", "2");
				error = "0";
			}
		}
		
		return error;
	}
	
	// 로그아웃
	@RequestMapping(value={"logout.do"},method=RequestMethod.GET)
	public String logout(HttpServletRequest request) {
		request.getSession().invalidate();
		return "redirect:../index.do";
	}
	
	// 아이디 중복 확인
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
	
	// 회원가입
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
	
	// 인증번호 전송
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
	
	// 비밀번호 찾기
	@RequestMapping(value={"findPwd.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String findPwd(HttpServletRequest request, String mid, String checkAuthNum, Model model) {
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
	
	// 출근하기
	@RequestMapping(value={"onWork.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String onWork(String rid) {
		System.out.println("\nCustomerController의 onWork.do(AJAX)");
		
		System.out.println("넘어온 rid : " + rid);
		
		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		
		// 현재 시간과 가장 가까운 예상 출근 시간을 가진 스케줄의 출근 시간을 설정
		String sseq = scheduleDAO.getClosestPreOnWork(rid);
		int result = scheduleDAO.setOnWork(sseq);
		
		if(result != 0) {
			System.out.println("출근 완료");
			return "1";
		} else {
			System.out.println("출근 실패");
			return "0";
		}
	}
	
	// 퇴근하기
	@RequestMapping(value={"offWork.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String preOffWork(String rid) {
		System.out.println("\nCustomerController의 offWork.do(AJAX)");
		
		System.out.println("넘어온 rid : " + rid);
		
		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		
		// 현재 시간과 가장 가까운 예상 퇴근 시간을 가진 스케줄의 퇴근 시간을 설정
		String sseq = scheduleDAO.getClosestPreOffWork(rid);
		int result = scheduleDAO.setOffWork(sseq);
		
		if(result != 0) {
			System.out.println("퇴근 완료");
			return "1";
		} else {
			System.out.println("퇴근 실패");
			return "0";
		}
	}
	@RequestMapping(value={"checkSalary.do"}, method=RequestMethod.GET)
	public String checkSalary(HttpServletRequest request,Model model,String selectMonth,String selectYear){
		System.out.println("\nStoreController의 checkSalary.do(GET)");
		
		String mid = (String) request.getSession().getAttribute("mid");
		
		// 직원 전체 정보 가져오기
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member memberData=memberDAO.getMember(mid);
		RecruitDAO recruitDAO=sqlSession.getMapper(RecruitDAO.class);
		Recruit recruitData=recruitDAO.getRecruit(mid);
		
		//해당 직원 스케줄 가져오기
//		날짜 변환
		if(selectMonth==null || selectMonth.equals("")){
			selectMonth=new SimpleDateFormat("MM").format(new Date());
		}
		if(selectYear==null ||selectYear.equals("")){
			selectYear=new SimpleDateFormat("yyyy").format(new Date());
		}

		int year=Integer.parseInt(selectYear);
		int month=Integer.parseInt(selectMonth);
		String preMonth="";
		if(month<=9){
			preMonth="0"+month;
		}
		String prework=year+"-"+preMonth;
		System.out.println("prework===="+prework);
//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);
		List<Schedule> allSchedule=scheduleDAO.getWorkTime(mid, prework);
		
		String allScheduleString="";
		for (int i = 0; i < allSchedule.size(); i++) {
			if(i==allSchedule.size()-1){
				allScheduleString+=allSchedule.get(i).getOnWork().substring(0, 16)+"_"+allSchedule.get(i).getOffWork().substring(0, 16)
				+"_"+recruitData.getWage();
			}else{
				allScheduleString+=allSchedule.get(i).getOnWork().substring(0, 16)+"_"+allSchedule.get(i).getOffWork().substring(0, 16)
			    +"_"+recruitData.getWage()+",";
			}
		}
		model.addAttribute("joinYear", recruitData.getJoinDate().split("-")[0]);
		System.out.println("allScheduleString-----"+allScheduleString);
		model.addAttribute("year",selectYear);
		model.addAttribute("month",selectMonth);
		model.addAttribute("memberData",memberData);
		model.addAttribute("recruitData",recruitData);
		model.addAttribute("allSchedule",allSchedule);
		model.addAttribute("allScheduleString",allScheduleString);
		return "customer.checkSalary";
	}
}
