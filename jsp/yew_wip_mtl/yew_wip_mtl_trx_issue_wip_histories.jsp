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

String wono=request.getParameter("wono");  
if (wono==null) wono="";
String wipid=request.getParameter("wipid");  
if (wipid==null) wipid="";
%>
<body>
    Job: <%=wono%><br />
    <br />
<%
//取得工令領料數量(含簽核中)
sql="";
sql=sql+"SELECT   wrov.inventory_item_id, wrov.concatenated_segments, ";
sql=sql+"         wrov.item_description, wrov.item_primary_uom_code, ";
sql=sql+"         wrov.required_quantity, ";
sql=sql+"         TO_NUMBER (NVL (wrov.quantity_issued, '0')) quantity_issued, ";
sql=sql+"         ABS (NVL (ywm.process_qty, 0)) quantity_process, ";
sql=sql+"         CASE ";
sql=sql+"            WHEN (  (  TO_NUMBER (NVL (wrov.quantity_issued, '0')) ";
sql=sql+"                     + ABS (NVL (ywm.process_qty, 0)) ";
sql=sql+"                    ) ";
sql=sql+"                  - wrov.required_quantity ";
sql=sql+"                 ) > 0 ";
sql=sql+"               THEN (  (  TO_NUMBER (NVL (wrov.quantity_issued, '0')) ";
sql=sql+"                        + ABS (NVL (ywm.process_qty, 0)) ";
sql=sql+"                       ) ";
sql=sql+"                     - wrov.required_quantity ";
sql=sql+"                    ) ";
sql=sql+"            ELSE 0 ";
sql=sql+"         END quantity_excess ";
sql=sql+"    FROM wip_entities we, ";
sql=sql+"         wip_requirement_operations_v wrov, ";
sql=sql+"         mtl_system_items_b msib, ";
sql=sql+"         (SELECT   wip_entity_id, organization_id, inventory_item_id, ";
sql=sql+"                   SUM (transaction_quantity) process_qty ";
sql=sql+"              FROM yew_wip_mtl_trx ";
sql=sql+"             WHERE closed_code = 'OPEN' ";
sql=sql+"          GROUP BY wip_entity_id, organization_id, inventory_item_id) ywm ";
sql=sql+"   WHERE wrov.wip_entity_id = we.wip_entity_id ";
sql=sql+"     AND wrov.inventory_item_id = msib.inventory_item_id ";
sql=sql+"     AND wrov.organization_id = msib.organization_id ";
sql=sql+"     AND wrov.wip_entity_id = ywm.wip_entity_id(+) ";
sql=sql+"     AND wrov.organization_id = ywm.organization_id(+) ";
sql=sql+"     AND wrov.inventory_item_id = ywm.inventory_item_id(+) ";
sql=sql+"     AND wrov.routing_exists_flag = 1 ";
sql=sql+"     AND wrov.wip_entity_id = "+wipid+" ";
sql=sql+"UNION ";
sql=sql+"SELECT   ywmt.inventory_item_id, msib.segment1, msib.description, ";
sql=sql+"         msib.primary_uom_code, 0 required_quantity, 0 quantity_issued, ";
sql=sql+"         ABS (SUM (ywmt.transaction_quantity)) quantity_process, ";
sql=sql+"         ABS (SUM (ywmt.transaction_quantity)) quantity_excess ";
sql=sql+"    FROM yew_wip_mtl_trx ywmt, mtl_system_items_b msib ";
sql=sql+"   WHERE ywmt.inventory_item_id = msib.inventory_item_id ";
sql=sql+"     AND ywmt.organization_id = msib.organization_id ";
sql=sql+"     AND ywmt.closed_code = 'OPEN' ";
sql=sql+"     AND ywmt.inventory_item_id NOT IN ( ";
sql=sql+"            SELECT inventory_item_id ";
sql=sql+"              FROM wip_requirement_operations_v ";
sql=sql+"             WHERE routing_exists_flag = 1 ";
sql=sql+"               AND wip_entity_id = ywmt.wip_entity_id) ";
sql=sql+"     AND ywmt.wip_entity_id = "+wipid+" ";
sql=sql+"GROUP BY ywmt.inventory_item_id, ";
sql=sql+"         ywmt.organization_id, ";
sql=sql+"         msib.segment1, ";
sql=sql+"         msib.description, ";
sql=sql+"         msib.primary_uom_code ";
sql=sql+"ORDER BY 2 ";
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
                UOM</td>
            <td align="center" bgcolor="silver">
                Required</td>
            <td align="center" bgcolor="silver">
                Issued</td>
            <td align="center" bgcolor="silver">
                Process</td>
            <td align="center" bgcolor="silver">
                Excess</td>
        </tr>
<%
while (rs.next())
{
%>
        <tr>
            <td nowrap="nowrap">
                <%=rs.getString("concatenated_segments")%></td>
            <td>
                <%=rs.getString("item_description")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("item_primary_uom_code")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("required_quantity")%></td>
            <td nowrap="nowrap">
                <a href="yew_wip_mtl_trx_issue_wip_histories_d.jsp?wipid=<%=wipid%>&itemid=<%=rs.getString("inventory_item_id")%>&type=issued">
				<%=rs.getString("quantity_issued")%></a></td>
            <td nowrap="nowrap">
                <a href="yew_wip_mtl_trx_issue_wip_histories_d.jsp?wipid=<%=wipid%>&itemid=<%=rs.getString("inventory_item_id")%>&type=process">
				<%=rs.getString("quantity_process")%></a></td>
            <td nowrap="nowrap">
                <%if (rs.getFloat("quantity_excess")>0) {%><font color="#FF0000" ><%}%>
				<%=rs.getString("quantity_excess")%>
				<%if (rs.getFloat("quantity_excess")>0) {%></font><%}%></td>
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

