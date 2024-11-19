<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - LOT</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
Statement statement2;
ResultSet rs2;
String sql="";
String trx_qty_str="";
String lot_qty_str="";
int i, j, lot_ctrl=0;
float trx_qty, available_qty, lot_qty, process_qty;

int trx_id=Integer.parseInt(request.getParameter("trx_id"));
String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String item_id=request.getParameter("item_id");  
if (item_id==null) item_id="";
String sub_inv=request.getParameter("sub_inv");  
if (sub_inv==null) sub_inv="";
String locator_id=request.getParameter("locator_id");  
if (locator_id==null) locator_id="";
try{lot_ctrl=Integer.parseInt(request.getParameter("lot_ctrl"));}catch (Exception e){};
try
{
	if (request.getParameter("trx_qty")==null)
	{
		trx_qty=0;
		trx_qty_str="0";
	}
	else
	{
		trx_qty_str = request.getParameter("trx_qty");
		trx_qty=Float.parseFloat(request.getParameter("trx_qty"));
	}
}
catch(NumberFormatException e)
{
	trx_qty=0;
}
String num=request.getParameter("num");  
if (num==null) num="";
try
{
	if (request.getParameter("lot_qty")==null)
	{
		lot_qty=0;
	}
	else
		lot_qty=Float.parseFloat(request.getParameter("lot_qty"));
}
catch(NumberFormatException e)
{
	lot_qty=0;
}
String lot=request.getParameter("lot");  
if (lot==null) lot="";
String lot_num=request.getParameter("lot_num");  
if (lot_num==null) lot_num="";
%>

<script language="JavaScript" type="text/JavaScript">
function chkNumber(obj)
{
	if (isNaN(obj.value))
	{
		alert('請輸入數字');
		obj.focus();
		return false;
	}
	else
		return true;
}

function DoReset()
{
	if (confirm('確認重置?')) MYFORM.reset();
}

function DoSubmit()
{
	if (chkSubmit())
		if (parseFloat(MYFORM.lot_qty_t.value) == parseFloat(MYFORM.trx_qty.value))
			{
				if (confirm('確認送出?')) 
				{
					window.opener.MYFORM.lot<%=num%>.value = 2;
					window.opener.MYFORM.lot_qty<%=num%>.value = MYFORM.lot_qty_t.value;
					MYFORM.Close1.disabled = true;
					MYFORM.Reset1.disabled = true;
					MYFORM.Submit1.disabled = true;
					MYFORM.submit();
				}
			}
			else
				alert('領用數量不足\n請補足數量 '+MYFORM.trx_qty.value+' '+MYFORM.uom.value);
}

String.prototype.Trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
} 
</script>

<body >

<FORM NAME="MYFORM" ACTION="yew_wip_mtl_trx_issue_wip_entry_lot_process.jsp" METHOD="POST"> 

<%
//取得料品資料
sql="";
sql=sql+"SELECT   msib.segment1, msib.description, ood.organization_code, ";
sql=sql+"         moqd.subinventory_code, msi.description inv_desc, moqd.locator_id, ";
sql=sql+"         mil.segment1 LOCATOR, SUM (moqd.primary_transaction_quantity) onhand, ";
sql=sql+"         msib.primary_uom_code, msib.fixed_lot_multiplier ";
sql=sql+"    FROM mtl_onhand_quantities_detail moqd, ";
sql=sql+"         mtl_system_items_b msib, ";
sql=sql+"         mtl_secondary_inventories msi, ";
sql=sql+"         mtl_item_locations mil, ";
sql=sql+"         org_organization_definitions ood ";
sql=sql+"   WHERE moqd.organization_id = msib.organization_id ";
sql=sql+"     AND moqd.inventory_item_id = msib.inventory_item_id ";
sql=sql+"     AND moqd.organization_id = msi.organization_id ";
sql=sql+"     AND moqd.organization_id = ood.organization_id ";
sql=sql+"     AND moqd.subinventory_code = msi.secondary_inventory_name ";
sql=sql+"     AND moqd.organization_id = mil.organization_id(+) ";
sql=sql+"     AND moqd.subinventory_code = mil.subinventory_code(+) ";
sql=sql+"     AND moqd.locator_id = mil.inventory_location_id(+) ";
sql=sql+"     AND msi.organization_id = "+orgid+" ";
sql=sql+"     AND msib.inventory_item_id = "+item_id+" ";
sql=sql+"     AND moqd.subinventory_code = '"+sub_inv+"' ";
if (locator_id.length() > 0)
	sql=sql+"     AND NVL (moqd.locator_id, 0) = "+locator_id+" ";
