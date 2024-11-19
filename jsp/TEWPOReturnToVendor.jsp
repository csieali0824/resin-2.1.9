<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
}
</STYLE>
<title>TEW Return to Vendor Query</title>
</head> 
<FORM ACTION="../jsp/TEWPOReturnToVendor.jsp" METHOD="post" NAME="MYFORMD" >
<%
String seqid=request.getParameter("seqid");
int i=0;
try
{
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(" select PO_LINE_LOCATION_ID,to_char(CREATION_DATE,'yyyy-mm-dd') CREATION_DATE,(OLD_RECEIVED_QUANTITY-NEW_RECEIVED_QUANTITY) RETURN_QTY,REMARK,CREATED_BY"+
                                        " from  oraddman.tewpo_receive_revise where nvl(APPROVE_FLAG,'N')='Y' AND CHANGE_TYPE='1' AND SEQ_ID ='"+seqid+"' order by CREATION_DATE ");
    while (rs.next())
    {
		if (i==0)
		{
		%>
			  <table cellspacing="0" bordercolordark="#999999" cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
				 <tr bgcolor="#CCCCCC">
				 	<td width="20%">退貨日期</td>
					<td width="20%">退貨數量</td>
					<td width="40%">退貨原因</td>
					<td width="20%">申請人</td>
				 </tr>
		<%
		}
		%>
				<tr>
					<td><%=rs.getString("CREATION_DATE")%></td>
					<td><%=rs.getString("RETURN_QTY")%></td>
					<td><%=rs.getString("REMARK")%></td>
					<td><%=rs.getString("CREATED_BY")%></td>
				</tr>
		<%
		i++;
    } 
	if (i>0)
	{
%>
	</table>
<%
	}
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%> 
</form>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

