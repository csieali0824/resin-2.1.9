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
Statement statement2;
ResultSet rs;
ResultSet rs2;
String sql="";
boolean LotFlag;

String itemid=request.getParameter("itemid");  
String wipid=request.getParameter("wipid");  
String type=request.getParameter("type");  
%>

<script language="JavaScript" type="text/JavaScript">
function OpenLot(trx_id,type)
{    
	subWinLot=window.open("yew_wip_mtl_trx_issue_wip_histories_d_lot.jsp?trx_id="+trx_id+"&type="+type,"subWinLot","width=450,height=200,status=yes,scrollbars=yes,resizable=yes");  
	subWinLot.focus();
} 

function CloseLot()
{    
	try {subWinLot.close();}
	catch(e) {}
} 
</script>

<body onUnload="CloseLot();">
<%
//取得料品領用明細
sql="";
if (type.indexOf("issued")>=0) //已發料
{
	sql=sql+"SELECT   mmt.transaction_source_id wip_entity_id, mmt.organization_id, ";
	sql=sql+"         mmt.subinventory_code, mmt.locator_id, mil.segment1 loc_segment1, ";
	sql=sql+"         mmt.operation_seq_num, mmt.department_id, bd.department_code, ";
	sql=sql+"         mmt.inventory_item_id, msib.segment1, msib.description, ";
	sql=sql+"         mmt.transaction_type_id, mtt.transaction_type_name, ";
	sql=sql+"         mmt.primary_quantity, msib.primary_uom_code, ";
	sql=sql+"         TO_CHAR (mmt.transaction_date, 'yyyy/mm/dd') trx_date, ";
	sql=sql+"         mmt.reason_id, mtr.reason_name, mmt.transaction_reference, ";
	sql=sql+"         mmt.attribute13, mmt.created_by, fu.user_name, '' action, ";
	sql=sql+"         '' action_code, '' action_date, '' closed_code, transaction_id trx_id ";
	sql=sql+"    FROM mtl_material_transactions mmt, ";
	sql=sql+"         mtl_system_items_b msib, ";
	sql=sql+"         mtl_item_locations mil, ";
	sql=sql+"         bom_departments bd, ";
	sql=sql+"         fnd_user fu, ";
	sql=sql+"         (SELECT transaction_type_id, transaction_type_name ";
	sql=sql+"            FROM mtl_transaction_types) mtt, ";
	sql=sql+"         (SELECT reason_id, reason_name, description ";
	sql=sql+"            FROM mtl_transaction_reasons ";
	sql=sql+"           WHERE (disable_date >= SYSDATE OR disable_date IS NULL)) mtr ";
	sql=sql+"   WHERE mmt.organization_id = msib.organization_id ";
	sql=sql+"     AND mmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND mmt.organization_id = mil.organization_id(+) ";
	sql=sql+"     AND mmt.subinventory_code = mil.subinventory_code(+) ";
	sql=sql+"     AND mmt.locator_id = mil.inventory_location_id(+) ";
	sql=sql+"     AND mmt.department_id = bd.department_id(+) ";
	sql=sql+"     AND mmt.created_by = fu.user_id ";
	sql=sql+"     AND mmt.transaction_type_id = mtt.transaction_type_id ";
	sql=sql+"     AND mmt.reason_id = mtr.reason_id(+) ";
	sql=sql+"     AND mmt.transaction_type_id IN (35, 43) ";
	sql=sql+"     AND mmt.transaction_source_id = "+wipid+" ";
	sql=sql+"     AND mmt.inventory_item_id = "+itemid+" ";
	sql=sql+"ORDER BY mmt.transaction_date ";
	}
