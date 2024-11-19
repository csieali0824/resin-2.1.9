<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>TS YEW Label Query</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAdd(URL)
{    
	var w_width=600;
	var w_height=600;
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
	var w_height=600;
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
<%
String LABEL_GROUP_CODE = request.getParameter("LABEL_GROUP_CODE");
if (LABEL_GROUP_CODE==null) LABEL_GROUP_CODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="",sql1="";
int area_cnt =0;

sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="../jsp/TSYewLabelGroupQuery.jsp">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤群組查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">群組代碼/名稱:</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="LABEL_GROUP_CODE" VALUE="<%=LABEL_GROUP_CODE%>" 	 style="font-family: Tahoma,Georgia;"></td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">啟/停用:</td>   
		<td width="15%">
		<select NAME="STATUS" style="font-family:Tahoma,Georgia; font-size: 12px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>			
		</td>
		<td width="31%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSYewLabelGroupQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSYewLabelGroupAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSYewLabelGroupExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.label_group_code"+
	      ",a.label_group_name"+
		  ",a.label_group_desc"+
          ",to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date"+
		  ",to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date"+
		  ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
          ",a.created_by"+
		  ",to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
		  ",a.last_updated_by"+
          ",case a.label_kind when 'TSC' then '台半標準標籤' when 'CUST' then '客戶標籤' when 'SHIPPING MARK' then '嘜頭標籤' else a.label_kind end as label_kind"+
		  ",a.label_form_code, a.label_form_version"+ //add by Peggy 20200505
          " FROM oraddman.tsyew_label_groups a"+
		  " where 1=1";
	if (! LABEL_GROUP_CODE.equals(""))
	{
	 	sql += " and (upper(a.label_group_code)='"+ LABEL_GROUP_CODE.toUpperCase()+"' or upper(a.label_group_name) like '"+ LABEL_GROUP_CODE.toUpperCase()+"%')";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	sql += " order by a.label_group_name";
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
				<td width="3%" >&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="6%" style="font-size:12px;color:#006666" align="center">標籤類別</td>
				<td width="6%" style="font-size:12px;color:#006666" align="center">群組代碼</td>
				<td width="13%" style="font-size:12px;color:#006666" align="center">群組名稱</td>
				<td width="15%" style="font-size:12px;color:#006666" align="center">群組說明</td>
				<td width="8%" style="font-size:12px;color:#006666" align="center">文件代碼</td>
				<td width="3%" style="font-size:12px;color:#006666" align="center">文件版次</td>
				<td width="7%" style="font-size:12px;color:#006666" align="center">啟用起日</td>            
				<td width="7%" style="font-size:12px;color:#006666" align="center">啟用迄日</td>            
				<td width="7%" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="7%" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
			</tr>
		<% 
		}
    	%>
			<tr id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSYewLabelGroupAdd.jsp?STATUS=UPD&LABEL_GROUP_CODE=<%=rs.getString("label_group_code")%>')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("label_kind")%></td>
			<td align="center"><%=rs.getString("label_group_code")%></td>
			<td><%=rs.getString("label_group_name")%></td>
			<td><%=rs.getString("label_group_desc")%></td>
			<td align="center"><%=(rs.getString("label_form_code")==null?"&nbsp;":rs.getString("label_form_code"))%></td>
			<td align="center"><%=(rs.getString("label_form_version")==null?"&nbsp;":rs.getString("label_form_version"))%></td>
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
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
