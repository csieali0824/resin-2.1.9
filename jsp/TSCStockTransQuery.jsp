<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setExportXLS(URL)
{    
	if (document.MYFORM.SDATE.value=="" && document.MYFORM.EDATE.value && document.MYFORM.CUSTOMER.value=="" && document.MYFORM.MO.value=="" && document.MYFORM.ADVISE_NO.value=="" && document.MYFORM.ITEMNAME.value=="" && document.MYFORM.SALESAREA.value=="")
	{
		alert("Please input to query condition !");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>SG Shipping Advise Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String REQ_NO = request.getParameter("REQ_NO");
if (REQ_NO==null) REQ_NO="";
String TSC_DESC = request.getParameter("TSC_DESC");
if (TSC_DESC==null) TSC_DESC="";
String STATUS_CODE = request.getParameter("STATUS_CODE");
if (STATUS_CODE ==null || STATUS_CODE.equals("--")) STATUS_CODE="";
String REQUESTOR = request.getParameter("REQUESTOR");
if (REQUESTOR==null || REQUESTOR.equals("--")) REQUESTOR="";
String TRANS_TYPE=request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null || TRANS_TYPE.equals("--")) TRANS_TYPE="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
if (SDATE.equals("") && EDATE.equals("") && REQ_NO.equals("") && TSC_DESC.equals("") && STATUS_CODE.equals("") && TRANS_TYPE.equals("") && REQUESTOR.equals(""))
{
	dateBean.setAdjDate(-10);
	SDATE = dateBean.getYearMonthDay();
	dateBean.setAdjDate(10);
}
String sql ="",sql1="",status_color="",swhere="";
int exist_cnt=0;
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCStockTransQuery.jsp?WKCODE=<%=WKCODE%>" METHOD="post" NAME="MYFORM">
<font style="font-weight:bold;font-family:'細明體';color:#006666;font-size:18px">轉倉或料號移轉歷程查詢</font><BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
	<tr>
		<td width="8%" style="background-color:#DBECE8;">申請單號 :</td>   
		<td width="10%"><textarea cols="20" rows="3" name="REQ_NO"  style="font-family: Tahoma,Georgia;font-size:12px"><%=REQ_NO%></textarea></td> 
	    <td width="8%" style="background-color:#DBECE8;">申請別:</td> 
		<td width="12%">	
		<%		
		try
    	{   
			sql = " select a.trans_type, a.trans_desc from oraddman.tsc_stock_trans_type a order by a.trans_type";
			PreparedStatement statement = con.prepareStatement(sql);
			ResultSet rs=statement.executeQuery();			
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TRANS_TYPE);
			comboBoxBean.setFieldName("TRANS_TYPE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>		
		<td width="8%" style="background-color:#DBECE8;">料號/品名 :</td>   
		<td width="12%"><textarea cols="25" rows="3" name="TSC_DESC"  style="font-family: Tahoma,Georgia;font-size:12px"><%=TSC_DESC%></textarea></td>
		<td width="8%" style="background-color:#DBECE8;">申請日期:</td>   
		<td width="16%">			
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;font-size:12px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">
			<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>~
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;font-size:12px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="8%" style="background-color:#DBECE8;">申請人 :</td>   
		<td width="10%" >
		<%
		try
    	{		
			sql = " SELECT distinct created_by,created_by created_by1 FROM oraddman.tsc_stock_trans_headers a where substr(a.WKFLOW_LEVEL,1,length(?))=? order by created_by";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,WKCODE);
			statement.setString(2,WKCODE);
			ResultSet rs=statement.executeQuery();			
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(REQUESTOR);
			comboBoxBean.setFieldName("REQUESTOR");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();    
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 			 	 		
		%>
		</td>		
	<tr>
		<td  style="background-color:#DBECE8;">申請狀態 :</td>   
		<td>
		<select NAME="STATUS_CODE" style="font-family: Tahoma,Georgia;font-size:12px" >
		<OPTION VALUE="--" <%=(STATUS_CODE.equals("") || STATUS_CODE.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="AWAITING_APPROVE" <%=(STATUS_CODE.equals("AWAITING_APPROVE")?" selected ":"")%>>AWAITING_APPROVE
        <OPTION VALUE="CONFIRMED" <%=(STATUS_CODE.equals("CONFIRMED")?" selected ":"")%>>CONFIRMED
        <OPTION VALUE="APPROVED" <%=(STATUS_CODE.equals("APPROVED")?" selected ":"")%>>APPROVED
        <OPTION VALUE="REJECTED" <%=(STATUS_CODE.equals("REJECTED")?" selected ":"")%>>REJECTED
        <OPTION VALUE="CLOSED" <%=(STATUS_CODE.equals("CLOSED")?" selected ":"")%>>CLOSED
        <OPTION VALUE="CANCELLED" <%=(STATUS_CODE.equals("CANCELLED")?" selected ":"")%>>CANCELLED
		</select>
		</td>		
		<td colspan="8">
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <INPUT TYPE="button" value='<jsp:getProperty name="rPH" property="pgQuery"/>' style="font-size:12px;font-family:Tahoma,Georgia;"  onClick='setSubmit("../jsp/TSCStockTransQuery.jsp?WKCODE=<%=WKCODE%>")' > 
		</td>
	</tr>
</table>
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.req_header_id"+
	      ",a.req_no"+
		  ",a.created_by"+
		  ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
          ",a.last_updated_by"+
		  ",to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
          ",c.trans_type"+
		  ",c.trans_desc"+
		  ",a.status_code"+
		  ",d.wkflow_next_level"+
          ",listagg(b.orig_item_name||case when length(b.orig_item_name)>=22 then '/'||b.orig_item_desc else '' end,'<br>') within group(order by b.orig_item_name) item_list"+
          ",(select listagg(e.user_name,'/') within group(order by e.user_name)  from oraddman.tsc_stock_trans_member e where c.trans_type=e.trans_type and d.wkflow_next_level=e.wkflow_level) flow_member_list"+
          " from oraddman.tsc_stock_trans_headers a"+
		  ",(select req_header_id,orig_item_name,orig_item_desc from oraddman.tsc_stock_trans_lines group by req_header_id,orig_item_name,orig_item_desc) b"+
		  ",oraddman.tsc_stock_trans_type c"+
		  ",oraddman.tsc_stock_trans_wkflow d"+
          " where a.req_header_id=b.req_header_id"+
          " and a.trans_type=c.trans_type"+
          " and a.trans_type=d.trans_type"+
          " and a.wkflow_level=d.wkflow_level";
	if (!WKCODE.equals("H"))
	{
		sql +=" and substr(d.wkflow_level,1,length('"+WKCODE+"'))='"+WKCODE+"'";
	}
	if (!SDATE.equals(""))
	{
		sql += " and a.creation_date >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		sql += " and a.creation_date <= TO_DATE('"+EDATE+"','yyyymmdd')+0.99999";
	}
	if (!TRANS_TYPE.equals(""))
	{
		sql += " and a.trans_type ='"+TRANS_TYPE+"'";
	}	
	if (!REQUESTOR.equals(""))
	{
		sql += " and a.created_by='"+REQUESTOR+"'";
	}	
	if (!STATUS_CODE.equals(""))
	{
		sql += " and a.status_code='"+STATUS_CODE+"'";
	}		
	if (!REQ_NO.equals(""))
	{
		String [] sArray = REQ_NO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and a.REQ_NO in ( '"+sArray[x].trim()+"'";
			}
			else
			{
				sql += " ,'"+sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	if (!TSC_DESC.equals(""))
	{
		String [] sArray = TSC_DESC.split("\n");
		sql1="";
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql1 += "  b.orig_item_desc in ( '"+sArray[x].trim()+"'";
			}
			else
			{
				sql1 += " ,'"+sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql1 += ")";
		}
		sql += " and ("+sql1 +" or "+ sql1.replace("b.orig_item_desc","b.orig_item_name")+")";
	}	
	sql += " group by a.req_header_id"+
 		   ",a.req_no"+
		   ",a.created_by"+
		   ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi')"+
           ",a.last_updated_by"+
		   ",to_char(a.last_update_date,'yyyy-mm-dd hh24:mi')"+
           ",c.trans_type"+
		   ",c.trans_desc"+
		   ",a.status_code"+
		   ",d.wkflow_next_level"+
           " order by to_char(a.creation_date,'yyyy-mm-dd hh24:mi') desc,a.req_no";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#FFFFFF"  bordercolordark="#5C7671">
			<tr style="background-color:#ACCCC2"> 
				<td width="2%" align="center" nowrap>項次</td> 
				<td width="6%" align="center" nowrap>申請單號</td> 
				<td width="10%" align="center">申請別</td>
				<td width="25%" align="center">料號/品名</td>
				<td width="6%" align="center">申請者</td>
				<td width="8%" align="center">申請日期</td>
				<td width="6%" align="center">最後更新者</td>
				<td width="8%" align="center">最後更新日</td>
				<td width="8%" align="center">申請狀態</td>
				<td width="4%" align="center">文件下載</td>
				<td width="17%" align="center">備註</td>
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>">
			<td align="center" style="font-size:11px"><%=iCnt%></td>
			<td align="center" style="font-size:11px"><A href="../jsp/TSCStockTransConfirmDetail.jsp?HID=<%=rs.getString("req_header_id")%>&WKCODE=<%=WKCODE%>&DTYPE=Q"><%=rs.getString("req_no")%></A></td>
			<td align="left" style="font-size:11px"><%=rs.getString("trans_desc")%></td>
			<td align="left" style="font-size:11px"><%=rs.getString("item_list")%></td>
			<td align="left" style="font-size:11px"><%=rs.getString("created_by")%></td>
			<td align="center" style="font-size:11px"><%=rs.getString("creation_date")%></td>
			<td align="left" style="font-size:11px"><%=rs.getString("last_updated_by")%></td>
			<td align="center" style="font-size:11px"><%=rs.getString("last_update_date")%></td>
			<td align="left" style="font-size:11px"><%=rs.getString("status_code")%></td>
			<%
			if (rs.getString("status_code").toUpperCase().equals("APPROVED") ||rs.getString("status_code").toUpperCase().equals("CLOSED"))
			{
				if (rs.getString("trans_type").equals("01"))
				{
				%>
					<td align="center"><a href="../jsp/TSCStockSubTransExcel.jsp?HID=<%=rs.getString("REQ_HEADER_ID")%>&REQNO=<%=rs.getString("REQ_NO")%>"><img name="popcal" border="0" src="../image/excel_16.gif"></a></td>
				<%
				}
				else if (rs.getString("trans_type").equals("02"))
				{
				%>
					<td align="center"><a href="../jsp/TSCStockMISCTransExcel.jsp?HID=<%=rs.getString("REQ_HEADER_ID")%>&REQNO=<%=rs.getString("REQ_NO")%>"><img name="popcal" border="0" src="../image/excel_16.gif"></a></td>
				<%
				}
				else
				{
				%>
					<td align="center">&nbsp;</td>
				<%
				}
			}
			else
			{
			%>
				<td align="center">&nbsp;</td>
			<%
			}
			%>
			<td align="left" style="font-size:11px"><%=(rs.getString("flow_member_list")==null||rs.getString("status_code").toUpperCase().equals("CLOSED")||rs.getString("status_code").toUpperCase().equals("REJECTED")?"&nbsp;":"待"+rs.getString("flow_member_list")+"同仁確認中")%></td>
		  </tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
<input type="hidden" name="WKCODE" value="<%=WKCODE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

