package com.comma.albaman.controllers;

import java.io.IOException;
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

import com.comma.albaman.dao.CommentDAO;
import com.comma.albaman.dao.MemberDAO;
import com.comma.albaman.dao.QnaDAO;
import com.comma.albaman.dao.StoreDAO;
import com.comma.albaman.util.SendMail;
import com.comma.albaman.vo.Qna;
import com.comma.albaman.vo.Store;
import com.comma.albaman.vo.StoreForAdmin;
import com.comma.albaman.vo.StoreMember;

@Controller
@RequestMapping("/admin/*")
public class AdminController {

	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	PlatformTransactionManager ptm;
	
	// 회원 관리 페이지
	@RequestMapping(value={"manageMember.do"},method=RequestMethod.GET)
	public String manageMember(String category, String query,  Model model) {
		System.out.println("\nAdminController의 manageMember.do(GET)");
		
		if(category==null || category.equals("")) {
			category = "mid";
		}
		if(query==null) {
			query = "";
		}
		
		// 전체 회원 조회
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		List<StoreMember> storeMemberList = memberDAO.getStoreMember(category, query);
		
		model.addAttribute("storeMemberList", storeMemberList);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		
		return "admin.manageMember";
	}
	
	// 회원 정보 수정(AJAX)
	@RequestMapping(value={"modifyMember.do"},method=RequestMethod.POST)
	@ResponseBody
	public String modifyMember(String mid, String pwd, String name, String phone, String email) {
		System.out.println("\nAdminController의 modifyMember.do(AJAX)");
		
		// 회원 정보 수정
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		int result = memberDAO.modifyMemberByAdmin(mid, pwd, name, phone, email);
		
		return Integer.toString(result);
	}
	
	// 회원 탈퇴(AJAX)
	/*@RequestMapping(value={"resignMember.do"},method=RequestMethod.POST)
	@ResponseBody
	public String resignMember(String mid) {
		System.out.println("\nAdminController의 resignMember.do(AJAX)");
		
		// 회원 탈퇴
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		int result = memberDAO.resignMember(mid);
		
		return Integer.toString(result);
	}*/
	
	// 회원 탈퇴(AJAX)
	@RequestMapping(value={"resignSelectedMember.do"},method=RequestMethod.POST)
	@ResponseBody
	public String resignSelectedMember(String[] midArray) {
		System.out.println("\nAdminController의 resignSelectedMember.do(AJAX)");
		
		for(String mid : midArray) {
			System.out.println("선택된 mid : " + mid);
		}
		
		// 회원 탈퇴
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		int result = 0;
		
		TransactionDefinition td = new DefaultTransactionDefinition();
		TransactionStatus ts = ptm.getTransaction(td);
		try {
			for(int i=0; i<midArray.length; i++) {			
				result += memberDAO.resignMember(midArray[i]);
			}
			ptm.commit(ts);
			System.out.println("트랜잭션 성공");
		} catch (Exception e) {
			ptm.rollback(ts);
			System.out.println("트랜잭션 실패");
		}
		
		return Integer.toString(result);
	}
	