sql=sql+"GROUP BY msib.segment1, ";
sql=sql+"         msib.description, ";
sql=sql+"         ood.organization_code, ";
sql=sql+"         moqd.subinventory_code, ";
sql=sql+"         msi.description, ";
sql=sql+"         moqd.locator_id, ";
sql=sql+"         mil.segment1, ";
sql=sql+"         msib.primary_uom_code, ";
sql=sql+"         msib.fixed_lot_multiplier ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
if (rs.next())
{
%>
    <table bgcolor="silver">
        <tr>
            <td align="right" nowrap="nowrap">
                Item</td>
            <td nowrap="nowrap">
				<input id="item_id" type="hidden" value="<%=item_id%>" name="item_id" />
                <input id="item_no" readonly="readonly" type="text" value="<%=rs.getString("segment1")%>" name="item_no" /></td>
            <td colspan="2" nowrap="nowrap">
                <input id="item_desc" readonly="readonly" style="width: 290px" type="text" value="<%=rs.getString("description")%>" name="item_desc" />
            </td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap">
                Orgnization</td>
            <td nowrap="nowrap">
                <input id="orgcode" readonly="readonly" style="width: 70px" type="text" value="<%=rs.getString("organization_code")%>" name="orgcode" /></td>
            <td align="right" nowrap="nowrap">
                UOM</td>
            <td nowrap="nowrap" style="width: 3px">
                <input id="uom" style="width: 40px" type="text" value="<%=rs.getString("primary_uom_code")%>" readonly="readOnly" name="uom" /></td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap" style="height: 26px">
                Subinventory</td>
            <td nowrap="nowrap" style="height: 26px"><input id="sub_inv" readonly="readonly" style="width: 70px" type="text" value="<%=sub_inv%>" name="sub_inv" /></td>
            <td align="right" nowrap="nowrap" style="height: 26px">
                Quantity</td>
            <td nowrap="nowrap" style="width: 3px; height: 26px;">
                <input id="trx_qty" readonly="readonly" style="width: 80px" type="text" value="<%=trx_qty_str%>" name="trx_qty" /></td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap">
                Locator</td>
            <td nowrap="nowrap">
                <input id="locator_id" type="hidden" value="<%=locator_id%>" name="locator" />
				<input id="locator" readonly="readonly" style="width: 70px" type="text" value="<%if (rs.getString("LOCATOR") != null) {%><%=rs.getString("LOCATOR")%><%}%>" name="locator" /></td>
            <td align="right" nowrap="nowrap">
                Lot Quantity Entered</td>
            <td nowrap="nowrap" style="width: 3px">
                <input id="lot_qty_t" readonly="readonly" style="width: 79px" type="text" value="0" name="lot_qty_t" /></td>
        </tr>
    </table>
    <br />
<%
}
rs.close();       
statement.close();

