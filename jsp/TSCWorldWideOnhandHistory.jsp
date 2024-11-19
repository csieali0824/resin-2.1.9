<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
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
<font  style="font-weight:bold;font-family:'Tahoma,Georgia';color:#003399;font-size:24px" >TSC ���~�w�s���v�W�ǩ���</font>
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
    							<TD width="10%"  height="70%" class="style13" title="�^����!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#000000">
									<STRONG>�^����</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>
					<TD width="10%" class="style15">
						<STRONG>�W�Ǿ��{</STRONG>
					</TD>
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="�Ы��ڶi�J�w�s�d�ߥ\��!">
									<A HREF="TSCWorldWideOnhandQuery.jsp" style="text-decoration:none;color:#000000">
									<STRONG>�w�s�d��</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>					
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="�Ы��ڶi�J��ƤW�ǥ\��!">
									<A HREF="TSCWorldWideOnhandUpload.jsp" style="text-decoration:none;color:#000000">
									<STRONG>��ƤW��</STRONG>
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
	      ", VERSION_FLAG,case VERSION_FLAG when 'A' then '����' when 'I' then '����' when 'T' then '��Ƨ�s��' else '��Ʋ��`' end as VERSION_STATUS,SOURCE_FILE "+
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
			out.println("<td class='style1'>����</td>");
			out.println("<td class='style1' style='text-align:center;'>�������A</td>");
			out.println("<td class='style1'>��Ƶ���</td>");
			out.println("<td class='style1' style='text-align:center;'>�W���ɮ�</td>");
			out.println("<td class='style1' style='text-align:center;'>��s�H��</td>");
			out.println("<td class='style1' style='text-align:center;'>��s���</td>");
			out.println("</tr>");
		}
		out.println("<tr style='background-color:#CCCCCC;font-family:Tahoma,Georgia;font-size:13px;'>");
		out.println("<td>"+rs.getString("VERSION_ID") + "</td>");
		if (rs.getString("VERSION_FLAG").equals("T"))
		{
			out.println("<td title='��Ƨ�s��...' style='text-align:center;'><img src='images/lang.gif' border='0' width='20' height='20'></td>");
		}
		else if (rs.getString("VERSION_FLAG").equals("A"))
		{
			out.println("<td title='���ĸ��' style='text-align:center;'><img src='images/not.gif' border='0' width='20' height='20'></td>");
		}
		else
		{
			out.println("<td title='��Ƥw����' style='text-align:center;'><img src='images/cross.gif' border='0' width='20' height='20'></td>");
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
<!--=============�H�U�Ϭq������s����==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
