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
<title>SG Shipping Advise Process</title>
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
<FORM ACTION="TSCSGShippingAdviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

String sql ="",NEW_ADVISE_NO="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
int item_limit_cnt =50;

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
			
			//檢查是否重複拋單,add by Peggy 20200326
			sql = " select so_line_id,so_qty,ship_qty,to_char(pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date "+
			      ",row_number() over (partition by so_line_id order by trunc(pc_schedule_ship_date)) row_seq"+
				  ",count(so_line_id) over (partition by so_line_id) row_cnt"+
			      " from tsc.tsc_shipping_advise_pc_sg where so_line_id ="+chk[i]+" ";
			Statement statementc=con.createStatement();
			ResultSet rsc=statementc.executeQuery(sql);
			while (rsc.next())
			{
				//if (rsc.getLong("ship_qty") == ACT_SHIP_QTY && rsc.getString("pc_schedule_ship_date").equals(request.getParameter("ACT_SHIP_DATE_"+chk[i])))
				//{
				//	rsc.close();
				//	statementc.close();				
				//	throw new Exception("訂單:"+request.getParameter("ORDER_NUMBER_"+chk[i])+"  項次:"+request.getParameter("ORDER_LINE_"+chk[i])+"出貨數量與交期不可重複!!");
				//}
				TOT_SHIP_QTY += rsc.getLong("ship_qty");
				if (rsc.getInt("row_seq")==rsc.getInt("row_cnt"))
				{
					TOT_SHIP_QTY += ACT_SHIP_QTY;
					if (TOT_SHIP_QTY>rsc.getLong("so_qty"))
					{
						throw new Exception("訂單:"+request.getParameter("ORDER_NUMBER_"+chk[i])+"  項次:"+request.getParameter("ORDER_LINE_"+chk[i])+"排定出貨量("+TOT_SHIP_QTY+")不可大於出貨量("+rsc.getLong("so_qty")+")!!");
					}
				}
			}
			rsc.close();
			statementc.close();
			
			//add by Peggy 20211109
			if (request.getParameter("VENDOR_SITE_ID_"+chk[i])==null || request.getParameter("VENDOR_SITE_ID_"+chk[i]).equals("") || request.getParameter("VENDOR_SITE_ID_"+chk[i]).equals("--"))
			{
				throw new Exception("訂單:"+request.getParameter("ORDER_NUMBER_"+chk[i])+"  項次:"+request.getParameter("ORDER_LINE_"+chk[i])+" 必須指定來源供應商!!");
			}
			
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(" SELECT TSC_SHIPPING_ADVISE_PC_S.nextval from dual");
			if (rs1.next())
			{
				PC_ADVISE_ID = rs1.getString(1);
			}
			else
			{
				rs1.close();
				statement1.close();		
				throw new Exception("PC Advise Id取得失敗!!");
			}
			rs1.close();
			statement1.close();		
					
			//out.println("**"+chk[i]+"<br>");
			sql = " insert into tsc.tsc_shipping_advise_pc_sg "+
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
				  " vendor_site_id,"+
				  " org_id"+
				  ")"+
				  " select a.HEADER_ID SO_HEADER_ID,"+
				  " b.LINE_ID SO_LINE_ID,"+
				  " a.order_number SO_NO,"+
				  " b.line_number ||'.'|| b.shipment_number SO_LINE_NUMBER,"+
				  " b.ship_from_org_id ORGANIZATION_ID,"+
				  " b.inventory_item_id,"+
				  " c.segment1 ITEM_NO,"+
				  " c.description ITEM_DESC,"+
				  " TSC_INV_Category(b.INVENTORY_ITEM_ID, 43, 1100000003) PRODUCT_GROUP,"+
				  " a.sold_to_org_id CUSTOMER_ID,"+
				  " case when ?='Y' and ((substr(a.order_number,1,4)<>'1121' and (instr(d.meaning,'AIR')<=0 and instr(d.meaning,'UPS')<=0 and instr(d.meaning,'DHL')<=0 and instr(d.meaning,'FEDEX')<=0)) or (substr(a.order_number,1,4)='1121' and instr(d.meaning,'UPS')<=0 and instr(d.meaning,'DHL')<=0 and instr(d.meaning,'FEDEX')<=0 and instr(d.meaning,'TNT')<=0)) then 'SEA(C)' else d.meaning end as SHIPPING_METHOD,"+
				  " case when mp.organization_code IN ('SG1','SG2') THEN mp.organization_code ELSE 'TEW' END SHIPPING_FROM,"+
				  " b.ordered_quantity SO_QTY,"+
				  " null DN_QTY,"+
				  " ? SHIP_QTY,"+
				  " ? onhand,"+
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
				  " case when substr(a.order_number,1,4) in ('8131') then TSC_GET_REMARK_DESC(a.HEADER_ID,'SHIPPING MARKS') else ?  end SHIPPING_REMARK,"+
				  " ? REGION_CODE,"+
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
				  " TSC_INV_Category(b.INVENTORY_ITEM_ID, 43, 23) AS TSC_PACKAGE,"+
				  " TSC_INV_Category(b.INVENTORY_ITEM_ID, 43, 21) AS TSC_FAMILY,"+
				  " tsc_get_item_packing_code(49,b.inventory_item_id) PACKING_CODE,"+
				  " 0 SHIP_ADVISE_QTY,"+
				  " ?,"+
				  " b.SHIPPING_METHOD_CODE,"+
				  " b.FOB_POINT_CODE FOB,"+
				  " NULL SHIP_TO_CONTACT_NAME,"+
				  " NULL TAX,"+
				  " g.customer_name,"+
				  //" h.MEDIA_ID,"+
				  " (SELECT MEDIA_ID FROM fnd_attached_docs_form_vl fadfv WHERE fadfv.function_name = 'OEXOEORD' AND fadfv.category_description = 'SHIPPING MARKS' AND fadfv.pk1_value = TO_CHAR(a.header_id)  AND fadfv.ENTITY_NAME = 'OE_ORDER_HEADERS' AND fadfv.pk2_value is null AND fadfv.pk3_value is null),"+ //解決run太久問題,add by Peggy 20200224
				  " null FILE_ID,"+
				  " null INVOICE_NO,"+
				  " null CARTON_NO_FROM,"+
				  " null CARTON_NO_TO,"+
				  //" case when length(h.description)>=12 and substr(h.description ,1,12)='CHANNEL WELL' then 'D' when instr(h.description ,'駱騰')>0 then 'I' "+
				  " case when length(case when substr(a.order_number,1,4) in ('8131') then TSC_GET_REMARK_DESC(a.HEADER_ID,'SHIPPING MARKS') else ?  end)>=12 and substr( case when substr(a.order_number,1,4) in ('8131') then TSC_GET_REMARK_DESC(a.HEADER_ID,'SHIPPING MARKS') else ?  end ,1,12)='CHANNEL WELL' then 'D' "+
				  "      when instr(case when substr(a.order_number,1,4) in ('8131') then TSC_GET_REMARK_DESC(a.HEADER_ID,'SHIPPING MARKS') else ?  end ,'駱騰')>0 then 'I' "+
				  "      when a.sold_to_org_id = 449294 then TSSG_SHIP_PKG.GET_SHIP_WEEK(TO_DATE(?,'YYYYMMDD')) "+ //Tantron by周編碼,add by Peggy 20221027
				  "      else 'A' end as box_code,"+  //ivy 9/17回覆統一為A
				  " null CARTON_PER_QTY,"+
				  " sysdate LAST_UPDATE_DATE,"+
				  " ? LAST_UPDATED_BY,"+
				  " sysdate CREATION_DATE,"+
				  " ? CREATED_BY,"+
				  " null LAST_UPDATE_LOGIN,"+
				  " ? TO_TW,"+
				  " ? vendor_site_id,"+
				  " a.org_id"+
				  " from ont.oe_order_headers_all a,"+
				  " ont.oe_order_lines_all b,"+
				  " inv.mtl_system_items_b c,"+
				  " (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') d ,"+
				  " (select * from ra_terms_tl where LANGUAGE='US') e,"+
				  " (select * from (select source_header_id,source_line_id,DELIVERY_DETAIL_ID,row_number() over(partition by source_header_id,source_line_id order by nvl(SPLIT_FROM_DELIVERY_DETAIL_ID,0) desc,CREATION_DATE) seq_no from wsh.wsh_delivery_details where source_line_id=?) where seq_no =1) f,"+  
				  " AR_CUSTOMERS g,"+
				  //" (SELECT y.description ,z.pk1_value,x.MEDIA_ID from fnd_documents_tl y,fnd_attached_documents z ,fnd_documents x where x.DOCUMENT_ID=y.DOCUMENT_ID AND y.language = 'US' and  x.DOCUMENT_ID=z.DOCUMENT_ID  and exists (select 1  from fnd_document_categories_tl r WHERE r.USER_NAME='SHIPPING MARKS' AND r.LANGUAGE='US' and r.category_id = x.category_id)) h, "+
				  " inv.mtl_parameters mp"+
				  " where a.header_id = b.header_id "+
				  " and b.ship_from_org_id = c.organization_id"+
				  " and b.inventory_item_id = c.inventory_item_id"+
				  " AND b.SHIPPING_METHOD_CODE = d.lookup_code (+)"+
				  " AND NVL(b.payment_term_id,a.payment_term_id) =e.term_id"+
				  " AND b.header_id = f.source_header_id"+
				  " and b.line_id = f.source_line_id"+
				  " and a.sold_to_org_id = g.customer_id"+
				  //" and a.header_id = h.pk1_value(+)"+
				  " and b.ship_from_org_id=mp.organization_id"+
				  " and b.line_id=?";
			/*out.println(sql);
			out.println(request.getParameter("TO_TW_"+chk[i]));
			out.println(ACT_SHIP_QTY);
			out.println(request.getParameter("ONHAND_"+chk[i]));
			out.println(request.getParameter("ACT_SHIP_DATE_"+chk[i]));
			out.println(request.getParameter("SHIPPING_REMARK_"+chk[i]));
			out.println(request.getParameter("SALES_GROUP_"+chk[i]));
			out.println(PC_ADVISE_ID);
			out.println(ERPUSERID);
			out.println(request.getParameter("VENDOR_SITE_ID_"+chk[i]));
			out.println(chk[i]);*/
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("TO_TW_"+chk[i]));
			pstmtDt.setString(2,""+ACT_SHIP_QTY);
			pstmtDt.setString(3,(request.getParameter("ONHAND_"+chk[i])==null||request.getParameter("ONHAND_"+chk[i]).equals("null")?"0":request.getParameter("ONHAND_"+chk[i])));
			pstmtDt.setString(4,""+ACT_SHIP_QTY);
			pstmtDt.setString(5,request.getParameter("ACT_SHIP_DATE_"+chk[i]));
			pstmtDt.setString(6,request.getParameter("SHIPPING_REMARK_"+chk[i]));
			pstmtDt.setString(7,request.getParameter("SALES_GROUP_"+chk[i]));
			pstmtDt.setString(8,PC_ADVISE_ID);
			//pstmtDt.setString(9,request.getParameter("VENDORSITE_"+chk[i]));
			pstmtDt.setString(9,request.getParameter("SHIPPING_REMARK_"+chk[i]));
			pstmtDt.setString(10,request.getParameter("SHIPPING_REMARK_"+chk[i]));
			pstmtDt.setString(11,request.getParameter("SHIPPING_REMARK_"+chk[i]));
			pstmtDt.setString(12,request.getParameter("ACT_SHIP_DATE_"+chk[i]));
			pstmtDt.setString(13,ERPUSERID);
			pstmtDt.setString(14,ERPUSERID);
			pstmtDt.setString(15,request.getParameter("TO_TW_"+chk[i]));
			pstmtDt.setString(16,request.getParameter("VENDOR_SITE_ID_"+chk[i]));
			pstmtDt.setString(17,chk[i]);
			pstmtDt.setString(18,chk[i]); 
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			//out.println(chk[i]+"<br>");
			TOT_SHIP_QTY=0;
			
			//客戶MILLENNIUM INDIA 型號:BZT52B36S RRG  cust po:4500000141/4500000211/4500000212/4500000213/4500000214/4500000215/4500000219 指定出貨po by Peggy 20230508
			sql = " SELECT INVENTORY_ITEM_ID "+
                  " FROM (SELECT A.HEADER_ID,A.ORDER_NUMBER,A.SOLD_TO_ORG_ID,B.INVENTORY_ITEM_ID,NVL((SELECT SOLD_TO_ORG_ID FROM ONT.OE_ORDER_HEADERS_ALL C where C.ORDER_NUMBER=a.ORDER_NUMBER and C.ORG_ID=41),A.SOLD_TO_ORG_ID) TSC_CUSTOMER_ID"+
                  " FROM ONT.OE_ORDER_HEADERS_ALL A"+
                  ",ONT.OE_ORDER_LINES_ALL B"+
                  " WHERE A.HEADER_ID=B.HEADER_ID"+
                  " AND B.LINE_ID=?"+
                  " AND B.INVENTORY_ITEM_ID in (?,?,?)"+
                  " AND REPLACE(B.cust_po_number,'''','') IN (?,?,?,?,?,?,?)) x"+
                  " WHERE x.TSC_CUSTOMER_ID=?";
			PreparedStatement statement09 = con.prepareStatement(sql);
			statement09.setString(1,chk[i]);
			statement09.setInt(2,599237);
			statement09.setInt(3,156656);	
			statement09.setInt(4,790576);					
			statement09.setString(5,"4500000141");
			statement09.setString(6,"4500000211");
			statement09.setString(7,"4500000212");
			statement09.setString(8,"4500000213"); 
			statement09.setString(9,"4500000214"); 
			statement09.setString(10,"4500000215"); 	
			statement09.setString(11,"4500000219"); 
			statement09.setInt(12,847292);															 
			ResultSet rs09=statement09.executeQuery();
			if (rs09.next())
			{
				sql = " insert into tsc.tsc_shipping_po_price_sg(pc_advise_id, po_header_id, po_unit_price,ORDER_QTY,CUST_PARTNO,INVENTORY_ITEM_ID,PC_ADVISE_PRICE_ID)"+
					  " SELECT ?,A.PO_HEADER_ID,A.UNIT_PRICE,?,?,A.ITEM_ID,TSC_ADVISE_PC_PRICE_ID_S.NEXTVAL "+
					  " FROM (SELECT DISTINCT A.PO_HEADER_ID,MIN(B.UNIT_PRICE) UNIT_PRICE,B.ITEM_ID"+
                      "       FROM PO_HEADERS_ALL A,PO_LINES_ALL B "+
                      "       WHERE A.PO_HEADER_ID=B.PO_HEADER_ID"+
                      "       AND A.SEGMENT1=?"+
					  "       AND B.ITEM_ID=?"+
                      "       GROUP BY A.PO_HEADER_ID,B.ITEM_ID) A";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,PC_ADVISE_ID);
				pstmtDt.setString(2,""+ACT_SHIP_QTY);
				pstmtDt.setString(3,"N/A");
				pstmtDt.setString(4,"62023050025");	
				pstmtDt.setInt(5,rs09.getInt("INVENTORY_ITEM_ID"));							
				pstmtDt.executeQuery();
				pstmtDt.close();			
			}
			else
			{			
				String ShipArray[][]= MOShipBean.getArray2DContent();
				if (ShipArray!=null)
				{
					for( int j=0 ; j< ShipArray.length ; j++ ) 
					{
						if (ShipArray[j][0].equals(chk[i]))
						{
							//out.println("ShipArray["+j+"][0]="+ShipArray[j][0]);
							//out.println("chk[i]="+chk[i]);
							//if (Float.parseFloat(ShipArray[j][8])==0) continue;
							
							sql = " select 1 from tsc.tsc_shipping_po_price_sg where pc_advise_id=? and po_header_id=? and po_unit_price=? and CUST_PARTNO=? and INVENTORY_ITEM_ID=?";
							PreparedStatement statement9 = con.prepareStatement(sql);
							statement9.setString(1,PC_ADVISE_ID);
							statement9.setString(2,ShipArray[j][1]);
							statement9.setString(3,ShipArray[j][4]);
							statement9.setString(4,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
							statement9.setString(5,ShipArray[j][9]); 
							ResultSet rs9=statement9.executeQuery();
							if (rs9.next())
							{
								sql = " UPDATE tsc.tsc_shipping_po_price_sg"+
									  " SET ORDER_QTY=ORDER_QTY+?"+
									  " where pc_advise_id=? and po_header_id=? and po_unit_price=? and CUST_PARTNO=? and INVENTORY_ITEM_ID=?";
								pstmtDt=con.prepareStatement(sql);  
								pstmtDt.setString(1,ShipArray[j][8]);
								pstmtDt.setString(2,PC_ADVISE_ID);
								pstmtDt.setString(3,ShipArray[j][1]);
								pstmtDt.setString(4,ShipArray[j][4]);
								pstmtDt.setString(5,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
								pstmtDt.setString(6,ShipArray[j][9]);
								pstmtDt.executeQuery();
								pstmtDt.close();						
							}
							else
							{
								sql = " insert into tsc.tsc_shipping_po_price_sg(pc_advise_id, po_header_id, po_unit_price,ORDER_QTY,CUST_PARTNO,INVENTORY_ITEM_ID,PC_ADVISE_PRICE_ID)"+
									  " select ?,?,?,?,?,?,TSC_ADVISE_PC_PRICE_ID_S.NEXTVAL from dual";
								pstmtDt=con.prepareStatement(sql);  
								pstmtDt.setString(1,PC_ADVISE_ID);
								pstmtDt.setString(2,ShipArray[j][1]);
								pstmtDt.setString(3,ShipArray[j][4]);
								pstmtDt.setString(4,ShipArray[j][8]);
								pstmtDt.setString(5,(ShipArray[j][7]==null||ShipArray[j][7].equals("null")||ShipArray[j][7].equals("")?"N/A":ShipArray[j][7]));
								pstmtDt.setString(6,ShipArray[j][9]);
								pstmtDt.executeQuery();
								pstmtDt.close();
							}
							rs9.close();
							statement9.close();
							TOT_SHIP_QTY += Long.parseLong(ShipArray[j][8]); 						
						}
					}
				}
			}
			rs09.close();
			statement09.close();
			
			if (ACT_SHIP_QTY != TOT_SHIP_QTY && TOT_SHIP_QTY>0)
			{
				throw new Exception("排定出貨量與分配出貨量不符(ACT SHIP QTY="+ACT_SHIP_QTY+"<>TOT SHIP QTY="+TOT_SHIP_QTY+")+!");
			}
						
		}	
		con.commit();
		MOShipBean.setArray2DString(null); 
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!!若要進行出貨通知確認動作,請按確定鍵,否則按下取消鍵,回到出貨通知排定功能!!"))
			{
				setSubmit("../jsp/TSCSGShippingAdviseConfirm.jsp");
			}
			else
			{
				setSubmit("../jsp/TSCSGShippingAdvise.jsp");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGShippingAdvise.jsp'>回出貨通知排定功能</a></font>");
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
			sql = " update tsc.tsc_shipping_advise_pc_sg a"+
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
				sql = " update tsc.tsc_shipping_advise_pc_sg a"+
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
			if (!AdviseNoList.equals("")) AdviseNoList +=",";
			AdviseNoList += "'"+ADVISE_NO+"'";			
			
			con.commit();
			out.println("<table width='80%' align='center'><tr><td align='center'><div align='cneter' style='color:#0000ff;font-size:12px'>動作成功!!資料已加入Advise No："+ADVISE_NO+"</DIV></td></tr>");
			out.println("<tr><td align='center'><div align='center' style='color:#0000ff;font-size:12x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
			%>
			<jsp:getProperty name="rPH" property="pgHOME"/>
			<%
			out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSCSGShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TSCSGShippingAdviseExcel.jsp?ADVISE_NO="+ADVISE_NO+'"'+">Download Shipping Advise</a></td></tr>");
			out.println("</table>");
		}
		else if (rdoValue.equals("NEW"))  
		{
			sql = " select a.shipping_from"+
			             " ,case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)')  AND a.to_tw ='N' THEN 1 "+
			             "       when a.to_tw ='Y' THEN 2 "+
						 "       when a.REGION_CODE='TSCT-Disty' THEN 3 "+
						 "       else a.CUSTOMER_ID END AS CUSTOMER_ID"+
			             //" ,case when a.to_tw ='Y' AND  UPPER(a.region_code)<>'SAMPLE' then 'TSCT' else a.REGION_CODE end REGION_CODE"+
						 " ,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end REGION_CODE"+  //1121與1131/1141合併回T,modify by Peggy 20200417
			             //" ,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end as SHIPPING_METHOD "+
						 " ,case when a.to_tw ='Y' and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end as SHIPPING_METHOD "+ //modify by Peggy 20220728
			             " ,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
						 " ,a.TO_TW"+
						 " ,case when a.shipping_from  LIKE 'SG%' then 0 else a.VENDOR_SITE_ID end VENDOR_SITE_ID"+
						 //" ,case when a.shipping_from ='SG' then 'N/A' "+
						 //" ,case when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' "+
						 //"       when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=6 and upper(substr(a.SHIPPING_REMARK,1,6))='FUTURE' THEN 'FUTURE' "+
						 " ,case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD' "+
						 "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  not in ('104','151') then 'PHIHONG(1)' "+ 
						 "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
						 "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
						 "       when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
						 "       when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+
						 "       when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216
						 "       when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ 
						 "       when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
						 //"       when substr(a.so_no,1,4)<>'1121' and a.to_tw ='Y' then 'T'"+
						 //"       when substr(a.SO_NO,1,4)='1121' then 'T(SAMPLE)' "+
						 //"       else a.SHIPPING_REMARK END AS SHIPPING_REMARK"+
						 " ELSE 'N/A' END AS SHIPPING_REMARK"+
						 //",case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+  //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
						 ",case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or (a.REGION_CODE in ('TSCK') and instr(a.SHIPPING_REMARK,'LG DD')>0) or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+  //add tsck LG DD by Peggy 20200716
						 ",case a.shipping_from when 'SG1' then '內銷' when 'SG2' THEN '外銷' ELSE a.shipping_from END shipping_from_name"+
			             " from tsc.tsc_shipping_advise_pc_sg a"+
						 ",AR_CUSTOMERS c"+
						 ",inv.mtl_parameters mp"+
			             " where a.CUSTOMER_ID = c.CUSTOMER_ID"+
						 " and a.organization_id=mp.organization_id"+
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
			sql += " group by a.shipping_from"+
			       " ,case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1  when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 ELSE a.CUSTOMER_ID END"+
				   //" ,case when a.to_tw ='Y' AND  UPPER(a.region_code)<>'SAMPLE' then 'TSCT' else a.REGION_CODE end"+
				   " ,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end"+  //1121與1131/1141合併回T,modify by Peggy 20200417
				   //" ,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end"+
				   " ,case when a.to_tw ='Y' and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end"+ //modify by Peggy 20220728
				   ",to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd')"+
				   ",TO_TW"+
				   ",case when a.shipping_from  LIKE 'SG%' then 0 else a.VENDOR_SITE_ID end "+
				   ",a.organization_id"+
				   //",case when a.shipping_from ='SG' then 'N/A'"+
				   //",case when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' "+
				   //"      when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=6 and upper(substr(a.SHIPPING_REMARK,1,6))='FUTURE' THEN 'FUTURE' "+
				   ",case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				   "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				   "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) ='151' then 'PHIHONG(3)' "+ 
  				   "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				   "      when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				   "      when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+
				   "      when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216				   
  				   "      when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
				   "      when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
				   //"      when substr(a.so_no,1,4)<>'1121' and a.to_tw ='Y' then 'T'"+
				   //"      when substr(a.SO_NO,1,4)='1121' then 'T(SAMPLE)' "+
                   "      else 'N/A' END"+
				   //",case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END"+  //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
				   ",case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or (a.REGION_CODE in ('TSCK') and instr(a.SHIPPING_REMARK,'LG DD')>0) or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END"+  //add tsck LG DD by Peggy 20200716
                  // " order by to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),case when a.to_tw ='Y' AND  UPPER(a.region_code)<>'SAMPLE' then 'TSCT' else a.REGION_CODE end";
				   " order by to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end";
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
				//out.println("xxx");
				sql = " update tsc.tsc_shipping_advise_pc_sg a"+
					  " set advise_no=?"+
					  ",orig_advise_no=?"+
					  " where advise_no is null"+
					  " and a.shipping_from=?"+
					  " and case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1 when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 ELSE a.CUSTOMER_ID END=?"+
			          //" and case when a.to_tw ='Y' AND  UPPER(a.region_code)<>'SAMPLE' then 'TSCT' else a.REGION_CODE end =?"+
			  	      " and case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end =?"+  //1121與1131/1141合併回T,modify by Peggy 20200417
			          //" and case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end=?"+
					  " and case when a.to_tw ='Y' and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end=?"+  //modify by Peggy 20220728
			          " and to_char(PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd')=?"+
					  " and TO_TW=?"+
					  " and case when a.shipping_from LIKE 'SG%' then 0 else VENDOR_SITE_ID end=? "+
					  //" and case when a.shipping_from ='SG' then 'N/A'"+
					  //" and case when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=2 and substr(a.SHIPPING_REMARK,1,2)='GE' THEN 'GE' "+
					  //"          when a.REGION_CODE ='TSCH-HK' and length(a.SHIPPING_REMARK)>=6 and  upper(substr(a.SHIPPING_REMARK,1,6))='FUTURE' THEN 'FUTURE' "+
					  " and case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
  				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				      "          when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				      "          when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') > 0 THEN '駱騰' "+
				      "          when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216					  
    				  "          when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
				      "          when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
  					  //"          when substr(a.so_no,1,4)<>'1121' and a.to_tw ='Y' then 'T'"+
     				  //"          when substr(a.SO_NO,1,4)='1121' then 'T(SAMPLE)' "+
					  "          else 'N/A' END=?"+
					  //" and case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END=?"+ //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
					  " and case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or (a.REGION_CODE in ('TSCK') and instr(a.SHIPPING_REMARK,'LG DD')>0) or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END=?"+ //add tsck LG DD by Peggy 20200716
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
				//out.println(sql);
				//out.println(ADVISE_NO);
				//out.println(rs8.getString("SHIPPING_FROM"));
				//out.println(rs8.getString("CUSTOMER_ID"));
				//out.println(rs8.getString("REGION_CODE"));
				//out.println(rs8.getString("SHIPPING_METHOD"));
				//out.println(rs8.getString("PC_SCHEDULE_SHIP_DATE"));
				//out.println(rs8.getString("TO_TW"));
				//out.println(rs8.getString("vendor_site_id"));
				//out.println(rs8.getString("SHIPPING_REMARK"));
				//out.println(rs8.getString("ship_to_org_id"));
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.setString(3,rs8.getString("SHIPPING_FROM"));
				pstmtDt.setString(4,rs8.getString("CUSTOMER_ID"));
				pstmtDt.setString(5,rs8.getString("REGION_CODE"));
				pstmtDt.setString(6,rs8.getString("SHIPPING_METHOD"));
				pstmtDt.setString(7,rs8.getString("PC_SCHEDULE_SHIP_DATE"));
				pstmtDt.setString(8,rs8.getString("TO_TW"));
				pstmtDt.setString(9,rs8.getString("vendor_site_id"));
				pstmtDt.setString(10,rs8.getString("SHIPPING_REMARK"));
				pstmtDt.setString(11,rs8.getString("ship_to_org_id"));
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				if (!AdviseNoList.equals("")) AdviseNoList +=",";
				AdviseNoList += "'"+ADVISE_NO+"'";
				if (AdviseList.equals(""))
				{
					AdviseList =" <table  align='center' width='100%' border='1'  bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>"+
					            " <tr bgcolor='#64B077' style='font-family:Tahoma,Georgia;font-size:11px;color:#ffffff'><td>Advise No</td><td>內外銷</td><td>Shipping Marks</td><td>Sales Region</td><td>Shipping Method</td><td>PC SSD</td><td>To TW</td></tr>";
				}
				AdviseList += " <tr style='font-family:Tahoma,Georgia;font-size:11px'><td>"+ADVISE_NO+"</td><td>"+(rs8.getString("shipping_from_name")==null?"N/A":rs8.getString("shipping_from_name"))+"</td><td>"+rs8.getString("SHIPPING_REMARK")+"</td><td>"+rs8.getString("REGION_CODE")+"</td><td>"+rs8.getString("SHIPPING_METHOD")+"</td><td>"+rs8.getString("PC_SCHEDULE_SHIP_DATE")+"</td><td>"+(rs8.getString("TO_TW").equals("Y")?"是":"否")+"</td></tr>";
				Advise_Cnt++;
								
				//advise最多50個item,add by Peggy 20200603
				/*sql = " select y.*"+
				      ",ceil( y.item_cnt/?) advise_rank"+
					  ",mod( y.item_cnt ,?) advise_seq"+
                      " from (select x.*,dense_rank() over (partition by x.advise_no order by x.ITEM_TOT_CNT desc,x.item_desc) item_cnt from (select a.advise_no,a.pc_advise_id,a.item_desc,count(1) over (partition by a.advise_no,a.item_desc) item_tot_cnt"+
                      " from tsc.tsc_shipping_advise_pc_sg a"+
                      " where  advise_no =?) x"+
                      " order by x.ITEM_TOT_CNT desc,x.item_desc) y where ceil( y.item_cnt/?)>1";*/
				/*sql = " select y.*"+
				      ",row_number() over (partition by y.advise_no,y.advise_rank order by y.item_cnt,y.pc_advise_id) advise_seq"+
                      " from (select x.*,dense_rank() over (partition by x.advise_no order by x.rank_seq) item_cnt "+
                      ",ceil(dense_rank() over (partition by x.advise_no order by x.rank_seq)/?)  advise_rank"+
                      " from (select  a.advise_no,a.pc_advise_id,a.product_group,a.vendor_site_id,a.customer_id,a.item_desc,b.rank_seq"+
                      "       from tsc.tsc_shipping_advise_pc_sg a,(select x.advise_no,x.item_desc,min(rank_seq) rank_seq"+
                      "            from (select a.advise_no,a.pc_advise_id,a.item_desc,dense_rank() over (order by a.PRODUCT_GROUP,a.VENDOR_SITE_ID,a.CUSTOMER_ID,a.ITEM_DESC,a.REGION_CODE) rank_seq"+
                      "                  from tsc.tsc_shipping_advise_pc_sg a"+
                      "             where  advise_no =?) x "+
                      "         group by x.advise_no,x.item_desc) b"+
                      " where a.advise_no=b.advise_no"+
                      " and a.item_desc=b.item_desc"+
                      " and a.advise_no =?"+
                      " order by b.advise_no,b.rank_seq) x"+
                      "  order by x.rank_seq) y "+
                      "  where ceil( y.item_cnt/?)>1  "+
                      "  order by advise_rank,item_cnt";
					 */
				//加vendor_site_id條件,add by Peggy 20211008
				sql = " select y.*"+
				      ",row_number() over (partition by y.advise_no,y.advise_rank order by y.item_cnt,y.pc_advise_id) advise_seq"+
                      " from (select x.*,dense_rank() over (partition by x.advise_no order by x.rank_seq) item_cnt "+
                      ",ceil(dense_rank() over (partition by x.advise_no order by x.rank_seq)/?)  advise_rank"+
                      " from (select  a.advise_no,a.pc_advise_id,a.product_group,a.vendor_site_id,a.customer_id,a.item_desc,b.rank_seq"+
                      "       from tsc.tsc_shipping_advise_pc_sg a,(select x.advise_no,x.vendor_site_id,x.item_desc,min(rank_seq) rank_seq"+
                      "            from (select a.advise_no,a.pc_advise_id,a.vendor_site_id,a.item_desc,dense_rank() over (order by a.PRODUCT_GROUP,a.VENDOR_SITE_ID,a.CUSTOMER_ID,a.ITEM_DESC,a.REGION_CODE) rank_seq"+
                      "                  from tsc.tsc_shipping_advise_pc_sg a"+
                      "             where  advise_no =?) x "+
                      "         group by x.advise_no,x.vendor_site_id,x.item_desc) b"+
                      " where a.advise_no=b.advise_no"+
					  " and a.vendor_site_id=b.vendor_site_id"+
                      " and a.item_desc=b.item_desc"+
                      " and a.advise_no =?"+
                      " order by b.advise_no,b.rank_seq) x"+
                      "  order by x.rank_seq) y "+
                      "  where ceil( y.item_cnt/?)>1  "+
                      "  order by advise_rank,item_cnt";
				//out.println(sql);
				PreparedStatement statement7 = con.prepareStatement(sql);
				statement7.setInt(1,item_limit_cnt);
				statement7.setString(2,ADVISE_NO); //20200520008
				statement7.setString(3,ADVISE_NO); //20200520008
				statement7.setInt(4,item_limit_cnt);
				ResultSet rs7=statement7.executeQuery();
				while (rs7.next())
				{
					if (rs7.getInt("advise_seq")==1)
					{
						sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
						statement=con.createStatement();
						rs=statement.executeQuery(sql);
						if (rs.next())
						{
							NEW_ADVISE_NO = rs.getString(1);
						}
						else
						{
							sql = " insert into tsc.tsc_shipping_advise_no(shipping_date, seq_no) values (trunc(sysdate),1)";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.executeUpdate();
							pstmtDt.close();	
							
							sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
							Statement statement1=con.createStatement();
							ResultSet rs1=statement1.executeQuery(sql);
							if (rs1.next())
							{
								NEW_ADVISE_NO = rs1.getString(1);
							}	
							rs1.close();
							statement1.close();						
						}
						rs.close();
						statement.close();
						
						if (!NEW_ADVISE_NO.equals(""))
						{
							sql = " update tsc.tsc_shipping_advise_no set seq_no = seq_no +1 where shipping_date = trunc(sysdate)";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.executeUpdate();
							pstmtDt.close();				
						}
						else
						{
							throw new Exception("Advise No產生失敗!!");
						}	
						if (!AdviseNoList.equals("")) AdviseNoList +=",";
						AdviseNoList += "'"+NEW_ADVISE_NO+"'";
						if (AdviseList.equals(""))
						{
							AdviseList =" <table  align='center' width='100%' border='1'  bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>"+
										" <tr bgcolor='#64B077' style='font-family:Tahoma,Georgia;font-size:11px;color:#ffffff'><td>Advise No</td><td>內外銷</td><td>Shipping Marks</td><td>Sales Region</td><td>Shipping Method</td><td>PC SSD</td><td>To TW</td></tr>";
						}
						AdviseList += " <tr style='font-family:Tahoma,Georgia;font-size:11px'><td>"+NEW_ADVISE_NO+"</td><td>"+(rs8.getString("shipping_from_name")==null?"N/A":rs8.getString("shipping_from_name"))+"</td><td>"+rs8.getString("SHIPPING_REMARK")+"</td><td>"+rs8.getString("REGION_CODE")+"</td><td>"+rs8.getString("SHIPPING_METHOD")+"</td><td>"+rs8.getString("PC_SCHEDULE_SHIP_DATE")+"</td><td>"+(rs8.getString("TO_TW").equals("Y")?"是":"否")+"</td></tr>";
						Advise_Cnt++;							
					}	
					sql = " update tsc.tsc_shipping_advise_pc_sg a"+
						  " set advise_no=?"+
						  ",orig_advise_no=?"+
						  ",post_fix_code=case when ?<=3 then case ? when 1 then 'A' when 2 then 'M' else 'N' end else CHR(76+?) end"+ 
						  " where advise_no=?"+
						  " and PC_ADVISE_ID=?";
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,NEW_ADVISE_NO);
					pstmtDt.setString(2,NEW_ADVISE_NO);
					pstmtDt.setInt(3,rs7.getInt("advise_rank"));
					pstmtDt.setInt(4,rs7.getInt("advise_rank"));
					pstmtDt.setInt(5,rs7.getInt("advise_rank"));
					pstmtDt.setString(6,ADVISE_NO);
					pstmtDt.setString(7,rs7.getString("PC_ADVISE_ID"));
					pstmtDt.executeQuery();
					pstmtDt.close();							  
				}
				rs7.close();
				statement7.close();
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
				out.println("<tr><td align='center' colspan='2'><a href='TSCSGShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TSCSGShippingAdviseExcel.jsp?ADVISENOLIST="+AdviseNoList+'"'+">Download Shipping Advise</a></td></tr>");
				out.println("</table>");
			}
			else
			{
				throw new Exception("查無出貨通知待確認資料!!");
			}	
		}

		try
		{
			//更新檢驗報告名,Add by Peggy 20200713
			/*sql = " SELECT X.* ,ADVISE_NO||'-'||CASE WHEN X.ROW_SEQ=1 THEN X.PARTNO ELSE X.ITEM_DESC END||'-'||X.CUSTOMER_NUMBER RPT_NAME"+
				  " FROM (SELECT A.ADVISE_NO,a.pc_advise_id,a.inventory_item_id,a.item_no,a.item_desc,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) partno,c.customer_number "+
				  ",RANK() OVER (PARTITION BY ADVISE_NO,c.customer_number,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) ORDER BY c.customer_number) ROW_SEQ"+
				  ",a.chk_rpt_name"+
				  " FROM tsc.tsc_shipping_advise_pc_sg  a,ont.oe_order_headers_all b,ar_customers c"+
				  " WHERE a.so_header_id=b.header_id"+
				  " and b.sold_to_org_id=c.customer_id"+
				  " and a.advise_no in (?,?)"+
				  " ORDER BY A.ADVISE_NO,PC_ADVISE_ID) X ";*/
				  //" where x.chk_rpt_name is null";
			sql = " SELECT DISTINCT  X.* ,ADVISE_NO||'-'||CASE WHEN X.ROW_SEQ=1 THEN replace(X.PARTNO,'/','') ELSE replace(X.ITEM_DESC,'/','') END||'-'||X.SEQ_RANK RPT_NAME"+
                  " FROM (SELECT A.ADVISE_NO,a.shipping_remark,a.inventory_item_id,a.item_no,a.item_desc,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) partno,a.customer_id "+
                  ",RANK() OVER (PARTITION BY ADVISE_NO,a.shipping_remark,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) ORDER BY ITEM_DESC ) ROW_SEQ"+
                  ",RANK() OVER (PARTITION BY ADVISE_NO ORDER BY a.shipping_remark,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id)) SEQ_RANK"+
                  " FROM tsc.tsc_shipping_advise_pc_sg  a,ont.oe_order_headers_all b"+
                  " WHERE a.so_header_id=b.header_id"+
                  //" AND a.advise_no in (?)"+
				  " AND instr(?,a.advise_no)>0"+
                  " ORDER BY A.ADVISE_NO) X  ORDER BY ADVISE_NO,SEQ_RANK";
			//out.println(sql);
			//out.println(AdviseNoList);
			PreparedStatement statementk = con.prepareStatement(sql);
			statementk.setString(1, AdviseNoList.replace("'",""));
			ResultSet rsk=statementk.executeQuery();
			while (rsk.next())			  
			{
				//sql = " update tsc.tsc_shipping_advise_pc_sg"+
				//	  " SET CHK_RPT_NAME=?"+
				//	  " WHERE pc_advise_ID=?";
				sql = " UPDATE tsc.tsc_shipping_advise_pc_sg"+
					  " SET ORIG_CHK_RPT_NAME=CHK_RPT_NAME"+
                      ",CHK_RPT_NAME=?"+
					  ",CHK_PAPER_RPT_NAME=orig_advise_no||'-'||replace(item_desc,'/','-')||case when SHIPPING_REMARK is not null then '-'||SHIPPING_REMARK else '' end"+ //add by Peggy 20210331
                      " WHERE customer_id=?"+
                      " and INVENTORY_ITEM_ID=?"+
                      " and nvl(SHIPPING_REMARK,'XX')=?"+
                      " and advise_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,rsk.getString("RPT_NAME"));
				pstmtDt.setString(2,rsk.getString("customer_id"));
				pstmtDt.setString(3,rsk.getString("INVENTORY_ITEM_ID"));
				pstmtDt.setString(4,(rsk.getString("SHIPPING_REMARK")==null?"XX":rsk.getString("SHIPPING_REMARK")));
				pstmtDt.setString(5,rsk.getString("advise_no"));
				pstmtDt.executeQuery();
				pstmtDt.close();				  
			}
			rsk.close();
			statementk.close();
			con.commit();					
		}
		catch(Exception e)
		{	
			con.rollback();
			out.println("<font color='red'>更新檢驗報檔名失敗</font>");	
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
		out.println("<div align='center'><a href='TSCSGShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div>");
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
				sql = " delete tsc.tsc_shipping_advise_pc_sg a"+
					  " where PC_ADVISE_ID=?"+
					  " and advise_no is null";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " delete tsc.tsc_shipping_po_price_sg a"+
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
		    out.println("<td width='55%' ><div align='left'>&nbsp;&nbsp;&nbsp;<a href='TSCSGShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div></td>");
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
		out.println("<div align='center'><a href='TSCSGShippingAdviseConfirm.jsp'>回出貨通知確認功能</font></a></div>");
		out.println("</td></tr>");
		out.println("</table>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

