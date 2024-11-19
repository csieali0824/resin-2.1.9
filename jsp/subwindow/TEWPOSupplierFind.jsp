<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String SEARCHSTR= request.getParameter("SEARCHSTR");
if (SEARCHSTR==null ) SEARCHSTR="";
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Supplier List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(vSiteID,vName)
{
	window.opener.document.MYFORM.SUPPLIER.value = vName;
	window.opener.document.MYFORM.SUPPLIERSITEID.value = vSiteID;
	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TEWPOSupplierFind.jsp" NAME="SUBFORM">
<table>
	<tr>
		<td>
			<table>
				<tr>
					<td style="font-family:arial;font-size:12px">Supplier Name:</td>
					<td><input type="text" name="SUPPLIER" style="font-family:arial" value="<%=SEARCHSTR%>"><input type="hidden" name="ORGCODE" value="<%=ORGCODE%>"></td>
					<td><input type="submit" name="submit" value="Query" style="font-family:arial"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<%     
				try
				{ 
					sql = " SELECT distinct D.SEGMENT1 vendor_code,F.VENDOR_SITE_CODE,F.INVOICE_CURRENCY_CODE CURRENCY_CODE,D.vendor_name,F.vendor_site_id"+
						  " FROM PO.PO_HEADERS_ALL A,PO.PO_LINES_ALL B,PO.PO_LINE_LOCATIONS_ALL C,AP.AP_SUPPLIERS D ,INV.MTL_SYSTEM_ITEMS_B E,AP.AP_SUPPLIER_SITES_ALL F"+
						  " WHERE A.ORG_ID =?"+
						  " AND A.ORG_ID=B.ORG_ID"+
						  " AND B.ORG_ID=C.ORG_ID"+
						  " AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
						  " AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
						  " AND B.PO_LINE_ID = C.PO_LINE_ID"+
						  " AND nvl(A.approved_flag, 'N') = 'Y' "+
						  " AND nvl(A.cancel_flag,'N') = 'N'"+
						  " AND NVL(A.closed_code,'') NOT LIKE '%CLOSED%'"+
						  " AND nvl(B.cancel_flag,'N') = 'N'"+
						  " AND NVL(B.closed_code,'') <> 'CLOSED'"+
						  " AND NVL(B.closed_flag,'N') <> 'Y'"+
						  " AND NVL(C.cancel_flag,'N') <> 'Y' "+
						  " AND nvl(C.CLOSED_CODE,'') NOT LIKE  '%CLOSED%'"+
						  " AND C.quantity - NVL (C.quantity_received, 0) > 0";
					if (ORGCODE.equals(""))
					{
						sql += " AND C.ship_to_organization_id in (49,566)";
					}
					else
					{
						sql += " AND C.ship_to_organization_id =" + ORGCODE+"";
					}
					sql +=" AND A.vendor_id = D.vendor_id"+
						  " AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
						  " AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID"+
						  " AND length(E.SEGMENT1)=?"+
						  " AND D.VENDOR_ID = F.VENDOR_ID"+
						  " AND D.VENDOR_NAME LIKE '%"+SEARCHSTR+"%'"+
						  " AND (D.END_DATE_ACTIVE IS NULL OR D.END_DATE_ACTIVE < trunc(sysdate))"+
						  " AND exists (select 1 from po.po_agents x where x.agent_id = a.agent_id and x.attribute1='TEW') "+
						  " AND F.INVOICE_CURRENCY_CODE=?"+
						  " ORDER BY 1";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"41");
					//statement.setString(2,ORGCODE);
					statement.setString(2,"22");
					statement.setString(3,"USD");
					ResultSet rs=statement.executeQuery();
					out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
					out.println("<TR bgcolor='#cccccc'><TH style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
					out.println("<TH style='font-size:12px;font-family:arial'>VENDOR CODE</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>VENDOR SITE</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>CURRENCY CODE</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>VENDOR NAME</TH>");
					out.println("</TR>");
					int vline=0;
					while (rs.next())
					{
						vline++;
						out.println("<TR id='tr_"+vline+"'>");
						out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick=setSubmit('"+rs.getString(5)+"','"+rs.getString(2)+"');></TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(1)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(2)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(3)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(4)+"</TD>");
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();  
					statement.close();  
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
