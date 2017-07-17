package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;

import com.comma.albaman.vo.Notice;


public interface NoticeDAO {

	//�Խñۺ���
	@Select("SELECT * FROM NOTICES WHERE SEQ = #{seq}")
	public abstract Notice getNotice(String seq);
	
	//�Խñ� ��� - ArrayList<Notice>
	@Select("SELECT * FROM (SELECT ROWNUM RN, N.* FROM (SELECT * FROM NOTICES WHERE ${field} LIKE '%${query}%' ORDER BY TO_NUMBER(SEQ) DESC) N) WHERE RN BETWEEN 1+(#{pg}-1)*10 AND 10+(#{pg}-1)*10 ")
	public List<Notice> getNotices(@Param("pg")int pg, @Param("field")String field, @Param("query")String query);
	
	@Update("UPDATE NOTICES SET TITLE=#{param1}, CONTENT=#{param2} WHERE SEQ=#{param3}")
	public int updateNotice(String title, String content, String seq);
	
	@Update("UPDATE NOTICES SET HIT=HIT+1 WHERE SEQ = #{seq}")
	public int updateHit(String seq);
	
	@Delete("DELETE NOTICES WHERE SEQ =#{seq}")
	public int deleteNotice(String seq);
	
	@SelectKey(before=true, keyProperty="seq", resultType=String.class, statement="SELECT NVL(MAX(TO_NUMBER(SEQ)),0)+1 FROM NOTICES")
	@Insert("INSERT INTO NOTICES (SEQ, TITLE, WRITER, CONTENT, REGDATE, HIT, FILESRC) VALUES(#{seq}, #{param1}, #{param3}, #{param2}, SYSDATE, 0, #{param4, jdbcType=VARCHAR})")
	public int insertNotice (String title, String content, String mid, String fileSrc);
	
	@Select("SELECT COUNT(SEQ) COUNT FROM NOTICES WHERE ${param1} LIKE '%${param2}%'")
	public int getSeqCount(String field, String query);
}


