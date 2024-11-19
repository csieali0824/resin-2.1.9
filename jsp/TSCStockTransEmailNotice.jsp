<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,java.util.*,java.text.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,oracle.sql.*,oracle.jdbc.driver.*,java.lang.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<html>
<head>
<title>TSC Stock Trans Email Notice</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCStockTransEmailNotice.jsp" METHOD="post" NAME="MYFORM">
<%
String sql ="";
try
{
	String remarks="",strSubject="",strContent="",strUrl= request.getRequestURL().toString(),strProgram="";
	strUrl=strUrl.substring(0,strUrl.lastIndexOf("/"));
	strUrl="http://rfq134.ts.com.tw:8080/oradds/jsp";
	strProgram=strUrl;
	boolean  testenv_flag=true;
	if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
	{
		testenv_flag=true;
	}
	
	Properties props = System.getProperties();
	props.put("mail.transport.protocol","smtp");
	props.put("mail.smtp.host", "mail.ts.com.tw");
	props.put("mail.smtp.port", "25");
	
	Session s = Session.getInstance(props, null);
	javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
	message.setSentDate(new java.util.Date());
	message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));		
	
	
	sql = " select a.status_code,a.req_no"+
          ",a.req_header_id"+
          ",a.wkflow_level"+
          ",b.wkflow_next_level"+
          ",c.user_name"+
          ",d.usermail"+
          ",e.usermail req_usermail"+
          ",f.trans_desc"+
          ",substr(a.wkflow_level,1,1) wkcode"+
          ",row_number() over (partition by a.req_no order by c.user_name) group_seq"+
          ",count(1) over (partition by a.req_no) group_cnt"+
		  ",(select COUNT(1) from oraddman.tsc_stock_trans_lines tstl  WHERE tstl.REQ_HEADER_ID=a.REQ_HEADER_ID and tstl.ORIG_SUBINVENTORY_CODE in (?,?) AND tstl.ORIG_ORGANIZATION_ID=?) WIP_SUBINV_CNT"+  //add by Peggy 20210713
          " from oraddman.tsc_stock_trans_headers a"+
          " ,oraddman.tsc_stock_trans_wkflow b"+
          " ,oraddman.tsc_stock_trans_member c"+
          " ,oraddman.wsuser d,oraddman.wsuser e"+
          " ,oraddman.tsc_stock_trans_type f"+
          " where a.trans_type=b.trans_type"+
          " and a.wkflow_level=b.wkflow_level"+
          " and b.trans_type=c.trans_type"+
          " and b.wkflow_next_level=c.wkflow_level"+
          " and c.user_name=d.username"+
          " and a.created_by=e.username"+
          " and a.trans_type=f.trans_type"+
          " and a.status_code in (?,?,?)"+
          " and trunc(a.last_update_date)<>trunc(sysdate)";
	PreparedStatement statement2=con.prepareStatement(sql);
	statement2.setString(1,"05");
	statement2.setString(2,"06");
	statement2.setInt(3,606);
	statement2.setString(4,"APPROVED");
	statement2.setString(5,"CONFIRMED");
	statement2.setString(6,"AWAITING_APPROVE");
	ResultSet rs2=statement2.executeQuery();
	while (rs2.next())
	{
		if (rs2.getString("group_seq").equals("1"))
		{
			message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));			
		}
		
		if (rs2.getString("status_code").equals("CONFIRMED") && rs2.getString("wkflow_next_level").substring(1,2).equals("9"))
		{
			strProgram =strUrl+"/TSCStockTransComply.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id") ;
			if (testenv_flag) //測試環境
			{
				remarks="(This is a test letter, please ignore it)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{	
				if (rs2.getString("WKFLOW_NEXT_LEVEL").equals("A99")) //add by Peggy 20210713
				{
					if (rs2.getInt("WIP_SUBINV_CNT")>0) //線邊倉
					{
						if (!rs2.getString("USER_NAME").equals("LINDA_LEE") &&  !rs2.getString("USER_NAME").equals("SHU.LEE"))
						{
							continue;
						}
					}
					else
					{
						if (rs2.getString("USER_NAME").equals("LINDA_LEE") ||  rs2.getString("USER_NAME").equals("SHU.LEE"))
						{
							continue;
						}
					}
				}			
				
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			} 
			strSubject ="Reminder - "+rs2.getString("trans_desc")+":"+rs2.getString("req_no")+" has been approved"+remarks;
			strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to comply the ERP system transactions.<br><br>p.s. login account & password with the ERP system same";
		}
		else		
		{
			//add by Peggy 20220126
			if (rs2.getString("status_code").equals("APPROVED") && rs2.getString("wkflow_next_level").substring(1,2).equals("9"))
			{
				strProgram =strUrl+"/TSCStockTransComply.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id") ;
			}
			else
			{
				strProgram =strUrl+"/TSCStockTransConfirm.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id") ;
			}
			if (testenv_flag) //測試環境
			{
				remarks="(This is a test letter, please ignore it)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{	
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			} 
			strSubject ="Reminder - "+rs2.getString("trans_desc")+":"+rs2.getString("req_no")+" is waiting for your approval"+remarks;
			strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to approve.<br><br>p.s. login account & password with the ERP system same";
		}
			
		if (rs2.getString("GROUP_SEQ").equals(rs2.getString("GROUP_CNT")))
		{
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				
			message.setSubject(strSubject, "UTF-8");
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp.setContent(strContent, "text/html;charset=UTF-8");
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);
		}
	}
	rs2.close();
	statement2.close();
				  
}
catch(Exception e)
{
	out.println(e.getMessage());
}	

%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

