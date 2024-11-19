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
<title>SG Pick Confirm Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		if (confirm("您確定要不存檔離開嗎?")==true)
		{
			window.opener.document.MYFORM.submit();
			window.close();	
		}		
    }  
} 
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
	if (confirm("您確定要刪除Line No:"+objLine+"的資料嗎?"))
	{
		var LOT = document.MYFORMD.elements["LOT_"+objLine].value;
		var SNO = document.MYFORMD.elements["S_CARTON_"+objLine].value;
		var ENO = document.MYFORMD.elements["E_CARTON_"+objLine].value;
		document.MYFORMD.action="../jsp/TSCSGLotDistributionConfirmDetail.jsp?ACODE=DELETELINE&DEL_SNO="+SNO+"&DEL_ENO="+ENO+"&DEL_LOT="+LOT;
		document.MYFORMD.submit();	
	}
	else
	{
		return false;
	}
}
function setSubmit(URL)
{
	var v_scno="",v_ecno="",v_lot="",v_qty="";
	var ID = document.MYFORMD.ID.value;
	var totqty = "";
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		document.MYFORMD.elements["LOT_"+i].style.backgroundColor="#FFFFFF";
		v_scno = document.MYFORMD.elements["S_CARTON_"+i].value;
		v_ecno = document.MYFORMD.elements["E_CARTON_"+i].value;
		v_lot = document.MYFORMD.elements["LOT_"+i].value;
		v_qty =document.MYFORMD.elements["QTY_"+i].value;
		
		if (v_scno !="" || v_ecno !="" || v_lot !="" || v_qty !="")
		{
			if (v_scno =="")
			{
				alert("請輸入起始箱號!!");
				document.MYFORMD.elements["S_CARTON_"+i].focus();
				return false;
			}
			else if (v_ecno =="")
			{
				alert("請輸入結束箱號!!");
				document.MYFORMD.elements["E_CARTON_"+i].focus();
				return false;
			}
			else
			{
				if (eval(v_scno) < eval(document.MYFORMD.SCNO.value) || eval(v_ecno) > eval(document.MYFORMD.ECNO.value))
				{
					alert("箱號錯誤!!");
					if (eval(v_scno) < eval(document.MYFORMD.SCNO.value))
					{
						document.MYFORMD.elements["S_CARTON_"+i].focus();
					}
					else
					{
						document.MYFORMD.elements["E_CARTON_"+i].focus();
					}
					return false;
				}
			}
			
			if (v_lot =="")
			{
				alert("請輸入LOT NUMBER!!");
				document.MYFORMD.elements["LOT_"+i].focus();
				return false;
			}	
			if (isNaN(v_qty))
			{
				document.MYFORMD.elements["QTY_"+i].focus();
				alert("請輸入數字型態!!");
				return false;
			}
			totqty = document.MYFORMD.elements["QTY_"+i].value;
			for (var j =i+1 ; j <= document.MYFORMD.LINECNT.value ; j++)
			{
				totqty =eval(totqty)+eval(document.MYFORMD.elements["QTY_"+j].value);
			}
			if (eval(totqty) > eval(document.MYFORMD.TOTSHIPQTY.value))
			{
				alert("總出貨量不可超過 "+document.MYFORMD.TOTSHIPQTY.value+" K!!");
				return false;
			}
		}		
	}
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.cancel1.disabled=true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}

function setClose()
{
	window.opener.document.MYFORM.submit();
	this.window.close();
}

function setChange()
{
	document.MYFORMD.submit();
}

