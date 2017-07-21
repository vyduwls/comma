package com.comma.albaman.dao;

import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Member;

@Component
public interface MemberDAO {

	@Select("SELECT * FROM MEMBER WHERE MID = #{mid}")
	public Member getMember(String mid);
}
