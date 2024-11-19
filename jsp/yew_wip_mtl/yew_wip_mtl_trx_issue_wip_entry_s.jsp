<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - Specific</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";
String wipid="";
String trx_qty_str="";
int i, trx_id, num=5;
float trx_qty, available_qty;

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

function OpenItem(orgid,wipid,wono,num)
{    
	var item_from = '';
	if (confirm('是否為工令料號(BOM)?'))
		item_from = 'bom'
	else
		item_from = 'specific';
	subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_item.jsp?orgid="+orgid+"&wipid="+wipid+"&wono="+wono+"&item_from="+item_from+"&num="+num,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");
	subWin.focus();  
} 

function OpenSubinv(orgid,itemid,dept,wipid,num)
{    
	if (itemid.length>0)
	{
		if (dept.length>0)
		{
			subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_subinv.jsp?orgid="+orgid+"&itemid="+itemid+"&dept="+dept+"&wipid="+wipid+"&num="+num,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
			subWin.focus();
		}
		else
			alert('請先選擇Op Seq.');
	}
	else
		alert('請先選擇Item.');  
} 

function OpenOP(wipid,num)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_entry_op.jsp?wipid="+wipid+"&num="+num,"subwin","width=300,height=200,status=yes,scrollbars=yes,resizable=yes");  
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
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;工令領料-Specific</FONT>
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
            <td style="width: 374px">            </td>
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
for (i=1;i<=num;i++)
{
	trx_id = 0;
%>
        <tr>
            <td nowrap="nowrap">
                <input id="trx_id<%=i%>" type="hidden" value="" name="trx_id<%=i%>" />
				<input id="item_id<%=i%>" type="hidden" value="" name="item_id<%=i%>" />
                <input id="item_no<%=i%>" style="width: 150px" type="text" readonly="readOnly" value="" name="item_no<%=i%>" />
				<input id="Button1" type="button" value="..." onClick="OpenItem(orgid.value,<%=wipid%>,'<%=wono%>',<%=i%>);" />
			</td>
            <td>
                <span id='item_desc<%=i%>_l'>&nbsp;</span>
			</td>
            <td nowrap="nowrap">
                <input id="sub_inv<%=i%>" type="text" value="" name="sub_inv<%=i%>" readonly="readOnly" size="3" />
				<input id="Button1"type="button" value="..." onClick="OpenSubinv(orgid.value,item_id<%=i%>.value,dept_code<%=i%>.value,<%=wipid%>,<%=i%>);" />
			</td>
            <td nowrap="nowrap">
				<input id="locator_id<%=i%>" type="hidden" value="" name="locator_id<%=i%>" />
				<input id="locator<%=i%>" type="text" value="" readonly="readOnly" size="2" name="locator<%=i%>" />
			</td>
            <td nowrap="nowrap">
                <input id="op_seq<%=i%>" type="text" value="" name="op_seq<%=i%>" readonly="readOnly" size="3" />
				<input id="Button3" type="button" value="..." name="op_seq_btn<%=i%>" onClick="OpenOP(<%=wipid%>,<%=i%>);" />
			</td>
            <td nowrap="nowrap">
				<input id="dept_id<%=i%>" type="hidden" value="" name="dept_id<%=i%>" />
				<input id="dept_code<%=i%>" type="text" value="" readonly="readOnly" size="3" name="dept_code<%=i%>" />
			</td>
            <td nowrap="nowrap">
				<input id="uom<%=i%>" type="text" value="" readonly="readOnly" size="3" name="uom<%=i%>" />
			</td>
            <td nowrap="nowrap">&nbsp;
                
			</td>
            <td nowrap="nowrap">
                <input id="trx_qty<%=i%>" type="text" value="<%=trx_qty_str%>" name="trx_qty<%=i%>" size="10" onBlur="chkTrxQty(trx_qty<%=i%>,parseFloat(available<%=i%>.value));" />
			</td>
            <td nowrap="nowrap">
				<input id="lot<%=i%>" type="hidden" value="" name="lot<%=i%>" />
				<input id="lot_qty<%=i%>" type="hidden" value="0" name="lot_qty<%=i%>" />
                <input id="lot_btn<%=i%>" type="button" value="Lot" name="lot_btn<%=i%>" onClick="OpenLot(orgid.value,item_id<%=i%>.value,sub_inv<%=i%>.value,locator_id<%=i%>.value,trx_qty<%=i%>.value,trx_id<%=i%>.value,lot<%=i%>.value,<%=i%>);" disabled/>
				<font color="#FF0000"><span id='lot<%=i%>_l'>&nbsp;</span></font>
			</td>
            <td nowrap="nowrap">
				<input id="available<%=+i%>" type="hidden" value="0" name="available<%=i%>" />
                <span id="available<%=+i%>_l"></span>
			</td>
            <td nowrap="nowrap">
				<input id="onhand<%=i%>" type="hidden" value="" name="onhand<%=i%>" />
                <span id="onhand<%=i%>_l"></span>
			</td>
            <td nowrap="nowrap">
				<input id="reason_id<%=i%>" type="hidden" name="reason_id<%=i%>" />
				<input id="reason<%=i%>" type="text" name="reason<%=i%>" readonly="readonly" />
				<input id="Button6" type="button" value="..." onClick="OpenReason('<%=i%>');" />
			</td>
            <td nowrap="nowrap">
                <input id="ref<%=i%>" type="text" name="ref<%=i%>" />
			</td>
        </tr>
<%
} //end of while	
%>
    </table>
    <br />
	<input type="hidden" name="orgid" value="<%=orgid%>" />
	<input type="hidden" name="wono" value="<%=wono%>" />
	<input type="hidden" name="wipid" value="<%=wipid%>" />
	<input type="hidden" name="num" value="<%=num%>" />
    <input type="button" name="Cancel1" value="Cancel" onClick="DoCancel();" />
    <input type="button" name="Reset1" value="Reset" onClick="DoReset();" />
    <input type="button" name="Submit1" value="Submit" onClick="DoSubmit();" />
</FORM>
<script language="javascript">
function chkSubmit()
{
	var t=0;
	<%for (i=1;i<=num;i++) {%>
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
				alert(MYFORM.item_no<%=i%>.value+'有LOT控管, LOT數量和領用數不同\n請挑選LOT或輸入0');
				MYFORM.trx_qty<%=i%>.focus();
				return false;
			}
		}
		else
		{
			alert(MYFORM.item_no<%=i%>.value+'有LOT控管, LOT數量和領用數不同\n請挑選LOT或輸入0');
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

