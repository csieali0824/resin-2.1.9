<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Pick Confirm Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
//window.onbeforeunload = bunload; 
//function bunload()  
//{  
//	if (event.clientY < 0)  
//   {  
//		if (confirm("您確定要不存檔離開嗎?")==true)
//		{
//			window.opener.document.MYFORM.submit();
//			window.close();	
//		}		
//    }  
//} 
function setAddLine(URL)
{
	var TXTLINE = document.MYFORMD.TXTLINE.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入欲新增行數!");
		document.MYFORMD.TXTLINE.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>10)
		{
    		alert("行數新增範圍1~10!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;		
		}
	}
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setDelete(objLine)
{
	if (confirm("您確定要刪除資料嗎?"))
	{
		var REQUEST_NO = document.MYFORMD.REQUEST_NO.value;
		var LINE_NO = document.MYFORMD.LINE_NO.value;
		var SUBINVENTORY  = document.MYFORMD.elements["SUBINVENTORY_"+objLine].value;
		var LOT   = document.MYFORMD.elements["LOT_"+objLine].value;
		document.MYFORMD.action="../jsp/TSA01WIPWareHousePickDetail.jsp?ACODE=DELETELINE&REQUEST_NO="+REQUEST_NO+"&LINE_NO="+LINE_NO+"&SUBINVENTORY_CODE="+SUBINVENTORY+"&LOT_NUMBER="+LOT;
		document.MYFORMD.submit();	
	}
	else
	{
		return false;
	}
}
function setSubmit(URL)
{
	var totqty = 0;
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		if (document.MYFORMD.COMP_TYPE_NO.value != "C009" && document.MYFORMD.COMP_TYPE_NO.value != "C010")
		{
			if (document.MYFORMD.elements["TRANSFER_SUBINV_"+i].value!="")
			{
				alert("項次"+i+":此型號不是扣邊線倉庫存,不用指定庫房!!");
				document.MYFORMD.elements["TRANSFER_SUBINV_"+i].focus();
				return false;
			}
		}
		if (document.MYFORMD.elements["SUBINVENTORY_"+i].value!="")
		{
			if (document.MYFORMD.elements["LOT_"+i].value=="")
			{
				alert("項次"+i+":請輸入LOT NUMBER!!");
				document.MYFORMD.elements["LOT_"+i].focus();
				return false;
			}
			if (document.MYFORMD.elements["PICK_QTY_"+i].value=="")
			{
				alert("項次"+i+":請輸入撿貨數量!!");
				document.MYFORMD.elements["PICK_QTY_"+i].focus();
				return false;
			}
		}
		if (document.MYFORMD.elements["LOT_"+i].value!="")
		{
			if (document.MYFORMD.elements["SUBINVENTORY_"+i].value=="")
			{
				alert("項次"+i+":請輸入SUBINVENTORY!!");
				document.MYFORMD.elements["SUBINVENTORY_"+i].focus();
				return false;
			}
			if (document.MYFORMD.elements["PICK_QTY_"+i].value=="")
			{
				alert("項次"+i+":請輸入撿貨數量!!");
				document.MYFORMD.elements["PICK_QTY_"+i].focus();
				return false;
			}
		}	
		if (document.MYFORMD.elements["PICK_QTY_"+i].value!="")
		{
			if (document.MYFORMD.elements["SUBINVENTORY_"+i].value=="")
			{
				alert("項次"+i+":請輸入SUBINVENTORY!!");
				document.MYFORMD.elements["SUBINVENTORY_"+i].focus();
				return false;
			}
			if (document.MYFORMD.elements["LOT_"+i].value=="")
			{
				alert("項次"+i+":請輸入LOT NUMBER!!");
				document.MYFORMD.elements["LOT_"+i].focus();
				return false;
			}
		}	
		if (document.MYFORMD.elements["SUBINVENTORY_"+i].value!="" || document.MYFORMD.elements["LOT_"+i].value !=="")
		{
			for (var j =i+1 ; j <= document.MYFORMD.LINECNT.value ; j++)
			{ 
				if (document.MYFORMD.elements["SUBINVENTORY_"+j].value!="" || document.MYFORMD.elements["LOT_"+j].value !=="")
				{
					if (document.MYFORMD.elements["SUBINVENTORY_"+i].value==document.MYFORMD.elements["SUBINVENTORY_"+j].value && document.MYFORMD.elements["LOT_"+i].value==document.MYFORMD.elements["LOT_"+j].value) 
					{
						alert("項次"+i+"與項次"+j+"LOT重複,請合併同一筆後再存檔!!");
						document.MYFORMD.elements["LOT_"+j].focus();
						return false;
					}
				}
			}
		}
		totqty +=eval(document.MYFORMD.elements["PICK_QTY_"+i].value);
	}
	//if (eval(totqty) > eval(document.MYFORMD.MOQ.value))
	//{
	//	alert("領用量必須小於 "+eval(document.MYFORMD.MOQ.value)+document.MYFORMD.UOM.value+"!!");
	//	return false;
	//}
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.cancel1.disabled=true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setClose()
{
	if (confirm("您確定要不存檔離開嗎?"))
	{
		//document.MYFORMD.action="../jsp/TSA01WIPWareHousePick.jsp";
		//document.MYFORMD.submit();	
		window.opener.document.MYFORM.submit();
		this.window.close();
		
	}
}
function setSave()
{
	//document.MYFORMD.action="../jsp/TSA01WIPWareHousePick.jsp";
	//document.MYFORMD.submit();	
	window.opener.document.MYFORM.submit();
	this.window.close();
}