//取得可用LOT
sql="";
sql=sql+"SELECT   ood.organization_code, moqd.inventory_item_id, msib.segment1, ";
sql=sql+"         msib.description, moqd.subinventory_code, moqd.locator_id, ";
sql=sql+"         mil.segment1 LOCATOR, moqd.lot_number, mln.expiration_date, ";
sql=sql+"         moqd.transaction_uom_code, ";
sql=sql+"         SUM (moqd.transaction_quantity) transaction_quantity, ";
sql=sql+"         SUM (ABS (NVL (ywmlot.process_qty, 0))) process_qty, ";
sql=sql+"         SUM (moqd.transaction_quantity - ABS (NVL (ywmlot.process_qty, 0)) ";
sql=sql+"             ) available_qty, ";
sql=sql+"         msib.lot_control_code, msib.fixed_lot_multiplier ";
sql=sql+"    FROM mtl_onhand_quantities_detail moqd, ";
sql=sql+"         mtl_system_items_b msib, ";
sql=sql+"         mtl_lot_numbers mln, ";
sql=sql+"         mtl_item_locations mil, ";
sql=sql+"         org_organization_definitions ood, ";
sql=sql+"         (SELECT   ywml.lot_number, ywml.inventory_item_id, ";
sql=sql+"                   ywml.organization_id, ywmt.subinventory_code, ";
sql=sql+"                   ywmt.locator_id, ";
sql=sql+"                   SUM (ywml.transaction_quantity) process_qty ";
sql=sql+"              FROM yew_wip_mtl_trx ywmt, yew_wip_mtl_lots ywml ";
sql=sql+"             WHERE ywmt.trx_id = ywml.trx_id AND closed_code = 'OPEN' ";
sql=sql+"          GROUP BY ywml.lot_number, ";
sql=sql+"                   ywml.inventory_item_id, ";
sql=sql+"                   ywml.organization_id, ";
sql=sql+"                   ywmt.subinventory_code, ";
sql=sql+"                   ywmt.locator_id) ywmlot ";
sql=sql+"   WHERE moqd.inventory_item_id = msib.inventory_item_id ";
sql=sql+"     AND moqd.organization_id = msib.organization_id ";
sql=sql+"     AND moqd.organization_id = ood.organization_id ";
sql=sql+"     AND moqd.inventory_item_id = mln.inventory_item_id(+) ";
sql=sql+"     AND moqd.organization_id = mln.organization_id(+) ";
sql=sql+"     AND moqd.lot_number = mln.lot_number(+) ";
sql=sql+"     AND moqd.organization_id = mil.organization_id(+) ";
sql=sql+"     AND moqd.subinventory_code = mil.subinventory_code(+) ";
sql=sql+"     AND moqd.locator_id = mil.inventory_location_id(+) ";
sql=sql+"     AND moqd.inventory_item_id = ywmlot.inventory_item_id(+) ";
sql=sql+"     AND moqd.organization_id = ywmlot.organization_id(+) ";
sql=sql+"     AND moqd.subinventory_code = ywmlot.subinventory_code(+) ";
sql=sql+"     AND NVL (moqd.locator_id, 0) = NVL (ywmlot.locator_id(+), 0) ";
sql=sql+"     AND moqd.lot_number = ywmlot.lot_number(+) ";
sql=sql+"     AND moqd.organization_id = "+orgid+" ";
sql=sql+"     AND moqd.subinventory_code = '"+sub_inv+"' ";
if (locator_id.length() > 0)
	sql=sql+"     AND NVL (moqd.locator_id, 0) = '"+locator_id+"' ";
sql=sql+"     AND moqd.inventory_item_id = "+item_id+" ";
sql=sql+"GROUP BY ood.organization_code, ";
sql=sql+"         moqd.inventory_item_id, ";
sql=sql+"         msib.segment1, ";
sql=sql+"         msib.description, ";
sql=sql+"         moqd.subinventory_code, ";
sql=sql+"         moqd.locator_id, ";
sql=sql+"         mil.segment1, ";
sql=sql+"         moqd.lot_number, ";
sql=sql+"         mln.expiration_date, ";
sql=sql+"         moqd.transaction_uom_code, ";
sql=sql+"         msib.lot_control_code, ";
sql=sql+"         msib.fixed_lot_multiplier ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
%>

	<table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td bgcolor="silver" nowrap="noWrap">
                Lot</td>
            <td bgcolor="silver" nowrap="noWrap">
                Expiration Date</td>
            <td bgcolor="silver" nowrap="noWrap">
                Quantity</td>
            <td bgcolor="silver" nowrap="noWrap">
                Available</td>
            <td bgcolor="silver" nowrap="noWrap">
                On Hand</td>
        </tr>
