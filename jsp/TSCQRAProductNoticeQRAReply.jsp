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
function setsubmit(URL)
{
	if (document.SUBFORM.REPLIER.value==null || document.SUBFORM.REPLIER.value=="")
	{
		document.SUBFORM.REPLIER.style.borderColor="#FF6600";
		document.SUBFORM.REPLIER.style.borderStyle="solid";
		document.SUBFORM.REPLIER.style.borderWidth="thin";
		return false;
	}
	if (document.SUBFORM.ANSWER.value==null || document.SUBFORM.ANSWER.value=="")
	{
		document.SUBFORM.ANSWER.style.borderColor="#FF6600";
		document.SUBFORM.ANSWER.style.borderStyle="solid";
		document.SUBFORM.ANSWER.style.borderWidth="thin";
		return false;
	}
	document.SUBFORM.action=URL;
 	document.SUBFORM.submit();
}

</script>
</head>
<%
String ITEMLIST="",DateNoFound="",sql="",email="",remarks1="",url="";
String formkey = request.getParameter("formkey");
String action = request.getParameter("action");
if (action==null) action="";
String KEYID = formkey.substring(0,formkey.indexOf("#"));
String CUSTSTR = formkey.substring(formkey.lastIndexOf("+")+1,formkey.lastIndexOf("/"));
String SEQNO = "PCN"+(formkey.substring(formkey.indexOf("#")+1,formkey.lastIndexOf("+"))).replace("id","");
String QNO="";
String CUSTNO="";
String numid="3285017";
String [] CUSTLIST = CUSTSTR.split("%");
for (int i =0 ; i < CUSTLIST.length ; i++)
{
	CUSTNO += ""+ (Integer.parseInt(CUSTLIST[i]) / (14 * (i+1)));
}
if (CUSTNO==null || !CUSTNO.equals(numid)) DateNoFound="Y";
//out.println(CUSTNO);
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REPLIER = request.getParameter("REPLIER");
if (REPLIER==null) REPLIER="";
String ANSWER = request.getParameter("ANSWER");
if (ANSWER==null) ANSWER="";
String iNo = request.getParameter("NO");
if (iNo==null) iNo="";
String EMAILLIST = request.getParameter("EMAILLIST");
if (EMAILLIST==null) EMAILLIST="";
String REPLIYDATE = dateBean.getYearMonthDay();

try
{
	if (action.equals("s"))
	{
		sql = " select 1 from  oraddman.tsqra_pcn_reply_info a where role_name=?  and pcn_number=? and EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid=? and x.CUST_SHORT_NAME=a.CUSTOMER_NAME)";
		//out.println(sql);
		//out.println(SEQNO);
		//out.println(CUST);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"HQ");
		statement.setString(2,SEQNO);
		statement.setString(3,CUST);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
		 	sql = " update oraddman.tsqra_pcn_reply_info a"+
			      " set  remarks=?"+
				  ",last_update_date=SYSDATE"+
				  ",last_updated_by=?"+
				  ",OWNER_EMAIL_LIST=?"+
				  " where pcn_number=?"+
				  " and role_name=?"+
				  " and EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid=? AND  x.CUST_SHORT_NAME=a.CUSTOMER_NAME)";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ANSWER);
			pstmtDt.setString(2,REPLIER);
			pstmtDt.setString(3,EMAILLIST);
			pstmtDt.setString(4,SEQNO);
			pstmtDt.setString(5,"HQ");
			pstmtDt.setString(6,CUST);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
		else
		{
		 	sql = " insert into oraddman.tsqra_pcn_reply_info(pcn_number,  customer_name, role_name,remarks, requester_email, creation_date, created_by,last_update_date, last_updated_by, choose_item_no,OWNER_EMAIL_LIST) "+
		          " select pcn_number,CUST_SHORT_NAME,?,?,?,sysdate,?,sysdate,?,?,? from oraddman.tsqra_pcn_item_detail x where pcn_number =? and rowid=? ";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"HQ");
			pstmtDt.setString(2,ANSWER);
			pstmtDt.setString(3,"");
			pstmtDt.setString(4,REPLIER);
			pstmtDt.setString(5,REPLIER);
			pstmtDt.setString(6,"");
			pstmtDt.setString(7,EMAILLIST);
			pstmtDt.setString(8,SEQNO);
			pstmtDt.setString(9,CUST);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
		rs.close();
		statement.close();	
		
		sql = " insert into oraddman.tsqra_pcn_reply_info_his(pcn_number, customer_name, role_name,remarks, requester_email, creation_date, created_by, choose_item_no,OWNER_EMAIL_LIST) "+
		      " select pcn_number,CUST_SHORT_NAME,?,?,?,sysdate,?,?,? from oraddman.tsqra_pcn_item_detail x where pcn_number =? and rowid=? ";
		//out.println(sql);
		PreparedStatement pstmtDt1=con.prepareStatement(sql);  
		pstmtDt1.setString(1,"HQ");
		pstmtDt1.setString(2,ANSWER);
		pstmtDt1.setString(3,"");
		pstmtDt1.setString(4,REPLIER);
		pstmtDt1.setString(5,"");
		pstmtDt1.setString(6,EMAILLIST);
		pstmtDt1.setString(7,SEQNO);
		pstmtDt1.setString(8,CUST);
		pstmtDt1.executeUpdate();
		pstmtDt1.close();

		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks1="(This is a test letter, please ignore it)";
			url="http://rfq.ts.com.tw:8080/oradds/jsp/TSCQRAProductNoticeQuery.jsp?QNO="+SEQNO+"&GROUPBY=2&QTRANS=Q";
		}
		else
		{
			remarks1="";
			url="http://tsrfq.ts.com.tw:8080/oradds/jsp/TSCQRAProductNoticeQuery.jsp?QNO="+SEQNO+"&GROUPBY=2&QTRANS=Q";
		}
		
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
	
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		javax.mail.internet.InternetAddress from = new javax.mail.internet.InternetAddress("hqsys@ts.com.tw");
		javax.mail.internet.InternetAddress bcc=new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw");

		message.setSentDate(new java.util.Date());
		message.setFrom(from);
		String [] emaillist= (EMAILLIST.replace("\n",",").replace(";",",")).split(",");
		for(int g=0;g<emaillist.length;g++)
		{
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(emaillist[g].trim()));
		}
		message.addRecipient(Message.RecipientType.BCC, bcc);
		
		String subject ="",detail="";
		subject = SEQNO + " Notice - "+REPLIER+" has replied"+remarks1;
		detail= "Dear All:<p>Please be noted that "+SEQNO+" has replied by "+REPLIER+" if you would like to know more details please click line route to "+url;
		message.setSubject(subject);
		message.setContent("<font style='font-size:14px;font-family:Tahoma;'>"+detail+"<p><p><p><p><p><p><p><p>~~~ This message is automatically sent, do not reply directly to this email. Thank you for your cooperation. ~~</font>","text/html;charset=UTF-8");
		Transport.send(message);			
	}
	else
	{

		sql = " SELECT distinct a.pcn_number,nvl(c.customer_name,b.cust_short_name) customer_name ,c.REMARKS ,c.REQUESTER_EMAIL,c.CHOOSE_ITEM_NO from oraddman.tsqra_pcn_item_header a,oraddman.tsqra_pcn_item_detail b,(select pcn_number,customer_name,REMARKS ,REQUESTER_EMAIL,CHOOSE_ITEM_NO from oraddman.tsqra_pcn_reply_info where role_name=?) c "+
			  " where a.rowid=? and b.ROWID=? and a.pcn_number=?"+
			  " and a.pcn_number= b.pcn_number and b.CUST_SHORT_NAME=c.customer_name(+) and b.pcn_number=c.pcn_number(+) ";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"HQ");
		statement.setString(2,KEYID);
		statement.setString(3,CUST);
		statement.setString(4,SEQNO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			QNO = rs.getString("pcn_number");
			ANSWER = rs.getString("REMARKS");
			if (ANSWER==null) ANSWER="";
			//CUST = rs.getString("customer_name");
		}
		rs.close();
		statement.close();	
	}
}
catch(Exception e)
{
	DateNoFound = "Y";	
	out.println(e.getMessage());
}

