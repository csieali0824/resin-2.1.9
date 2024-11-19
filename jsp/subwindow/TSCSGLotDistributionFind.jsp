<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="LotDistributionBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<%
String sql = "";
String SG_DIST_ID=request.getParameter("SG_DIST_ID");
if (SG_DIST_ID==null) SG_DIST_ID="";
String ADVISE_LINE_ID =request.getParameter("ADVISE_LINE_ID");
if (ADVISE_LINE_ID==null) ADVISE_LINE_ID="";
String CARTON_NO= request.getParameter("CARTON_NO");
if (CARTON_NO==null) CARTON_NO="";
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
int vline=0;
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
<title>SG PO List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
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
		if (parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value)>= parseFloat(document.SUBFORM.SHIP_QTY.value))
		{
			document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = document.SUBFORM.SHIP_QTY.value;
		}
		else
		{
			document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = ""+parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value);
		}
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].style.color="#0000ff";
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].disabled = false;
	}
	else
	{
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = "0";
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
			if (parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value) > parseFloat(document.SUBFORM.elements["ONHAND_"+line].value))
			{
				alert("出貨量("+parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value)+")不可超過可用庫存量("+parseFloat(document.SUBFORM.elements["ONHAND_"+line].value)+")");
				return false;
			}
			
			tot_allot_qty = parseFloat(tot_allot_qty) + parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value);
		}
	}
	//if (tot_allot_qty>0 && tot_allot_qty != parseFloat(document.SUBFORM.SHIP_QTY.value))
	if (tot_allot_qty>0 && tot_allot_qty != (parseFloat(document.SUBFORM.SHIP_QTY.value)+parseFloat(document.SUBFORM.ALLOT_QTY.value)))
	{
		alert("出貨分配量必須等於排定出貨量!!");
		return false;
	}
	document.SUBFORM.submit1.disabled= true;
	document.SUBFORM.action="TSCSGLotDistributionFind.jsp?ACODE=SAVE&SG_DIST_ID="+document.SUBFORM.SG_DIST_ID.value+"&ADVISE_LINE_ID="+document.SUBFORM.ADVISE_LINE_ID.value+"&CARTON_NO="+document.SUBFORM.CARTON_NO.value;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.MYFORM.submit();
	window.close();				
}
</script>
<body >  
<FORM METHOD="post" ACTION="../TSCSGLotDistributionFind.jsp" NAME="SUBFORM">
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
					sql = " select b.advise_no"+
					      ",a.advise_line_id"+
						  ",case b.shipping_from when 'SG1' then '內銷' when 'SG2' then '外銷' else b.shipping_from end shipping_from"+
						  ",d.vendor_site_code"+
						  ",a.so_no"+
						  ",a.so_line_number"+
						  ",a.item_desc"+
						  ",a.item_no"+
						  ",a.inventory_item_id"+
						  ",(case when ?=a.CARTON_QTY then a.total_qty-(?-1)*a.CARTON_PER_QTY else a.TOTAL_QTY/a.CARTON_QTY end)/1000 ship_qty"+
						  ",(select sum(x.qty)/1000 from tsc.tsc_pick_confirm_lines x where x.tew_advise_no=a.tew_advise_no and x.advise_line_id=a.advise_line_id and x.carton_no=?) allot_qty"+
                          ",e.segment1 po_no"+
						  ",tssg_ship_pkg.GET_ORDER_CARTON_LIST('ORDER_LINE',a.tew_advise_no,a.so_line_id,'0','0') carton_list"+
						  //",NVL(decode(f.item_identifier_type,'CUST',f.ordered_item,''),'N/A') CUST_PARTNO"+
                          ",case when substr(a.SO_NO,1,1)='8' then NVL(decode(f.item_identifier_type,'CUST',f.ordered_item,''),'N/A') else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_PARTNO"+
						  ",a.organization_id"+
                          " from tsc.tsc_shipping_advise_lines a"+
						  ",tsc.tsc_shipping_advise_headers b"+
						  ",tsc.tsc_shipping_po_price_sg c"+
						  ",ap_supplier_sites_all d"+
						  ",po.po_headers_all e"+
						  ",ont.oe_order_lines_all f"+
                          ",(select x.order_number,y.line_number||'.'||y.shipment_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
                          " where a.advise_header_id=b.advise_header_id"+
                          " and a.pc_advise_id=c.pc_advise_id(+)"+
                          " and a.vendor_site_id=d.vendor_site_id"+
                          " and c.po_header_id=e.po_header_id(+)"+
                          " and a.so_no=tsc_odr.order_number(+)"+
                          " and a.so_line_number=tsc_odr.line_no(+)	"+					  
						  " and a.so_line_id=f.line_id"+
                          " and a.advise_line_id=?";
					//out.println(sql);
					//out.println(ADVISE_LINE_ID);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,CARTON_NO);
					statement.setString(2,CARTON_NO);
					statement.setString(3,CARTON_NO);
					statement.setString(4,ADVISE_LINE_ID);
					ResultSet rs=statement.executeQuery();
					if (rs.next())
					{
						out.println("<div id='div1' style='font-size:12px'>內&nbsp;外&nbsp;銷："+rs.getString("shipping_from")+"</div>");
						out.println("<div id='div1' style='font-size:12px'>訂單號碼："+rs.getString("so_no")+"</div>");
						out.println("<div id='div1' style='font-size:12px'>品&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名："+rs.getString("item_desc")+"</div>");
						out.println("<div id='div1' style='font-size:12px'>客戶品號："+(rs.getString("cust_partno")==null?"&nbsp;":rs.getString("cust_partno"))+"</div>");
						out.println("<div id='div1' style='font-size:12px'>數&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量："+rs.getString("ship_qty")+"K<input type='hidden' name='SHIP_QTY' value='"+rs.getString("ship_qty")+"'></div>");
						out.println("<div id='div1' style='font-size:12px'>已分配量："+(rs.getString("allot_qty")==null?"0":rs.getString("allot_qty"))+"K<input type='hidden' name='ALLOT_QTY' value='"+(rs.getString("allot_qty")==null?"0":rs.getString("allot_qty"))+"'></div>");
						out.println("<div id='div1' style='font-size:12px'>箱&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;號："+CARTON_NO+"</div>");
						out.println("<div id='div1' style='font-size:12px'>指定採購單號："+(rs.getString("po_no")==null?"&nbsp;":rs.getString("po_no"))+"</div>");
					
						/*sql = " SELECT Y.*"+
                              ",nvl((SELECT SUM(X.QTY/1000) FROM ORADDMAN.TSSG_LOT_DISTRIBUTION_TEMP X WHERE X.SG_DISTRIBUTION_ID=? AND X.ADVISE_LINE_ID=? AND X.CARTON_NUM=? AND X.LOT_NUMBER=Y.LOT_NUMBER AND X.DATE_CODE=Y.DATE_CODE),0) ALLOT_SHIP_QTY"+
                              " FROM (SELECT A.ORGANIZATION_ID,A.ITEM_ID INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,A.SUBINVENTORY_CODE"+
							  ",A.LOT_NUMBER,A.DATE_CODE,A.EXP_DATE,A.VENDOR_SITE_ID,A.VENDOR_SITE_CODE,A.PO_NO,A.PO_CUST_PARTNO "+
                              ",SUM(A.ONHAND+A.PICK_QTY ) QTY,SUM(A.PICK_QTY) ALLOT_QTY"+
							  " FROM TABLE(TSSG_SHIP_PKG.LOT_ONHAND_VIEW(?,?,NULL,NULL,NULL,0,null)) A"+
                              " WHERE  A.ONHAND+A.PICK_QTY >0"+
							  " GROUP BY  A.ORGANIZATION_ID,A.ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,A.SUBINVENTORY_CODE,A.LOT_NUMBER,A.DATE_CODE,A.EXP_DATE,A.VENDOR_SITE_ID,A.VENDOR_SITE_CODE,A.PO_NO,A.PO_CUST_PARTNO) Y";*/
						sql =" SELECT A.ORGANIZATION_ID"+
						     ",A.INVENTORY_ITEM_ID "+
							 ",A.ITEM_NAME"+
							 ",A.ITEM_DESC"+
							 ",A.SUBINVENTORY_CODE"+
                             ",A.LOT_NUMBER"+
                             ",A.DATE_CODE"+
                             ",A.VENDOR_SITE_ID"+
                             ",A.VENDOR_SITE_CODE"+
                             ",D.SEGMENT1 PO_NO"+
                             //",NVL(A.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(C.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN C.NOTE_TO_VENDOR ELSE SUBSTR(C.NOTE_TO_VENDOR,1,INSTR(C.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
                             ",NVL(A.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(C.NOTE_TO_VENDOR)"+
                             ",CASE WHEN B.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
                             " FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
                             " WHERE x.org_id= CASE WHEN SUBSTR(B.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
                             " AND x.header_id=y.header_id"+
                             " AND y.packing_instructions='T'"+
                             " AND x.order_number= SUBSTR(B.NOTE_TO_RECEIVER,1,INSTR(B.NOTE_TO_RECEIVER,'.')-1)"+
                             " AND y.shipment_number=1 and y.line_number=SUBSTR(B.NOTE_TO_RECEIVER,INSTR(B.NOTE_TO_RECEIVER,'.')+1))"+
                             " ELSE '' END)) PO_CUST_PARTNO"+
                             ",(NVL(A.RECEIVED_QTY,0)+NVL(A.ALLOCATE_IN_QTY,0)-NVL(A.RETURN_QTY,0)-NVL(A.ALLOCATE_OUT_QTY,0)-NVL(A.SHIPPED_QTY,0))/1000 QTY  "+   
                             ",NVL((SELECT SUM(TPCL.QTY) QTY FROM TSC_PICK_CONFIRM_LINES TPCL,TSC_PICK_CONFIRM_HEADERS TPCH WHERE TPCH.PICK_CONFIRM_DATE IS NULL AND TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID),0)/1000 PICK_QTY"+
                             ",NVL((SELECT SUM(X.QTY/1000) FROM ORADDMAN.TSSG_LOT_DISTRIBUTION_TEMP X WHERE X.SG_DISTRIBUTION_ID=? AND X.ADVISE_LINE_ID=? AND X.CARTON_NUM=? AND X.SG_STOCK_ID=A.SG_STOCK_ID),0) ALLOT_SHIP_QTY"+
							 ",a.SG_STOCK_ID"+
							 ",nvl(a.VENDOR_CARTON_NO,'') VENDOR_CARTON_NO "+
							 ",d.PO_HEADER_ID"+
							 ",A.dc_yyww"+  //add by Peggy 20220801
                             //" FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
							 " FROM (SELECT sg_stock_id, inventory_item_id, item_name, item_desc, organization_id, subinventory_code, lot_number,"+
                             " date_code,dc_yyww, received_date, received_qty, allocate_in_qty,allocate_out_qty, return_qty, shipped_qty,"+
                             " nvl(po_line_location_id,(select po_line_location_id from ORADDMAN.TSSG_STOCK_OVERVIEW X WHERE A.FROM_SG_STOCK_ID=X.SG_STOCK_ID)) po_line_location_id , po_header_id, remarks, vendor_site_id, vendor_site_code,  vendor_carton_no, nw, gw, cust_partno, receipt_num"+
							 " FROM ORADDMAN.TSSG_STOCK_OVERVIEW A)  A"+ //FOR內外銷庫存互轉調整,MODIFY BY PEGGY 20201225
							 ",PO.PO_LINE_LOCATIONS_ALL B"+
							 ",PO.PO_LINES_ALL C"+
							 ",PO.PO_HEADERS_ALL D"+
                             " WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
                             " AND B.PO_LINE_ID=C.PO_LINE_ID"+
                             " AND C.PO_HEADER_ID=D.PO_HEADER_ID"+
                             " AND EXISTS (SELECT 1 FROM TSC_SHIPPING_ADVISE_HEADERS X,TSC_SHIPPING_ADVISE_LINES Y"+
                             "             WHERE X.ADVISE_HEADER_ID=Y.ADVISE_HEADER_ID"+
                             "             AND Y.ADVISE_LINE_ID=?"+
                             "             AND DECODE(X.DELIVERY_TYPE,'VENDOR','02','01')=A.SUBINVENTORY_CODE"+
                             "             AND Y.ORGANIZATION_ID=A.ORGANIZATION_ID"+
                             "             AND Y.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID"+
                             //"             AND Y.VENDOR_SITE_ID=A.VENDOR_SITE_ID)"+
							 "              AND DECODE(Y.VENDOR_SITE_ID,1117980,1287968,1117981,1287969,Y.VENDOR_SITE_ID)=DECODE(A.VENDOR_SITE_ID,1117980,1287968,1117981,1287969,A.VENDOR_SITE_ID))"+ //中之轉先之科,兩家庫存共享 modify by Peggy 20210715
                             "             AND NVL(RECEIVED_QTY,0)+NVL(ALLOCATE_IN_QTY,0)-NVL(RETURN_QTY,0)-NVL(ALLOCATE_OUT_QTY,0)-NVL(SHIPPED_QTY,0)>0";
 						//out.println(sql);
						//out.println("SG_DIST_ID="+SG_DIST_ID);
						//out.println("ADVISE_LINE_ID="+ADVISE_LINE_ID);
						//out.println("CARTON_NO="+CARTON_NO);
						//out.println(rs.getString("organization_id"));
						//out.println(rs.getString("inventory_item_id"));
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,SG_DIST_ID);
						statement1.setString(2,ADVISE_LINE_ID);
						statement1.setString(3,CARTON_NO);
						statement1.setString(4,ADVISE_LINE_ID);
						ResultSet rs1=statement1.executeQuery();
						vline=0;
						long tot_allot_qty =0;
						while (rs1.next())
						{	
							if (vline==0)
							{
								out.println("<TABLE border='1' width='100%' cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>");      
								out.println("<TR bgcolor='#cccccc' align='center'>");
								out.println("<Td width='3%'>&nbsp;</Td>");        
								out.println("<Td width='3%'>項次</Td>");        
								out.println("<Td width='10%'>供 應 商</Td>");
								out.println("<Td width='10%'>採購單號</Td>");
								out.println("<Td width='15%'>客戶品號</Td>");
								out.println("<Td width='16%'>Lot</Td>");
								out.println("<Td width='6%'>Date Code</Td>");
								out.println("<Td width='6%'>DC YYWW</Td>");
								out.println("<Td width='7%'>箱號</Td>");
								out.println("<Td width='8%'>庫存量(K)</Td>");
								out.println("<Td width='8%'>已分配量(K)</Td>");
								out.println("<Td width='8%'>出貨量</Td>");
								out.println("</TR>");
							}
							vline++;
							out.println("<TR id='tr_"+vline+"' "+ (rs.getString("cust_partno")!=null &&rs.getString("cust_partno").equals(rs1.getString("PO_CUST_PARTNO"))?"bgcolor='#CCFFFF'":"")+">");
							out.println("<TD><input type='checkbox' name='chkbox' value='"+vline+"' onClick='setClick("+vline+")' "+ (rs1.getString("allot_ship_qty").equals("0")?"":"checked")+">");
							out.println("</TD>");
							out.println("<td>"+vline+"</td>");
							out.println("<TD>"+ rs1.getString("vendor_site_code")+"<input type='hidden' name='VENDOR_SITE_id_"+vline+"' value ='"+ rs1.getString("VENDOR_SITE_ID")+"'></TD>");
							out.println("<TD>"+ rs1.getString("po_no")+"<input type='hidden' name='PO_HEADER_ID_"+vline+"' value ='"+ (rs1.getString("PO_HEADER_ID")==null?"":rs1.getString("PO_HEADER_ID"))+"'></TD>");
							out.println("<TD>"+ (rs1.getString("PO_CUST_PARTNO")==null?"&nbsp;":rs1.getString("PO_CUST_PARTNO"))+"</TD>");
							out.println("<TD>"+ rs1.getString("lot_number")+"<input type='hidden' name='SUBINV_"+vline+"' value ='"+ rs1.getString("subinventory_code")+"'><input type='hidden' name='LOT_"+vline+"' value ='"+ rs1.getString("lot_number")+"'><input type='hidden' name='PO_CUST_PARTNO_"+vline+"' value ='"+ (rs1.getString("PO_CUST_PARTNO")==null?"":rs1.getString("PO_CUST_PARTNO"))+"'></TD>");
							out.println("<TD>"+ rs1.getString("date_code")+"<input type='hidden' name='DC_"+vline+"' value ='"+ rs1.getString("date_code")+"'><input type='hidden' name='SG_STOCK_ID_"+vline+"' value ='"+ rs1.getString("SG_STOCK_ID")+"'></TD>");
							out.println("<TD>"+ (rs1.getString("dc_yyww")==null?"&nbsp;":rs1.getString("dc_yyww"))+"<input type='hidden' name='DC_YYWW_"+vline+"' value ='"+ (rs1.getString("dc_yyww")==null?"":rs1.getString("dc_yyww"))+"'></TD>");
							out.println("<TD>"+ (rs1.getString("VENDOR_CARTON_NO")==null?"&nbsp;":rs1.getString("VENDOR_CARTON_NO"))+"<input type='hidden' name='VENDOR_CARTON_NO_"+vline+"' value ='"+ (rs1.getString("VENDOR_CARTON_NO")==null?"":rs1.getString("VENDOR_CARTON_NO"))+"'></TD>");
							out.println("<TD align='right'>"+ rs1.getString("qty")+"<input type='hidden' name='ONHAND_"+vline+"' value='"+rs1.getString("qty")+"'></TD>");
							out.println("<TD align='right'>"+ rs1.getString("PICK_QTY")+"</TD>");
							out.println("<TD align='center'><input type='text' name='ALLOT_SHIP_QTY_"+vline+"' value='"+rs1.getString("allot_ship_qty")+"' size='6' style='text-align:right;font-family:Tahoma,Georgia; font-size: 11px;font-weight:bold;"+(rs1.getString("allot_ship_qty").equals("0")?"":"color:#0000ff")+"' onKeyPress='return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)' "+ (rs1.getString("allot_ship_qty").equals("0")?"disabled":"")+"></TD>");
							out.println("</TR>");	
						}
						rs1.close();
						statement1.close();
						
						if (vline>0)
						{
							out.println("</table><table border='0' width='100%'>");
							out.println("<tr><td align='center'><input type='button' name='submit1' value='確定' onclick='setSubmit1();'></td></tr>");
							out.println("</table>");
							
						}   
						else
						{
							out.println("<font color='red'>No Data Found!</font>");
						} 							
					}
					
					rs.close();
					statement.close();
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
		String chk[]= request.getParameterValues("chkbox");
		if (chk !=null)
		{
			sql= " DELETE oraddman.TSSG_LOT_DISTRIBUTION_TEMP X"+
				 " WHERE X.SG_DISTRIBUTION_ID=?"+
				 " AND X.ADVISE_LINE_ID=?"+
				 " AND X.CARTON_NUM=? ";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  	
			pstmtDt.setString(1,SG_DIST_ID); 
			pstmtDt.setString(2,ADVISE_LINE_ID); 
			pstmtDt.setString(3,CARTON_NO);						 
			pstmtDt.executeQuery();
			pstmtDt.close();	
		
			for (int i = 0 ; i < chk.length ; i++)
			{
				sql = " insert into oraddman.tssg_lot_distribution_temp"+
					  " select ?"+
					  ",a.TEW_ADVISE_NO"+
					  ",(SELECT VENDOR_SITE_CODE FROM AP_SUPPLIER_SITES_ALL WHERE VENDOR_SITE_ID=?)"+
					  ",?"+
					  ",b.ADVISE_HEADER_ID"+
					  ",a.ADVISE_LINE_ID"+
					  ",a.PC_ADVISE_ID"+
					  ",a.SO_NO"+
					  ",a.SO_LINE_NUMBER"+
					  ",a.INVENTORY_ITEM_ID"+
					  ",a.ITEM_NO"+
					  ",a.ITEM_DESC"+
					  ",a.SHIP_QTY"+
					  ",a.PO_NO"+
					  ",NVL(decode(d.item_identifier_type,'CUST',d.ordered_item,''),'N/A') CUST_PARTNO"+
					  ",a.SHIPPING_REMARK"+
					  ",b.SHIPPING_METHOD"+
					  ",TO_CHAR(a.PC_SCHEDULE_SHIP_DATE,'yyyy-mm-dd') "+
					  ",?"+
					  ",a.POST_CODE POST_FIX_CODE"+
					  ",?"+
					  ",?"+
					  ",?*1000"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  " FROM tsc.tsc_shipping_advise_lines a"+
					  ",tsc.tsc_shipping_advise_headers b"+
					  ",ONT.OE_ORDER_LINES_ALL d"+
					  " where a.advise_line_id=?"+
					  " and b.SHIPPING_FROM LIKE 'SG%'"+
					  " and b.advise_header_id = a.advise_header_id"+
					  " and a.so_line_id = d.line_id(+)";
				//out.println(sql);
				pstmtDt=con.prepareStatement(sql);  	
				pstmtDt.setString(1,SG_DIST_ID); 
				pstmtDt.setString(2,request.getParameter("VENDOR_SITE_id_"+chk[i])); 
				pstmtDt.setString(3,request.getParameter("VENDOR_SITE_id_"+chk[i])); 
				pstmtDt.setString(4,CARTON_NO);						 
				pstmtDt.setString(5,request.getParameter("LOT_"+chk[i])); 
				pstmtDt.setString(6,request.getParameter("DC_"+chk[i])); 
				pstmtDt.setString(7,request.getParameter("ALLOT_SHIP_QTY_"+chk[i])); 
				pstmtDt.setString(8,UserName); 
				pstmtDt.setString(9,(request.getParameter("PO_CUST_PARTNO_"+chk[i])==null?"":request.getParameter("PO_CUST_PARTNO_"+chk[i]))); 
				pstmtDt.setString(10,(request.getParameter("VENDOR_CARTON_NO_"+chk[i])==null?"":request.getParameter("VENDOR_CARTON_NO_"+chk[i]))); 
				pstmtDt.setString(11,request.getParameter("SG_STOCK_ID_"+chk[i])); 
				pstmtDt.setString(12,request.getParameter("SUBINV_"+chk[i])); 
				pstmtDt.setString(13,request.getParameter("PO_HEADER_ID_"+chk[i])); 
				pstmtDt.setString(14,request.getParameter("DC_YYWW_"+chk[i])); 
				pstmtDt.setString(15,ADVISE_LINE_ID); 
				pstmtDt.executeQuery();
				pstmtDt.close();	
			}			  
		} 
		else
		{
			sql= " update oraddman.TSSG_LOT_DISTRIBUTION_TEMP X"+
				 " SET lot_number='庫存不足'"+
				 " ,date_code=null"+
				 " ,VENDOR_CARTON_NO=null"+
				 " ,SG_STOCK_ID=null"+
				 " ,SUBINVENTORY_CODE=null"+
				 " ,PO_CUST_PARTNO=null"+
				 " ,PO_HEADER_ID=null"+
				 " ,DC_YYWW=null"+
				 " where X.SG_DISTRIBUTION_ID=?"+
				 " AND X.ADVISE_LINE_ID=?"+
				 " AND X.CARTON_NUM=? ";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  	
			pstmtDt.setString(1,SG_DIST_ID); 
			pstmtDt.setString(2,ADVISE_LINE_ID); 
			pstmtDt.setString(3,CARTON_NO);						 
			pstmtDt.executeQuery();
			pstmtDt.close();		
		}
		con.commit();
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}
}
%>
<INPUT TYPE="hidden" name="ADVISE_LINE_ID" value="<%=ADVISE_LINE_ID%>">
<INPUT TYPE="hidden" name="SG_DIST_ID" value="<%=SG_DIST_ID%>">
<INPUT TYPE="hidden" name="CARTON_NO" value="<%=CARTON_NO%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