function setChange()
{
	document.MYFORMD.submit();
}
function setLot(objLine)
{
	if (document.MYFORMD.elements["SUBINVENTORY_"+objLine].value!="" && document.MYFORMD.elements["LOT_"+objLine].value!="")
	{
		document.MYFORMD.action="../jsp/TSA01WIPWareHousePickDetail.jsp?ACODE=UPDATE&CHANGE_LINE="+objLine;
		document.MYFORMD.submit();
	}
}
</script>
<%
String sql = "";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String LINE_NO = request.getParameter("LINE_NO");
if (LINE_NO==null) LINE_NO="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
String SUBINVENTORY_CODE = request.getParameter("SUBINVENTORY_CODE");
if (SUBINVENTORY_CODE==null) SUBINVENTORY_CODE="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String ITEM_ID = request.getParameter("ITEM_ID");
if (ITEM_ID==null) ITEM_ID="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="3";
String ORIGCNT=  request.getParameter("ORIGCNT");
if (ORIGCNT ==null) ORIGCNT="";
String REQUEST_QTY = request.getParameter("REQUEST_QTY");
if (REQUEST_QTY ==null) REQUEST_QTY="";
String REQUEST_TYPE = request.getParameter("REQUEST_TYPE");
if (REQUEST_TYPE==null) REQUEST_TYPE="";
String MOQ = request.getParameter("MOQ");
if (MOQ==null) MOQ="";
String UOM = request.getParameter("UOM");
if (UOM==null) UOM="";
String DEL_LINE = request.getParameter("DEL_LINE");
if (DEL_LINE==null) DEL_LINE="";
String COMP_TYPE_NO = request.getParameter("COMP_TYPE_NO");
if (COMP_TYPE_NO==null) COMP_TYPE_NO="";
boolean def_lot=false;
boolean Line_Exist = false;
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="NEW";
if (ACODE.equals("ADDLINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)+Integer.parseInt(TXTLINE));
}
else if (ACODE.equals("DELETELINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)-1);
}
if (LINECNT.equals("0")) LINECNT="1";
int icnt=0,errcnt=0;	

try
{
	if (ACODE.equals("NEW"))
	{
		sql = " select a.organization_id,c.wip_entity_name,a.pick_no,a.comp_type_no,a.component_item_id inventory_item_id,a.COMPONENT_NAME ITEM_NAME,a.UOM,a.REQUEST_QTY,a.ISSUE_QTY,b.description,a.MOQ "+
			  " from oraddman.tsa01_request_lines_all a"+
			  " ,inv.mtl_system_items_b b"+
			  ",oraddman.tsa01_request_headers_all c"+
			  " where a.organization_id=b.organization_id"+
			  " and a.component_item_id=b.inventory_item_id"+
			  " and a.request_no=c.request_no"+
			  " and a.REQUEST_NO=?"+
			  " and a.LINE_NO=?";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,REQUEST_NO);
		statement1.setString(2,LINE_NO);
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{
			PICK_NO =rs1.getString("PICK_NO");
			WIP_NO = rs1.getString("WIP_ENTITY_NAME");
			Line_Exist=true;
			ITEM_ID=rs1.getString("INVENTORY_ITEM_ID");
			ITEM_NAME=rs1.getString("ITEM_NAME");
			UOM=rs1.getString("UOM");
			REQUEST_QTY=rs1.getString("REQUEST_QTY");
			ITEM_DESC = rs1.getString("DESCRIPTION");
			MOQ=rs1.getString("MOQ");
			COMP_TYPE_NO=rs1.getString("COMP_TYPE_NO");
			ORGANIZATION_ID=rs1.getString("ORGANIZATION_ID");
		}
		else
		{
			Line_Exist=false;
		}
		rs1.close();
		statement1.close();	
	}
	else
	{
		Line_Exist =true;
	}
}
catch(Exception e)
{
	Line_Exist=false;
}

if (!Line_Exist)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查無撿貨資料,請重新確認,謝謝!");
		this.window.close();	
	</script>
<%
}  
%>
<body>  
<FORM ACTION="../jsp/TSA01WIPWareHousePickDetail.jsp" METHOD="post" NAME="MYFORMD">
<TABLE border="0" width="100%" align="center">
	<tr>
		<td width="15%" style="font-size:12px" align="right">撿貨單號：</td>
		<td width="85%" colspan="4"><input type="text" name="PICK_NO" value="<%=PICK_NO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="20" readonly><input type="hidden" name="PICK_NO" value="<%=PICK_NO%>"><input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>"><input type="hidden" name="REQUEST_TYPE" value="<%=REQUEST_TYPE%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">領料單號：</td>
		<td colspan="4"><input type="text" name="REQUEST_NO" value="<%=REQUEST_NO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="20"  readonly><input type="hidden" name="LINE_NO" value="<%=LINE_NO%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">工單號碼：</td>
		<td colspan="4"><input type="text" name="WIP_NO" value="<%=WIP_NO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;"  size="20" readonly><input type="hidden" name="WIP_NO" value="<%=WIP_NO%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">料號：</td>
		<td colspan="4"><input type="text" name="ITEM_NAME" value="<%=ITEM_NAME%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;"  size="20"  readonly><input type="hidden" name="COMP_TYPE_NO" value="<%=COMP_TYPE_NO%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">型號：</td>
		<td colspan="4"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="80" readonly><input type="hidden" name="ITEM_ID" value="<%=ITEM_ID%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right"><%=(REQUEST_TYPE.equals("RETURN")?"領退":"領用")%>數量：</td>
		<td colspan="4"><input type="TEXT" name="REQUEST_QTY" value="<%=(new DecimalFormat("#####.###")).format(Float.parseFloat(REQUEST_QTY))%>" style="text-align:right;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="5"><input type="text" NAME="UOM" value="<%=UOM%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="5" readonly><input type="hidden" name="MOQ" value="<%=MOQ%>"></td>
	</tr>
