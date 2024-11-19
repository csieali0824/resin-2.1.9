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
String op_seq="";
String dept_id="";
String dept_code="";
int i;
String num=request.getParameter("num");
String orgid=request.getParameter("orgid");
String wipid=request.getParameter("wipid");
String wono=request.getParameter("wono");
String item=request.getParameter("item");
String item_from=request.getParameter("item_from");
if (item_from.indexOf("bom")>=0)
{
	if (item==null) item="";
}
else
	if (item==null) item="請輸入料號或品名";
%>

<script language="JavaScript" type="text/JavaScript">
function SendData(item_id,item_no,item_desc,uom,onhand,lot,op_seq,dept_id,dept_code,available)
{    
	if (item_id.length==0)
		if (!confirm('是否清空此筆領料?')) return false;
	window.opener.MYFORM.item_id<%=num%>.value = item_id;
	window.opener.MYFORM.item_no<%=num%>.value = item_no;
	window.opener.MYFORM.sub_inv<%=num%>.value = '';
	window.opener.document.all.item_desc<%=num%>_l.innerText = item_desc;
	window.opener.MYFORM.op_seq<%=num%>.value = op_seq;
	if (op_seq.length>0)
		window.opener.MYFORM.op_seq_btn<%=num%>.disabled = true
	else
		window.opener.MYFORM.op_seq_btn<%=num%>.disabled = false;
	window.opener.MYFORM.dept_id<%=num%>.value = dept_id;
	window.opener.MYFORM.dept_code<%=num%>.value = dept_code;
	window.opener.MYFORM.uom<%=num%>.value = uom;
	window.opener.MYFORM.trx_qty<%=num%>.value = '';
	window.opener.MYFORM.available<%=num%>.value = available;
	window.opener.document.all.available<%=num%>_l.innerText = available;
	window.opener.MYFORM.onhand<%=num%>.value = onhand;
	window.opener.document.all.onhand<%=num%>_l.innerText = onhand;
	window.opener.MYFORM.lot<%=num%>.value = lot;
	if (lot=='2')
	{
		window.opener.MYFORM.lot_btn<%=num%>.disabled = false;
		window.opener.document.all.lot<%=num%>_l.innerText = '※';
	}
	else
	{
		window.opener.MYFORM.lot_btn<%=num%>.disabled = true;
		window.opener.document.all.lot<%=num%>_l.innerText = '';
	}
	if (item_id.length==0)
		window.close()
	else
		location.href = 'yew_wip_mtl_trx_issue_wip_entry_item_process.jsp?orgid=<%=orgid%>&wipid=<%=wipid%>&wono=<%=wono%>&num=<%=num%>&item_id='+item_id+'&uom='+uom;
}

function DoFind()
{
	search.item.value = search.item.value.Trim();
	if (search.item.value == '' || search.item.value == '%')
		if(!confirm('沒輸入條件將會花費許多時間搜尋\n確定要執行?'))
			return false;
	search.find.disabled = true;
	search.submit();
} 

String.prototype.Trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
} 
</script>

<body>
<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST"> 
    <input type="hidden" name="item_from" value="<%=item_from%>" />
    <input type="hidden" name="num" value="<%=num%>" />
    <input type="hidden" name="orgid" value="<%=orgid%>" />
    <input type="hidden" name="wipid" value="<%=wipid%>" />
    <input id="Text1" type="text" name="item" value="<%=item%>" onClick="if (this.value=='請輸入料號或品名') this.value = '';" />
    <input id="Submit1" name="find" type="button" value="Find" onClick="DoFind();" disabled="disabled" /><br />
    <br />
