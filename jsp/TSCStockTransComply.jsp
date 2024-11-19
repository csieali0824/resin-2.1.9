<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
		lineid = document.MYFORM.chk[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#F4F9F2";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}

function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{   
	var chkflag ="";
	var lineid="";
	var chkcnt=0;
	document.MYFORM.save.disabled=true;
	document.MYFORM.exit.disabled=true;
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked)  chkcnt++;
		}
	}
	else
	{
		if (document.MYFORM.chk.checked) chkcnt++;
			
	}

	if (chkcnt==0)
	{
		alert("請先勾選資料!");
		document.MYFORM.save.disabled=false;
		document.MYFORM.exit.disabled=false;
		return false;
	}		
		 
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
} 
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
String sql = "";
String HID=request.getParameter("HID");
if (HID==null || HID.equals("--")) HID="";
String REQ_NO=request.getParameter("REQ_NO");
if (REQ_NO==null) REQ_NO="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";

sql = " select distinct a.wkflow_level "+
      " from oraddman.tsc_stock_trans_wkflow a"+
	  " ,oraddman.tsc_stock_trans_member b"+
      " where a.wkflow_level_rank in (?)"+
      " and a.wkflow_level=b.wkflow_level"+
      " and nvl(a.active_flag,'N')=?"+
      " and nvl(b.active_flag,'N')=?"+
	  //" and substr(b.WKFLOW_LEVEL,1,length(?))=?"+
      " and b.user_name=?";
