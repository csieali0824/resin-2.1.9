<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.Math.*,java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,ComboBoxBean,ArrayComboBoxBean,javax.xml.parsers.*,CodeUtil,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="codeUtil" scope="page" class="CodeUtil"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style5   {font-family:Tahoma,Georgia;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
	if (document.MYFORM.TSCPARTNO.value==""
	    && document.MYFORM.WIPNO.value==""
	    && document.MYFORM.LOTNO.value==""
	    && document.MYFORM.SDATE.value==""
	    && document.MYFORM.EDATE.value==""
	    && document.MYFORM.UNLOCK_SDATE.value==""
	    && document.MYFORM.UNLOCK_EDATE.value=="")		
	{
		alert("請輸入查詢條件!");
		return false;
	}
	//else if (document.MYFORM.SDATE.value==""&& document.MYFORM.EDATE.value=="")
	//{
	//	if (!confirm("Are you sure to search data code data under no specified date?\nThis may cause the search time to be too long.."))
	//	{
	//		return false;
	//	}
	//}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setClear()
{
	document.MYFORM.TSCPARTNO.value="";
	document.MYFORM.WIPNO.value="";
	document.MYFORM.LOTNO.value="";
	document.MYFORM.SDATE.value="";
	document.MYFORM.EDATE.value="";
	document.MYFORM.check1.checked=true;
	document.MYFORM.check2.checked=false;
	document.MYFORM.check3.checked=false;
	document.MYFORM.REEL_CHK.checked=false;
	document.MYFORM.BOX_CHK.checked=false;
	document.MYFORM.CARTON_CHK.checked=false;	
}

function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i+1);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
		lineid = document.MYFORM.chk[irow-1].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		//document.MYFORM.elements["UNLOCK_REASON_"+lineid].readOnly =false;
		//document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].readOnly =false;
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["UNLOCK_REASON_"+lineid].value ="";
		document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].value ="";
		//document.MYFORM.elements["UNLOCK_REASON_"+lineid].readOnly =true;
		//document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].readOnly=true;
	}
	if (chooseCnt()==0)
	{
		document.MYFORM.btn1.disabled=true;
	}
	else
	{
		document.MYFORM.btn1.disabled=false;
	}	
}

function chkchoose(irow)
{
	var chkcnt =0;
	if ((document.MYFORM.elements["UNLOCK_REASON_"+irow].value !="" && document.MYFORM.elements["UNLOCK_REASON_"+irow].value !="--") ||  document.MYFORM.elements["UNLOCK_REMARKS_"+irow].value !="")
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#daf1a9";
		if (document.MYFORM.chk.length != undefined)
		{
			if (document.MYFORM.chk[irow-1].disabled ==false && document.MYFORM.chk[irow-1].checked==false)
			{
				document.MYFORM.chk[irow-1].checked=true;
			}
		}
		else
		{
			if (document.MYFORM.chk.checked==false)
			{
				document.MYFORM.chk.checked=true;
			}
		}	
		if (document.MYFORM.btn1.disabled==true)
		{
			document.MYFORM.btn1.disabled=false;
		}
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		if (document.MYFORM.chk.length != undefined)
		{
			if (document.MYFORM.chk[irow-1].checked==true)
			{
				document.MYFORM.chk[irow-1].checked=false;
			}
		}
		else
		{
			if (document.MYFORM.chk.checked==true)
			{
				document.MYFORM.chk.checked=false;
			}
		}	
	}
	if (chooseCnt()==0)
	{
		document.MYFORM.btn1.disabled=true;
	}
	else
	{
		document.MYFORM.btn1.disabled=false;
	}
}