function setCNOChange(CNO,objname)
{
	if (eval(CNO) < eval(document.MYFORMD.SCNO.value) || eval(CNO)  > eval(document.MYFORMD.ECNO.value))
	{
		alert("箱號錯誤");
		document.MYFORMD.elements[objname].value ="";
		document.MYFORMD.elements[objname].focus();
		return false;
	}
}
</script>
<%
String sql = "",DateCodeList="";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String VID = request.getParameter("VID");  //add by Peggy 20210826
if (VID==null) VID="";
String SO_NO = request.getParameter("SO_NO");
if (SO_NO==null) SO_NO="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String PC_ADVISE_ID= request.getParameter("PC_ADVISE_ID");
if (PC_ADVISE_ID ==null) PC_ADVISE_ID="";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="3";
String ORIGCNT=  request.getParameter("ORIGCNT");
if (ORIGCNT ==null) ORIGCNT="";
String TOTQTY = request.getParameter("TOTQTY");
if (TOTQTY ==null) TOTQTY="";
String DEL_SNO = request.getParameter("DEL_SNO");
if (DEL_SNO==null) DEL_SNO="";
String DEL_ENO = request.getParameter("DEL_ENO");
if (DEL_ENO==null) DEL_ENO="";
String DEL_LOT = request.getParameter("DEL_LOT");
if (DEL_LOT==null) DEL_LOT="";
String DEL_LINE = request.getParameter("DEL_LINE");
if (DEL_LINE==null) DEL_LINE="";
String NOW_CNO = request.getParameter("NOW_CNO");
if (NOW_CNO==null) NOW_CNO="";
String SCNO="",ECNO="",CARTON_CODE="",SHIPQTY="";
boolean Line_Exist = false;
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="1";
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
String SHIPPING_REMARK="",advise_line_id="";

try
{
	sql = " select a.tew_advise_no,a.pc_advise_id,a.so_no,a.so_header_id, a.so_line_id,a.advise_line_id,a.inventory_item_id,a.ITEM_DESC,nvl(a.post_code,b.POST_FIX_CODE) post_fix_code,a.shipping_remark,min(a.CARTON_NUM_FR) CARTON_NUM_FR,max(a.CARTON_NUM_TO) CARTON_NUM_TO,sum(a.TOTAL_QTY) TOTAL_QTY "+
		  " from tsc.tsc_shipping_advise_lines a,tsc.tsc_shipping_advise_headers b"+
		  " where a.tew_advise_no =?"+
		  " and a.SO_LINE_ID=?"+
		  " and a.vendor_site_id=?"+ //add by Peggy 20210826
		  " and a.advise_header_id = b.advise_header_id"+
		  " group by a.tew_advise_no,a.pc_advise_id,a.so_no,a.so_header_id, a.so_line_id,a.advise_line_id,a.inventory_item_id,a.ITEM_DESC,nvl(a.post_code,b.POST_FIX_CODE),a.shipping_remark";
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,ADVISENO);
	statement1.setString(2,ID);
	statement1.setString(3,VID); //add by Peggy 20210826
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{
		Line_Exist=true;
		SCNO=rs1.getString("CARTON_NUM_FR");
		ECNO=rs1.getString("CARTON_NUM_TO");
		CARTON_CODE=rs1.getString("POST_FIX_CODE");
		SHIPQTY=""+(rs1.getFloat("TOTAL_QTY")/1000);
		SO_NO = rs1.getString("SO_NO");
		ITEM_DESC = rs1.getString("ITEM_DESC");
		PC_ADVISE_ID = rs1.getString("PC_ADVISE_ID");
		SHIPPING_REMARK = rs1.getString("SHIPPING_REMARK");
		if (SHIPPING_REMARK==null) SHIPPING_REMARK=""; 
	}
	else
	{
		Line_Exist=false;
	}
	rs1.close();
	statement1.close();	
}
catch(Exception e)
{
	Line_Exist=false;
}

if (!Line_Exist)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查無訂單資料,請重新確認,謝謝!");
		this.window.close();	
	</script>
