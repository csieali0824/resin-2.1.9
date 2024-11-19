<%@ page language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean,javax.mail.*,javax.mail.internet.*"%> 
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html> 
<head>
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Verdana; color: #000000; font-size: 12px }
  P         { font-family: Verdana; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Verdana; font-size: 12px }
  TD        { font-family: Verdana; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  .style1   {font-weight:bold;color:#000000;font-size:18px;font-family:Verdana;}
  .style2   {font-family:Verdana;font-size:12px;}
  .style3   {font-family:Verdana;font-weight:bold;font-size:14px;color:#000000;}
  .style4   {color:#999999;font-family:Verdana;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setCheck(idx)
{
	for (var i = 0 ; i < document.SUBFORM.chkitem.length ; i ++)
	{
		if (i == idx)
		{
			document.SUBFORM.chkitem[i].checked=true;
		}
		else
		{
			document.SUBFORM.chkitem[i].checked=false;
		}
	}
}
function setsubmit(URL)
{
	if (document.SUBFORM.COMPANYNAME.value==null || document.SUBFORM.COMPANYNAME.value=="")
	{
		document.SUBFORM.COMPANYNAME.style.borderColor="#FF6600";
		document.SUBFORM.COMPANYNAME.style.borderStyle="solid";
		document.SUBFORM.COMPANYNAME.style.borderWidth="thin";
		return false;
	}
	if (document.SUBFORM.REQUESTER.value==null || document.SUBFORM.REQUESTER.value=="" || document.SUBFORM.REQUESTER.value.indexOf("@")<0)
	{
		document.SUBFORM.REQUESTER.style.borderColor="#FF6600";
		document.SUBFORM.REQUESTER.style.borderStyle="solid";
		document.SUBFORM.REQUESTER.style.borderWidth="thin";
		return false;
	}
	var icnt =0;
	for (var i = 0 ; i < document.SUBFORM.chkitem.length ; i ++)
	{
		if (document.SUBFORM.chkitem[i].checked==true) icnt++;
		if ((i ==1 || i == 2 || i == 3) && document.SUBFORM.chkitem[i].checked==true && (document.SUBFORM.CUSTREMARKS.value==null || document.SUBFORM.CUSTREMARKS.value==""))
		{
			document.SUBFORM.CUSTREMARKS.style.borderColor="#FF6600";
			document.SUBFORM.CUSTREMARKS.style.borderStyle="solid";
			document.SUBFORM.CUSTREMARKS.style.borderWidth="thin";
			return false;
		}
	}
	if (icnt == 0)
	{
		document.getElementById("div1").innerHTML ="Pls choose to reply item!!";
		return false;
	}
	else if (icnt >1)
	{
		document.getElementById("div1").innerHTML ="Pls choose only one item!!";
	}
	document.SUBFORM.action=URL;
 	document.SUBFORM.submit();
}
</script>
</head>
<body bgcolor="#E0E7F8">
<form name="SUBFORM"  METHOD="post" ACTION="TSCQRAProductNoticeCustReply.jsp">
<%
try
{
	String CUSTNO="",email="",remarks1="",url="";
	String formkey = request.getParameter("formkey");
	//out.println(formkey);
	String action = request.getParameter("action");
	if (action==null) action="";
	String COMPANYNAME = request.getParameter("COMPANYNAME");
	if (COMPANYNAME==null) COMPANYNAME="";
	String REQUESTER = request.getParameter("REQUESTER");
	if (REQUESTER==null) REQUESTER="";
	String REMARKS = request.getParameter("CUSTREMARKS");
	if (REMARKS==null) REMARKS="";
	String REPLIYDATE = dateBean.getYearMonthDay();
	String SOURCEPAGE = request.getParameter("SOURCEPAGE");
	if (SOURCEPAGE==null) SOURCEPAGE="";
	String iNo = request.getParameter("NO");
	if (iNo==null) iNo="";
	String KEYID = formkey.substring(0,formkey.indexOf("#"));
	String CUSTSTR = "";
	String SEQNO = "PCN"+(formkey.substring(formkey.indexOf("#")+1,formkey.lastIndexOf("+"))).replace("cid","");
	String CUST = request.getParameter("CUST");
	if (CUST==null) CUST="";
	String QNO="";
	String [] CUSTLIST = {""};
	if (formkey.endsWith("/view"))
	{
		SOURCEPAGE ="RFQ";
		CUSTSTR = formkey.substring(formkey.lastIndexOf("+")+1,formkey.lastIndexOf("/"));
		CUSTLIST = CUSTSTR.split("%");
		for (int i =0 ; i < CUSTLIST.length ; i++)
		{
			CUSTNO += ""+ (Integer.parseInt(CUSTLIST[i]) / (12 * (i+1)));
		}
	}
	String CHKLIST="",sql="";
	
	try
	{
		sql = " SELECT distinct to_char(to_date(pcn_end_date,'yyyymmdd'),'yyyy/mm/dd') deadline, trunc(sysdate)-to_date(pcn_end_date,'yyyymmdd') days,a.pcn_number,nvl(c.customer_name,b.cust_short_name) customer_name ,c.REMARKS ,c.REQUESTER_EMAIL,c.CHOOSE_ITEM_NO from oraddman.tsqra_pcn_item_header a,oraddman.tsqra_pcn_item_detail b,"+
		      "(select pcn_number,customer_name,REMARKS ,REQUESTER_EMAIL,CHOOSE_ITEM_NO from oraddman.tsqra_pcn_reply_info y where role_name=? ) c"+
			  " where a.rowid=? and a.pcn_number=? and b.source_type=?"+
			  " and a.pcn_number= b.pcn_number and b.cust_short_name=c.customer_name(+) and b.pcn_number=c.pcn_number(+) ";
		if (SOURCEPAGE.equals("RFQ")) sql += " and EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid='"+CUST+"' and x.CUST_SHORT_NAME=b.CUST_short_NAME)";
		//out.println(sql);
		//out.println(KEYID);
		//out.println(SEQNO);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,"CUSTOMER");
		statement1.setString(2,KEYID);
		statement1.setString(3,SEQNO);
		statement1.setString(4,"1");
		//out.println(KEYID);
		//out.println(SEQNO);
		//out.println(CUSTNO);
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{
			out.println("<input type='hidden' name='QNO' value='"+SEQNO+"'>");
			out.println("<input type='hidden' name='deadline' value='"+rs1.getString("deadline")+"'>");
			if (rs1.getInt(2) > 0)
			{
%>
			<Script language="JavaScript">
				alert(document.SUBFORM.QNO.value+" of customer questionnaire end on "+ document.SUBFORM.deadline.value +" and thanks for your cooperation!!");
				location.replace('http://www.taiwansemi.com/');  
			</Script>
<%			
			}		
			QNO = rs1.getString("pcn_number");
			if (!action.equals("s") && SOURCEPAGE.equals("RFQ"))
			{
				REMARKS = rs1.getString("REMARKS");
				if (REMARKS==null) REMARKS="";
				COMPANYNAME = rs1.getString("customer_name");
				REQUESTER = rs1.getString("REQUESTER_EMAIL");
				if (REQUESTER==null) REQUESTER="";
				CHKLIST = rs1.getString("CHOOSE_ITEM_NO");
			}
		}
		else
		{
%>
		<Script language="JavaScript">
			alert("PCN number value is invalid!!");
			location.replace("http://www.taiwansemi.com/"); 
		</Script>
<%		
		}
		rs1.close();
		statement1.close();
		
		if (action.equals("s"))
		{
			String CHKITEM []= request.getParameterValues("chkitem");
			for (int m =0 ; m < CHKITEM.length ; m++)
			{
				if (CHKLIST.length() >0) CHKLIST += ",";
				CHKLIST += CHKITEM[m];
				//out.println(CHKLIST);
			}
		
			sql = " select 1 from  oraddman.tsqra_pcn_reply_info a where role_name=? and pcn_number=? and EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid=? and x.CUST_SHORT_NAME=a.CUSTOMER_NAME)";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,"CUSTOMER");
			statement.setString(2,SEQNO);
			statement.setString(3,CUST);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				sql = " update oraddman.tsqra_pcn_reply_info"+
					  " set  remarks=?"+
					  ",requester_email=?"+
					  ",customer_name=?"+
					  ",last_update_date=SYSDATE"+
					  ",last_updated_by=?"+
					  ",choose_item_no=?"+
					  " where pcn_number=?"+
					  " and role_name=?"+
				      " and EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid=? AND  x.CUST_SHORT_NAME=a.CUSTOMER_NAME)";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,REMARKS);
				pstmtDt.setString(2,REQUESTER);
				pstmtDt.setString(3,COMPANYNAME);
				pstmtDt.setString(4,REQUESTER.substring(0,REQUESTER.indexOf("@")));
				pstmtDt.setString(5,CHKLIST);
				pstmtDt.setString(6,SEQNO);
				pstmtDt.setString(7,"CUSTOMER");
				pstmtDt.setString(8,CUST);
				pstmtDt.executeUpdate();
				pstmtDt.close();
			}
			else
			{
				sql = " insert into oraddman.tsqra_pcn_reply_info(pcn_number, customer_name, role_name,remarks, requester_email, creation_date, created_by,last_update_date, last_updated_by, choose_item_no) "+
			          " select pcn_number,CUST_SHORT_NAME,?,?,?,sysdate,?,sysdate,?,? from oraddman.tsqra_pcn_item_detail x where pcn_number =? and rowid=? ";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"CUSTOMER");
				pstmtDt.setString(2,REMARKS);
				pstmtDt.setString(3,REQUESTER);
				pstmtDt.setString(4,REQUESTER.substring(0,REQUESTER.indexOf("@")));
				pstmtDt.setString(5,REQUESTER.substring(0,REQUESTER.indexOf("@")));
				pstmtDt.setString(6,CHKLIST);
				pstmtDt.setString(7,SEQNO);
				pstmtDt.setString(8,CUST);
				pstmtDt.executeUpdate();
				pstmtDt.close();
			}
			rs.close();
			statement.close();	
			
			sql = " insert into oraddman.tsqra_pcn_reply_info_his(pcn_number,  customer_name, role_name,remarks, requester_email, creation_date, created_by, choose_item_no) "+
		          " select pcn_number,CUST_SHORT_NAME,?,?,?,sysdate,?,? from oraddman.tsqra_pcn_item_detail x where pcn_number =? and rowid=? ";
			//out.println(sql);
			PreparedStatement pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.setString(1,"CUSTOMER");
			pstmtDt1.setString(2,REMARKS);
			pstmtDt1.setString(3,REQUESTER);
			pstmtDt1.setString(4,REQUESTER.substring(0,REQUESTER.indexOf("@")));
			pstmtDt1.setString(5,CHKLIST);
			pstmtDt1.setString(6,SEQNO);
			pstmtDt1.setString(7,CUST);
			pstmtDt1.executeUpdate();
			pstmtDt1.close();
			
			sql = " update  oraddman.tsqra_pcn_item_detail "+
			      " set STATUS=(SELECT RESULT FROM oraddman.tsqra_pcn_reply_item WHERE ITEM_NO=?)"+
			      " WHERE PCN_NUMBER=?"+
				  " AND CUST_SHORT_NAME=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,CHKLIST);
			pstmtDt.setString(2,SEQNO);
			pstmtDt.setString(3,COMPANYNAME);
			pstmtDt.executeUpdate();
			pstmtDt.close();
			
			
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				email ="peggy.chen@ts.com.tw,owen.wang@ts.com.tw";
				remarks1="(This is a test letter, please ignore it)";
				url="http://rfq.ts.com.tw:8080/oradds/jsp/TSCQRAProductNoticeQuery.jsp?QNO="+SEQNO+"&GROUPBY=2&QTRANS=Q";
			}
			else
			{
				remarks1="";
				email ="";
				url="http://tsrfq.ts.com.tw:8080/oradds/jsp/TSCQRAProductNoticeQuery.jsp?QNO="+SEQNO+"&GROUPBY=2&QTRANS=Q";
				sql = " select distinct  EMAIL"+
					  " from (select EMAIL from oraddman.tsqra_contact_window_mail a"+
					  " where ROLE_NAME in ('HQ_QRA','HQ_MARKETING')"+
					  " UNION ALL"+
					  " SELECT EMAIL from oraddman.tsqra_contact_window_mail a"+
					  " WHERE (ROLE_NAME ='FACTORY_QC' and exists (select 1  FROM oraddman.tsqra_pcn_item_header b where b.PCN_NUMBER=? AND b.APPLY_ORG_ID=a.territory))"+
					  " UNION ALL"+
					  " SELECT EMAIL from oraddman.tsqra_contact_window_mail a"+
					  " WHERE (ROLE_NAME ='WW_FAE' and exists (select 1  FROM oraddman.tsqra_pcn_item_detail b where b.PCN_NUMBER=? AND b.territory=a.territory)"+
					  " UNION ALL"+
					  " SELECT EMAIL from oraddman.tsqra_contact_window_mail a"+
					  " WHERE (ROLE_NAME ='HQ_SALES' and exists (select 1  FROM oraddman.tsqra_pcn_item_detail b where b.PCN_NUMBER=? AND b.territory=a.territory))";
				PreparedStatement statement3 = con.prepareStatement(sql);
				statement3.setString(1,SEQNO);
				ResultSet rs3=statement.executeQuery();
				while (rs3.next())
				{
					if (email.length() >0) email +=",";
					email += rs3.getString(1);
				}			
				rs3.close();
				statement3.close();
			}
			
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
		
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			javax.mail.internet.InternetAddress from = new javax.mail.internet.InternetAddress("hqsys@ts.com.tw");
			//javax.mail.internet.InternetAddress to=new javax.mail.internet.InternetAddress(email);
			javax.mail.internet.InternetAddress bcc=new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw");

			message.setSentDate(new java.util.Date());
			message.setFrom(from);
			String [] mailList = email.split(",");
			for (int g=0 ; g < mailList.length ; g++)
			{
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(mailList[g].toString()));			
			}
			message.addRecipient(Message.RecipientType.BCC, bcc);
			
			String sitem = ((String [])request.getParameterValues("chkitem"))[0];
			String subject ="",detail="";
			if (sitem.equals("Q1"))
			{
				subject = SEQNO + " Notice - Customer : "+COMPANYNAME+" has agreed"+remarks1;
				detail= "Dear All:<p>Please be noted that "+SEQNO+" has agreed by "+COMPANYNAME+" if you would like to know more details please click line route to "+url;
			}
			else if (sitem.equals("Q2"))
			{
				subject = SEQNO + " Notice - Customer : "+COMPANYNAME+" has objected"+remarks1;
				detail= "Dear All:<p>Please be noted that "+SEQNO+" has objected by "+COMPANYNAME+" if you would like to know more details please click line route to "+url;
			}
			else
			{
				subject = SEQNO + " Notice - Customer : "+COMPANYNAME+" has required"+remarks1;
				detail= "Dear All:<p>Please be noted that "+SEQNO+" has required by "+COMPANYNAME+" if you would like to know more details please click line route to "+url;
			}
			
			message.setSubject(subject);
			message.setContent("<font style='font-size:14px;font-family:Tahoma;'>"+detail+"<p><p><p><p><p><p><p><p>~~~ This message is automatically sent, do not reply directly to this email. Thank you for your cooperation. ~~</font>","text/html;charset=UTF-8");
			Transport.send(message);			
		}
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
%>
	<table align="center" width="60%" border="1" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="1"n bgcolor="#FFFFFF">
					<tr>
						<td width="100%" class="style1">TSC form Customer reply to <%=QNO%></td>
					</tr>
					<tr>
						<td><br><font color="#FF6600">* Required</font></td>
					</tr>
					<tr>
						<td><div id="div1" style="color:#FF6600"></div>
						<%
							sql = " SELECT a.item_no, a.item_name ,a.result FROM oraddman.tsqra_pcn_reply_item a where STATUS='A' ORDER BY ITEM_NO";
							Statement statement1=con.createStatement();
							ResultSet rs1=statement1.executeQuery(sql);
							String strchk="";
							int m=0;
							while (rs1.next())
							{
								strchk="";
								if ((","+CHKLIST+",").indexOf(","+rs1.getString("item_no")+",")>=0)
								{
									strchk = "CHECKED";
								}
								out.println("<BR><input type='checkbox' class='style2' name='chkitem' value='"+rs1.getString("item_no")+"' "+strchk+" onClick='setCheck("+m+")'><font class='style2'>"+rs1.getString("item_name")+"</font><input type='hidden' name='"+rs1.getString("item_no")+"' value='"+rs1.getString("item_name")+"'><input type='hidden' name='RESULT_"+rs1.getString("item_no")+"' value='"+rs1.getString("RESULT")+"'>");
								m++;
							}
							rs1.close();
							statement1.close();
						%>
						</td>
					</tr>
					<tr>
						<td><font class="style3"><br>Remarks:</font><br>
						<textarea cols="70" rows="6" name="CUSTREMARKS" class="style2"><%=REMARKS%></textarea>
						<input type="hidden" name="CUST" value="<%=CUST%>">
						<input type="hidden" name="REPLIYDATE" VALUE="<%=REPLIYDATE%>">
						<input type="hidden" name="NO" VALUE="<%=iNo%>">
						</td>
					</tr>
					<tr>
						<td><br><font class="style3">Company Name:</font><font color="#FF6600"> *</font><br>
						<font class="style4">Pls fill in then full company name</font><br>
						<input type="text" name="COMPANYNAME" class="style2" value="<%=COMPANYNAME%>" size="70">
						</td>
					</tr>
					<tr>
						<td><br><font class="style3">Requester:</font><font color="#FF6600"> *</font><br>
						<font class="style4">Pls add your full mail address</font><br>
						<input type="text" name="REQUESTER" class="style2" value="<%=REQUESTER%>" size="70">
						</td>
					</tr>
					<tr>
						<td><br><br><input type="button" name="save" class="style2" value="Submit" onClick="setsubmit('../jsp/TSCQRAProductNoticeCustReply.jsp?formkey=<%=java.net.URLEncoder.encode(formkey)%>&action=s');"></td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>		
