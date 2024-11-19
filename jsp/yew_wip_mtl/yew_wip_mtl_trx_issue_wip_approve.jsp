<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 領料簽核 - Approve</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
Statement statement2;
ResultSet rs;
ResultSet rs2;
String sql="";
String wono="";
String orgid="";
int i, j, act_num;
float required_qty, issued_qty, process_qty, excess_qty, available_qty;
boolean LotFlag;

String wipid=request.getParameter("wipid");
String act=request.getParameter("act");
String act_lbl="";
if (act.indexOf("0")>=0) act_lbl = "產線主管";
if (act.indexOf("10")>=0) act_lbl = "物管";
if (act.indexOf("20")>=0) act_lbl = "倉庫";
act_num=Integer.parseInt(act)+10;
%>

<script language="JavaScript" type="text/JavaScript">
function OpenHistories(wono,wipid)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_histories.jsp?wono="+wono+"&wipid="+wipid,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
	subWin.focus();
} 

<%if (act_num==30) {%>
function OpenLot(orgid,item_id,sub_inv,locator_id,trx_qty,trx_id,lot_ctrl,num)
{    
	if (locator_id=="null") 
		locator_id="";
	if (sub_inv.length>0)
	{
		if (trx_qty.length>0)
		{
			if (trx_qty!='0')
			{
				subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_lot.jsp?orgid="+orgid+"&item_id="+item_id+"&sub_inv="+sub_inv+"&locator_id="+locator_id+"&trx_qty="+trx_qty+"&trx_id="+trx_id+"&lot_ctrl="+lot_ctrl+"&num="+num,"subwin","width=600,height=480,status=yes,scrollbars=yes,resizable=yes");
				subWin.focus();
			}
			else
				alert('必需要有Quantity');
		}
		else
			alert('請先輸入Quantity');
	}
	else
		alert('請先選擇SubInv');  
} 
<%} else {%>
function OpenLot(trx_id)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_histories_d_lot.jsp?trx_id="+trx_id+"&type=process","subWin","width=450,height=200,status=yes,scrollbars=yes,resizable=yes");  
	subWin.focus();
}
<%}%>

function DoBack()
{
	if (confirm('確認回到上一頁?')) history.back();
}

function DoSubmit(act)
{
	MYFORM.action_code.value = act;
	if (chkSubmit())
		if (confirm('確認'+act+'?'))
			if (confirm('確認送出?'))
			{
				MYFORM.Back.disabled = true;
				MYFORM.Reject.disabled = true;
				MYFORM.Approve.disabled = true;
				MYFORM.submit();
			}
} 

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

function chkTrxQty(obj, available)
{
	if (chkNumber(obj))
	{
		if (obj.value=='')
		{
			alert('請輸入數量');
			obj.focus();
			return false;
		}
		if (parseFloat(obj.value)>available || !(parseFloat(obj.value)>0))
		{
			alert('數量不可大於Available且必需大於0');
			obj.focus();
			return false;
		}
	}
	else
		return true;
}

function CloseSubWin()
{    
	try {subWin.close();}
	catch(e) {}
} 

String.prototype.Trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
} 
</script>

<body onUnload="CloseSubWin();">
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;<%=act_lbl%>簽核作業</FONT>
<br><br>

