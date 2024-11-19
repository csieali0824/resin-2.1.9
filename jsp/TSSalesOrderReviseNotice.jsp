<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Order Revise Request Over Lead Time</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderReviseNotice.jsp" METHOD="post" name="MYFORM">
<%
int over_hours=48;
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
String sql ="",sql1="",sql2="",strcontent="",remarks="";
try  
{ 	
	sql = " SELECT A.*,b.TSC_PROD_GROUP ALENGNAME"+
		  " FROM (SELECT PLANT_CODE,TEMP_ID,SEQ_ID,REQUEST_NO,SALES_GROUP,CREATED_BY,TO_CHAR(CREATION_DATE,'yyyy/mm/dd hh24:mi') CREATION_DATE,SO_NO,LINE_NO,SOURCE_ITEM_DESC, tsc_order_revise_pkg.GET_REQ_PENDING_HOURS(A.CREATION_DATE,SYSDATE) PENDING_HOURS,b.USERMAIL FROM oraddman.tsc_om_salesorderrevise_req a,oraddman.wsuser b "+
		  " WHERE a.STATUS='AWAITING_CONFIRM'"+
		  " and a.CREATED_BY=b.USERNAME) a,oraddman.tsprod_manufactory b "+
		  " WHERE a.PENDING_HOURS>"+over_hours+
		  " and a.plant_code=b.MANUFACTORY_NO";
	sql1 = "SELECT DISTINCT PLANT_CODE FROM ("+sql+") a";
	//out.println(sql1);
	Statement state=con.createStatement();     
	ResultSet rs=state.executeQuery(sql1);
	String plantCode="";
	while (rs.next())	
	{ 
		plantCode=rs.getString("plant_code");
		
		sql2 = (sql + " and plant_code='"+plantCode+"' ORDER BY PLANT_CODE,SALES_GROUP,REQUEST_NO");
		Statement state1=con.createStatement();     
		ResultSet rs1=state1.executeQuery(sql2);
		StringBuffer sb = new StringBuffer();
		//Hashtable hashtb = new Hashtable();
		while (rs1.next())	
		{ 
			if (sb.length()==0)
			{
				sb.append("<table align='left' width='100%' border='1' bordercolorlight='#E3E3E3' bordercolordark='#CCCCFF' cellpadding='0' cellspacing='1' bgcolor='#FFFFFF'>");
				sb.append("<tr bgcolor='#CCCCCC' style='font-family:arial;font-size:12px'>");
				sb.append("<td width='12%'>Request No</td>");
				sb.append("<td width='10%'>Sales Group</td>");
				sb.append("<td width='10%'>MO#</td>");
				sb.append("<td width='5%'>Line#</td>");
				sb.append("<td width='15%'>Item Desc</td>");
				sb.append("<td width='13%'>Created By</td>");
				sb.append("<td width='15%'>Creation Date</td>");
				sb.append("<td width='10%'>Pending Hours</td>");
				sb.append("<td width='10%'>Plant Name</td>");
				sb.append("</tr>");		
			}
			sb.append("<tr style='font-family:arial;font-size:12px'>");
			sb.append("<td>"+rs1.getString("request_no")+"</td>");
			sb.append("<td>"+rs1.getString("SALES_GROUP")+"</td>");
			sb.append("<td>"+rs1.getString("SO_NO")+"</td>");
			sb.append("<td>"+rs1.getString("line_no")+"</td>");
			sb.append("<td>"+rs1.getString("SOURCE_ITEM_DESC")+"</td>");
			sb.append("<td>"+rs1.getString("CREATED_BY")+"</td>");
			sb.append("<td>"+rs1.getString("CREATION_DATE")+"</td>");
			sb.append("<td>"+rs1.getString("PENDING_HOURS")+"</td>");
			sb.append("<td>"+rs1.getString("ALENGNAME")+"</td>");
			sb.append("</tr>");
			//hashtb.put(rs1.getString("USERMAIL"),rs1.getString("USERMAIL"));			
		}
		rs1.close();
		state1.close();
		 
		if (sb.length()>0)
		{
			sb.append("</table>");
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			remarks="";
			strcontent="以下訂單申請變更已超過"+over_hours+"小時未回覆,請撥空至<a href='"+request.getRequestURL().toString().replace("TSSalesOrderReviseNotice.jsp","TSSalesOrderReviseReply.jsp")+"'>RFQ D12-002 工廠回覆訂單變更結果</a>功能進行回覆作業,謝謝!";
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				if (plantCode.equals("002"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amanda@mail.tsyew.com.cn"));
				}
				else if (plantCode.equals("005"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aggie@mail.tew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
				}
				else if (plantCode.equals("006"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("esther.yang@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tin.chang@ts.com.tw"));
				}
				else if (plantCode.equals("008"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("outsourcingpc1@mail.tew.com.cn"));
				}
				else if (plantCode.equals("010"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("may.huang@ts.com.tw"));
				}	
				else if (plantCode.equals("011"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
				}
				//if (hashtb!=null)
				//{
				//	Enumeration enkey  = hashtb.keys(); 
				//	while (enkey.hasMoreElements())   
				//	{
				//		message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress(enkey.nextElement().toString()));
				//	} 
				//}	
			}																
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			message.setHeader("Subject", MimeUtility.encodeText("Notice!!Order revise request for more than "+over_hours+" hours not yet reply"+remarks, "UTF-8", null));				
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp.setContent("<table align='left' width='80%'><tr><td style='color:#000000;font-family:細明體;font-size:15px'>"+strcontent+"</td></tr><tr><td>"+sb.toString()+"</td></tr></table>", "text/html;charset=UTF-8");
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
		}
	}		
	rs.close();
	state.close();
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

