<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%   
Statement statement;
ResultSet rs;
String sql="";
int maxrow=0;//查詢資料總筆數 
String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String wono=request.getParameter("wono");  
if (wono==null) wono="";
%>

<script language="JavaScript" type="text/JavaScript">
function QueryWo(orgid,wono)
{    
	if(orgid.length>0)
	{
		subWin=window.open("yew_wip_mtl_trx_issue_wip_query_subwin.jsp?orgid="+orgid+"&wono="+wono,"subwin","width=400,height=480,status=yes,scrollbars=yes,resizable=yes");
		subWin.focus();
	}
	else
		alert('請先選擇Orgnization');  
} 

function chkSubmit()
{
	search.Submit1.disabled=true;
	MYFORM.Submit2.disabled=true;
	r=MYFORM.R1
	for (i=0;i<r.length;i++) 
	{ 
		if(r[i].checked)
		{
			MYFORM.action=r[i].value;
			break;
		}
	} 
}

function CloseSubWin()
{    
	try {subWin.close();}
	catch(e) {}
} 
</script>

<body onUnload="CloseSubWin();">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<br><br>
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;領料作業</FONT>
<br><br>

<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST" onSubmit(Submit1.disabled=true;) > 
	<table border="0" bgcolor="silver">
		<tr>
			<td>
		    Orgnization
<%
try
{
	//取得org
	sql="SELECT organization_id, organization_code, organization_name FROM org_organization_definitions where OPERATING_UNIT=325 ";
	statement=con.createStatement();
	rs=statement.executeQuery(sql); 
	out.println("<select NAME='orgid'>");	
	out.println("<OPTION VALUE=''>--</option>"); 			  				  
	while (rs.next())
	{            
		String s1=(String)rs.getString("organization_id"); 
		String s2=(String)rs.getString("organization_name"); 
		if (s1.equals(orgid)) 
		{
			out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2+"</option>"); 					                                
		} else {
			out.println("<OPTION VALUE='"+s1+"'>"+s2+"</option>");
		}        
	} //end of while
	out.println("</select>"); 
	rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println("(organization)"+e.getMessage());
}//end of catch   
%>
			&nbsp; &nbsp;Job
			<input id="Text1" type="text" name="wono" value="<%=wono%>" />
			<input id="Button1" type="button" value="..." onClick="QueryWo(search.orgid.value, search.wono.value)" />
			&nbsp; &nbsp;
			<input id="Submit1" name="Submit1" type="submit" value="Find" />
			</td>
		</tr>
	</table>
	<br />
</FORM>	
<FORM NAME="MYFORM" ACTION="" METHOD="POST" onSubmit="chkSubmit();"> 
<%
//取得工令
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
if (orgid.length()>0) sql=sql+"   AND wdj.organization_id = " + orgid + " ";
sql=sql+"   AND we.wip_entity_name = '" + wono + "' ";
if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0)) //若不是admin則加入部門條件
	sql=sql+"   AND SUBSTR (we.wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
statement=con.createStatement();
rs=statement.executeQuery(sql); 
if (rs.next())
{
%>
    <table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td bgcolor="silver" nowrap="nowrap">
                Orgnization</td>
            <td bgcolor="silver" nowrap="nowrap">
                Job</td>
            <td bgcolor="silver" nowrap="nowrap">
                Assembly</td>
            <td bgcolor="silver" nowrap="nowrap">
                Description</td>
            <td bgcolor="silver" nowrap="nowrap">
                Create date</td>
            <td bgcolor="silver" nowrap="nowrap">
                Include</td>
            <td bgcolor="silver" nowrap="nowrap">&nbsp;
                </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <%=rs.getString("organization_name")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("wip_entity_name")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("item_no")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("item_desc")%></td>
            <td nowrap="nowrap">
                <%=rs.getString("creation_date")%></td>
            <td nowrap="nowrap">
                <input id="Radio3" checked name="R1" type="radio" value="yew_wip_mtl_trx_issue_wip_entry.jsp" />BOM<br />
                <input id="Radio4" name="R1" type="radio" value="yew_wip_mtl_trx_issue_wip_entry_s.jsp" />Specific</td>
            <td nowrap="nowrap">
                <input id="Submit2" name="Submit2" type="submit" value="Continue" /></td>
        </tr>
    </table>
	<input type="hidden" name="orgid" value="<%=rs.getString("organization_id")%>" />
	<input type="hidden" name="wono" value="<%=rs.getString("wip_entity_name")%>" />
<%
}
rs.close();       
statement.close();
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

