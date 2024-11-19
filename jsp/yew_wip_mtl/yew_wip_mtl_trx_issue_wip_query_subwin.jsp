<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - 未完工工令查詢</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>

<%   
Statement statement;
ResultSet rs;
String sql="";
int i=0;
String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String wono=request.getParameter("wono");  
if (wono==null) wono="";
String num=request.getParameter("num");  
if (num==null && wono.length()==0)
{
	wono="請輸入工令號";
}
%>

<script language="JavaScript" type="text/JavaScript">
function SendData(wono)
{    
	window.opener.search.wono.value = wono;
	window.opener.search.Submit1.disabled = true;
	try
	{
		window.opener.MYFORM.Submit2.disabled = true;
	}
	catch(e)
	{
	}
	window.opener.search.submit();
	window.close();
} 

function DoFind()
{
	search.wono.value = search.wono.value.Trim();
	if (search.wono.value == '' || search.wono.value == '%')
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
<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST" onSubmit="Submit1.disabled=true;"> 
	<input type="hidden" name="orgid" value="<%=orgid%>" />
    <input id="Text1" type="text" name="wono" value="<%=wono%>" onClick="if (this.value=='請輸入工令號') this.value = '';" />
    <input id="find" name="find" type="button" value="Find" onClick="DoFind();" disabled="disabled" /><br />
    <br />
<%
if (orgid.length()>0)
{
	//取得未完工工令清單
	sql="";
	sql=sql+"SELECT wdj.organization_id, ood.organization_name, we.wip_entity_id, ";
	sql=sql+"       we.wip_entity_name, we.description, wdj.creation_date, ";
	sql=sql+"       wdj.primary_item_id, msib.segment1 item_no, msib.description item_desc, ";
	sql=sql+"       wdj.start_quantity, wdj.common_bom_sequence_id, ";
	sql=sql+"       wdj.common_routing_sequence_id ";
	sql=sql+"  FROM wip_entities we, ";
	sql=sql+"       wip_discrete_jobs wdj, ";
	sql=sql+"       mtl_system_items_b msib, ";
	sql=sql+"       org_organization_definitions ood ";
	sql=sql+" WHERE wdj.wip_entity_id = we.wip_entity_id ";
	sql=sql+"   AND wdj.organization_id = msib.organization_id ";
	sql=sql+"   AND wdj.organization_id = ood.organization_id ";
	sql=sql+"   AND wdj.primary_item_id = msib.inventory_item_id ";
	sql=sql+"   AND wdj.status_type = 3 "; //3=Released, 4=Complete
	sql=sql+"   AND wdj.organization_id = " + orgid + " ";
	sql=sql+"   AND we.wip_entity_name like '" + wono + "%' ";
	if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0)) //若不是admin則加入部門條件
		sql=sql+"   AND SUBSTR (we.wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
	sql=sql+"ORDER BY we.wip_entity_name ";
	statement=con.createStatement();
	rs=statement.executeQuery(sql); 
%>
    <table border="1" cellspacing="0" bordercolor="#000000">
        <tr>
            <td align="center" bgcolor="silver">
                Job</td>
            <td align="center" bgcolor="silver">
                Assembly</td>
            <td align="center" bgcolor="silver">&nbsp;
                </td>
        </tr>
<%
	while (rs.next())
	{    
		i++;        
%>
        <tr>
            <td nowrap="noWrap">
                <%=rs.getString("wip_entity_name")%></td>
            <td>
                <%=rs.getString("item_desc")%></td>
            <td>
                <input id="Button1" type="button" value="Select" onClick="SendData('<%=rs.getString("wip_entity_name")%>');" /></td>
        </tr>

<%
	} //end of while	
%>
    </table>
<%
	rs.close();       
	statement.close();
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
	alert('請先選擇Orgnization');
	window.close();
	</script>
<%
}
%>
<input type="hidden" name="num" value="<%=i%>" />
</FORM>
<script language="JavaScript" type="text/JavaScript">
	search.find.disabled=false;
</script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

