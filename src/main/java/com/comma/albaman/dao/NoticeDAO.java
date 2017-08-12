package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Notice;

@Component
public interface NoticeDAO {
		
		// 해당 가게의 공지사항 갯수
		@Select("SELECT COUNT(*) FROM NOTICE WHERE ${category} LIKE '%${query}%' AND SID=#{sid}")
		public int getMax(@Param("category")String category, @Param("query")String query, @Param("sid")String sid);
	
		// 해당 가게의 공지사항 반환
		@Select("SELECT * FROM NOTICE WHERE SID=#{sid} AND ${category} LIKE '%${query}%' ORDER BY CAST(NSEQ AS UNSIGNED) DESC LIMIT ${start}, ${end}")
		public List<Notice> getNotices(@Param("sid")String sid, @Param("category")String category, @Param("query")String query, @Param("start")int start, @Param("end")int end);
		
		// 해당 공지사항 반환
		@Select("SELECT * FROM NOTICE WHERE NSEQ=#{nseq}")
		public Notice getNotice(String nseq);
		
		// 해당 공지사항 삭제
		@Delete("DELETE FROM NOTICE WHERE NSEQ=#{nseq}")
		public int deleteNotice(String nseq);
				
		// 공지사항 등록
		@SelectKey(before = true, keyProperty = "nseq", resultType = String.class, statement = "SELECT MAX(CAST(NSEQ AS UNSIGNED))+1 FROM NOTICE") 
		@Insert("INSERT INTO NOTICE VALUES(#{nseq},#{title},#{content},CURDATE(),#{file},#{sid})")
		public int addNotice(@Param("title")String title, @Param("content")String content, @Param("file")String file, @Param("sid")String sid);
		
		/*// 회원 정보 수정
		@Update("UPDATE MEMBER SET PWD=#{pwd}, NAME=#{name}, POSITION=#{position}, PHONE=#{phone} WHERE MID=#{mid}")
		public int modifyMember(@Param("mid")String mid, @Param("pwd")String pwd, @Param("name")String name, @Param("position")String position, @Param("phone")String phone);*/
}


