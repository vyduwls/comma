package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Employee;
import com.comma.albaman.vo.Member;
import com.comma.albaman.vo.StoreMember;

@Component
public interface MemberDAO {

	// mid로 회원 조회
	@Select("SELECT * FROM MEMBER WHERE MID = #{mid}")
	public Member getMember(String mid);
	
	// 회원 추가
	@Insert("INSERT INTO MEMBER VALUES (#{mid},#{pwd},#{name},#{phone},#{email},#{position})")
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
	@Update("UPDATE MEMBER SET PWD=#{pwd}, NAME=#{name}, EMAIL=#{email}, PHONE=#{phone} WHERE MID=#{mid}")
	public int modifyStoreOwner(Member member);
	@Delete("DELETE FROM MEMBER WHERE MID=#{mid}")
	public int withDraw(String mid);
	
	//현재 일하는 직원만 가져오기
	@Select("SELECT * FROM MEMBER INNER JOIN RECRUIT ON MID = RID AND SID = #{sid} WHERE SUBSTRING_INDEX(JOINDATE,'-',2)<=#{prework} AND (SUBSTRING_INDEX(RESIGNDATE,'-',2)>=#{prework} OR RESIGNDATE IS NULL) ORDER BY JOINDATE DESC")
	public List<Employee> getNowWorkEmployee(@Param("sid")String sid,@Param("prework")String prework);
	
	//가게 삭제할 때, 멤버 지우기
	@Delete("DELETE FROM  M USING MEMBER M JOIN  RECRUIT R ON M.MID=R.RID WHERE R.SID=#{sid}")
	public int deleteMember(String sid);
	@Delete("DELETE FROM  M USING MEMBER M JOIN  RECRUIT R ON M.MID=R.RID JOIN STORE S ON S.SID=R.SID WHERE S.MID=#{mid}")
	public int deleteAllMember(String mid);
	
	// 전체 점주 조회(ADMIN)
	@Select("SELECT *, (SELECT COUNT(*) FROM STORE WHERE STORE.MID=MEMBER.MID) AS STORECOUNT FROM MEMBER WHERE POSITION='점주' AND ${category} LIKE '%${query}%' ORDER BY STORECOUNT DESC")
	public List<StoreMember> getStoreMember(@Param("category")String category, @Param("query")String query);
	
	// 회원 정보 수정(ADMIN)
	@Update("UPDATE MEMBER SET PWD=#{pwd}, NAME=#{name}, PHONE=#{phone}, EMAIL=#{email} WHERE MID=#{mid}")
	public int modifyMemberByAdmin(@Param("mid")String mid, @Param("pwd")String pwd, @Param("name")String name, @Param("phone")String phone, @Param("email")String email);
	
	// 회원 탈퇴(ADMIN)
	@Delete("DELETE FROM MEMBER WHERE MID=#{mid}")
	public int resignMember(String mid);
}
