package com.comma.albaman.vo;

public class SalaryManage {
	
		private String mid;
		private String name;
		private int wage;
		private int totalTime;
		private int weeklyPay;
		private int excessPay;
		private int overTimePay;
		private int totalPay;
		
		
		public int getWage() {
			return wage;
		}
		public void setWage(int wage) {
			this.wage = wage;
		}
		public String getMid() {
			return mid;
		}
		public void setMid(String mid) {
			this.mid = mid;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public int getTotalTime() {
			return totalTime;
		}
		public void setTotalTime(int totalTime) {
			this.totalTime = totalTime;
		}
		public int getWeeklyPay() {
			return weeklyPay;
		}
		public void setWeeklyPay(int weeklyPay) {
			this.weeklyPay = weeklyPay;
		}
		public int getExcessPay() {
			return excessPay;
		}
		public void setExcessPay(int excessPay) {
			this.excessPay = excessPay;
		}
		public int getOverTimePay() {
			return overTimePay;
		}
		public void setOverTimePay(int overTimePay) {
			this.overTimePay = overTimePay;
		}
		public int getTotalPay() {
			return totalPay;
		}
		public void setTotalPay(int totalPay) {
			this.totalPay = totalPay;
		}
	
}
