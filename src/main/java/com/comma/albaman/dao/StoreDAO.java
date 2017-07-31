package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Store;

@Component
public interface StoreDAO {

	// sid로 가게 찾기
	@Select("SELECT * FROM STORE WHERE SID=#{sid}")
	public Store getStore(String sid);
	
	// mid(점주)로 가게 찾기
	@Select("SELECT * FROM STORE WHERE MID=#{mid}")
	public List<Store> getAllStore(@Param("mid")String mid);
}