<%
i=0;
while (rs.next())
{
	i++;
	process_qty=0;
	//讀取簽核中的lot數
	sql="";
	sql=sql+"SELECT ABS (NVL (transaction_quantity,0)) ";
	if (lot_ctrl>0)
	{
		sql=sql+"  FROM yew_wip_mtl_lots_temp ";
	}
	else
		sql=sql+"  FROM yew_wip_mtl_lots ";
	sql=sql+" WHERE trx_id = "+trx_id+" AND lot_number = '"+rs.getString("lot_number")+"' ";
	statement2=con.createStatement();
	rs2=statement2.executeQuery(sql); 
	if (rs2.next()) process_qty=rs2.getFloat(1);
	rs2.close();       
	statement2.close();
	available_qty = rs.getFloat("available_qty")+process_qty;
	if (available_qty<0) available_qty=0;
%>
        <tr>
            <td nowrap="noWrap">
				<input id="lot<%=i%>" type="hidden" name="lot<%=i%>" readonly="readOnly" value="<%=rs.getString("lot_number")%>" />
				<%=rs.getString("lot_number")%>
            </td>
            <td nowrap="noWrap">
                <%if (rs.getString("expiration_date") != null) {%><%=rs.getString("expiration_date")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="noWrap">
                <input id="lot_qty<%=i%>" style="width: 80px" type="text" name="lot_qty<%=i%>" value="<%if (process_qty>0) {%><%=process_qty%><%}%>" onBlur="chkLotQty(lot_qty<%=i%>,<%=available_qty%>);" <%if (available_qty<=0) {%> disabled<%};%>  /></td>
            <td nowrap="noWrap">
				<%=rs.getString("available_qty")%></td>
            <td nowrap="noWrap">
                <%=rs.getString("transaction_quantity")%></td>
        </tr>
<%
} //end of while	
j = i;
%>
    </table>
    <br />
	<input type="hidden" name="trx_id" value="<%=trx_id%>" />
	<input type="hidden" name="orgid" value="<%=orgid%>" />
	<input type="hidden" name="lot_num" value="<%=j%>" />
	<input id="Close1" name="Close1" type="button" value="Close" onClick="window.close();" />
    <input id="Reset1" name="Reset1" type="button" value="Reset" onClick="DoReset();" />
    <input id="Submit1" name="Submit1" type="button" value="Submit" onClick="DoSubmit();" />
<%
rs.close();       
statement.close();
%>
</FORM>
<script language="javascript">
var t = 0;
	<%for (i=1;i<=j;i++) {%>
if (!isNaN(MYFORM.lot_qty<%=i%>.value) && MYFORM.lot_qty<%=i%>.value!='') t += parseFloat(MYFORM.lot_qty<%=i%>.value);
	<%}%>
MYFORM.lot_qty_t.value=t;

function chkLotQty(obj,available)
{
	var lot = 0;
	var trx = parseFloat(MYFORM.trx_qty.value);
	var total = 0;
	<%for (i=1;i<=j;i++) {%>
	var lot<%=i%>=0;
	<%}%>
	<%for (i=1;i<=j;i++) {%>
	if (!isNaN(MYFORM.lot_qty<%=i%>.value) && MYFORM.lot_qty<%=i%>.value!='') lot<%=i%>=parseFloat(MYFORM.lot_qty<%=i%>.value);
	total += lot<%=i%>;
	<%}%>
	MYFORM.lot_qty_t.value = total;
	if (chkNumber(obj))
	{
		lot = parseFloat(obj.value);
		if (lot>available || lot<0)
		{
			alert('數量不可大於Available或小於0');
			obj.focus();
			return false;
		}
		if (total>trx)
		{
			lot = trx-(total-lot);
			alert('總數量超過可領用數');
			alert('LOT最大可領用數 = '+lot);
			MYFORM.lot_qty_t.value = total-parseFloat(obj.value);
			obj.value = "";
			obj.focus();
			return false;
		}
	}
	else
		return true;
}

function chkSubmit()
{
	<%for (i=1;i<=j;i++) {%>
	MYFORM.lot_qty<%=i%>.value = MYFORM.lot_qty<%=i%>.value.Trim();
	if (MYFORM.lot_qty<%=i%>.value=="") MYFORM.lot_qty<%=i%>.value="0";
	<%}%>
	return true;
}
</script>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

