<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - Histories</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";

String trx_id=request.getParameter("trx_id");  
String type=request.getParameter("type");  
%>
<body>
<%
//取得料品領用明細
sql="";
if (type.indexOf("issued")>=0) //已發料
{
	sql=sql+"SELECT   msib.segment1, msib.description, mtln.lot_number, ";
	sql=sql+"         mtln.primary_quantity, msib.primary_uom_code ";
	sql=sql+"    FROM mtl_transaction_lot_numbers mtln, mtl_system_items_b msib ";
	sql=sql+"   WHERE mtln.organization_id = msib.organization_id ";
	sql=sql+"     AND mtln.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND mtln.transaction_id = "+trx_id+" ";
	sql=sql+"ORDER BY mtln.transaction_date ";
}
else //簽核中
{
	sql=sql+"SELECT   msib.segment1, msib.description, ywml.lot_number, ";
	sql=sql+"         ywml.transaction_quantity primary_quantity, msib.primary_uom_code ";
	sql=sql+"    FROM yew_wip_mtl_lots ywml, mtl_system_items_b msib ";
	sql=sql+"   WHERE ywml.organization_id = msib.organization_id ";
	sql=sql+"     AND ywml.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND ywml.trx_id = "+trx_id+" ";
	sql=sql+"ORDER BY ywml.creation_date ";
}
statement=con.createStatement();
rs=statement.executeQuery(sql); 
%>

 
    <table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td align="center" bgcolor="silver">
                Item</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                LOT</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Quantity</td>
        </tr>
<%
while (rs.next())
{
%>
        <tr>
            <td nowrap="nowrap">
                <%=rs.getString("segment1")%></td>
            <td>
                <%=rs.getString("description")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("lot_number")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("primary_uom_code")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("primary_quantity")%></td>
        </tr>
<%
} //end of while	
%>
    </table>
    <br />
	<input id="Button2" type="button" value="Close" onClick="window.close();" />
<%
rs.close();       
statement.close();
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