function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i].checked;
			lineid = document.MYFORM.chk[i].value;
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["UNLOCK_REASON_"+lineid].value =="" || document.MYFORM.elements["UNLOCK_REASON_"+lineid].value =="--")
			{
				alert("請輸入原因!");
				document.MYFORM.elements["UNLOCK_REASON_"+lineid].focus();
				return false;			
			}	
			else if (document.MYFORM.elements["UNLOCK_REASON_"+lineid].value=="改訂單出貨")
			{
				if (document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].value==null || document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].value=="")
				{
					alert("請輸入訂單號碼!");
					document.MYFORM.elements["UNLOCK_REMARKS_"+lineid].focus();
					return false;		
				}
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.btn1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function chooseCnt()
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i].checked;
		}
		if (chkvalue==true)
		{
		 	chkcnt ++;
		}
	}
	return chkcnt;
}
</script>
</head>
<%
String QTRANS = request.getParameter("QTRANS");
if (QTRANS==null) QTRANS="";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String LOTNO = request.getParameter("LOTNO");
if (LOTNO==null) LOTNO="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String UNLOCK_EDATE = request.getParameter("UNLOCK_EDATE");
if (UNLOCK_EDATE==null) UNLOCK_EDATE="";
String UNLOCK_SDATE = request.getParameter("UNLOCK_SDATE");
if (UNLOCK_SDATE==null) UNLOCK_SDATE="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String A01_FLAG = request.getParameter("check1");
if (A01_FLAG==null) A01_FLAG="A01";
String ILANHUB_FLAG = request.getParameter("check2");
if (ILANHUB_FLAG==null) ILANHUB_FLAG="";
String TEW_FLAG = request.getParameter("check3");
if (TEW_FLAG==null) TEW_FLAG="";
String REEL_CHK = request.getParameter("REEL_CHK");
if (REEL_CHK==null) REEL_CHK="";
String BOX_CHK = request.getParameter("BOX_CHK");
if (BOX_CHK==null) BOX_CHK="";
String CARTON_CHK = request.getParameter("CARTON_CHK");
if (CARTON_CHK==null) CARTON_CHK="";
String sql ="";
%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSLabelPrintedLogQuery.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="ARIAL" size="+1">The data processing, please wait.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font size=4><strong>TS Label Printing Query/Unlock</strong></font>
<table width="100%">
	<tr>
		<td align="right">
		<A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
		</td>
	</tr>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
				<tr>
					<td width="10%"  style="background-color:#DCE6E7">Location</td>
					<td width="24%" valign="middle"><input type="checkbox" name="check1" value="A01" <%=(!A01_FLAG.equals("")?"checked":"")%>>A01 &nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="check2" value="ILANHUB" <%=(!ILANHUB_FLAG.equals("")?"checked":"")%> disabled>ILAN HUB &nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="check3" value="TEW" <%=(!TEW_FLAG.equals("")?"checked":"")%> disabled>TEW
					</td>
					<td width="10%" rowspan="4" style="background-color:#DCE6E7"><font color="#006666">WIP NO</font></td>
					<td width="12%" rowspan="4" ><textarea cols="25" rows="6" name="WIPNO" class="style5"><%=WIPNO%></textarea></td>
					<td width="10%" rowspan="4" style="background-color:#DCE6E7"><font color="#006666">LOT NO</font></td>
					<td width="12%" rowspan="4"><textarea cols="25" rows="6" name="LOTNO" class="style5"><%=LOTNO%></textarea></td>
					<td width="10%" rowspan="4" style="background-color:#DCE6E7"><font color="#006666">TSC P/N</font></td>
					<td width="12%"rowspan="4"><textarea cols="30" rows="6" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>
				</tr>
				<tr>
					<td width="10%" style="background-color:#DCE6E7">Package Type</td>
					<td><input type="checkbox" name="REEL_CHK" value="REEL" <%=(!REEL_CHK.equals("")?"checked":"")%>>Reel &nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="BOX_CHK" value="BOX" <%=(!BOX_CHK.equals("")?"checked":"")%>>Box &nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="CARTON_CHK" value="CARTON" <%=(!CARTON_CHK.equals("")?"checked":"")%>>Carton</td>
				</tr>
				<tr>
					<td width="10%" style="background-color:#DCE6E7">Printed Date</td>
					<td>  
						<input type="text" name="SDATE" class="style5" value="<%=SDATE%>" SIZE="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57">
						<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>~
						<input type="text" name="EDATE" class="style5" value="<%=EDATE%>" size="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>			      
					</td>
				</tr>
				<tr>
					<td width="10%" style="background-color:#DCE6E7">Unlock Date</td>
					<td>  
						<input type="text" name="UNLOCK_SDATE" class="style5" value="<%=UNLOCK_SDATE%>" SIZE="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57">
						<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.UNLOCK_SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>~
						<input type="text" name="UNLOCK_EDATE" class="style5" value="<%=UNLOCK_EDATE%>" size="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57">
						<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.UNLOCK_EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>			      
					</td>
				</tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" name="submit1" value="Query" style="font-family:arial" onClick='setSubmit("../jsp/TSLabelPrintedLogQuery.jsp?QTRANS=Q")'>
			&nbsp;<input type="button" name="submit2" value="Excel" style="font-family:arial;" onClick='setExportXLS("../jsp/TSLabelPrintedLogExcel.jsp")'>
			&nbsp;<input type="button" name="clear" value="Clear" style="font-family:arial" onClick="setClear()">
		</td>
	</tr>
	<tr>
		<td>
