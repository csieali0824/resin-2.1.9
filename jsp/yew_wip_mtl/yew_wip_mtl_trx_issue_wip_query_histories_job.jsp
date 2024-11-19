<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 明細查詢 - Job Info</title>
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
%>

<script language="JavaScript" type="text/JavaScript">
function OpenHistories(wono,wipid)
{    
	subWin=window.open("yew_wip_mtl_trx_issue_wip_histories.jsp?wono="+wono+"&wipid="+wipid,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
	subWin.focus();
} 

function CloseSubWin()
{    
	try {subWin.close();}
	catch(e) {}
} 
</script>

<body onUnload="CloseSubWin();">
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;明細查詢 - Job Info</FONT>
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
<input type="button" name="Close" value="Close" onClick="window.close();" />
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

