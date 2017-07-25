package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
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
	
	// 가장 높은 번호를 가진 사원번호 가져오기
	@Select("SELECT MAX(CAST(SUBSTRING_INDEX(RID, '-', -1) AS UNSIGNED)) FROM RECRUIT WHERE SID = #{sid}")
	public int getLastRecruit(String sid);

	@Insert("INSERT INTO RECRUIT VALUES(#{rid},#{birth},#{address},${wage},#{joinDate},#{resignDate, jdbcType=VARCHAR},#{sid})")
	public int addRecruit(Recruit recruit);
}