<%
//取得工令資料
sql="";
sql=sql+"SELECT wdj.organization_id, ood.organization_code, we.wip_entity_id, ";
sql=sql+"       we.wip_entity_name, we.description, wdj.creation_date, ";
sql=sql+"       wdj.primary_item_id, msib.segment1 item_no, msib.description item_desc, ";
sql=sql+"       wdj.start_quantity, wdj.common_bom_sequence_id, ";
sql=sql+"       wdj.common_routing_sequence_id, ml.meaning status_type_disp ";
sql=sql+"  FROM wip_entities we, ";
sql=sql+"       wip_discrete_jobs wdj, ";
sql=sql+"       mtl_system_items_b msib, ";
sql=sql+"       org_organization_definitions ood, ";
sql=sql+"       mfg_lookups ml ";
sql=sql+" WHERE wdj.wip_entity_id = we.wip_entity_id ";
sql=sql+"   AND wdj.organization_id = msib.organization_id ";
sql=sql+"   AND wdj.organization_id = ood.organization_id ";
sql=sql+"   AND wdj.primary_item_id = msib.inventory_item_id ";
sql=sql+"   AND ml.lookup_code = wdj.status_type ";
sql=sql+"   AND ml.lookup_type = 'WIP_JOB_STATUS' ";
//sql=sql+"   AND wdj.status_type = 3 ";
sql=sql+"   AND we.wip_entity_id = "+wipid+" ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
if (rs.next())
{
	wono=rs.getString("wip_entity_name");
	orgid=rs.getString("organization_id");
%>
    <table bgcolor="silver">
        <tr>
            <td align="right">
                Orgnization</td>
            <td>
                <input id="Text7" readonly="readonly" style="width: 50px" type="text" value="<%=rs.getString("organization_code")%>" /></td>
            <td style="width: 374px">
            </td>
        </tr>
        <tr>
            <td align="right">
                Assembly</td>
            <td>
                <input id="Text16" readonly="readonly" style="width: 150px" type="text" value="<%=rs.getString("item_no")%>" /></td>
            <td style="width: 374px">
                <input id="Text34" readonly="readonly" size="20" style="width: 365px" type="text"
                    value="<%=rs.getString("item_desc")%>" /></td>
        </tr>
        <tr>
            <td align="right">
                Job</td>
            <td>
                <input id="Text25" readonly="readonly" style="width: 120px" type="text" value="<%=rs.getString("wip_entity_name")%>" /></td>
            <td style="width: 374px">
                <input id="Text43" readonly="readonly" size="20" style="width: 365px" type="text"
                    value="<%=rs.getString("description")%>" /></td>
        </tr>
        <tr>
            <td align="right">Status</td>
            <td><input name="text" type="text" id="text" style="width: 120px" value="<%=rs.getString("status_type_disp")%>" readonly="readonly" /></td>
            <td style="width: 374px"><input name="button" type="button" id="Button2" onClick="OpenHistories('<%=wono%>','<%=wipid%>');" value="Histories" /> </td>
        </tr>
    </table>
    <br />
<%
}
rs.close();       
statement.close();
%>
<FORM NAME="MYFORM" ACTION="yew_wip_mtl_trx_issue_wip_approve_process.jsp" METHOD="POST"> 
<%
//取得工令領料簽核
sql="";
sql=sql+"SELECT   ywmt.trx_id, ywmt.wip_entity_id, ywmt.organization_id, ywmt.subinventory_code, ";
sql=sql+"         nvl(ywmt.locator_id, 0) locator_id, ywmt.loc_segment1, ywmt.operation_seq_num, ";
sql=sql+"         ywmt.department_id, bd.department_code, ywmt.inventory_item_id, ";
sql=sql+"         msib.segment1, msib.description, ywmt.transaction_type_id, ";
sql=sql+"         mtt.transaction_type_name, ";
sql=sql+"         ABS (ywmt.transaction_quantity) transaction_quantity, msib.primary_uom_code, ";
sql=sql+"         TO_CHAR (ywmt.creation_date, 'yyyy/mm/dd') trx_date, NULL lot_number, ";
sql=sql+"         ywmt.reason_id, mtr.reason_name, ywmt.transaction_reference, ";
sql=sql+"         ywmt.created_by, fu.user_name, ";
sql=sql+"         CASE action_sequence_num ";
sql=sql+"            WHEN 0 ";
sql=sql+"               THEN '送出' ";
sql=sql+"            WHEN 10 ";
sql=sql+"               THEN '產線主管' ";
sql=sql+"            WHEN 20 ";
sql=sql+"               THEN '物管' ";
sql=sql+"            WHEN 30 ";
sql=sql+"               THEN '倉庫' ";
sql=sql+"         END action, ";
sql=sql+"         action_code, TO_CHAR (ywmt.action_date, 'yyyy/mm/dd') action_date, ";
sql=sql+"         closed_code ";
sql=sql+"    FROM yew_wip_mtl_trx ywmt, ";
sql=sql+"         mtl_system_items_b msib, ";
sql=sql+"         bom_departments bd, ";
sql=sql+"         fnd_user fu, ";
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
sql=sql+"     AND ywmt.closed_code = 'OPEN' ";
sql=sql+"     AND ywmt.action_sequence_num = "+act+" ";
sql=sql+"     AND ywmt.wip_entity_id = "+wipid+" ";
sql=sql+"ORDER BY operation_seq_num, trx_date ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
%>
	<table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td align="center" bgcolor="silver">
                <input type="button" name="all" value="全選" onClick="SelectAll(this);" /></td>
            <td align="center" bgcolor="silver">
                Item</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Quantity</td>
            <td align="center" bgcolor="silver">
                Lot</td>
            <td align="center" bgcolor="silver">
                Required</td>
            <td align="center" bgcolor="silver">
                Issued</td>
            <td align="center" bgcolor="silver">
                Process</td>
            <td align="center" bgcolor="silver">
                Excess</td>
            <td align="center" bgcolor="silver">
                Available</td>
            <td align="center" bgcolor="silver">
                SubInv</td>
            <td align="center" bgcolor="silver">
                Locator</td>
            <td align="center" bgcolor="silver">
                Op Seq</td>
            <td align="center" bgcolor="silver">
                Dept</td>
            <td align="center" bgcolor="silver">
                Reason</td>
            <td align="center" bgcolor="silver">
                Reference</td>
            <td align="center" bgcolor="silver">
                Creation Date</td>
            <td align="center" bgcolor="silver">
                Action</td>
            <td align="center" bgcolor="silver">
                Action Date</td>
            <td align="center" bgcolor="silver">
                Status</td>
        </tr>
