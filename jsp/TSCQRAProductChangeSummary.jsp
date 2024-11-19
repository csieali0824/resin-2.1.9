<!-- modify by Peggy 20140829,add a delete pcn function-->
<!-- modffy by Peggy 20150127,顯示pcn訂單搜尋狀態-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,ComboBoxBean,ArrayComboBoxBean,javax.xml.parsers.*,CodeUtil"%>
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
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function toUpper(objname)
{
	if (objname!=null)
	{
		document.MYFORM.elements[objname].value = document.MYFORM.elements[objname].value.toUpperCase();
	}
}
function setDelete(URL) //add by Peggy 20140829
{
	if (confirm("請注意!資料一旦刪除,即無法恢原,您確定仍要刪除此筆PCN資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();	
	}
}
function subAttachWindow(pcn_number)
{
	subWin=window.open("../jsp/TSCQRAAttachmentUpload.jsp?FILEID="+pcn_number,"subwin","width=840,height=150,scrollbars=yes,menubar=no");
}
function setUpdate(pcn_number,seq)
{
	subWin=window.open("../jsp/TSCQRAPCNIssueDate.jsp?PCN="+pcn_number+"&SEQ="+seq,"subwin","width=500,height=400,scrollbars=yes,menubar=no");
}
function setWebInfo(keyid,pcn)
{
	subWin=window.open("../jsp/TSCQRAPCNCustomerReplyPage.jsp?keyid="+keyid+"&PCN="+pcn,"subwin","width=700,height=100,scrollbars=yes,menubar=no");
}

</script>
</head>
<%
response.setHeader("refresh" , "180" ); 
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QTYPE = request.getParameter("QTYPE");
if (QTYPE==null) QTYPE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String DEL_QNO = request.getParameter("DEL_QNO");    //add by Peggy 20140829
if (DEL_QNO==null) DEL_QNO="";
String DEL_FLAG = request.getParameter("DEL_FLAG");  //add by Peggy 20140829
if (DEL_FLAG==null) DEL_FLAG=""; 
String sql ="",where="";
boolean isExist=false;

//add by Peggy 20140829
if (DEL_FLAG.equals("Y") && !DEL_QNO.equals(""))
{
	try
	{
		sql = " delete oraddman.tsqra_pcn_item_detail where PCN_NUMBER=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,DEL_QNO); 
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		sql = " delete oraddman.tsqra_pcn_item_header where PCN_NUMBER=?";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,DEL_QNO); 
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		con.commit();
		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("PCN Number:"+DEL_QNO+" 刪除失敗!!(發生錯誤原因:"+e.getMessage()+")");
	}	
}
%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSCQRAProductChangeSummary.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font size=4><strong>PCN/PDN/IN資料查詢</strong></font>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp">HOME</A></td>
	</tr>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr>
					<td width="15%" style="background-color:#DCE6E7"><font color="#006666">PCN/PDN/IN Number</font></td>
					<td width="15%" style="background-color:#DCE6E7"><input type="text" name="QNO" style="font-family: Tahoma,Georgia;" value="<%=QNO%>"  onKeyUp="toUpper('QNO')" size="20"></td>
					<td width="20%" style="background-color:#DCE6E7"><font color="#006666">Issue Date</font></td>
					<td width="30%" style="background-color:#DCE6E7">   
					<input type="text" name="SDATE" value="<%=SDATE%>" size="12" style="font-family:Tahoma,Georgia"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					<input type="text" name="EDATE" value="<%=EDATE%>" size="12" style="font-family:Tahoma,Georgia"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>					
					</td>
					<td width="10%" style="background-color:#DCE6E7"><font color="#006666">Type</font></td>
					<td width="10%" style="background-color:#DCE6E7"><SELECT NAME="QTYPE" style="font-family:Tahoma,Georgia;">
						<option value="--" <% if (QTYPE.equals("")) out.println("selected");%>>--</option>
						<option value="PCN" <% if (QTYPE.equals("PCN")) out.println("selected");%>>PCN</option>
					    <option value="PDN" <% if (QTYPE.equals("PDN")) out.println("selected");%>>PDN</option>
						</SELECT>	</td>
				</tr>
				<tr>
					<td colspan="6" align="center" style="background-color:#DCE6E7">
					<input type="button" name="submit1" value="Query" style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCQRAProductChangeSummary.jsp")'>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" name="AddNew" value="Create" style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCQRAProductChangeModify.jsp")'>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<HR>
