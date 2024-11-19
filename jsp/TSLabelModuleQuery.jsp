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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>TS Label Group Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String MODULE_CODE = request.getParameter("MODULE_CODE");
if (MODULE_CODE==null) MODULE_CODE="";
String MODULE_NAME = request.getParameter("MODULE_NAME");
if (MODULE_NAME==null) MODULE_NAME="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSLabelModuleQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">業務模組查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">模組代碼:</td>   
		<td width="15%">
		<%
		try
		{
			sql = " select MODULE_CODE,MODULE_CODE  from oraddman.ts_label_modules a";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(MODULE_CODE);
			comboBoxBean.setFieldName("MODULE_CODE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
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
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">模組名稱:</td>   
		<td width="15%">
		<INPUT TYPE="TEXT" NAME="MODULE_NAME" VALUE="<%=MODULE_NAME%>" 	 style="font-family: Tahoma,Georgia;">
		</td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">啟/停用:</td>   
		<td width="15%">
		<select NAME="STATUS" style="font-family:Tahoma,Georgia; font-size: 12px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>			
		</td>
		<td width="31%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSLabelModuleQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSLabelModuleAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSLabelModuleExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.module_code, a.module_name,"+
          " to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date, to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, a.last_updated_by "+
          " from oraddman.ts_label_modules a where 1=1  ";
	if (!MODULE_CODE.equals("") && !MODULE_CODE.equals("--"))
	{
	 	sql += " and a.MODULE_CODE='"+ MODULE_CODE+"'";
	}
	if (!MODULE_NAME.equals(""))
	{
		sql += " and a.module_name like '%" + MODULE_NAME +"%'";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#D3E6F3"> 
				<td width="3%" height="22">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="14%" style="font-size:12px;color:#006666" align="center">業務模組代碼</td>
				<td width="20%" style="font-size:12px;color:#006666" align="center">業務模組名稱</td>
				<td width="12%" style="font-size:12px;color:#006666" align="center">啟用起日</td>            
				<td width="12%" style="font-size:12px;color:#006666" align="center">啟用迄日</td>            
				<td width="12%" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="12%" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
			</tr>
		<% 
		}
    	%>
			<tr  id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSLabelModuleAdd.jsp?STATUS=UPD&MODULE_CODE=<%=rs.getString("MODULE_CODE")%>')"></td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("module_code")%></td>
			<td><%=rs.getString("module_name")%></td>
			<td align="center"><%=(rs.getString("effective_from_date")==null?"&nbsp;":rs.getString("effective_from_date"))%></td>
			<td align="center"><%=(rs.getString("effective_to_date")==null?"&nbsp;":rs.getString("effective_to_date"))%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center"><%=rs.getString("last_updated_by")%></td>
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