<%
try
{
	if (QTRANS.equals("UNLOCK"))
	{
		String unlock_group_id="",lot_list="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No choose any items!!");
		}
		else
		{	
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select TS_LABEL_UNLOCK_GROUP_ID_S.NEXTVAL from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				unlock_group_id= rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{		
				sql = " update oraddman.ts_label_print_log a"+
					  " set a.unlock_reason=?"+
					  ",a.unlock_reason_remarks=?"+
					  ",a.unlocked_by=?"+
					  ",a.unlock_group_id=?"+
					  " where a.lot_number=?"+
					  " and a.label_code=?"+
					  " and nvl(a.so_no,'xxx')=nvl(?,'xxx')"+
					  " and a.unlock_group_id is null";
				//out.println(request.getParameter("UNLOCK_REASON_"+chk[i]));
				//out.println(request.getParameter("UNLOCK_REMARKS_"+chk[i]));
				//out.println(request.getParameter("LOT_"+chk[i]));
				//out.println(request.getParameter("LABEL_CODE_"+chk[i]));
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("UNLOCK_REASON_"+chk[i])); 
				pstmtDt.setString(2,(request.getParameter("UNLOCK_REMARKS_"+chk[i])==null?"":request.getParameter("UNLOCK_REMARKS_"+chk[i]))); 
				pstmtDt.setString(3,UserName); 
				pstmtDt.setString(4,unlock_group_id); 
				pstmtDt.setString(5,request.getParameter("LOT_"+chk[i])); 
				pstmtDt.setString(6,request.getParameter("LABEL_CODE_"+chk[i])); 
				pstmtDt.setString(7,request.getParameter("ERPMO_"+chk[i])); 
				pstmtDt.executeQuery();
				pstmtDt.close();					  
			}
			con.commit();
			
			CallableStatement cs3 = con.prepareCall("{call TSC_MES_LABEL_PKG.JOB_INTIIAL(?,?)}");
			cs3.setString(1,unlock_group_id); 
			cs3.setString(2,UserName); 
			cs3.execute();
			cs3.close();
			QTRANS="Q";	
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
				</script>
			<%	
			//mail notice			
			/*Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			String remarks="",strSubject="",strContent="",strUrl= request.getRequestURL().toString(),strProgram="";
			strUrl=strUrl.substring(0,strUrl.lastIndexOf("/"));
			strProgram=strUrl;
			boolean  testenv_flag=false;
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				testenv_flag=true;
			}
		
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		
			if (testenv_flag) //測試環境
			{
				remarks="(This is a test letter, please ignore it)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			}
			else
			{	
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("felix.chang@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("linda_lee@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ilanpd@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ck.lin@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("shawn@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("derek@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ilanqc@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ca.chu@ts.com.tw"));  
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("may@ts.com.tw"));  
			}
			strSubject = "Hold Lot Notification for Re-label"+remarks;
			strContent = "List of hold lot as below:<br>"+lot_list;
					  
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			
			message.setSubject(strSubject, "UTF-8");
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp.setContent(strContent, "text/html;charset=UTF-8");
	
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);
			*/
			
		}
	}
	
	int rec_cnt =0;
	if (QTRANS.equals("Q"))
	{	
	%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
				<tr style="background-color:#006666;color:#ffffff;">
					<td width="7%" style="font-family:arial" align="center">WIP NO</td>
					<td width="7%"  style="font-family:arial" align="center">Lot No</td>
					<td width="6%"  style="font-family:arial">ERP MO</td>
					<td width="10%"  style="font-family:arial">TSC PartNo</td>
					<td width="5%"  style="font-family:arial">Label Type </td>
					<td width="5%"  style="font-family:arial">Label Code</td>
					<td width="6%"  style="font-family:arial">Package Type</td>
					<td width="9%"  style="font-family:arial" align="center">Printed Date</td>
					<td width="7%"  style="font-family:arial" align="center">Printed By</td>
					<td width="3%"  style="font-family:arial" align="center"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="10%"  style="font-family:arial" align="center">Unlock Reason</td>
					<td width="10%"  style="font-family:arial" align="center">Unlockl Remarks</td>
					<td width="8%"  style="font-family:arial" align="center">Unlock Date</td>
					<td width="7%"  style="font-family:arial" align="center">Unlock By</td>
				</tr>
		<%
		sql = " select x.*";
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") >=0) 
		{
			sql += ",nvl(y.CONTAINERNAME,'') hold_lot";
		}
		else
		{
			sql += ",'' hold_lot";
		}
		sql+= " from (select a.wip_no,a.lot_number,a.so_no,a.item_desc,a.date_code,d.label_group,a.label_code,c.label_type_size"+
			  "      ,to_char(a.print_date,'yyyy/mm/dd hh24:mi') print_date,a.printed_by,a.unlock_reason,a.unlock_reason_remarks"+
			  "      ,a.unlocked_by,to_char(a.unlock_date,'yyyy/mm/dd hh24:mi') unlock_date ,nvl(a.unlock_group_id,-999) unlock_group_id "+
              "      ,row_number() over (partition by a.so_no,a.lot_number,a.label_code,nvl(unlock_group_id,-999) order by a.print_date) label_code_seq"+
              "      from oraddman.ts_label_print_log a"+
			  "      ,oraddman.ts_label_all b"+
			  "      ,oraddman.ts_label_types c"+
			  "      ,oraddman.ts_label_groups d"+
              "      where a.label_code=b.label_code"+
              "      and b.label_type_code=c.label_type_code"+
              "      and b.label_group_code=d.label_group_code";
		if (!A01_FLAG.equals("") || !ILANHUB_FLAG.equals("") || !TEW_FLAG.equals(""))
		{
			sql += " and a.location in ('"+A01_FLAG+"','"+ILANHUB_FLAG+"','"+TEW_FLAG+"')";
		}
		if (!TSCPARTNO.equals(""))
		{
			String [] sArray = TSCPARTNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (";
				}
				else
				{
					sql += " or ";
				}
				sql += " upper(a.ITEM_DESC) like '"+sArray[x].trim().toUpperCase()+"%'";
				if (x==sArray.length -1) sql += ")";
			}
		}			  
		if (!WIPNO.equals(""))
		{
			String [] sArray = WIPNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.WIP_NO in ('"+sArray[x].trim()+"'";
				}
				else
				{
					sql += (",'"+sArray[x].trim()+"'");
				}
				if (x==sArray.length -1) sql += ")";
			}
		}	
		if (!LOTNO.equals(""))
		{
			String [] sArray = LOTNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.LOT_NUMBER in ('"+sArray[x].trim()+"'";
				}
				else
				{
					sql += (",'"+sArray[x].trim()+"'");
				}
				if (x==sArray.length -1) sql += ")";
			}
		}		
		if (!SDATE.equals("") || !EDATE.equals(""))
		{
			sql += " and a.PRINT_DATE between to_date(nvl('"+SDATE+"',to_char(add_months(sysdate,-24),'yyyymmdd')),'yyyymmdd') and to_date(NVL('"+EDATE+"',to_char(sysdate,'yyyymmdd')),'yyyymmdd')+0.99999";
		}	
		if (!UNLOCK_SDATE.equals("") || !UNLOCK_EDATE.equals(""))
		{
			sql += " and a.UNLOCK_DATE between to_date(nvl('"+UNLOCK_SDATE+"','"+UNLOCK_EDATE+"'),'yyyymmdd') and to_date(NVL('"+UNLOCK_EDATE+"','"+UNLOCK_SDATE+"'),'yyyymmdd')+0.99999";
		}		
		if (!REEL_CHK.equals("") || !BOX_CHK.equals("") || !CARTON_CHK.equals(""))
		{
			sql += " and c.label_type_size in ('"+REEL_CHK+"','"+BOX_CHK+"','"+CARTON_CHK+"')";
		}
		sql += " ) x ";
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") >=0) 
		{
			sql += ",INSITEA01_ODS.TSC_CURRENT_HOLD_LOT@A01ODS y"+
			       " where x.LOT_NUMBER=y.CONTAINERNAME(+)";
		}
		else
		{
			sql += " where 1=1";
		}
       	sql += " and x.LABEL_CODE_SEQ=1"+
			   " order by x.lot_number,x.so_no,x.label_type_size,x.label_code";
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next())
		{
			rec_cnt ++;
			out.println("<tr id='tr_"+(rec_cnt)+"'>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("WIP_NO")==null?"&nbsp;":rs.getString("WIP_NO"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("LOT_NUMBER")==null?"&nbsp;":rs.getString("LOT_NUMBER"))+(rs.getString("hold_lot")!=null?"<BR><font color='#ff0000'>MES HOLD</font>":"")+"</td>");
			out.println("<td style='font-family:arial'>"+(rs.getString("so_no")==null?"&nbsp;":rs.getString("so_no"))+"</td>");
			out.println("<td style='font-family:arial'>"+(rs.getString("ITEM_DESC")==null?"&nbsp;":rs.getString("ITEM_DESC"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("LABEL_GROUP")==null?"&nbsp;":rs.getString("LABEL_GROUP"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("LABEL_CODE")==null?"&nbsp;":rs.getString("LABEL_CODE"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("LABEL_TYPE_SIZE")==null?"&nbsp;":rs.getString("LABEL_TYPE_SIZE"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("PRINT_DATE")==null?"&nbsp;":rs.getString("PRINT_DATE"))+"</td>");
			out.println("<td style='font-family:arial' align='center'>"+(rs.getString("PRINTED_BY")==null?"&nbsp;":rs.getString("PRINTED_BY"))+"</td>");
			out.println("<td align='center' style='font-family:arial'>");
			out.println("<input type='checkbox' name='chk' value='"+(rec_cnt)+"' onClick='setCheck("+(rec_cnt)+")'"+ (rs.getInt("unlock_group_id")>0||rs.getString("hold_lot")!=null?" disabled":"")+">");
			%>
			<input type="hidden" name="LOT_<%=rec_cnt%>" value="<%=rs.getString("LOT_NUMBER")%>">
			<input type="hidden" name="LABEL_CODE_<%=rec_cnt%>" value="<%=rs.getString("LABEL_CODE")%>">
			<input type="hidden" name="ERPMO_<%=rec_cnt%>" value="<%=(rs.getString("so_no")==null?"":rs.getString("so_no"))%>">
			<%
			out.println("</td>");
			out.println("<td align='center' style='font-family:arial'>");
			//<input type='text' name='UNLOCK_REASON_"+(rec_cnt)+"' value='"+(rs.getString("UNLOCK_REASON")==null?"":rs.getString("UNLOCK_REASON"))+"' style='font-family:arial;font-size:11px' readonly>
			try
			{   
				sql = " SELECT  a.a_value, a.a_value a_value1  FROM oraddman.tsc_rfq_setup a  where A_CODE='A01_LABEL_UNLOCK_REASON' order by A_SEQ";
				Statement st2=con.createStatement();
				ResultSet rs2=st2.executeQuery(sql);
				comboBoxBean.setRs(rs2);
				comboBoxBean.setFontSize(11);
				comboBoxBean.setFontName("arial");
				comboBoxBean.setSelection((rs.getString("UNLOCK_REASON")==null?"":rs.getString("UNLOCK_REASON")));
				comboBoxBean.setFieldName("UNLOCK_REASON_"+(rec_cnt));	
				comboBoxBean.setOnChangeJS("chkchoose("+rec_cnt+")");
				out.println(comboBoxBean.getRsString());				   
				rs2.close();   
				st2.close();     	 
			} 
			catch (Exception e) 
			{ 
				out.println("Exception:"+e.getMessage()); 
			} 	
			out.println("</td>");
			out.println("<td align='center' style='font-family:arial'><input type='text' name='UNLOCK_REMARKS_"+(rec_cnt)+"' value='"+(rs.getString("UNLOCK_REASON_REMARKS")==null?"":rs.getString("UNLOCK_REASON_REMARKS"))+"'  style='font-family:arial;font-size:11px' onBlur='chkchoose("+rec_cnt+")'"+ (rs.getInt("unlock_group_id")>0?" disabled":"")+"></td>");
			out.println("<td align='center' style='font-family:arial'>"+(rs.getString("UNLOCK_DATE")==null?"&nbsp;":rs.getString("UNLOCK_DATE"))+"</td>");
			out.println("<td align='center' style='font-family:arial'>"+(rs.getString("UNLOCKED_BY")==null?"&nbsp;":rs.getString("UNLOCKED_BY"))+"</td>");
			out.println("</td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
%>			
			</table>
		</td>
	</tr>
<%
		if (rec_cnt ==0)
		{
%>
	<tr>
		<td align="center" style="font-family:'arial';font-size:13px;color:'#FF0000'">No data found!</td>
	</tr>
<%
		}
		else
		{
	%>
	<tr>
		<td align="center" style="font-family:'arial';font-size:13px;color:#FF0000"><br><input type="button" name="btn1" value="Unlock to Relabel" style="font-family:arial;"  onClick="setSubmit1('../jsp/TSLabelPrintedLogQuery.jsp?QTRANS=UNLOCK')" disabled></td>
	</tr>	
	<%	
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("exception2:"+e.toString());
}
%>			
</table>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>