<%
//有庫存的料號查詢
sql="";
if (item_from.indexOf("bom")>=0)
{
	//工令領用過的料品(工令已領用含簽核中)
	sql=sql+"SELECT we.wip_entity_name, wrov.wip_entity_id, wrov.inventory_item_id, ";
	sql=sql+"       wrov.organization_id, wrov.concatenated_segments segment1, ";
	sql=sql+"       wrov.item_description description, wrov.operation_seq_num, wrov.department_id, ";
	sql=sql+"       wrov.department_code, wrov.item_primary_uom_code primary_uom_code, ";
	sql=sql+"       wrov.required_quantity, ";
	sql=sql+"       TO_NUMBER (NVL (wrov.quantity_issued, 0)) quantity_issued, ";
	sql=sql+"       ABS (NVL (ywm.process_qty, 0)) quantity_process, ";
	sql=sql+"       CASE ";
	sql=sql+"          WHEN (  (wrov.quantity_issued + ABS (NVL (ywm.process_qty, 0))) ";
	sql=sql+"                - wrov.required_quantity ";
	sql=sql+"               ) > 0 ";
	sql=sql+"             THEN (  (wrov.quantity_issued + ABS (NVL (ywm.process_qty, 0))) ";
	sql=sql+"                   - wrov.required_quantity ";
	sql=sql+"                  ) ";
	sql=sql+"          ELSE 0 ";
	sql=sql+"       END quantity_excess, ";
	sql=sql+"       (NVL (wrov.quantity_open, 0) - ABS (NVL (ywm.process_qty, 0)) ";
	sql=sql+"       ) quantity_open, ";
	sql=sql+"       (NVL (qoh.total_qoh, 0) - ABS (NVL (ywm2.process_qty, 0))) available, ";
	sql=sql+"       NVL (qoh.total_qoh, 0) onhand, wrov.quantity_per_assembly, ";
	sql=sql+"       msib.lot_control_code ";
	sql=sql+"  FROM wip_entities we, ";
	sql=sql+"       wip_requirement_operations_v wrov, ";
	sql=sql+"       mtl_system_items_b msib, ";
	sql=sql+"       (SELECT   organization_id, inventory_item_id, ";
	sql=sql+"                 SUM (transaction_quantity) total_qoh ";
	sql=sql+"            FROM mtl_onhand_quantities_detail ";
	sql=sql+"        GROUP BY organization_id, inventory_item_id) qoh, ";
	sql=sql+"       (SELECT   wip_entity_id, SUM (transaction_quantity) process_qty ";
	sql=sql+"            FROM yew_wip_mtl_trx ";
	sql=sql+"           WHERE closed_code = 'OPEN' ";
	sql=sql+"        GROUP BY wip_entity_id) ywm, ";
	sql=sql+"       (SELECT   organization_id, inventory_item_id, ";
	sql=sql+"                 SUM (transaction_quantity) process_qty ";
	sql=sql+"            FROM yew_wip_mtl_trx ";
	sql=sql+"           WHERE closed_code = 'OPEN' ";
	sql=sql+"        GROUP BY organization_id, inventory_item_id) ywm2 ";
	sql=sql+" WHERE wrov.wip_entity_id = we.wip_entity_id ";
	sql=sql+"   AND wrov.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"   AND wrov.organization_id = msib.organization_id ";
	sql=sql+"   AND wrov.wip_entity_id = ywm.wip_entity_id(+) ";
	sql=sql+"   AND wrov.inventory_item_id = qoh.inventory_item_id(+) ";
	sql=sql+"   AND wrov.organization_id = qoh.organization_id(+) ";
	sql=sql+"   AND wrov.inventory_item_id = ywm2.inventory_item_id(+) ";
	sql=sql+"   AND wrov.organization_id = ywm2.organization_id(+) ";
	sql=sql+"   AND wrov.routing_exists_flag = 1 ";
	sql=sql+"   AND (wrov.concatenated_segments LIKE '%"+item+"%' OR wrov.item_description LIKE '%"+item+"%') ";
	sql=sql+"   AND wrov.wip_entity_id = "+wipid+" ";
	sql=sql+"UNION ";
	sql=sql+"SELECT   ywmt.wip_entity_name, ywmt.wip_entity_id, ywmt.inventory_item_id, ";
	sql=sql+"         ywmt.organization_id, msib.segment1, msib.description, ";
	sql=sql+"         ywmt.operation_seq_num, ywmt.department_id, bd.department_code, ";
	sql=sql+"         msib.primary_uom_code, 0 required_quantity, 0 quantity_issued, ";
	sql=sql+"         SUM (ABS (ywmt.transaction_quantity)) quantity_process, ";
	sql=sql+"         SUM (ABS (ywmt.transaction_quantity)) quantity_excess, 0 quantity_open, ";
	sql=sql+"         (NVL (qoh.total_qoh, 0) - SUM (ABS (ywmt.transaction_quantity)) ";
	sql=sql+"         ) available, NVL (qoh.total_qoh, 0) onhand, 0 quantity_per_assembly, ";
	sql=sql+"         msib.lot_control_code ";
	sql=sql+"    FROM yew_wip_mtl_trx ywmt, ";
	sql=sql+"         mtl_system_items_b msib, ";
	sql=sql+"         bom_departments bd, ";
	sql=sql+"         (SELECT   organization_id, inventory_item_id, ";
	sql=sql+"                   SUM (transaction_quantity) total_qoh ";
	sql=sql+"              FROM mtl_onhand_quantities_detail ";
	sql=sql+"          GROUP BY organization_id, inventory_item_id) qoh ";
	sql=sql+"   WHERE ywmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND ywmt.organization_id = msib.organization_id ";
	sql=sql+"     AND ywmt.department_id = bd.department_id ";
	sql=sql+"     AND ywmt.inventory_item_id = qoh.inventory_item_id(+) ";
	sql=sql+"     AND ywmt.organization_id = qoh.organization_id(+) ";
	sql=sql+"     AND ywmt.inventory_item_id NOT IN ( ";
	sql=sql+"            SELECT inventory_item_id ";
	sql=sql+"              FROM wip_requirement_operations_v ";
	sql=sql+"             WHERE routing_exists_flag = 1 ";
	sql=sql+"               AND wip_entity_id = ywmt.wip_entity_id) ";
	sql=sql+"   AND ywmt.wip_entity_id = "+wipid+" ";
	sql=sql+"GROUP BY ywmt.wip_entity_name, ";
	sql=sql+"         ywmt.wip_entity_id, ";
	sql=sql+"         ywmt.inventory_item_id, ";
	sql=sql+"         ywmt.organization_id, ";
	sql=sql+"         msib.segment1, ";
	sql=sql+"         msib.description, ";
	sql=sql+"         ywmt.operation_seq_num, ";
	sql=sql+"         ywmt.department_id, ";
	sql=sql+"         bd.department_code, ";
	sql=sql+"         msib.primary_uom_code, ";
	sql=sql+"         NVL (qoh.total_qoh, 0), ";
	sql=sql+"         msib.lot_control_code ";
	sql=sql+"ORDER BY operation_seq_num ";
}
else
{
	//所有的料品庫存可用數
	sql="";
	sql=sql+"SELECT   moqd.inventory_item_id, msib.segment1, msib.description, ";
	sql=sql+"         ABS (NVL (ywm.process_qty, 0)) quantity_process, ";
	sql=sql+"           SUM (moqd.primary_transaction_quantity) ";
	sql=sql+"         - ABS (NVL (ywm.process_qty, 0)) available, ";
	sql=sql+"         SUM (moqd.primary_transaction_quantity) onhand, ";
	sql=sql+"         msib.primary_uom_code, msib.lot_control_code ";
	sql=sql+"    FROM mtl_onhand_quantities_detail moqd, ";
	sql=sql+"         mtl_system_items_b msib, ";
	sql=sql+"         (SELECT   organization_id, inventory_item_id, ";
	sql=sql+"                   SUM (transaction_quantity) process_qty ";
	sql=sql+"              FROM yew_wip_mtl_trx ";
	sql=sql+"             WHERE closed_code = 'OPEN' ";
	sql=sql+"          GROUP BY organization_id, inventory_item_id) ywm ";
	sql=sql+"   WHERE moqd.organization_id = msib.organization_id ";
	sql=sql+"     AND moqd.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"     AND msib.inventory_item_status_code = 'Active' ";
	sql=sql+"     AND moqd.organization_id = ywm.organization_id(+) ";
	sql=sql+"     AND moqd.inventory_item_id = ywm.inventory_item_id(+) ";
	sql=sql+"     AND moqd.organization_id = "+orgid+" ";
	sql=sql+"     AND (   msib.segment1 LIKE '%"+item+"%' ";
	sql=sql+"          OR msib.description LIKE '%"+item+"%' ";
	sql=sql+"         ) ";
	sql=sql+"GROUP BY moqd.inventory_item_id, ";
	sql=sql+"         msib.segment1, ";
	sql=sql+"         msib.description, ";
	sql=sql+"         ywm.process_qty, ";
	sql=sql+"         msib.primary_uom_code, ";
	sql=sql+"         msib.lot_control_code ";
	sql=sql+"ORDER BY segment1 ";
}
statement=con.createStatement();
rs=statement.executeQuery(sql); 
i=0;
%>
    <table border="1" cellspacing="0" bordercolor="#000000">
        <tr>
            <td align="center" bgcolor="silver">
                Item</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Available</td>
            <td align="center" bgcolor="silver">
                On-hand</td>
            <td align="center" bgcolor="silver">&nbsp;
                </td>
        </tr>
        <tr>
            <td>
				<input id="op_seq<%=i%>" type="hidden" name="op_seq<%=i%>" value="" />
				<input id="dept_id<%=i%>" type="hidden" name="dept_id<%=i%>" value="" />
				<input id="dept_code<%=i%>" type="hidden" name="dept_code<%=i%>" value="" />
                <input id="item_id<%=i%>" type="hidden" name="item_id<%=i%>" value="" />
				<input id="item_no<%=i%>" type="hidden" name="item_no<%=i%>" value="" />
                (清空Item)</td>
            <td>
                <input id="item_desc<%=i%>" type="hidden" name="item_desc<%=i%>" value="" />
                &nbsp;</td>
            <td>
                <input id="uom<%=i%>" type="hidden" name="uom<%=i%>" value="" />
                &nbsp;</td>
            <td>
                <input id="available<%=i%>" type="hidden" name="available<%=i%>" value="" />
                &nbsp;</td>
            <td>
                <input id="onhand<%=i%>" type="hidden" name="onhand<%=i%>" value="" />
                &nbsp;</td>
            <td>
                <input id="lot<%=i%>" type="hidden" name="lot<%=i%>" value="" />
				<input id="Button<%=i%>" type="button" value="Select" onClick="SendData(item_id<%=i%>.value,item_no<%=i%>.value,item_desc<%=i%>.value,uom<%=i%>.value,onhand<%=i%>.value,lot<%=i%>.value,op_seq<%=i%>.value,dept_id<%=i%>.value,dept_code<%=i%>.value,available<%=i%>.value);" /></td>
        </tr>
