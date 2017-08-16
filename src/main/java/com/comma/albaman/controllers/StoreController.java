package com.comma.albaman.controllers;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.multipart.MultipartFile;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.dao.NoticeDAO;
import com.comma.albaman.dao.RecruitDAO;
import com.comma.albaman.dao.ScheduleDAO;
import com.comma.albaman.dao.StoreDAO;
import com.comma.albaman.util.CalcuTime;
import com.comma.albaman.vo.Attendance;
import com.comma.albaman.vo.Employee;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Notice;
import com.comma.albaman.vo.Recruit;
import com.comma.albaman.vo.SalaryManage;
import com.comma.albaman.vo.Schedule;
import com.comma.albaman.vo.Store;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.ParameterParser;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@Controller
@RequestMapping("/store/*")
public class StoreController {

	@Autowired
	private SqlSession sqlSession;

	@Autowired
	PlatformTransactionManager ptm;

	@RequestMapping(value={"calendar.do"},method=RequestMethod.GET)
	public String calendar(HttpServletRequest request,Model model,String sid) {
		System.out.println("\nStoreController의 calendar.do(GET)");

		String mid=(String) request.getSession().getAttribute("mid");
		String checkPosition=(String) request.getSession().getAttribute("checkPosition");

		RecruitDAO recruitDao=sqlSession.getMapper(RecruitDAO.class);
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

		model.addAttribute("storeList", storeList);
		model.addAttribute("storeInfo", storeInfo);

		return "store.calendar";
	}
	@RequestMapping(value={"fullSchedule.do"},method=RequestMethod.GET)
	@ResponseBody
	public String fullScheduel(HttpServletRequest request,String start,String end,String sid){
		System.out.println("\nStoreController의 fullSchedule.do(GET)");
		System.out.println("sid==="+sid);
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
		System.out.println("storeInfo.getSid()====="+storeInfo.getSid());
		//		전체 직원 rid String 으로 변환
		//SQL BETEEN 사용하기 위한 STRING 변환
		String allEmployeeRid="";
		for (int i = 0; i < allEmployee.size(); i++) {
			if(i==allEmployee.size()-1){
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'";
			}else{
				allEmployeeRid+="'"+allEmployee.get(i).getRid()+"'"+",";
			}
		}
		List<Member> memberList=new ArrayList<Member>();
		//		스트링으로 변환한 rid로 멤버 리스트 추출
		if(allEmployeeRid!=null && !allEmployeeRid.equals("")){
			memberList=memberDAO.getAllMember(allEmployeeRid);	
		}

		//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		
		List<Schedule> allSchedule=scheduleDAO.getAllSchedule(storeInfo.getSid());

		//  	멤버 mid-날짜 스트링으로 만들어서 가져가기	
		String data="[";

		for (int i = 0; i < allSchedule.size(); i++) {
			if(i==allSchedule.size()-1){
				data+="{\"title\":\""+allSchedule.get(i).getPreOnWork().split(" ")[1].substring(0, 5)+"~"+allSchedule.get(i).getPreOffWork().split(" ")[1].substring(0, 5)+" ";
				for (int j = 0; j < memberList.size(); j++) {
					if(memberList.get(j).getMid().equals(allSchedule.get(i).getRid())){
						data+=memberList.get(j).getName()+"\",";
					}
				}
				data+="\"start\":\""+allSchedule.get(i).getPreOnWork().split(" ")[0]+"\"}";
			}else{
				data+="{\"title\":\""+allSchedule.get(i).getPreOnWork().split(" ")[1].substring(0, 5)+"~"+allSchedule.get(i).getPreOffWork().split(" ")[1].substring(0, 5)+"  ";
				for (int j = 0; j < memberList.size(); j++) {
					if(memberList.get(j).getMid().equals(allSchedule.get(i).getRid())){
						data+=memberList.get(j).getName()+"\",";
					}
				}
				data+="\"start\":\""+allSchedule.get(i).getPreOnWork().split(" ")[0]+"\"},";
			}
		}

		data+="]";


		return data;
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
		System.out.println("storeInfo.getSid()====="+storeInfo.getSid());
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
			preMonth="0"+month;
		}else{
			preMonth=selectMonth;
		}
		String prework=year+"-"+preMonth;

		//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		
		List<Schedule> allSchedule=scheduleDAO.getSchedule(storeInfo.getSid(), prework);


		//  	멤버 mid-날짜 스트링으로 만들어서 가져가기	
		String allScheduleString="";
		String allEndScheduleString="";
		for (int i = 0; i < allSchedule.size(); i++) {
			if(i==allSchedule.size()-1){
				allScheduleString+=allSchedule.get(i).getRid()+"_"+allSchedule.get(i).getPreOnWork().substring(0, 16);
				allEndScheduleString+=allSchedule.get(i).getRid()+"_"+allSchedule.get(i).getPreOffWork().substring(0, 16);
			}else{
				allScheduleString+=allSchedule.get(i).getRid()+"_"+allSchedule.get(i).getPreOnWork().substring(0, 16)+",";
				allEndScheduleString+=allSchedule.get(i).getRid()+"_"+allSchedule.get(i).getPreOffWork().substring(0, 16)+",";
			}
		}

