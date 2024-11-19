<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--========2007/09/25 Moon Festiva by Kerwin=============-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - 未完工工令查詢</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";
int i, j;
float available_qty;

String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String itemid=request.getParameter("itemid");  
if (itemid==null) itemid="";
String dept=request.getParameter("dept");  
if (dept==null) dept="";
String num=request.getParameter("num");  
if (num==null) num="";
%>

<script language="JavaScript" type="text/JavaScript">
function SendData(sub_inv,locator_id,locator,available,onhand)
{   
	var trx_qty = 0;
	if (window.opener.MYFORM.trx_qty<%=num%>.value.length>0)
		trx_qty = parseFloat(window.opener.MYFORM.trx_qty<%=num%>.value);
	try
	{
		if (parseFloat(available)<parseFloat(trx_qty)) trx_qty=available;
	}
	catch(e)
	{
	}
	if (locator=="null") locator="";
	window.opener.MYFORM.sub_inv<%=num%>.value = sub_inv;
	window.opener.MYFORM.locator_id<%=num%>.value = locator_id;
	window.opener.MYFORM.locator<%=num%>.value = locator;
	window.opener.MYFORM.trx_qty<%=num%>.value = trx_qty;
	window.opener.MYFORM.available<%=num%>.value = available;
	window.opener.document.all.available<%=num%>_l.innerText = available;
	window.opener.MYFORM.onhand<%=num%>.value = onhand;
	window.opener.document.all.onhand<%=num%>_l.innerText = onhand;
	window.close();
} 
</script>

<body>
<FORM NAME="search" ACTION="" METHOD="POST"> 
<%
//取得可領料倉別(可用數)
sql="";
sql=sql+"SELECT   msib.segment1, msib.description, msi.organization_id, ";
sql=sql+"         ood.organization_code,  moqd.subinventory_code, ";
sql=sql+"         msi.description inv_desc, moqd.locator_id, mil.segment1 locator, ";
sql=sql+"         SUM (moqd.primary_transaction_quantity) onhand, ";
sql=sql+"         ABS (NVL (ywm.process_qty, 0)) quantity_process, ";
sql=sql+"         SUM (moqd.primary_transaction_quantity) ";
sql=sql+"             - ABS (NVL (ywm.process_qty, 0)) available_qty, ";
sql=sql+"         msib.primary_uom_code, msib.fixed_lot_multiplier ";
sql=sql+"    FROM mtl_onhand_quantities_detail moqd, ";
sql=sql+"         mtl_system_items_b msib, ";
sql=sql+"         mtl_secondary_inventories msi, ";
sql=sql+"         mtl_item_locations mil, ";
sql=sql+"         org_organization_definitions ood, ";
sql=sql+"         (SELECT   organization_id, inventory_item_id, subinventory_code, ";
sql=sql+"                   locator_id, SUM (transaction_quantity) process_qty ";
sql=sql+"              FROM yew_wip_mtl_trx ";
sql=sql+"             WHERE closed_code = 'OPEN' ";
sql=sql+"          GROUP BY organization_id, ";
sql=sql+"                   inventory_item_id, ";
sql=sql+"                   subinventory_code, ";
sql=sql+"                   locator_id) ywm ";
sql=sql+"   WHERE moqd.organization_id = msib.organization_id ";
sql=sql+"     AND moqd.inventory_item_id = msib.inventory_item_id ";
sql=sql+"     AND moqd.organization_id = msi.organization_id ";
sql=sql+"     AND moqd.subinventory_code = msi.secondary_inventory_name ";
sql=sql+"     AND moqd.organization_id = ood.organization_id ";
sql=sql+"     AND moqd.organization_id = mil.organization_id(+) ";
sql=sql+"     AND moqd.subinventory_code = mil.subinventory_code(+) ";
sql=sql+"     AND moqd.locator_id = mil.inventory_location_id(+) ";
sql=sql+"     AND moqd.organization_id = ywm.organization_id(+) ";
sql=sql+"     AND moqd.inventory_item_id = ywm.inventory_item_id(+) ";
sql=sql+"     AND moqd.subinventory_code = ywm.subinventory_code(+) ";
sql=sql+"     AND NVL (moqd.locator_id, 0) = NVL (ywm.locator_id(+), 0) ";
sql=sql+"     AND msi.organization_id = "+orgid+" ";
sql=sql+"     AND msib.inventory_item_id = "+itemid+" ";
sql=sql+"GROUP BY msib.segment1, ";
sql=sql+"         msib.description, ";
sql=sql+"         msi.organization_id, ";
sql=sql+"         ood.organization_code, ";
sql=sql+"         moqd.subinventory_code, ";
sql=sql+"         msi.description, ";
sql=sql+"         moqd.locator_id, ";
sql=sql+"         mil.segment1, ";
sql=sql+"         ywm.process_qty, ";
sql=sql+"         msib.primary_uom_code, ";
sql=sql+"         msib.fixed_lot_multiplier ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
%>
    <table border="1" cellspacing="0" bordercolor="#000000">
        <tr>
            <td align="center" bgcolor="silver">
                SubInv</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                Locator</td>
            <td align="center" bgcolor="silver">
                Available</td>
            <td align="center" bgcolor="silver">
                On-hand</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">&nbsp;
                </td>
        </tr>
