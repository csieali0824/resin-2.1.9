<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String objid=request.getParameter("objid");
if (objid==null) objid="";
String lineid=request.getParameter("lineid");
if (lineid==null) lineid="";
String CRD = request.getParameter("CRD");
if (CRD==null) CRD="";
%>
<html>
<head>
<title></title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow()
{ 
	window.opener.document.MYFORM.elements[document.SUBVNDFORM.objid.value].value = document.SUBVNDFORM.SSD.value;        
  	this.window.close();
}

</script>
<body>  
<FORM action="TSCHSalesOrderSSDFind.jsp" METHOD="post" NAME="SUBVNDFORM">
<input type="hidden" name="objid" value="<%=objid%>">
<input type="hidden" name="lineid" value="<%=lineid%>">
<input type="hidden" name="CRD" value="<%=CRD%>">

<% 
try
{
	Statement statement=con.createStatement();
  	String sql  ="select tsch_get_tsc_order_ssd("+lineid+",to_date('"+CRD+"','yyyymmdd'),'TSCH') from dual";   
	//out.println(sql);				 
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
	%>
		<font style="font-family: Tahoma,Georgia; color: #000000; font-size: 11px">TSC Order SSD:</font><input type="text" name="SSD" value="<%=rs.getString(1)%>" style="font-family: Tahoma,Georgia; color: #000000; font-size: 11px">
	<%			 
	}
	rs.close();       
	statement.close();

	%>
	<script LANGUAGE="JavaScript">	
	  sendToMainWindow();	
	</script>
   	<%
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