if (DateNoFound.equals("Y"))
{
%>
	<Script language="JavaScript">
		alert("PCN number value is invalid!!");
		location.replace("http://www.taiwansemi.com/"); 
	</Script>
<%
}
%>
<body bgcolor="#EFF4DD">
<form name="SUBFORM"  METHOD="post" ACTION="TSCQRAProductNoticeQRAReply.jsp">
	<table align="center" width="60%" border="1" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="1"n bgcolor="#FFFFFF">
					<tr>
						<td width="100%" class="style1">TSC form Sales reply to <%=QNO%></td>
					</tr>
					<tr>
						<td><br><font class="style3">Replier:</font><font color="#FF6600"> *</font><br>
						<input type="text" name="REPLIER" class="style2" value="<%=REPLIER%>" size="30">
						<input type="hidden" name="CUST" value="<%=CUST%>">
						<input type="hidden" name="REPLIYDATE" VALUE="<%=REPLIYDATE%>">
						<input type="hidden" name="NO" VALUE="<%=iNo%>">
						</td>
					</tr>
					<tr>
						<td><font class="style3"><br>Answer:</font><br>
						<textarea cols="70" rows="12" name="ANSWER" class="style2"><%=ANSWER%></textarea>
						</td>
					</tr>
					<tr>
						<td><font class="style3"><br>Responsible Person Mail:</font><br>
						<textarea cols="70" rows="6" name="EMAILLIST" class="style2"><%=EMAILLIST%></textarea>
						</td>
					</tr>
					<tr>
						<td><br><br><input type="button" name="save" class="style2" value="Submit" onClick="setsubmit('../jsp/TSCQRAProductNoticeQRAReply.jsp?formkey=<%=java.net.URLEncoder.encode(formkey)%>&action=s');"></td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>		
</form>
<%
if (action.equals("s"))
{
%>
	<Script language="JavaScript">
		var HQ_NOTICE = "";
		if (document.SUBFORM.ANSWER.value.length>0) HQ_NOTICE += document.SUBFORM.ANSWER.value;
		HQ_NOTICE += ("<br><font style='font-weight:bold'>Replied on </font><font style='color:blue;font-weight:bold'>"+document.SUBFORM.REPLIYDATE.value+"</font><font style='font-weight:bold'> by "+document.SUBFORM.REPLIER.value+"</font>");
		window.opener.document.getElementById("DIV_HQ_"+document.SUBFORM.NO.value).innerHTML = HQ_NOTICE;
		this.window.close(); 
	</Script>
<%
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>