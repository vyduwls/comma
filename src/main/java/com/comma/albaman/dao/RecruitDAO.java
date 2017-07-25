package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Recruit;

@Component
public interface RecruitDAO {

//	해당 점포의 직원 추출
	@Select("SELECT * FROM RECRUIT WHERE RID=#{rid}")
	public Recruit getRecruit(String rid);
//  전체 직원 조회
	@Select("SELECT * FROM RECRUIT WHERE SID=#{sid} AND RESIGNDATE IS NULL")
	public List<Recruit> getAllRecruit(String sid);
}


