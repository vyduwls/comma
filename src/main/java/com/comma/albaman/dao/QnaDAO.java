package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Notice;
import com.comma.albaman.vo.Qna;

@Component
public interface QnaDAO {

	//관리자-문의사항 seq 갯수 가져오기
	@Select("SELECT COUNT(*) FROM QNA WHERE ${category} LIKE '%${query}%'")
	public int getAllMax(@Param("category")String category,@Param("query") String query);
	// 점주-문의사항 seq 갯수 가져오기
	@Select("SELECT COUNT(*) FROM QNA WHERE ${category} LIKE '%${query}%' AND MID=#{mid}")
	public int getMax(@Param("category")String category,@Param("query") String query,@Param("mid") String mid);
	//관리자-문의사항 가져오기
	@Select("SELECT * FROM QNA WHERE ${category} LIKE '%${query}%' ORDER BY CAST(QSEQ AS UNSIGNED) DESC LIMIT ${start}, ${end}")
	public List<Qna> getAllQna(@Param("category")String category,@Param("query") String query,@Param("start") int start,@Param("end") int end);
	//점주-문의사항 가져오기
	@Select("SELECT * FROM QNA WHERE MID=#{mid} AND ${category} LIKE '%${query}%' ORDER BY CAST(QSEQ AS UNSIGNED) DESC LIMIT ${start}, ${end}")
	public List<Qna> getQnaList(@Param("mid")String mid, @Param("category")String category,@Param("query") String query, @Param("start")int start,@Param("end") int end);
	//점주-문의사항 등록
	@SelectKey(before = true, keyProperty = "qseq", resultType = String.class, statement = "SELECT IFNULL(MAX(CAST(QSEQ AS UNSIGNED)),0)+1 FROM QNA") 
	@Insert("INSERT INTO QNA VALUES(#{qseq},#{title},#{content},CURDATE(),#{file},#{mid})")		
	public int addQna(@Param("title")String title, @Param("content")String content, @Param("file")String file, @Param("mid")String mid);
	//문의사항 detail 가져오기
	@Select("SELECT * FROM QNA WHERE QSEQ=#{qseq}")
	public Qna getQna(String qseq);
	//문의사항 삭제
	@Delete("DELETE FROM QNA WHERE QSEQ=#{qseq}")
	public int deleteQna(String qseq);
	//문의사항 수정
	@Update("UPDATE QNA SET TITLE=#{title},CONTENT=#{content},FILE=#{file} WHERE QSEQ=#{qseq}")
	public int updateQna(@Param("qseq")String qseq,@Param("title") String title,@Param("content") String content,@Param("file")String file);

}