</TABLE>
<hr>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="5%" align="center">項次</td>
		<td width="10%" align="center">Subinventory</td>
		<td width="10%" align="center">Lot Number</td>
		<td width="8%" align="center">撿貨數量</td>
		<td width="8%" align="center">Transfer Subinv</td>
		<td width="8%" align="center">&nbsp;</td>
	</tr>
<%
try
{
	if (ACODE.equals("NEW") || ACODE.equals("DELETELINE") || ACODE.equals("SAVE") || ACODE.equals("ADDLINE"))
	{
		if (ACODE.equals("DELETELINE"))
		{
			sql = " delete oraddman.tsa01_request_line_lots_all"+
				  " where request_no=?"+
				  " and line_no=?"+
				  " and subinventory_code=?"+
				  " and lot_number=?";
			//out.println(REQUEST_NO);
			//out.println(LINE_NO);
			//out.println(SUBINVENTORY_CODE);
			//out.println(LOT_NUMBER);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUEST_NO);
			pstmtDt.setString(2,LINE_NO);
			pstmtDt.setString(3,SUBINVENTORY_CODE);
			pstmtDt.setString(4,LOT_NUMBER);
			pstmtDt.executeQuery();
			pstmtDt.close();				  

			sql = " update oraddman.tsa01_request_lines_all a"+
			      " set issue_qty=nvl((select sum(lot_qty) from oraddman.tsa01_request_line_lots_all b where b.request_no=a.request_no and b.line_no=a.line_no),0)"+
				  " where request_no=?"+
				  " and line_no=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUEST_NO);
			pstmtDt.setString(2,LINE_NO);
			pstmtDt.executeQuery();
			pstmtDt.close();	

			con.commit();		
		}
		
		String data [][] = new String [Integer.parseInt(LINECNT)][4];
		if (ACODE.equals("NEW") || ACODE.equals("DELETELINE"))
		{
			icnt =0;
			sql = " SELECT distinct a.request_no,a.line_no,c.subinventory_code,nvl(b.lot,c.lot_number) lot_number,nvl(c.lot_qty,b.lot_qty) lot_qty"+
                  ",count(b.line_no) over (partition by b.request_no,b.line_no order by b.line_no) deault_lot_cnt"+
                  ",count(c.line_no) over (partition by c.request_no,c.line_no order by c.line_no) allot_lot_cnt"+
				  ",nvl(c.transfer_subinventory,'') transfer_subinventory"+	 
                  " FROM oraddman.tsa01_request_lines_all a"+
				  ",oraddman.tsa01_request_wafer_lot_all b"+
				  ",oraddman.tsa01_request_line_lots_all c"+
                  " where a.request_no=c.request_no(+)"+
                  " and a.line_no=c.line_no(+)"+
				  " and a.request_no=?"+
				  " and a.line_no=?"+
				  " and c.request_no=b.request_no(+)"+
                  " and c.line_no=b.line_no(+)"+
                  " and c.lot_number=b.lot(+)"+
				  " order by a.request_no,a.line_no";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,REQUEST_NO);
			statement.setString(2,LINE_NO);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				if (icnt==0)
				{
					if (rs.getInt("deault_lot_cnt") >0)
					{
						LINECNT = ""+rs.getInt("deault_lot_cnt");
						def_lot =true;
					}
					else
					{
						LINECNT =""+(rs.getInt("allot_lot_cnt")+3); 
					}
					data= new String [Integer.parseInt(LINECNT)][4];
				}
				data[icnt][0] = rs.getString("subinventory_code");
				data[icnt][1] = rs.getString("lot_number");
				data[icnt][2] = (new DecimalFormat("######0.####")).format(rs.getFloat("lot_qty"));
				data[icnt][3] = (rs.getString("transfer_subinventory")==null?"":rs.getString("transfer_subinventory"));
				icnt++;				
			}
			rs.close();
			statement.close();		
		}
		for (int i =0 ; i <Integer.parseInt(LINECNT) ; i++)
		{
			if (ACODE.equals("ADDLINE") || ACODE.equals("SAVE"))
			{
				data[i][0] = request.getParameter("SUBINVENTORY_"+(i+1));
				data[i][1] = request.getParameter("LOT_"+(i+1));
				data[i][2] = request.getParameter("PICK_QTY_"+(i+1));
				data[i][3] = request.getParameter("TRANSFER_SUBINV_"+(i+1));
			}
		%>
			<tr>
				<td align="center"><%=(i+1)%></td>
				<td><input type="text" NAME="SUBINVENTORY_<%=(i+1)%>" value="<%=(data[i][0]==null?"":data[i][0])%>" style="font-family: Tahoma,Georgia;" size="10"></td>
				<td><input type="text" name="LOT_<%=(i+1)%>" value="<%=(data[i][1]==null?"":data[i][1])%>" style="font-family: Tahoma,Georgia;" size="20"></td>
				<td align="center"><input type="text" name="PICK_QTY_<%=(i+1)%>" value="<%=(data[i][2]==null?"":data[i][2])%>" style="font-family: Tahoma,Georgia;" size="10"></td>
				<td><input type="text" name="TRANSFER_SUBINV_<%=(i+1)%>" value="<%=(data[i][3]==null?"":data[i][3])%>" style="font-family: Tahoma,Georgia;" size="10"></td>
				<td align="center"><input type="button" name="DEL<%=(i+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick="setDelete(<%=(i+1)%>)" <%=(def_lot?" disabled":"")%>></td>
			</tr>	
		
		<%		
		}	
	}
		
	if (ACODE.equals("SAVE"))
	{
		try
		{
			String strErr="";
				
			sql = " delete oraddman.tsa01_request_line_lots_all a"+
				  " where request_no=?"+
				  " and line_no=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUEST_NO);
			pstmtDt.setString(2,LINE_NO);
			pstmtDt.executeQuery();
			pstmtDt.close();
							
			for (int i = 1 ; i <= Integer.parseInt(LINECNT) ;i++)
			{
				if (request.getParameter("LOT_"+i) == null || request.getParameter("LOT_"+i).equals("")) continue;
				strErr="";
				
				if (REQUEST_TYPE.equals("ISSUE")) //領用才檢查
				{
					//檢查onhand
					sql = " SELECT SUM(A.TRANSACTION_QUANTITY)-NVL((select LOT_QTY from oraddman.tsa01_request_line_lots_all x where x.erp_flag=? and x.ORGANIZATION_ID=a.ORGANIZATION_ID and x.COMPONENT_ITEM_ID=a.inventory_item_id and x.SUBINVENTORY_CODE=a.SUBINVENTORY_CODE and x.LOT_NUMBER=a.LOT_NUMBER and x.request_no<>? and x.line_no<>?),0)-?  AS TRANSACTION_QUANTITY "+
						  " FROM inv.mtl_onhand_quantities_detail a"+
						  " WHERE A.ORGANIZATION_ID=?"+
						  " AND A.INVENTORY_ITEM_ID=?"+
						  " AND A.SUBINVENTORY_CODE=?"+
						  " AND A.LOT_NUMBER=?"+
						  " GROUP BY A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.SUBINVENTORY_code,A.LOT_NUMBER";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"N");
					statement.setString(2,REQUEST_NO);
					statement.setString(3,LINE_NO);
					statement.setString(4,request.getParameter("PICK_QTY_"+i));
					statement.setString(5,ORGANIZATION_ID);
					statement.setString(6,ITEM_ID);
					statement.setString(7,request.getParameter("SUBINVENTORY_"+i));
					statement.setString(8,request.getParameter("LOT_"+i));
					ResultSet rs=statement.executeQuery();
					if (rs.next()) 
					{ 
						if (rs.getFloat(1)<0)
						{
							strErr="料號:"+ITEM_NAME+" LOT:"+request.getParameter("LOT_"+i)+" 庫存不足!!";
						}
					}
					else
					{
						strErr="料號:"+ITEM_NAME+" LOT:"+request.getParameter("LOT_"+i)+" 查無庫存資料!!";
					}
					rs.close();
					statement.close();
				}
				
				//檢查移轉庫房是否存在
				if (request.getParameter("TRANSFER_SUBINV_"+i)!=null && request.getParameter("TRANSFER_SUBINV_"+i) !="" && request.getParameter("TRANSFER_SUBINV_"+i) !="&nbsp;" && request.getParameter("TRANSFER_SUBINV_"+i).length()>0)
				{
					sql = " SELECT COUNT(1)"+
						  " FROM INV.MTL_SECONDARY_INVENTORIES A"+
						  " WHERE A.ORGANIZATION_ID =?"+
						  " AND A.SECONDARY_INVENTORY_NAME=?"+
						  " AND (A.DISABLE_DATE IS NULL OR A.DISABLE_DATE>TRUNC(SYSDATE))";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ORGANIZATION_ID);
					statement.setString(2,request.getParameter("TRANSFER_SUBINV_"+i));
					ResultSet rs=statement.executeQuery();
					if (rs.next()) 
					{ 
						if (rs.getInt(1)<=0)
						{
							strErr="庫房:"+request.getParameter("TRANSFER_SUBINV_"+i)+"不存在!!";
						}
					}
					else
					{
						strErr="庫房:"+request.getParameter("TRANSFER_SUBINV_"+i)+"不存在!!";
					}
					rs.close();
					statement.close();
				}	  
				
				if (strErr.length()>0)
				{
					throw new Exception(strErr);
				}
				
				sql = " insert into oraddman.tsa01_request_line_lots_all"+
					  " (request_no"+
					  ", line_no"+
					  ", organization_id"+
					  ", component_item_id"+
					  ", component_name"+
					  ", uom"+
					  ", subinventory_code"+
					  ", lot_number"+
					  ", lot_qty"+
					  ", expiration_date"+
					  ", created_by"+
					  ", creation_date"+
					  ", last_updated_by"+
					  ", last_update_date"+
					  ", erp_flag"+
					  ", transfer_subinventory"+
					  " )"+
					  "  select "+
					  "  a.request_no"+
					  ", a.line_no"+
					  ", a.organization_id"+
					  ", a.component_item_id"+
					  ", a.component_name"+
					  ", a.uom"+
					  ", ?"+
					  ", ?"+
					  ", ?"+
					  ", b.expiration_date"+
					  ", ?"+
					  ", sysdate"+
					  ", ?"+
					  ", sysdate"+
					  ", 'N'"+
					  ", ?"+
					  " from oraddman.tsa01_request_lines_all a"+
					  ",(select organization_id,inventory_item_id,lot_number,max(expiration_date) expiration_date from inv.mtl_lot_numbers where lot_number=? group by organization_id,inventory_item_id,lot_number) b "+
					  " where a.request_no=?"+
					  " and a.line_no=?"+
					  " and a.organization_id=b.organization_id"+
				      " and a.component_item_id=b.inventory_item_id";
				//out.println(sql);
				//out.println(request.getParameter("SUBINVENTORY_"+i));
				//out.println(request.getParameter("PICK_QTY_"+i));
				//out.println(request.getParameter("LOT_"+i));
				//out.println(REQUEST_NO);
				//out.println(LINE_NO);
				pstmtDt=con.prepareStatement(sql);
				pstmtDt.setString(1,request.getParameter("SUBINVENTORY_"+i));
				pstmtDt.setString(2,request.getParameter("LOT_"+i));
				pstmtDt.setString(3,request.getParameter("PICK_QTY_"+i));
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,(request.getParameter("TRANSFER_SUBINV_"+i)==null?"":request.getParameter("TRANSFER_SUBINV_"+i)));
				pstmtDt.setString(7,request.getParameter("LOT_"+i));
				pstmtDt.setString(8,REQUEST_NO);
				pstmtDt.setString(9,LINE_NO);				
				pstmtDt.executeQuery();
				pstmtDt.close();								  
			}	
			
			sql = " update oraddman.tsa01_request_lines_all a"+
			      " set issue_qty=nvl((select sum(lot_qty) from oraddman.tsa01_request_line_lots_all b where b.request_no=a.request_no and b.line_no=a.line_no),0)"+
				  " where request_no=?"+
				  " and line_no=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUEST_NO);
			pstmtDt.setString(2,LINE_NO);
			pstmtDt.executeQuery();
			pstmtDt.close();	
							  
			con.commit();
			%>
			<script language="JavaScript" type="text/JavaScript">
				alert("儲存成功!");
				setSave();
			</script>			
			<%	
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<font color='#ff0000'>"+e.getMessage()+"</font>");
		}			
	}
}
catch(Exception e)
{
	out.println("<font color='#ff0000'>"+e.getMessage()+"</font>");
}	
%>	
	<tr>
		<td  colspan="7"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick='setAddLine("../jsp/TSA01WIPWareHousePickDetail.jsp?ACODE=ADDLINE")' <%=(def_lot?" disabled":"")%>><input type="text" NAME="TXTLINE" value="1" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="3"></td>
	</tr>
</table>
<table width="100%">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TSA01WIPWareHousePickDetail.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;visibility:<%=REQUEST_TYPE.equals("MISC")||REQUEST_TYPE.equals("RDMISC")||REQUEST_TYPE.equals("QCMISC")||def_lot?"hidden":"visible"%>">
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick="setClose()" style="font-family: Tahoma,Georgia;visibility:<%=REQUEST_TYPE.equals("MISC")||REQUEST_TYPE.equals("RDMISC")||REQUEST_TYPE.equals("QCMISC")||def_lot?"hidden":"visible"%>">
		</td>
	</tr>
</table>
<input type="hidden" name="LINECNT" value="<%=LINECNT%>">
<input type="hidden" name="ORIGCNT" value="<%=ORIGCNT%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

