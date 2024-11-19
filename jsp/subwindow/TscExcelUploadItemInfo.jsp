<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String CustomerID=request.getParameter("CUSTOMERID");
String CustItem=request.getParameter("CUSTITEM");
if (CustItem==null) CustItem="";
String ItemDesc=request.getParameter("ITEMDESC");
if (ItemDesc==null) ItemDesc="";
String LineID=request.getParameter("LINEID");
%>
<html>
<head>
<title>Page for choose Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(LineID,ItemName,ItemDesc,UOM)
{
	window.opener.document.form1.elements["itemdesc"+LineID].value=ItemDesc;
	window.opener.document.form1.elements["itemname"+LineID].value=ItemName;
	window.opener.document.form1.elements["uom"+LineID].value==UOM;
  	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TscExcelUploadCustInfo.jsp" NAME=CUSTFORM>
<BR>
<%     
int QryCnt = 0;
String sql = "";
String buttonContent=null;
String trBgColor = "";
String TSCItem="",TSCItemDesc="",UOM="";
Statement statement=con.createStatement();
try
{ 
	CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	cs1.execute();
	cs1.close();

	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	

	sql = " select a.ITEM,ITEM_ID,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
		  " a.INVENTORY_ITEM, a.ITEM_IDENTIFIER_TYPE, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE,msi.attribute3 "+
		  ",tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_Package') TSC_PACKAGE"+
		  " from oe_items_v  a,inv.mtl_system_items_b msi "+
		  " where a.SOLD_TO_ORG_ID = '"+CustomerID +"' "+
		  " and a.ITEM ='" + CustItem + "'";
    //if (!CustItem.equals("")) sql += " and a.ITEM ='" + CustItem + "'";
	if (!ItemDesc.equals("")) sql +=  " and a.ITEM_DESCRIPTION = '"+ItemDesc+"'";
	sql += " and a.organization_id = msi.organization_id and a.inventory_item_id = msi.inventory_item_id";
	//out.println(sql);
	ResultSet rs=statement.executeQuery(sql);	
	while (rs.next())
	{	
		if (QryCnt==0)
		{
			out.println("<TABLE width='100%'>");      
			out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>TSC Item</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Item Desc</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>UOM</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Plant Code</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>TSC Package</TH>");
			out.println("</TR>");
		}
		TSCItem=rs.getString("INVENTORY_ITEM");
		TSCItemDesc=rs.getString("ITEM_DESCRIPTION");
		UOM=rs.getString("PRIMARY_UOM_CODE");
		trBgColor = "E3E3CF"; 
		buttonContent="this.value=sendToMainWindow("+'"'+LineID+'"'+","+'"'+TSCItem+'"'+","+'"'+TSCItemDesc+'"'+","+'"'+UOM+'"'+")";		
		out.println("<TR BGCOLOR='"+trBgColor+"'>");
		out.println("<TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%out.println("' onClick='"+buttonContent+"'></TD>");		
		out.println("<TD><FONT SIZE=2>"+TSCItem+"</TD>");
		out.println("<TD><FONT SIZE=2>"+TSCItemDesc+"</TD>");
		out.println("<TD><FONT SIZE=2>"+UOM+"</TD>");
		out.println("<TD><FONT SIZE=2>"+rs.getString("attribute3")+"</TD>");
		out.println("<TD><FONT SIZE=2>"+rs.getString("TSC_PACKAGE")+"</TD>");
		out.println("</TR>");
		QryCnt++;
	}
	if (QryCnt >0)
	{
		out.println("</TABLE>");
	}						
	else
	{
		sql = "  select  DISTINCT msi.DESCRIPTION ITEM_DESCRIPTION,msi.INVENTORY_ITEM_ID, msi.segment1 INVENTORY_ITEM, msi.PRIMARY_UOM_CODE,msi.attribute3 "+
		      ",tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_Package') TSC_PACKAGE"+
              " from inv.mtl_system_items_b msi "+
			  " where 1=1"+
			  " and msi.organization_id=49";
		if (!ItemDesc.equals("")) sql +=  " and msi.DESCRIPTION = '"+ItemDesc+"'";
		Statement statementx=con.createStatement();
		ResultSet rsx=statementx.executeQuery(sql);	
		while (rsx.next())
		{	
			if (QryCnt==0)
			{
				out.println("<TABLE>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>TSC Item</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Item Desc</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>UOM</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Plant Code</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>TSC Package</TH>");
				out.println("</TR>");
			}
			TSCItem=rsx.getString("INVENTORY_ITEM");
			TSCItemDesc=rsx.getString("ITEM_DESCRIPTION");
			UOM=rsx.getString("PRIMARY_UOM_CODE");
			trBgColor = "E3E3CF"; 
			buttonContent="this.value=sendToMainWindow("+'"'+LineID+'"'+","+'"'+TSCItem+'"'+","+'"'+TSCItemDesc+'"'+","+'"'+UOM+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'>");
			out.println("<TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("<TD><FONT SIZE=2>"+TSCItem+"</TD>");
			out.println("<TD><FONT SIZE=2>"+TSCItemDesc+"</TD>");
			out.println("<TD><FONT SIZE=2>"+UOM+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rsx.getString("attribute3")+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rsx.getString("TSC_PACKAGE")+"</TD>");
			out.println("</TR>");
			QryCnt++;
		}
		
		if (QryCnt >0)
		{
			out.println("</TABLE>");
		}						
		else
		{
			out.println("<font color='red'>No Data found!</font>");
		}
		rsx.close();
		statementx.close();
	} 
	rs.close(); 
	
	sql1="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE'";     
	pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
}
catch(Exception e)
{
	out.println("Exception"+e.getMessage());
}
finally
{
	statement.close();
}
if (QryCnt ==1)
{
	out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+LineID+'"'+","+'"'+TSCItem+'"'+","+'"'+TSCItemDesc+'"'+","+'"'+UOM+'"'+")</script>"); 
}		
%>
<BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
