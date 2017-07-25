package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Member;

@Component
public interface MemberDAO {

	// mid로 회원 조회
	@Select("SELECT * FROM MEMBER WHERE MID = #{mid}")
	public Member getMember(String mid);
	
	// 회원 추가
	@Insert("INSERT INTO MEMBER VALUES(#{mid},#{pwd},#{name},#{phone},#{email},#{position})")
	public int addMember(Member member);
	
	// mid로 전체 회원 조회
	@Select("SELECT * FROM MEMBER WHERE MID IN (${allEmployeeRid})")
	public List<Member> getAllMember(@Param("allEmployeeRid")String allEmployeeRid);
}
