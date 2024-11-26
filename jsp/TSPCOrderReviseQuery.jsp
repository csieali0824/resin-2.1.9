<%@ page contentType="text/html;charset=utf-8"  language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>PC Order Revise for Query</title>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	//if (document.MYFORM.SDATE.value=="" ||document.MYFORM.SDATE.value==null)
	//{
	//	alert("Please input then request start date!");
	//	document.MYFORM.SDATE.focus();
	//	return false;
	//}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
	//if (document.MYFORM.SDATE.value=="" ||document.MYFORM.SDATE.value==null)
	//{
	//	alert("Please input then request start date!");
	//	document.MYFORM.SDATE.focus();
	//	return false;
	//}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck((i+1));
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr"+irow).style.backgroundColor ="#D8E2E9";
	}
	else
	{
		document.getElementById("tr"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true) chkcnt ++;
	}
	if (chkcnt <=0)
	{
		alert("Please select to revise order data!");
		return false;
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;
	document.MYFORM.btnExport.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>
<STYLE TYPE='text/css'> 
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<%
String sql = "",request_no="";
String PLANTCODE = request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0)
{
	PLANTCODE=userProdCenterNo;
}
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String SALES_RESULT = request.getParameter("SALES_RESULT");
if(SALES_RESULT==null || SALES_RESULT.equals("--")) SALES_RESULT="";
String CONFIRMEDBY=request.getParameter("CONFIRMEDBY");
if (CONFIRMEDBY==null || CONFIRMEDBY.equals("--")) CONFIRMEDBY="";
String REQ_TYPE =request.getParameter("REQ_TYPE");
if (REQ_TYPE==null) REQ_TYPE="";
String REQ_TYPE_P =request.getParameter("REQ_TYPE_P");
if (REQ_TYPE_P==null) REQ_TYPE_P="";
String REQ_TYPE_O =request.getParameter("REQ_TYPE_O");
if (REQ_TYPE_O==null) REQ_TYPE_O="";
String REQ_TYPE_E =request.getParameter("REQ_TYPE_E");
if (REQ_TYPE_E==null) REQ_TYPE_E="";
String MO_LIST=request.getParameter("MO_LIST");
if (MO_LIST==null) MO_LIST="";
String CUST_LIST=request.getParameter("CUST_LIST");
if (CUST_LIST==null) CUST_LIST="";
String ITEM_DESC_LIST=request.getParameter("ITEM_DESC_LIST");
if (ITEM_DESC_LIST==null) ITEM_DESC_LIST="";
String CUST_ITEM_LIST=request.getParameter("CUST_ITEM_LIST");
if (CUST_ITEM_LIST==null) CUST_ITEM_LIST="";
String SALES_SDATE=request.getParameter("SALES_SDATE");
if (SALES_SDATE==null) SALES_SDATE="";
String SALES_EDATE=request.getParameter("SALES_EDATE");
if (SALES_EDATE==null) SALES_EDATE="";
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
if (ATYPE.equals(""))
{
	dateBean.setAdjDate(-4);
	SDATE = dateBean.getYearMonthDay();
	dateBean.setAdjDate(4);
}
String strBackColor="",id="";
int rowcnt=0;

