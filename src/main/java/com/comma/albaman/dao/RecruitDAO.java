package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Recruit;

@Component
public interface RecruitDAO {

	// 해당 점포의 직원 추출
	@Select("SELECT * FROM RECRUIT WHERE RID=#{rid}")
	public Recruit getRecruit(String rid);
	
	// 전체 직원 조회
	@Select("SELECT * FROM RECRUIT WHERE SID=#{sid} AND RESIGNDATE IS NULL")
	public List<Recruit> getAllRecruit(String sid);
	
	// 직원 수 조회
	@Select("SELECT COUNT(*) FROM RECRUIT WHERE SID = #{sid}")
	public int getRecruitCount(String sid);
	
	// 가장 높은 번호를 가진 사원번호 가져오기
	@Select("SELECT MAX(CAST(SUBSTRING_INDEX(RID, '-', -1) AS UNSIGNED)) FROM RECRUIT WHERE SID = #{sid}")
	public int getLastRecruit(String sid);

	// 사원 추가
	@Insert("INSERT INTO RECRUIT VALUES(#{rid},#{birth},#{address},${wage},#{joinDate},#{resignDate, jdbcType=VARCHAR},#{sid})")
	public int addRecruit(Recruit recruit);
	
	// 회원 정보 수정
	@Update("UPDATE RECRUIT SET BIRTH=#{birth}, ADDRESS=#{address}, WAGE=${wage}, JOINDATE=#{joinDate} WHERE RID=#{rid}")
	public int modifyRecruit(@Param("rid")String rid, @Param("birth")String birth, @Param("address")String address, @Param("wage")int wage, @Param("joinDate")String joinDate);
	
	// 퇴사하기
	@Update("UPDATE RECRUIT SET RESIGNDATE=CURDATE() WHERE RID=#{rid}")
	public int resignRecruit(@Param("rid")String rid);
}