else //簽核中
{
	sql=sql+"SELECT   ywmt.wip_entity_id, ywmt.organization_id, ywmt.subinventory_code, ";
	sql=sql+"         ywmt.locator_id, ywmt.loc_segment1, ywmt.operation_seq_num, ";
	sql=sql+"         ywmt.department_id, bd.department_code, ywmt.inventory_item_id, ";
	sql=sql+"         msib.segment1, msib.description, ywmt.transaction_type_id, ";
	sql=sql+"         mtt.transaction_type_name, ";
	sql=sql+"         ywmt.transaction_quantity primary_quantity, msib.primary_uom_code, ";
	sql=sql+"         TO_CHAR (ywmt.creation_date, 'yyyy/mm/dd') trx_date, ";
	sql=sql+"         ywmt.reason_id, mtr.reason_name, ywmt.transaction_reference, ";
	sql=sql+"         mmt.attribute13, ywmt.created_by, fu.user_name, ";
	sql=sql+"         CASE action_sequence_num ";
	sql=sql+"            WHEN 0 ";
	sql=sql+"               THEN '領料'||action_code ";
	sql=sql+"            WHEN 10 ";
	sql=sql+"               THEN '產線主管'||action_code ";
	sql=sql+"            WHEN 20 ";
	sql=sql+"               THEN '物管'||action_code ";
	sql=sql+"            WHEN 30 ";
	sql=sql+"               THEN '倉庫'||action_code ";
	sql=sql+"         END action, ";
	sql=sql+"         TO_CHAR (ywmt.action_date, 'yyyy/mm/dd') action_date, ";
	sql=sql+"         closed_code, ywmt.trx_id ";
	sql=sql+"    FROM yew_wip_mtl_trx ywmt, ";
	sql=sql+"         mtl_system_items_b msib, ";
	sql=sql+"         bom_departments bd, ";
	sql=sql+"         fnd_user fu, ";
	sql=sql+"         mtl_material_transactions mmt, ";
	sql=sql+"         (SELECT transaction_type_id, transaction_type_name ";
	sql=sql+"            FROM mtl_transaction_types) mtt, ";
	sql=sql+"         (SELECT reason_id, reason_name, description ";
	sql=sql+"            FROM mtl_transaction_reasons ";
	sql=sql+"           WHERE (disable_date >= SYSDATE OR disable_date IS NULL)) mtr ";
	sql=sql+"   WHERE ywmt.organization_id = msib.organization_id ";
	sql=sql+"     AND ywmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND ywmt.department_id = bd.department_id ";
	sql=sql+"     AND ywmt.created_by = fu.user_id ";
	sql=sql+"     AND ywmt.transaction_type_id = mtt.transaction_type_id ";
	sql=sql+"     AND ywmt.reason_id = mtr.reason_id(+) ";
	sql=sql+"     AND ywmt.transaction_set_id = mmt.transaction_set_id(+) ";
	sql=sql+"     AND ywmt.wip_entity_id = "+wipid+" ";
	sql=sql+"     AND ywmt.inventory_item_id = "+itemid+" ";
	sql=sql+"ORDER BY ywmt.creation_date ";
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
                Transaction type</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Quantity</td>
            <td align="center" bgcolor="silver">
                SubInv</td>
            <td align="center" bgcolor="silver">
                Locator</td>
            <td align="center" bgcolor="silver">
                Op Seq</td>
            <td align="center" bgcolor="silver">
                Dept</td>
            <td align="center" bgcolor="silver">
                Lot</td>
            <td align="center" bgcolor="silver">
                Reason</td>
            <td align="center" bgcolor="silver">
                Reference</td>
            <td align="center" bgcolor="silver" nowrap="nowrap">
                WIP領料(退庫)單</td>
            <td align="center" bgcolor="silver">
                <%if (type.indexOf("issued")>=0) {%>Transaction<%}else{%>Submit<%}%> date</td>
            <td align="center" bgcolor="silver">
                Action</td>
            <td align="center" bgcolor="silver">
                Action Date</td>
            <td align="center" bgcolor="silver">
                Status</td>
        </tr>
<%
while (rs.next())
{
	LotFlag = false;
	if (type.indexOf("issued")>=0)
	{
		sql="SELECT COUNT (transaction_id) FROM mtl_transaction_lot_numbers WHERE transaction_id = "+rs.getString("trx_id");
	}
	else
	{
		sql="SELECT COUNT (trx_id) FROM yew_wip_mtl_lots WHERE trx_id = "+rs.getString("trx_id");
	}
	statement2=con.createStatement();
	rs2=statement2.executeQuery(sql); 
	if (rs2.next())
	{
		if (rs2.getInt(1)>0) LotFlag = true;
	}
	rs2.close();       
	statement2.close();
%>
        <tr>
            <td nowrap="nowrap">
                <%=rs.getString("segment1")%></td>
            <td>
                <%=rs.getString("description")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("transaction_type_name")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("primary_uom_code")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("primary_quantity")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("subinventory_code")%></td>
            <td nowrap="nowrap">
                <%if (rs.getString("loc_segment1") != null) {%><%=rs.getString("loc_segment1")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%=rs.getString("operation_seq_num")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("department_code")%></td>
            <td nowrap="nowrap">
                <%if (LotFlag) {%><input id="Button" type="button" value="Lot" onClick="OpenLot('<%=rs.getString("trx_id")%>','<%=type%>');" /><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%if (rs.getString("reason_name") != null) {%><%=rs.getString("reason_name")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs.getString("transaction_reference") != null) {%><%=rs.getString("transaction_reference")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs.getString("attribute13") != null) {%><%=rs.getString("attribute13")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%=rs.getString("trx_date")%></td>
            <td>
                <%if (rs.getString("action") != null) {%><%=rs.getString("action")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs.getString("action_date") != null) {%><%=rs.getString("action_date")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs.getString("closed_code") != null) {%><%=rs.getString("closed_code")%><%}else{%>&nbsp;<%}%></td>
        </tr>
<%
} //end of while	
%>
    </table>
    <br />
	<input id="Button1" type="button" value="Back" onClick="history.back();" />
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

