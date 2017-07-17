package com.comma.albaman.vo;


public class Member{

	private String mid;
	private String pwd;
	private String name;
	private String gender;
	private int age;
	private String birthday;
	private String phone;
	private String regdate;
	private String hobby;
	
	public Member() {
		this(null, null, null, null, 0, null, null);
	}
	
	



	public String getHobby() {
		return hobby;
	}





	public void setHobby(String hobby) {
		this.hobby = hobby;
	}





	public Member(String mid, String pwd, String name, String gender, int age, String birthday, String phone) {
		mid=this.mid;
		pwd=this.pwd;
		name=this.name;
		gender=this.gender;
		age=this.age;
		birthday=this.birthday;
		phone=this.phone;
	
		
	}
	public String getMid() {
		return mid;
	}
	public void setMid(String mid) {
		this.mid = mid;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	
	public String getBirthday() {
		return birthday;
	}


	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}


	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}

	
	
	
	
}
