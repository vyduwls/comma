package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Schedule;

@Component
public interface ScheduleDAO {
	
//	일별 전체 직원의 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} AND SUBSTRING_INDEX(PREONWORK,'-','2')=#{prework}")
	public List<Schedule> getSchedule(@Param("sid") String sid,@Param("prework") String prework);
	
	// 스케줄 저장
	@Insert("INSERT INTO SCHEDULE (SSEQ,PREONWORK,PREOFFWORK,ONWORK,OFFWORK,RID) VALUES ((SELECT * FROM (SELECT IFNULL(MAX(CAST(S.SSEQ AS UNSIGNED)),0)+1 FROM SCHEDULE S) NEXT),#{date},#{date},null,null,#{rid})")
	public int insertSchedule(@Param("date")String date,@Param("rid")String rid);

	// 스케줄 지우기
	@Delete("DELETE FROM SCHEDULE WHERE SUBSTRING_INDEX(PREONWORK,'-','2')=#{deleteDate} AND RID=#{rid}")
	public void deleteSchedule(@Param("rid") String rid,@Param("deleteDate") String deleteDate);
	//시간별 직원 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} AND SUBSTRING_INDEX(PREONWORK,' ','1')=#{prework}")
	public List<Schedule> getDaySchedule(@Param("sid") String sid,@Param("prework") String prework);
}


