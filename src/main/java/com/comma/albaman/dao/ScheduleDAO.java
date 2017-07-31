package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Schedule;

@Component
public interface ScheduleDAO {
	
//	일별 전체 직원의 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} AND SUBSTRING_INDEX(PREONWORK,'-','2')=#{prework}")
	public List<Schedule> getSchedule(@Param("sid") String sid,@Param("prework") String prework);
	
	// 스케줄 저장
	@Insert("INSERT INTO SCHEDULE (SSEQ,PREONWORK,PREOFFWORK,ONWORK,OFFWORK,RID) VALUES ((SELECT * FROM (SELECT IFNULL(MAX(CAST(S.SSEQ AS UNSIGNED)),0)+1 FROM SCHEDULE S) NEXT),#{preOnWork},#{preOffWork},null,null,#{rid})")
	public int insertSchedule(@Param("preOnWork")String preOnWork,@Param("preOffWork")String preOffWork,@Param("rid")String rid);

	// 스케줄 지우기
	@Delete("DELETE FROM SCHEDULE WHERE SUBSTRING_INDEX(PREONWORK,'-','2')=#{deleteDate} AND RID=#{rid}")
	public void deleteSchedule(@Param("rid") String rid,@Param("deleteDate") String deleteDate);
	
	//시간별 직원 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} AND SUBSTRING_INDEX(PREONWORK,' ','1')=#{prework}")
	public List<Schedule> getDaySchedule(@Param("sid") String sid,@Param("prework") String prework);

	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} ")	
	public List<Schedule> getAllSchedule(String sid);
	
	// 현재 시간과 가장 가까운 출근예정시간을 갖는 컬럼 추출
	@Select("SELECT SSEQ FROM SCHEDULE WHERE RID=#{rid} AND DATE(PREONWORK)=CURDATE() ORDER BY ABS(TIMESTAMPDIFF(SECOND,PREONWORK,NOW())) LIMIT 1")
	public String getClosestPreOnWork(String rid);
	
	// 출근 시간 설정
	@Update("UPDATE SCHEDULE SET ONWORK = NOW() WHERE SSEQ = #{sseq} AND ONWORK IS NULL")
	public int setOnWork(String sseq);
	
	// 현재 시간과 가장 가까운 퇴근예정시간을 갖는 컬럼 추출
	@Select("SELECT SSEQ FROM SCHEDULE WHERE RID=#{rid} AND DATE(PREOFFWORK)=CURDATE() ORDER BY ABS(TIMESTAMPDIFF(SECOND,PREOFFWORK,NOW())) LIMIT 1")
	public String getClosestPreOffWork(String rid);
	
	// 퇴근 시간 설정
	@Update("UPDATE SCHEDULE SET OFFWORK = NOW() WHERE SSEQ = #{sseq} AND OFFWORK IS NULL AND ONWORK IS NOT NULL")
	public int setOffWork(String sseq);
	

	// 출근 시간 15분 전부터 퇴근시간 전 사이에 출근 가능 (해당 IP에서만)
	@Select("SELECT COUNT(*) FROM SCHEDULE WHERE RID=#{rid} AND DATE(PREONWORK)=CURDATE() AND TIMESTAMPDIFF(MINUTE,NOW(),PREONWORK)<=15 AND ONWORK IS NULL "
			+ "AND (SELECT STORE.IP FROM STORE INNER JOIN RECRUIT ON STORE.SID = RECRUIT.SID AND RECRUIT.RID = #{rid}) = #{ip}")
	public int possibleOnWork(@Param("rid") String rid, @Param("ip") String ip);

	// 퇴근 시간부터 퇴근 가능 (해당 IP에서만)
	@Select("SELECT COUNT(*) FROM SCHEDULE WHERE RID=#{rid} AND DATE(PREOFFWORK)=CURDATE() AND ONWORK IS NOT NULL AND OFFWORK IS NULL "
			+ "AND (SELECT STORE.IP FROM STORE INNER JOIN RECRUIT ON STORE.SID = RECRUIT.SID AND RECRUIT.RID = #{rid}) = #{ip} "
			+ "ORDER BY ABS(TIMESTAMPDIFF(SECOND,PREOFFWORK,NOW())) LIMIT 1")
	public int possibleOffWork(@Param("rid") String rid, @Param("ip") String ip);
}


