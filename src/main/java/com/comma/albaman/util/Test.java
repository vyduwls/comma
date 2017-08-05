package com.comma.albaman.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class Test {

	public static void main(String[] args) {
		Calendar cal = Calendar.getInstance(Locale.KOREA);
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = df.parse("2017-08-17");
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		cal.setTime(date);
		cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		System.out.println(df.format(cal.getTime()));
		for(int i=0; i<6; i++) {
			cal.add(cal.DATE, 1);
			String temp = df.format(cal.getTime()).toString();
			System.out.println(temp);
		}
	}

}
