<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - Transaction Reasons</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";
int i;
String num=request.getParameter("num");
if (num==null) num="";
String reason=request.getParameter("reason");
if (reason==null) reason="";
%>

<script language="JavaScript" type="text/JavaScript">
function SendData(reason_id,reason)
{    
	if (reason_id.length==0)
		if (!confirm('是否清空Reason?')) return false;
	window.opener.MYFORM.reason_id<%=num%>.value = reason_id;
	window.opener.MYFORM.reason<%=num%>.value = reason;
	window.close();
} 
</script>

<body>
<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST"> 
    <input type="hidden" name="num" value="<%=num%>" />
    <input id="Text1" type="text" name="reason" value="<%=reason%>" />
    <input id="Submit1" type="submit" value="Find" /><br />
    <br />
<%
sql="";
sql=sql+"SELECT reason_id, reason_name, description ";
sql=sql+"  FROM mtl_transaction_reasons ";
sql=sql+" WHERE (disable_date >= SYSDATE OR disable_date IS NULL) ";
sql=sql+"   AND reason_name LIKE '"+reason+"%' ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
i=0;
%>
    <table border="1" cellspacing="0" bordercolor="#000000">
        <tr>
            <td align="center" bgcolor="silver">
                Reason</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">&nbsp;
                </td>
        </tr>
        <tr>
            <td>
                <input id="reason_id<%=i%>" type="hidden" name="reason_id<%=i%>" value="" />
				<input id="reason<%=i%>" type="hidden" name="reason<%=i%>" value="" />
                (清空Reason)</td>
            <td>&nbsp;
                </td>
            <td>
                <input id="Button<%=i%>" type="button" value="Clean" onClick="SendData(reason_id<%=i%>.value,reason<%=i%>.value);" /></td>
        </tr>
<%
while (rs.next())
{ 
	i++;           
%>
        <tr>
            <td>
                <input id="reason_id<%=i%>" type="hidden" name="reason_id<%=i%>" value="<%=rs.getString("reason_id")%>" />
				<input id="reason<%=i%>" type="hidden" name="reason<%=i%>" value="<%=rs.getString("reason_name")%>" />
				<%=rs.getString("reason_name")%></td>
            <td>
                <%=rs.getString("description")%></td>
            <td>
                <input id="Button1" type="button" value="Select" onClick="SendData(reason_id<%=i%>.value,reason<%=i%>.value);" /></td>
        </tr>
<%
} //end of while	
%>
    </table>
<%
rs.close();       
statement.close();
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

