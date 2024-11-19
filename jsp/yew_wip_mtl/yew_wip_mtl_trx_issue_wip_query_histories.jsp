<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 明細查詢</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%   
Statement statement;
Statement statement2;
ResultSet rs;
ResultSet rs2;
String sql="";
String trx_id="";
int i=0;
int maxrow=0;//查詢資料總筆數 
int pagesize=50;//每頁資料筆數 
String errFlag="";
boolean LotFlag;

String orgid=request.getParameter("orgid");
if (orgid==null) orgid="";
String wono=request.getParameter("wono");  
if (wono==null) wono="";
String item=request.getParameter("item");  
if (item==null) item="";
String date_s=request.getParameter("date_s");
if (date_s==null) date_s="";
String date_e=request.getParameter("date_e");
if (date_e==null) date_e="";
String status=request.getParameter("status");
if (status==null) status="OPEN";
String row_num=request.getParameter("row_num");
if (row_num==null) row_num="1";

try
{
	//讀取簽核中工令筆數
	sql="";
	sql=sql+"SELECT COUNT (ywmt.trx_id) ";
	sql=sql+"  FROM yew_wip_mtl_trx ywmt, ";
	sql=sql+"       mtl_material_transactions mmt, ";
	sql=sql+"       mtl_system_items_b msib ";
	sql=sql+" WHERE ywmt.organization_id = msib.organization_id ";
	sql=sql+"   AND ywmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"   AND ywmt.transaction_set_id = mmt.transaction_set_id(+) ";
	sql=sql+"   AND ywmt.wip_entity_name like '%" + wono + "%' ";
	sql=sql+"   AND (msib.segment1 LIKE '%" + item + "%' OR msib.description LIKE '%" + item + "%') ";
	if (orgid.length()>0) sql=sql+"   AND ywmt.organization_id = " + orgid + " ";
	if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0 || UserRoles.indexOf("YEW_IQC_MC")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0)) //若不是admin則加入部門條件
		sql=sql+"   AND SUBSTR (ywmt.wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
	if (!status.equals("ALL"))
	{
		if (status.equals("WAITISSUE"))
		{
			sql=sql+"   AND mmt.attribute13 IS NULL ";
			sql=sql+"   AND ywmt.subinventory_code != '06' ";
			sql=sql+"   AND LENGTH (ywmt.transaction_set_id) > 0 ";
		}
		else
			sql=sql+"   AND ywmt.closed_code = '"+status+"' ";
	}
	if (date_s.length()>0 && date_e.length()>0)
	{
		sql=sql+"   AND ywmt.creation_date BETWEEN TO_DATE ('"+date_s+"', 'yyyy/mm/dd') ";
		sql=sql+"                         AND TO_DATE ('"+date_e+"', 'yyyy/mm/dd') + .99999 ";
	}
	else if (date_s.length()>0)
	{
		sql=sql+"   AND ywmt.creation_date >= TO_DATE ('"+date_s+"', 'yyyy/mm/dd') ";
	}
	else if (date_e.length()>0)
		sql=sql+"   AND ywmt.creation_date <= TO_DATE ('"+date_e+"', 'yyyy/mm/dd') + .99999 ";
	
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

String scrollRow=request.getParameter("SCROLLROW");    
int rowNumber=Integer.parseInt(row_num);
if (scrollRow==null || scrollRow.equals("FIRST")) 
{
	rowNumber=1;
} else {
	if (scrollRow.equals("LAST")) 
	{  	 	 
		rowNumber=maxrow-pagesize;	 	 	   
	} else {     
		rowNumber=rowNumber+Integer.parseInt(scrollRow);
		if (rowNumber<=0) rowNumber=1;
	}	 
}          

int currentPageNumber=0,totalPageNumber=0;
totalPageNumber=maxrow/pagesize+1;
if (rowNumber==0 || rowNumber<0)
{
	currentPageNumber=rowNumber/(pagesize+1)+1;  
} else {
	currentPageNumber=rowNumber/pagesize+1; 
}	
if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>

<script language="JavaScript" src="date-picker.js"></script>
<script language="JavaScript" type="text/JavaScript">
function OpenJob(wipid)
{    
	subWinJob=window.open("yew_wip_mtl_trx_issue_wip_query_histories_job.jsp?wipid="+wipid,"subWinJob","width=640,height=300,status=yes,scrollbars=yes,resizable=yes");  
	subWinJob.focus();
} 

