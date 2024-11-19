<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 主管授權</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%   
Statement statement;
Statement statement2;
ResultSet rs;
ResultSet rs2;
String sql="";
String wipid="";
int i=0;
int maxrow=0;//查詢資料總筆數 
String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String wono=request.getParameter("wono");  
if (wono==null) wono="";
String act=request.getParameter("act");  
if (act==null) act="";
String act_lbl="";
if (act.indexOf("0")>=0) act_lbl = "產線主管";
if (act.indexOf("10")>=0) act_lbl = "物管";
if (act.indexOf("20")>=0) act_lbl = "倉庫";
try
{
	//讀取簽核中工令筆數
	sql="";
	sql=sql+"SELECT COUNT (wip_entity_id) ";
	sql=sql+"  FROM (SELECT   wip_entity_id ";
	sql=sql+"            FROM  yew_wip_mtl_trx ";
	sql=sql+"           WHERE closed_code = 'OPEN' ";
	sql=sql+"             AND wip_entity_name like '%" + wono + "%' ";
	sql=sql+"             AND action_sequence_num = "+act+" ";
	if (orgid.length()>0) sql=sql+"             AND organization_id = " + orgid + " ";
	if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0)) //若不是admin則加入部門條件
		sql=sql+"             AND SUBSTR (wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
	sql=sql+"        GROUP BY  wip_entity_id) t ";
	statement=con.createStatement();
	rs=statement.executeQuery(sql); 
	rs.next();   
	maxrow=rs.getInt(1);
	rs.close();   
	statement.close();
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println("(count)"+e.getMessage());
}//end of catch   
%>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<br><br>
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;<%=act_lbl%>簽核作業</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>&nbsp;筆記錄)</FONT>
<br><br>

<FORM NAME="search" ACTION="" METHOD="POST" > 
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
			&nbsp; &nbsp;
			<input id="Submit1" name="Submit1" type="button" value="Find" onClick="chkSubmit(search);" />
			</td>
		</tr>
	</table>
    <br />
</FORM>
<FORM NAME="MYFORM" ACTION="yew_wip_mtl_trx_issue_wip_approve.jsp" METHOD="POST" >
	<input type="hidden" name="wipid" value="" /> 
	<input type="hidden" name="act" value="<%=act%>" /> 
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
            <td bgcolor="silver" nowrap="nowrap">&nbsp;
                </td>
        </tr>
<%
try
{
	//讀取簽核中工令號
	sql="";
	sql=sql+"SELECT   wip_entity_id ";
	sql=sql+"            FROM  yew_wip_mtl_trx ";
	sql=sql+"           WHERE closed_code = 'OPEN' ";
	sql=sql+"             AND wip_entity_name like '%" + wono + "%' ";
	sql=sql+"             AND action_sequence_num = "+act+" ";
	if (orgid.length()>0) sql=sql+"             AND organization_id = " + orgid + " ";
	if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0 || UserRoles.indexOf("YEW_IQC_MC")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0)) //若不是admin則加入部門條件
		sql=sql+"             AND SUBSTR (wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
	sql=sql+"        GROUP BY  wip_entity_id";
	statement=con.createStatement();
	rs=statement.executeQuery(sql); 
	while (rs.next())
	{    
		i++;
		wipid = rs.getString("wip_entity_id");
		//取得工令資料
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
		sql=sql+"   AND we.wip_entity_id = " + wipid ;
		statement2=con.createStatement();
		rs2=statement2.executeQuery(sql); 
		if (rs2.next())
		{    
%>
        <tr>
            <td nowrap="nowrap">
                <%=rs2.getString("organization_name")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("wip_entity_name")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("item_no")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("item_desc")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("creation_date")%></td>
            <td nowrap="nowrap">
                <input type="hidden" name="wipid<%=i%>" value="<%=wipid%>" />
				<input id="Submit2" name="Submit2" type="button" value="Continue" onClick="wipid.value='<%=wipid%>';chkSubmit(MYFORM);" /></td>
        </tr>
<%
		} //end if
		rs2.close();       
		statement2.close();
	} //end of while
	rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println("(wipinfo)"+e.getMessage());
}//end of catch   
%>
    </table>
</FORM>

<script language="JavaScript" type="text/JavaScript">
function chkSubmit(obj)
{
	var i;
	search.Submit1.disabled=true;
	if (<%=i%>>1)
	{
		for (i=0;i<<%=i%>;i++)
		{
			MYFORM.Submit2[i].disabled=true;
		}
	}
	else
		MYFORM.Submit2.disabled=true;
	obj.submit();
}
</script>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

