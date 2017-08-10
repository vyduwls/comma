package com.comma.albaman.controllers;

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
	         date = df.parse("2017-08-31");
	      } catch (ParseException e) {
	         // TODO Auto-generated catch block
	         e.printStackTrace();
	      }
	      cal.setTime(date);
	      cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
	      String monDay=df.format(cal.getTime());
	      cal.add(cal.DATE, 6);
	      String sunDay = df.format(cal.getTime()).toString();
	      System.out.println("월요일---"+monDay+"일요일---"+sunDay);

	   }

	}