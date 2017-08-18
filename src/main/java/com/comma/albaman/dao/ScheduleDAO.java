package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Attendance;
import com.comma.albaman.vo.Schedule;

@Component
public interface ScheduleDAO {
	
//	일별 전체 직원의 스케줄 추출
	@Select("SELECT * FROM SCHEDULE S JOIN RECRUIT R ON S.RID=R.RID WHERE SID =#{sid} AND SUBSTRING_INDEX(PREONWORK,'-','2')=#{prework} ORDER BY ONWORK" )
	public List<Schedule> getSchedule(@Param("sid") String sid,@Param("prework") String prework);
	
	// 스케줄 저장
	@Insert("INSERT INTO SCHEDULE (SSEQ,PREONWORK,PREOFFWORK,ONWORK,OFFWORK,RID,WAGE) VALUES ((SELECT * FROM (SELECT IFNULL(MAX(CAST(S.SSEQ AS UNSIGNED)),0)+1 FROM SCHEDULE S) NEXT),#{preOnWork},#{preOffWork},null,null,#{rid},${wage})")
	public int insertSchedule(@Param("preOnWork")String preOnWork,@Param("preOffWork")String preOffWork,@Param("rid")String rid,@Param("wage") int wage);

	// 스케줄 지우기
	@Delete("DELETE FROM SCHEDULE WHERE PREONWORK  BETWEEN #{startDate} AND #{endDate} AND RID=#{rid}")
	public int deleteSchedule(@Param("rid") String rid,@Param("startDate") String startDate,@Param("endDate") String endDate);
	
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
	
	//
	@Select("SELECT * FROM SCHEDULE WHERE RID=#{mid} AND SUBSTRING_INDEX(PREONWORK,'-','2')=#{prework} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL ORDER BY ONWORK")
	public List<Schedule> getWorkTime(@Param("mid")String mid,@Param("prework") String prework);
	
	// 해당 가게의 모든 근태 기록 불러오기
	@Select("SELECT S.SSEQ AS SSEQ, DATE(S.PREONWORK) AS DATE, R.RID AS MID, (SELECT NAME FROM MEMBER WHERE MID=R.RID) AS NAME, (SELECT POSITION FROM MEMBER WHERE MID=R.RID) AS POSITION, "
			+ "TIME(S.PREONWORK) AS PREONWORK, TIME(S.PREOFFWORK) AS PREOFFWORK, TIME(S.ONWORK) AS ONWORK, TIME(S.OFFWORK) AS OFFWORK, IF(S.ONWORK - S.PREONWORK > 0,'지각','정상') AS ONWORKSTATE, "
			+ "IF(S.PREOFFWORK - S.OFFWORK > 0,'조퇴','정상') AS OFFWORKSTATE FROM RECRUIT AS R INNER JOIN SCHEDULE AS S "
			+ "ON R.RID = S.RID AND R.SID = #{sid} AND DATE(S.PREONWORK) <= CURDATE() ORDER BY DATE(S.PREONWORK) DESC")
	public List<Attendance> getAttendance(String sid);
	// 해당 직원의 모든 근태 기록 불러오기
	@Select("SELECT S.SSEQ AS SSEQ, DATE(S.PREONWORK) AS DATE, R.RID AS MID, (SELECT NAME FROM MEMBER WHERE MID=R.RID) AS NAME, (SELECT POSITION FROM MEMBER WHERE MID=R.RID) AS POSITION, "
			+ "TIME(S.PREONWORK) AS PREONWORK, TIME(S.PREOFFWORK) AS PREOFFWORK, TIME(S.ONWORK) AS ONWORK, TIME(S.OFFWORK) AS OFFWORK, IF(S.ONWORK - S.PREONWORK > 0,'지각','정상') AS ONWORKSTATE, "
			+ "IF(S.PREOFFWORK - S.OFFWORK > 0,'조퇴','정상') AS OFFWORKSTATE FROM RECRUIT AS R INNER JOIN SCHEDULE AS S "
			+ "ON R.RID = S.RID AND R.RID = #{rid} AND DATE(S.PREONWORK) <= CURDATE() ORDER BY DATE(S.PREONWORK) DESC")
	public List<Attendance> getAttendanceForEmployee(@Param("rid")String rid);
	
	// 해당 직원의 근태 기록 검색 기능
	@Select("SELECT S.SSEQ AS SSEQ, DATE(S.PREONWORK) AS DATE, R.RID AS MID, (SELECT NAME FROM MEMBER WHERE MID=R.RID) AS NAME, (SELECT POSITION FROM MEMBER WHERE MID=R.RID) AS POSITION, "
			+ "TIME(S.PREONWORK) AS PREONWORK, TIME(S.PREOFFWORK) AS PREOFFWORK, TIME(S.ONWORK) AS ONWORK, TIME(S.OFFWORK) AS OFFWORK, IF(S.ONWORK - S.PREONWORK > 0,'지각','정상') AS ONWORKSTATE, "
			+ "IF(S.PREOFFWORK - S.OFFWORK > 0,'조퇴','정상') AS OFFWORKSTATE FROM RECRUIT AS R INNER JOIN SCHEDULE AS S "
			+ "ON R.RID = S.RID AND R.RID = #{rid} AND DATE(S.PREONWORK) <= CURDATE()  AND DATE(S.PREONWORK) BETWEEN #{startDate} AND #{endDate} ORDER BY DATE(S.PREONWORK) DESC")
	public List<Attendance> searchAttendanceForEmployee(@Param("rid")String rid, @Param("startDate")String startDate, @Param("endDate")String endDate);
	