<%
i=0;
while (rs.next())
{
	i++;
	required_qty = 0;
	issued_qty = 0;
	process_qty = 0;
	excess_qty = 0;
	available_qty = 0;
	//取得工令領料數量(含簽核中)
	sql="";
	sql=sql+"SELECT we.wip_entity_name, wrov.wip_entity_id, wrov.inventory_item_id, ";
	sql=sql+"       wrov.organization_id, wrov.concatenated_segments, ";
	sql=sql+"       wrov.item_description, wrov.operation_seq_num, wrov.department_id, ";
	sql=sql+"       wrov.department_code, wrov.item_primary_uom_code, ";
	sql=sql+"       wrov.required_quantity, ";
	sql=sql+"       TO_NUMBER (NVL (wrov.quantity_issued, '0')) quantity_issued, ";
	sql=sql+"       ABS (NVL (ywm.process_qty, 0)) quantity_process, ";
	sql=sql+"       CASE ";
	sql=sql+"          WHEN (  (  TO_NUMBER (NVL (wrov.quantity_issued, '0')) ";
	sql=sql+"                   + ABS (NVL (ywm.process_qty, 0)) ";
	sql=sql+"                  ) ";
	sql=sql+"                - wrov.required_quantity ";
	sql=sql+"               ) > 0 ";
	sql=sql+"             THEN (  (  TO_NUMBER (NVL (wrov.quantity_issued, '0')) ";
	sql=sql+"                      + ABS (NVL (ywm.process_qty, 0)) ";
	sql=sql+"                     ) ";
	sql=sql+"                   - wrov.required_quantity ";
	sql=sql+"                  ) ";
	sql=sql+"          ELSE 0 ";
	sql=sql+"       END quantity_excess ";
	sql=sql+"  FROM wip_entities we, ";
	sql=sql+"       wip_requirement_operations_v wrov, ";
	sql=sql+"       mtl_system_items_b msib, ";
	sql=sql+"       (SELECT   wip_entity_id, organization_id, inventory_item_id, ";
	sql=sql+"                 SUM (transaction_quantity) process_qty ";
	sql=sql+"            FROM yew_wip_mtl_trx ";
	sql=sql+"           WHERE closed_code = 'OPEN' ";
	sql=sql+"        GROUP BY wip_entity_id, organization_id, inventory_item_id) ywm ";
	sql=sql+" WHERE wrov.wip_entity_id = we.wip_entity_id ";
	sql=sql+"   AND wrov.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"   AND wrov.organization_id = msib.organization_id ";
	sql=sql+"   AND wrov.wip_entity_id = ywm.wip_entity_id(+) ";
	sql=sql+"   AND wrov.inventory_item_id = ywm.inventory_item_id(+) ";
	sql=sql+"   AND wrov.organization_id = ywm.organization_id(+) ";
	sql=sql+"   AND wrov.routing_exists_flag = 1 ";
	sql=sql+"   AND wrov.wip_entity_id = "+wipid+" ";
	sql=sql+"   AND wrov.inventory_item_id = "+rs.getInt("inventory_item_id")+" ";
	sql=sql+"   AND wrov.organization_id = "+rs.getInt("organization_id")+" ";
	sql=sql+"UNION ";
	sql=sql+"SELECT   ywmt.wip_entity_name, ywmt.wip_entity_id, ywmt.inventory_item_id, ";
	sql=sql+"         ywmt.organization_id, msib.segment1, msib.description, ";
	sql=sql+"         ywmt.operation_seq_num, ywmt.department_id, bd.department_code, ";
	sql=sql+"         msib.primary_uom_code, 0 required_quantity, 0 quantity_issued, ";
	sql=sql+"         SUM (ABS (ywmt.transaction_quantity)) quantity_process, ";
	sql=sql+"         SUM (ABS (ywmt.transaction_quantity)) quantity_excess ";
	sql=sql+"  FROM yew_wip_mtl_trx ywmt, ";
	sql=sql+"       mtl_system_items_b msib, ";
	sql=sql+"       bom_departments bd ";
	sql=sql+" WHERE ywmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"   AND ywmt.organization_id = msib.organization_id ";
	sql=sql+"   AND ywmt.department_id = bd.department_id ";
	sql=sql+"   AND ywmt.closed_code = 'OPEN' ";
	sql=sql+"   AND ywmt.inventory_item_id NOT IN ( ";
	sql=sql+"          SELECT inventory_item_id ";
	sql=sql+"            FROM wip_requirement_operations_v ";
	sql=sql+"           WHERE routing_exists_flag = 1 ";
	sql=sql+"                 AND wip_entity_id = ywmt.wip_entity_id) ";
	sql=sql+"   AND ywmt.wip_entity_id = "+wipid+" ";
	sql=sql+"   AND ywmt.inventory_item_id = "+rs.getInt("inventory_item_id")+" ";
	sql=sql+"   AND ywmt.organization_id = "+rs.getInt("organization_id")+" ";
	sql=sql+"GROUP BY ywmt.wip_entity_name, ";
	sql=sql+"         ywmt.wip_entity_id, ";
	sql=sql+"         ywmt.inventory_item_id, ";
	sql=sql+"         ywmt.organization_id, ";
	sql=sql+"         msib.segment1, ";
	sql=sql+"         msib.description, ";
	sql=sql+"         ywmt.operation_seq_num, ";
	sql=sql+"         ywmt.department_id, ";
	sql=sql+"         bd.department_code, ";
	sql=sql+"         msib.primary_uom_code ";
	sql=sql+"ORDER BY operation_seq_num ";
	statement2=con.createStatement();
	rs2=statement2.executeQuery(sql); 
	if (rs2.next())
	{
		required_qty = rs2.getFloat("required_quantity");
		issued_qty = rs2.getFloat("quantity_issued");
		process_qty = rs2.getFloat("quantity_process")-rs.getFloat("transaction_quantity");
		excess_qty = rs2.getFloat("quantity_excess");
	}
	rs2.close();       
	statement2.close();
	//讀取onhand數
	sql="";
	sql=sql+"SELECT sum(primary_transaction_quantity) onhand ";
	sql=sql+"  FROM mtl_onhand_quantities_detail ";
	sql=sql+" WHERE organization_id = "+rs.getString("organization_id")+" ";
	sql=sql+"   AND inventory_item_id = "+rs.getString("inventory_item_id")+" ";
	sql=sql+"   AND subinventory_code = '"+rs.getString("subinventory_code")+"' ";
	sql=sql+"   AND NVL (locator_id, 0) = "+rs.getString("locator_id")+" ";
	statement2=con.createStatement();
	rs2=statement2.executeQuery(sql); 
	if (rs2.next())
	{
		available_qty = rs2.getFloat("onhand") - process_qty;
	}
	rs2.close();       
	statement2.close();
	//檢查是否有lot
	LotFlag = false;
	sql="SELECT COUNT (trx_id) FROM yew_wip_mtl_lots WHERE trx_id = "+rs.getString("trx_id");
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
            <td>
				<input type="hidden" name="trx_id<%=i%>" value="<%=rs.getString("trx_id")%>" >
                <input type="checkbox" name="action<%=i%>" value="1" >
			</td>
            <td nowrap="nowrap">
                <input type="hidden" name="item_id<%=i%>" value="<%=rs.getString("inventory_item_id")%>" >
                <input type="hidden" name="item_no<%=i%>" value="<%=rs.getString("segment1")%>" >
				<%=rs.getString("segment1")%></td>
            <td>
                <%=rs.getString("description")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("primary_uom_code")%></td>
            <td nowrap="nowrap">
                <input type="hidden" name="original_qty<%=i%>" value="<%=rs.getString("transaction_quantity")%>" >
                <input type="text" name="trx_qty<%=i%>" value="<%=rs.getString("transaction_quantity")%>" size="10" onBlur="chkTrxQty(trx_qty<%=i%>,<%=available_qty%>);" readonly="readOnly" />
			</td>
            <td nowrap="nowrap">
				<input type="hidden" name="lot<%=i%>" value="0" />
				<input type="hidden" name="lot_qty<%=i%>" value="<%=rs.getString("transaction_quantity")%>" />
                <%if (LotFlag) {%>
					<%if (act_num==30) {%>
				<input type="button" value="Lot" onClick="OpenLot(orgid.value,item_id<%=i%>.value,sub_inv<%=i%>.value,locator_id<%=i%>.value,trx_qty<%=i%>.value,trx_id<%=i%>.value,lot<%=i%>.value,<%=i%>);"  />
					<%} else {%>
				<input type="button" value="Lot" onClick="OpenLot('<%=rs.getString("trx_id")%>');" />
					<%}%>
				<%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
				<%=required_qty%></td>
            <td nowrap="nowrap">
				<%=issued_qty%></td>
            <td nowrap="nowrap">
				<%=process_qty%></td>
            <td nowrap="nowrap">
				<%if (excess_qty>0) {%><font color="#FF0000" ><%}%>
				<%=excess_qty%>
				<%if (excess_qty>0) {%></font><%}%></td>
            <td nowrap="nowrap">
				<%=available_qty%></td>
            <td nowrap="nowrap">
                <input type="hidden" name="sub_inv<%=i%>" value="<%=rs.getString("subinventory_code")%>" >
                <%=rs.getString("subinventory_code")%></td>
            <td nowrap="nowrap">
                <input type="hidden" name="locator_id<%=i%>" value="<%=rs.getString("locator_id")%>" >
                <%if (rs.getString("loc_segment1") != null) {%><%=rs.getString("loc_segment1")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%=rs.getString("operation_seq_num")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("department_code")%></td>
            <td nowrap="nowrap">
                <%if (rs.getString("reason_name") != null) {%><%=rs.getString("reason_name")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs.getString("transaction_reference") != null) {%><%=rs.getString("transaction_reference")%><%}else{%>&nbsp;<%}%></td>
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
j = i;
%>
    </table>
    <br />
	<input type="hidden" name="orgid" value="<%=orgid%>" />
	<input type="hidden" name="wono" value="<%=wono%>" />
	<input type="hidden" name="wipid" value="<%=wipid%>" />
	<input type="hidden" name="act_num" value="<%=act_num%>" />
	<input type="hidden" name="num" value="<%=j%>" />
	<input type="hidden" name="action_code" value="" />
    <input type="button" name="Back" value="Back" onClick="DoBack();" />
    <input type="button" name="Reject" value="Reject" onClick="DoSubmit('REJECT');" />
    <%if (act_num==30) {%>
	<input type="button" name="Approve" value="Approve" onClick="DoSubmit('APPROVE');" />
    <%} else {%>
	<input type="button" name="Approve" value="Forward" onClick="DoSubmit('FORWARD');" />
	<%}%>
<%
rs.close();       
statement.close();
%>
</FORM>
<script language="javascript">
function chkSubmit()
{
	var flag=false;
	var t=0;
	<%for (i=1;i<=j;i++) {%>
	if (MYFORM.action<%=i%>.checked)
	{
		flag=true;
		MYFORM.trx_qty<%=i%>.value = MYFORM.trx_qty<%=i%>.value.Trim();
		if ((parseFloat(MYFORM.lot_qty<%=i%>.value) != parseFloat(MYFORM.trx_qty<%=i%>.value)))
		{
			alert(MYFORM.item_no<%=i%>.value+'有LOT控管, 領用數和LOT數量不同\n請挑選LOT或輸入正確的數量');
			MYFORM.trx_qty<%=i%>.focus();
			return false;
		}
	}
	<%}%>
	if (!flag)
	{
		alert('請選取要進行動作的領料!!');
		return false;
	}
	else
		return true;
}

function SelectAll(obj)
{
	if (obj.value == '全選')
	{
		<%for (i=1;i<=j;i++) {%>
		MYFORM.action<%=i%>.checked = true;
		<%}%>
		obj.value = '全取消';
	}
	else
	{
		<%for (i=1;i<=j;i++) {%>
		MYFORM.action<%=i%>.checked = false;
		<%}%>
		obj.value = '全選';
	}
}
</script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

