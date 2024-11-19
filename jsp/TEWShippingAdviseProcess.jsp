<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- 20150109 by Peggy, PHIHONG151單獨開一筆ADVISE & INSERT tsc.tsc_shipping_po_price前,檢查資料是否存在,若是,則以UPDATE方式加入數量-->
<!-- 20150630 by Peggy, table:tsc_shipping_po_price add columen:INVENTORY_ITEM_ID-->
<!-- 20170516 by Peggy, DELTA ELE.(THAILAND) PO前兩碼不同要拆成不同出貨通知單-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2..-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>TEW Shipping Advise Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TEWShippingAdviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

String sql ="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";

if (TRANSTYPE.equals("INSERT"))
{
	try
	{
		String ERPUSERID = request.getParameter("ERPUSERID");
		String PC_ADVISE_ID="";
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無出貨通知交易!!");
		}
		long  ACT_SHIP_QTY=0,TOT_SHIP_QTY=0;
		for(int i=0; i< chk.length ;i++)
		{
			ACT_SHIP_QTY=Long.parseLong(request.getParameter("ACT_SHIP_QTY_"+chk[i]));
			TOT_SHIP_QTY=0;
			
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(" SELECT TSC_SHIPPING_ADVISE_PC_S.nextval from dual");
			if (rs1.next())
			{
				PC_ADVISE_ID = rs1.getString(1);
			}
			else
			{
				throw new Exception("PC Advise Id取得失敗!!");
			}
			rs1.close();
			statement1.close();		
					
			sql = " insert into tsc.tsc_shipping_advise_pc_tew "+
				  " (so_header_id, "+
				  " so_line_id, "+
				  " so_no, "+
				  " so_line_number,"+
				  " organization_id, "+
				  " inventory_item_id, "+
				  " item_no, "+
				  " item_desc,"+
				  " product_group, "+
				  " customer_id, "+
				  " shipping_method,"+
				  " shipping_from, "+
				  " so_qty, "+
				  " dn_qty, "+
				  " ship_qty, "+
				  " onhand_qty,"+
				  " pc_confirm_qty, "+
				  " unship_confirm_qty,"+ 
				  " uom, "+
				  " fob_code,"+
				  " schedule_ship_date, "+
				  " pc_schedule_ship_date,"+
				  " net_weight,"+
				  " gross_weight, "+
				  " cube, "+
				  " pc_remark, "+
				  " packing_instructions,"+
				  " shipping_remark, "+
				  " region_code, "+
				  " payment_term_id,"+
				  " payment_term, "+
				  " ship_to_org_id, "+
				  " ship_to, "+
				  " invoice_to_org_id,"+
				  " invoice_to, "+
				  " deliver_to_org_id, "+
				  " deliver_to,"+
				  " tax_code,"+
				  " ship_to_contact_id, "+
				  " currency_code, "+
				  " cust_po_number,"+
				  " delivery_detail_id, "+
				  " tsc_package, "+
				  " tsc_family,"+
				  " packing_code, "+
				  " ship_advise_qty,"+
				  " pc_advise_id,"+
				  " shipping_method_code, "+
				  " fob, "+
				  " ship_to_contact_name,"+
				  " tax,"+
				  " customer_name, "+
				  " media_id, "+
				  " file_id,"+
				  " invoice_no,"+
				  " carton_no_from,"+
				  " carton_no_to,"+
				  " post_fix_code,"+
				  " carton_per_qty, "+
				  " last_update_date,"+
				  " last_updated_by,"+
				  " creation_date,"+
				  " created_by, "+
				  " last_update_login,"+
				  " TO_TW,"+
				  " VENDOR_SITE_ID)"+
				  " select a.HEADER_ID SO_HEADER_ID,"+
				  " b.LINE_ID SO_LINE_ID,"+
				  " a.order_number SO_NO,"+
				  " b.line_number ||'.'|| b.shipment_number SO_LINE_NUMBER,"+
				  " b.ship_from_org_id ORGANIZATION_ID,"+
				  " b.inventory_item_id,"+
				  " c.segment1 ITEM_NO,"+
				  " c.description ITEM_DESC,"+
				  " tsc_om_category(c.inventory_item_id,49,'TSC_PROD_GROUP') PRODUCT_GROUP,"+
				  " a.sold_to_org_id CUSTOMER_ID,"+
				  //" case when ?='Y' and instr(d.meaning,'UPS')<=0 and instr(d.meaning,'DHL')<=0 and instr(d.meaning,'FEDEX')<=0 and instr(d.meaning,'TNT')<=0 then 'SEA(C)' else d.meaning end as SHIPPING_METHOD,"+
				  //" case when ?='Y' and substr(a.order_number,1,4)='1121' and (instr(d.meaning,'UPS')>0 or instr(d.meaning,'DHL')>0 or instr(d.meaning,'FEDEX')>0 or instr(d.meaning,'TNT')>0) then d.meaning else 'SEA(C)' end as SHIPPING_METHOD,"+ //1121 回T快遞維持原出貨方式,modify by Peggy 20170908
				  " case when ?='Y' and (substr(a.order_number,1,4)<>'1121' or (substr(a.order_number,1,4)='1121' and instr(d.meaning,'UPS')<=0 and instr(d.meaning,'DHL')<=0 and instr(d.meaning,'FEDEX')<=0 and instr(d.meaning,'TNT')<=0)) then 'SEA(C)' else d.meaning end as SHIPPING_METHOD,"+
				  " 'TEW' SHIPPING_FROM,"+
				  " b.ordered_quantity SO_QTY,"+
				  " null DN_QTY,"+
				  " ? SHIP_QTY,"+
				  " nvl((SELECT sum(nvl(y.RECEIVED_QUANTITY,0)*1000)-sum(nvl(y.SHIPPED_QUANTITY,0)*1000) from oraddman.tewpo_receive_header x,oraddman.tewpo_receive_detail y where x.PO_LINE_LOCATION_ID=y.PO_LINE_LOCATION_ID and y.PO_LINE_LOCATION_ID=? ),0) onhand,"+
				  " ? PC_CONFIRM_QTY,"+
				  " 0 UNSHIP_CONFIRM_QTY,"+
				  " b.ORDER_QUANTITY_UOM UOM,"+
				  " b.FOB_POINT_CODE FOB_CODE,"+
				  " to_date(TO_CHAR(b.SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),'yyyy/mm/dd') SCHEDULE_SHIP_DATE,"+
				  " TO_DATE(?,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
				  " null NET_WEIGHT,"+
				  " null GROSS_WEIGHT,"+
				  " null CUBE,"+
				  " null PC_REMARK,"+
				  " b.PACKING_INSTRUCTIONS,"+
				  " h.description  SHIPPING_REMARK,"+
				  " Tsc_Intercompany_Pkg.get_sales_group(b.header_id) REGION_CODE,"+
				  " b.payment_term_id PAYMENT_TERM_ID,"+
				  " e.name PAYMENT_TERM,"+
				  " b.SHIP_TO_ORG_ID,"+
				  " b.SHIP_TO_ORG_ID SHIP_TO,"+
				  " b.INVOICE_TO_ORG_ID,"+
				  " b.INVOICE_TO_ORG_ID INVOICE_TO,"+
				  " b.DELIVER_TO_ORG_ID,"+
				  " b.DELIVER_TO_ORG_ID DELIVER_TO,"+
				  " b.TAX_CODE,"+
				  " b.SHIP_TO_CONTACT_ID,"+
				  " a.TRANSACTIONAL_CURR_CODE CURRENCY_CODE,"+
				  " b.CUSTOMER_LINE_NUMBER CUST_PO_NUMBER,"+
				  " f.DELIVERY_DETAIL_ID,"+
				  " tsc_om_category(c.inventory_item_id,49,'TSC_Package') AS TSC_PACKAGE,"+
				  " tsc_om_category(c.inventory_item_id,49,'TSC_Family') AS TSC_FAMILY,"+
				  " tsc_get_item_packing_code(49,c.inventory_item_id) PACKING_CODE,"+
				  " 0 SHIP_ADVISE_QTY,"+
				  " ?,"+
				  " b.SHIPPING_METHOD_CODE,"+
				  " b.FOB_POINT_CODE FOB,"+
				  " NULL SHIP_TO_CONTACT_NAME,"+
				  " NULL TAX,"+
				  " g.customer_name,"+
				  " h.MEDIA_ID,"+
				  " null FILE_ID,"+
				  " null INVOICE_NO,"+
				  " null CARTON_NO_FROM,"+
				  " null CARTON_NO_TO,"+
				  //" ? POST_FIX_CODE,"+
				  //" case when length(h.description)>=12 and substr(h.description ,1,12)='CHANNEL WELL' then 'D' else '"+(request.getParameter("BOX_CODE_"+chk[i])==null?"":request.getParameter("BOX_CODE_"+chk[i]))+"' end, "+ //modify by Peggy 20140902
				  " case when length(h.description)>=12 and substr(h.description ,1,12)='CHANNEL WELL' then 'D' when instr(h.description ,'駱騰')>0 then 'I' else '"+(request.getParameter("BOX_CODE_"+chk[i])==null?"":request.getParameter("BOX_CODE_"+chk[i]))+"' end, "+ //modify by Peggy 20140902
				  " null CARTON_PER_QTY,"+
				  " sysdate LAST_UPDATE_DATE,"+
				  " ? LAST_UPDATED_BY,"+
				  " sysdate CREATION_DATE,"+
				  " ? CREATED_BY,"+
				  " null LAST_UPDATE_LOGIN,"+
				  " ? TO_TW,"+
				  " ? VENDOR_SITE_ID"+
				  " from ont.oe_order_headers_all a,"+
				  " ont.oe_order_lines_all b,"+
				  " inv.mtl_system_items_b c,"+
				  " (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') d ,"+
				  " (select * from ra_terms_tl where LANGUAGE='US') e,"+
				  //" wsh.wsh_delivery_details f,"+
				  " (select * from (select source_header_id,source_line_id,DELIVERY_DETAIL_ID,row_number() over(partition by source_header_id,source_line_id order by nvl(SPLIT_FROM_DELIVERY_DETAIL_ID,0) desc,CREATION_DATE) seq_no from wsh.wsh_delivery_details where source_line_id=?) where seq_no =1) f,"+  //modify by Peggy 20141211
				  " AR_CUSTOMERS g,"+
				  " (SELECT y.description ,z.pk1_value,x.MEDIA_ID from fnd_documents_tl y,fnd_attached_documents z ,fnd_documents x where x.DOCUMENT_ID=y.DOCUMENT_ID AND y.language = 'US' and  x.DOCUMENT_ID=z.DOCUMENT_ID  and exists (select 1  from fnd_document_categories_tl r WHERE r.USER_NAME='SHIPPING MARKS' AND r.LANGUAGE='US' and r.category_id = x.category_id)) h "+
				  " where a.header_id = b.header_id "+
				  " and b.ship_from_org_id = c.organization_id"+
				  " and b.inventory_item_id = c.inventory_item_id"+
				  " AND b.SHIPPING_METHOD_CODE = d.lookup_code (+)"+
				  " AND NVL(b.payment_term_id,a.payment_term_id) =e.term_id"+
				  " AND b.header_id = f.source_header_id"+
				  " and b.line_id = f.source_line_id"+
				  " and a.sold_to_org_id = g.customer_id"+
				  " and a.header_id = h.pk1_value(+)"+
				  " and b.line_id=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("TO_TW_"+chk[i]));
			pstmtDt.setString(2,""+ACT_SHIP_QTY);
			pstmtDt.setString(3,request.getParameter("LINE_LOCATION_ID_"+chk[i]));
			pstmtDt.setString(4,""+ACT_SHIP_QTY);
			pstmtDt.setString(5,request.getParameter("ACT_SHIP_DATE_"+chk[i]));
			pstmtDt.setString(6,PC_ADVISE_ID);
			//pstmtDt.setString(7,request.getParameter("BOX_CODE_"+chk[i]));
			pstmtDt.setString(7,ERPUSERID);
			pstmtDt.setString(8,ERPUSERID);
			pstmtDt.setString(9,request.getParameter("TO_TW_"+chk[i]));
			pstmtDt.setString(10,request.getParameter("VENDOR_SITE_ID_"+chk[i]));
			pstmtDt.setString(11,chk[i]);  //add by Peggy 20141211 
			pstmtDt.setString(12,chk[i]); 
			pstmtDt.executeQuery();
			pstmtDt.close();
						
			String ShipArray[][]= MOShipBean.getArray2DContent();
			if (ShipArray!=null)
			{
				for( int j=0 ; j< ShipArray.length ; j++ ) 
				{
					if (ShipArray[j][0].equals(chk[i]))
					{
						//add by Peggy 20150109
						sql = " select 1 from tsc.tsc_shipping_po_price where pc_advise_id=? and po_header_id=? and po_unit_price=? and CUST_PARTNO=? and INVENTORY_ITEM_ID=?";
						PreparedStatement statement9 = con.prepareStatement(sql);
						statement9.setString(1,PC_ADVISE_ID);
						statement9.setString(2,ShipArray[j][1]);
						statement9.setString(3,ShipArray[j][4]);
						statement9.setString(4,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
						statement9.setString(5,ShipArray[j][9]); //add by Peggy 20150630
						ResultSet rs9=statement9.executeQuery();
						if (rs9.next())
						{
							sql = " UPDATE tsc.tsc_shipping_po_price"+
							      " SET ORDER_QTY=ORDER_QTY+?"+
								  " where pc_advise_id=? and po_header_id=? and po_unit_price=? and CUST_PARTNO=? and INVENTORY_ITEM_ID=?";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,ShipArray[j][8]);
							pstmtDt.setString(2,PC_ADVISE_ID);
							pstmtDt.setString(3,ShipArray[j][1]);
							pstmtDt.setString(4,ShipArray[j][4]);
							pstmtDt.setString(5,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
							pstmtDt.setString(6,ShipArray[j][9]); //add by Peggy 20150630
							pstmtDt.executeQuery();
							pstmtDt.close();						
						}
						else
						{
							sql = " insert into tsc.tsc_shipping_po_price(pc_advise_id, po_header_id, po_unit_price,ORDER_QTY,CUST_PARTNO,INVENTORY_ITEM_ID,PC_ADVISE_PRICE_ID)"+
								  " select ?,?,?,?,?,?,TSC_ADVISE_PC_PRICE_ID_S.NEXTVAL from dual";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,PC_ADVISE_ID);
							pstmtDt.setString(2,ShipArray[j][1]);
							pstmtDt.setString(3,ShipArray[j][4]);
							pstmtDt.setString(4,ShipArray[j][8]);
							pstmtDt.setString(5,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
							pstmtDt.setString(6,ShipArray[j][9]); //add by Peggy 20150630
							pstmtDt.executeQuery();
							pstmtDt.close();
						}
						rs9.close();
						statement9.close();
						
						TOT_SHIP_QTY += Long.parseLong(ShipArray[j][8]); 
					}
				}
			}
			if (ACT_SHIP_QTY != TOT_SHIP_QTY)
			{
				throw new Exception("排定出貨量與分配出貨量不符!");
			}
		}	
		con.commit();
		MOShipBean.setArray2DString(null); 
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!!若要進行出貨通知確認動作,請按確定鍵,否則按下取消鍵,回到出貨通知排定功能!!"))
			{
				setSubmit("../jsp/TEWShippingAdviseConfirm.jsp");
			}
			else
			{
				setSubmit("../jsp/TEWShippingAdvise.jsp");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TEWShippingAdvise.jsp'>回出貨通知排定功能</a></font>");
	}
}
else if (TRANSTYPE.equals("CONFIRM"))
{
	try
	{
		int Advise_Cnt = 0,insertCnt=0;
		String AdviseList="",AdviseNoList="";
		String ERPUSERID = request.getParameter("ERPUSERID");
		String rdoValue=request.getParameter("rdo1");
		if (rdoValue==null) rdoValue="";
		String ADVISE_NO = request.getParameter("ADVISE_NO");
		if (ADVISE_NO ==null) ADVISE_NO="";
		if (rdoValue.equals("ADD") && ADVISE_NO.equals(""))
		{
			throw new Exception("未指定Advise No!!");
		}
		else if (rdoValue.equals(""))
		{
			throw new Exception("未指定Shipping Advise種類!");
		}
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無出貨通知交易!!");
		}
		for (int i=0; i< chk.length ;i++)
		{
			sql = " update tsc.tsc_shipping_advise_pc_tew a"+
				  " set PC_SCHEDULE_SHIP_DATE=to_date(?,'yyyymmdd')"+
				  ",LAST_UPDATE_DATE=SYSDATE"+
				  ",LAST_UPDATED_BY=?"+
				  ",SEQ_NO=?"+
				  " where PC_ADVISE_ID=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("SSD_"+chk[i]));
			pstmtDt.setString(2,ERPUSERID);
			pstmtDt.setString(3,request.getParameter("SEQ_"+chk[i]));
			pstmtDt.setString(4,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
		if (rdoValue.equals("ADD"))
		{
			for (int i=0; i< chk.length ;i++)
			{
				sql = " update tsc.tsc_shipping_advise_pc_tew a"+
				      " set advise_no=?"+
					  ",orig_advise_no=?"+
					  ",LAST_UPDATE_DATE=SYSDATE"+
					  ",LAST_UPDATED_BY=?"+
					  " where PC_ADVISE_ID=?"+
					  " and advise_no is null";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.setString(3,ERPUSERID);
				pstmtDt.setString(4,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			con.commit();
			out.println("<table width='80%' align='center'><tr><td align='center'><div align='cneter' style='color:#0000ff;font-size:12px'>動作成功!!資料已加入Advise No："+ADVISE_NO+"</DIV></td></tr>");
			out.println("<tr><td align='center'><div align='center' style='color:#0000ff;font-size:12x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
			%>
			<jsp:getProperty name="rPH" property="pgHOME"/>
			<%
			out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TEWShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TEWShippingAdviseExcel.jsp?ADVISE_NO="+ADVISE_NO+'"'+">下載出貨通知單</a></td></tr>");
			out.println("</table>");
		}
		else if (rdoValue.equals("NEW"))  
		{
			sql = " select case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)')  AND a.to_tw ='N' THEN 1 "+
			             " when a.to_tw ='Y' THEN 2 "+
						 " when a.REGION_CODE='TSCT-Disty' THEN 3 "+
						 " ELSE a.CUSTOMER_ID END AS CUSTOMER_ID"+
			             " ,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end REGION_CODE"+
			             " ,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end as SHIPPING_METHOD "+
			             " ,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
						 " ,a.TO_TW"+
						 " ,a.VENDOR_SITE_ID"+
						 " ,b.vendor_site_code"+
						 " ,case when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' "+
						 " when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD' "+
						 " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  not in ('104','151') then 'PHIHONG(1)' "+ 
						 " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
						 " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
						 " when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
						 " when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+ //add by Peggy 20181211
						 " when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
						 " ELSE 'N/A' END AS SHIPPING_REMARK"+
						 //",case when a.to_tw ='N' and a.REGION_CODE ='TSCJ' THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+
						 ",case when a.to_tw ='N' and a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT') THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+
			             " from tsc.tsc_shipping_advise_pc_tew a"+
						 ",ap.ap_supplier_sites_all b"+
						 ",AR_CUSTOMERS c"+
			             " where SHIPPING_FROM='TEW'"+
						 " and a.vendor_site_id = b.vendor_site_id"+
						 " and a.CUSTOMER_ID = c.CUSTOMER_ID"+
						 " and advise_no is null"+
						 " and PC_ADVISE_ID in (";
			for (int i=0; i< chk.length ;i++)
			{
				if (i==chk.length-1)
				{
					sql +=  (chk[i]+")");
				}
				else
				{
					sql +=  (chk[i]+",");
				}
			}	
			//sql += " group by a.CUSTOMER_ID,c.CUSTOMER_NAME_PHONETIC,a.SHIP_TO_ORG_ID ,REGION_CODE,SHIPPING_METHOD ,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),TO_TW,a.VENDOR_SITE_ID,b.vendor_site_code,a.currency_code,case when length(a.SHIPPING_REMARK)>2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' ELSE 'N/A' END "+
			//      " order by to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),a.VENDOR_SITE_ID,a.REGION_CODE,a.SHIP_TO_ORG_ID ";
			sql += " group by Case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1  when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 ELSE a.CUSTOMER_ID END,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),TO_TW,a.VENDOR_SITE_ID,b.vendor_site_code"+
		           ",case when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				   " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				   " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) ='151' then 'PHIHONG(3)' "+ 
  				   " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				   " when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				   " when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+
  				   " when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
                   " ELSE 'N/A' END"+
				   //",case when a.to_tw ='N' and a.REGION_CODE='TSCJ' THEN  a.SHIP_TO_ORG_ID ELSE 0 END"+ 
				   ",case when a.to_tw ='N' and a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT')  THEN  a.SHIP_TO_ORG_ID ELSE 0 END"+ 
                   " order by to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),a.VENDOR_SITE_ID,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end";
			//out.println(sql);
			Statement statement8=con.createStatement();
			ResultSet rs8=statement8.executeQuery(sql);
			while (rs8.next())
			{
				sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				if (rs.next())
				{
					ADVISE_NO = rs.getString(1);
				}
				else
				{
					sql = " insert into tsc.tsc_shipping_advise_no(shipping_date, seq_no) values (trunc(sysdate),1)";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.executeUpdate();
					pstmtDt.close();	
					
					sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
					Statement statement1=con.createStatement();
					ResultSet rs1=statement1.executeQuery(sql);
					if (rs1.next())
					{
						ADVISE_NO = rs1.getString(1);
					}	
					rs1.close();
					statement1.close();						
				}
				rs.close();
				statement.close();
				
				if (!ADVISE_NO.equals(""))
				{
					sql = " update tsc.tsc_shipping_advise_no set seq_no = seq_no +1 where shipping_date = trunc(sysdate)";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.executeUpdate();
					pstmtDt.close();				
				}
				else
				{
					throw new Exception("Advise No產生失敗!!");
				}
				
				sql = " update tsc.tsc_shipping_advise_pc_tew a"+
					  " set advise_no=?"+
					  ",orig_advise_no=?"+
					  " where advise_no is null"+
					  " and case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1 when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 ELSE a.CUSTOMER_ID END=?"+
			          " and case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end =?"+
			          " and case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end=?"+
			          " and to_char(PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd')=?"+
					  " and TO_TW=?"+
					  " and VENDOR_SITE_ID=?"+
					  " and case when REGION_CODE ='TSCH-HK' and  length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				      " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				      " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
  				      " when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				      " when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				      " when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') > 0 THEN '駱騰' "+
    				  " when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
					  " ELSE 'N/A' END=?"+
					  //" and case when a.to_tw ='N' and a.REGION_CODE='TSCJ' THEN  a.SHIP_TO_ORG_ID ELSE 0 END=?"+
					  " and case when a.to_tw ='N' and a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT') THEN  a.SHIP_TO_ORG_ID ELSE 0 END=?"+
					  " and PC_ADVISE_ID in (";
				for (int i=0; i< chk.length ;i++)
				{
					if (i==chk.length-1)
					{
						sql +=  (chk[i]+")");
					}
					else
					{
						sql +=  (chk[i]+",");
					}
				}					
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.setString(3,rs8.getString("CUSTOMER_ID"));
				pstmtDt.setString(4,rs8.getString("REGION_CODE"));
				pstmtDt.setString(5,rs8.getString("SHIPPING_METHOD"));
				pstmtDt.setString(6,rs8.getString("PC_SCHEDULE_SHIP_DATE"));
				pstmtDt.setString(7,rs8.getString("TO_TW"));
				pstmtDt.setString(8,rs8.getString("VENDOR_SITE_ID"));
				//pstmtDt.setString(9,rs8.getString("CURRENCY_CODE"));
				//pstmtDt.setString(10,rs8.getString("SHIP_TO_ORG_ID"));
				pstmtDt.setString(9,rs8.getString("SHIPPING_REMARK"));
				pstmtDt.setString(10,rs8.getString("ship_to_org_id"));
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				if (!AdviseNoList.equals("")) AdviseNoList +=",";
				AdviseNoList += "'"+ADVISE_NO+"'";
				if (AdviseList.equals(""))
				{
					AdviseList =" <table  align='center' width='100%' border='1'  bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>"+
					            " <tr bgcolor='#64B077' style='font-family:細明體;font-size:11px;color:#ffffff'><td>Advise No</td><td>供應商</td><td>業務區</td><td>出貨方式</td><td>出貨日期</td><td>回T</td></tr>";
				}
				AdviseList += " <tr style='font-family:細明體;font-size:11px'><td>"+ADVISE_NO+"</td><td>"+rs8.getString("vendor_site_code")+"</td><td>"+rs8.getString("REGION_CODE")+"</td><td>"+rs8.getString("SHIPPING_METHOD")+"</td><td>"+rs8.getString("PC_SCHEDULE_SHIP_DATE")+"</td><td>"+(rs8.getString("TO_TW").equals("Y")?"是":"否")+"</td></tr>";
				Advise_Cnt++;
			}
			
			rs8.close();
			statement8.close();		
			con.commit();	
			if (Advise_Cnt>0)
			{
				out.println("<table width='40%' align='center'><tr><td align='left' width='80%'><div align='cneter' style='color:#0000ff;font-size:12px'>動作成功!!共產生"+Advise_Cnt+"筆Advise，如下表所示..</DIV></td>");
				out.println("<td align='left' width='20%'><div align='right' style='color:#0000ff;font-size:12px'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
				%>
				<jsp:getProperty name="rPH" property="pgHOME"/>
				<%
				out.println("</A></DIV></td></tr>");
				out.println("<tr><td colspan='2'>");
				out.println(AdviseList+"</table>");
				out.println("</td></tr>");
				out.println("<tr><td align='center' colspan='2'><a href='TEWShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TEWShippingAdviseExcel.jsp?ADVISENOLIST="+AdviseNoList+'"'+">下載出貨通知單</a></td></tr>");
				out.println("</table>");
			}
			else
			{
				throw new Exception("查無出貨通知待確認資料!!");
			}	
		}			
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<table width='80%' align='center'><tr><td align='center'>");
		out.println("<div align='center'><font color='red'>交易失敗,請速洽系統管理人員,謝謝!!</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><font color='red'>"+e.getMessage()+"</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><a href='TEWShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div>");
		out.println("</td></tr>");
		out.println("</table>");
	}		
}
else if (TRANSTYPE.equals("DELETE"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無刪除資料!!");
		}	
		else
		{
			for (int i=0; i< chk.length ;i++)
			{
				sql = " delete tsc.tsc_shipping_advise_pc_tew a"+
					  " where PC_ADVISE_ID=?"+
					  " and advise_no is null";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " delete tsc.tsc_shipping_po_price a"+
					  " where PC_ADVISE_ID=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();				
			}
			con.commit();
			out.println("<table width='80%' valign='center' align='center'><tr><td align='center' colspan='2'><div align='cneter' style='color:#0000ff;font-size:16px'>資料刪除成功!!</DIV></td></tr>");
			out.println("<tr><td colspan='2'>&nbsp;</td></tr>");
			out.println("<tr><td width='45%' align='center'><div align='right' style='color:#0000ff;font-size:12x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
			%>
			<jsp:getProperty name="rPH" property="pgHOME"/>
			<%
			out.println("</A></DIV></td>");
		    out.println("<td width='55%' ><div align='left'>&nbsp;&nbsp;&nbsp;<a href='TEWShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div></td>");
			out.println("</tr>");
			out.println("</table>");
		}		
	}
	catch(Exception e)
	{
        con.rollback();
		out.println("<table width='80%' align='center'><tr><td align='center'>");
		out.println("<div align='center'><font color='red'>交易失敗,請速洽系統管理人員,謝謝!!</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><font color='red'>"+e.getMessage()+"</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><a href='TEWShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div>");
		out.println("</td></tr>");
		out.println("</table>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