PreparedStatement statement = con.prepareStatement(sql);
statement.setString(1,"99");
statement.setString(2,"A");
statement.setString(3,"A");
//statement.setString(4,WKCODE);
//statement.setString(5,WKCODE);
statement.setString(4,UserName);
ResultSet rs=statement.executeQuery();	
if (!rs.next())
{
	rs.close();
	statement.close();
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您尚未設定倉管權限,請向資訊單位提出申請後再作業,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%	
}
rs.close();
statement.close();
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCStockTransComply.jsp" METHOD="post" NAME="MYFORM">
<br>
<font style="font-weight:bold;font-family:'細明體';color:#666699;font-size:18px">轉倉或料號移轉作業</font>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%">申請單:</td>   
		<td>
		<%		
		try
    	{   
			sql = "SELECT a.req_no,a.req_header_id FROM oraddman.tsc_stock_trans_headers a WHERE STATUS_CODE=?";
			statement = con.prepareStatement(sql);
			statement.setString(1,"APPROVED");
			rs=statement.executeQuery();	
			out.println("<select NAME='HID' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (HID.equals("") || HID.equals("--") ?" selected ":"")+">--");     
			while (rs.next())
			{            
           		out.println("<OPTION VALUE='"+rs.getString(2)+"'"+ (HID.equals(rs.getString(2))?" selected ":"") +">"+rs.getString(1));
			} 
			out.println("</select>"); 
			rs.close();        	 
			statement.close();		  		  
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>		
			&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCStockTransComply.jsp")' >			
		</td>  
	</tr>
</table> 
<HR>
<%
try
{
	sql = " select c.trans_type"+
	      ", c.trans_name"+
		  ", c.trans_desc"+
		  ", a.req_header_id"+
		  ", a.req_no"+
		  ", b.req_line_id"+
		  ", b.line_no"+
		  ", b.tsc_prod_group"+
		  ", b.orig_organization_id"+
		  ", b.orig_subinventory_code"+
		  ", b.orig_inventory_item_id"+
		  ", b.orig_item_name"+
		  ", b.orig_item_desc"+
		  ", b.orig_lot_number"+
		  ", b.orig_date_code"+
		  ", b.orig_qty"+
		  ", b.orig_uom"+
		  ", b.req_reason"+
		  ", b.new_organization_id"+
		  ", b.new_subinventory_code"+
		  ", b.new_inventory_item_id"+
		  ", b.new_item_name"+
		  ", b.new_item_desc"+
		  ", b.new_lot_number"+
		  ", b.new_date_code"+
		  ", b.new_qty"+
		  ", b.new_uom"+
		  ", d.organization_code orig_organization_code"+
		  ", e.organization_code new_organization_code"+
		  ", a.created_by"+
          " from oraddman.tsc_stock_trans_headers a"+
		  ",oraddman.tsc_stock_trans_lines b"+
		  ",(select * from oraddman.tsc_stock_trans_type where nvl(active_flag,'N')=?) c"+
		  ",mtl_parameters d"+
		  ",mtl_parameters e"+
		  ",(select * from oraddman.tsc_stock_trans_wkflow where nvl(active_flag,'N')=?) f"+
		  ",(select * from oraddman.tsc_stock_trans_member where nvl(active_flag,'N')=?) g"+
          " where a.req_header_id=b.req_header_id"+
          " and a.trans_type=c.trans_type"+
		  " and a.status_code=?"+
		  " and a.req_header_id=nvl(?,a.req_header_id)"+
		  " and a.req_no=nvl(?,a.req_no)"+
		  " and a.trans_type=f.trans_type"+
		  " and a.wkflow_level=f.wkflow_level"+
		  " and f.trans_type=g.trans_type"+
		  " and f.wkflow_next_level=g.wkflow_level"+
		  " and g.user_name=?"+
		  " and b.orig_organization_id=d.organization_id"+
		  " and b.new_organization_id=e.organization_id"+
		  " and b.erp_group_id is null"+
		  " and b.erp_comply_flag is null"+
          " order by a.req_no,b.line_no";
	//out.println(sql);
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,"A");
	statement1.setString(2,"A");
	statement1.setString(3,"A");
	statement1.setString(4,"APPROVED");
	statement1.setString(5,HID);
	statement1.setString(6,REQ_NO);
	statement1.setString(7,UserName);
	ResultSet rs1=statement1.executeQuery();			 
	int icnt =0;
	//out.println(sql);
	while (rs1.next())
	{
		if (icnt ==0)
		{
	%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
				  <td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="4%" align="center">申請單號</td>    
					<td width="4%" align="center">申請人</td>            
					<td width="5%" align="center">申請別</td>            
					<td width="2%" align="center">項次</td>
					<td width="5%" align="center">產品別</td>
					<td width="9%" align="center">料號(22D/30D)</td>
					<td width="7%" align="center">品名規格</td>            
					<td width="2%" align="center">移出Org</td>
					<td width="2%" align="center">移出倉別</td>            
					<td width="6%" align="center">Lot Number</td>
					<td width="4%" align="center">Date Code</td>
					<td width="3%" align="center">數量</td>
					<td width="3%" align="center">單位</td>
					<td width="9%" align="center">轉入料號(22D/30D)</td>            
					<td width="7%" align="center">轉入品名規格</td>
					<td width="2%" align="center">移入Org</td>            
					<td width="2%" align="center">移入倉別</td>            
					<td width="6%" align="center">轉入<br>Lot Number</td>
					<td width="4%" align="center">轉入<br>Date Code</td>
					<td width="3%" align="center">轉入數量</td>
					<td width="3%" align="center">轉入單位</td>
					<td width="8%" align="center">移轉原因</td>            
				</tr>
			
<%		
		}
		
%>
				<tr style="font-size:10px" id="tr_<%=rs1.getString("req_line_id")%>">
					<td align="center"><input type="checkbox" name="chk" value="<%=rs1.getString("req_line_id")%>" onClick="setCheck(<%=(icnt)%>)"></td>
					<td align="left"><%=rs1.getString("req_no")%></td>
					<td align="left"><%=rs1.getString("created_by")%></td>
					<td align="left"><%=rs1.getString("trans_desc")%></td>
					<td align="left"><%=rs1.getString("line_no")%></td>
					<td align="left"><%=rs1.getString("tsc_prod_group")%></td>
					<td align="left"><%=rs1.getString("orig_item_name")%></td>
					<td align="left"><%=rs1.getString("orig_item_desc")%></td>
					<td align="left"><%=rs1.getString("orig_organization_code")%></td>
					<td align="left"><%=rs1.getString("orig_subinventory_code")%></td>
					<td align="left"><%=rs1.getString("orig_lot_number")%></td>
					<td align="left"><%=(rs1.getString("orig_date_code")==null?"&nbsp;":rs1.getString("orig_date_code"))%></td>
					<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs1.getString("orig_qty")))%></td>
					<td align="center"><%=rs1.getString("orig_uom")%></td>
					<td align="left"><%=rs1.getString("new_item_name")%></td>
					<td align="left"><%=rs1.getString("new_item_desc")%></td>
					<td align="left"><%=rs1.getString("new_organization_code")%></td>
					<td align="left"><%=rs1.getString("new_subinventory_code")%></td>
					<td align="left"><%=rs1.getString("new_lot_number")%></td>
					<td align="left"><%=(rs1.getString("new_date_code")==null?"&nbsp;":rs1.getString("new_date_code"))%></td>
					<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs1.getString("new_qty")))%></td>
					<td align="center"><%=rs1.getString("new_uom")%></td>
					<td align="left"><%=rs1.getString("req_reason")%></td>
				</tr>
<%
		icnt++;
	}
	if (icnt >0)
	{
%>
			</table>
			<table width="100%">
				<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family:Tahoma,Georgia" onClick="setSubmit1('../jsp/TSCStockTransProcess.jsp')">
				 &nbsp;&nbsp;&nbsp;<input type="button" name="exit" value="Exit" style="font-family:Tahoma,Georgia" onClick="setSubmit('../ORADDSMainMenu.jsp')"></td></tr>
			</table>
<%

	}
	else
	{
		out.println("<font style='color:#ff0000;font-size:12px'>No Data Found!!</font>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("<font style='color:#ff0000;font-size:12px'>Exception Error!!Please contact the system administrator..</font>");
}
%>
<input type="hidden" name="STATUS_CODE" value="COMPLY">
<input type="hidden" name="WKCODE" value="<%=WKCODE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

