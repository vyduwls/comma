package com.comma.albaman.controllers;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.PlatformTransactionManager;
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
import com.comma.albaman.vo.Employee;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Recruit;
import com.comma.albaman.vo.Schedule;
import com.comma.albaman.vo.Store;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@Controller
@RequestMapping("/store/*")
public class StoreController {

	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	PlatformTransactionManager ptm;
	
	@RequestMapping(value={"calendar.do"},method=RequestMethod.GET)
	public String calendar() {
		System.out.println("\nStoreController의 calendar.do(GET)");
		
		return "store.calendar";
	}
	
	@RequestMapping(value={"editSchedule.do"},method=RequestMethod.GET)
	public String edit_Schedule(HttpServletRequest request,Model model,String selectMonth,String selectYear,String emName,String sid) {
		System.out.println("\nStoreController의 editSchedule.do(GET)");
		
		String mid=(String) request.getSession().getAttribute("mid");
		String checkPosition=(String) request.getSession().getAttribute("checkPosition");
		
		RecruitDAO recruitDao=sqlSession.getMapper(RecruitDAO.class);
		MemberDAO memberDAO=sqlSession.getMapper(MemberDAO.class);
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);
		StoreDAO storeDAO=sqlSession.getMapper(StoreDAO.class);
		
		
		Recruit employee=new Recruit();
		Store storeInfo=new Store();
		List<Store> storeList=new ArrayList<Store>();
		if(checkPosition.equals("2")){
//		rid로 직원 정보 가져오기
			employee=recruitDao.getRecruit(mid);
			storeInfo=storeDAO.getStore(employee.getSid());
		}else if(checkPosition.equals("1")){
			storeList=storeDAO.getAllStore(mid);
			if(sid==null || sid.equals("")){
				storeInfo=storeList.get(0);
			}else{
				storeInfo=storeDAO.getStore(sid);
			}
			
		}
//		가져온 직원 정보에서 sid로 전체 직원 추출
		List<Recruit> allEmployee=recruitDao.getAllRecruit(storeInfo.getSid());
//		전체 직원 rid String 으로 변환
		String allEmployeeRid="";
		String allEmployeeRids="";
		for (int i = 0; i < allEmployee.size(); i++) {
			if(i==allEmployee.size()-1){
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'";
				allEmployeeRids+=allEmployee.get(i).getRid();
			}else{
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'"+",";
				allEmployeeRids+=allEmployee.get(i).getRid()+",";
			}
		}
		List<Member> memberList=new ArrayList<Member>();
//		스트링으로 변환한 rid로 멤버 리스트 추출
		if(allEmployeeRid!=null && !allEmployeeRid.equals("")){
		memberList=memberDAO.getAllMember(allEmployeeRid);	
		}
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
			preMonth="0"+selectMonth;
		}
		String prework=year+"-"+preMonth;
//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		
		List<Schedule> allSchedule=scheduleDAO.getSchedule(storeInfo.getSid(), prework);
		
		
