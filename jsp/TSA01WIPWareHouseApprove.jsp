<!--20170628 Peggy,點測工單在發料前指定入庫交易-->
<!--20170814 Peggy,新增21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉-->
<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,java.lang.Math.*,java.text.*,java.io.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
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
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (i!=irow && document.MYFORM.chk[i].checked==true)
			{		
				//if (document.MYFORM.elements["request_type_"+lineid].value != document.MYFORM.elements["request_type_"+document.MYFORM.chk[i].value].value)			
				//{
				//	alert("不同交易類型不可合併!");
				//	document.MYFORM.chk[irow].checked=false;
				//	return false;					
				//}												
			}
		}
		document.getElementById("tr_"+lineid).style.backgroundColor ="#D3EFE4";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}
function setAddCheckBox()
{
	if (document.MYFORM.chkadd.checked)
	{
		document.MYFORM.PICK_NO.value="";
		document.MYFORM.PICK_NO.disabled=false;
		document.getElementById("btn2").style.Visibility ="visible";
	}
	else
	{
		document.MYFORM.PICK_NO.value="";
		document.MYFORM.PICK_NO.disabled=true;
		document.getElementById("btn2").style.Visibility ="hidden";
	}
}

function setPickNoList()
{
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked==true)
			{
				lineid = document.MYFORM.chk[i].value;
				break;
			}
		}
	}
	else if (document.MYFORM.chk.checked==true)
	{
		lineid = document.MYFORM.chk.value;
	}
	if (lineid=="")
	{
		alert("請先勾選資料!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSA01WIPPickNotFind.jsp?NO="+lineid,"subwin","width=300,height=300,scrollbars=yes,menubar=no");  
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	var req_type="";
	var errcnt=0;	
	if (document.MYFORM.chkadd.checked==true)
	{
		if (document.MYFORM.PICK_NO.value =="")
		{
			alert("請選擇撿貨單號!");
			document.MYFORM.PICK_NO.focus();
			return false;
		}
	}	
	if (document.MYFORM.STATUS.value =="" || document.MYFORM.STATUS.value =="--")
	{
		alert("請選擇執行動作!");
		document.MYFORM.STATUS.focus();
		return false;
	}
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
		if (chkvalue==true)
		{
			if (req_type=="")
			{
				req_type=document.MYFORM.elements["request_type_"+lineid].value;
			}
			if (document.MYFORM.elements["request_type_"+lineid].value!=req_type)
			{
				errcnt=1;
				break;			
			}
			if (document.MYFORM.chkadd.checked==true)
			{
				if (document.MYFORM.elements["request_type_"+lineid].value != document.MYFORM.REQUEST_TYPE.value)			
				{
					errcnt=1;
					break;
					//alert("不同交易類型不可合併!");
					//return false;					
				}
			}																		
		 	chkcnt ++;
		}
	}
	if (errcnt >=1)
	{
		alert("不同交易類型不可合併!");
		return false;
	}	
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setOPTValue()
{
	if (document.MYFORM.STATUS.value=="DISAGREE")
	{
		document.getElementById("span2").style.visibility ="visible";
		document.getElementById("span1").style.visibility ="hidden";
		document.getElementById("btn2").style.Visibility ="hidden";
		document.MYFORM.REQUEST_TYPE.style.value="";
		document.MYFORM.REJ_REASON.value="";
	}
	else if (document.MYFORM.STATUS.value=="CONFIRMED")
	{
		document.getElementById("span1").style.visibility ="visible";
		document.getElementById("span2").style.visibility ="hidden";
		document.getElementById("btn2").style.Visibility ="visible";
		document.MYFORM.REQUEST_TYPE.style.value="";
		document.MYFORM.REJ_REASON.value="";
	}
	else
	{
		document.getElementById("span1").style.visibility ="hidden";
		document.getElementById("span2").style.visibility ="hidden";
		document.getElementById("btn2").style.Visibility ="hidden";
		document.MYFORM.REQUEST_TYPE.style.value="";
		document.MYFORM.REJ_REASON.value="";
	}
	setAddCheckBox();
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function SetERPTrans(request_no,line_no,qty)
{
	subWin=window.open("../jsp/TSA01WIPComponentMISC.jsp?REQUEST_NO="+request_no+"&LINE_NO="+line_no+"&NUMQ="+qty,"subwin","width=800,height=400,scrollbars=yes,menubar=no");  
}

</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>A01領退料倉庫審核</title>
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
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String sql = "";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String REQUEST_TYPE = request.getParameter("REQUEST_TYPE");
if (REQUEST_TYPE==null) REQUEST_TYPE="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String COMPONENT_NAME = request.getParameter("COMPONENT_NAME");
if (COMPONENT_NAME==null) COMPONENT_NAME="";
String REQ_TYPE_CODE=request.getParameter("REQ_TYPE_CODE");
if (REQ_TYPE_CODE==null) REQ_TYPE_CODE="";  //add by Peggy 20180928
String ERPUSERID="";
float req_qty=0,request_qty=0,allot_qty=0,use_qty=0,onhand=0,erp_qty=0;
String lot_number="";
Hashtable hashtb = new Hashtable();

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
<FORM ACTION="../jsp/TSA01WIPWareHouseApprove.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">A01領退料倉庫審核</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#E4F0F1">
	<tr>
		<td width="5%"><font style="color:#666600;font-family: Tahoma,Georgia">類型:</font></td>
		<td width="10%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("SELECT distinct c.type_value,c.type_name from oraddman.TSA01_REQUEST_LINES_ALL a,oraddman.TSA01_REQUEST_HEADERS_ALL b ,(SELECT TYPE_NAME,TYPE_VALUE FROM oraddman.TSA01_BASE_SETUP x where x.TYPE_CODE='REQ_TYPE') c where a.status='APPROVED' AND a.REQUEST_NO=b.REQUEST_NO AND b.REQUEST_TYPE=c.TYPE_VALUE order by 1");
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(REQ_TYPE_CODE);
			comboBoxBean.setFieldName("REQ_TYPE_CODE");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} //end of try		 
		catch (Exception e) 
		{ 
			//out.println("Exception:"+e.getMessage()); 
		} 
		%>		
		</td>
		<td width="5%"><font style="color:#666600;font-family: Tahoma,Georgia">領料單號:</font></td>
		<td width="15%"><input type="text" name="REQUEST_NO"  style="font-family: Tahoma,Georgia;" value="<%=REQUEST_NO%>"></td>
		<td width="5%"><font style="color:#666600;font-family: Tahoma,Georgia">工單號碼:</font></td>
		<td width="15%"><input type="text" name="WIP_NO"  style="font-family: Tahoma,Georgia;" value="<%=WIP_NO%>"></td>
		<td width="5%"><font style="color:#666600;font-family: Tahoma,Georgia">原物料號:</font></td>
		<td width="40%"><input type="text" name="COMPONENT_NAME"  style="font-family: Tahoma,Georgia;" value="<%=COMPONENT_NAME%>">
			<%
			/*
			try
			{   
				sql = "select distinct a.COMPONENT_NAME,a.COMPONENT_NAME from oraddman.TSA01_REQUEST_LINES_ALL a where a.status='APPROVED' order by a.COMPONENT_NAME";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				comboBoxBean.setRs(rs);
				comboBoxBean.setSelection(COMPONENT_NAME);
				comboBoxBean.setFieldName("COMPONENT_NAME");	
				comboBoxBean.setFontName("Tahoma,Georgia");   
				out.println(comboBoxBean.getRsString());
				rs.close();   
				statement.close();      	 
			} 
			catch (Exception e) 
			{ 
				out.println("Exception:"+e.getMessage()); 
			}
			*/ 	
			%>		
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" name="btnqry" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSA01WIPWareHouseApprove.jsp")' >
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value="EXCEL" onClick='setExportXLS("../jsp/TSA01WIPWareHouseApproveExcel.jsp")' style="font-family: Tahoma,Georgia;" > 
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	sql = " SELECT a.inventory_item_id, a.organization_id, a.SUBINVENTORY_CODE,a.LOT_NUMBER,b.expiration_date,sum(a.TRANSACTION_QUANTITY) onhand,a.transaction_uom_code"+
          " FROM inv.mtl_onhand_quantities_detail a"+
		  ",inv.mtl_lot_numbers b "+
          " where a.inventory_item_id=b.inventory_item_id"+
          " and a.organization_id=b.organization_id"+
          " and a.lot_number=b.lot_number"+
          " and exists (select 1 from oraddman.TSA01_REQUEST_LINES_ALL x where x.status='APPROVED' and x.component_item_id =a.inventory_item_id and x.organization_id=a.organization_id )"+
		  //" and a.SUBINVENTORY_CODE in ('01','02') "+
          " and a.SUBINVENTORY_CODE in ('01','02','21','22','11','12') "+ //21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉,add by Peggy 20170814, 11:OEM 晶片倉,12:OEM 半成品倉 add by Peggy 20211126
          " group by a.inventory_item_id, a.organization_id,a.SUBINVENTORY_CODE,b.expiration_date, a.LOT_NUMBER ,a.transaction_uom_code"+
          " order by a.inventory_item_id, a.organization_id,b.expiration_date,a.lot_number";
	Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rsh = statementh.executeQuery(sql);
	
	sql = " SELECT a.request_no"+
	             ",a.request_type"+
				 ",a.organization_id"+
                 ",a.wip_entity_name"+
				 ",a.wip_entity_id"+
				 ",a.inventory_item_id"+
				 ",e.line_no"+
				 ",e.COMPONENT_NAME"+
				 ",e.REQUEST_QTY"+
				 ",f.COMP_TYPE_NAME"+
				 ",e.UOM"+
                 ",a.item_name"+
				 ",a.tsc_package"+
				 ",a.created_by"+
				 ",to_char(a.creation_date,'mm-dd hh24:mi') creation_date"+
                 ",a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date"+
				 ",nvl(d.TYPE_VALUE ,a.status) status"+
				 ",a.version_id"+
				 ",c.TYPE_NAME"+
				 ",b.description item_desc"+
				 ",e.COMP_TYPE_NO"+
				 ",row_number() over (partition by a.organization_id order by a.request_no desc) tot_cnt"+
                 //",(select listagg(k.LOT ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'<br>') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
                 ",(select listagg(CASE WHEN NVL(k.MISCELLANEOUS_FLAG,'N')='Y' AND nvl(k.TRANSACTIONS_TYPE_ID,0)=327 THEN '工程批:' ELSE '' END || k.LOT || '  '||k.LOT_QTY||k.UOM||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'<br>') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
				 " where e.request_no=k.request_no"+
                 " and e.line_no=k.line_no) lot_list,"+
                 " NVL((SELECT DISTINCT 'Y' FROM oraddman.tsa01_base_setup g WHERE g.type_code = 'TRANS_TYPE' AND SUBSTR (a.wip_entity_name, 1, 1) = g.type_name AND e.comp_type_no = g.type_group),'N')  erp_misc_flag"+  //add by Peggy 20170629
				 " FROM oraddman.tsa01_request_headers_all a"+
				 ",inv.mtl_system_items_b b"+
				 ",(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
				 ",(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
				 ",oraddman.TSA01_REQUEST_LINES_ALL e"+
				 ",oraddman.TSA01_COMPONENT_TYPE f"+
				 " where a.organization_id=b.organization_id "+
				 " and a.inventory_item_id=b.inventory_item_id "+
				 " and a.request_no=e.request_no"+
				 " and e.COMP_TYPE_NO=f.COMP_TYPE_NO"+
				 " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
				 " and a.status=d.TYPE_NAME(+)";
	if (!REQ_TYPE_CODE.equals("--") && REQ_TYPE_CODE !=null && !REQ_TYPE_CODE.equals("")) 
	{
		sql += " and a.request_type='"+ REQ_TYPE_CODE+"'";
	}
	if (!REQUEST_NO.equals(""))
	{
		sql += " and a.request_no='"+ REQUEST_NO+"'";
	}
	if (!WIP_NO.equals(""))
	{
		sql += " and upper(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	}	
	if (!COMPONENT_NAME.equals("") && !COMPONENT_NAME.equals("--"))
	{
		sql += " and e.COMPONENT_NAME LIKE '"+ COMPONENT_NAME+"%'";
	}
	sql += " and e.status=?"+
	       " order by a.wip_entity_name,a.request_no,e.line_no ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"APPROVED");
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	while (rs.next())
	{
		if (icnt ==0)
		{
%>
		<table cellSpacing="1" bordercolordark="#5C7671"  cellPadding="0" width="100%" align="center" borderColorLight="#ffffff" border="1">
			<tr bgcolor="#C5C6AE" style="font-family:'細明體';font-size:12px" align="center">
				<td width="3%">項次</td>
				<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
				<td width="6%" align="center">領料單號</td>
				<td width="4%" align="center">類型</td>
				<td width="8%" align="center">工單號碼</td>
				<td width="13%" align="center">料號</td>
				<td width="6%" align="center">類別</td>
				<td width="11%" align="center">原物料號</td>
				<td width="6%" align="center">領用數量</td>
				<td width="6%" align="center">可使用庫存量</td>
				<td width="5%" align="center">入庫交易</td>
				<td width="4%" align="center">單位</td>
				<td width="12%" align="center">指定LOT</td>
				<td width="7%" align="center">申請人</td>
				<td width="9%" align="center">申請日期</td>
			</tr>
		
<%
		}
		if (rs.getString("request_type").equals("RETURN"))
		{
			req_qty =rs.getFloat("request_qty");
		}
		else
		{
			if (rs.getString("comp_type_no").equals("C008"))
			{
				request_qty = rs.getFloat("request_qty")*1000;	
				req_qty = rs.getFloat("request_qty")*1000;
			}
			else
			{
				request_qty=-999;
				req_qty =-999;
			}
					
			sql = " select a.request_no,a.line_no,a.COMPONENT_ITEM_ID,a.ORGANIZATION_ID,b.LOT,nvl(b.LOT_QTY,a.REQUEST_QTY) request_qty,a.uom,a.REQUEST_QTY wip_request_qty"+
				  " from oraddman.tsa01_request_lines_all a,oraddman.tsa01_request_wafer_lot_all b"+
				  " where a.request_no=b.request_no(+)"+
				  " and a.line_no=b.line_no(+)"+
				  " and a.request_no=?"+
				  " and a.line_no=?";
			//out.println(sql);
			PreparedStatement statement2 = con.prepareStatement(sql);
			statement2.setString(1,rs.getString("request_no"));
			statement2.setString(2,rs.getString("line_no"));
			ResultSet rs2=statement2.executeQuery();
			while (rs2.next())
			{	
				if (request_qty <0)
				{
					request_qty = rs2.getFloat("request_qty")*1000;	
				}
				if (req_qty<0)
				{
					req_qty = rs2.getFloat("request_qty")*1000;	
				}
				lot_number="";
				onhand =0;
				if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
				while (rsh.next())
				{
					if (request_qty <=0) break;
					
					if (!rs2.getString("COMPONENT_ITEM_ID").equals(rsh.getString("INVENTORY_ITEM_ID")))
					{
						continue;
					}
					if (rs2.getString("LOT")!=null)
					{
						lot_number = rs2.getString("LOT");
						if (rsh.getString("LOT_NUMBER").equals(lot_number))
						{
							onhand=rsh.getFloat("onhand")*1000;
						}
					}
					else
					{
						lot_number = rsh.getString("LOT_NUMBER");
						onhand=rsh.getFloat("onhand")*1000;
					}
					if (hashtb.get(rsh.getString("organization_id")+";"+rsh.getString("INVENTORY_ITEM_ID")+";"+rsh.getString("SUBINVENTORY_CODE")+";"+lot_number)==null)
					{
						if (onhand>request_qty)
						{
							allot_qty = request_qty;
							request_qty-=allot_qty;
						}
						else
						{
							allot_qty = onhand;
							request_qty-=allot_qty;
						}
						hashtb.put(rsh.getString("organization_id")+";"+rsh.getString("INVENTORY_ITEM_ID")+";"+rsh.getString("SUBINVENTORY_CODE")+";"+lot_number,""+(allot_qty/1000));
					}
					else
					{
						use_qty = Float.parseFloat((String)hashtb.get(rsh.getString("organization_id")+";"+rsh.getString("INVENTORY_ITEM_ID")+";"+rsh.getString("SUBINVENTORY_CODE")+";"+lot_number))*1000;
						//out.println(use_qty);
						onhand -= use_qty;
						if (onhand <=0) continue;
						if (onhand>request_qty)
						{
							allot_qty = request_qty;
							request_qty-=allot_qty;
						}
						else
						{
							allot_qty = onhand;
							request_qty-=allot_qty;
						}
						hashtb.put(rsh.getString("organization_id")+";"+rsh.getString("INVENTORY_ITEM_ID")+";"+rsh.getString("SUBINVENTORY_CODE")+";"+lot_number,""+((allot_qty+use_qty)/1000));					
						
					}
				}
			}
			rs2.close();
			statement2.close();
			req_qty = (req_qty - request_qty)/1000;
		}
			  
%>
			<tr style="font-family:airl;font-size:12px" id="tr_<%=rs.getString("request_no")+"_"+rs.getString("line_no")%>">
				<td align="center"><%=(icnt+1)%></td>
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("request_no")+"_"+rs.getString("line_no")%>" onClick="setCheck(<%=icnt%>)"></td>
				<td align="center"><%=rs.getString("request_no")%></td>
				<td align="center" <%=(rs.getString("request_type").equals("RETURN")?"style='background-color:#F9C6DB'":"")%>><input type="hidden" name="request_type_<%=rs.getString("request_no")+"_"+rs.getString("line_no")%>" value="<%=rs.getString("request_type")%>"><%=rs.getString("TYPE_NAME")%></td>
				<td align="center"><%=rs.getString("wip_entity_name")%></td>
				<td><%=rs.getString("item_name")%></td>
				<td><%=rs.getString("COMP_TYPE_NAME")%></td>
				<td><%=rs.getString("COMPONENT_NAME")%></td>
				<td align="right"><%=Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()%></td>
				<td align="right" <%=(Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()<=Double.valueOf(""+req_qty).doubleValue()?"":" style='color:#ff0000;font-weight:bold'")%>><%=Double.valueOf(""+req_qty).doubleValue()%></td>
				<%erp_qty= ((rs.getFloat("REQUEST_QTY")*1000) - (req_qty*1000))/1000;%>
				<td align="center"><%=(rs.getString("request_type").equals("ISSUE") && rs.getString("ERP_MISC_FLAG").equals("Y") && Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()>Double.valueOf(""+req_qty).doubleValue()?"<input type='button' name='btn"+(icnt+1)+"' value='....' onClick='SetERPTrans("+'"'+rs.getString("request_no")+'"'+","+'"'+rs.getString("line_no")+'"'+","+'"'+erp_qty+'"'+")'>":"&nbsp;")%></td>
				<td align="center"><%=rs.getString("uom")%></td>
				<td><%=(rs.getString("lot_list")==null?"&nbsp;":rs.getString("lot_list"))%></td>
				<td align="center"><%=rs.getString("created_by")%></td>
				<td align="center"><%=rs.getString("creation_date")%></td>
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
				sql = "select distinct a.type_name,a.type_value from oraddman.tsa01_base_setup a where a.type_code='REQ_STATUS' AND TYPE_GROUP='K2-003'";
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);
				comboBoxBean.setRs(rs1);
				comboBoxBean.setSelection(STATUS);
				comboBoxBean.setOnChangeJS("setOPTValue()");
				comboBoxBean.setFieldName("STATUS");	
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
	        <input type="button" name="submit1" value="Submit" style="font-family: Tahoma,Georgia;" onClick='setSubmit1("../jsp/TSA01WIPComponentProcess.jsp?PROGRAM=K2-003")'>
			
				<span id="span1" style="font-size:12px">
				<input type="checkbox" name="chkadd" value="ADD" onClick="setAddCheckBox();"><font  style="color:000000;font-family: Tahoma,Georgia">Add To Pick No</font>
				&nbsp;&nbsp;<input type="text" style="font-family:Tahoma,Georgia;" name="PICK_NO" value="<%=PICK_NO%>" size="20"  onKeyDown="return (event.keyCode!=8);" readonly disabled>
				<input type="button" id="btn2" name="btnadd" value=".."  onClick="setPickNoList();"> </span>
						        <br><span id="span2" style="visibility:hidden;font-size:12px">
			退件原因 =></font>
  <input type="text"  name="REJ_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia;font-size:12px">
            </span> 
				</td>
			</tr>
		</table>		
<%
	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>目前無申請資料,請重新確認,謝謝!</strong></font></div>");
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
<input type="hidden" name="REQUEST_TYPE" value="<%=REQUEST_TYPE%>">
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

