package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Employee;
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
	
	// 특정 가게 직원 전체 정보 조회
	@Select("SELECT * FROM MEMBER INNER JOIN RECRUIT ON MID = RID AND SID = #{sid} ORDER BY JOINDATE DESC")
	public List<Employee> getEmployee(String sid);
	
	// 특정 직원 정보 조회
	@Select("SELECT * FROM MEMBER INNER JOIN RECRUIT ON MID = RID AND MID = #{mid}")
	public Employee getEmployeeForEmployee(String mid);
	
	// 특정 조건의 가게 직원 정보 조회
	@Select("SELECT * FROM MEMBER INNER JOIN RECRUIT ON MID = RID AND SID = #{sid} AND ${category} LIKE '%${query}%' AND( JOINDATE <= #{endDate} AND ( RESIGNDATE >= #{startDate} OR RESIGNDATE IS NULL)) ORDER BY JOINDATE DESC")
	public List<Employee> searchEmployee(@Param("sid")String store, @Param("category")String category, @Param("query")String query, @Param("startDate")String startDate, @Param("endDate")String endDate);
	
	// 회원 정보 수정
	@Update("UPDATE MEMBER SET PWD=#{pwd}, NAME=#{name}, POSITION=#{position}, PHONE=#{phone} WHERE MID=#{mid}")
	public int modifyMember(@Param("mid")String mid, @Param("pwd")String pwd, @Param("name")String name, @Param("position")String position, @Param("phone")String phone);
}
