<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - Item</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";
int i;
String num=request.getParameter("num");
String wipid=request.getParameter("wipid");
%>

<script language="JavaScript" type="text/JavaScript">
function SendData(op_seq,dept_id,dept_code)
{    
	window.opener.MYFORM.op_seq<%=num%>.value = op_seq;
	window.opener.MYFORM.dept_id<%=num%>.value = dept_id;
	window.opener.MYFORM.dept_code<%=num%>.value = dept_code;
	window.close();
}
</script>

<body>
<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST"> 
<%
//工令站別資訊
sql="";
sql=sql+"SELECT wo.wip_entity_id, wo.operation_seq_num, wo.organization_id, ";
sql=sql+"       wo.department_id, bd.department_code, wo.description ";
sql=sql+"  FROM wip_operations wo, bom_departments bd ";
sql=sql+" WHERE bd.department_id = wo.department_id AND wo.wip_entity_id = "+wipid+" ";
sql=sql+"ORDER BY operation_seq_num ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
i=0;
%>
    <table border="1" cellspacing="0" bordercolor="#000000">
        <tr>
            <td align="center" bgcolor="silver">
                Operation Seq</td>
            <td align="center" bgcolor="silver">
                Department</td>
            <td align="center" bgcolor="silver">&nbsp;
                </td>
        </tr>
<%
while (rs.next())
{ 
	i++;
%>
        <tr>
            <td>
				<%%>
				<input id="op_seq<%=i%>" type="hidden" name="op_seq<%=i%>" value="<%=rs.getString("operation_seq_num")%>" />
				<%=rs.getString("operation_seq_num")%></td>
            <td>
				<input id="dept_id<%=i%>" type="hidden" name="dept_id<%=i%>" value="<%=rs.getString("department_id")%>" />
				<input id="dept_code<%=i%>" type="hidden" name="dept_code<%=i%>" value="<%=rs.getString("department_code")%>" />
                <%=rs.getString("department_code")%></td>
            <td>
				<input id="Button<%=i%>" type="button" value="Select" onClick="SendData(op_seq<%=i%>.value,dept_id<%=i%>.value,dept_code<%=i%>.value);" /></td>
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