<%
i=0;
while (rs.next())
{  
	i++;          
	available_qty = rs.getFloat("onhand")-rs.getFloat("quantity_process");
	if (available_qty<0) available_qty=0;
%>
        <tr>
            <td>
                <input id="sub_inv<%=i%>" type="hidden" value="<%=rs.getString("subinventory_code")%>" name="sub_inv<%=i%>" />
				<%=rs.getString("subinventory_code")%></td>
            <td>
				<%=rs.getString("inv_desc")%></td>
            <td>
				<input id="locator_id<%=i%>" type="hidden" value="<%=rs.getString("locator_id")%>" name="locator_id<%=i%>" />
				<input id="locator<%=i%>" type="hidden" value="<%=rs.getString("locator")%>" name="locator<%=i%>" />
                <%if (rs.getString("locator_id") != null) {%><%=rs.getString("locator")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <input id="available<%=i%>" type="hidden" value="<%=available_qty%>" name="available<%=i%>" />
				<%=available_qty%></td>
            <td>
				<input id="onhand<%=i%>" type="hidden" value="<%=rs.getString("onhand")%>" name="onhand<%=i%>" />
                <%=rs.getString("onhand")%></td>
            <td>
                <%=rs.getString("primary_uom_code")%></td>
            <td>
				<input id="Button2" type="button" name="B<%=i%>" value="Select" onClick="SendData(sub_inv<%=i%>.value,locator_id<%=i%>.value,locator<%=i%>.value,available<%=i%>.value,onhand<%=i%>.value);" <%if (available_qty<=0) {%>disabled<%}else{%>&nbsp;<%}%> /></td>
        </tr>
<%
} //end of while	
j = i;
%>
    </table>
	<script language="javascript">
		flag = false;
		<%for (i=1;i<=j;i++) {%>
		if (search.sub_inv<%=i%>.value == '06' && search.locator<%=i%>.value == '<%=dept%>')
			flag=true;
		<%}%>
		if (flag)
		{
		<%for (i=1;i<=j;i++) {%>
			if (search.sub_inv<%=i%>.value != '06' || search.locator<%=i%>.value != '<%=dept%>')
				search.B<%=i%>.disabled=true;
		<%}%>
		}
		else
		{
		<%for (i=1;i<=j;i++) {%>
			if (search.sub_inv<%=i%>.value == '06')
				search.B<%=i%>.disabled=true;
		<%}%>
		}
		;
	</script>
<%
rs.close();       
statement.close();
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

