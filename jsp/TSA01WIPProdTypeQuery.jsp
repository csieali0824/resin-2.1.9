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
	document.MYFORM.action=URL;   
	document.MYFORM.submit();
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
<title>A01 Prod Type Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String sql ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPProdTypeQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666;">A01產品類別設定</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="10%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">TSC Package :</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="TSC_PACKAGE" VALUE="<%=TSC_PACKAGE%>" 	 style="font-family: Tahoma,Georgia;"></td> 
		<td width="75%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPProdTypeQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSA01WIPProdTypeModify.jsp?STATUS=NEW")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT PROD_TYPE_NO,PROD_TYPE_NAME,listagg(TSC_PACKAGE,',') within group (order by TSC_PACKAGE) TSC_PACKAGE,max(a.created_by) created_by,to_char(max(a.CREATION_DATE),'yyyy-mm-dd hh24:mi') CREATION_DATE  FROM ORADDMAN.TSA01_PROD_TYPE A WHERE 1=1";
	if (! TSC_PACKAGE.equals(""))
	{
	 	sql += " and EXISTS (SELECT 1 FROM  ORADDMAN.TSA01_PROD_TYPE B WHERE upper(B.TSC_PACKAGE) like '"+ TSC_PACKAGE.toUpperCase()+"%' AND B.PROD_TYPE_NO=A.PROD_TYPE_NO)";
	}
	sql += " group by PROD_TYPE_NO,PROD_TYPE_NAME order by PROD_TYPE_NO";
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
				<td width="6%" style="font-size:12px;color:#006666" align="center">產品類別代碼</td>
				<td width="10%" style="font-size:12px;color:#006666" align="center">產品類別名稱</td>
				<td width="57%" style="font-size:12px;color:#006666" align="center">Package List</td>
				<td width="10%" style="font-size:12px;color:#006666" align="center">資料異動日</td>            
				<td width="10%" style="font-size:12px;color:#006666" align="center">資料異動者</td>            
			</tr>
			<tr bgcolor="#D3E6F3"> 
			</tr>
		<% 
		}
    	%>
			<tr id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setAdd('../jsp/TSA01WIPProdTypeModify.jsp?STATUS=UPD&PROD_TYPE_NO=<%=rs.getString("PROD_TYPE_NO")%>')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td align="center"><%=rs.getString("PROD_TYPE_NO")%></td>
			<td><%=rs.getString("PROD_TYPE_NAME")%></td>
			<td><%=rs.getString("TSC_PACKAGE")%></td>
			<td align="center"><%=rs.getString("CREATED_BY")%></td>
			<td align="center"><%=rs.getString("CREATION_DATE")%></td>
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

