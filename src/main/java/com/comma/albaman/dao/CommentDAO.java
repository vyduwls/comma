package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectKey;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Comment;

@Component
public interface CommentDAO {
	
	// 특정 게시글의 댓글 가져오기
	@Select("SELECT * FROM COMMENT WHERE QSEQ = #{qseq} ORDER BY CSEQ")
	public List<Comment> getComment(String qseq);
	
	// 특정 게시글의 댓글 수 가져오기
	@Select("SELECT COUNT(*) FROM COMMENT WHERE QSEQ = #{qseq}")
	public List<Comment> getCommentCount(String qseq);
	
	// 댓글 수정하기
	@Update("UPDATE COMMENT SET CONTENT = #{content} WHERE CSEQ = #{cseq}")
	public int modifyComment(@Param("cseq")String cseq, @Param("content")String content);
	
	// 댓글 삭제하기
	@Delete("DELETE FROM COMMENT WHERE CSEQ = #{cseq}")
	public int deleteComment(String cseq);
	
	// 댓글 추가하기
	@SelectKey(before = true, keyProperty = "cseq", resultType = String.class, statement = "SELECT MAX(CAST(CSEQ AS UNSIGNED))+1 FROM COMMENT") 
	@Insert("INSERT INTO COMMENT VALUES(#{cseq},#{content},CURDATE(),#{qseq},#{mid})")
	public int addComment(@Param("content")String content, @Param("qseq")String qseq, @Param("mid")String mid);
}
