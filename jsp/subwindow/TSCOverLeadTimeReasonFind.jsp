<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String sql = "";
String LINENO = request.getParameter("LINENO");
if (LINENO==null) LINENO="";
String VENDOR_SITE_CODE="",VENDOR_SITE_ID="";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(v_reason)
{ 
	window.opener.document.DISPLAYREPAIR.elements["OVER_LT_"+document.SITEFORM.LINENO.value].value=v_reason;
  	this.window.close();
}
</script>
<title>Over Lead Time Reason List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCOverLeadTimeReasonFind.jsp" NAME="SITEFORM">
<input type="hidden" name="LINENO" value="<%=LINENO%>">
<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		sql = " select DATE_VALUE FROM oraddman.tsprod_manufactory_setup WHERE DATA_TYPE='OVER_LEAD_TIME_REASON' AND STATUS='A' ";
		if (UserRoles.indexOf("admin")>=0) sql += " and (ATTRIBUTE1 is null or ATTRIBUTE1 ='"+userProdCenterNo+"')";
		sql +=" order by DATE_VALUE";
		ResultSet rs=statement.executeQuery(sql);
		int rec_cnt=0;
		while (rs.next())
		{
			if (rec_cnt==0)
			{
%>			
				<TABLE width="80%" border="1" bordercolor="#0099CC" style="font-family:ARIAL;font-size:12px">
					<TR bgcolor="#CCCCCC">
						<TD width="10%">&nbsp;</TD>        
						<TD width="90%">Over L/T Reason</TD>        
					</TR>
<%
			}
%>
			<tr>
				<td><INPUT TYPE="button" NAME="btn<%=rec_cnt+1%>" VALUE='<jsp:getProperty name="rPH" property="pgFetch"/>' onClick="sendToMainWindow('<%=rs.getString("DATE_VALUE")%>')"></TD>
				<td><%=rs.getString("DATE_VALUE")%></td>
			</tr>
<%
			rec_cnt++;	
		}
		rs.close();       
		if (rec_cnt>0)
		{
%>		
			</TABLE>
<%
		}
		else
		{
			out.println("<font color='red'>查無資料!!!</font>");
		}
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
 <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
