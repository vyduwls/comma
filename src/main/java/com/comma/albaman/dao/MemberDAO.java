package com.comma.albaman.dao;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.comma.albaman.vo.Member;




public interface MemberDAO {

	// 한글이다 한글 한글 1234 ㅅㄷㅇㄹ마름나름너룬머루먼루
	@Select("SELECT * FROM MEMBERS WHERE MID = #{mid}")
	public Member getMember(String mid);
	//ȸ������
	
	@Insert("INSERT INTO MEMBERS (MID, PWD, NAME, GENDER, AGE, BIRTHDAY, PHONE, HOBBY) VALUES(#{mid},#{pwd},#{name},#{gender},#{age},#{birthday},#{phone},#{hobby, jdbcType=VARCHAR})")
	public int addMember(Member m) ;
	
	//ȸ����������
	@Update("UPDATE MEMBERS SET PWD=#{pwd}, PHONE=#{phone}, HOBBY=#{hobby}, BIRTHDAY=#{birthday}, AGE=#{age} WHERE MID=#{mid}")
	public int modifyMemberDao(Member m);
	
	@Delete("DELETE DEALS WHERE FACCOUNTNUM = ANY(SELECT ACCOUNTNUM FROM ACCOUNT WHERE OWNER = #{mid})")
	public int deleteID1(Member m);
	
	@Delete("DELETE ACCOUNT WHERE OWNER = #{mid}")
	public int deleteID2(Member m);
	
	@Delete("DELETE MEMBERS WHERE MID =#{mid}")
	public int deleteID3(Member m);
	
	@Update("UPDATE MEMBERS SET POINT = POINT+1 WHERE MID=#{mid}")
	public int pointUp(String mid);
}
