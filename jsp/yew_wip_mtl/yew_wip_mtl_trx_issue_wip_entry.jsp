<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - BOM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
Statement statement2;
PreparedStatement prestatement;
ResultSet rs;
ResultSet rs2;
String sql="";
String wipid="";
String trx_qty_str="";
int i, j, trx_id;
float trx_qty, available_qty;
boolean trx_flag;

String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String wono=request.getParameter("wono");  
if (wono==null) wono="";
%>

<script language="JavaScript" type="text/JavaScript">
function OpenHistories(wono,wipid)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_histories.jsp?wono="+wono+"&wipid="+wipid,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
	subWin.focus();
} 

function OpenSubinv(orgid,itemid,dept,wipid,num)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_subinv.jsp?orgid="+orgid+"&itemid="+itemid+"&dept="+dept+"&wipid="+wipid+"&num="+num,"subwin","width=600,height=480,status=yes,scrollbars=yes,resizable=yes");
	subWin.focus();  
} 

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

function OpenReason(num)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_reason.jsp?num="+num,"subwin","width=400,height=480,status=yes,scrollbars=yes,resizable=yes"); 
	subWin.focus(); 
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
		if (parseFloat(obj.value)>available || parseFloat(obj.value)<0)
		{
			alert('數量不可大於Available或小於0');
			obj.focus();
			return false;
		}
	}
	else
		return true;
}

function DoCancel()
{
	if (confirm('確認取消?'))
	{
		MYFORM.action="yew_wip_mtl_trx_issue_wip_entry_process.jsp?cancel=y";
		MYFORM.Cancel1.disabled = true;
		MYFORM.Reset1.disabled = true;
		MYFORM.Submit1.disabled = true;
		MYFORM.submit();
	}
}

function DoReset()
{
	if (confirm('確認重置?')) MYFORM.reset();
}

