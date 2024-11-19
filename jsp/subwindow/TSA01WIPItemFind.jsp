<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String ID = request.getParameter("ID");
if (ID == null) ID="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
%>
<html>
<head>
<title></title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow()
{ 
	window.opener.document.MYFORM.elements["ITEM_NAME_T_"+document.SUBVNDFORM.ID.value].value = document.SUBVNDFORM.ITEM.value;        
	window.opener.document.MYFORM.elements["ITEM_ID_"+document.SUBVNDFORM.ID.value].value = document.SUBVNDFORM.ITEMID.value;        
	window.opener.document.MYFORM.elements["ITEM_DESC_"+document.SUBVNDFORM.ID.value].value = document.SUBVNDFORM.ITEMDESC.value;        
	window.opener.document.MYFORM.elements["UOM_"+document.SUBVNDFORM.ID.value].value = document.SUBVNDFORM.UOM.value;  
	window.opener.document.MYFORM.elements["LEVEL1_VALUE_"+document.SUBVNDFORM.ID.value].focus();      
  	this.window.close();
}

</script>
<body>  
<FORM action="TSA01WIPItemFind.jsp" METHOD="post" NAME="SUBVNDFORM">
<input type="hidden" name="ID" value="<%=ID%>">
<input type="hidden" name="ITEM" value="<%=ITEM%>">
<input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<% 
try
{
	Statement statement=con.createStatement();
  	String sql  ="select inventory_item_id,description,primary_uom_code from inv.mtl_system_items_b a where organization_id="+ ORGANIZATION_ID+" and segment1='"+ITEM+"'";   
	//out.println(sql);				 
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
	%>
		<input type="hidden" name="ITEMID" value="<%=rs.getString(1)%>">
		<input type="hidden" name="ITEMDESC" value='<%=rs.getString(2)%>'>
		<input type="hidden" name="UOM" value="<%=rs.getString(3)%>">
	<%			 
	}
	else
	{
	%>
		<script LANGUAGE="JavaScript">	
			window.opener.document.MYFORM.elements["ITEM_NAME_T_"+document.SUBVNDFORM.ID.value].value = "";        
			window.opener.document.MYFORM.elements["ITEM_ID_"+document.SUBVNDFORM.ID.value].value = "";        
			window.opener.document.MYFORM.elements["ITEM_DESC_"+document.SUBVNDFORM.ID.value].value = "";        
			window.opener.document.MYFORM.elements["UOM_"+document.SUBVNDFORM.ID.value].value = ""; 	
		</script>
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
