package com.comma.albaman.vo;

public class Qna {
	
		private String qseq;
		private String title;
		private String content;
		private String regDate;
		private String file;
		private String mid;
		private int comment;
		
		
		public String getQseq() {
			return qseq;
		}
		public void setQseq(String qseq) {
			this.qseq = qseq;
		}
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getContent() {
			return content;
		}
		public void setContent(String content) {
			this.content = content;
		}
		public String getRegDate() {
			return regDate;
		}
		public void setRegDate(String regDate) {
			this.regDate = regDate;
		}
		
		public String getFile() {
			return file;
		}
		public void setFile(String file) {
			this.file = file;
		}
		public String getMid() {
			return mid;
		}
		public void setMid(String mid) {
			this.mid = mid;
		}
		public int getComment() {
			return comment;
		}
		public void setComment(int comment) {
			this.comment = comment;
		}
}
