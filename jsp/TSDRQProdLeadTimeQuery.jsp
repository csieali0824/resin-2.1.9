<!-- 20151119 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160130 Peggy,add No Wafer Lead Time column-->
<!-- 20180802 Peggy,新增"停用/啟用"欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUpload(URL)
{    
	var w_width=600;
	var w_height=500;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-100)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);	
}
function setAdd(URL)
{    
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);	
}
function setDelete(URL)
{  
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setUpdate(URL)
{
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>TS Lead Time Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String PLANT_CODE = request.getParameter("PLANT_CODE");
if (PLANT_CODE==null) PLANT_CODE=(userProdCenterNo==null?"":userProdCenterNo);
String TSC_PROD_GROUP = request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP==null) TSC_PROD_GROUP="";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PROD_FAMILY = request.getParameter("TSC_PROD_FAMILY");
if (TSC_PROD_FAMILY==null) TSC_PROD_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String ACTYPE = request.getParameter("ACTYPE");
if (ACTYPE==null) ACTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String sql ="",stock_color="";

if (ACTYPE.equals("DELETE"))
{
	try
	{
		sql = " delete  oraddman.tsprod_manufactory_leadtime where SEQ_ID=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,ID); 
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		con.commit();
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("刪除動作失敗!!(錯誤原因:"+e.getMessage()+")");
	}	
}

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSDRQProdLeadTimeQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">生產廠區<font style="font-family:arial;font-size:20px;color:#006666">Lead Time</font>資料查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='1' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1' bordercolor="#CCCCCC">
     <tr>
		<td width="6%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666;">生產廠區:</td>   
		<td width="10%">
		<%
		try
		{
			sql = " select a.manufactory_no,a.manufactory_no || ' '||a.manufactory_name manufactory_name from oraddman.tsprod_manufactory a where MANUFACTORY_NO in ('002','005','006','008','010','011')";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(PLANT_CODE);
			comboBoxBean.setFieldName("PLANT_CODE");	
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setFontSize(11);   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>		
		</td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666">TSC Prod Group:</td>   
		<td width="9%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_GROUP' AND DISABLE_DATE IS NULL order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PROD_GROUP);
			comboBoxBean.setFieldName("TSC_PROD_GROUP");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(11);   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>		
		</td>
		<td width="6%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666">TSC Family:</td>   
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Family' AND DISABLE_DATE IS NULL order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_FAMILY);
			comboBoxBean.setFieldName("TSC_FAMILY");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(11);   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666">TSC Prod Family:</td>   
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_FAMILY' AND DISABLE_DATE IS NULL order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PROD_FAMILY);
			comboBoxBean.setFieldName("TSC_PROD_FAMILY");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(11);   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
	    <td width="7%" bgcolor="#D3E6F3" style="font-size:11px;font-weight:bold;color:#006666">TSC Package:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Package' AND DISABLE_DATE IS NULL order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PACKAGE);
			comboBoxBean.setFieldName("TSC_PACKAGE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(11);   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>	
		</td>
	    <td width="5%" bgcolor="#D3E6F3" style="font-size:11px;font-weight:bold;color:#006666">型號:</td> 
		<td width="8%"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia; font-size:11px" size="15" onChange="setChange();"></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr><td height="10">&nbsp;</td></tr>
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSDRQProdLeadTimeQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
			<% 
			if (UserRoles.indexOf("LeadTimeQuery")<0)
			{
			%>
		    <INPUT TYPE="button" align="middle"  value='整批匯入'  style="font-family:ARIAL" onClick='setUpload("../jsp/TSDRQProdLeadTimeUpload.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='單筆新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSDRQProdLeadTimeAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
			<%
			}
			%>
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSDRQProdLeadTimeExcel.jsp")' > 
			&nbsp;&nbsp;&nbsp;	
		    <INPUT TYPE="button" align="middle"  value='Item Leadtime Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSDRQProdLeadTimeItemExcel.jsp")' > 					
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.seq_id,a.manufactory_no,b.MANUFACTORY_NO ||' '|| b.MANUFACTORY_NAME MANUFACTORY_NAME, a.tsc_prod_group, a.tsc_family,a.tsc_prod_family, a.tsc_package,a.tsc_desc, a.lead_time, a.lead_time_uom, a.created_by, a.creation_date, a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
	      ",a.NO_WAFER_LEAD_TIME,a.s_voltage,a.e_voltage"+//add by Peggy 20160130
		  ",NVL(a.active_flag,'I') active_flag"+ //add by Peggy 20180802
          " FROM oraddman.tsprod_manufactory_leadtime a,oraddman.tsprod_manufactory b where a.manufactory_no=b.manufactory_no(+)";
	if (!PLANT_CODE.equals("") && !PLANT_CODE.equals("--"))
	{
	 	sql += " and a.manufactory_no='"+PLANT_CODE+"'";
	}
	if (!TSC_PROD_GROUP.equals("") && !TSC_PROD_GROUP.equals("--"))
	{
		sql += " and a.tsc_prod_group = '" + TSC_PROD_GROUP +"'";
	}
	if (!TSC_FAMILY.equals("") && !TSC_FAMILY.equals("--"))
	{
		sql += " and a.tsc_family ='"+ TSC_FAMILY+"'";
	}
	if (!TSC_PROD_FAMILY.equals("") && !TSC_PROD_FAMILY.equals("--"))
	{
		sql += " and a.tsc_prod_family ='"+ TSC_PROD_FAMILY+"'";
	}	
	if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--"))
	{
		sql += " and a.tsc_package = '" + TSC_PACKAGE+"'";
	}
	if (!ITEM_DESC.equals(""))
	{
		sql += " and a.tsc_desc = '"+  ITEM_DESC+"'";
	}
	sql += " order by a.manufactory_no,a.tsc_family,a.tsc_prod_family, a.tsc_package,case when a.s_voltage is null and a.e_voltage is null then 4 when a.s_voltage is null and a.e_voltage is not null then 1 when a.s_voltage is not null and a.e_voltage is not null then 2 else 3 end";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671" bordercolor="#D3E6F3">
			<tr bgcolor="#D3E6F3"> 
				<td width="4%" height="22">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="10%" style="font-size:12px;color:#006666" align="center">生產廠區</td>
				<td width="7%" style="font-size:12px;color:#006666" align="center">TSC Prod Group</td>
				<td width="7%" style="font-size:12px;color:#006666" align="center">TSC Family</td>
				<td width="7%" style="font-size:12px;color:#006666" align="center">TSC Prod Family</td>
				<td width="7%" style="font-size:12px;color:#006666" align="center">TSC Package</td>            
				<td width="10%" style="font-size:12px;color:#006666" align="center">型號</td>            
				<td width="5%" style="font-size:12px;color:#006666" align="center">Start Voltage(V)</td>            
				<td width="5%" style="font-size:12px;color:#006666" align="center">End Voltage(V)</td>            
				<td width="6%" style="font-size:12px;color:#006666" align="center">Lead Time</td>            
				<!--<td width="6%" style="font-size:12px;color:#006666" align="center">Lead Time(No Wafer)</td> -->
				<td width="5%" style="font-size:12px;color:#006666" align="center">Lead Time Uom</td>            
				<td width="6%" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
				<td width="8%" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="5%" style="font-size:12px;color:#006666" align="center">狀態</td>            
			</tr>
		<% 
		}
    	%>
			<tr  id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<%
			if (UserRoles.indexOf("admin")>=0 || (userProdCenterNo!=null && userProdCenterNo.equals(rs.getString("manufactory_no"))))
			{
			%>
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSDRQProdLeadTimeAdd.jsp?STATUS=UPD&ID=<%=rs.getString("SEQ_ID")%>')">&nbsp;&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="刪除資料" onClick="setDelete('../jsp/TSDRQProdLeadTimeQuery.jsp?ID=<%=rs.getString("seq_id")%>&ACTYPE=DELETE')">
			<%
			}
			else
			{
				out.println("-------");
			}
			%>
			</td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("MANUFACTORY_NAME")%></td>
			<td><%=rs.getString("tsc_prod_group")%></td>
			<td><%=rs.getString("tsc_family")%></td>
			<td><%=(rs.getString("tsc_prod_family")==null?"&nbsp;":rs.getString("tsc_prod_family"))%></td>
			<td><%=rs.getString("tsc_package")%></td>
			<td><%=(rs.getString("tsc_desc")==null?"&nbsp;":rs.getString("tsc_desc"))%></td>
			<td><%=(rs.getString("s_voltage")==null?"&nbsp;":rs.getString("s_voltage"))%></td>
			<td><%=(rs.getString("e_voltage")==null?"&nbsp;":rs.getString("e_voltage"))%></td>
			<td align="center"><%=rs.getString("lead_time")%></td>
			<!--<td align="center"><%=(rs.getString("no_wafer_lead_time")==null?"&nbsp;":rs.getString("no_wafer_lead_time"))%></td>-->
			<td align="center"><%=rs.getString("lead_time_uom")%></td>
			<td><%=rs.getString("last_updated_by")%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center" <%=(rs.getString("active_flag").equals("A")?"":"style='color:#FF0000'")%>><%=(rs.getString("active_flag").equals("A")?"啟用":"停用")%></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
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
</FORM>
<BR>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

