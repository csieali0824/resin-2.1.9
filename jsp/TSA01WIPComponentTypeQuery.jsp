<!--20180613 Pegg,新增庫存移轉邊線倉flag-->
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
	var w_height=300;
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
<title>A01 WIP  Component Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String COMP_TYPE_NAME = request.getParameter("COMP_TYPE_NAME");
if (COMP_TYPE_NAME==null) COMP_TYPE_NAME="";
String sql ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPComponentTypeQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666;">A01 原物料類別設定</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="10%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;"><span style="font-size:12px;color:#006666">原物料類別名稱</span> :</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="COMP_TYPE_NAME" VALUE="<%=COMP_TYPE_NAME%>" style="font-family: Tahoma,Georgia;"></td> 
		<td width="75%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPComponentTypeQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSA01WIPComponentTypeModify.jsp?STATUS=NEW")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.comp_type_no, a.comp_type_name, a.created_by, to_char(a.creation_date,'yyyy-mm-dd') creation_date,a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, a.active_flag,a.WIP_SUBINV_FLAG FROM oraddman.tsa01_component_type a where 1=1";
	if (!COMP_TYPE_NAME.equals(""))
	{
	 	sql += " and COMP_TYPE_NAME like '%"+ COMP_TYPE_NAME.toUpperCase()+"%'";
	}
	sql += " order by a.comp_type_no";
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
				<td width="3%">&nbsp;&nbsp;&nbsp;</td> 
				<td width="4%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="6%" style="font-size:12px;color:#006666" align="center">原物料類別代碼</td>
				<td width="10%" style="font-size:12px;color:#006666" align="center">原物料類別名稱</td>
				<td width="5%" style="font-size:12px;color:#006666" align="center">發料線邊倉</td>
				<td width="9%" style="font-size:12px;color:#006666" align="center">建立日期</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">建立人員</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">狀態</td>            
			</tr>
			<tr bgcolor="#D3E6F3"> 
			</tr>
		<% 
		}
    	%>
			<tr id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setAdd('../jsp/TSA01WIPComponentTypeModify.jsp?STATUS=UPD&comp_type_no=<%=rs.getString("comp_type_no")%>')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td align="center"><%=rs.getString("comp_type_no")%></td>
			<td><%=rs.getString("comp_type_name")%></td>
			<td align="center"><%=(rs.getString("wip_subinv_flag")==null?"&nbsp;":rs.getString("wip_subinv_flag"))%></td>
			<td align="center"><%=rs.getString("creation_date")%></td>
			<td align="center"><%=rs.getString("created_by")%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center"><%=rs.getString("last_updated_by")%></td>
			<td align="center"><%=(rs.getString("active_flag").equals("Y")?"生效":"失效")%></td>
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

