<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
 
<%
	String line_no=request.getParameter("line_no");
	String keyID=request.getParameter("ID");
	String status=request.getParameter("status");
	if (status==null) status="OPEN";
	String p_Line_Type = "";
	String p_Line_Type_Name = "";
	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	cs1.execute();
	cs1.close();
%>
<html>
<head>
<title>Page for choose Line Type</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	window.opener.document.form1.action=URL;
 	window.opener.document.form1.submit(); 
 	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1">
<TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Line Type Select:</strong></font>
</TD>
<br>
<br>
<%  
    out.println("<table width='300' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
	out.println("<tr bgcolor='#EEEEEE'>");
	out.println("<td width='40'><font size='2'>&nbsp;</font></td>");
	out.println("<td width='60'><font size='2'>Line Type ID</font></td>");
	out.println("<td width='200'><font size='2'>Line Type Name</font></td>");
    out.println("</tr>");
	try
	{ 
 		String sql = "Select LINE_TYPE_ID, LINE_TYPE from APPS.OE_WF_LINE_ASSIGN_V group by  LINE_TYPE_ID, LINE_TYPE";
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql);
		while(rs.next())
		{
			p_Line_Type = rs.getString("LINE_TYPE_ID");
			p_Line_Type_Name = rs.getString("LINE_TYPE");
			out.println("<tr bgcolor='#E6FFE6'>");
			if (status.toUpperCase().equals("CLOSED"))
			{
				out.println("<td><input type='button' value='Set' disabled></td>");
			}
			else
			{
				out.println("<td><input type='button' value='Set'  onClick='setSubmit("+'"'+"../jsp/Tsc1211SpecialCustConfirm.jsp?ID="+java.net.URLEncoder.encode(keyID)+"&v_line_no="+line_no+"&p_Line_Type="+p_Line_Type+'"'+")' ></td>");
			}
			out.println("<td><div align='left'><font size='2'>"+p_Line_Type+"</font></div></td>");
			out.println("<td><div align='left'><font size='2'>"+p_Line_Type_Name+"</font></div></td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
	}
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());
	}
 	out.println("</table>");
    %>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
 </body>
</html>