function DoSubmit()
{
	if (chkSubmit())
		if (confirm('確認送出?'))
		{
			MYFORM.Cancel1.disabled = true;
			MYFORM.Reset1.disabled = true;
			MYFORM.Submit1.disabled = true;
			MYFORM.submit();
		}
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
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;工令領料-BOM</FONT>
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
sql=sql+"   AND wdj.status_type = 3 ";
sql=sql+"   AND wdj.organization_id = "+orgid+" ";
sql=sql+"   AND we.wip_entity_name = '"+wono+"' ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
if (rs.next())
{
	wipid=rs.getString("wip_entity_id");
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
<FORM NAME="MYFORM" ACTION="yew_wip_mtl_trx_issue_wip_entry_process.jsp" METHOD="POST"> 
<%
//取得工令站別需求量
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
sql=sql+"       END quantity_excess, ";
sql=sql+"       CASE ";
sql=sql+"          WHEN (NVL (wrov.quantity_open, 0) - ABS (NVL (ywm.process_qty, 0)) ";
sql=sql+"               ) > 0 ";
sql=sql+"             THEN (NVL (wrov.quantity_open, 0) - ABS (NVL (ywm.process_qty, 0))) ";
sql=sql+"          ELSE 0 ";
sql=sql+"       END quantity_open, ";
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
sql=sql+"       (SELECT   wip_entity_id, organization_id, inventory_item_id, ";
sql=sql+"                 SUM (transaction_quantity) process_qty ";
sql=sql+"            FROM yew_wip_mtl_trx ";
sql=sql+"           WHERE closed_code = 'OPEN' ";
sql=sql+"        GROUP BY wip_entity_id, organization_id, inventory_item_id) ywm, ";
sql=sql+"       (SELECT   organization_id, inventory_item_id, ";
sql=sql+"                 SUM (transaction_quantity) process_qty ";
sql=sql+"            FROM yew_wip_mtl_trx ";
sql=sql+"           WHERE closed_code = 'OPEN' ";
sql=sql+"        GROUP BY organization_id, inventory_item_id) ywm2 ";
sql=sql+" WHERE wrov.wip_entity_id = we.wip_entity_id ";
sql=sql+"   AND wrov.inventory_item_id = msib.inventory_item_id ";
sql=sql+"   AND wrov.organization_id = msib.organization_id ";
sql=sql+"   AND wrov.inventory_item_id = qoh.inventory_item_id(+) ";
sql=sql+"   AND wrov.organization_id = qoh.organization_id(+) ";
sql=sql+"   AND wrov.wip_entity_id = ywm.wip_entity_id(+) ";
sql=sql+"   AND wrov.inventory_item_id = ywm.inventory_item_id(+) ";
sql=sql+"   AND wrov.organization_id = ywm.organization_id(+) ";
sql=sql+"   AND wrov.inventory_item_id = ywm2.inventory_item_id(+) ";
sql=sql+"   AND wrov.organization_id = ywm2.organization_id(+) ";
sql=sql+"   AND wrov.routing_exists_flag = 1 ";
sql=sql+"   AND wrov.quantity_open IS NOT NULL ";  //可領料, mark此列可顯示所有的料品
sql=sql+"   AND wrov.wip_entity_id = "+wipid+" ";
sql=sql+"ORDER BY operation_seq_num ";
statement=con.createStatement();
rs=statement.executeQuery(sql); 
%>
	<font color="#FF0000">※</font>表示LOT控管<br>
	<table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td align="center" bgcolor="silver">
                Item</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                SubInv</td>
            <td align="center" bgcolor="silver">
                Locator</td>
            <td align="center" bgcolor="silver">
                Op Seq</td>
            <td align="center" bgcolor="silver">
                Dept</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Required Qty</td>
            <td align="center" bgcolor="silver">
                Quantity</td>
            <td align="center" bgcolor="silver">
                Lot</td>
            <td align="center" bgcolor="silver">
                Available</td>
            <td align="center" bgcolor="silver">
                On-hand</td>
            <td align="center" bgcolor="silver">
                Reason</td>
            <td align="center" bgcolor="silver">
                Reference</td>
        </tr>
<%
i=0;
while (rs.next())
{
	i++;
	trx_id = 0;
	available_qty = rs.getFloat("available");
	trx_qty = rs.getFloat("quantity_open");
	trx_qty_str = rs.getString("quantity_open");
	if (available_qty<trx_qty)
	{
		trx_qty=available_qty;
		trx_qty_str = rs.getString("available");
	}
	
	if ((available_qty<=0.0) || (trx_qty<=0.0))
	{
		trx_flag = false;
	}
	else
	{
		trx_flag = true;
	}
	if (trx_flag)
	{
		//建立yew_wip_mtl_trx_temp
		sql="";
		sql=sql+"INSERT INTO YEW_WIP_MTL_TRX_TEMP ";
		sql=sql+"	(TRX_ID, INVENTORY_ITEM_ID, ORGANIZATION_ID, LAST_UPDATE_DATE, LAST_UPDATED_BY, ";
		sql=sql+"		CREATION_DATE, CREATED_BY, WIP_ENTITY_ID, WIP_ENTITY_NAME, TRANSACTION_UOM, ";
		sql=sql+"		TRANSACTION_QUANTITY) ";
		sql=sql+"	VALUES(seq_yew_wip_mtl_trx.nextval,?,?,sysdate,?,sysdate,?,?,?,?,0) ";
		prestatement=con.prepareStatement(sql); 
		prestatement.setInt(1,rs.getInt("inventory_item_id"));    //INVENTORY_ITEM_ID
		prestatement.setInt(2,rs.getInt("organization_id"));    //ORGANIZATION_ID
		prestatement.setInt(3,Integer.parseInt(userMfgUserID));      //LAST_UPDATED_BY
		prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //CREATED_BY
		prestatement.setInt(5,rs.getInt("wip_entity_id"));      //WIP_ENTITY_ID
		prestatement.setString(6,rs.getString("wip_entity_name"));      //WIP_ENTITY_NAME    
		prestatement.setString(7,rs.getString("item_primary_uom_code")); //TRANSACTION_UOM        	   
		prestatement.executeUpdate();
		prestatement.close();	      	
	
		//抓取寫入yew_wip_mtl_trx_temp的transaction_id
		sql = "SELECT seq_yew_wip_mtl_trx.CURRVAL FROM DUAL";
		statement2=con.createStatement();
		rs2=statement2.executeQuery(sql);
		if (rs2.next())
		{
			trx_id = rs2.getInt(1);
		}
		rs2.close();
		statement2.close();
	}
%>
        <tr>
            <td nowrap="nowrap">
                <input id="trx_id<%=i%>" type="hidden" value="<%=trx_id%>" name="trx_id<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
                <input id="item_id<%=i%>" type="hidden" value="<%=rs.getString("inventory_item_id")%>" name="item_id<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
                <input id="item_no<%=i%>" type="hidden" value="<%=rs.getString("concatenated_segments")%>" name="item_no<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
				<%=rs.getString("concatenated_segments")%>
			</td>
            <td>
                <%=rs.getString("item_description")%>
			</td>
            <td nowrap="nowrap">
                <input id="sub_inv<%=i%>" type="text" value="" name="sub_inv<%=i%>" readonly="readOnly" size="3" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="Button1"type="button" value="..." onClick="OpenSubinv(orgid.value,item_id<%=i%>.value,dept_code<%=i%>.value,<%=wipid%>,<%=i%>);" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
				<input id="locator_id<%=i%>" type="hidden" value="" name="locator_id<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="locator<%=i%>" type="text" value="" readonly="readOnly" size="2" name="locator<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
                <input id="op_seq<%=i%>" type="text" value="<%=rs.getString("operation_seq_num")%>" name="op_seq<%=i%>" readonly="readOnly" size="3" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
				<input id="dept_id<%=i%>" type="hidden" value="<%=rs.getString("department_id")%>" name="dept_id<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="dept_code<%=i%>" type="text" value="<%=rs.getString("department_code")%>" readonly="readOnly" size="3" name="dept_code<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
				<input id="uom<%=i%>" type="text" value="<%=rs.getString("item_primary_uom_code")%>" readonly="readOnly" size="3" name="uom<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
                <%=rs.getString("quantity_open")%>
			</td>
            <td nowrap="nowrap">
                <input id="trx_qty<%=i%>" type="text" value="<%=trx_qty_str%>" name="trx_qty<%=i%>" size="10" onBlur="chkTrxQty(trx_qty<%=i%>,parseFloat(available<%=i%>.value));" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
				<input id="lot<%=i%>" type="hidden" value="<%=rs.getString("lot_control_code")%>" name="lot<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="lot_qty<%=i%>" type="hidden" value="0" name="lot_qty<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
                <input id="Button5" type="button" value="Lot" onClick="OpenLot(orgid.value,item_id<%=i%>.value,sub_inv<%=i%>.value,locator_id<%=i%>.value,trx_qty<%=i%>.value,trx_id<%=i%>.value,lot<%=i%>.value,<%=i%>);" <%if (!trx_flag || rs.getInt("lot_control_code")!=2) {%> disabled<%};%> /><%if (rs.getInt("lot_control_code")==2) {%><font color="#FF0000">※</font><%};%>
			</td>
            <td nowrap="nowrap">
				<input id="available<%=+i%>" type="hidden" value="<%=rs.getString("available")%>" name="available<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
                <span id="available<%=+i%>_l"><%=rs.getString("available")%></span>
			</td>
            <td nowrap="nowrap">
				<input id="onhand<%=i%>" type="hidden" value="<%=rs.getString("onhand")%>" name="onhand<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
                <span id="onhand<%=i%>_l"><%=rs.getString("onhand")%></span>
			</td>
            <td nowrap="nowrap">
				<input id="reason_id<%=i%>" type="hidden" name="reason_id<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="reason<%=i%>" type="text" name="reason<%=i%>" readonly="readonly" <%if (!trx_flag) {%> disabled<%};%> />
				<input id="Button6" type="button" value="..." onClick="OpenReason('<%=i%>');" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
            <td nowrap="nowrap">
                <input id="ref<%=i%>" type="text" name="ref<%=i%>" <%if (!trx_flag) {%> disabled<%};%> />
			</td>
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
	<input type="hidden" name="num" value="<%=j%>" />
    <input type="button" name="Cancel1" value="Cancel" onClick="DoCancel();" />
    <input type="button" name="Reset1" value="Reset" onClick="DoReset();" />
    <input type="button" name="Submit1" value="Submit" onClick="DoSubmit();" />
<%
rs.close();       
statement.close();
%>
</FORM>
<script language="javascript">
function chkSubmit()
{
	var t=0;
	<%for (i=1;i<=j;i++) {%>
	MYFORM.trx_qty<%=i%>.value = MYFORM.trx_qty<%=i%>.value.Trim();
	if (MYFORM.sub_inv<%=i%>.value=="" || MYFORM.trx_qty<%=i%>.value=="") MYFORM.trx_qty<%=i%>.value="0";
	t += parseFloat(MYFORM.trx_qty<%=i%>.value);
	if ((parseFloat(MYFORM.lot<%=i%>.value)==2) && (parseFloat(MYFORM.lot_qty<%=i%>.value) != parseFloat(MYFORM.trx_qty<%=i%>.value)))
	{
		if (parseFloat(MYFORM.trx_qty<%=i%>.value)==0)
		{
			if (confirm(MYFORM.item_no<%=i%>.value+'\n是否清空已選LOT?'))
			{
				MYFORM.lot_qty<%=i%>.value = "0";
			}
			else
			{
				alert(MYFORM.item_no<%=i%>.value+'有LOT控管, 領用數和LOT數量不同\n請挑選LOT或輸入0');
				MYFORM.trx_qty<%=i%>.focus();
				return false;
			}
		}
		else
		{
			alert(MYFORM.item_no<%=i%>.value+'有LOT控管, 領用數和LOT數量不同\n請挑選LOT或輸入0');
			MYFORM.trx_qty<%=i%>.focus();
			return false;
		}
	}
	<%}%>
	if (t==0)
	{
		alert('沒有任何的領料!!');
		return false;
	}
	else
		return true;
}
</script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

