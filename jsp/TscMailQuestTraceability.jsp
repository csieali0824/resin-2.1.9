<!-- 20180628 Peggy,add new column =customer group-->
<%@ page contentType="text/html; charset=utf-8"  pageEncoding="big5"  language="java" import="java.sql.*,java.util.*,javax.mail.*,javax.mail.internet.*"%>
<%@ page import="java.io.*,DateBean,ArrayComboBoxBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %> 
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>
</title>
<script language="JavaScript" type="text/JavaScript">
</script>
</head>
<%
String deadline = request.getParameter("DEADLINE");
if (deadline==null) deadline="";  
String sid = request.getParameter("ID");
if (sid==null) sid="";
String s_yearmon = request.getParameter("SYEAR");
if ( s_yearmon==null)  s_yearmon="";
String keycode="",id= "", name= "", email= "", title= "", department= "", telephone= "", fax= "", company= "", region= "",terrority = "",status="",dealline_date="",sales_deadline_date="",trace_deadline_date="",cust_id="";
int upload_cnt =0,m=0;
String httl="",sql ="",sName = "",sEmail="",sDept="",sTitle="",sCompany="",sTele="",sFax="",sRegion="",sTerrority,sLanguage="",sales="",salesManager="",hqSales="",	sales_email = "",manager_email="",hq_email ="",s_year="",s_month="";
String reqURL = request.getRequestURL().toString();
if (reqURL != null) reqURL = reqURL.substring(0,reqURL.lastIndexOf("/")+1);