<%
}  
%>
<body>  
<FORM ACTION="../jsp/TSCSGLotDistributionConfirmDetail.jsp" METHOD="post" NAME="MYFORMD">
<TABLE border="0" width="100%">
	<tr>
		<td width="10%" style="font-size:12px" align="right">Advise No：</td>
		<td width="30%" colspan="3"><input type="text" name="ADVISENO" value="<%=ADVISENO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" readonly><input type="hidden" name="ID" value="<%=ID%>"><input type="hidden" name="VID" value="<%=VID%>"><input type="hidden" name="PC_ADVISE_ID" value="<%=PC_ADVISE_ID%>"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right">MO#：</td>
		<td width="30%" colspan="3"><input type="text" name="SO_NO" value="<%=SO_NO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" readonly></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right">型號：</td>
		<td width="30%" colspan="3"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="30" readonly></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right">起訖箱號：</td>
		<td width="10%">
		<%
		if (!SHIPPING_REMARK.equals("") && ((SHIPPING_REMARK.length()>=12 && SHIPPING_REMARK.substring(0,12).equals("CHANNEL WELL")) || (SHIPPING_REMARK.indexOf("駱騰")>=0)))
		{
			out.println((SCNO.equals(ECNO)?CARTON_CODE+SCNO:CARTON_CODE+SCNO+" - "+CARTON_CODE+ECNO));
		}
		else
		{
			out.println((SCNO.equals(ECNO)?SCNO+CARTON_CODE:SCNO+CARTON_CODE+" - "+ECNO+CARTON_CODE));
		}
		%>
		<input type="hidden" name="SCNO" value="<%=SCNO%>"><input type="hidden" name="ECNO" value="<%=ECNO%>"><input type="hidden" name="CARTON_CODE" value="<%=CARTON_CODE%>"></td>
		<td width="10%" style="font-size:12px" align="right">總出貨量：</td>
		<td width="10%" align="right"><%=(new DecimalFormat("#####.###")).format(Float.parseFloat(SHIPQTY))+" K"%><input type="hidden" name="TOTSHIPQTY" value="<%=SHIPQTY%>"></td>
		<td>&nbsp;</td>
	</tr>
</TABLE>
<hr>
<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="26%" align="center">Lot Number</td>
		<td width="10%" align="center">Date Code</td>
		<td width="10%" align="center">DC YYWW</td>
		<td width="15%" align="center">撿貨數量(K)</td>
		<td width="10%" align="center">起始箱號</td>
		<td width="10%" align="center">結束箱號</td>
		<!--<td width="6%" align="center">&nbsp;</td>-->
	</tr>
