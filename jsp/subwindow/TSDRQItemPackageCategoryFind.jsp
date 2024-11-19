<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String itemDesc=request.getParameter("ITEM_DESC");
String searchString=request.getParameter("SEARCHSTRING");
if (searchString==null) searchString=itemDesc;
%>
<html>
<head>
<title>TSC Item List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(item_id,item_name,item_desc,tsc_prod_group,tsc_family,tsc_package,tsc_prod_family,tsc_packing_code)
{ 
	window.opener.document.MYFORM.ITEM_ID.value=item_id;   
	window.opener.document.MYFORM.ITEM_NAME.value=item_name;  
	window.opener.document.MYFORM.ITEM_DESC.value=item_desc; 
	window.opener.document.MYFORM.ITEM_DESC1.value=item_desc; 
	window.opener.document.MYFORM.TSCFAMILY.value=tsc_family; 
	window.opener.document.MYFORM.TSCPRODFAMILY.value=tsc_prod_family; 
	window.opener.document.MYFORM.TSCPACKAGE.value=tsc_package; 
	window.opener.document.MYFORM.PACKAGECODE.value=tsc_packing_code; 
	window.opener.document.MYFORM.TSCPRODGROUP.value=tsc_prod_group;
  	this.window.close();
}
</script>
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
</STYLE>
<body onBlur="this.focus();">  
<FORM METHOD="post" ACTION="TSDRQItemPackageCategoryFind.jsp" name="ITEMFORM">
  <font size="-1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%> style="font-family: Tahoma,Georgia">
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>" style="font-family: Tahoma,Georgia"><BR>
  -----<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
<%  
int queryCount = 0;
String sql ="",buttonContent="";
String item_id="",item_name="",item_desc="",tsc_prod_group="",tsc_family="",tsc_package="",tsc_prod_family="",tsc_packing_code="";
try
{ 
	sql = " select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,"+
		  " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP,"+
		  " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Family') TSC_FAMILY,"+
		  " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_FAMILY') TSC_PROD_FAMILY,"+
		  " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') TSC_PACKAGE,"+
		  " TSC_GET_ITEM_PACKING_CODE(ORGANIZATION_ID,INVENTORY_ITEM_ID) TSC_PACKING_CODE"+
		  " from inv.mtl_system_items_b a"+
		  " where ORGANIZATION_ID=43 "+
		  " AND LENGTH(A.SEGMENT1)>=21"+
		  " AND UPPER(DESCRIPTION) NOT LIKE '%DISABLE%'"+
		  " AND A.INVENTORY_ITEM_STATUS_CODE <>'Inactive'";
	if (searchString!="" && searchString!=null) 
	{ 
		sql += " AND UPPER(DESCRIPTION) LIKE '%"+searchString.toUpperCase()+"%'";
	}
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next())
	{
		if (queryCount==0)
		{ 
			out.println("<TABLE width='100%' border='1'>");    
			out.println("<TR BGCOLOR=BLACK style='color:#ffffff'><TD width='3%'>&nbsp;</TD>");  
			out.println("<TD width='18%'>Item Name</TD>");
			out.println("<TD width='15%'>Item Desc</TD>");
			out.println("<TD width='15%'>TSC Prod Group</TD>");
			out.println("<TD width='15%'>TSC Family</TD>");
			out.println("<TD width='15%'>TSC Prod Family</TD>");
			out.println("<TD width='10%'>TSC Package</TD>");
			out.println("<TD width='7%'>TSC Packing Code</TD>");
			out.println("</tr>");
		}
		item_id=rs.getString("INVENTORY_ITEM_ID");
		item_name=rs.getString("SEGMENT1");
		item_desc=rs.getString("DESCRIPTION");
		tsc_prod_group=rs.getString("TSC_PROD_GROUP");
		tsc_family=rs.getString("TSC_FAMILY");
		tsc_package=rs.getString("TSC_PACKAGE");
		tsc_prod_family=rs.getString("TSC_PROD_FAMILY");
		tsc_packing_code=rs.getString("TSC_PACKING_CODE");
		out.println("<tr>");
		buttonContent="sendToMainWindow("+'"'+item_id+'"'+','+'"'+item_name+'"'+','+'"'+item_desc+'"'+","+'"'+tsc_prod_group+'"'+","+'"'+tsc_family+'"'+","+'"'+tsc_package+'"'+","+'"'+tsc_prod_family+'"'+","+'"'+tsc_packing_code+'"'+")";		
		out.println("<TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		out.println("' onClick='"+buttonContent+"'></TD>");		
		out.println("<td>"+item_name+"</td>");
		out.println("<td>"+item_desc+"</td>");
		out.println("<td>"+tsc_prod_group+"</td>");
		out.println("<td>"+tsc_family+"</td>");
		out.println("<td>"+tsc_prod_family+"</td>");
		out.println("<td>"+tsc_package+"</td>");
		out.println("<td>"+tsc_packing_code+"</td>");
		out.println("</tr>");
		queryCount++;
	}//end of while
	rs.close();       
	statement.close();
	if (queryCount>0)
	{
		out.println("</TABLE>");						
		if (queryCount==1) //若取到的查詢數 == 1
		{
			out.print("<script type=\"text/javascript\">"+buttonContent+"</script>"); 
		}
	}
} //end of try
catch (Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
<BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
