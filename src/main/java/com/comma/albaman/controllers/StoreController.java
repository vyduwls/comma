package com.comma.albaman.controllers;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.dao.RecruitDAO;
import com.comma.albaman.dao.ScheduleDAO;
import com.comma.albaman.dao.StoreDAO;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Recruit;
import com.comma.albaman.vo.Schedule;
import com.comma.albaman.vo.Store;

@Controller
@RequestMapping("/store/*")
public class StoreController {

	@Autowired
	private SqlSession sqlSession;
	
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
		
		model.addAttribute("storeList", storeList);
		model.addAttribute("storeInfo", storeInfo);
		model.addAttribute("memberList", memberList);
		model.addAttribute("allSchedule", allSchedule);
		model.addAttribute("month", month);
		model.addAttribute("year", year);
		model.addAttribute("emName", emName);
		return "store.editSchedule";
	}
	
	
	@RequestMapping(value={"recruit.do"},method=RequestMethod.GET)
	public String recruit() {
		System.out.println("\nStoreController의 recruit.do(GET)");
		
		return "store.recruit";
	}
}