	// 이메일 발송(회원)
	@RequestMapping(value={"sendEmailToMember.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String sendEmailToMember(String title, String receiverEmail, String receiverMid, String content){
		System.out.println("\nCustomerController의 sendEmailToMember.do(AJAX)");
		
		System.out.println("title : " + title);
		System.out.println("receiverEmail : " + receiverEmail);
		System.out.println("receiverMid : " + receiverMid);
		System.out.println("content : " + content);
		String[] receiverEmailArray = receiverEmail.split(", ");
		String[] receiverMidArray = receiverMid.split(", ");
		
		int result = 0;
		
		for(int i=0; i<receiverEmailArray.length; i++) {
			SendMail sm = new SendMail(receiverEmailArray[i]);
			sm.login("senseproject", "jang7102@");
			result += Integer.parseInt(sm.sendMail("[ALBAMAN(" + receiverMidArray[i] + "님)] " + title, content, true));
		}
		return Integer.toString(result);
	}
	
	// 점포 관리 페이지
	@RequestMapping(value={"manageStore.do"},method=RequestMethod.GET)
	public String manageStore(String category, String query, Model model) {
		System.out.println("\nAdminController의 manageStore.do(GET)");
		
		if(category==null || category.equals("")) {
			category = "sid";
		}
		if(query==null) {
			query = "";
		}
		
		// 전체 점포 조회
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		List<StoreForAdmin> storeForAdminList = storeDAO.getAllStoreByAdmin(category, query);
		
		model.addAttribute("storeForAdminList", storeForAdminList);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		
		return "admin.manageStore";
	}
	
	// 점포 정보 수정(AJAX)
	@RequestMapping(value={"modifyStore.do"},method=RequestMethod.POST)
	@ResponseBody
	public String modifyStore(String sid, String name, String address, String storeNumber, String ip) {
		System.out.println("\nAdminController의 modifyStore.do(AJAX)");
		
		// 점포 정보 수정
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		
		Store store = storeDAO.getStore(sid);
		store.setName(name);
		store.setAddress(address);
		store.setStoreNumber(storeNumber);
		store.setIp(ip);
		
		int result = storeDAO.updateStore(store); 
		
		return Integer.toString(result);
	}
	
	// 이메일 발송(점주)
	@RequestMapping(value={"sendEmailToOwner.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String sendEmailToOwner(String title, String receiverMid, String receiverStoreName, String content){
		System.out.println("\nCustomerController의 sendEmailToOwner.do(AJAX)");
		
		System.out.println("title : " + title);
		System.out.println("receiverMid : " + receiverMid);
		System.out.println("receiverStoreName : " + receiverStoreName);
		System.out.println("content : " + content);
		
		String[] receiverArray = receiverMid.split(", ");
		String[] storeNameArray = receiverStoreName.split(", ");
		
		// mid로 email 받아 배열에 넣기
		MemberDAO memberDAO = sqlSession.getMapper(MemberDAO.class);
		String[] receiverEmailArray = new String[receiverArray.length];
		for(int i=0; i<receiverArray.length; i++) {
			receiverEmailArray[i] = memberDAO.getMember(receiverArray[i]).getEmail();
		}
		
		int result = 0;
		
		for(int i=0; i<receiverEmailArray.length; i++) {
			SendMail sm = new SendMail(receiverEmailArray[i]);
			sm.login("senseproject", "jang7102@");
			result += Integer.parseInt(sm.sendMail("[ALBAMAN(" + storeNameArray[i] + " 점주님)] " + title, content, true));
		}
		return Integer.toString(result);
	}
	
	// 점포 삭제(AJAX)
	@RequestMapping(value={"resignSelectedStore.do"},method=RequestMethod.POST)
	@ResponseBody
	public String resignSelectedStore(String[] sidArray) {
		System.out.println("\nAdminController의 resignSelectedStore.do(AJAX)");
		
		for(String sid : sidArray) {
			System.out.println("선택된 sid : " + sid);
		}
		
		// 점포 삭제
		StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
		int result = 0;
		
		TransactionDefinition td = new DefaultTransactionDefinition();
		TransactionStatus ts = ptm.getTransaction(td);
		try {
			for(int i=0; i<sidArray.length; i++) {			
				result += storeDAO.deleteStore(sidArray[i]);
			}
			ptm.commit(ts);
			System.out.println("트랜잭션 성공");
		} catch (Exception e) {
			ptm.rollback(ts);
			System.out.println("트랜잭션 실패");
		}
		
		return Integer.toString(result);
	}
	
	// 문의 게시판 페이지
	@RequestMapping(value={"manageQNA.do"},method=RequestMethod.GET)
	public String manageQNA(String category, String query, String pg, Model model) {
		System.out.println("\nAdminController의 manageQNA.do(GET)");
		
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
		
		QnaDAO qnaDAO = sqlSession.getMapper(QnaDAO.class);
	
		int total = qnaDAO.getAllMax(category, query);
		int lastPage = total/15 + (total%15==0? 0 : 1);
		int startPage = ipg -(ipg-1)%5;
		int start = (ipg-1)*15;
		int end = ipg*15;
		
		System.out.println("category : " + category);
		System.out.println("query : " + query);
		System.out.println("ipg : " + ipg);
		System.out.println("start : " + start);
		System.out.println("end : " + end);
		
		List<Qna> qnaList = qnaDAO.getAllQna(category, query, start, end);
		System.out.println("qnaList의 크기 : " + qnaList.size()); 
		
		model.addAttribute("pg", ipg);
		model.addAttribute("category", category);
		model.addAttribute("query", query);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("qnaList", qnaList);
		
		return "admin.manageQNA";
	}
}