%>
<body>
<FORM ACTION="../jsp/TscMailQuestTraceability.jsp" METHOD="post" NAME="MYFORM">
<%	
try
{ 
	sql = " select a.*"+
	      ",c.sales_email"+
		  ",c.sales_manager_email"+
		  ",c.hq_sales_email"+
		  ",c.deadline"+
		  ",c.rowid"+
	      ",to_char(add_months(to_date(c.deadline,'yyyymmdd'),1)+10,'yyyy/mm/dd') sales_deadline"+
		  ",to_char(to_date(c.deadline,'yyyymmdd')+60,'Month', 'nls_date_language=American') trace_deadline"+
          " from oraddman.cust_collect_questionnaire a"+
		  ",oraddman.cust_mail c"+
          " where 1=1";
	if (!sid.equals(""))
	{
		sql += " and a.id = '"+ sid+"' and a.YEAR || a.BIANNUAL_CODE='"+s_yearmon+"'";
	}
	else
	{
		sql += " and to_date(a.YEAR || a.BIANNUAL_CODE||'01','yyyymmdd') <= TRUNC(sysdate)";
	}
    sql += " and a.CUSTOMER_ID=c.ID"+
          " and a.YEAR=c.YEAR"+
          " and a.BIANNUAL_CODE=c.BIANNUAL_CODE"+
          " and trunc(sysdate-30) <= to_date(c.deadline,'yyyymmdd')"+
		  " and c.ACTIVE_FLAG='Y'"+
		  " and (NVL(a.Q1,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q1'),0,5)) <3 "+
          " or NVL(a.Q2,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q2'),0,5)) <3 "+
          " or NVL(a.Q3,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q3'),0,5)) <3 "+
          " or NVL(a.Q4,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q4'),0,5)) <3 "+
          " or NVL(a.Q5,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q5'),0,5)) <3 "+
          " or NVL(a.Q6,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q6'),0,5)) <3 "+
          " or NVL(a.Q7,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q7'),0,5)) <3 "+
          " or NVL(a.Q8,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q8'),0,5)) <3 "+
          " or NVL(a.Q9,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q9'),0,5)) <3 "+
          " or NVL(a.Q10,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q10'),0,5)) <3 ";
		  //" and (NVL(a.Q1,0) <3 "+
          //" or NVL(a.Q2,0) <3 "+
          //" or NVL(a.Q3,0) <3 "+
          //" or NVL(a.Q4,0) <3 "+
          //" or NVL(a.Q5,0) <3 "+
          //" or NVL(a.Q6,0) <3 "+
          //" or NVL(a.Q7,0) <3 "+
          //" or NVL(a.Q8,0) <3 "+
          //" or NVL(a.Q9,0) <3 "+
          //" or NVL(a.Q10,0) <3 ";
	if (!sid.equals(""))
	{		
		sql += " or a.comments is not null";
	}
	sql += ") "+
          " and not exists (select 1 from oraddman.cust_questionnaire_trace b "+
          "                 where b.customer_id=a.id"+
          "                 and b.year=a.year"+
          "                 and b.biannual_code=a.biannual_code"+
          //"                 and (b.question_no IN (CASE WHEN NVL( a.Q1,0)<3 THEN 'Q1' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q2,0)<3 THEN 'Q2' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q3,0)<3 THEN 'Q3' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q4,0)<3 THEN 'Q4' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q5,0)<3 THEN 'Q5' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q6,0)<3 THEN 'Q6' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q7,0)<3 THEN 'Q7' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q8,0)<3 THEN 'Q8' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q9,0)<3 THEN 'Q9' ELSE b.question_no END"+
          //"                                       ,CASE WHEN NVL( a.Q10,0)<3 THEN 'Q10' ELSE b.question_no END)"+
          "                 and (b.question_no IN (CASE WHEN NVL( a.Q1,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q1'),0,5))<3 THEN 'Q1' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q2,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q2'),0,5))<3 THEN 'Q2' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q3,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q3'),0,5))<3 THEN 'Q3' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q4,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q4'),0,5))<3 THEN 'Q4' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q5,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q5'),0,5))<3 THEN 'Q5' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q6,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q6'),0,5))<3 THEN 'Q6' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q7,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q7'),0,5))<3 THEN 'Q7' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q8,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q8'),0,5))<3 THEN 'Q8' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q9,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q9'),0,5))<3 THEN 'Q9' ELSE b.question_no END"+
          "                                       ,CASE WHEN NVL( a.Q10,NVL2((select x.quest_code from oraddman.cust_questionnaire_type x where x.customer_group=c.customer_group and x.quest_code='Q10'),0,5))<3 THEN 'Q10' ELSE b.question_no END)"+
          "                     )"+
          "                  )";
	//out.println(sql);
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	int seq=0;
	while(rs.next())
	{
		seq++;
		keycode = rs.getString("ROWID");
		cust_id= rs.getString("CUSTOMER_ID");
		id= rs.getString("id");
		name= rs.getString("NAME");
		email= rs.getString("EMAIL");
		title= rs.getString("TITLE");
		if (title == null) title = "";
		department= rs.getString("DEPARTMENT");
		if (department == null) department = "";
		telephone= rs.getString("TELEPHONE");
		if (telephone==null) telephone = "";
		fax= rs.getString("FAX");
		if (fax == null) fax = "";
		company= rs.getString("COMPANY");
		if (company == null) company = "";
		region = rs.getString("REGION");
		if (region == null) region ="";
		terrority = rs.getString("TERRORITY");
		if (terrority == null) terrority="";
		sales_email = rs.getString("SALES_EMAIL");
		manager_email = rs.getString("SALES_MANAGER_EMAIL");
		hq_email =rs.getString("HQ_SALES_EMAIL");
		dealline_date =rs.getString("DEADLINE");
		sales_deadline_date = rs.getString("sales_deadline");
		trace_deadline_date = rs.getString("trace_deadline");
		s_year = rs.getString("year");
		s_month = rs.getString("BIANNUAL_CODE");
		dealline_date = dealline_date.substring(0,4)+"/"+dealline_date.substring(4,6)+"/"+dealline_date.substring(6,8);

		%>
			<%@ include file="/jsp/TscMailQuestTraceabilityBody.jsp"%>
		<%
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
	
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		javax.mail.internet.InternetAddress from = new javax.mail.internet.InternetAddress("salescss@ts.com.tw");
		message.setFrom(from);
		if (reqURL.toLowerCase().indexOf("tsrfq.") >=0 || reqURL.toLowerCase().indexOf("rfq134.") >=0 ||reqURL.toLowerCase().indexOf("10.0.1.135") >=0 ||reqURL.toLowerCase().indexOf("10.0.1.134") >=0 ) //正式環境
		{
			//if (reqURL.toLowerCase().indexOf("10.0.3.16") >=0 || reqURL.toLowerCase().indexOf("rfq.") >=0)
			//{		
			//	sales_email="peggy_chen@ts.com.tw;";
			//}
			if (sales_email != null)
			{
				String mail_to_list [] = (sales_email.replace(";",",")).split(",");
				for (m = 0 ; m < mail_to_list.length ; m++)
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(mail_to_list[m].trim()));
				}	
			}
			//if (reqURL.toLowerCase().indexOf("10.0.3.16") >=0 || reqURL.toLowerCase().indexOf("rfq.") >=0)
			//{		
			//	manager_email="peggy_chen@ts.com.tw";
			//	hq_email="angelawu@ts.com.tw;";
			//}
			String mail_cc_list []= (((manager_email==null?"":manager_email)+(hq_email==null?"":";"+hq_email)).replace(";",",")).split(",");
			for (m = 0 ; m < mail_cc_list.length ; m++)
			{
				if (mail_cc_list[m].trim()==null || mail_cc_list[m].trim().equals("")) continue;
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress(mail_cc_list[m].trim()));
			}
		}					
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("claire.chen@ts.com.tw")); 
		
		message.setSubject("====== Taiwan Semi Customer Questionnaire Dissatisfaction Follow up ======");
		message.setContent(httl,"text/html;charset=UTF-8");
		Transport.send(message);
	}
	rs.close();
	st.close();
}
catch(MessagingException e)
{ 
	out.println(e.toString()); 
}
%>
<script language="JavaScript" type="text/JavaScript">
this.window.close();
</script>
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
 