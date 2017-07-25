package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Schedule;

@Component
public interface ScheduleDAO {
	
//	전체 직원의 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID IN (${sid}) AND SUBSTRING_INDEX(PREONWORK,'-','2')=#{prework}")
	public List<Schedule> getSchedule(@Param("sid") String sid,@Param("prework") String prework);
}


