package com.comma.albaman.util;

import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendMail {
	private String receiver;
	private Pattern mailPattern = Pattern.compile("([A-Za-z0-9]+[@][a-zA-Z0-9]+[.][A-Za-z0-9]+)");
	private String naverID;
	private String naverPW;

	public SendMail(String sendTo) {
		Matcher matcher = mailPattern.matcher(sendTo);
		if(!matcher.find()) {
			System.out.println(sendTo + "를 찾을 수 없습니다.");
		}
		this.receiver = sendTo;
	}

	public String getReceiver() {
		return receiver;
	}

	public String sendMail(String title, String contents, boolean isHTML) {
		try {
			Message mm = new MimeMessage(getSession());
			mm.setFrom(new InternetAddress(naverID + "@naver.com"));
			mm.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver));
			mm.setSubject(title);
			if (isHTML) {
				mm.setContent(contents, "text/html; charset=utf-8");
			} else {
				mm.setText(contents);
			}
			Transport.send(mm);
			return "1";
		} catch (Exception e) {
			e.printStackTrace();
			return "0";
		}
	}
	public void login(String naverID, String naverPW) {
		this.naverID = naverID;
		this.naverPW = naverPW;
	}
	private Session getSession() throws NotLoggedInException {
		if (naverID == null || naverPW == null) {
			throw new NotLoggedInException();
		}
		Properties props = System.getProperties();
		props.put("mail.smtp.host", "smtp.naver.com");
		props.put("mail.smtp.port", 465);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.ssl.trust", "smtp.naver.com");
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(naverID, naverPW);
			}
		});
		return session;
	}
}

class UnknownMailException extends Exception {
	private static final long serialVersionUID = 1L;
	public UnknownMailException(String message) {
		super(message);
	}
}
class NotLoggedInException extends Exception {
	private static final long serialVersionUID = 1L;
	public NotLoggedInException() {
		super();
	}

}