%>
<body> 
<FORM ACTION="../jsp/TSPCOrderReviseQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">PC Order Revise for Query</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#CFDAC9" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="6%" style="font-size:11px" align="right" rowspan="4">Request Type：</td>
		<td width="7%" rowspan="4">
		<!--<select NAME="REQ_TYPE" style="font-family: Tahoma,Georgia;font-size:11px" onChange="setReqType(this.value)">
		<OPTION VALUE="--" <%=(REQ_TYPE.equals("") || REQ_TYPE.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="Pull in" <%=(REQ_TYPE.equals("Pull in")?" selected ":"")%>>Pull in
        <OPTION VALUE="Overdue" <%=(REQ_TYPE.equals("Overdue")?" selected ":"")%>>Overdue
        <OPTION VALUE="Early Warning" <%=(REQ_TYPE.equals("Early Warning")?" selected ":"")%>>Early Warning
		</select>-->
		<input type="checkbox" name="REQ_TYPE_P" value="Early Ship" <%=!REQ_TYPE_P.equals("")?"checked":""%>>Early Ship<BR>
		<input type="checkbox" name="REQ_TYPE_O" value="Overdue" <%=!REQ_TYPE_O.equals("")?"checked":""%>>Overdue<BR>
		<input type="checkbox" name="REQ_TYPE_E" value="Early Warning" <%=!REQ_TYPE_E.equals("")?"checked":""%>>Early Warning
		</td>
		<td width="7%" align="right"><span style="font-size:11px">Plant Name</span>：</td>
		<td width="14%">
		<%
		try
		{   
			sql = "select distinct PLANT_CODE,  MANUFACTORY_NAME from tsc_om_salesorderrevise_pc_v a,oraddman.tsprod_manufactory b where a.plant_code=b.MANUFACTORY_NO";
			if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0 && UserName.indexOf("JUDY_CHO")<0)
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(PLANTCODE);
			comboBoxBean.setFieldName("PLANTCODE");	 
			if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0 && UserName.indexOf("JUDY_CHO")<0)
			{			
				comboBoxBean.setOnChangeJS("this.value="+'"'+userProdCenterNo+'"');  
			}
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>
		</td>		
		<td width="10%" align="right">Sales Group：</td>
		<td width="14%">
		<%
		try
		{   
			sql = " SELECT distinct d.group_name,d.group_name "+
			      " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_pc_v e"+
                  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
                  //" and b.MASTER_GROUP_ID=c.master_group_id"+
				  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                  " and c.master_group_id=d.master_group_id"+
                  " and d.group_name=e.SALES_GROUP"+
				  " and b.SALES_AREA_NO<>'020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("JUDY_CHO")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("JUDY_CHO")<0)) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " union all"+
			       " select distinct ALNAME,ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("JUDY_CHO")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("JUDY_CHO")<0 )) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " order by 1";
			
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFieldName("SALESGROUP");	
			comboBoxBean.setOnChangeJS("");
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>	
		</td>
		<td width="6%"align="right" rowspan="2">Customer：</td>
		<td width="13%" rowspan="2"><textarea cols="30" rows="3" name="CUST_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=CUST_LIST%></textarea></td>
		<td width="7%"align="right" rowspan="2">ERP MO# ：</td>
		<td width="13%" rowspan="2"><textarea cols="30" rows="3" name="MO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=MO_LIST%></textarea>
		</td>
	</tr>
	<tr>
		<td align="right">Request No：</td>
		<td><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>	
		<td align="right">Sales Confirm Result：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT SALES_CONFIRMED_RESULT,SALES_CONFIRMED_RESULT FROM tsc_om_salesorderrevise_pc_v WHERE SALES_CONFIRMED_RESULT is not null ORDER BY 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(SALES_RESULT);
			comboBoxBean.setFieldName("SALES_RESULT");	 
			comboBoxBean.setOnChangeJS("");  
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
	</tr>
	<tr>
		<td align="right">Status：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT STATUS,STATUS STATUS1 FROM tsc_om_salesorderrevise_pc_v order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(STATUS);
			comboBoxBean.setFieldName("STATUS");	
			comboBoxBean.setOnChangeJS("");   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
		<td align="right">Sales Confrimed By：</td>
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT SALES_CONFIRMED_BY,SALES_CONFIRMED_BY FROM tsc_om_salesorderrevise_pc_v a WHERE SALES_CONFIRMED_BY IS NOT NULL ";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || ( UserRoles.indexOf("Sale")>=0  && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_pc_v e"+
                       " where x.TSSALEAREANO=b.SALES_AREA_NO "+
                       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
                       " and x.USERNAME ='"+UserName+"'"+
					   " and d.group_name=a.sales_group"+
                       " and b.SALES_AREA_NO<>'020')"+
					   " or exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"'"+
					   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CONFIRMEDBY);
			comboBoxBean.setFieldName("CONFIRMEDBY");	 
			comboBoxBean.setOnChangeJS("");  
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();  
 	 
		} 
		catch (Exception e) 
		{ 
			out.println("<select NAME='CONFIRMEDBY' style='font-size:11px;font-family:'Tahoma,Georgia'>");
			out.println("<OPTION VALUE=-->--");
			out.println("</select>");
		} 	
		%>	
		</td>
		<td align="right" rowspan="2">Item Desc：</td>
		<td rowspan="2"><textarea cols="30" rows="3" name="ITEM_DESC_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=ITEM_DESC_LIST%></textarea></td>
		<td align="right" rowspan="2">Cust Item：</td>
		<td rowspan="2"><textarea cols="30" rows="3" name="CUST_ITEM_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=CUST_ITEM_LIST%></textarea></td>		
	</tr>
	<tr>
		<td align="right">Request Date：</td>
		<td><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">Sales Confirm Date：</td>
		<td><input type="TEXT" NAME="SALES_SDATE" value="<%=SALES_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SALES_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="SALES_EDATE" value="<%=SALES_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SALES_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>		
	</tr>
	<tr>
		<td colspan="12" align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSPCOrderReviseQuery.jsp?ATYPE=Q')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSPCOrderReviseHisExcel.jsp?RTYPE=QUERY&UserName=<%=UserName%>&UserRoles=<%=UserRoles%>&userProdCenterNo=<%=userProdCenterNo%>')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{
	sql = " select a.request_no"+
	      ", a.request_type"+
		  ", a.seq_id"+
		  ", a.sales_group"+
		  ", a.so_no"+
		  ", a.line_no"+
		  ", a.so_header_id"+
		  ", a.so_line_id"+
		  ", a.source_customer_id"+
		  ", a.source_ship_from_org_id"+
		  ", a.source_item_id"+
		  ", a.source_item_desc"+
		  ", a.source_cust_item_id"+
		  ", a.source_cust_item_name"+
		  ", a.source_customer_po"+
		  ", a.source_shipping_method"+
		  ", a.source_so_qty"+
		  ", to_char(a.source_ssd,'yyyymmdd') source_ssd"+
		  ", to_char(a.source_request_date,'yyyymmdd') source_request_date"+
		  ", a.tsc_prod_group"+
		  ", a.packing_instructions"+
		  ", a.plant_code"+
		  ", a.inventory_item_id"+
		  ", a.item_name"+
		  ", a.item_desc"+
		  ", a.shipping_method"+
		  ", a.so_qty"+
		  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
		  ", to_char(a.schedule_ship_date_tw,'yyyymmdd')schedule_ship_date_tw"+
		  ", to_char(a.overdue_early_warning_new_ssd,'yyyymmdd') overdue_early_warning_new_ssd"+
		  ", a.reason_desc"+
		  ", a.remarks"+
		  ", a.change_reason"+
		  ", a.change_comments"+
		  ", a.sales_confirmed_qty"+
          ", to_char(a.sales_confirmed_ssd,'yyyymmdd') sales_confirmed_ssd"+
		  ", a.sales_confirmed_result"+
          ", a.sales_confirmed_remarks"+	  
		  ", a.status"+
		  ", a.created_by"+
		  ", to_char(a.creation_date,'yyyymmdd hh24:mi') creation_date"+
		  ", a.sales_confirmed_by"+
		  ", to_char(a.sales_confirmed_date,'yyyymmdd hh24:mi') sales_confirmed_date"+
		  ", a.last_updated_by"+
		  ", to_char(a.last_update_date,'yyyymmdd hh24:mi') last_update_date"+
		  ", a.hold_code"+
		  ", a.hold_reason"+
		  ", a.new_so_no"+
		  ", a.new_line_no"+
		  ", b.MANUFACTORY_NAME"+
		  ", '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
		  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
		  ",nvl(a.to_tw_days,0) to_tw_days"+ 
		  ",to_char(d.schedule_ship_date,'yyyy/mm/dd') erp_ssd"+ 
		  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ 
		  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
		  ",row_number() over (partition by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no order by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no,nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
		  ",count(1) over (partition by a.request_type,a.request_no,a.so_line_id) line_cnt"+
		  ",to_char(a.source_ssd_tw,'yyyymmdd') source_ssd_tw"+
		  ",hd.meaning hold_name"+
		  ",a.ascription_by"+
		  //" from oraddman.tsc_om_salesorderrevise_pc a"+
		  " from tsc_om_salesorderrevise_pc_v a"+  //add by Peggy 20240617
		  ",oraddman.tsprod_manufactory b"+
		  ",ont.oe_order_headers_all c"+
		  ",ont.oe_order_lines_all d"+
		  ",tsc_customer_all_v ar"+
		  ",hz_cust_accounts end_cust"+ 
		  ",(select lookup_code,meaning FROM fnd_lookup_values WHERE lookup_type = 'YES_NO_HOLD' AND language = 'US' AND enabled_flag = 'Y') hd"+
		  " where a.so_header_id=c.header_id(+)"+  
		  " and a.so_line_id=d.line_id(+)"+
		  " and a.plant_code =b.manufactory_no(+)"+
		  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
		  " and d.end_customer_id = end_cust.cust_account_id(+)"+ 
		  " and a.hold_code=hd.lookup_code(+)";
	if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
	{
		sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
	}		  
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		sql += " and a.SALES_GROUP='"+salesGroup+"'";
	}
	else if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JENNY_LIAO")<0) || (UserRoles.indexOf("Sale")>=0  && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JENNY_LIAO")<0 ))
	{
		sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
			   " where x.TSSALEAREANO=b.SALES_AREA_NO "+
			   " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
			   " and c.master_group_id=d.master_group_id"+
			   " and d.group_name=e.SALES_GROUP"+
			   " and x.USERNAME ='"+UserName+"'"+
			   " and d.group_name=a.sales_group"+
			   " and b.SALES_AREA_NO<>'020')"+
			   " or exists (select 1 from oraddman.tsrecperson x where (x.USERNAME='"+UserName+"' or 'CYTSOU'='"+UserName+"')"+
			   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";	
	}
	if (!CONFIRMEDBY.equals("") && !CONFIRMEDBY.equals("--"))
	{
		sql += " and a.SALES_CONFIRMED_BY ='"+CONFIRMEDBY+"'";
	}
	if (!STATUS.equals("") && !STATUS.equals("--"))
	{
		sql += " and a.STATUS = '"+STATUS+"'";
	}	
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20210701":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!SALES_SDATE.equals("") || !SALES_EDATE.equals(""))
	{
		sql += " and a.sales_confirmed_date  BETWEEN TO_DATE('"+(SALES_SDATE.equals("")?"20210701":SALES_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (SALES_EDATE.equals("")?dateBean.getYearMonthDay():SALES_EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!REQUESTNO.equals(""))
	{
		sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
	}
	if (!SALES_RESULT.equals("") && !SALES_RESULT.equals("--"))
	{
		sql += " and a.SALES_CONFIRMED_RESULT ='"+SALES_RESULT+"'";
	}
	if (!REQ_TYPE_P.equals("") || !REQ_TYPE_O.equals("") || !REQ_TYPE_E.equals(""))
	{
		sql += " and a.REQUEST_TYPE IN ('"+REQ_TYPE_P+"','"+REQ_TYPE_O+"','"+REQ_TYPE_E+"')";
	}
	if (!ITEM_DESC_LIST.equals(""))
	{
		String [] sArray = ITEM_DESC_LIST.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (a.SOURCE_ITEM_DESC like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or a.SOURCE_ITEM_DESC like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += ")";
		}	
	}
	if (!CUST_ITEM_LIST.equals(""))
	{
		String [] sArray = CUST_ITEM_LIST.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (a.SOURCE_CUST_ITEM_NAME like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or a.SOURCE_CUST_ITEM_NAME like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += ")";
		}	
	}
	if (!CUST_LIST.equals(""))
	{
		String [] sArray = CUST_LIST.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
					   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
					   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}		
	if (!MO_LIST.equals(""))
	{
		String [] sArray = MO_LIST.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and a.SO_NO IN ('"+sArray[x].trim().toUpperCase()+"'";
			}
			else
			{
				sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}		
	sql += "  order by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no,nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 
		if (rowcnt==0)
		{
		%>
<table align="center" width="2500" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#E9F8F2;color:#000000">
		<td rowspan="2" width="80" align="center">Request No </td>
		<td rowspan="2" width="60" align="center">Request Type</td>
		<td rowspan="2" width="60" align="center">Sales Group</td>
		<td rowspan="2" width="100" align="center">Customer</td>
		<td rowspan="2" width="80" align="center">MO#</td>
		<td rowspan="2" width="30" align="center">Line#</td>	
		<td rowspan="2" width="90" align="center">Original Item Desc </td>	
		<td rowspan="2" width="90" align="center">Cust Item </td>	
		<td rowspan="2" width="90" align="center">Cust PO </td>	
		<td rowspan="2" width="90" align="center">TSC Package </td>	
		<td rowspan="2" width="50" align="center">Original Qty </td>	
		<td rowspan="2" width="60" align="center">Original CRD </td>	
		<td rowspan="2" width="60" align="center">Original TW SSD </td>	
		<td rowspan="2" width="60" align="center">Original SSD </td>	
		<td rowspan="2" width="60" align="center">Shipping Method</td>	
		<td style="background-color:#006699;color:#ffffff" colspan="5" align="center">PC Revise Detail </td>
		<td rowspan="2" width="70" align="center" style="background-color:#D3793D;color:#ffffff">Sales Confirm Qty</td>
		<td rowspan="2" width="70" align="center" style="background-color:#D3793D;color:#ffffff">Sales Confirm SSD</td>
		<td rowspan="2" width="70" align="center" style="background-color:#D3793D;color:#FFFFFF">Shipping Method</td>
		<td rowspan="2" width="30" align="center" style="background-color:#D3793D;color:#ffffff">Hold</td>
		<td rowspan="2" width="60" align="center" style="background-color:#D3793D;color:#ffffff">Sales Confirm Result</td>
		<td rowspan="2" width="100" align="center" style="background-color:#D3793D;color:#ffffff">Sales Confirm Remarks</td>
		<td rowspan="2" width="70" align="center" style="background-color:#D3793D;color:#ffffff">Overdue/Early Warning<br>New SSD</td>
		<td rowspan="2" width="100" align="center">New MO#/Line#</td>	
		<td rowspan="2" width="80" align="center">Plant Name</td>
		<td rowspan="2" width="60" align="center">Ascription By</td>
		<td rowspan="2" width="80">Created by </td>
		<td rowspan="2" width="60">Creation Date </td>
		<td rowspan="2" width="70">Sales Confrimed  By</td>
		<td rowspan="2" width="60">Sales Confrimed  Date </td>
		<td rowspan="2" width="80">Last Updated by </td>
		<td rowspan="2" width="60">Last Update Date</td>
		<td rowspan="2" width="100" align="center">Status</td>	
	</tr>
	<tr style="background-color:#006699;color:#ffffff">
		<td width="50">Ascription By</td>
		<td width="50">Order Qty</td>
		<td width="60">TW SSD pull in/out</td>
		<td width="60">SSD pull in/out</td>
		<td width="120">Remarks</td>
	</tr>
		<%
		}
		rowcnt++;
		id=rs.getString("seq_id");
		%>
	<tr id="tr<%=rowcnt%>">
		<%
		if (rs.getInt("line_seq")==1)
		{
		%>		
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("request_no")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>" style="background-color:<%=rs.getString("request_type").equals("Overdue")?"#FF9999":(rs.getString("request_type").equals("Early Ship")?"#66FF99":"#FFFF33")%>"><%=rs.getString("request_type")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SALES_GROUP")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("customer")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SO_NO")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("LINE_NO")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_ITEM_DESC")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUST_ITEM_NAME")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("tsc_package")%></td>
		<td align="right" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_SO_QTY")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_REQUEST_DATE")==null?"&nbsp;":rs.getString("SOURCE_REQUEST_DATE"))%>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_SSD_TW")==null?"&nbsp;":rs.getString("SOURCE_SSD_TW"))%>
		<%
		//if ((UserRoles.indexOf("Sale")>=0 || UserRoles.indexOf("admin")>=0) && (rs.getString("status").equals("AWAITING_CONFIRM")) && !rs.getString("SOURCE_SSD_TW").equals(rs.getString("erp_ssd")))
		//{
		//	out.println("<br><font color='#ff0000'>ERP SSD:"+rs.getString("erp_ssd")+"</font>");
		//}
		%>	
		</td>	
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_SSD")==null?"&nbsp;":rs.getString("SOURCE_SSD"))%></td>
		<%
		}
		%>
		<td><%=(rs.getString("SOURCE_SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SOURCE_SHIPPING_METHOD"))%></td>
		<td><%=(rs.getString("ASCRIPTION_BY")==null?"&nbsp;":rs.getString("ASCRIPTION_BY"))%></td>
		<td align="right"><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE_TW")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE_TW"))%></td>
		<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%></td>
		<td><%=(rs.getString("reason_desc")==null?"&nbsp;":rs.getString("reason_desc"))+(rs.getString("reason_desc")!=null&&rs.getString("remarks")!=null?",":"")+(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
		<td align="right"><%=(rs.getString("SALES_CONFIRMED_QTY")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_QTY"))%></td>
		<td align="center"><%=(rs.getString("SALES_CONFIRMED_SSD")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_SSD"))%></td>
		<td align="center"><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></td>
		<td align="center"><%=(rs.getString("hold_name")==null?"&nbsp;":rs.getString("hold_name"))%></td>
		<td align="center"><%=(rs.getString("SALES_CONFIRMED_RESULT")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_RESULT"))%></td>
		<td><%=(rs.getString("SALES_CONFIRMED_REMARKS")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_REMARKS"))%></td>
		<td align="center"><%=(rs.getString("OVERDUE_EARLY_WARNING_NEW_SSD")==null?"&nbsp;":rs.getString("OVERDUE_EARLY_WARNING_NEW_SSD"))%></td>
		<td><%=(rs.getString("new_order")==null?"&nbsp;":rs.getString("new_order"))%></td>
		<td align="center"><%=rs.getString("MANUFACTORY_NAME")%></td>
		<td align="center"><%=rs.getString("ascription_by")%></td>
		<td><%=(rs.getString("CREATED_BY")==null?"&nbsp;":rs.getString("CREATED_BY"))%></td>
		<td align="center"><%=rs.getString("CREATION_DATE")%></td>
		<td><%=(rs.getString("SALES_CONFIRMED_BY")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_BY"))%></td>
		<td align="center"><%=(rs.getString("SALES_CONFIRMED_DATE")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_DATE"))%></td>
		<td><%=(rs.getString("LAST_UPDATED_BY")==null?"&nbsp;":rs.getString("LAST_UPDATED_BY"))%></td>
		<td align="center"><%=(rs.getString("LAST_UPDATE_DATE")==null?"&nbsp;":rs.getString("LAST_UPDATE_DATE"))%></td>
		<td><%=rs.getString("status")%></td>
	</tr>
		<%
	}
	rs.close();
	statement.close();

	if (rowcnt <=0) 
	{
		out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
	}
	else
	{
	%>
  </table>
	<%
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception:"+e.getMessage()+"</font></div>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