//  	멤버 mid-날짜 스트링으로 만들어서 가져가기	
		String allScheduleString="";
		String memberRidArray="";
		for (int i = 0; i < allSchedule.size(); i++) {
			if(i==allSchedule.size()-1){
				allScheduleString+=allSchedule.get(i).getRid()+"-"+allSchedule.get(i).getPreOnWork().substring(0, 10);
			}else{
				allScheduleString+=allSchedule.get(i).getRid()+"-"+allSchedule.get(i).getPreOnWork().substring(0, 10)+",";
			}
		}
		model.addAttribute("allEmployeeRids", allEmployeeRids);
		model.addAttribute("allScheduleString", allScheduleString);
		model.addAttribute("storeList", storeList);
		model.addAttribute("storeInfo", storeInfo);
		model.addAttribute("storeRegYear", storeInfo.getRegDate().split("-")[0]);
		model.addAttribute("memberList", memberList);
		model.addAttribute("month", month);
		model.addAttribute("year", year);
		model.addAttribute("emName", emName);
		return "store.editSchedule";
	}
	
	//스케줄 저장 ajax
	@RequestMapping(value={"saveSchedule.do"},method=RequestMethod.GET)
	@ResponseBody
	public String saveSchedule(String stringSchedule,String allEmployeeRids,String deleteDate){
		System.out.println("\nStoreController의 saveSchedule.do(GET)");	
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);

		if(stringSchedule.equals("")||stringSchedule==null){
			stringSchedule="0";
		}		
		String[] schedules=stringSchedule.split(",");
		String[] memberRids=allEmployeeRids.split(",");
		//기존 스케줄 지우기
		for (int i = 0; i < memberRids.length; i++) {
			String rid=memberRids[i];
			scheduleDAO.deleteSchedule(rid, deleteDate);
		}
		// 스케줄 추가
		for (int i = 0; i < schedules.length; i++) {
			Schedule schedule=new Schedule();
			String[] info=schedules[i].split("-");
			String date=deleteDate+"-"+info[3];
			schedule.setRid(info[0]);
			schedule.setPreOnWork(date);
			schedule.setPreOffWork(date);

			scheduleDAO.insertSchedule(schedule);
		}

		return stringSchedule;
	}
		
	@RequestMapping(value={"recruit.do"},method=RequestMethod.GET)
	public String recruit(HttpServletRequest request, Model model) {
		System.out.println("\nStoreController의 recruit.do(GET)");
		
		String mid = (String) request.getSession().getAttribute("mid");
		
		// 소유한 가게 가져오기
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		List<Store> storeList = storeDAO.getAllStore(mid);
		model.addAttribute("storeList", storeList);
		
		// 직원 전체 정보 가져오기
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		System.out.println("storeList.get(0).getSid() : " + storeList.get(0).getSid());
		List<Employee> employeeList = memberDAO.getEmployee(storeList.get(0).getSid());
		model.addAttribute("employeeList",employeeList);
		
		return "store.recruit";
	}

	@RequestMapping(value={"addRecruit.do"},method=RequestMethod.GET)
	public String addRecruit(HttpServletRequest request, Model model) {
		System.out.println("\nStoreController의 addRecruit.do(GET)");
		
		String mid = (String) request.getSession().getAttribute("mid");
		
		// 소유한 가게 가져오기
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		List<Store> storeList = storeDAO.getAllStore(mid);
		model.addAttribute("storeList", storeList);
		
		return "store.addRecruit";
	}
	
	@RequestMapping(value={"createId.do"},method=RequestMethod.POST)
	@ResponseBody
	public String createId(String sid) {
		System.out.println("\nStoreController의 createId.do(AJAX)");
		
		System.out.println("선택된 sid : " + sid);
		
		RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);
		int last = recruitDAO.getLastRecruit(sid)+1;

		String mid = sid + "-" + Integer.toString(last);
		
		return mid;
	}
	
	@RequestMapping(value={"addRecruit.do"},method=RequestMethod.POST)
	public String addRecruit(String store, String mid, String pwd, String name, String phone, String email, 
			String position, String birth, String address, int wage, String joinDate) {
		System.out.println("\nStoreController의 addRecruit.do(GET)");
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member member = new Member();
		member.setMid(mid);
		member.setPwd(pwd);
		member.setName(name);
		member.setPhone(phone);
		member.setEmail(email);
		member.setPosition(position);
		
		RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);
		Recruit recruit = new Recruit();
		recruit.setRid(mid);
		recruit.setBirth(birth);
		recruit.setAddress(address);
		recruit.setWage(wage);
		recruit.setJoinDate(joinDate);
		recruit.setSid(store);
		
		int result = 0;
		TransactionDefinition td = new DefaultTransactionDefinition();
		TransactionStatus ts = ptm.getTransaction(td);
		 try {
			 System.out.println("트랜잭션 완료");
			 result = memberDAO.addMember(member);
			 result += recruitDAO.addRecruit(recruit);
			 ptm.commit(ts);
		 } catch (Exception e) {
			 ptm.rollback(ts);
			 System.out.println("트랜잭션 실패");
		}
		
		if(result ==2) {
			System.out.println("직원 회원가입 성공");
			return "redirect:recruit.do";			
		} else {
			System.out.println("직원 회원가입 실패");
			return null;
		}
	}
	
	@RequestMapping(value={"changeRecruit.do"},method=RequestMethod.POST)
	@ResponseBody
	public String changeRecruit(String sid) {
		System.out.println("\nStoreController의 changeRecruit.do(AJAX)");
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		List<Employee> employeeList = memberDAO.getEmployee(sid);
		
		// null값을 가진 컬럼이 json에 들어가지 않던 것을 해결
		Gson gson = new GsonBuilder().serializeNulls().create();
		String result = gson.toJson(employeeList);
		System.out.println(result);
		
		return result;
	}
	
	
	@RequestMapping(value={"searchRecruit.do"},method=RequestMethod.POST)
	@ResponseBody
	public String searchRecruit(String store, String joinDate, String resignDate, String category, String query) {
		System.out.println("\nStoreController의 searchRecruit.do(AJAX)");
		
		System.out.println("sid : " + store);
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("joinDate : " + joinDate);
		System.out.println("resignDate : " + resignDate);
		
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		List<Employee> employeeList = memberDAO.searchEmployee(store, category, query, joinDate, resignDate);

		Gson gson = new GsonBuilder().serializeNulls().create();
		String result = gson.toJson(employeeList);
		System.out.println(result);
		
		return result;
	}
	@RequestMapping(value={"editTimeSchedule.do"},method=RequestMethod.GET)
	public String editTimeSchedule(HttpServletRequest request,Model model,String selectMonth,String selectYear,String selectDay,String emName,String sid) {
		System.out.println("\nStoreController의 editTimeSchedule.do(GET)");
		
		String mid=(String) request.getSession().getAttribute("mid");
		String checkPosition=(String) request.getSession().getAttribute("checkPosition");
		
		RecruitDAO recruitDao=sqlSession.getMapper(RecruitDAO.class);
		MemberDAO memberDAO=sqlSession.getMapper(MemberDAO.class);
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);
		StoreDAO storeDAO=sqlSession.getMapper(StoreDAO.class);
		
		
		Recruit employee=new Recruit();
		Store storeInfo=new Store();
		List<Store> storeList=new ArrayList<Store>();
		if(checkPosition.equals("2")){
//		rid로 직원 정보 가져오기
			employee=recruitDao.getRecruit(mid);
			storeInfo=storeDAO.getStore(employee.getSid());
		}else if(checkPosition.equals("1")){
			storeList=storeDAO.getAllStore(mid);
			if(sid==null || sid.equals("")){
				storeInfo=storeList.get(0);
			}else{
				storeInfo=storeDAO.getStore(sid);
			}
			
		}
