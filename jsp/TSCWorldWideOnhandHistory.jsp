<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Slow Moving Stock Query</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>
<STYLE TYPE='text/css'> 
 .style1   {font-family:Tahoma,Georgia; font-size:13px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:Tahoma,Georgia; font-size:13px; background-color:#D8E6E7; color:#000000; text-align:left;}
 .style3   {font-family:Tahoma,Georgia; font-size:13px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Tahoma,Georgia; font-size:11px; color: #000000; text-align:center}
 .style7   {font-family:Tahoma,Georgia; font-size:11px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style9   {font-family:Tahoma,Georgia; font-size:11px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style13  {font-family:Tahoma,Georgia; font-size:13px; background-color:#AAAAAA; color:#000000; text-align:left;}
 .style14  {font-family:Tahoma,Georgia; font-size:13px; background-color:#CAE1DC; color:#000000; text-align:center;}
 .style15  {font-family:Tahoma,Georgia; font-size:15px; background-color:#99CC99; color:#000000; text-align:center;}
 .style16  {font-family:Tahoma,Georgia; font-size:11px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style17  {font-family:Tahoma,Georgia; font-size:13px; background-color:#FFFFFF; color:#000000; text-align:LEFT;}
 .style18  {font-family:Tahoma,Georgia; font-size:15px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 td {word-break:break-all}
</STYLE>
</head>
<body>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<p>
<font  style="font-weight:bold;font-family:'Tahoma,Georgia';color:#003399;font-size:24px" >TSC 海外庫存歷史上傳明細</font>
<br>
</p>
<table width="75%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
 	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#000000" cellpadding="1" width="100%" height="15" align="left">
				<TR>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="回首頁!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#000000">
									<STRONG>回首頁</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>
					<TD width="10%" class="style15">
						<STRONG>上傳歷程</STRONG>
					</TD>
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入庫存查詢功能!">
									<A HREF="TSCWorldWideOnhandQuery.jsp" style="text-decoration:none;color:#000000">
									<STRONG>庫存查詢</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>					
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入資料上傳功能!">
									<A HREF="TSCWorldWideOnhandUpload.jsp" style="text-decoration:none;color:#000000">
									<STRONG>資料上傳</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>					
					<!--<TD width="65%" class="style16"><a href="samplefiles/D8-001_User_Guide.doc">Download User Guide</a>&nbsp;</TD>-->
					<TD width="65%" class="style16">&nbsp;</TD>
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
<%
String sql = "" ;
Statement st = con.createStatement();
ResultSet rs = null;
String pgmName = "D8001_";
try
{
	sql = " SELECT VERSION_ID,UPDATED_BY,TO_CHAR(UPDATE_DATE,'yyyy-mm-dd hh24:mi:ss') UPDATE_DATE"+
	      ", VERSION_FLAG,case VERSION_FLAG when 'A' then '有效' when 'I' then '失效' when 'T' then '資料更新中' else '資料異常' end as VERSION_STATUS,SOURCE_FILE "+
	      ", (select count(1) from  oraddman.TSC_WWS_STOCK_DETAIL b where b.version_id = a.version_id) TRANS_TOT "+
	      " from oraddman.TSC_WWS_STOCK_HEADER a order by version_id desc";
	rs = st.executeQuery(sql);
	int firCnt = 0;
	while (rs.next()) 
	{	
		if (firCnt==0)
		{
			out.println("<tr><td><table cellspacing='0' bordercolordark='#998811' cellpadding='1' width='100%' align='left' bordercolorlight='#ffffff' border='1'>");
			out.println("<tr style='background-color:#C7DEC8'>");
			out.println("<td class='style1'>版本</td>");
			out.println("<td class='style1' style='text-align:center;'>版本狀態</td>");
			out.println("<td class='style1'>資料筆數</td>");
			out.println("<td class='style1' style='text-align:center;'>上傳檔案</td>");
			out.println("<td class='style1' style='text-align:center;'>更新人員</td>");
			out.println("<td class='style1' style='text-align:center;'>更新日期</td>");
			out.println("</tr>");
		}
		out.println("<tr style='background-color:#CCCCCC;font-family:Tahoma,Georgia;font-size:13px;'>");
		out.println("<td>"+rs.getString("VERSION_ID") + "</td>");
		if (rs.getString("VERSION_FLAG").equals("T"))
		{
			out.println("<td title='資料更新中...' style='text-align:center;'><img src='images/lang.gif' border='0' width='20' height='20'></td>");
		}
		else if (rs.getString("VERSION_FLAG").equals("A"))
		{
			out.println("<td title='有效資料' style='text-align:center;'><img src='images/not.gif' border='0' width='20' height='20'></td>");
		}
		else
		{
			out.println("<td title='資料已失效' style='text-align:center;'><img src='images/cross.gif' border='0' width='20' height='20'></td>");
		}
		out.println("<td>"+rs.getString("TRANS_TOT") + "</td>");
		out.println("<td style='text-align:center;'><a href='../jsp/upload_exl/"+rs.getString("SOURCE_FILE")+"'><img src='images/Excel_16.gif' border='0' width='20' height='20'></a></td>");
		out.println("<td style='text-align:center;'>"+rs.getString("UPDATED_BY") + "</td>");
		out.println("<td style='text-align:center;'>"+rs.getString("UPDATE_DATE") + "</td>");
		out.println("</tr>");
		firCnt ++;
	}
	if (firCnt >0)
	{
		out.println("</table></td></tr>");
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
finally
{
	rs.close();
	st.close();
}
%>

</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
