<!--20161028 Peggy,新增倉別讓user指定退料倉-->
<!--20170814 Peggy,新增21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(0);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#DCF5EC";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	if (document.MYFORM.STATUS.value =="" || document.MYFORM.STATUS.value =="--")
	{
		alert("請選擇執行動作!");
		document.MYFORM.STATUS.focus();
		return false;
	}	
	if (document.MYFORM.STATUS.value=="GOBACK")
	{
		if (confirm("您確定要退回撿貨確認嗎?")==false) 
		{	
			return false;
		}
	}
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i].checked;
			lineid = document.MYFORM.chk[i].value;
		}
		if (chkvalue==true)
		{ 

			chkcnt ++;				
		}
	}
	if (chkcnt <=0)
	{
		alert("請勾選資料!");
		return false;
	}		
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setOPTValue()
{
	if (document.MYFORM.STATUS.value=="GOBACK")
	{
		document.getElementById("span2").style.visibility ="visible";
		document.MYFORM.REJ_REASON.value="";
	}
	else
	{
		document.getElementById("span1").style.visibility ="hidden";
		document.MYFORM.REJ_REASON.value="";
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline; font-size: 12px  }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TSA01 Pick Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sql = "";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null || PICK_NO.equals("--")) PICK_NO="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String ERPUSERID="";
String strdetail="",err_msg="";
double tot_pick_qty=0;
int err_cnt=0;
String chkno="";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSA01WIPWareHouseConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">A01倉庫發退料確認</font></strong>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#E4F0F1">
	<tr>
		<td width="10%"><font color="#666600">撿貨單號:</font></td>
		<td width="90%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("select PICK_NO,PICK_NO PICK_NO1 from oraddman.tsa01_request_lines_all a where status='PICKED' group by PICK_NO order by PICK_NO");
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(PICK_NO);
			comboBoxBean.setFieldName("PICK_NO");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} //end of try		 
		catch (Exception e) 
		{ 
			//out.println("Exception:"+e.getMessage()); 
		} 
		%>		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPWareHouseConfirm.jsp")' > 
		</td>
	</tr>