<%
if (ACODE.equals("1") || ACODE.equals("DELETELINE") || ACODE.equals("SAVE") || ACODE.equals("ADDLINE"))
{
	try
	{
		if (ACODE.equals("ADDLINE"))
		{	
			for (int i =0 ; i <Integer.parseInt(LINECNT) ; i++)
			{
		%>
				<tr>
					<td align="center"><input type="TEXT" NAME="LOT_<%=(i+1)%>" value="<%=(request.getParameter("LOT_"+(i+1))==null?"":request.getParameter("LOT_"+(i+1)))%>" style="font-family: Tahoma,Georgia;" size="24"></td>
					<td align="center"><input type="TEXT" NAME="DC_<%=(i+1)%>" value="<%=(request.getParameter("DC_"+(i+1))==null?"":request.getParameter("DC_"+(i+1)))%>" style="font-family: Tahoma,Georgia;" size="12"></td>
					<td align="center"><input type="TEXT" NAME="DC_YYWW_<%=(i+1)%>" value="<%=(request.getParameter("DC_YYWW_"+(i+1))==null?"":request.getParameter("DC_YYWW_"+(i+1)))%>" style="font-family: Tahoma,Georgia;" size="12"></td>
					<td align="center"><input type="TEXT" NAME="QTY_<%=(i+1)%>" value="<%=(request.getParameter("QTY_"+(i+1))==null?"":request.getParameter("QTY_"+(i+1)))%>" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="15" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
					<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(i+1)%>" value="<%=(request.getParameter("S_CARTON_"+(i+1))==null?"":request.getParameter("S_CARTON_"+(i+1)))%>" style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.S_CARTON_<%=(i+1)%>.value,"S_CARTON_<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
					<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(i+1)%>" value="<%=(request.getParameter("E_CARTON_"+(i+1))==null?"":request.getParameter("E_CARTON_"+(i+1)))%>" style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.E_CARTON_<%=(i+1)%>.value,"E_CARTON_<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
					<!--<td align="center"><input type="checkbox" name="chk1" value="<%=(i+1)%>" style="visibility:hidden" checked><input type="button" name="DEL<%=(i+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=(i+1)%>)'></td>-->
				</tr>	
		<%		

			}		
		}
		else
		{
			if (ACODE.equals("DELETELINE"))
			{
				sql = " SELECT  count(1) from tsc.tsc_pick_confirm_lines a where a.so_line_id<>"+ID+" and a.CARTON_NO  not between '"+DEL_SNO+"' and '"+DEL_ENO+"' and a.LOT<>'"+DEL_LOT+"' and exists (select 1 from tsc.tsc_pick_confirm_lines b where b.TEW_ADVISE_NO='"+ADVISENO+"' and b.so_line_id="+ID+"  AND b.CARTON_NO between '"+DEL_SNO+"' and '"+DEL_ENO+"' and b.LOT='"+DEL_LOT+"' and b.advise_header_id=a.advise_header_id)";
				//out.println(sql);
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);
				if (rs1.next())
				{
					if (rs1.getInt(1)==0)
					{
						sql = "delete tsc.tsc_pick_confirm_headers a where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.TEW_ADVISE_NO=? and b.so_line_id=? and b.advise_header_id=a.advise_header_id)";
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						//out.println(sql);
						pstmtDt.setString(1,ADVISENO);
						pstmtDt.setString(2,ID);
						pstmtDt.executeUpdate();
						pstmtDt.close();
					}
				}
				rs1.close();
				statement1.close();	
						
				PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where a.SO_LINE_ID=?  AND a.TEW_ADVISE_NO=? AND a.CARTON_NO between ? and ? and a.LOT=?");  
				pstmtDt.setString(1,ID);
				pstmtDt.setString(2,ADVISENO);
				pstmtDt.setString(3,DEL_SNO);
				pstmtDt.setString(4,DEL_ENO);
				pstmtDt.setString(5,DEL_LOT);
				if (pstmtDt.executeUpdate()<=0)
				{
				%>
					<script language="JavaScript" type="text/JavaScript">
						alert("刪除失敗!! 查無相關資料,請重新確認,謝謝!");
					</script>			
				<%
				}
				else
				{
				%>
					<script language="JavaScript" type="text/JavaScript">
						alert("刪除成功!");
					</script>			
				<%			
				}
				pstmtDt.close();
			}
			else if (ACODE.equals("SAVE"))
			{
				try
				{
					PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a  where a.SO_LINE_ID=?  AND a.TEW_ADVISE_NO=? and a.vendor_site_id=?");  
					pstmtDt.setString(1,ID);
					pstmtDt.setString(2,ADVISENO);
					pstmtDt.setString(3,VID); //add by Peggy 20210826
					pstmtDt.executeQuery();
					pstmtDt.close();
	
					long CARTON_PER_QTY = 0,ALLOT_QTY=0,PICK_QTY=0;	
							
					for (int i = 1 ; i <= Integer.parseInt(LINECNT) ;i++)
					{
						if (request.getParameter("LOT_"+i) == null || request.getParameter("LOT_"+i).equals("")) continue;
	
						PICK_QTY = (long)(Float.parseFloat(request.getParameter("QTY_"+i))*1000);
						
						sql = " SELECT MTLN.lot_number,MOQD.TRANSACTION_QUANTITY * CASE WHEN MOQD.TRANSACTION_UOM_CODE='KPC' THEN 1000 ELSE 1 END"+
							  "-TSSG_SHIP_PKG.GET_LOT_DISTRIBUTION_QTY(TSAL.ORGANIZATION_ID,?,TSAL.INVENTORY_ITEM_ID)"+
							  " AS useful_quantity"+
							  " FROM MTL_ONHAND_QUANTITIES_DETAIL MOQD"+
							  ",MTL_TRANSACTION_LOT_NUMBERS MTLN"+
							  ",TSC.TSC_SHIPPING_ADVISE_LINES TSAL"+
							  " WHERE  MOQD.ORGANIZATION_ID=MTLN.ORGANIZATION_ID"+
							  " AND MOQD.INVENTORY_ITEM_ID=MTLN.INVENTORY_ITEM_ID"+
							  " AND MOQD.LOT_NUMBER=MTLN.LOT_NUMBER"+
							  " AND MOQD.SUBINVENTORY_CODE IN (CASE WHEN TSAL.ORGANIZATION_ID=907 THEN '01' ELSE '' END)"+
							  " AND MTLN.LOT_NUMBER=?"+
							  " AND MTLN.INVENTORY_ITEM_ID=TSAL.INVENTORY_ITEM_ID"+
							  " AND MTLN.ORGANIZATION_ID=TSAL.ORGANIZATION_ID"+
							  " AND TSAL.SO_LINE_ID=?"; 						
				  		//out.println(sql);
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,request.getParameter("LOT_"+i));
						statement1.setString(2,request.getParameter("LOT_"+i));
						statement1.setString(3,ID);
						ResultSet rs1=statement1.executeQuery();
						if (rs1.next())
						{
							//可分配量不足
							if (rs1.getFloat("useful_quantity") < Float.parseFloat(request.getParameter("QTY_"+i)))
							{
								throw new Exception("LOT:"+request.getParameter("LOT_"+i)+ " 庫存量("+rs1.getInt("useful_quantity")+"K)不足!");
							}
							
							for (int j = Integer.parseInt(request.getParameter("S_CARTON_"+i)) ; j <= Integer.parseInt(request.getParameter("E_CARTON_"+i)) ; j++)
							{
								sql = " select a.advise_line_id,a.advise_header_id,a.tew_advise_no,a.CARTON_PER_QTY "+
								          " from tsc.tsc_shipping_advise_lines a"+
										  " where a.pc_advise_id=?"+
										  " and a.so_line_id=?"+
										  " and a.tew_advise_no=?"+
										  " and a.vendor_site_id=?"+ //add by Peggy 20210826
										  " and ? between a.CARTON_NUM_FR and a.CARTON_NUM_TO";
								//out.println(sql);
								PreparedStatement statement3=con.prepareStatement(sql);
								statement3.setString(1,PC_ADVISE_ID);
								statement3.setString(2,ID);
								statement3.setString(3,ADVISENO);
								statement3.setString(4,VID); //add by Peggy 20210826
								statement3.setString(5,""+j);
								ResultSet rs3=statement3.executeQuery();
								if (rs3.next())
								{
									if ( PICK_QTY  >= rs3.getLong("CARTON_PER_QTY"))
									{
										CARTON_PER_QTY = rs3.getLong("CARTON_PER_QTY");
									}
									else
									{
										CARTON_PER_QTY =  PICK_QTY;
									}
									PICK_QTY -= CARTON_PER_QTY;
									
									sql = " insert into tsc.tsc_pick_confirm_lines"+
										  " (advise_header_id"+
										  ", advise_line_id"+
										  ", oqc_status"+
										  ", carton_no"+
										  ", carton_qty"+
										  ", so_no"+
										  ", so_header_id"+
										  ", so_line_id"+
										  ", organization_id"+
										  ", inventory_item_id"+
										  ", item_no"+
										  ", lot"+
										  ", subinventory"+
										  ", qty"+
										  ", date_code"+
										  ", manufacture_date"+
										  ", effective_date"+
										  ", last_update_date"+
										  ", last_updated_by"+
										  ", creation_date"+
										  ", created_by"+
										  ", product_group"+
										  ", onhand_org_id"+
										  ", PO_LINE_LOCATION_ID"+ 
										  ", TEW_ADVISE_NO"+
										  ", DC_YYWW"+ //add by Peggy 20220721
										  ")"+ 
										  " select b.advise_header_id"+
										  ",b.advise_line_id"+
										  ",'C'"+
										  ",?"+
										  ",'1'"+
										  ",b.so_no"+
										  ",b.so_header_id"+
										  ",b.so_line_id"+
										  ",b.organization_id"+
										  ",b.inventory_item_id"+
										  ",b.item_no"+
										  ",?"+
										  ",'01' "+
										  ",?"+
										  ",c.date_code"+
										  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(c.date_code,b.item_no)) where D_TYPE=?) MANUFACTURE_DATE"+
										  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(c.date_code,b.item_no)) where D_TYPE=?) EFFECTIVE_DATE"+
										  ",sysdate"+
										  ",(select erp_user_id from oraddman.wsuser where username=?)"+
										  ",sysdate"+
										  ",(select erp_user_id from oraddman.wsuser where username=?)"+
										  ",b.PRODUCT_GROUP"+
										  ",b.ORGANIZATION_ID"+
										  ",null"+
										  ",?"+
										  ",c.attribute8"+
										  " from tsc.tsc_shipping_advise_lines b,tsc.tsc_shipping_advise_headers a,mtl_transaction_lot_numbers c"+ 
										  " where b.tew_advise_no=?"+
										  " and b.advise_header_id=a.advise_header_id"+ 
										  " and b.inventory_item_id=c.inventory_item_id"+
										  " and b.organization_id=c.organization_id"+
										  " and c.lot_number=?"+
										  " and b.SO_LINE_ID=?";
									//out.println(sql);
									pstmtDt=con.prepareStatement(sql);  
									pstmtDt.setString(1,""+j);
									pstmtDt.setString(2,request.getParameter("LOT_"+i));
									pstmtDt.setString(3,""+CARTON_PER_QTY);
									pstmtDt.setString(4,"MAKE");
									pstmtDt.setString(5,"VALID");
									pstmtDt.setString(6,UserName);
									pstmtDt.setString(7,UserName);
									pstmtDt.setString(8,ADVISENO);
									pstmtDt.setString(9,ADVISENO);
									pstmtDt.setString(10,request.getParameter("LOT_"+i));
									pstmtDt.setString(11,ID);
									pstmtDt.executeQuery();
									pstmtDt.close();
								}
								rs3.close();
								statement3.close();
							}
						}
						else
						{
							throw new Exception("LOT:"+request.getParameter("LOT_"+i)+ " 無庫存可分配!");
						}
						rs1.close();
						statement1.close();	
					}
					
					//批號分配數量檢查
					String strErr="";
					sql = " select z.* from (select y.* ,nvl((select sum(qty/1000) from tsc.tsc_pick_confirm_lines b where b.advise_line_id=y.advise_line_id and b.carton_no=y.carton_num ),0) allot_qty"+
						  " from (select x.advise_line_id,case when x.carton_qty =1 then x.carton_num_fr else x.carton_num_fr+rownum-1 end as carton_num,x.carton_per_qty"+
						  "       from (select a.advise_line_id,a.carton_num_fr,a.carton_num_to,a.carton_per_qty,a.CARTON_QTY"+
						  "             from tsc.tsc_shipping_advise_lines a"+
						  "             where a.tew_advise_no =?"+
						  "             and a.vendor_site_id=?"+ //add by Peggy 20210826
						  "             and a.so_line_id=?) x "+
						  "       connect by rownum <=(x.carton_num_to-x.carton_num_fr)+1) y ) z where z.CARTON_PER_QTY<z.ALLOT_QTY";
					PreparedStatement statement6 = con.prepareStatement(sql);
					statement6.setString(1,ADVISENO);
					statement6.setString(2,VID);
					statement6.setString(3,ID);
					ResultSet rs6=statement6.executeQuery();
					while (rs6.next())
					{
						strErr+="第"+rs6.getString("carton_num")+"箱出貨量("+ rs6.getFloat("allot_qty")/1000+"K)超過預定出貨量("+rs6.getFloat("carton_per_qty")/1000+"K)<br>";
					}
					rs6.close();
					statement6.close();
					
					if (!strErr.equals(""))
					{
						throw new Exception(strErr);
					}
					
					con.commit();
					%>
						<script language="JavaScript" type="text/JavaScript">
							alert("修改成功!");
							setClose();
						</script>			
					<%				
				}
				catch(Exception e)
				{
					con.rollback();
					out.println("<font color='red'>更新失敗!!"+e.getMessage()+"</font>");
				}
			}
			
			sql = " SELECT a.advise_line_id,a.LOT LOT_NUMBER,a.CARTON_NO CARTON_NUM,sum(a.QTY)/1000 ALLOT_QTY,a.DATE_CODE,a.DC_YYWW"+
				  " FROM tsc.tsc_pick_confirm_lines a,tsc.tsc_shipping_advise_lines b"+
				  " WHERE  b.SO_LINE_ID=? "+
				  " AND b.TEW_ADVISE_NO=? "+
				  " AND b.vendor_site_id=? "+ //add by Peggy 20210826
				  " AND a.advise_line_id = b.advise_line_id"+
				  " AND a.tew_advise_no = b.tew_advise_no"+
				  " group by a.advise_line_id,a.LOT,a.CARTON_NO,a.DATE_CODE ,a.DC_YYWW"+
				  " order by min(a.CARTON_NO),a.LOT,a.DATE_CODE";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ID);
			statement.setString(2,ADVISENO);
			statement.setString(3,VID); //add by Peggy 20210826
			ResultSet rs=statement.executeQuery();
			String lotNumber="",sCartonNum="",eCartonNum="",datecode="",dc_yyww="";
			float allotQty=0;
			int rowcnt=0;
			while (rs.next())
			{
				if (rowcnt==0)
				{
					advise_line_id=rs.getString("advise_line_Id");
					lotNumber=rs.getString("LOT_NUMBER");
					datecode=rs.getString("DATE_CODE");
					if (datecode==null) datecode="";
					dc_yyww=rs.getString("DC_YYWW");
					if (dc_yyww==null) dc_yyww="";
					allotQty=rs.getFloat("ALLOT_QTY");
					sCartonNum=rs.getString("CARTON_NUM");
					eCartonNum=rs.getString("CARTON_NUM");
				}
				if (!advise_line_id.equals(rs.getString("advise_line_id")) || !lotNumber.equals(rs.getString("LOT_NUMBER")) || !datecode.equals((rs.getString("DATE_CODE")==null?"":rs.getString("DATE_CODE"))) || (!sCartonNum.equals(eCartonNum) && !eCartonNum.equals(""+(rs.getInt("CARTON_NUM")-1))))
				{
		%>
			<tr>
				<td align="center"><input type="TEXT" NAME="LOT_<%=(icnt+1)%>" value="<%=lotNumber%>"  style="font-family: Tahoma,Georgia;" size="25"></td>
				<td align="center"><input type="TEXT" NAME="DC_<%=(icnt+1)%>" value="<%=datecode%>"  style="font-family: Tahoma,Georgia;" size="12"></td>
				<td align="center"><input type="TEXT" NAME="DC_YYWW_<%=(icnt+1)%>" value="<%=dc_yyww%>"  style="font-family: Tahoma,Georgia;" size="12"></td>
				<td align="center"><input type="TEXT" NAME="QTY_<%=(icnt+1)%>" value="<%=(new DecimalFormat("######.###")).format(allotQty)%>"   style="font-family: Tahoma,Georgia;text-align:RIGHT" size="15"  onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
				<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(icnt+1)%>" value="<%=sCartonNum%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.S_CARTON_<%=(icnt+1)%>.value,"S_CARTON_<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(icnt+1)%>" value="<%=eCartonNum%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.E_CARTON_<%=(icnt+1)%>.value,"E_CARTON_<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<!--<td align="center"><input type="checkbox" name="chk1" value="<%=(icnt+1)%>" style="visibility:hidden" checked><input type="button" name="DEL<%=(icnt+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=(icnt+1)%>)'></td>-->
			</tr>	
		<%
					advise_line_id=rs.getString("advise_line_Id");
					lotNumber=rs.getString("LOT_NUMBER");
					datecode=rs.getString("DATE_CODE");
					dc_yyww=rs.getString("DC_YYWW");
					allotQty=rs.getFloat("ALLOT_QTY");
					sCartonNum=rs.getString("CARTON_NUM");
					eCartonNum=rs.getString("CARTON_NUM");		
					icnt++;
				}
				else if (rowcnt!=0)
				{
					allotQty+=rs.getFloat("ALLOT_QTY");
					eCartonNum=rs.getString("CARTON_NUM");
				}
				rowcnt++;
			}
			rs.close();
			statement.close();
		
			if (rowcnt>0)
			{
		%>
			<tr>
				<td align="center"><input type="TEXT" NAME="LOT_<%=(icnt+1)%>" value="<%=lotNumber%>"  style="font-family: Tahoma,Georgia;" size="25"></td>
				<td align="center"><input type="TEXT" NAME="DC_<%=(icnt+1)%>" value="<%=datecode%>"  style="font-family: Tahoma,Georgia;" size="12"></td>
				<td align="center"><input type="TEXT" NAME="DC_YYWW_<%=(icnt+1)%>" value="<%=dc_yyww%>"  style="font-family: Tahoma,Georgia;" size="12"></td>
				<td align="center"><input type="TEXT" NAME="QTY_<%=(icnt+1)%>" value="<%=(new DecimalFormat("######.###")).format(allotQty)%>"   style="font-family: Tahoma,Georgia;text-align:RIGHT" size="15"  onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
				<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(icnt+1)%>" value="<%=sCartonNum%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.S_CARTON_<%=(icnt+1)%>.value,"S_CARTON_<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(icnt+1)%>" value="<%=eCartonNum%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.E_CARTON_<%=(icnt+1)%>.value,"E_CARTON_<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<!--<td align="center"><input type="checkbox" name="chk1" value="<%=(icnt+1)%>" style="visibility:hidden" checked><input type="button" name="DEL<%=(icnt+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=(icnt+1)%>)'></td>-->
			</tr>	
		<%		
				icnt++;
			}
			else
			{
				for (int i =0 ; i <=2 ; i++)
				{
			%>
					<tr>
						<td align="center"><input type="TEXT" NAME="LOT_<%=(i+1)%>" value=""  style="font-family: Tahoma,Georgia;" size="25"></td>
						<td align="center"><input type="TEXT" NAME="DC_<%=(i+1)%>" value=""  style="font-family: Tahoma,Georgia;" size="12"></td>
						<td align="center"><input type="TEXT" NAME="DC_YYWW_<%=(i+1)%>" value=""  style="font-family: Tahoma,Georgia;" size="12"></td>
						<td align="center"><input type="TEXT" NAME="QTY_<%=(i+1)%>" value=""   style="font-family: Tahoma,Georgia;text-align:RIGHT" size="15" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
						<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(i+1)%>" value=""  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.S_CARTON_<%=(i+1)%>.value,"S_CARTON_<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
						<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(i+1)%>" value=""  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange(this.form.E_CARTON_<%=(i+1)%>.value,"E_CARTON_<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
						<!--<td align="center"><input type="checkbox" name="chk1" value="<%=(i+1)%>" style="visibility:hidden" checked><input type="button" name="DEL<%=(i+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=(i+1)%>)'></td>-->
					</tr>	
			<%		
					icnt++;
				}
			}		
			LINECNT = ""+icnt;
		}
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
}
%>	
	<!--<tr>-->
		<!--<td  colspan="6" style="border-left-style:none;border-right-style:none;"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick='setAddLine("../jsp/TSCSGLotDistributionConfirmDetail.jsp?ACODE=ADDLINE")'><input type="text" NAME="TXTLINE" value="1" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="5"></td>-->
	<!--</tr>-->
</table>
<table width="100%">
	<tr>
		<td align="center">
			<!--<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TSCSGLotDistributionConfirmDetail.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">-->
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick='setClose()' style="font-family: Tahoma,Georgia;">
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

