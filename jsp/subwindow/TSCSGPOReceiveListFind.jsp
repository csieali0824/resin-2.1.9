<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<%
String sql = "";
String SEARCHSTR = request.getParameter("SEARCHSTR");
if (SEARCHSTR==null) SEARCHSTR="";
String ID  =request.getParameter("ID");
if (ID==null) ID="";
String SHIPORGID= request.getParameter("SHIPORGID");
if (SHIPORGID==null) SHIPORGID="";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID==null || ITEMID.equals("--")) ITEMID="0";
String CUST_PARTNO = request.getParameter("CUST_PARTNO");
if (CUST_PARTNO==null || CUST_PARTNO.equals("")) CUST_PARTNO="N/A";
String SHIP_QTY = request.getParameter("SHIP_QTY");
if (SHIP_QTY==null) SHIP_QTY="";
String ALLOT_SHIP_QTY="";
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
String IDLIST = request.getParameter("IDLIST");
if (IDLIST==null) IDLIST="";
String PID=request.getParameter("PID"); //add by Peggy 20230515
if (PID==null) PID="";
%>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEW PO List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
//window.onbeforeunload = bunload; 
//function bunload()  
//{  
//	if (event.clientY < 0)  
//   {  
//		//window.opener.document.getElementById("alpha").style.width="0%";
//		//window.opener.document.getElementById("alpha").style.height="0px";
//		window.close();				
//   }  
//}  
function setClick(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.SUBFORM.chkbox.length != undefined)
	{
		chkflag = document.SUBFORM.chkbox[irow-1].checked; 
		lineid = document.SUBFORM.chkbox[irow-1].value;
	}
	else
	{
		chkflag = document.SUBFORM.chkbox.checked; 
		lineid = document.SUBFORM.chkbox.value;
	}
	if (chkflag == true)
	{
		if ((parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value)+parseFloat(document.SUBFORM.elements["UNRECEIVE_QTY_"+lineid].value))>= parseFloat(document.SUBFORM.SHIP_QTY.value))
		{
			document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = document.SUBFORM.SHIP_QTY.value;
		}
		else
		{
			document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = ""+(parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value)+parseFloat(document.SUBFORM.elements["UNRECEIVE_QTY_"+lineid].value));
		}
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].disabled = false;
	}
	else
	{
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = "";
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].disabled = true;
	}
}
function setSubmit1()
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var line="";
	var tot_allot_qty =0;
	var vendor_id ="";
	var chkline="";
	if (document.SUBFORM.chkbox.length != undefined)
	{
		iLen = document.SUBFORM.chkbox.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.SUBFORM.chkbox.checked;
			line = document.SUBFORM.chkbox.value;
		}
		else
		{
			chkvalue = document.SUBFORM.chkbox[i-1].checked;
			line = document.SUBFORM.chkbox[i-1].value;
		}
		if (chkvalue==true)
		{
			chkline = line;
			if (document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value==null || document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value=="" || isNaN(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value))
			{
				alert("請輸入數字型態!!");
				document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].focus();
				return false;
			}
			if (vendor_id !="" && vendor_id != document.SUBFORM.elements["VENDOR_SITE_ID_"+line].value)
			{
				alert("必須是同一個供應商!");
				return false;
			}
			if (parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value) > (parseFloat(document.SUBFORM.elements["ONHAND_"+line].value)+parseFloat(document.SUBFORM.elements["UNRECEIVE_QTY_"+line].value)))
			{
				alert("出貨量("+parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value)+")不可超過採購未收+可用庫存量("+(parseFloat(document.SUBFORM.elements["ONHAND_"+line].value)+parseFloat(document.SUBFORM.elements["UNRECEIVE_QTY_"+line].value))+")");
				return false;
			}
			
			tot_allot_qty = parseFloat(tot_allot_qty) + parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value);
			vendor_id = document.SUBFORM.elements["VENDOR_SITE_ID_"+line].value;
			chkcnt++;
		}
	}
	if (chkcnt>0)
	{
		if (tot_allot_qty != parseFloat(document.SUBFORM.SHIP_QTY.value))
		{
			alert("出貨分配量必須等於排定出貨量!!");
			return false;
		}
	}
	document.SUBFORM.submit1.disabled= true;
	//window.opener.document.MYFORM.elements["VENDOR_NAME_"+document.SUBFORM.ID.value].value = document.SUBFORM.elements["VENDOR_SITE_CODE_"+chkline].value;
	window.opener.document.MYFORM.elements["VENDOR_SITE_ID_"+document.SUBFORM.ID.value].value = document.SUBFORM.elements["VENDOR_SITE_ID_"+chkline].value;
	if (chkcnt>0)
	{
		window.opener.document.MYFORM.elements["ASSIGN_PO_"+document.SUBFORM.ID.value].value="Y";
	}
	else
	{
		window.opener.document.MYFORM.elements["ASSIGN_PO_"+document.SUBFORM.ID.value].value="N";
	}
	//window.opener.document.MYFORM.elements["BOX_CODE_"+document.SUBFORM.ID.value].value = document.SUBFORM.elements["BOX_CODE_"+chkline].value;
	//window.opener.document.MYFORM.elements["ACT_ALLOT_QTY_"+document.SUBFORM.ID.value].value = tot_allot_qty;
	document.SUBFORM.action="TSCSGPOReceiveListFind.jsp?ACODE=SAVE";
	document.SUBFORM.submit();	
}
function setClose()
{
	//window.opener.document.getElementById("alpha").style.width="0%";
	//window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSCSGPOReceiveListFind.jsp" NAME="SUBFORM">
<INPUT TYPE="hidden" name="ITEMID" value="<%=ITEMID%>">
<INPUT TYPE="hidden" name="ID" value="<%=ID%>">
<INPUT TYPE="hidden" name="IDLIST" value="<%=IDLIST%>">
<%
if (!ACODE.equals("SAVE"))
{
%>
<table width="100%">
	<tr>
		<td>
			<%     
				try
				{ 
					/*sql = " SELECT * FROM (SELECT x.ITEM_DESC"+
					      "               ,x.PO_HEADER_ID"+
						  "               ,x.PO_NO"+
						  "               ,x.vendor_site_code"+
						  "               ,x.VENDOR_SITE_ID"+
						  "               ,NVL(x.cust_partno,'N/A') cust_partno"+
						  "               ,x.unit_price"+
						  "               ,x.box_code"+
						  "               ,x.CURRENCY_CODE"+
						  "               ,MIN(need_by_date) NEED_BY_DATE"+
                          "               ,sum(x.UNRECEIVE_QUANTITY) UNRECEIVE_QUANTITY"+
                          "               ,tssg_ship_pkg.GET_PO_ALLOT_QTY( x.PO_NO,x.item_id,NVL(x.cust_partno,'N/A'),0) allot_qty"+
                          "               ,sum(nvl(x.on_hand_qty,0))  on_hand_qty"+
                          "                FROM (SELECT a.PO_HEADER_ID"+
                          "                      ,b.PO_LINE_ID"+
                          "                      ,g.vendor_site_code"+
                          "                      ,A.SEGMENT1 PO_NO"+
                          "                      ,C.LINE_LOCATION_ID"+
                          "                      ,to_char(c.need_by_date,'yyyy-mm-dd') need_by_date"+
                          "                      ,E.SEGMENT1 ITEM_NAME"+
                          "                      ,E.DESCRIPTION ITEM_DESC"+
                          "                      ,c.PRICE_OVERRIDE unit_price"+
                          "                      ,A.CURRENCY_CODE"+
                          "                      ,DECODE( C.UNIT_MEAS_LOOKUP_CODE,'KPC',(C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0))*1000,C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)) QUANTITY"+
                          "                      ,DECODE( C.UNIT_MEAS_LOOKUP_CODE,'KPC',(C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0))*1000,C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)) UNRECEIVE_QUANTITY"+
                          "                      ,C.note_to_receiver"+
                          "                      ,C.SHIP_TO_ORGANIZATION_ID"+
                          "                      ,E.INVENTORY_ITEM_ID ITEM_ID"+
                          "                      ,a.VENDOR_SITE_ID"+
                          "                      ,nvl(odr.cust_partno,b.note_to_vendor) cust_partno"+
                          //"                      ,nvl(asp.attribute5,'') BOX_CODE"+
						  "                      ,'A' BOX_CODE"+
                          "                      ,rsh.receipt_num"+
                          "                      ,mtln.lot_number"+
                          //"                      ,mtln.date_code"+
                          "                      ,case when e.primary_unit_of_measure='KPC' then 1000 else 1 end * moq.transaction_quantity on_hand_qty"+
                          "                       FROM PO.PO_HEADERS_ALL A,"+
                          "                       PO.PO_LINES_ALL B,"+
                          "                       PO.PO_LINE_LOCATIONS_ALL C,"+
                          "                       AP.AP_SUPPLIER_SITES_ALL G,"+
                          "                       INV.MTL_SYSTEM_ITEMS_B E,"+
                          "                       ap.ap_suppliers asp,"+
                          "                       (SELECT *  FROM (SELECT a.order_number,b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b WHERE a.header_id = b.header_id) WHERE seqno = 1) odr,"+
                          "                       rcv_shipment_headers rsh,"+
                          "                       rcv_shipment_lines rsl,"+
                          "                       rcv_transactions rv,"+
                          "                       mtl_material_transactions mmt,"+
                          "                       (select distinct transaction_id,organization_id,inventory_item_id,lot_number from  mtl_transaction_lot_numbers)  mtln,"+
                          "                       (select create_transaction_id,inventory_item_id,organization_id,subinventory_code,lot_number,sum(transaction_quantity) transaction_quantity FROM mtl_onhand_quantities  group by create_transaction_id,inventory_item_id,organization_id,subinventory_code,lot_number) moq"+
                          "                       WHERE A.ORG_ID =?"+
                          "                       AND A.TYPE_LOOKUP_CODE='STANDARD'"+
                          "                       AND A.ORG_ID=B.ORG_ID"+
                          "                       AND B.ORG_ID=C.ORG_ID"+
                          "                       AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
                          "                       AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
                          "                       AND B.PO_LINE_ID = C.PO_LINE_ID"+
                          "                       AND (NVL(A.approved_flag, 'N') in ('R','Y') or a.AUTHORIZATION_STATUS='IN PROCESS')"+
                          "                       AND NVL(A.cancel_flag,'N') = 'N'"+
                          //"                     AND NVL(A.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
                          "                       AND NVL(B.cancel_flag,'N') = 'N'"+
                          //"                     AND NVL(B.closed_code,'OPEN') <> 'CLOSED'"+
                          "                       AND NVL(B.closed_flag,'N') <> 'Y'"+
                          "                       AND NVL(C.cancel_flag,'N') <> 'Y'"+
                          //"                     AND NVL(C.CLOSED_CODE,'OPEN') NOT LIKE  '%CLOSED%'"+
                          //"                       AND C.quantity - NVL (C.quantity_received, 0) > 0"+
                          "                       AND C.ship_to_organization_id=?"+
                          "                       AND A.vendor_site_id = g.vendor_site_id"+
                          "                       AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
                          "                       AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID"+
                          "                       AND b.item_id=?"+
                          "                       AND a.VENDOR_ID=asp.VENDOR_ID"+
                          "                       AND c.line_location_id=rsl.po_line_location_id(+)"+
                          "                       AND rsl.shipment_header_id=rsh.shipment_header_id(+)"+
                          "                       AND rsl.shipment_line_id=rv.shipment_line_id(+)"+
						  "                       AND rv.TRANSACTION_TYPE='DELIVER'"+
                          "                       AND rv.transaction_id=mmt.rcv_transaction_id(+)"+
                          "                       AND mmt.transaction_id=mtln.transaction_id(+) "+     
                          "                       and mtln.organization_id=moq.organization_id(+)"+
                          "                       and mtln.inventory_item_id=moq.inventory_item_id(+)"+
                          "                       and mtln.lot_number=moq.lot_number(+)   "+  
						  "                       and mtln.transaction_id=moq.create_transaction_id(+) "+                
                          "                       AND SUBSTR (c.note_to_receiver,1, INSTR (c.note_to_receiver, '.') - 1) = odr.order_number(+)"+
                          "                       AND SUBSTR (c.note_to_receiver,INSTR (c.note_to_receiver, '.') + 1,LENGTH (c.note_to_receiver)) = odr.line_number(+)"+
                          //"                     AND C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)  >0"+
                          "                      ) x"+
                          " group by x.ITEM_DESC,x.PO_HEADER_ID,x.PO_NO,x.vendor_site_code,x.VENDOR_SITE_ID,x.cust_partno,x.box_code,x.unit_price,x.CURRENCY_CODE,x.item_id"+
                          " having sum(x.UNRECEIVE_QUANTITY)>0 or  sum(nvl(x.on_hand_qty,0)) >0) k "+
                          " ORDER BY k.vendor_site_code,(on_hand_qty- allot_qty) desc,k.PO_NO ";*/
					sql = " SELECT * FROM (SELECT x.ITEM_DESC"+
                          "               ,x.PO_HEADER_ID"+
                          "               ,x.PO_NO"+
                          "               ,x.vendor_site_code"+
                          "               ,x.VENDOR_SITE_ID"+
                          "               ,NVL(x.cust_partno,'N/A') cust_partno"+
                          "               ,x.unit_price"+
                          "               ,x.box_code"+
                          "               ,x.CURRENCY_CODE"+
                          "               ,MIN(need_by_date) NEED_BY_DATE"+
                          "               ,sum(x.UNRECEIVE_QUANTITY) UNRECEIVE_QUANTITY"+
                          "               ,tssg_ship_pkg.GET_PO_ALLOT_QTY( x.PO_NO,x.item_id,NVL(x.cust_partno,'N/A'),0) allot_qty"+
						  "               ,sum(nvl(x.pick_qty,0)) PICK_QTY"+
                          "               ,sum(nvl(x.on_hand_qty,0))  on_hand_qty"+
                          "               FROM (SELECT a.PO_HEADER_ID"+
                          "                     ,b.PO_LINE_ID"+
                          "                      ,g.vendor_site_code"+
                          "                      ,A.SEGMENT1 PO_NO"+
                          "                      ,C.LINE_LOCATION_ID"+
                          "                      ,to_char(c.need_by_date,'yyyy-mm-dd') need_by_date"+
                          "                      ,E.SEGMENT1 ITEM_NAME"+
                          "                      ,E.DESCRIPTION ITEM_DESC"+
                          "                      ,c.PRICE_OVERRIDE unit_price"+
                          "                      ,A.CURRENCY_CODE"+
                          "                      ,DECODE( C.UNIT_MEAS_LOOKUP_CODE,'KPC',(C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0))*1000,C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)) QUANTITY"+
                          "                      ,DECODE( C.UNIT_MEAS_LOOKUP_CODE,'KPC',(C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0))*1000,C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)) UNRECEIVE_QUANTITY"+
                          "                      ,C.note_to_receiver"+
                          "                      ,C.SHIP_TO_ORGANIZATION_ID"+
                          "                      ,E.INVENTORY_ITEM_ID ITEM_ID"+
                          "                      ,a.VENDOR_SITE_ID"+
                          //"                      ,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(B.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN B.NOTE_TO_VENDOR ELSE SUBSTR(B.NOTE_TO_VENDOR,1,INSTR(B.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
                          "                      ,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(B.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
                          "                      ,CASE WHEN C.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
                          "                       FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
                          "                       WHERE x.org_id= CASE WHEN SUBSTR(C.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
                          "                       AND x.header_id=y.header_id"+
                          "                       AND y.packing_instructions='T'"+
                          "                       AND x.order_number= SUBSTR(C.NOTE_TO_RECEIVER,1,INSTR(C.NOTE_TO_RECEIVER,'.')-1)"+
                          "                       AND y.shipment_number=1 and y.line_number=SUBSTR(C.NOTE_TO_RECEIVER,INSTR(C.NOTE_TO_RECEIVER,'.')+1))"+
                          "                       ELSE '' END) cust_partno"+
                          "                      ,'A' BOX_CODE"+
                          "                      ,nvl((select sum(nvl(RECEIVED_QTY,0)+nvl(ALLOCATE_IN_QTY,0)-nvl(ALLOCATE_OUT_QTY,0)-nvl(RETURN_QTY,0)-nvl(SHIPPED_QTY,0))  from oraddman.tssg_stock_overview tso"+
                          "                           where tso.po_line_location_id=c.line_location_id),0) on_hand_qty"+
						  "                      ,nvl((SELECT SUM(QTY) PICK_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL,oraddman.tssg_stock_overview TSO"+
                          "                           WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=TSO.SG_STOCK_ID(+)"+
                          "                           AND TSO.PO_LINE_LOCATION_ID=c.line_location_id AND TPCH.PICK_CONFIRM_DATE IS NULL),0) pick_qty"+  //add by Peggy 20200616
                          "                       FROM PO.PO_HEADERS_ALL A,"+
                          "                       PO.PO_LINES_ALL B,"+
                          "                       PO.PO_LINE_LOCATIONS_ALL C,"+
                          "                       AP.AP_SUPPLIER_SITES_ALL G,"+
                          "                       INV.MTL_SYSTEM_ITEMS_B E,"+
                          "                       ap.ap_suppliers asp"+
                          "                       WHERE A.ORG_ID =?"+
                          "                       AND A.TYPE_LOOKUP_CODE='STANDARD'"+
                          "                       AND A.ORG_ID=B.ORG_ID"+
                          "                       AND B.ORG_ID=C.ORG_ID"+
                          "                       AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
                          "                       AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
                          "                       AND B.PO_LINE_ID = C.PO_LINE_ID"+
                          "                       AND (NVL(A.approved_flag, 'N') in ('R','Y') or a.AUTHORIZATION_STATUS='IN PROCESS')"+
                          "                       AND NVL(A.cancel_flag,'N') = 'N'"+
                          "                       AND NVL(B.cancel_flag,'N') = 'N'"+
                          "                       AND NVL(B.closed_flag,'N') <> 'Y'"+
                          "                       AND NVL(C.cancel_flag,'N') <> 'Y'"+
                          "                       AND C.ship_to_organization_id=?"+
                          "                       AND A.vendor_site_id = g.vendor_site_id"+
                          "                       AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
                          "                       AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID"+
                          "                       AND b.item_id=?"+
                          "                       AND a.VENDOR_ID=asp.VENDOR_ID";
					if (!PID.equals("0"))
					{
						sql += " AND exists (select 1 from oraddman.tssg_custpo_link_tspo x where x.group_id=? and x.tsc_pono=a.segment1)";
					}
					else
					{
						sql += " AND not exists (select 1 from oraddman.tssg_custpo_link_tspo x where x.item_desc=E.DESCRIPTION and x.tsc_pono=A.SEGMENT1)";
					}
                    sql  +="  ) x"+
                          " group by x.ITEM_DESC,x.PO_HEADER_ID,x.PO_NO,x.vendor_site_code,x.VENDOR_SITE_ID,x.cust_partno,x.box_code,x.unit_price,x.CURRENCY_CODE,x.item_id"+
                          " having sum(x.UNRECEIVE_QUANTITY)>0 or  sum(nvl(x.on_hand_qty,0)) >0) k "+
                          " ORDER BY k.vendor_site_code,k.PO_NO,(on_hand_qty- allot_qty) desc,k.PO_NO ";
					//out.println(sql);
					//out.println(ITEMID);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"906");
					statement.setString(2,SHIPORGID);
					statement.setString(3,ITEMID);
					if (!PID.equals("0"))
					{
						statement.setString(4,PID);
					}					
					ResultSet rs=statement.executeQuery();
					int vline=0;
					long useful_qty = 0;
					long tot_allot_qty =0;
					String V_FLAG="";
					while (rs.next())
					{
						vline++;
						if (vline==1)
						{
							out.println("<div id='div1' style='font-size:12px'>品    名："+rs.getString("item_desc")+"</div>");
							out.println("<font style='color:#000000;font-family:Tahoma,Georgia; font-size: 11px'>排定出貨量："+SHIP_QTY+" /PCE</font><input type='hidden' name='SHIP_QTY' value='"+SHIP_QTY+"'>");
							out.println("<TABLE border='1' width='100%' cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>");      
							out.println("<TR bgcolor='#cccccc' align='center'>");
							out.println("<Td width='3%'>&nbsp;</Td>");        
							out.println("<Td width='8%'>供應商</Td>");
							out.println("<Td width='9%'>採購單號</Td>");
							out.println("<Td width='5%'>單價</Td>");
							out.println("<Td width='4%'>幣別</Td>");
							out.println("<Td width='8%'>需求日期</Td>");
							out.println("<Td width='11%'>客戶品號</Td>");
							out.println("<Td width='8%'>採購未交量</Td>");
							//out.println("<Td width='10%'>已收未出數量</Td>");
							out.println("<Td width='8%'>已分配量</Td>");
							out.println("<Td width='8%'>已撿貨量</Td>"); //add by Peggy 20200616
							out.println("<Td width='9%'>可用庫存量</Td>");
							out.println("<Td width='11%'>此次分配出貨量</Td>");
							out.println("</TR>");
						}
						ALLOT_SHIP_QTY ="";V_FLAG="N";
						tot_allot_qty =rs.getLong("ALLOT_QTY"); 
						String AllotArray[][]=MOShipBean.getArray2DContent();
						if (AllotArray!=null)
						{
							for( int i=0 ; i<AllotArray.length ; i++ ) 
							{
								if (IDLIST.indexOf(","+AllotArray[i][0]+",") <0 )
								{
									AllotArray[i][0] ="-1";
									AllotArray[i][8] ="0";
								 	continue;
								}
								//out.println(AllotArray[i][9]+ "  "+ITEMID +"****"+ AllotArray[i][1]+"  "+rs.getString("PO_HEADER_ID")+"****"+ AllotArray[i][2]+"  "+rs.getString("vendor_site_id")+"****"+ AllotArray[i][3]+"  "+rs.getString("po_no")+"****"+ AllotArray[i][4]+"  "+rs.getString("unit_price")+"****"+ AllotArray[i][5]+"  "+rs.getString("BOX_CODE")+"****"+ AllotArray[i][6]+"  "+rs.getString("need_by_date")+ "****"+AllotArray[i][7]+"  "+(rs.getString("CUST_PARTNO")==null?"N/A":rs.getString("CUST_PARTNO")));
								if (AllotArray[i][9].equals(ITEMID) && AllotArray[i][1].equals(rs.getString("PO_HEADER_ID")) && AllotArray[i][2].equals(rs.getString("vendor_site_id")) && AllotArray[i][3].equals(rs.getString("po_no")) && AllotArray[i][4].equals(rs.getString("unit_price"))  && AllotArray[i][5].equals(rs.getString("BOX_CODE"))  && AllotArray[i][6].equals(rs.getString("need_by_date")) && AllotArray[i][7].equals((rs.getString("CUST_PARTNO")==null?"N/A":rs.getString("CUST_PARTNO"))))
								{
									if (AllotArray[i][0].equals(ID))
									{
										ALLOT_SHIP_QTY = AllotArray[i][8];
										V_FLAG="Y";
									}
									else
									{
										tot_allot_qty +=  Long.parseLong(AllotArray[i][8]); 
									}
								}
							}
						}
						
						useful_qty =rs.getLong("ON_HAND_QTY")-rs.getLong("PICK_QTY")-tot_allot_qty;
						out.println("<TR id='tr_"+vline+"' "+ (rs.getString("CUST_PARTNO")!=null && rs.getString("CUST_PARTNO").equals(CUST_PARTNO)?" style='background-color:#daf1a9'":"")+">");
						out.println("<TD><input type='checkbox' name='chkbox' value='"+vline+"' onClick='setClick("+vline+")' "+ (V_FLAG.equals("N")?"":"checked")+">");
						out.println("<input type='hidden' name='PO_HEADER_ID_"+vline+"' value ='"+ rs.getString("PO_HEADER_ID")+"'>");
						out.println("<input type='hidden' name='VENDOR_SITE_ID_"+vline+"' value ='"+ rs.getString("vendor_site_id")+"'>");
						out.println("<input type='hidden' name='PO_NO_"+vline+"' value ='"+ rs.getString("PO_NO")+"'>");
						out.println("<input type='hidden' name='UNIT_PRICE_"+vline+"' value ='"+ rs.getString("UNIT_PRICE")+"'>");
						out.println("<input type='hidden' name='BOX_CODE_"+vline+"' value ='"+ rs.getString("BOX_CODE")+"'>");
						out.println("<input type='hidden' name='NEED_BY_DATE_"+vline+"' value ='"+ rs.getString("need_by_date")+"'>");
						out.println("<input type='hidden' name='CUST_PARTNO_"+vline+"' value ='"+ rs.getString("CUST_PARTNO")+"'>");
						out.println("</TD>");
						out.println("<TD>"+ rs.getString("vendor_site_code")+"<input type='hidden' name='VENDOR_SITE_CODE_"+vline+"' value ='"+ rs.getString("vendor_site_code")+"'></TD>");
						out.println("<TD>"+ rs.getString("po_no")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("UNIT_PRICE")+"</TD>");
						out.println("<TD>"+ rs.getString("CURRENCY_CODE")+"</TD>");
						out.println("<TD align='center'>"+ rs.getString("need_by_date")+"</TD>");
						out.println("<TD>"+ (rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("UNRECEIVE_QUANTITY")+"<input type='hidden' name='UNRECEIVE_QTY_"+vline+"' value='"+rs.getString("UNRECEIVE_QUANTITY")+"'></TD>");
						//out.println("<TD align='right'>"+ rs.getString("RECEIVED_QUANTITY")+"<input type='hidden' name='RECEIVED_QUANTITY_"+vline+"' value='"+rs.getString("RECEIVED_QUANTITY")+"'></TD>");
						out.println("<TD align='right'>"+ tot_allot_qty+"<input type='hidden' name='ALLOT_QTY_"+vline+"' value='"+tot_allot_qty+"'></TD>");
						out.println("<TD align='right'>"+ (rs.getString("pick_qty")==null?"&nbsp;":rs.getString("pick_qty"))+"</TD>"); //add by Peggy 20200616
						out.println("<TD align='right' "+(useful_qty>0 ?"style='color:#0000ff'":"")+">"+ useful_qty+"<input type='hidden' name='ONHAND_"+vline+"' value='"+useful_qty+"'></TD>");
						out.println("<TD align='center'><input type='text' name='ALLOT_SHIP_QTY_"+vline+"' value='"+ALLOT_SHIP_QTY+"' size='7' style='text-align:right;font-family:Tahoma,Georgia; font-size: 11px' onKeyPress='return (event.keyCode >= 48 && event.keyCode <=57)' "+ (V_FLAG.equals("N")?"disabled":"")+"></TD>");
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();  
					statement.close(); 
					
					if (vline>0)
					{
						out.println("<table border='0' width='100%'>");
						out.println("<tr><td align='center'><input type='button' name='submit1' value='確定' onclick='setSubmit1();'></td></tr>");
						out.println("</table>");
						
					}   
					else
					{
						out.println("<font color='red'>查無採購單資料,請確認料號是否有下採購單,謝謝!</font>");
					} 
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
<%
}
else
{
	try
	{
		int tot_row  =0, del_cnt=0;
		String chk[]= request.getParameterValues("chkbox");
		String ShipArray [][]=MOShipBean.getArray2DContent();
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(ID) || ShipArray[i][0].equals("-1")) del_cnt++;
			}
			tot_row = ShipArray.length + chk.length - del_cnt;	
		}
		else
		{
			tot_row = chk.length;
		}
		//out.println("tot_row="+tot_row);
		String ship_tot [][] = new String [tot_row][10];
		int iLine=0;
		for (int i = 0 ; i < chk.length ; i++)
		{
			ship_tot[iLine][0] = ID;
			ship_tot[iLine][1] = request.getParameter("PO_HEADER_ID_"+chk[i]);
			ship_tot[iLine][2] = request.getParameter("VENDOR_SITE_ID_"+chk[i]);
			ship_tot[iLine][3] = request.getParameter("PO_NO_"+chk[i]);
			ship_tot[iLine][4] = request.getParameter("UNIT_PRICE_"+chk[i]);
			ship_tot[iLine][5] = request.getParameter("BOX_CODE_"+chk[i]);
			ship_tot[iLine][6] = request.getParameter("NEED_BY_DATE_"+chk[i]);
			ship_tot[iLine][7] = request.getParameter("CUST_PARTNO_"+chk[i]);
			ship_tot[iLine][8] = request.getParameter("ALLOT_SHIP_QTY_"+chk[i]);
			ship_tot[iLine][9] = ITEMID;
			iLine ++;
		} 
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(ID) || ShipArray[i][0].equals("-1")) continue;
				ship_tot[iLine][0] = ShipArray[i][0];
				ship_tot[iLine][1] = ShipArray[i][1];
				ship_tot[iLine][2] = ShipArray[i][2];
				ship_tot[iLine][3] = ShipArray[i][3];
				ship_tot[iLine][4] = ShipArray[i][4];
				ship_tot[iLine][5] = ShipArray[i][5];
				ship_tot[iLine][6] = ShipArray[i][6];
				ship_tot[iLine][7] = ShipArray[i][7];
				ship_tot[iLine][8] = ShipArray[i][8];
				ship_tot[iLine][9] = ShipArray[i][9];
				iLine ++;
			}
		}
		MOShipBean.setArray2DString(ship_tot);
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
