<!-- modify by Peggy 20141217,記錄回覆之客戶的ip or mail server-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,javax.mail.*,javax.mail.internet.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,SendMailBean,CodeUtil" %>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<body>
<form method='post'  name='form1'>
<%
//String serverHostName = request.getServerName();
String remoteAddr     = request.getRemoteAddr();         //add by Peggy 20141217
//String mailHost       = application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
//out.println("mailHost="+mailHost);
String name           = request.getParameter("Name");
String department	  = request.getParameter("Department");
String title		  = request.getParameter("Title");
String company 		  = request.getParameter("Company");
String email		  = request.getParameter("Email");
String telephone	  = request.getParameter("Telephone");
String fax			  = request.getParameter("Fax");
String q1             = request.getParameter("Q1");
String q2             = request.getParameter("Q2");
String q3             = request.getParameter("Q3");
String q4             = request.getParameter("Q4");
String q5             = request.getParameter("Q5");
String q6             = request.getParameter("Q6");
String q7             = request.getParameter("Q7");
String q8             = request.getParameter("Q8");
String q9             = request.getParameter("Q9");
String q10            = request.getParameter("Q10");
String comment        = request.getParameter("comment");
String customerId     = request.getParameter("custid");
String region         = request.getParameter("REGION");
String terrority      = request.getParameter("TERRORITY");
String keycode        = request.getParameter("keycode");
if (keycode == null) keycode ="";
String id = null;  // 本次回函的序號
String sql = "";

//檢查客戶滿意度調查是否已截止
String sqly = "select deadline from ORADDMAN.CUST_MAIL a where rowid ='"+keycode+"' and deadline < TO_CHAR(trunc(sysdate),'yyyymmdd')";
Statement sty = con.createStatement();
ResultSet rsy = sty.executeQuery(sqly);		
if (rsy.next())
{
	out.println("<input type='hidden' name='deadline' value='"+rsy.getString("deadline")+"'>");
%>
	<Script language="JavaScript">
		alert("The customer questionnaire end on "+document.form1.deadline.value+" and thanks for your cooperation!!");
		location.replace('http://www.taiwansemi.com/');  
	</Script>
<%
}
rsy.close();
sty.close();

//檢查是否已回覆,add by Peggy 20130111
String sqlx = "select ID from ORADDMAN.CUST_COLLECT_QUESTIONNAIRE a where a.ORIG_ROWID ='"+keycode+"'";			  
Statement stx = con.createStatement();
ResultSet rsx = stx.executeQuery(sqlx);		
if (rsx.next())
{
	id = rsx.getString("id");

	sql =" update ORADDMAN.CUST_COLLECT_QUESTIONNAIRE " +
				" set q1 =?,"+
				" q2 =?,"+
				" q3 =?,"+
				" q4 =?,"+
				" q5 =?,"+
				" q6 =?,"+ 
				" q7 =?,"+
				" q8 =?,"+
				" q9 =?,"+
				" q10=?,"+
				" comments =?"+
				" where ORIG_ROWID='"+keycode+"'"+
				" and ID = '" + id +"'";
	//out.println("sql="+sql); 					
	PreparedStatement st1 = con.prepareStatement(sql);
	st1.setString(1,q1);
	st1.setString(2,q2);
	st1.setString(3,q3);
	st1.setString(4,q4);
	st1.setString(5,q5);
	st1.setString(6,q6);
	st1.setString(7,q7); 
	st1.setString(8,q8);
	st1.setString(9,q9);
	st1.setString(10,q10);
	st1.setString(11,comment);
	st1.executeUpdate();
	st1.close();	
}
else
{
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery("SELECT ORADDMAN.CUST_COLLECT_QUEST_S.nextval FROM dual ");  
	if (rs.next())
	{
	   id = rs.getString(1);
	}
	rs.close();
	statement.close();
			
	sql =" Insert into ORADDMAN.CUST_COLLECT_QUESTIONNAIRE(id, name , department , title , company , email ," +
				" telephone , fax , q1 , q2 , q3 , q4 , q5 , q6 , q7 , q8 , q9 , q10, comments ,customer_id, REGION, TERRORITY, YEAR, BIANNUAL_CODE,ORIG_ROWID) "+
				" select ?,name,department,title,company,email,telephone,fax,?,?,?,?,?,?,?,?,?,?,?,?,region,terrority,YEAR, BIANNUAL_CODE,rowid from oraddman.cust_mail where rowid='"+keycode+"'";
	//out.println("sql="+sql); 					
	PreparedStatement st1 = con.prepareStatement(sql);
	st1.setString(1,id);
	st1.setString(2,q1);
	st1.setString(3,q2);
	st1.setString(4,q3);
	st1.setString(5,q4);
	st1.setString(6,q5);
	st1.setString(7,q6);
	st1.setString(8,q7); 
	st1.setString(9,q8);
	st1.setString(10,q9);
	st1.setString(11,q10);
	st1.setString(12,comment);
	st1.setString(13,customerId);
	st1.executeUpdate();
	st1.close();	
}
rsx.close();
stx.close();


//add by Peggy 20141217,insert customer reply log
sql = " Insert into oraddman.cust_collect_questionnaire_log(year, biannual_code, region, terrority, name,company, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10,comments,creation_date, orig_rowid,remote_addr)"+
	  " select YEAR, BIANNUAL_CODE,region,terrority,name,company,?,?,?,?,?,?,?,?,?,?,?,sysdate,rowid ,? from oraddman.cust_mail where rowid=?";
PreparedStatement st1 = con.prepareStatement(sql);
st1.setString(1,q1);
st1.setString(2,q2);
st1.setString(3,q3);
st1.setString(4,q4);
st1.setString(5,q5);
st1.setString(6,q6);
st1.setString(7,q7); 
st1.setString(8,q8);
st1.setString(9,q9);
st1.setString(10,q10);
st1.setString(11,comment);
st1.setString(12,remoteAddr);
st1.setString(13,keycode);
st1.executeUpdate();
st1.close();	
	  

// 20100709 Marvie Add : fix bug
if (q1==null || q1.equals("")) q1="0";
if (q2==null || q2.equals("")) q2="0";
if (q3==null || q3.equals("")) q3="0";
if (q4==null || q4.equals("")) q4="0";
if (q5==null || q5.equals("")) q5="0";
if (q6==null || q6.equals("")) q6="0";
if (q7==null || q7.equals("")) q7="0";
if (q8==null || q8.equals("")) q8="0";
if (q9==null || q9.equals("")) q9="0";
if (q10==null || q10.equals("")) q10="0";

%>
<Script language="JavaScript">
	alert("Thanks for your cooperation!!");
	location.replace('http://www.taiwansemi.com/');  
</Script>
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
