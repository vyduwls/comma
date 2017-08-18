package com.comma.albaman.controllers;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.comma.albaman.dao.NoticeDAO;
import com.comma.albaman.dao.QnaDAO;
import com.comma.albaman.dao.RecruitDAO;
import com.comma.albaman.dao.ScheduleDAO;
import com.comma.albaman.dao.StoreDAO;
import com.comma.albaman.util.SendMail;
import com.comma.albaman.vo.Employee;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.Notice;
import com.comma.albaman.vo.Qna;
import com.comma.albaman.vo.Recruit;
import com.comma.albaman.vo.Schedule;
import com.comma.albaman.vo.Store;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

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
			}else if(member.getPosition().equals("관리자")){
				request.getSession().setAttribute("mid", mid);
				request.getSession().setAttribute("checkPosition", "0");
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
	
	@RequestMapping(value={"myPage.do"}, method=RequestMethod.GET)
	public String myPage(HttpServletRequest request,Model model){
		System.out.println("\nCustomerController의 myPage.do");
		String mid=(String) request.getSession().getAttribute("mid");
		
		//멤버 정보 가져오기
		MemberDAO memberDao=sqlSession.getMapper(MemberDAO.class);
		Member member=memberDao.getMember(mid);
		//가게 정보 가져오기
		StoreDAO storeDao=sqlSession.getMapper(StoreDAO.class);
		List<Store> storeList=storeDao.getAllStore(mid);
		
		model.addAttribute("member", member);
		model.addAttribute("storeList", storeList);
		return "customer.myPage";
	}
	
	@RequestMapping(value={"addStore.do"}, method=RequestMethod.GET)
	public String addStore(HttpServletRequest request,Model model){
		System.out.println("\nCustomerController의 addStore.do");
		return "customer.addStore";
	}
	
	@RequestMapping(value={"modifyStore.do"}, method=RequestMethod.GET)
	public String modifyStore(HttpServletRequest request,Model model,String sid){
		System.out.println("\nCustomerController의 modifyStore.do");
		StoreDAO storeDao=sqlSession.getMapper(StoreDAO.class);
		Store store=storeDao.getStore(sid);
		
		model.addAttribute("store", store);
		return "customer.modifyStore";
	}
	
	@RequestMapping(value={"modifyMember.do"}, method=RequestMethod.GET)
	public String modifyMember(HttpServletRequest request,Model model){
		System.out.println("\nCustomerController의 modifyMember.do");
		String mid=(String) request.getSession().getAttribute("mid");
		
		//멤버 정보 가져오기
		MemberDAO memberDao=sqlSession.getMapper(MemberDAO.class);
		Member member=memberDao.getMember(mid);
		
		model.addAttribute("member", member);
		return "customer.modifyMember";
	}
	
	@RequestMapping(value={"saveMember.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String saveMember(HttpServletRequest request,Model model,Member member){
		System.out.println("\nCustomerController의 saveMember.do");
		MemberDAO memberDao=sqlSession.getMapper(MemberDAO.class);
		String data=Integer.toString(memberDao.modifyStoreOwner(member));
		System.out.println("data---"+data);
		return data;
	}
	
	@RequestMapping(value={"withDraw.do"}, method=RequestMethod.GET)
	public String withDraw(HttpServletRequest request,Model model){
		System.out.println("\nCustomerController의 withDraw.do");
		
		String mid=(String) request.getSession().getAttribute("mid");
		MemberDAO memberDao=sqlSession.getMapper(MemberDAO.class);
		int data=memberDao.withDraw(mid);
		
		System.out.println("DATA----"+data);
		request.getSession().invalidate();
		
		return "redirect:../index.do";
	}
	
	@RequestMapping(value={"insertStore.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String insertStore(HttpServletRequest request,Model model,Store store){
		System.out.println("\nCustomerController의 insertStore.do");
		
		String mid=(String) request.getSession().getAttribute("mid");
		store.setMid(mid);
		StoreDAO storeDao=sqlSession.getMapper(StoreDAO.class);
		String data=Integer.toString(storeDao.addStore(store));
		
		return data;
	}
	
	@RequestMapping(value={"saveStore.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String saveStore(HttpServletRequest request,Model model,Store store){
		System.out.println("\nCustomerController의 saveStore.do");

		StoreDAO storeDao=sqlSession.getMapper(StoreDAO.class);
		String data=Integer.toString(storeDao.updateStore(store));
		
		return data;
	}
	
	@RequestMapping(value={"deleteStore.do"}, method=RequestMethod.POST)
	@ResponseBody
	public String deleteStore(HttpServletRequest request,Model model,String sid){
		System.out.println("\nCustomerController의 deleteStore.do");

		StoreDAO storeDao=sqlSession.getMapper(StoreDAO.class);
		String data=Integer.toString(storeDao.deleteStore(sid));
		
		return data;
	}
	
	// 문의사항 페이지
		@RequestMapping(value={"qna.do"}, method=RequestMethod.GET)
		public String qna(String category, String query, String pg, HttpServletRequest request, Model model) {
			System.out.println("\nStoreController의 notice.do(GET)");

			String mid = (String) request.getSession().getAttribute("mid");
			String checkPosition = (String) request.getSession().getAttribute("checkPosition");

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
			
//			int total = qnaDAO.getAllMax(category, query, mid);

//			int lastPage = total/10 + (total%10==0? 0 : 1);
			int startPage = ipg - (ipg-1)%5;
			int start = (ipg-1)*10;
			int end = ipg*10;
			
			System.out.println("category : " + category);
			System.out.println("query : " + query);
			System.out.println("ipg : " + ipg);
			System.out.println("start : " + start);
			System.out.println("end : " + end);
			
			List<Qna> qnaList =new ArrayList<Qna>();
//			qnaList= qnaDAO.getNotices(mid, category, query, start, end);

			
			System.out.println("noticeList 크기 : " + qnaList.size());
			
			model.addAttribute("pg", ipg);
			model.addAttribute("category", category);
			model.addAttribute("query", query);
//			model.addAttribute("lastPage", lastPage);
			model.addAttribute("startPage", startPage);
			model.addAttribute("noticeList", qnaList);
			
			return "store.notice";
		}
		
		// 문의사항 세부 페이지
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
		
		// 문의사항 등록 페이지
		@RequestMapping(value={"addNotice.do"}, method=RequestMethod.GET)
		public String addNotice(String sid, Model model, String add){
			System.out.println("\nStoreController의 addNotice.do(GET)");
			
			StoreDAO storeDAO = sqlSession.getMapper(StoreDAO.class);
			Store store = storeDAO.getStore(sid);
			
			model.addAttribute("store", store);
			model.addAttribute("add",add);
			
			return "store.addNotice";
		}
		
		// 문의사항 이미지 업로드(위지윅)
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
		
		// 문의사항 등록
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
		
		// 문의사항 수정 페이지
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
		
		// 문의사항 수정
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
		
		// 문의사항 삭제
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
}