<%
while (rs.next())
{ 
	i++;
	op_seq="";
	dept_id="";
	dept_code="";
	if (item_from.indexOf("bom")>=0)
	{
		op_seq=rs.getString("operation_seq_num");
		dept_id=rs.getString("department_id");
		dept_code=rs.getString("department_code");
	}           
%>
        <tr>
            <td>
				<%%>
				<input id="op_seq<%=i%>" type="hidden" name="op_seq<%=i%>" value="<%=op_seq%>" />
				<input id="dept_id<%=i%>" type="hidden" name="dept_id<%=i%>" value="<%=dept_id%>" />
				<input id="dept_code<%=i%>" type="hidden" name="dept_code<%=i%>" value="<%=dept_code%>" />
                <input id="item_id<%=i%>" type="hidden" name="item_id<%=i%>" value="<%=rs.getString("inventory_item_id")%>" />
				<input id="item_no<%=i%>" type="hidden" name="item_no<%=i%>" value="<%=rs.getString("segment1")%>" />
				<%=rs.getString("segment1")%></td>
            <td>
				<input id="item_desc<%=i%>" type="hidden" name="item_desc<%=i%>" value="<%=rs.getString("description")%>" />
                <%=rs.getString("description")%></td>
            <td>
				<input id="uom<%=i%>" type="hidden" name="uom<%=i%>" value="<%=rs.getString("primary_uom_code")%>" />
                <%=rs.getString("primary_uom_code")%></td>
            <td>
                <input id="available<%=i%>" type="hidden" name="available<%=i%>" value="<%=rs.getString("available")%>" />
                <%=rs.getString("available")%></td>
             <td>
				<input id="onhand<%=i%>" type="hidden" name="onhand<%=i%>" value="<%=rs.getString("onhand")%>" />
                <%=rs.getString("onhand")%></td>
            <td>
                <input id="lot<%=i%>" type="hidden" name="lot<%=i%>" value="<%=rs.getString("lot_control_code")%>" />
				<input id="Button<%=i%>" type="button" value="Select" onClick="SendData(item_id<%=i%>.value,item_no<%=i%>.value,item_desc<%=i%>.value,uom<%=i%>.value,onhand<%=i%>.value,lot<%=i%>.value,op_seq<%=i%>.value,dept_id<%=i%>.value,dept_code<%=i%>.value,available<%=i%>.value);" /></td>
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
<script language="javascript">
search.find.disabled = false;
</script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