	// 근태 기록 검색 기능
	@Select("SELECT * FROM (SELECT S.SSEQ AS SSEQ, DATE(S.PREONWORK) AS DATE, R.RID AS MID, (SELECT NAME FROM MEMBER WHERE MID=R.RID) AS NAME, (SELECT POSITION FROM MEMBER WHERE MID=R.RID) AS POSITION, "
			+ "TIME(S.PREONWORK) AS PREONWORK, TIME(S.PREOFFWORK) AS PREOFFWORK, TIME(S.ONWORK) AS ONWORK, TIME(S.OFFWORK) AS OFFWORK, IF(S.ONWORK - S.PREONWORK > 0,'지각','정상') AS ONWORKSTATE, "
			+ "IF(S.PREOFFWORK - S.OFFWORK > 0,'조퇴','정상') AS OFFWORKSTATE FROM RECRUIT AS R INNER JOIN SCHEDULE AS S "
			+ "ON R.RID = S.RID AND R.SID = #{sid} AND DATE(S.PREONWORK) BETWEEN #{startDate} AND #{endDate} AND DATE(S.PREONWORK) <= CURDATE()) ORIGIN "
			+ "WHERE ${category} LIKE '%${query}%' ORDER BY DATE DESC")
	public List<Attendance> searchAttendance(@Param("sid")String sid, @Param("startDate")String startDate, @Param("endDate")String endDate, @Param("category")String category, @Param("query")String query);
	
	// 근태 기록 수정
	@Update("UPDATE SCHEDULE SET PREONWORK=#{preOnWork},PREOFFWORK=#{preOffWork},ONWORK=#{onWork},OFFWORK=#{offWork} WHERE SSEQ=#{sseq}")
	public int modifyAttendance(@Param("sseq")String sseq, @Param("preOnWork")String preOnWork, @Param("preOffWork")String preOffWork, @Param("onWork")String onWork, @Param("offWork")String offWork);
	
	//직원의 결근 횟수 가져오기
	@Select("SELECT COUNT(*) FROM SCHEDULE WHERE PREONWORK BETWEEN #{monDay} AND #{sunDay} AND RID=#{mid} AND ONWORK IS NULL")
	public int checkAbsent(@Param("monDay")String monDay,@Param("sunDay")String sunDay,@Param("mid")String mid);
	
	//직원의 주 근태정보 가져오기
	@Select("SELECT * FROM SCHEDULE WHERE ONWORK BETWEEN #{monDay} AND #{sunDay} AND RID=#{mid} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL ORDER BY ONWORK")
	public List<Schedule> getWeekSchedule(@Param("monDay")String monDay,@Param("sunDay")String sunDay,@Param("mid")String mid);
	
	//직원의 주 총 근무시간 가져오기
	@Select("SELECT IFNULL(SUM(TIMESTAMPDIFF(MINUTE,ONWORK,OFFWORK)),0) FROM  SCHEDULE WHERE ONWORK BETWEEN #{monDay} AND #{sunDay} AND RID=#{mid} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL")
	public Integer getWeekWorkTime(@Param("monDay")String monDay,@Param("sunDay")String sunDay,@Param("mid")String mid);
	
	//일별 총 근무시간 구하기
	@Select("SELECT IFNULL(TIMESTAMPDIFF(MINUTE,ONWORK,OFFWORK),0) FROM  SCHEDULE WHERE SUBSTRING_INDEX(ONWORK,'-','2')=#{prework} AND RID=#{mid} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL ORDER BY ONWORK")
	public int[] getWorkDayTime(@Param("prework")String prework, @Param("mid")String mid);
	//월 총 근무시간 구하기
	@Select("SELECT IFNULL(SUM(TIMESTAMPDIFF(MINUTE,ONWORK,OFFWORK)),0) FROM  SCHEDULE WHERE SUBSTRING_INDEX(ONWORK,'-','2')=#{prework} AND RID=#{mid} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL ORDER BY ONWORK")
	public int getWorkTotalTime(@Param("prework")String prework, @Param("mid")String mid);
	//한 주의 평균 시급 구하기
	@Select("SELECT IFNULL(SUM(WAGE)/COUNT(*),0) FROM  SCHEDULE WHERE ONWORK BETWEEN #{monDay} AND #{sunDay} AND RID=#{mid} AND ONWORK IS NOT NULL AND OFFWORK IS NOT NULL")
	public int getWeekWage(@Param("monDay")String monDay,@Param("sunDay")String sunDay,@Param("mid")String mid);
}


