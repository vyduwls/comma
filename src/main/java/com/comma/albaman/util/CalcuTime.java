package com.comma.albaman.util;

public class CalcuTime {
	
	public int calcuTime(String time){
 		int selectHour=Integer.parseInt(time.split(":")[0]);
 		int selectMinute=Integer.parseInt(time.split(":")[1]);
 		int totalMinute=selectHour*60+selectMinute;
	
 		return totalMinute;
 	}	
	
}