<%
try
{
	int rec_cnt =0;
	where ="";sql ="";
	sql = " SELECT a.rowid keyid,a.pcn_number, a.SEQUENCE_ID,a.pcn_end_date,a.pcn_type, a.pcn_creation_date, to_char(a.creation_date,'yyyy-mm-dd') creation_date, a.created_by , a.S_ACT_SHIP_DATE||' - '||a.E_ACT_SHIP_DATE order_date"+
	      ",(select count(1) from user_scheduler_jobs b where b.JOB_NAME = 'PCN_JOB:'||a.pcn_number) job_cnt"+
		  ",a.PDF_FILE_PATH ,a.EFFECTIVE_DATE,a.LAST_ORDER_DATE,a.LAST_DELIVERY_DATE,a.INTENDED_START_OF_DELIVERY"+
	      " FROM oraddman.tsqra_pcn_item_header a where 1=1";
	if (!QNO.equals(""))
	{	
		where += " and a.pcn_number='"+ QNO+"'";
	}
	if (!QTYPE.equals("--") && !QTYPE.equals(""))
	{
		where += " and a.pcn_type='" + QTYPE+"'";
	}
	if (!SDATE.equals("")) //modify by Peggy 20140416
	{
		where += " and a.pcn_creation_date >= '"+SDATE+"'";
	}
	if (!EDATE.equals(""))  //modify by Peggy 20140416
	{
		where += " and a.pcn_creation_date <= '"+EDATE+"'";
	}
	sql = sql + where + " order by a.creation_date desc";
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	String rootPath="";
	while (rs.next())
	{
		if (rec_cnt==0)
		{
%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
				<tr style="background-color:#006666;color:#FFFFFF;font-size:11px">
					<td width="6%" align="center" valign="top">&nbsp;</td>
					<td width="3%" align="center" valign="top">SEQ</td>
					<td width="9%" align="center" valign="top">PCN/PDN/IN Number</td>
					<td width="9%" align="center" valign="top">ECN NO </td>
					<td width="5%" align="center" valign="top">Issue Date</td>
					<td width="5%" align="center" valign="top">End Date</td>
					<td width="5%" align="center" valign="top">Effective Date</td>
					<td width="5%" align="center" valign="top">Last Order Date</td>
					<td width="5%" align="center" valign="top">Last Delivery Date</td>
					<td width="5%" align="center" valign="top">Intended Start Of Delivery</td>
					<td width="6%" align="center" valign="top">Type</td>
					<td width="9%" align="center" valign="top">Search Order Date</td>
					<td width="8%" align="center" valign="top">Created by</td>
					<td width="6%" align="center" valign="top">Creation Date</td>
					<td width="4%" align="center" valign="top">Export to Excel</td>
					<td width="4%" align="center" valign="top">PDF File</td>
					<td width="6%" align="center" valign="top">Customer Questionnaire<br>Web Page</td>
				</tr>
<%
		}
		out.println("<tr id='tr_"+(rec_cnt+1)+"' bgcolor='#F5F5F5' style='font-size:11px' onmouseover="+'"'+"this.style.color='#000000';this.style.backgroundColor='#AFCDBA';"+'"'+" onmouseout="+'"'+"style.backgroundColor='#f0f0f0',style.color='#000000';this.style.fontWeight='normal'"+'"'+">");    
		out.println("<td align='center'>");
		if (rs.getInt("job_cnt")>0)
		{
			out.println("<font color='red'>訂單資料正在搜尋中...</font>");
		}
		else
		{
			out.println("<img border='0' src='images/deletion.gif' height='14' title='刪除資料' onClick='setDelete("+'"'+"../jsp/TSCQRAProductChangeSummary.jsp?DEL_QNO="+rs.getString("pcn_number")+"&DEL_FLAG=Y"+'"'+")'>");
			out.println("&nbsp;&nbsp;");
			out.println("<img id='img_"+(rec_cnt+1)+"' border='0' src='images/icon.png' height='14' title='PCN日期維護' onClick='setUpdate("+'"'+rs.getString("pcn_number")+'"'+","+(rec_cnt+1)+")'>");
			out.println("&nbsp;&nbsp;");
			//if (rs.getString("SEQUENCE_ID")!=null && rs.getString("pcn_number").equals(rs.getString("SEQUENCE_ID")) && !rs.getString("pcn_number").startsWith("QP"))
			if (rs.getString("SEQUENCE_ID")!=null && rs.getString("pcn_number").startsWith("ECN"))
			{
				out.println("&nbsp;&nbsp;&nbsp;&nbsp;");
			}
			else
			{
				out.println("<img border='0' src='images/icon_16.png' height='14' title='PDF檔案上傳'  onClick='subAttachWindow("+'"'+rs.getString("pcn_number")+'"'+")'>");
			}
		}
		out.println("</td>");
		out.println("<td align='center'>"+(rec_cnt+1)+"</td>");
		out.println("<td>");
		if (rs.getInt("job_cnt")>0)
		{
			out.println(rs.getString("pcn_number"));
		}
		else
		{
			out.println("<a href='../jsp/TSCQRAProductChangeDetail.jsp?ID="+rs.getString("pcn_number")+"'>"+rs.getString("pcn_number")+"</a>");
		}
		out.println("</td>");
		out.println("<td>"+(rs.getString("SEQUENCE_ID")==null?"&nbsp;":rs.getString("SEQUENCE_ID"))+"</td>");
		out.println("<td align='center'><div id='sd_"+(rec_cnt+1)+"'>"+(rs.getString("pcn_creation_date")==null?"&nbsp;":rs.getString("pcn_creation_date"))+"</div></td>");
		out.println("<td align='center'><div id='ed_"+(rec_cnt+1)+"'>"+(rs.getString("pcn_end_date")==null?"&nbsp;":rs.getString("pcn_end_date"))+"</div></td>");
		out.println("<td align='center'><div id='efd_"+(rec_cnt+1)+"'>"+(rs.getString("EFFECTIVE_DATE")==null?"&nbsp;":rs.getString("EFFECTIVE_DATE"))+"</div></td>");
		out.println("<td align='center'><div id='lod_"+(rec_cnt+1)+"'>"+(rs.getString("LAST_ORDER_DATE")==null?"&nbsp;":rs.getString("LAST_ORDER_DATE"))+"</div></td>");
		out.println("<td align='center'><div id='ldd_"+(rec_cnt+1)+"'>"+(rs.getString("LAST_DELIVERY_DATE")==null?"&nbsp;":rs.getString("LAST_DELIVERY_DATE"))+"</div></td>");
		out.println("<td align='center'><div id='id_"+(rec_cnt+1)+"'>"+(rs.getString("INTENDED_START_OF_DELIVERY")==null?"&nbsp;":rs.getString("INTENDED_START_OF_DELIVERY"))+"</div></td>");
		out.println("<td align='center'>"+rs.getString("pcn_type")+"</td>");
		out.println("<td align='center'>"+rs.getString("order_date")+"</td>");
		out.println("<td align='center'>"+rs.getString("created_by")+"</td>");
		out.println("<td align='center'>"+rs.getString("creation_date")+"</td>");
		out.println("<td align='center'><a href='../jsp/TSCQRAProductNoticeExcel.jsp?QNO="+rs.getString("pcn_number")+"&TERRITORY=ALL&GROUPBY=4' target='_blank'><img src='images/xls.gif' border='0'></a></td>");
		rootPath = application.getRealPath("/jsp/QRA_Attache/"+rs.getString("pcn_number")+".pdf");
		File fp = new File(rootPath);
		if (fp.exists()) 
		{
			out.println("<td align='center'><a href='../jsp/QRA_Attache/"+rs.getString("pcn_number")+".pdf"+"' target='_blank'><img src='images/pdf.gif' border='0'></a></td>");
		}
		else if (rs.getString("PDF_FILE_PATH")!=null)
		{
			out.println("<td align='center'><a href='"+rs.getString("PDF_FILE_PATH")+"' target='_blank'><img src='images/pdf.gif' border='0'></a></td>");
		}
		else
		{
			out.println("<td align='center'>&nbsp;</td>");
		}
		//cust_url=request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/"))+"/TSCQRAProductNoticeCustReply.jsp?formkey="+java.net.URLEncoder.encode(rs.getString("keyid")+"#cid"+rs.getString("PCN_NUMBER").toUpperCase().replace("QPCN","")+"+"+"/cview");
		out.println("<td align='center'><a href='javascript:void(0)' onClick='setWebInfo("+'"'+rs.getString("keyid")+'"'+","+'"'+rs.getString("PCN_NUMBER")+'"'+")'><img src='images/reconnect.png' border='0' width='30' height='20'></a></td>");
		out.println("</tr>");
		rec_cnt ++;
	}
	rs.close();
	statement.close();
	if (rec_cnt >0)
	{
%>
			</table>
<%
	}
	else
	{
%>
	<table width="100%">
		<tr>
			<td align="center" style="font-family:'細明體';font-size:12px;color:#FF0000"><div align="center">查無符合條件資料,請重新確認,謝謝!</div></td>
		</tr>
	</table>
<%
	}
}
catch(Exception e)
{
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