function OpenLot(trx_id,type)
{    
	subWinLot=window.open("yew_wip_mtl_trx_issue_wip_histories_d_lot.jsp?trx_id="+trx_id+"&type="+type,"subWinLot","width=450,height=200,status=yes,scrollbars=yes,resizable=yes");  
	subWinLot.focus();
} 

function CloseJob()
{    
	try {subWinJob.close();}
	catch(e) {}
} 

function CloseLot()
{    
	try {subWinLot.close();}
	catch(e) {}
} 

function chkSubmit(obj)
{
	var s1 = obj.date_s.value;
	var s2 = obj.date_e.value;
	if (s1.length > 0 && s2.length >0)
	{
		s1 = new Date(s1);
		s2 = new Date(s2);
		var days= s2.getTime() - s1.getTime(); 
		if (days<0)
		{
			alert('開始日期不能大於結束日期!!');
			return false;
		}
	}
	obj.SCROLLROW.value='FIRST';
	obj.Submit1.disabled=true;
	obj.submit();
}

function changePage(act)
{
	if (act=='PREC') act = '<%=-pagesize%>';
	if (act=='NEXT') act = '<%=pagesize%>';
	search.SCROLLROW.value=act;
	search.Submit1.disabled=true;
	search.submit();
}
</script>

<body onUnload="CloseLot();CloseJob();">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<br><br>
<strong><font color="#0080C0" size="5">WIP領料線上簽核作業</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;明細查詢</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>&nbsp;筆記錄)</FONT>
<br><br>

<FORM NAME="search" ACTION="<%=request.getRequestURL() %>" METHOD="POST" > 
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
			<input type="text" name="wono" value="<%=wono%>" />
			&nbsp; &nbsp;Item
			<input type="text" name="item" value="<%=item%>" />
			</td>
		</tr>
		<tr>
			<td>
			Submit Dates 
			<input name="date_s" type="text" value="<%=date_s%>" size="10" readonly onClick="show_calendar('search.date_s');" />
			-
			<input name="date_e" type="text" value="<%=date_e%>" size="10" readonly onClick="show_calendar('search.date_e');" />
			<input name="clean" type="button" value="Clean dates" onClick="date_s.value='';date_e.value='';" />
			</td>
		</tr>
		<tr>
			<td>
			<input name="status" type="radio" value="OPEN" <%if (status.equals("OPEN")) {%>checked<%}%> />
			Open&nbsp;&nbsp;&nbsp;
			<input name="status" type="radio" value="CLOSED" <%if (status.equals("CLOSED")) {%>checked<%}%> />
			Approved&nbsp;&nbsp;&nbsp;
			<input name="status" type="radio" value="REJECTED" <%if (status.equals("REJECTED")) {%>checked<%}%> />
			Rejected&nbsp;&nbsp;&nbsp;
			<input name="status" type="radio" value="ALL" <%if (status.equals("ALL")) {%>checked<%}%> />
			All&nbsp;&nbsp;&nbsp;
			<input name="status" type="radio" value="WAITISSUE" <%if (status.equals("WAITISSUE")) {%>checked<%}%> />
			Wait Issue&nbsp;&nbsp;&nbsp;
			<input id="Submit1" name="Submit1" type="button" value="Find" onClick="chkSubmit(search);" />
			</td>
		</tr>
	</table>
	<br>
	<input name="row_num" type="hidden" value="<%=rowNumber%>" />
	<input name="SCROLLROW" type="hidden" value="" />
	<input type="button" value="FIRST" onClick="changePage(this.value);" />
	<input type="button" value="PREC" onClick="changePage(this.value);" />
	<input type="button" value="NEXT" onClick="changePage(this.value);" />
	<input type="button" value="LAST" onClick="changePage(this.value);" />
	<font size="2" color="#FF0080"><strong>
	&nbsp;&nbsp;&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)
	</strong></font>
	<table bgcolor="beige" border="1" bordercolor="#000000" cellspacing="0">
        <tr>
            <td align="center" bgcolor="silver">
                Job</td>
            <td align="center" bgcolor="silver">
                Item</td>
            <td align="center" bgcolor="silver">
                Description</td>
            <td align="center" bgcolor="silver">
                Transaction type</td>
            <td align="center" bgcolor="silver">
                UOM</td>
            <td align="center" bgcolor="silver">
                Quantity</td>
            <td align="center" bgcolor="silver">
                SubInv</td>
            <td align="center" bgcolor="silver">
                Locator</td>
            <td align="center" bgcolor="silver">
                Op Seq</td>
            <td align="center" bgcolor="silver">
                Dept</td>
            <td align="center" bgcolor="silver">
                Lot</td>
            <td align="center" bgcolor="silver">
                Reason</td>
            <td align="center" bgcolor="silver">
                Reference</td>
            <td align="center" bgcolor="silver" nowrap="nowrap">
                WIP領料(退庫)單</td>
            <td align="center" bgcolor="silver">
                Submit date</td>
            <td align="center" bgcolor="silver">
                Action</td>
            <td align="center" bgcolor="silver">
                Action Date</td>
            <td align="center" bgcolor="silver">
                Status</td>
        </tr>