		//  	멤버 이름, rid 가져오기
		String memberName="";
		for (int i = 0; i < memberList.size(); i++) {
			if(i==memberList.size()-1){
				memberName+=memberList.get(i).getMid()+"_"+memberList.get(i).getName();
			}else{
				memberName+=memberList.get(i).getMid()+"_"+memberList.get(i).getName()+",";
			}
		}

		model.addAttribute("memberName", memberName);
		model.addAttribute("allEmployeeRids", allEmployeeRids);
		model.addAttribute("allScheduleString", allScheduleString);
		model.addAttribute("allEndScheduleString", allEndScheduleString);
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
	public String saveSchedule(String stringSchedule,String stringEndSchedule){
		System.out.println("\nStoreController의 saveSchedule.do(GET)");	
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);

		String[] schedules=stringSchedule.split(",");
		String[] endSchedules=stringEndSchedule.split(",");

		//기존 스케줄 지우기
		for (int i = 0; i < schedules.length; i++) {
			String rid=schedules[i].split("_")[0];
			System.out.println("rid[---"+rid);
			String deleteDate=schedules[i].split("_")[1].split(" ")[0];
			System.out.println("deleteDate==="+deleteDate);
			int a=scheduleDAO.deleteSchedule(rid, deleteDate);
			System.out.println("a[---"+a);
		}
		// 스케줄 추가
		if(stringSchedule!=null && !stringSchedule.equals("")){
			System.out.println("stringSchedule---"+stringSchedule);
			for (int i = 0; i < schedules.length; i++) {
				String rid=schedules[i].split("_")[0];
				String preOnWork=schedules[i].split("_")[1];
				String preOffWork=endSchedules[i].split("_")[1];
				System.out.println("preOnWork---"+preOnWork);
				System.out.println("preOffWork---"+preOffWork);
				System.out.println("rid---"+rid);
				int a=scheduleDAO.insertSchedule(preOnWork,preOffWork,rid);
				System.out.println("A-------"+a);
			}	
		}else{
			stringSchedule="0";
		}
		return stringSchedule;
	}

	// 직원 정보 조회 페이지
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

	// 직원 정보 등록 페이지
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

	// 사원 아이디 발급
	@RequestMapping(value={"createId.do"},method=RequestMethod.POST)
	@ResponseBody
	public String createId(String sid) {
		System.out.println("\nStoreController의 createId.do(AJAX)");

		System.out.println("선택된 sid : " + sid);

		RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);
		int last = 0;
		if(recruitDAO.getRecruitCount(sid)!=0) {
			last = recruitDAO.getLastRecruit(sid)+1;
		}

		String mid = sid + "-" + Integer.toString(last);

		return mid;
	}

	// 직원 정보 등록
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

	// 다른 매장 직원 정보 검색
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

	// 직원 정보 검색
	@RequestMapping(value={"searchRecruit.do"},method=RequestMethod.POST)
	@ResponseBody
	public String searchRecruit(String store, String startDate, String endDate, String category, String query) {
		System.out.println("\nStoreController의 searchRecruit.do(AJAX)");

		System.out.println("sid : " + store);
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("startDate : " + startDate);
		System.out.println("endDate : " + endDate);

		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		List<Employee> employeeList = memberDAO.searchEmployee(store, category, query, startDate, endDate);

		Gson gson = new GsonBuilder().serializeNulls().create();
		String result = gson.toJson(employeeList);
		System.out.println(result);

		return result;
	}

	// 퇴사하기
	@RequestMapping(value={"resignRecruit.do"},method=RequestMethod.POST)
	@ResponseBody
	public String resignRecruit(String mid) {
		System.out.println("\nStoreController의 resignRecruit.do(AJAX)");

		System.out.println("mid : " + mid);

		RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);
		int result = recruitDAO.resignRecruit(mid);

		String resignDate = null;

		if(result==0) {
			System.out.println("퇴사하기 실패");
		} else {
			System.out.println("퇴사하기 성공");
			Recruit recruit = recruitDAO.getRecruit(mid);
			resignDate = recruit.getResignDate();
		}

		return resignDate;
	}

	// 직원 정보 수정
	@RequestMapping(value={"modifyRecruit.do"},method=RequestMethod.POST)
	@ResponseBody
	public String modifyRecruit(String mid, String pwd, String name, String position, String phone, String birth, String address, int wage, String joinDate) {
		System.out.println("\nStoreController의 modifyRecruit.do(AJAX)");

		System.out.println("mid : " + mid);
		System.out.println("pwd : " + pwd);
		System.out.println("name : " + name);
		System.out.println("position : " + position);
		System.out.println("phone : " + phone);
		System.out.println("birth : " + birth);
		System.out.println("address : " + address);
		System.out.println("wage : " + wage);
		System.out.println("joinDate : " + joinDate);

		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);

		int result = 0;
		TransactionDefinition td = new DefaultTransactionDefinition();
		TransactionStatus ts = ptm.getTransaction(td);
		try {
			result = memberDAO.modifyMember(mid, pwd, name, position, phone);
			result += recruitDAO.modifyRecruit(mid, birth, address, wage, joinDate);
			ptm.commit(ts);
			System.out.println("트랜잭션 완료");
		} catch (Exception e) {
			ptm.rollback(ts);
			System.out.println("트랜잭션 실패");
		}

		// 0 : 실패, 2 : 성공
		return Integer.toString(result);
	}

	// 직원 근태관리 페이지
	@RequestMapping(value={"attendance.do"},method=RequestMethod.GET)
	public String attendance(HttpServletRequest request, Model model) {
		System.out.println("\nStoreController의 attendance.do(GET)");

		String mid = (String) request.getSession().getAttribute("mid");

		// 소유한 가게 가져오기
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		List<Store> storeList = storeDAO.getAllStore(mid);
		model.addAttribute("storeList", storeList);

		// 직원 전체 정보 가져오기
		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		System.out.println("storeList.get(0).getSid() : " + storeList.get(0).getSid());
		List<Attendance> attendanceList = scheduleDAO.getAttendance(storeList.get(0).getSid());
		model.addAttribute("attendanceList",attendanceList);

		return "store.attendance";
	}

	// 다른 매장 근태 관리 검색
	@RequestMapping(value={"changeAttendance.do"},method=RequestMethod.POST)
	@ResponseBody
	public String changeAttendance(String sid) {
		System.out.println("\nStoreController의 changeAttendance.do(AJAX)");

		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		List<Attendance> attendanceList = scheduleDAO.getAttendance(sid);

		// null값을 가진 컬럼이 json에 들어가지 않던 것을 해결
		Gson gson = new GsonBuilder().serializeNulls().create();
		String result = gson.toJson(attendanceList);
		System.out.println(result);

		return result;
	}
	
	// 조건에 맞는 근태 관리 검색
	@RequestMapping(value={"searchAttendance.do"},method=RequestMethod.POST)
	@ResponseBody
	public String searchAttendance(String store, String startDate, String endDate, String category, String query) {
		System.out.println("\nStoreController의 searchAttendance.do(AJAX)");
		
		System.out.println("sid : " + store);
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("startDate : " + startDate);
		System.out.println("endDate : " + endDate);
		
		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		List<Attendance> attendanceList = scheduleDAO.searchAttendance(store, startDate, endDate, category, query);

		Gson gson = new GsonBuilder().serializeNulls().create();
		String result = gson.toJson(attendanceList);
		System.out.println(result);

		return result;
	}
	
	// 근태 관리 수정
	@RequestMapping(value={"modifyAttendance.do"},method=RequestMethod.POST)
	@ResponseBody
	public String modifyAttendance(String sseq, String date, String mid, String name, String position, String preOnWork, String preOffWork, String onWork, String offWork) {
		System.out.println("\nStoreController의 modifyAttendance.do(AJAX)");
		
		System.out.println("sseq : " + sseq);
		System.out.println("date : " + date);
		System.out.println("mid : " + mid);
		System.out.println("name : " + name);
		System.out.println("position : " + position);
		System.out.println("preOnWork : " + preOnWork);
		System.out.println("preOffWork : " + preOffWork);
		System.out.println("onWork : " + onWork);
		System.out.println("offWork : " + offWork);
		
		preOnWork = date + " " + preOnWork;
		preOffWork = date + " " + preOffWork;
		onWork = date + " " + onWork;
		offWork = date + " " + offWork;
		
		ScheduleDAO scheduleDAO = sqlSession.getMapper(ScheduleDAO.class);
		int result = scheduleDAO.modifyAttendance(sseq, preOnWork, preOffWork, onWork, offWork);
		
		return Integer.toString(result);
	}
	
	// 공지사항 페이지
	@RequestMapping(value={"notice.do"}, method=RequestMethod.GET)
	public String notice(String sid, String category, String query, String pg, HttpServletRequest request, Model model) {
		System.out.println("\nStoreController의 notice.do(GET)");

		String mid = (String) request.getSession().getAttribute("mid");
		String checkPosition = (String) request.getSession().getAttribute("checkPosition");

		// 점주인 경우
		if(checkPosition.equals("1")) {
			System.out.println("점주로 접근");
			
			// 소유한 가게 가져오기
			StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
			List<Store> storeList = storeDAO.getAllStore(mid);
			model.addAttribute("storeList", storeList);
			
			if(sid==null || sid.equals("")) {
				sid = storeList.get(0).getSid();
			}
		}
		
		// 직원일 경우
		else if(checkPosition.equals("2")) {
			System.out.println("직원으로 접근");
			
			RecruitDAO recruitDAO = sqlSession.getMapper(RecruitDAO.class);
			Recruit recruit = recruitDAO.getRecruit(mid);
			sid = recruit.getSid();
		}
		
		if(category==null || category.equals("")) {
			category = "title";
		}
		if(query==null) {
			query = "";
		}
		int ipg = 0;
		if(pg!=null && !pg.equals("")) {
			ipg = Integer.parseInt(pg);
		} else {
			ipg = 1;
		}
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		int total = noticeDAO.getMax(category, query, sid);
		int lastPage = total/10 + (total%10==0? 0 : 1);
		int startPage = ipg - (ipg-1)%5;
		int start = (ipg-1)*10;
		int end = ipg*10;
		
		System.out.println("sid : " + sid);
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("ipg : " + ipg);
		System.out.println("start : " + start);
		System.out.println("end : " + end);
		
		List<Notice> noticeList = noticeDAO.getNotices(sid, category, query, start, end);
		System.out.println("noticeList 크기 : " + noticeList.size());
		
		model.addAttribute("pg", ipg);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		model.addAttribute("sid", sid);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("noticeList", noticeList);
		
		return "store.notice";
	}
	
	// 공지사항 세부 페이지
	@RequestMapping(value={"noticeDetail.do"}, method=RequestMethod.GET)
	public String noticeDetail(String nseq, String sid, String category, String query, String pg, Model model, String delete){
		System.out.println("\nStoreController의 noticeDetail.do(GET)");
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		Notice notice = noticeDAO.getNotice(nseq);
		
		// 파일명 encoding(한글깨짐 방지)
		if(notice.getFile()!=null) {
			String fileName = null;
			try {
				fileName =  URLEncoder.encode(notice.getFile(), "UTF-8");
			} catch (UnsupportedEncodingException e) {
				System.out.println("파일명 인코딩 실패");
				e.printStackTrace();
			}
			model.addAttribute("fileName", fileName);
		}
		model.addAttribute("notice", notice);
		model.addAttribute("sid", sid);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		model.addAttribute("pg", pg);
		model.addAttribute("delete", delete);
		
		System.out.println("nseq : " + nseq);
		System.out.println("delete : " + delete);
		
		return "store.noticeDetail";
	}
	
	// 첨부파일 다운로드
	@RequestMapping(value={"download.do"}, method={RequestMethod.GET})
	public String download(String path, String fileName, HttpServletRequest request, HttpServletResponse response) {
		System.out.println("\nStoreController의 download.do(GET)");
		
		// 받아온 fileName을 decoding(한글깨짐 방지)
		String fileNameDecoded = null;
		try {
			fileNameDecoded = URLDecoder.decode(fileName, "UTF-8");
			System.out.println("decode된 fileName : " + fileNameDecoded);
		} catch (UnsupportedEncodingException e) {
			System.out.println("파일명 디코딩 실패");
			e.printStackTrace();
		}
		
		String fullPath = path + "/" + fileNameDecoded;
		System.out.println("전체 경로 : " + fullPath);
		String realPath = request.getServletContext().getRealPath(fullPath);
		System.out.println("실제 경로 : " + realPath);
		
		
		// 파일 다운로드
		try {
			String newFileName = new String(fileNameDecoded.getBytes(), "ISO-8859-1");
			System.out.println("NewFileName : " + newFileName);
			response.setHeader("content-Disposition", "attachment;filename="+newFileName);
			FileInputStream fis = new FileInputStream(realPath);
			ServletOutputStream sout = response.getOutputStream();
			byte[] buf = new byte[1024];
			int readData = 0;
			while((readData=fis.read(buf))!= -1) {
				sout.write(buf);
			}
			fis.close();
			sout.close();
		} catch (IOException e) {
			System.out.println("파일 다운로드 실패");
			e.printStackTrace();
		}
		
		return null;
	}
	
	// 공지사항 등록 페이지
	@RequestMapping(value={"addNotice.do"}, method=RequestMethod.GET)
	public String addNotice(String sid, Model model, String add){
		System.out.println("\nStoreController의 addNotice.do(GET)");
		
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		Store store = storeDAO.getStore(sid);
		
		model.addAttribute("store", store);
		model.addAttribute("add",add);
		
		return "store.addNotice";
	}
	
	// 공지사항 이미지 업로드(위지윅)
	@RequestMapping(value={"noticeImageUpload.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String noticeImageUpload(HttpServletRequest request){
		System.out.println("\nStoreController의 noticeImageUpload.do(AJAX)");
		
		// store/upload 위치로 지정하면 summernote가 인식을 못해서 일단 WEB-INF 바깥으로 설정함
		// (WEB-INF 내부에는 접근을 하지 못하는 듯)
		String path = "/images";
		String realPath = request.getServletContext().getRealPath(path);
		System.out.println("실제 경로 : " + realPath);
		
		MultipartRequest multiReq = null;
		try {
			multiReq = new MultipartRequest(request, realPath, 1024*1024*10, "UTF-8", new DefaultFileRenamePolicy());
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String image = multiReq.getFilesystemName("uploadFile");
		System.out.println("image : " + image);
		
		// /images + 파일명
		String fullPath = path + "/" + image;
		
		return fullPath;
	}
	
	// 공지사항 등록
	@RequestMapping(value={"addNotice.do"}, method=RequestMethod.POST)
	public String addNoticeProc(HttpServletRequest request){
		System.out.println("\nStoreController의 addNotice.do(POST)");
		
		String path = "/WEB-INF/views/store/upload";
		String realPath = request.getServletContext().getRealPath(path);
		System.out.println("실제 경로 : " + realPath);
		
		MultipartRequest multiReq = null;
		try {
			multiReq = new MultipartRequest(request, realPath, 1024*1024*10, "UTF-8", new DefaultFileRenamePolicy());
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String title = multiReq.getParameter("title");
		String content = multiReq.getParameter("content");
		String file = multiReq.getFilesystemName("file");
		String sid = multiReq.getParameter("sid");
		
		System.out.println("title : " + title);
		System.out.println("content : " + content);
		System.out.println("file : " + file);
		System.out.println("sid : " + sid);
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		int result = noticeDAO.addNotice(title, content, file, sid);
		if(result==0) {
			System.out.println("공지사항 등록 실패");
			return "redirect:addNotice.do?sid=" + sid + "&add=fail";
		} else {
			System.out.println("공지사항 등록 성공");
			return "redirect:notice.do?sid=" + sid;
		}
	}
	
	// 공지사항 수정 페이지
	@RequestMapping(value={"modifyNotice.do"}, method=RequestMethod.GET)
	public String modifyNotice(String nseq, String sid, String category, String query, String pg, Model model, String modify){
		System.out.println("\nStoreController의 modifyNotice.do(GET)");
		
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		Store store = storeDAO.getStore(sid);
		
		model.addAttribute("store", store);
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		Notice notice = noticeDAO.getNotice(nseq);
		
		model.addAttribute("notice", notice);
		model.addAttribute("sid", sid);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		model.addAttribute("pg", pg);
		model.addAttribute("modify",modify);
		
		return "store.modifyNotice";
	}
	
	// 공지사항 수정
	@RequestMapping(value={"modifyNotice.do"}, method=RequestMethod.POST)
	public String modifyNoticeProc(HttpServletRequest request){
		System.out.println("\nStoreController의 modifyNotice.do(POST)");
		
		String path = "/WEB-INF/views/store/upload";
		String realPath = request.getServletContext().getRealPath(path);
		System.out.println("실제 경로 : " + realPath);
		
		MultipartRequest multiReq = null;
		try {
			multiReq = new MultipartRequest(request, realPath, 1024*1024*10, "UTF-8", new DefaultFileRenamePolicy());
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		String title = multiReq.getParameter("title");
		String content = multiReq.getParameter("content");
		String file = multiReq.getFilesystemName("file");
		String sid = multiReq.getParameter("sid");
		String category = multiReq.getParameter("category");
		String query = multiReq.getParameter("query");
		String pg = multiReq.getParameter("pg");
		
		System.out.println("title : " + title);
		System.out.println("content : " + content);
		System.out.println("file : " + file);
		System.out.println("sid : " + sid);
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("pg : " + pg);
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		int result = noticeDAO.addNotice(title, content, file, sid);
		if(result==0) {
			System.out.println("공지사항 수정 실패");
			return "redirect:modifyNotice.do?sid=" + sid + "&category=" + category + "&query=" + query + "&pg=" + pg + "&modify=fail";
		} else {
			System.out.println("공지사항 수정 성공");
			return "redirect:notice.do?sid=" + sid + "&category=" + category + "&query=" + query + "&pg=" + pg;
		}
	}
	
	// 공지사항 삭제
	@RequestMapping(value={"deleteNotice.do"}, method=RequestMethod.GET)
	public String deleteNotice(String nseq, String sid, String category, String query, String pg, Model model){
		System.out.println("\nStoreController의 deleteNotice.do(GET)");
		
		System.out.println("nseq : " + nseq);
		
		NoticeDAO noticeDAO = sqlSession.getMapper(NoticeDAO.class);
		int result = noticeDAO.deleteNotice(nseq);
		if(result == 0) {
			System.out.println("삭제 실패");
			return "redirect:noticeDetail.do?nseq=" + nseq + "&sid=" + sid + "&category=" + category + "&query=" + query + "&pg=" + pg + "&delete=fail";
		} else {
			System.out.println("삭제 성공");
			return "redirect:notice.do?sid=" + sid + "&category=" + category + "&query=" + query + "&pg=" + pg;			
		}
	}

	@RequestMapping(value={"checkSalary.do"}, method=RequestMethod.GET)
	public String checkSalary(HttpServletRequest request,Model model,String selectMonth,String selectYear,String mid){
		System.out.println("\nStoreController의 checkSalary.do(GET)");

		if(mid==null || mid.equals("")){
			mid = (String) request.getSession().getAttribute("mid");
		}
		
		// 직원 전체 정보 가져오기
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		Member memberData=memberDAO.getMember(mid);
		RecruitDAO recruitDAO=sqlSession.getMapper(RecruitDAO.class);
		Recruit recruitData=recruitDAO.getRecruit(mid);
		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);
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
		}else{
			preMonth=selectMonth;
		}
		String prework=year+"-"+preMonth;

		String getWeek=prework+"-01";
		// 		주휴수당 계산하기		

		Calendar cal = Calendar.getInstance(Locale.KOREA);
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = df.parse(getWeek);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		cal.setTime(date);
		int lastDay= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		String monDay=df.format(cal.getTime());
		cal.add(cal.DATE, 6);
		String sunDay = df.format(cal.getTime()).toString();

		int sunDayInt=Integer.parseInt(sunDay.split("-")[2])+1;
		int monDayInt=Integer.parseInt(monDay.split("-")[2]);

		int totalMoney=0;
		String totalWeekTime="";
		for (int i = 0; i < 5; i++) {
			double totalweekMoney=0;
			if(sunDayInt-1<=lastDay){
				if(i>=1){
					monDay=prework+"-"+monDayInt;
				}
				sunDay=prework+"-"+sunDayInt;
				int count=scheduleDAO.checkAbsent(monDay,sunDay,mid);
				if(count==0){
					int weekWorkTime=scheduleDAO.getWeekWorkTime(monDay,sunDay,mid);
					if(weekWorkTime>=900 && weekWorkTime<2400){
						totalweekMoney=(weekWorkTime/2400.0)*8*recruitData.getWage();
					}else if(weekWorkTime>=2400){
						totalweekMoney=8*recruitData.getWage();
					}
					totalMoney+=totalweekMoney;
				}

				int workTime=scheduleDAO.getWeekWorkTime(monDay,sunDay,mid);
				totalWeekTime+=prework+"-"+(sunDayInt-1)+"_"+workTime+",";
			}

			monDayInt=sunDayInt;
			sunDayInt+=7;
		}

		//일별 근무시간 구하기
		int[] workMinuteTime=new int[]{};
		workMinuteTime=scheduleDAO.getWorkDayTime(prework,mid);
		String stringworkTime="";
		if(workMinuteTime.length!=0){
			for (int i = 0; i < workMinuteTime.length; i++) {
				if(i==workMinuteTime.length-1){
					stringworkTime+=workMinuteTime[i];
				}else{
					stringworkTime+=workMinuteTime[i]+",";
				}
			}
		}

		//      sid와 prework 날짜로 해당 달의 전체 스케줄 받기		

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
		model.addAttribute("stringworkTime",stringworkTime);
		model.addAttribute("joinYear", recruitData.getJoinDate().split("-")[0]);
		model.addAttribute("totalMoney",totalMoney);
		model.addAttribute("totalWeekTime",totalWeekTime);
		model.addAttribute("year",selectYear);
		model.addAttribute("month",selectMonth);
		model.addAttribute("memberData",memberData);
		model.addAttribute("recruitData",recruitData);
		model.addAttribute("allSchedule",allSchedule);
		model.addAttribute("allScheduleString",allScheduleString);
		return "store.checkSalary";
	}

	@RequestMapping(value={"salaryManage.do"}, method=RequestMethod.GET)
	public String salaryManage(HttpServletRequest request,Model model,String selectMonth,String selectYear,String sid){
		System.out.println("\nStoreController의 salaryManage.do(GET)");

		String mid = (String) request.getSession().getAttribute("mid");

		// 소유한 가게 가져오기
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		List<Store> storeList = storeDAO.getAllStore(mid);
		Store storeInfo=new Store();
		System.out.println("Sid---"+sid);
		if(sid==null || sid.equals("")){
			storeInfo=storeList.get(0);
		}else{
			storeInfo=storeDAO.getStore(sid);
		}
		model.addAttribute("storeList", storeList);
		model.addAttribute("storeInfo", storeInfo);

		// 직원 전체 정보 가져오기
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		List<Employee> employeeList=new ArrayList<Employee>();
		if(sid==null||sid.equals("")){
			employeeList = memberDAO.getEmployee(storeList.get(0).getSid());
		}else{
			employeeList = memberDAO.getEmployee(sid);
		}
		model.addAttribute("employeeList",employeeList);

		ScheduleDAO scheduleDAO=sqlSession.getMapper(ScheduleDAO.class);
		RecruitDAO recruitDAO=sqlSession.getMapper(RecruitDAO.class);
		//		전체 직원 스케줄 가져오기	
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
		}else{
			preMonth=selectMonth;
		}
		String prework=year+"-"+preMonth;

		String getWeek=prework+"-01";
		// 		주휴수당 계산하기		
		Calendar cal = Calendar.getInstance(Locale.KOREA);
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = df.parse(getWeek);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		cal.setTime(date);
		int lastDay= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		String monDay=df.format(cal.getTime());
		cal.add(cal.DATE, 6);
		String sunDay = df.format(cal.getTime()).toString();
		int mmonday=Integer.parseInt(monDay.split("-")[2]);  
		int ssunday=Integer.parseInt(sunDay.split("-")[2])+1;


		List<SalaryManage> salaryManageList=new ArrayList<SalaryManage>();

		for (int j = 0; j < employeeList.size(); j++) {
			int sunDayInt=ssunday;
			int monDayInt=mmonday;
			SalaryManage salaryManage=new SalaryManage();
			Recruit recruitData=recruitDAO.getRecruit(employeeList.get(j).getMid());

			salaryManage.setMid(employeeList.get(j).getMid());
			salaryManage.setName(employeeList.get(j).getName());
			salaryManage.setWage(recruitData.getWage());

			int weeklyPay=0;

			List<String> totalWeekTime=new ArrayList<String>();
			for (int i = 0; i < 5; i++) {
				double totalweekMoney=0;
				if(sunDayInt-1<=lastDay){
					if(i>=1){
						monDay=prework+"-"+monDayInt;
					}
					sunDay=prework+"-"+sunDayInt;
					int count=scheduleDAO.checkAbsent(monDay,sunDay,salaryManage.getMid());
					if(count==0){
						int weekWorkTime=scheduleDAO.getWeekWorkTime(monDay,sunDay,salaryManage.getMid());
						if(weekWorkTime>=900 && weekWorkTime<2400){
							totalweekMoney=(weekWorkTime/2400.0)*8*recruitData.getWage();
						}else if(weekWorkTime>=2400){
							totalweekMoney=8*recruitData.getWage();
						}
						weeklyPay+=totalweekMoney;
					}

					int workTime=scheduleDAO.getWeekWorkTime(monDay,sunDay,salaryManage.getMid());
					totalWeekTime.add(prework+"-"+(sunDayInt-1)+"_"+workTime);
				}

				monDayInt=sunDayInt;
				sunDayInt+=7;
			}
			salaryManage.setWeeklyPay(weeklyPay);
			//월 총 근무시간 구하기
			int totalTime=scheduleDAO.getWorkTotalTime(prework,salaryManage.getMid());
			salaryManage.setTotalTime(totalTime);
			//일별 근무시간 구하기
			int[] workMinuteTime=scheduleDAO.getWorkDayTime(prework,salaryManage.getMid());
			List<Schedule> allSchedule=scheduleDAO.getWorkTime(salaryManage.getMid(), prework);

			int totalWorkTime=0;
			int totalPlusTime=0;
			int totalOverTime=0;
			int totalSalary=0;
			int totalExcessPay=0;
			int totalOverTimePay=0;
			
			int check=0;
			int sumtime=0;
			int hourCheck=0;
			if(workMinuteTime.length!=0){
				for (int i = 0; i < allSchedule.size(); i++) {
					String onWork=allSchedule.get(i).getOnWork();
					String offWork=allSchedule.get(i).getOffWork();
					int startDay=Integer.parseInt(onWork.split("-")[2].split(" ")[0]);
					int endDay=Integer.parseInt(offWork.split("-")[2].split(" ")[0]);
					//일 총근무 시간
					int totalWorkMinute=workMinuteTime[i];
					//주의 총 근무시간
					int totalWeekWorkTime=0;
					int plusTime=0;
					int overTime=0;
					double daySalary=0;
					
					//한 주의 총 근무시간 구하기
					for (int k = 0; k < totalWeekTime.size(); k++) {
						int weekSundayDate=Integer.parseInt(totalWeekTime.get(k).split("-")[2].split("_")[0]);
						if(k==0 &&(startDay<=weekSundayDate  || !onWork.split("-")[1].equals(preMonth))){
							totalWeekWorkTime=Integer.parseInt(totalWeekTime.get(k).split("_")[1]);
						}else if(k>=1 && (startDay<=weekSundayDate && startDay>Integer.parseInt(totalWeekTime.get(k-1).split("-")[2].split("_")[0]))){
							totalWeekWorkTime=Integer.parseInt(totalWeekTime.get(k).split("_")[1]);
						}
					}
					
					/* 한 주 총 근무시간이 40시간 이상/이하 비교*/
		 			if(totalWeekWorkTime>=2400){
		 				/*일 근무시간 더하기*/
		 				sumtime+=totalWorkMinute;
		 				if(totalWorkMinute>=480){
		 					hourCheck+=480;
		 				}else{
		 					hourCheck+=totalWorkMinute;	
		 				}
		 				 /*주 40시간 이상 근무시 추가 시간만큼 1.5배 해주기*/
		 				 if(hourCheck>=2400 && check!=1){
		 					check=1;
		 					if(totalWorkMinute>=480){
		 						hourCheck-=480;
		 						hourCheck+=totalWorkMinute;	
		 					}
		 					plusTime=hourCheck-2400;
		 				/*주 40시간 초과 근무시 1.5배 해주기*/
		 				 }else if(check==1){
		 					plusTime=totalWorkMinute;
		 					if(totalWeekWorkTime==sumtime){
		 						sumtime=0;
		 						check=0;
		 						hourCheck=0;
		 					 }
		 				/*주의 총 근무시간은 40시간 이상 , 추가 근무시간 합이 40시간 미만일 경우*/
		 				 }else{
		 						if(totalWorkMinute>=480){
		 							plusTime=totalWorkMinute-480;
		 						}else{
		 							plusTime=0;
		 						}
		 				 }
		 				 /* 주의 총 근무시간이 40시간 미만일경우 */
		 			}else{
		 				if(totalWorkMinute>=480 && (totalWorkMinute-480>=60)){
		 					plusTime=totalWorkMinute-480;
		 				}else{
		 					plusTime=0;
		 				}	
		 			}
		 			
		 			/*야근수당 구하기*/		
		 			CalcuTime calcu=new CalcuTime();
		 		 	if(startDay!=endDay){
		 				if(Integer.parseInt(onWork.split(" ")[1].split(":")[0])>=22 && Integer.parseInt(offWork.split(" ")[1].split(":")[0])<=6){
		 					overTime=calcu.calcuTime(offWork.split(" ")[1])+(1440-calcu.calcuTime(onWork.split(" ")[1]));
		 				}else if(Integer.parseInt(onWork.split(" ")[1].split(":")[0])<22 && Integer.parseInt(offWork.split(" ")[1].split(":")[0])<=6){
		 					overTime=calcu.calcuTime(offWork.split(" ")[1])+120;
		 				}else if(Integer.parseInt(onWork.split(" ")[1].split(":")[0])>=22 && Integer.parseInt(offWork.split(" ")[1].split(":")[0])>6){
		 					overTime=calcu.calcuTime(onWork.split(" ")[1])+360;
		 				}else{
		 					overTime=480;
		 				}

		 			}else{
		 				if(Integer.parseInt(onWork.split(" ")[1].split(":")[0])>=22 || Integer.parseInt(onWork.split(" ")[1].split(":")[0])<=6 && Integer.parseInt(offWork.split(" ")[1].split(":")[0])<=6){
		 					overTime=calcu.calcuTime(offWork.split(" ")[1])-calcu.calcuTime(onWork.split(" ")[1]);
		 				}else if(Integer.parseInt(offWork.split(" ")[1].split(":")[0])>=22){
		 					overTime=calcu.calcuTime(offWork.split(" ")[1])-1320;
		 				}else if(Integer.parseInt(onWork.split(" ")[1].split(":")[0])<=6 && Integer.parseInt(offWork.split(" ")[1].split(":")[0])>6){
		 					overTime=360-calcu.calcuTime(onWork.split(" ")[1]);
		 				}else{
		 					overTime=0;
		 				}
		 			}
		 			totalPlusTime+=plusTime;
		 			totalOverTime+=overTime;
		 			if(totalWorkMinute>=480){
		 				daySalary=8*salaryManage.getWage()+
		 						Math.round(plusTime*((salaryManage.getWage()*1.5)/60))+
		 						Math.round(overTime*((salaryManage.getWage()*1.5)/60));
		 			}else{
		 				daySalary=Math.round(totalWorkMinute*salaryManage.getWage()/60)+
		 						Math.round(plusTime*((salaryManage.getWage()*1.5)/60))+
		 						Math.round(overTime*((salaryManage.getWage()*1.5)/60));
		 			}

		 			totalExcessPay+=Math.round(plusTime*((salaryManage.getWage()*1.5)/60));
		 			totalOverTimePay+=Math.round(overTime*((salaryManage.getWage()*1.5)/60));	
					totalSalary+=daySalary;
				}
			}
			salaryManage.setExcessPay(totalExcessPay);
			salaryManage.setOverTimePay(totalOverTimePay);
			salaryManage.setTotalPay(totalSalary);
			salaryManageList.add(salaryManage);

		}
		SalaryManage sm=new SalaryManage();
		for (int i = 0; i < salaryManageList.size(); i++) {
			if(i==0){
				sm.setExcessPay(salaryManageList.get(i).getExcessPay());
				sm.setOverTimePay(salaryManageList.get(i).getOverTimePay());
				sm.setWeeklyPay(salaryManageList.get(i).getWeeklyPay());
				sm.setTotalTime(salaryManageList.get(i).getTotalTime());
				sm.setTotalPay(salaryManageList.get(i).getTotalPay());
			}else{
				sm.setExcessPay(sm.getExcessPay()+salaryManageList.get(i).getExcessPay());
				sm.setOverTimePay(sm.getOverTimePay()+salaryManageList.get(i).getOverTimePay());
				sm.setWeeklyPay(sm.getWeeklyPay()+salaryManageList.get(i).getWeeklyPay());
				sm.setTotalTime(sm.getTotalTime()+salaryManageList.get(i).getTotalTime());
				sm.setTotalPay(sm.getTotalPay()+salaryManageList.get(i).getTotalPay());
			}
			
			
		}
		String stringSalary="";
		for (int i = 0; i < salaryManageList.size(); i++) {
			if(i==salaryManageList.size()-1){
				stringSalary+=salaryManageList.get(i).getMid()+"_"+salaryManageList.get(i).getName()+"_"+salaryManageList.get(i).getWage()+"_"+
						salaryManageList.get(i).getTotalTime()+"_"+salaryManageList.get(i).getWeeklyPay()+"_"+
						salaryManageList.get(i).getExcessPay()+"_"+salaryManageList.get(i).getOverTimePay()+"_"+salaryManageList.get(i).getTotalPay();
			}else{
				stringSalary+=salaryManageList.get(i).getMid()+"_"+salaryManageList.get(i).getName()+"_"+salaryManageList.get(i).getWage()+"_"+
						salaryManageList.get(i).getTotalTime()+"_"+salaryManageList.get(i).getWeeklyPay()+"_"+
						salaryManageList.get(i).getExcessPay()+"_"+salaryManageList.get(i).getOverTimePay()+"_"+salaryManageList.get(i).getTotalPay()+",";
			}
		}

	model.addAttribute("stringSalary",stringSalary);
	model.addAttribute("sm",sm);
	model.addAttribute("year",selectYear);
	model.addAttribute("month",selectMonth);
	model.addAttribute("startYear",storeInfo.getRegDate().split("-")[0]);
	model.addAttribute("salaryManageList",salaryManageList);

	return "store.salaryManage";
	}
}
