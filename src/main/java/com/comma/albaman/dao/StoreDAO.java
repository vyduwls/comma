package com.comma.albaman.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Component;

import com.comma.albaman.vo.Store;
import com.comma.albaman.vo.StoreForAdmin;

@Component
public interface StoreDAO {

	// sid로 가게 찾기
	@Select("SELECT * FROM STORE WHERE SID=#{sid}")
	public Store getStore(String sid);
	
	// mid(점주)로 가게 찾기
	@Select("SELECT * FROM STORE WHERE MID=#{mid} ORDER BY REGDATE DESC")
	public List<Store> getAllStore(@Param("mid")String mid);
	
	@Insert("INSERT INTO STORE (SID,NAME,ADDRESS,STORENUMBER,IP,IMAGE,MID,REGDATE) VALUES ((SELECT * FROM (SELECT IFNULL(MAX(CAST(S.SID AS UNSIGNED)),0)+1 FROM STORE S) NEXT),#{name},#{address},#{storeNumber},#{ip},NULL,#{mid},NOW())")
	public int addStore(Store store);
	
	@Update("UPDATE STORE SET NAME=#{name},ADDRESS=#{address},STORENUMBER=#{storeNumber},IP=#{ip} WHERE SID=#{sid}")
	public int updateStore(Store store);
	
	@Delete("DELETE FROM STORE WHERE SID=#{sid}")
	public int deleteStore(String sid);
	
	// 전체 가게 검색(ADMIN)
	@Select("SELECT *, (SELECT COUNT(*) FROM RECRUIT WHERE RECRUIT.SID=STORE.SID AND RESIGNDATE IS NULL AND JOINDATE <= CURDATE()) AS RECRUITCOUNT FROM STORE WHERE ${category} LIKE '%${query}%' ORDER BY REGDATE DESC")
	public List<StoreForAdmin> getAllStoreByAdmin(@Param("category")String category, @Param("query")String query);
}