</table> 
<hr>
<%
try
{
	sql = " SELECT distinct e.request_no"+
		  ", a.request_type"+
		  ", g.organization_code"+
		  ", a.organization_id"+
		  ", a.wip_entity_name"+
		  ", a.wip_entity_id"+
		  ", a.inventory_item_id"+
		  ", a.item_name"+
		  ", a.tsc_package"+
		  ", a.created_by"+
		  ", to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
		  ", a.last_updated_by"+
		  ", to_char(a.last_update_date,'yyyy-mm-dd') last_update_date"+
		  ", nvl(d.TYPE_VALUE ,a.status) status"+
		  ", a.version_id"+
		  ", e.PICK_NO"+
		  ", c.TYPE_NAME"+
		  ", b.description component_item_desc"+
		  ", e.line_no"+
		  ", e.comp_type_no"+
		  ", f.comp_type_name"+
		  ", e.component_item_id"+
		  ", e.component_name"+
		  ", e.uom"+
		  ", e.request_qty"+
		  ", e.remarks"+
		  ", h.SUBINVENTORY_CODE "+
          ", sum(h.lot_qty) over (partition by e.request_no,e.line_no,a.item_name) tot_lot_qty"+  //modify by Peggy 20170815
          ", sum(h.lot_qty) over (partition by e.request_no,e.line_no,a.item_name,h.SUBINVENTORY_CODE ) lot_qty"+  //modify by Peggy 20170815
		  //",(select distinct SUBINVENTORY_CODE from oraddman.tsa01_request_line_lots_all x where x.request_no=e.request_no and x.line_no=e.line_no) SUBINVENTORY_CODE"+
		  ", (select listagg(k.LOT ||'  ' ||K.LOT_QTY||K.UOM ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'\n') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
		  "   where e.request_no=k.request_no"+
		  "   and e.line_no=k.line_no) lot_list"+
		  " , (SELECT COUNT(1) FROM  oraddman.tsa01_request_wafer_lot_all k WHERE e.request_no = k.request_no AND e.line_no = k.line_no) lot_cnt"+
		  //" ,nvl((select sum(lot_qty) from oraddman.tsa01_request_line_lots_all x where x.request_no=e.request_no and x.line_no=e.line_no),0) lot_qty"+
		  " , count(distinct h.SUBINVENTORY_CODE) over (partition by e.request_no,e.line_no,a.item_name) tot_line"+ //modify by Peggy 20170815
		  " FROM oraddman.tsa01_request_headers_all a"+
		  " ,inv.mtl_system_items_b b"+
		  " ,(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
		  " ,(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
		  " ,oraddman.tsa01_request_lines_all e"+
		  " ,oraddman.tsa01_component_type f"+
		  " ,mtl_parameters g"+
		  ", oraddman.tsa01_request_line_lots_all  h"+
		  " where e.organization_id=b.organization_id "+
		  " and e.component_item_id=b.inventory_item_id "+
		  " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
		  " and a.status=d.TYPE_NAME(+)"+
		  " and a.request_no=e.request_no(+)"+
		  " and e.COMP_TYPE_NO=f.COMP_TYPE_NO(+)"+
		  " and a.organization_id=g.organization_id(+)"+
		  " and h.Request_no(+)=e.request_no"+
		  " and H.line_no(+)=e.line_no"+
		  " and e.status=?";
	if (!PICK_NO.equals(""))
	{
		sql += " and e.pick_no='"+ PICK_NO+"'";
	}
	if (!WIP_NO.equals(""))
	{
		sql += " and upper(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	}
	sql += " order by a.wip_entity_name,e.request_no,e.LINE_NO,h.SUBINVENTORY_CODE";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"PICKED");		
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	String strColor=""; 
	while (rs.next())
	{		
		if (icnt ==0)
		{
%>
			<table border="0" width="100%">
				<tr><td style="background-color:#F8E0BC" width="2%">&nbsp;&nbsp;</td><td>註:撿貨數量欄位若有標顏色,表示該工單該型號之發貨倉有一個以上</td></tr>
			</table>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr bgcolor="#B4E0C8" style="font-family:'細明體';font-size:12px" align="center">
					<td width="3%"><input type="checkbox" name="chkall" value="Y"  onClick="checkall()"></td>
					<td width="6%">倉庫備註</td>
					<td width="6%">出(入)倉別</td>
					<td width="8%">撿貨單號</td>
					<td width="7%">領料單號</td>
					<td width="8%">工單號碼</td>
					<td width="10%">類別</td>
					<td width="12%">原物料名稱</td>
					<td width="23%">品名</td>
					<td width="6%">領用數量</td>
					<td width="6%">撿貨數量</td>
					<td width="5%">單位</td>
				</tr>
<%		
		}
					
		//if (rs.getFloat("REQUEST_QTY") > rs.getFloat("lot_qty"))
		if (rs.getFloat("REQUEST_QTY") > rs.getFloat("tot_lot_qty")) //modify by Peggy 20170815
		{
			strColor="color:#FF0000;font-weight:bold;";
		}
		else
		{
			strColor ="color:#000000;";
		}
		sql = " SELECT  a.subinventory_code,"+
			  " a.lot_number, a.lot_qty,a.uom,"+
			  " to_char(a.expiration_date,'yyyy-mm-dd') expiration_date,a.transfer_subinventory"+
			  " from oraddman.tsa01_request_line_lots_all a"+
			  " where a.request_no=? "+
			  " and a.line_no=?"+
			  " order by a.lot_number,to_char(a.expiration_date,'yyyy-mm-dd') ";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,rs.getString("request_no"));
		statement1.setString(2,rs.getString("line_no"));
		ResultSet rs1=statement1.executeQuery();
		strdetail="";tot_pick_qty=0;
		float pick_qty=0;
		int rowcnt=0;			
		while (rs1.next())
		{	
			if (strdetail.equals(""))
			{
				strdetail ="<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
			}	
			strdetail += "<tr><td>"+rs1.getString("SUBINVENTORY_CODE")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>"+rs1.getString("LOT_NUMBER")+"</td><td align=right>"+Double.valueOf(rs1.getString("LOT_QTY")).doubleValue()+"</td><td align=center>&nbsp;&nbsp;"+rs1.getString("EXPIRATION_DATE")+"</td><td align=center>"+(rs1.getString("transfer_subinventory")==null?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":rs1.getString("transfer_subinventory")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")+"</td></tr>";
			tot_pick_qty +=Double.parseDouble(rs1.getString("LOT_QTY"));
		}	
		if (strdetail.length() >0) strdetail += "<tr><td colspan=5>---------------------------------------------------------------------------------------------------</td></tr><tr><td colspan=3 align=right>Total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+tot_pick_qty+"</td><td>&nbsp;</td></table>";
		//if (strdetail.length() >0) strdetail += "</table>";
		rs1.close();
		statement1.close();
		//out.println(strdetail);
		chkno=rs.getString("request_no")+"_"+rs.getString("line_no")+"_"+rs.getString("SUBINVENTORY_CODE");
%>
			<tr id="tr_<%=icnt%>">
				<td align="center"><input type="checkbox" name="chk" value="<%=chkno%>" onClick="setCheck('<%=icnt%>')"><input type="hidden" name="strkey_<%=chkno%>" value="<%=rs.getString("request_no")+"_"+rs.getString("line_no")%>"> </td>
				<td align="left"><input type="text" name="REMARKS_<%=chkno%>" value="" size="15" style="font-family: Tahoma,Georgia;font-size: 12px"></td>
				<td align="center"><input type="text" name="SUBINV_<%=chkno%>" value="<%=rs.getString("SUBINVENTORY_CODE")%>" size="8" style="font-family: Tahoma,Georgia;font-size: 12px" <%=(rs.getString("request_type").equals("RETURN")?" ":" readonly ")%>></td>
				<td align="center"><%=rs.getString("pick_no")%></td>
				<td align="center"><%=rs.getString("request_no")%></td>
				<td align="center"><%=rs.getString("WIP_ENTITY_NAME")%><input type="hidden" name="WIP_NO_<%=icnt%>" value="<%=rs.getString("WIP_ENTITY_NAME")%>"></td>
				<td align="left"><%=rs.getString("comp_type_name")%><input type="hidden" name="COMP_TYPE_NO_<%=icnt%>" value="<%=rs.getString("COMP_TYPE_NO")%>"></td>
				<td align="left"><a onMouseOver="this.T_STICKY=true;this.T_WIDTH=450;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_TITLE='Subinventory&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lot Number&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Qty&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiration Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Transfer Subinv';this.T_OFFSETY=-100;return escape('<%=strdetail%>')"><%=rs.getString("COMPONENT_NAME")%></a><input type="hidden" name="ITEM_NAME_<%=icnt%>" value="<%=rs.getString("COMPONENT_NAME")%>"></td>
				<td align="left"><%=rs.getString("COMPONENT_ITEM_DESC")%></td>
				<td align="right" style="font-size:12px"><%=Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()%><input type="hidden" name="REQUEST_QTY_<%=icnt%>" value="<%=rs.getFloat("REQUEST_QTY")%>"></td>
				<td align="right" style="<%=(rs.getInt("tot_line")>1?"background-color:#F8E0BC;":"")+strColor+";font-size:12px"%>"><%=Double.valueOf(rs.getString("LOT_QTY")).doubleValue()%><input type="hidden" name="PICK_QTY_<%=icnt%>" value="<%=rs.getFloat("LOT_QTY")%>"></td>
				<td align="center"><%=rs.getString("UOM")%></td>
			</tr>
<%				
		icnt++;
	}
	if (icnt >0)
	{
%>
		</table>
		<hr>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#E4F0F1">
			<tr>
				<td>
		  <p><font style="font-family:Tahoma,Georgia;font-size:12px">
		  <jsp:getProperty name="rPH" property="pgAction"/>
		  =></font>
		 <%
		try
		{   
			sql = "select distinct a.type_name,a.type_value from oraddman.tsa01_base_setup a where a.type_code='REQ_STATUS' AND TYPE_GROUP='K2-005'";
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(sql);
			comboBoxBean.setRs(rs1);
			comboBoxBean.setSelection(STATUS);
			comboBoxBean.setFieldName("STATUS");	
			comboBoxBean.setOnChangeJS("setOPTValue()");			
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs1.close();   
			statement1.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>	
		<input type="button" name="submit1" value="Submit" style="font-family: Tahoma,Georgia;" onClick='setSubmit1("../jsp/TSA01WIPComponentProcess.jsp?PROGRAM=K2-005")'>
		<span id="span2" style="visibility:hidden;font-size:12px">
			退回原因 =></font>
  <input type="text"  name="REJ_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia;font-size:12px">
            </span> 
				
				</td>
			</tr>
		</table>
<%

	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