<input type="hidden" name="SOURCEPAGE" value="<%=SOURCEPAGE%>">
</form>
<%
	if (action.equals("s"))
	{
%>
		<Script language="JavaScript">
			if (document.SUBFORM.SOURCEPAGE.value=="RFQ")
			{
				var CUST_NOTICE = "";
				var STATUS = "";
				for (var i = 0 ; i < document.SUBFORM.chkitem.length ; i ++)
				{
					if (document.SUBFORM.chkitem[i].checked==true)
					{
						CUST_NOTICE += document.SUBFORM.elements[document.SUBFORM.chkitem[i].value].value+"<br>";
						STATUS= document.SUBFORM.elements["RESULT_"+document.SUBFORM.chkitem[i].value].value;
					}
				}
				if (document.SUBFORM.CUSTREMARKS.value.length>0) CUST_NOTICE += "<font style='font-weight:bold'>Remarks:</font><br>"+document.SUBFORM.CUSTREMARKS.value;
				CUST_NOTICE += ("<br><font style='font-weight:bold'>Replied on </font><font style='color:blue;font-weight:bold'>"+document.SUBFORM.REPLIYDATE.value+"</font><font style='font-weight:bold'> by "+document.SUBFORM.REQUESTER.value.substr(0,document.SUBFORM.REQUESTER.value.indexOf("@"))+"</font>");
				window.opener.document.getElementById("DIV_CUST_"+document.SUBFORM.NO.value).innerHTML = CUST_NOTICE;
				window.opener.document.getElementById("STATUS_"+document.SUBFORM.NO.value).innerHTML = STATUS;
				this.window.close(); 
			}
			else
			{
				alert("Thanks for your answer!!");
				location.replace('http://www.taiwansemi.com/');  
			}
		</Script>
<%
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>