<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,javax.mail.*,javax.mail.internet.*"%> 
 

<%
 Connection conn = null;
 
 		String id= ""; 
		String name=   ""; 
		String email=   ""; 
		String title=  "";  
		String department=   "";  
		String telephone=  "";  
		String fax=  "";  
		String company=   ""; 
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://ap:1433;DatabaseName=tsc_co;User=web;Password=6227");

 
try{ 
		
				//out.println("conn="+conn);
		 
		
		String Sql = " select *  from cust_mail ";
		Statement st = null;
		ResultSet rs = null;
		st = conn.createStatement();
		rs = st.executeQuery(Sql);
		while(rs.next()){
		  id= rs.getString("id");
		  //out.println("id");
		  name= rs.getString("name");
		  email= rs.getString("email");
		  title= rs.getString("title");
		  department= rs.getString("department");
		  telephone= rs.getString("telephone");
		  fax= rs.getString("fax");
		  company= rs.getString("company");
			%>
				<%@ include file="/jsp/TscMailBody.jsp"%>
			<%
		
		
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
		
			//out.println(props);
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		
			javax.mail.internet.InternetAddress from = new javax.mail.internet.InternetAddress("suming@mail.ts.com.tw");
		
			javax.mail.internet.InternetAddress to = new javax.mail.internet.InternetAddress(email);
		
			message.setSentDate(new java.util.Date());
			message.setFrom(from);
			message.addRecipient(Message.RecipientType.TO, to);
		
			message.setSubject("====== Taiwan Semi Customer Questionnaire--September,2006 ======");
			message.setContent(httl,"text/html");
			//Transport transport=s.getTransport("smtp");
			//transport.sendMessage(message,message.getAllRecipients()); 
			//transport.close(); 
			Transport.send(message);
			
		}
		 }catch(MessagingException e){ 
		out.println(e.toString()); 
		}finally{
		   if(conn!=null){
		      conn.close();
			  //conn=null;
		   }
		  }		
		
%>	
 