<%
try
{
	//讀取簽核領料明細
	errFlag = "100";
	sql="";
	sql=sql+"SELECT ywmt.trx_id ";
	sql=sql+"  FROM yew_wip_mtl_trx ywmt, ";
	sql=sql+"       mtl_material_transactions mmt, ";
	sql=sql+"       mtl_system_items_b msib ";
	sql=sql+" WHERE ywmt.organization_id = msib.organization_id ";
	sql=sql+"   AND ywmt.inventory_item_id = msib.inventory_item_id ";
	sql=sql+"   AND ywmt.transaction_set_id = mmt.transaction_set_id(+) ";
	sql=sql+"   AND ywmt.wip_entity_name like '%" + wono + "%' ";
	sql=sql+"   AND (msib.segment1 LIKE '%" + item + "%' OR msib.description LIKE '%" + item + "%') ";
	if (orgid.length()>0) sql=sql+"   AND ywmt.organization_id = " + orgid + " ";
	if (!(UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0)) //若不是admin則加入部門條件
		sql=sql+"   AND SUBSTR (ywmt.wip_entity_name, 2, 1) = '"+userMfgDeptNo+"' "; //dept 1=M1, 2=M2, 3=M3
	if (!status.equals("ALL"))
	{
		if (status.equals("WAITISSUE"))
		{
			sql=sql+"   AND mmt.attribute13 IS NULL ";
			sql=sql+"   AND ywmt.subinventory_code != '06' ";
			sql=sql+"   AND LENGTH (ywmt.transaction_set_id) > 0 ";
		}
		else
			sql=sql+"   AND ywmt.closed_code = '"+status+"' ";
	}
	if (date_s.length()>0 && date_e.length()>0)
	{
		sql=sql+"   AND ywmt.creation_date BETWEEN TO_DATE ('"+date_s+"', 'yyyy/mm/dd') ";
		sql=sql+"                         AND TO_DATE ('"+date_e+"', 'yyyy/mm/dd') + .99999 ";
	}
	else if (date_s.length()>0)
	{
		sql=sql+"   AND ywmt.creation_date >= TO_DATE ('"+date_s+"', 'yyyy/mm/dd') ";
	}
	else if (date_e.length()>0)
		sql=sql+"   AND ywmt.creation_date <= TO_DATE ('"+date_e+"', 'yyyy/mm/dd') + .99999 ";
	sql=sql+"ORDER BY ywmt.wip_entity_name, ywmt.operation_seq_num, ywmt.creation_date ";
	statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	rs=statement.executeQuery(sql); 
	if (rowNumber==1 || rowNumber<0)
	{ 
		rs.beforeFirst(); //移至第一筆資料列  
	} else { 
		if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
		{
			rs.absolute(rowNumber-1); //移至指定資料列	 
		}	
	}
	i=0;
	while (rs.next())
	{    
		if (i==pagesize && pagesize>0) break;
		i++;
		trx_id = rs.getString("trx_id");
		LotFlag = false;
		errFlag = "200";
		sql="SELECT COUNT (trx_id) FROM yew_wip_mtl_lots WHERE trx_id = "+trx_id;
		statement2=con.createStatement();
		rs2=statement2.executeQuery(sql); 
		if (rs2.next())
			if (rs2.getInt(1)>0) LotFlag = true;
		rs2.close();       
		statement2.close();
		errFlag = "300";
		//取得領料資料
		sql="";
		sql=sql+"SELECT   ywmt.trx_id, ywmt.wip_entity_id, ywmt.wip_entity_name, ";
		sql=sql+"         ywmt.organization_id, ywmt.subinventory_code, ywmt.locator_id, ";
		sql=sql+"         ywmt.loc_segment1, ywmt.operation_seq_num, ywmt.department_id, ";
		sql=sql+"         bd.department_code, ywmt.inventory_item_id, msib.segment1, ";
		sql=sql+"         msib.description, ywmt.transaction_type_id, ";
		sql=sql+"         mtt.transaction_type_name, ";
		sql=sql+"         ywmt.transaction_quantity primary_quantity, msib.primary_uom_code, ";
		sql=sql+"         TO_CHAR (ywmt.creation_date, 'yyyy/mm/dd') trx_date, ywmt.reason_id, ";
		sql=sql+"         mtr.reason_name, ywmt.transaction_reference, mmt.attribute13, ";
		sql=sql+"         ywmt.created_by, fu.user_name, ";
		sql=sql+"         CASE action_sequence_num ";
		sql=sql+"            WHEN 0 ";
		sql=sql+"               THEN '領料'||action_code ";
		sql=sql+"            WHEN 10 ";
		sql=sql+"               THEN '產線主管'||action_code ";
		sql=sql+"            WHEN 20 ";
		sql=sql+"               THEN '物管'||action_code ";
		sql=sql+"            WHEN 30 ";
		sql=sql+"               THEN '倉庫'||action_code ";
		sql=sql+"         END action , ";
		sql=sql+"         TO_CHAR (ywmt.action_date, 'yyyy/mm/dd') action_date, ";
		sql=sql+"         closed_code ";
		sql=sql+"    FROM yew_wip_mtl_trx ywmt, ";
		sql=sql+"         mtl_system_items_b msib, ";
		sql=sql+"         bom_departments bd, ";
		sql=sql+"         fnd_user fu, ";
		sql=sql+"         mtl_material_transactions mmt, ";
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
		sql=sql+"     AND ywmt.transaction_set_id = mmt.transaction_set_id(+) ";
		sql=sql+"     AND ywmt.trx_id = "+trx_id+" ";
		statement2=con.createStatement();
		rs2=statement2.executeQuery(sql); 
		if (rs2.next())
		{    
%>
        <tr>
            <td nowrap="nowrap">
				<input name="b1" type="button" value="<%=rs2.getString("wip_entity_name")%>" onClick="OpenJob('<%=rs2.getString("wip_entity_id")%>')" /></td>
            <td nowrap="nowrap">
                <%=rs2.getString("segment1")%></td>
            <td>
                <%=rs2.getString("description")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("transaction_type_name")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("primary_uom_code")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("primary_quantity")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("subinventory_code")%></td>
            <td nowrap="nowrap">
                <%if (rs2.getString("loc_segment1") != null) {%><%=rs2.getString("loc_segment1")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("operation_seq_num")%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("department_code")%></td>
            <td nowrap="nowrap">
                <%if (LotFlag) {%><input id="Button" type="button" value="Lot" onClick="OpenLot('<%=trx_id%>','process');" /><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%if (rs2.getString("reason_name") != null) {%><%=rs2.getString("reason_name")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs2.getString("transaction_reference") != null) {%><%=rs2.getString("transaction_reference")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs2.getString("attribute13") != null) {%><%=rs2.getString("attribute13")%><%}else{%>&nbsp;<%}%></td>
            <td nowrap="nowrap">
                <%=rs2.getString("trx_date")%></td>
            <td>
                <%if (rs2.getString("action") != null) {%><%=rs2.getString("action")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs2.getString("action_date") != null) {%><%=rs2.getString("action_date")%><%}else{%>&nbsp;<%}%></td>
            <td>
                <%if (rs2.getString("closed_code") != null) {%><%=rs2.getString("closed_code")%><%}else{%>&nbsp;<%}%></td>
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
	out.println("("+errFlag+")"+e.getMessage());
}//end of catch   
%>
	</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