//		가져온 직원 정보에서 sid로 전체 직원 추출
		List<Recruit> allEmployee=recruitDao.getAllRecruit(storeInfo.getSid());
//		전체 직원 rid String 으로 변환
		String allEmployeeRid="";
		for (int i = 0; i < allEmployee.size(); i++) {
			if(i==allEmployee.size()-1){
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'";
			}else{
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'"+",";
			}
		}
		List<Member> memberList=new ArrayList<Member>();
//		스트링으로 변환한 rid로 전체 멤버 리스트 추출
		if(allEmployeeRid!=null && !allEmployeeRid.equals("")){
		memberList=memberDAO.getAllMember(allEmployeeRid);	
		}
//		날짜 변환
		if(selectMonth==null || selectMonth.equals("")){
			selectMonth=new SimpleDateFormat("MM").format(new Date());
		}
		if(selectYear==null ||selectYear.equals("")){
			selectYear=new SimpleDateFormat("yyyy").format(new Date());
		}
		if(selectDay==null ||selectDay.equals("")){
			selectDay=new SimpleDateFormat("dd").format(new Date());
		}
		int year=Integer.parseInt(selectYear);
		int month=Integer.parseInt(selectMonth);
		int day=Integer.parseInt(selectDay);
		String preMonth="";
		String preDay="";
		if(month<=9){
			preMonth="0"+selectMonth;
		}
		if(day<=9){
			preDay="0"+selectDay;
		}
		String prework=year+"-"+preMonth+"-"+preDay;
//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		
		List<Schedule> allSchedule=scheduleDAO.getDaySchedule(storeInfo.getSid(), prework);
		
		
//  	멤버 mid-날짜 스트링으로 만들어서 가져가기	
		String allScheduleString="";
		String memberRidArray="";
		for (int i = 0; i < allSchedule.size(); i++) {
			if(i==allSchedule.size()-1){
				allScheduleString+=allSchedule.get(i).getRid()+"-"+allSchedule.get(i).getPreOnWork().substring(11, 16);
				memberRidArray+=allSchedule.get(i).getRid();
			}else{
				allScheduleString+=allSchedule.get(i).getRid()+"-"+allSchedule.get(i).getPreOnWork().substring(11, 16)+",";
				memberRidArray+=allSchedule.get(i).getRid()+",";
			}
		}
		model.addAttribute("memberRidArray", memberRidArray);
		model.addAttribute("allScheduleString", allScheduleString);
		model.addAttribute("storeList", storeList);
		model.addAttribute("storeInfo", storeInfo);
		model.addAttribute("storeRegYear", storeInfo.getRegDate().split("-")[0]);
		model.addAttribute("memberList", memberList);
		model.addAttribute("day", day);
		model.addAttribute("month", month);
		model.addAttribute("year", year);
		model.addAttribute("emName", emName);
		return "store.editTimeSchedule";
	}
}
