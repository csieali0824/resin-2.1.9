<%@ page import="java.sql.*,java.util.*,java.text.*,java.io.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*" %>
<html>
<body>
<%
	String v_email="";
	sql = " select (select usermail from oraddman.wsuser c where c.username=case when a.sales_head_approve_date is null then a.region_sales_head_person else a.hq_sales_head_person end) email,b.sales_group"+
		  " from oraddman.tsc_om_salesorderrevise_wkfw a,oraddman.tsc_om_salesorderrevise_req b"+
		  " where a.temp_id=b.temp_id"+
		  " and a.seq_id=b.seq_id"+
		  " and a.temp_id=?"+
		  " and (a.sales_head_approve_date is null or (a.sales_head_approve_result=? and a.hq_sales_head_approve_date is null))"+
		  " and rownum=1";
	PreparedStatement statement2 = con.prepareStatement(sql);
	statement2.setString(1,temp_id);
	statement2.setString(2,"A");	
	ResultSet rs2=statement2.executeQuery();
	if (rs2.next())
	{
		v_email=rs2.getString(1);

		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		String remarks="";
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@mail.ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //´ú¸ÕÀô¹Ò
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(v_email));  	  
		}
		if (rs2.getString(2).equals("TSCA")) //add by Peggy 20230830
		{
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("cindy.huang@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("Reminder - Sales Order Move is waiting for your approval"+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		if (remarks.equals(""))
		{
			mbp.setContent("Sales Order Move Notification,<p>Please login to <a href="+'"'+"http://tsrfq.ts.com.tw:8080/oradds/jsp/TSSalesOrderReviseSalesApprove.jsp"+'"'+">RFQ System</a> to approve.", "text/html;charset=UTF-8");
		}
		else
		{
			mbp.setContent("Sales Order Move Notification,<p>Please login to <a href="+'"'+"http://rfq144.ts.com.tw:8080/oradds/jsp/TSSalesOrderReviseSalesApprove.jsp"+'"'+">RFQ System</a> to approve.", "text/html;charset=UTF-8");
		}
		mp.addBodyPart(mbp);
	
		// create the Multipart and add its parts to it
		message.setContent(mp);
		Transport.send(message);
	}
	rs2.close();
	statement2.close();			

%>
</body>
</html>

