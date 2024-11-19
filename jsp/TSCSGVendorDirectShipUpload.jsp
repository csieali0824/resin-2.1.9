<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0%";
		window.opener.document.getElementById("alpha").style.height="0px";
		window.close();				
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0%";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<title>Excel Upload</title>
</head>
<%
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String VENDORID = request.getParameter("VENDORID");
if (VENDORID == null) VENDORID="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String VENDOR_NAME = "",ITEMDESC="",SHIP_QTY="",VENDOR_SITE_CODE="",remarks="",SO_NO="",LINE_NO="",PC_SSD="",FILE_ID="",TO_TW="",LINE_ID="",ADVISE_NO="",ADVISE_HEADER_ID="",DISTRIBUTION_ID="",ADVISE_LIST="",advise_line_id="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int colCnt = 12,start_row=1,i_code=0,icnt=0,TOT_CARTON_NUM=0,SNO=0,ENO=0,advise_cnt=0;
long QTY=0,ALLOT_QTY=0,REC_QTY=0,UN_REC_QTY=0;

try
{
	sql = " select a.VENDOR_NAME, b.INVOICE_CURRENCY_CODE CURRENCY_CODE,b.vendor_site_code from  AP.ap_suppliers a,ap.ap_supplier_sites_all b where b.vendor_site_id ="+VENDORID+" and b.vendor_id = a.vendor_id";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if(rs.next())
	{
		VENDOR_NAME = rs.getString("VENDOR_NAME");
		VENDOR_SITE_CODE = rs.getString("VENDOR_SITE_CODE");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查詢供應商資料時發生異常,請洽系統管理人員,謝謝!");
		setClose();
		this.window.close();
	</script>
<%
}
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<input type="hidden" name="ORGCODE" value="<%=ORGCODE%>">
<input type="hidden" name="VENDORID" value="<%=VENDORID%>">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;供應商&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong><%=VENDOR_NAME%></strong></font></TD>
	</TR>
<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/H15-005_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSCSGVendorDirectShipUpload.jsp?ACTION=UPLOAD&ORGCODE=<%=ORGCODE%>&VENDORID=<%=VENDORID%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
	
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			String AdviseNoList="";
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H15-005("+VENDORID+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			Hashtable hashtb = new Hashtable();
			Hashtable hashtb1 = new Hashtable();
			
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				LINE_ID="";TO_TW="";
				//MO
				jxl.Cell wcSO_NO = sht.getCell(0, i);          
				SO_NO = (wcSO_NO.getContents()).trim();
				if (SO_NO  == null) SO_NO = "";
				if (SO_NO.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:MO#不可空白!!");
				}
				//LINE
				jxl.Cell wcLINE_NO = sht.getCell(1, i);  
				LINE_NO = (wcLINE_NO.getContents()).trim();
				if (LINE_NO == null) LINE_NO = "";
				if (LINE_NO.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Line#不可空白!!");
				}
				
				//品名
				jxl.Cell wcItemDesc = sht.getCell(2, i);          
				ITEMDESC = (wcItemDesc.getContents()).trim();
				if (ITEMDESC  == null) ITEMDESC = "";
				if (ITEMDESC.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Item Desc不可空白!!");
				}
								
				//出貨數量
				jxl.Cell wcQTY = sht.getCell(3, i);  		   
				if (wcQTY.getType() == CellType.NUMBER) 
				{
					SHIP_QTY = (new DecimalFormat("#####.###")).format(Float.parseFloat(""+((NumberCell) wcQTY).getValue()));
				}
				else SHIP_QTY = (wcQTY.getContents()).trim();
				if (SHIP_QTY == null || SHIP_QTY.equals(""))
				{
					throw new Exception("第"+i+"列:數量不可空白!!");
				}
				else  if (Float.parseFloat(SHIP_QTY)<=0)
				{
					throw new Exception("第"+(i+1)+"列:Ship Qty(K)必須大於0!!");
				}
				
				//PC出貨日
				jxl.Cell wcPC_SSD = sht.getCell(4, i); 
				if (wcPC_SSD.getType() == CellType.DATE)
				{
					DateCell vdate = (DateCell)wcPC_SSD;
					java.util.Date ReqDate  =  ((DateCell)wcPC_SSD).getDate();
					SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
					PC_SSD=sy1.format(ReqDate); 
				}	
				else
				{
					throw new Exception("第"+(i+1)+"列:PC SSD format error!!");
				}
				
				//檢查訂單資訊
				sql = " SELECT B.LINE_ID"+
				      ",MSI.DESCRIPTION"+
				      ",(B.ORDERED_QUANTITY-NVL(B.SHIPPED_QUANTITY,0))/1000 UNSHIP_QTY"+
				      ",(NVL((SELECT SUM(PC_CONFIRM_QTY) FROM TSC.TSC_SHIPPING_ADVISE_PC_SG X WHERE X.SO_LINE_ID=B.LINE_ID),0)/1000) ADVISE_QTY"+
					  ",CASE WHEN NVL(B.ATTRIBUTE20,'N') IN ('YP','YC','YT') THEN 'HOLD' ELSE B.FLOW_STATUS_CODE END AS FLOW_STATUS_CODE "+
					  ",((B.ORDERED_QUANTITY-NVL(B.SHIPPED_QUANTITY,0))/1000)-(NVL((SELECT SUM(PC_CONFIRM_QTY) FROM TSC.TSC_SHIPPING_ADVISE_PC_SG X WHERE X.SO_LINE_ID=B.LINE_ID),0)/1000)-"+SHIP_QTY+" AS SHIP_QTY,"+
				      " case substr(a.ORDER_NUMBER,1,4) when '1121' then 'Y'"+
                      " when '1131' then 'Y' when '1141' then 'Y' when '1214' then case when a.ORG_ID=906 THEN 'Y' ELSE 'N' END else 'N' end as TO_TW"+					  
					  " ,NVL(B.attribute19,'0') DIRECT_SHIP_FLAG"+
                      " FROM ONT.OE_ORDER_HEADERS_ALL A,ONT.OE_ORDER_LINES_ALL B,INV.MTL_SYSTEM_ITEMS_B MSI"+
                      " WHERE A.HEADER_ID=B.HEADER_ID"+
                      " AND A.ORDER_NUMBER=?"+
                      " AND B.LINE_NUMBER||'.'||B.SHIPMENT_NUMBER=?"+
                      " AND B.SHIP_FROM_ORG_ID=?"+
                      " AND B.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID"+
                      " AND B.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID";
				//out.println(sql);
				//out.println(SO_NO);
				//out.println(LINE_NO);
				//out.println(ORGCODE);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,SO_NO);
				statement.setString(2,LINE_NO);
				statement.setString(3,ORGCODE);
				ResultSet rs=statement.executeQuery();
				if (rs.next())					 
				{
					if (rs.getString("SHIP_QTY").startsWith("-"))
					{
						throw new Exception("第"+(i)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" 不可超排出貨(未交:"+rs.getString("UNSHIP_QTY")+"K,已排:"+rs.getString("ADVISE_QTY")+"K)!!");
					}
					else if (rs.getString("FLOW_STATUS_CODE").equals("HOLD"))
					{
						throw new Exception("第"+(i)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" HOLD狀態,不允許排出貨!!");
					}
					else if (!rs.getString("FLOW_STATUS_CODE").equals("AWAITING_SHIPPING"))
					{
						throw new Exception("第"+(i)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" 不是可出貨狀態("+rs.getString("FLOW_STATUS_CODE")+")!!");
					}	
					else if (!rs.getString("description").equals(ITEMDESC))
					{
						throw new Exception("第"+(i)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" 品名:"+ITEMDESC+"與訂單品名:"+rs.getString("description")+"不符!!");
					}
					else if (!rs.getString("DIRECT_SHIP_FLAG").equals("3")) //直出
					{
						throw new Exception("第"+(i)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" 未指定直出!!");
					}
					LINE_ID=rs.getString("line_id");
					TO_TW=rs.getString("TO_TW");				
				}	
				else
				{
					throw new Exception("第"+(i+1)+"列:MO#"+SO_NO+"  Line#"+LINE_NO+" not found!!");
				}
				rs.close();	
				statement.close();
				
				if (FILE_ID.equals(""))
				{
					Statement statement1=con.createStatement();
					ResultSet rs1=statement1.executeQuery(" SELECT TSC_SHIPPING_ADVISE_PC_S.nextval from dual");
					if (rs1.next())
					{
						FILE_ID = ""+(rs1.getInt(1)*-1);
					}
					else
					{
						rs1.close();
						statement1.close();		
						throw new Exception("FILE Id取得失敗!!");
					}
					rs1.close();
					statement1.close();					
				}
				
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
					  " org_id,"+
					  " delivery_type"+
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
					  " case when ?='Y' and (substr(a.order_number,1,4)<>'1121' or (substr(a.order_number,1,4)='1121' and instr(d.meaning,'UPS')<=0 and instr(d.meaning,'DHL')<=0 and instr(d.meaning,'FEDEX')<=0 and instr(d.meaning,'TNT')<=0)) then 'SEA(C)' else d.meaning end as SHIPPING_METHOD,"+
					  " case when mp.organization_code IN ('SG1','SG2') THEN mp.organization_code ELSE 'TEW' END SHIPPING_FROM,"+
					  " b.ordered_quantity SO_QTY,"+
					  " null DN_QTY,"+
					  " ?*1000 SHIP_QTY,"+
					  " 0 onhand,"+
					  " ?*1000 PC_CONFIRM_QTY,"+
					  " 0 UNSHIP_CONFIRM_QTY,"+
					  " b.ORDER_QUANTITY_UOM UOM,"+
					  " b.FOB_POINT_CODE FOB_CODE,"+
					  " to_date(TO_CHAR(b.SCHEDULE_SHIP_DATE,'yyyymmdd'),'yyyymmdd') SCHEDULE_SHIP_DATE,"+
					  " TO_DATE(?,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
					  " null NET_WEIGHT,"+
					  " null GROSS_WEIGHT,"+
					  " null CUBE,"+
					  " null PC_REMARK,"+
					  " b.PACKING_INSTRUCTIONS,"+
					  " TSC_GET_REMARK_DESC(a.TSC_HEADER_ID,'SHIPPING MARKS') SHIPPING_REMARK,"+
					  //" Tsc_Intercompany_Pkg.get_sales_group(a.TSC_header_id) REGION_CODE,"+
					  " TSC_OM_Get_Sales_Group(a.TSC_header_id) REGION_CODE,"+
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
					  " TSC_SHIPPING_ADVISE_PC_S.nextval,"+
					  " b.SHIPPING_METHOD_CODE,"+
					  " b.FOB_POINT_CODE FOB,"+
					  " NULL SHIP_TO_CONTACT_NAME,"+
					  " NULL TAX,"+
					  " g.customer_name,"+
					  " (SELECT MEDIA_ID FROM fnd_attached_docs_form_vl fadfv WHERE fadfv.function_name = 'OEXOEORD' AND fadfv.category_description = 'SHIPPING MARKS' AND fadfv.pk1_value = TO_CHAR(a.header_id)  AND fadfv.ENTITY_NAME = 'OE_ORDER_HEADERS' AND fadfv.pk2_value is null AND fadfv.pk3_value is null),"+ 
					  " ? FILE_ID,"+
					  " null INVOICE_NO,"+
					  " null CARTON_NO_FROM,"+
					  " null CARTON_NO_TO,"+
				      " case when length( TSC_GET_REMARK_DESC(a.TSC_HEADER_ID,'SHIPPING MARKS'))>=12 and substr(TSC_GET_REMARK_DESC(a.TSC_HEADER_ID,'SHIPPING MARKS'),1,12)='CHANNEL WELL' then 'D' when instr(TSC_GET_REMARK_DESC(a.TSC_HEADER_ID,'SHIPPING MARKS'),'駱騰')>0 then 'I' "+
				      " else '' end as box_code,"+  //直出固定無箱碼,add by Peggy 20200427
					  " null CARTON_PER_QTY,"+
					  " sysdate LAST_UPDATE_DATE,"+
					  " (select ERP_USER_ID from oraddman.wsuser where username=?) LAST_UPDATED_BY,"+
					  " sysdate CREATION_DATE,"+
					  " (select ERP_USER_ID from oraddman.wsuser where username=?) CREATED_BY,"+
					  " null LAST_UPDATE_LOGIN,"+
					  " ? TO_TW,"+
					  " ? vendor_site_id,"+
					  " a.org_id,"+
					  " ?"+
					  //" from ont.oe_order_headers_all a,"+
					  " from (SELECT a.*,NVL((SELECT HEADER_ID FROM ONT.OE_ORDER_HEADERS_ALL b where b.ORDER_NUMBER=a.ORDER_NUMBER and b.ORG_ID=41),a.HEADER_ID) TSC_HEADER_ID FROM ONT.OE_ORDER_HEADERS_ALL a) a,"+
					  " ont.oe_order_lines_all b,"+
					  " inv.mtl_system_items_b c,"+
					  " (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') d ,"+
					  " (select * from ra_terms_tl where LANGUAGE='US') e,"+
					  " (select * from (select source_header_id,source_line_id,DELIVERY_DETAIL_ID,row_number() over(partition by source_header_id,source_line_id order by nvl(SPLIT_FROM_DELIVERY_DETAIL_ID,0) desc,CREATION_DATE) seq_no from wsh.wsh_delivery_details where source_line_id=?) where seq_no =1) f,"+  
					  " AR_CUSTOMERS g,"+
					  " inv.mtl_parameters mp"+
					  " where a.header_id = b.header_id "+
					  " and b.ship_from_org_id = c.organization_id"+
					  " and b.inventory_item_id = c.inventory_item_id"+
					  " AND b.SHIPPING_METHOD_CODE = d.lookup_code (+)"+
					  " AND NVL(b.payment_term_id,a.payment_term_id) =e.term_id"+
					  " AND b.header_id = f.source_header_id"+
					  " and b.line_id = f.source_line_id"+
					  " and a.sold_to_org_id = g.customer_id"+
					  " and b.ship_from_org_id=mp.organization_id"+
					  " and b.line_id=?";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,TO_TW);
				pstmtDt.setString(2,SHIP_QTY);
				pstmtDt.setString(3,SHIP_QTY);
				pstmtDt.setString(4,PC_SSD);
				pstmtDt.setString(5,FILE_ID);
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,UserName);
				pstmtDt.setString(8,TO_TW);
				pstmtDt.setString(9,VENDORID);
				pstmtDt.setString(10,"VENDOR");
				pstmtDt.setString(11,LINE_ID); 
				pstmtDt.setString(12,LINE_ID); 
				pstmtDt.executeQuery();
				pstmtDt.close();
			}	
			out.println("<font style='font-family:arial;font-size:12px'>1.PC出貨通知排定完成<br></font>");
			
			sql = " select a.shipping_from"+
			   	  " ,case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)')  AND a.to_tw ='N' THEN 1 "+
				  "       when a.to_tw ='Y' THEN 2 "+
				  "       when a.REGION_CODE='TSCT-Disty' THEN 3 "+
				  "       when NVL(a.delivery_type,'XX')='VENDOR' THEN 4"+ //廠商直出,TSCC-SH與TSCH-HK可合併一張ADVISE,add by Peggy 20200511
				  "       else a.CUSTOMER_ID END AS CUSTOMER_ID"+
				  //" ,case when a.to_tw ='Y' then 'TSCT' else a.REGION_CODE end REGION_CODE"+  //1121與1131/1141合併回T,modify by Peggy 20200417
				  " ,case when a.to_tw ='Y' then 'TSCT'  when NVL(a.delivery_type,'XX')='VENDOR' and instr(a.REGION_CODE,'TSCC')>0 then 'TSCH-HK' else a.REGION_CODE end REGION_CODE"+  //廠商直出,TSCC-SH與TSCH-HK可合併一張ADVISE,add by Peggy 20200511
				  //" ,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end as SHIPPING_METHOD "+
				  " ,case when a.to_tw ='Y' and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end as SHIPPING_METHOD "+ //modif by Peggy 20220728
				  " ,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
				  " ,a.TO_TW"+
				  " ,case when a.shipping_from  LIKE 'SG%' then 0 else a.VENDOR_SITE_ID end VENDOR_SITE_ID"+
				  " ,case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD' "+
				  "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  not in ('104','151') then 'PHIHONG(1)' "+ 
				  "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
				  "       when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				  "       when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				  "       when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+
				  "       when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216					  
				  "       when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ 
				  "       when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
				  " ELSE 'N/A' END AS SHIPPING_REMARK"+
				  //",case when a.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+  //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
				  ",case when a.to_tw ='N' and  NVL(a.delivery_type,'XX')<> 'VENDOR' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END as ship_to_org_id"+  //廠商直出,TSCC-SH與TSCH-HK可合併一張ADVISE,add by Peggy 20200511
				  ",case a.shipping_from when 'SG1' then '內銷' when 'SG2' THEN '外銷' ELSE a.shipping_from END shipping_from_name"+
				  " from tsc.tsc_shipping_advise_pc_sg a"+
				  ",AR_CUSTOMERS c"+
				  ",inv.mtl_parameters mp"+
				  " where a.CUSTOMER_ID = c.CUSTOMER_ID"+
				  " and a.organization_id=mp.organization_id"+
				  " and advise_no is null"+
				  " and FILE_ID ='"+FILE_ID+"'"+
			      " group by a.shipping_from"+
			      " ,case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1  when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 when NVL(a.delivery_type,'XX')='VENDOR' THEN 4 ELSE a.CUSTOMER_ID END"+
				  " ,case when a.to_tw ='Y' then 'TSCT' when NVL(a.delivery_type,'XX')='VENDOR' and instr(a.REGION_CODE,'TSCC')>0 then 'TSCH-HK' else a.REGION_CODE end"+  //1121與1131/1141合併回T,modify by Peggy 20200417
				  //" ,case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end"+
				  " ,case when a.to_tw ='Y' and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end"+  //modif by Peggy 20220728
				  ",to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd')"+
				  ",TO_TW"+
				  ",case when a.shipping_from  LIKE 'SG%' then 0 else a.VENDOR_SITE_ID end "+
				  ",a.organization_id"+
				  ",case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				  "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				  "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) ='151' then 'PHIHONG(3)' "+ 
  				  "      when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				  "      when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				  "      when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') >0 THEN '駱騰' "+
				  "      when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216					  
  				  "      when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
				  "      when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
                  "      else 'N/A' END"+
				  ",case when a.to_tw ='N' and NVL(a.delivery_type,'XX')<> 'VENDOR' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END"+  //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
				  " order by to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),case when a.to_tw ='Y' then 'TSCT' when NVL(a.delivery_type,'XX')='VENDOR' and instr(a.REGION_CODE,'TSCC')>0 then 'TSCH-HK' else a.REGION_CODE end";
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

				if (!AdviseNoList.equals("")) AdviseNoList +=",";
				AdviseNoList += "'"+ADVISE_NO+"'";
								
				sql = " update tsc.tsc_shipping_advise_pc_sg a"+
					  " set advise_no=?"+
					  ",orig_advise_no=?"+
					  " where advise_no is null"+
					  " and a.shipping_from=?"+
					  " and case when a.REGION_CODE='TSCE' AND (a.SHIPPING_METHOD='AIR(C)' or a.SHIPPING_METHOD='SEA(C)') AND a.to_tw ='N' THEN 1 when a.to_tw ='Y' THEN 2 when a.REGION_CODE='TSCT-Disty' THEN 3 when NVL(a.delivery_type,'XX')='VENDOR' THEN 4 ELSE a.CUSTOMER_ID END=?"+
			  	      " and case when a.to_tw ='Y' then 'TSCT'  when NVL(a.delivery_type,'XX')='VENDOR' and instr(a.REGION_CODE,'TSCC')>0 then 'TSCH-HK' else a.REGION_CODE end =?"+  //1121與1131/1141合併回T,modify by Peggy 20200417
			          //" and case when a.to_tw ='Y' then 'SEA(C)' else a.SHIPPING_METHOD end=?"+
					  " and case when a.to_tw ='Y'  and instr(a.SHIPPING_METHOD,'AIR')=0 then 'SEA(C)' else a.SHIPPING_METHOD end=?"+ //modify by Peggy 20220728
			          " and to_char(PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd')=?"+
					  " and TO_TW=?"+
					  " and case when a.shipping_from LIKE 'SG%' then 0 else VENDOR_SITE_ID end=? "+
					  " and case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and substr(a.CUST_PO_NUMBER,1,1)= '1' and substr(a.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
  				      "          when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.CUST_PO_NUMBER)>=3 and (substr(a.CUST_PO_NUMBER,1,1)<> '1' or substr(a.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
				      "          when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
				      "          when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') > 0 THEN '駱騰' "+
				      "          when a.REGION_CODE ='TSCT-DA' and a.CUSTOMER_ID=1138 and (substr(a.CUST_PO_NUMBER,1,3) in ('T3F','T3C') or substr(a.CUST_PO_NUMBER,1,2) in ('T2')) then 'DELTA-THAILAND'"+ //add by Peggy 20230216					  
    				  "          when a.REGION_CODE ='TSCT-DA' and instr(upper(a.CUSTOMER_NAME),'DELTA') >0 and instr(upper(a.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.CUST_PO_NUMBER,1,2)"+ //add by Peggy 20170516
				      "          when a.to_tw ='Y' then 'T'"+  //1121與1131/1141合併回T,modify by Peggy 20200417
					  "          else 'N/A' END=?"+
				   	  " and case when a.to_tw ='N' and  NVL(a.delivery_type,'XX')<> 'VENDOR' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or substr(a.so_no,1,1) in ('8')) THEN  a.SHIP_TO_ORG_ID ELSE 0 END=?"+ //TSCH 不同地址分開產生Advise No,ADD BY PEGGY 20200326
				      " and FILE_ID ='"+FILE_ID+"'";
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
			}
			rs8.close();
			statement8.close();		
			
			sql = " SELECT DISTINCT  X.* ,ADVISE_NO||'-'||CASE WHEN X.ROW_SEQ=1 THEN X.PARTNO ELSE X.ITEM_DESC END||'-'||X.SEQ_RANK RPT_NAME"+
                  " FROM (SELECT A.ADVISE_NO,a.shipping_remark,a.inventory_item_id,a.item_no,a.item_desc,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) partno,a.customer_id "+
                  ",RANK() OVER (PARTITION BY ADVISE_NO,a.shipping_remark,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) ORDER BY ITEM_DESC ) ROW_SEQ"+
                  ",RANK() OVER (PARTITION BY ADVISE_NO ORDER BY a.shipping_remark,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id)) SEQ_RANK"+
                  " FROM tsc.tsc_shipping_advise_pc_sg  a,ont.oe_order_headers_all b"+
                  " WHERE a.so_header_id=b.header_id"+
				  " AND instr(?,a.advise_no)>0"+
                  " ORDER BY A.ADVISE_NO) X  ORDER BY ADVISE_NO,SEQ_RANK";
			PreparedStatement statementk = con.prepareStatement(sql);
			statementk.setString(1, AdviseNoList.replace("'",""));
			ResultSet rsk=statementk.executeQuery();
			while (rsk.next())			  
			{
				sql = " UPDATE tsc.tsc_shipping_advise_pc_sg"+
                      " SET CHK_RPT_NAME=?"+
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
			
			out.println("<font style='font-family:arial;font-size:12px'>2.PC出貨通知確認完成<br></font>");
			
			//advise loop	
			sql = " select distinct advise_no,delivery_type from tsc.tsc_shipping_advise_pc_sg a where FILE_ID ='"+FILE_ID+"'";
			Statement statement2=con.createStatement();
			ResultSet rs2=statement2.executeQuery(sql);
			while (rs2.next())
			{
				ADVISE_NO=rs2.getString(1);
				TOT_CARTON_NUM=0;SNO=0;ENO=0;
				out.println("<font style='font-family:arial;font-size:12px'>***Advise#:"+ADVISE_NO+"</font>");
				icnt=0;
				sql = " select tsc_shipping_advise_lines_s.nextval advise_line_id"+
					  ",box.*"+
					  ",case WHEN ACT_SHIP_QTY < CARTON_QTY THEN ACT_SHIP_QTY ELSE CARTON_QTY END AS ACT_CARTON_QTY"+
					  ",case WHEN ACT_SHIP_QTY_S < CARTON_QTY_S THEN ACT_SHIP_QTY_S ELSE CARTON_QTY_S END AS ACT_CARTON_QTY_S"+
					  ",tssg_ship_pkg.get_cubic_meter(box.carton_size,3) cbm"+
					  " from (SELECT 1 as seq, y.*,floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY ACT_SHIP_QTY,TO_CHAR(floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY /1000,'99999.000') ACT_SHIP_QTY_S, floor(y.SHIP_QTY/y.CARTON_QTY) TOT_CARTON_NUM,y.NW as ACT_NW,y.GW as ACT_GW,y.NW as ACT_NW_1,y.GW as ACT_GW_1"+
					  "       FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
					  "            FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.post_fix_code BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
					  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
					  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
					  "                  where orig_ADVISE_NO in ("+ADVISE_NO+")"+
					  "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
					  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
					  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
					  "                  and a.vendor_id = b.vendor_id(+)"+
					  "                  and a.ITEM_DESC =b.TSC_PARTNO(+)"+
					  "                  and b.TSC_PARTNO is not null"+
					  "                  UNION ALL"+
					  "                  select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.post_fix_code BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
					  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
					  "                       ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
					  "                  where orig_ADVISE_NO in ("+ADVISE_NO+")"+
					  "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
					  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
					  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
					  "                  and a.vendor_id = b.vendor_id(+)"+
					  "                  and b.TSC_PARTNO is null"+
					  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
					  "                  ) x"+
					  "            ) y where ROWSEQ=1 AND  floor(y.SHIP_QTY/NVL(y.CARTON_QTY,1)) >0"+
					  "      union all "+
					  "      SELECT 2 as seq, y.*,mod(y.SHIP_QTY,y.CARTON_QTY) ACT_SHIP_QTY,TO_CHAR(mod(y.SHIP_QTY,y.CARTON_QTY) /1000,'99999.000') ACT_SHIP_QTY_S, ceil(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY) TOT_CARTON_NUM,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) < 0.01 then 0.01 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) end as ACT_NW,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) < 1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) end as ACT_GW,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) ACT_NW_1,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) ACT_GW_1"+
					  "      FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
					  "           FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.post_fix_code BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
					  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
					  "                     ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
					  "                 where orig_ADVISE_NO in ("+ADVISE_NO+")"+
					  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
					  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
					  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
					  "                 and a.vendor_id = b.vendor_id(+)"+
					  "                 and a.ITEM_DESC =b.TSC_PARTNO(+)"+
					  "                 and b.TSC_PARTNO is not null"+
					  "                 UNION ALL"+
					  "                 select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.post_fix_code BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
					  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
					  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
					  "                 where orig_ADVISE_NO in ("+ADVISE_NO+")"+
					  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
					  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
					  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
					  "                 and a.vendor_id = b.vendor_id(+)"+
					  "                 and b.TSC_PARTNO is null"+
					  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
					  "                 ) x"+
					  "       ) y "+
					  "       where ROWSEQ=1 "+
					  "       AND  mod(y.SHIP_QTY,y.CARTON_QTY) >0"+
					  "       order by  3,23,24,5,10,12,9,7,1,24 DESC ) box "; //prod group第二順位,zhangdi 11/15要求
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				ResultSet rs=statement.executeQuery();
				while (rs.next())
				{
					if (icnt ==0)
					{
						sql = " SELECT tsc_shipping_advise_headers_s.nextval from dual";
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery(sql);
						if (rs1.next())
						{
							ADVISE_HEADER_ID = rs1.getString(1);
						}
						rs1.close();
						statement1.close();	
						
						sql = " insert into tsc.tsc_shipping_advise_headers"+
							  "(advise_header_id"+
							  ",advise_no"+
							  ",comfirm_flag"+
							  ",status"+
							  ",invoice_no"+
							  ",customer_id"+
							  ",shipping_method"+
							  ",shipping_from"+
							  ",fob_code"+
							  ",payment_term_id"+
							  ",payment_term"+
							  ",ship_to_org_id"+
							  ",ship_to"+
							  ",invoice_to_org_id"+
							  ",invoice_to"+
							  ",deliver_to_org_id"+
							  ",deliver_to"+
							  ",tax_code"+
							  ",ship_to_contact_id"+
							  ",currency_code"+
							  ",po_no"+
							  ",shipping_remark"+
							  ",post_fix_code"+
							  ",file_id"+
							  ",dn_flag"+
							  ",last_update_date"+
							  ",last_updated_by"+
							  ",creation_date"+
							  ",created_by"+
							  ",last_update_login"+
							  ",to_tw"+
							  ",delivery_type)"+
							  " SELECT ?,ADVISE_NO, 'Y','4','' invoice_no, a.customer_id, a.shipping_method, a.shipping_from,"+
							  "       a.fob_code, a.payment_term_id, a.payment_term, a.ship_to_org_id, a.ship_to, a.invoice_to_org_id, a.invoice_to,"+
							  "       a.deliver_to_org_id, a.deliver_to, a.tax_code,a.ship_to_contact_id, a.currency_code, a.CUST_PO_NUMBER po_no,"+
							  "       a.shipping_remark,'', file_id, 'N',sysdate LAST_UPDATE_DATE,(select ERP_USER_ID from oraddman.wsuser where username=?) LAST_UPDATED_BY,sysdate CREATION_DATE,(select ERP_USER_ID from oraddman.wsuser where username=?) CREATED_BY,'' LAST_UPDATE_LOGIN, a.to_tw,?"+
							  " FROM tsc.tsc_shipping_advise_pc_sg a "+
							  " WHERE ADVISE_NO=? and rownum=1";
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,ADVISE_HEADER_ID);
						pstmtDt.setString(2,UserName);
						pstmtDt.setString(3,UserName);
						pstmtDt.setString(4,rs2.getString("delivery_type"));
						pstmtDt.setString(5,ADVISE_NO);
						pstmtDt.executeQuery();
						pstmtDt.close();
	
					}
					
					if (rs.getString("CARTON_SIZE")==null || rs.getString("CARTON_SIZE").equals(""))
					{
						out.println("<div><font color='red'>型號:"+rs.getString("ITEM_DESC")+"未定義編箱基本資料(供應商:"+rs.getString("VENDOR_SITE_CODE")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TSC Package:"+rs.getString("tsc_package")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Packing:"+rs.getString("packing_code")+")!</font></div>");
						throw new Exception("Error");
					}
					SNO = TOT_CARTON_NUM+1;
					TOT_CARTON_NUM+=Integer.parseInt(rs.getString("TOT_CARTON_NUM"));
					ENO =TOT_CARTON_NUM;				
					
					sql = " INSERT INTO tsc.tsc_shipping_advise_lines "+
						  "(advise_line_id"+
						  ",advise_header_id"+
						  ",so_header_id"+
						  ",so_line_id"+
						  ",so_no"+
						  ",so_line_number"+
						  ",delivery_detail_id"+
						  ",organization_id"+
						  ",inventory_item_id"+
						  ",item_no"+
						  ",item_desc"+
						  ",product_group"+
						  ",so_qty"+
						  ",ship_qty"+
						  ",onhand_qty"+
						  ",pc_confirm_qty"+
						  ",unship_confirm_qty"+
						  ",uom"+
						  ",schedule_ship_date"+
						  ",pc_schedule_ship_date"+
						  ",net_weight"+
						  ",gross_weight"+
						  ",cube"+
						  ",pc_remark"+
						  ",packing_instructions"+
						  ",shipping_remark"+
						  ",region_code"+
						  ",po_no"+
						  ",carton_num_fr"+
						  ",carton_num_to"+
						  ",type"+
						  ",carton_qty"+
						  ",carton_per_qty"+
						  ",total_qty"+
						  ",tsc_package"+
						  ",tsc_family"+
						  ",pc_advise_id"+
						  ",parent_advise_line_id"+
						  ",file_id"+
						  ",packing_code"+
						  ",last_update_date"+
						  ",last_updated_by"+
						  ",creation_date"+
						  ",created_by"+
						  ",last_update_login"+
						  ",attribute1"+
						  ",attribute2"+
						  ",vendor_site_id"+
						  ",tew_advise_no"+
						  ",org_id"+
						  ",post_code"+
						  ",cubic_meter"+
						  ") "+
						  " SELECT ?,?, a.so_header_id,"+
						  " a.so_line_id, a.so_no, a.so_line_number, a.delivery_detail_id,a.organization_id, a.inventory_item_id,"+
						  " a.item_no, a.item_desc,a.product_group, a.so_qty, ?, a.onhand_qty,a.pc_confirm_qty, a.unship_confirm_qty, a.uom,"+
						  " a.schedule_ship_date, a.pc_schedule_ship_date, ? net_weight, ? gross_weight,? cube, a.pc_remark, a.packing_instructions,"+
						  " a.shipping_remark, a.region_code, a.CUST_PO_NUMBER po_no,"+
						  " ? carton_num_fr,? carton_num_to, 'LINE' type, ? carton_qty, ? carton_per_qty,? total_qty,"+
						  " a.tsc_package, a.tsc_family, a.pc_advise_id, null parent_advise_line_id, a.file_id, a.packing_code,"+
						  " sysdate last_update_date,(select ERP_USER_ID from oraddman.wsuser where username=?) last_updated_by,"+
						  " sysdate creation_date,(select ERP_USER_ID from oraddman.wsuser where username=?) created_by, null last_update_login, null attribute1, null attribute2,a.vendor_site_id,?,org_id,post_fix_code,?"+
						  " FROM tsc.tsc_shipping_advise_pc_sg a   WHERE PC_ADVISE_ID =?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,rs.getString("advise_line_id"));
					pstmtDt.setString(2,ADVISE_HEADER_ID);
					pstmtDt.setString(3,rs.getString("ACT_SHIP_QTY"));
					pstmtDt.setString(4,rs.getString("ACT_NW"));;
					pstmtDt.setString(5,rs.getString("ACT_GW"));
					pstmtDt.setString(6,rs.getString("CARTON_SIZE"));
					pstmtDt.setString(7,""+SNO);;
					pstmtDt.setString(8,""+ENO);;
					pstmtDt.setString(9,rs.getString("TOT_CARTON_NUM"));
					pstmtDt.setString(10,rs.getString("ACT_CARTON_QTY"));
					pstmtDt.setString(11,""+ (Long.parseLong(rs.getString("TOT_CARTON_NUM"))*Long.parseLong(rs.getString("ACT_CARTON_QTY"))));
					pstmtDt.setString(12,UserName);
					pstmtDt.setString(13,UserName);
					pstmtDt.setString(14,ADVISE_NO);
					pstmtDt.setString(15,rs.getString("CBM"));
					pstmtDt.setString(16,rs.getString("PC_ADVISE_ID"));
					pstmtDt.executeQuery();
					pstmtDt.close();	
					icnt ++;
				}
				rs.close();
				statement.close();
				
				Statement statement1=con.createStatement();
				rs=statement1.executeQuery("select SG_LOT_DISTRIBUTION_ID_S.nextval from dual");
				if (!rs.next())
				{
					rs.close();
					statement1.close();		
					throw new Exception("ID not Found!!");
				}
				else
				{
					DISTRIBUTION_ID = rs.getString(1);
				}
				rs.close();
				statement1.close();		
				out.println("<font style='font-family:arial;font-size:12px'>           3.進出口編箱作業完成</font>");
			
				
				sql= " insert into oraddman.TSSG_LOT_DISTRIBUTION_TEMP"+
					 " (sg_distribution_id, advise_no, vendor_site_code,"+
					 " vendor_site_id, advise_header_id, advise_line_id,"+
					 " pc_advise_id, so_no, so_line_no, item_id, item_name,"+
					 " item_desc, ship_qty, cust_po, cust_partno,"+
					 " shipping_remark, shipping_method, schedule_ship_date,"+
					 " carton_num, post_fix_code, lot_number, date_code, qty,"+
					 //" po_cust_partno,vendor_carton_no,sg_stock_id,subinventory_code,po_header_id,created_by, creation_date)"+
					 " po_cust_partno,vendor_carton_no,sg_stock_id,subinventory_code,po_header_id,dc_yyww,created_by, creation_date)"+ //DC_YYWW add by Peggy 20220722
					 " select ?,a.*,?,sysdate FROM TABLE(TSSG_SHIP_PKG.LOT_DISTRIBUTION_VIEW_NEW(?)) a";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  	
				pstmtDt.setString(1,DISTRIBUTION_ID); 
				pstmtDt.setString(2,UserName);						 
				pstmtDt.setString(3,ADVISE_NO);						 
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " select 'MO#:'||SO_NO||'  LINE#:'||SO_LINE_NO||'   ITEM DESC:'||ITEM_DESC|| '   '||LOT_NUMBER  from oraddman.TSSG_LOT_DISTRIBUTION_TEMP b"+
					  " where b.SG_DISTRIBUTION_ID='"+DISTRIBUTION_ID+"'"+
					  " and b.lot_number ='庫存不足'";
				statement1=con.createStatement();
				rs=statement1.executeQuery(sql);
				while (rs.next())
				{
					if (rs.getString(1)!=null)
					{
						throw new Exception(rs.getString(1));
					}
				}
				rs.close();
				statement1.close();		
				
				sql = " insert into tsc.tsc_pick_confirm_headers"+
					  "(advise_header_id"+
					  ",advise_no"+
					  ",pick_status"+
					  ",oqc_status"+
					  ",PICK_CONFIRM_DATE"+
					  ",PICK_CONFIRM_BY"+
					  ",LAST_UPDATE_DATE"+
					  ",LAST_UPDATED_BY"+
					  ",CREATION_DATE"+
					  ",CREATED_BY)"+
					  " select x.advise_header_id"+
					  ",x.advise_no"+
					  ",'Y'"+
					  ",'Y'"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=?)"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=?)"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=?)"+
					  " from tsc.tsc_shipping_advise_headers x "+
					  " where exists (select 1 from tsc.tsc_shipping_advise_lines y where x.advise_header_id = y.advise_header_id and y.tew_advise_no=?)";
				//out.println(sql);
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,UserName);
				pstmtDt.setString(4,ADVISE_NO);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
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
					  ", pick_qty"+
					  ", date_code"+
					  ", manufacture_date"+
					  ", effective_date"+
					  ", last_update_date"+
					  ", last_updated_by"+
					  ", creation_date"+
					  ", created_by"+
					  ", product_group"+
					  ", onhand_org_id"+
					  ", po_line_location_id"+
					  ", tew_advise_no"+
					  ", po_cust_partno"+
					  ", sg_stock_id"+
					  ", dc_yyww)"+  //add by Peggy 20220722
					  " select b.advise_header_id"+
					  ",b.advise_line_id"+
					  ",'C'"+
					  //",b.carton_num"+
					  ",b.vendor_carton_no"+ //取供應商箱碼
					  ",'1'"+
					  ",b.so_no"+
					  ",a.so_header_id"+
					  ",a.so_line_id"+
					  ",a.organization_id"+
					  ",b.item_id"+
					  ",b.item_name"+
					  ",b.lot_number"+
					  ",b.subinventory_code "+
					  ",b.qty"+
					  ",b.qty"+
					  ",b.date_code"+
					  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(b.date_code,b.item_name)) where D_TYPE='MAKE') MANUFACTURE_DATE"+
					  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(b.date_code,b.item_name)) where D_TYPE='VALID') EFFECTIVE_DATE"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=b.created_by)"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=b.created_by)"+
					  ",a.PRODUCT_GROUP"+
					  ",a.ORGANIZATION_ID"+
					  ",null"+
					  ",b.advise_no"+
					  ",replace(b.PO_CUST_PARTNO,'N/A','')"+
					  ",b.sg_stock_id"+
					  ",b.dc_yyww"+ //add by Peggy 20220722
					  " from oraddman.TSSG_LOT_DISTRIBUTION_TEMP b,tsc.tsc_shipping_advise_lines a"+
					  " where b.SG_DISTRIBUTION_ID=?"+
					  " and b.advise_line_id=a.advise_line_id"+
					  " order by b.carton_num";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,DISTRIBUTION_ID);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " SELECT ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NO,QTY"+
                      ",COUNT(1) OVER (PARTITION BY ADVISE_LINE_ID ORDER BY TO_NUMBER(CARTON_NO)) ADVISE_ID_SEQ"+
                      ",COUNT(CARTON_NO) OVER (PARTITION BY ADVISE_LINE_ID) ADVISE_CARTON_NUM"+
                      ",RANK() OVER (PARTITION BY CARTON_NO ORDER BY ADVISE_LINE_ID) SAME_CARTON_RANK"+
                      " FROM (SELECT ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NO,SUM(QTY) QTY FROM tsc.tsc_pick_confirm_lines a"+
                      " WHERE TEW_ADVISE_NO='"+ADVISE_NO+"'"+
                      " GROUP BY ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NO"+
                      " ORDER BY ADVISE_LINE_ID,CARTON_NO) X";
				Statement statement3=con.createStatement();
				ResultSet rs3=statement3.executeQuery(sql);
				while (rs3.next())
				{	
					if (rs3.getInt("ADVISE_CARTON_NUM")==1 || rs3.getInt("SAME_CARTON_RANK")==1)
					{
						sql = " update tsc.tsc_shipping_advise_lines b"+
							  " set  (CARTON_NUM_FR,CARTON_NUM_TO,CARTON_QTY,CARTON_PER_QTY,TOTAL_QTY,SHIP_QTY)=(SELECT min(to_number(carton_no)),max(to_number(carton_no)), max(to_number(carton_no))-min(to_number(carton_no))+1,sum(QTY)/(max(to_number(carton_no))-min(to_number(carton_no))+1),sum(QTY),sum(QTY) FROM tsc.tsc_pick_confirm_lines a WHERE a.advise_line_id=b.advise_line_id)"+
							  " where tew_advise_no=?"+
							  " and advise_line_id=?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,ADVISE_NO);
						pstmtDt.setString(2,rs3.getString("advise_line_id"));
						pstmtDt.executeQuery();
						pstmtDt.close();
					}
					else
					{
						statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery(" SELECT tsc_shipping_advise_lines_s.nextval from dual");
						if (rs1.next())
						{
							advise_line_id = rs1.getString(1);
						}
						else
						{
							rs1.close();
							statement1.close();		
							throw new Exception("advise line id取得失敗!!");
						}
						rs1.close();
						statement1.close();		
						
						sql = " INSERT INTO tsc.tsc_shipping_advise_lines "+
							  "(advise_line_id"+
							  ",advise_header_id"+
							  ",so_header_id"+
							  ",so_line_id"+
							  ",so_no"+
							  ",so_line_number"+
							  ",delivery_detail_id"+
							  ",organization_id"+
							  ",inventory_item_id"+
							  ",item_no"+
							  ",item_desc"+
							  ",product_group"+
							  ",so_qty"+
							  ",ship_qty"+
							  ",onhand_qty"+
							  ",pc_confirm_qty"+
							  ",unship_confirm_qty"+
							  ",uom"+
							  ",schedule_ship_date"+
							  ",pc_schedule_ship_date"+
							  ",net_weight"+
							  ",gross_weight"+
							  ",cube"+
							  ",pc_remark"+
							  ",packing_instructions"+
							  ",shipping_remark"+
							  ",region_code"+
							  ",po_no"+
							  ",carton_num_fr"+
							  ",carton_num_to"+
							  ",type"+
							  ",carton_qty"+
							  ",carton_per_qty"+
							  ",total_qty"+
							  ",tsc_package"+
							  ",tsc_family"+
							  ",pc_advise_id"+
							  ",parent_advise_line_id"+
							  ",file_id"+
							  ",packing_code"+
							  ",last_update_date"+
							  ",last_updated_by"+
							  ",creation_date"+
							  ",created_by"+
							  ",last_update_login"+
							  ",attribute1"+
							  ",attribute2"+
							  ",vendor_site_id"+
							  ",tew_advise_no"+
							  ",org_id"+
							  ",post_code"+
							  ",cubic_meter"+
							  ") "+
							  " SELECT ?,advise_header_id, a.so_header_id,"+
							  " a.so_line_id, a.so_no, a.so_line_number, a.delivery_detail_id,a.organization_id, a.inventory_item_id,"+
							  " a.item_no, a.item_desc,a.product_group, a.so_qty, ?, a.onhand_qty,a.pc_confirm_qty, a.unship_confirm_qty, a.uom,"+
							  " a.schedule_ship_date, a.pc_schedule_ship_date, a.net_weight, a.gross_weight,a.cube, a.pc_remark, a.packing_instructions,"+
							  " a.shipping_remark, a.region_code, a.po_no,"+
							  " ? carton_num_fr,? carton_num_to, 'LINE' type, ? carton_qty, ? carton_per_qty,? total_qty,"+
							  " a.tsc_package, a.tsc_family, a.pc_advise_id, null parent_advise_line_id, a.file_id, a.packing_code,"+
							  " sysdate last_update_date,last_updated_by,"+
							  " sysdate creation_date,created_by, null last_update_login, null attribute1, null attribute2,"+
							  " a.vendor_site_id,a.tew_advise_no,a.org_id,'',a.cubic_meter"+
							  " FROM tsc.tsc_shipping_advise_lines a "+
							  " WHERE advise_line_id =?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,advise_line_id);
						pstmtDt.setString(2,rs3.getString("qty"));
						pstmtDt.setString(3,rs3.getString("carton_no"));
						pstmtDt.setString(4,rs3.getString("carton_no"));
						pstmtDt.setString(5,"1");
						pstmtDt.setString(6,rs3.getString("qty"));
						pstmtDt.setString(7,rs3.getString("qty"));
						pstmtDt.setString(8,rs3.getString("advise_line_id"));
						pstmtDt.executeQuery();
						pstmtDt.close();
						
						sql = " update tsc.tsc_pick_confirm_lines b"+
							  " set advise_line_id=?"+
							  " where advise_header_id=?"+
							  " and advise_line_id=?"+
							  " and carton_no=?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,advise_line_id);
						pstmtDt.setString(2,rs3.getString("advise_header_id"));
						pstmtDt.setString(3,rs3.getString("advise_line_id"));
						pstmtDt.setString(4,rs3.getString("carton_no"));
						pstmtDt.executeQuery();
						pstmtDt.close();	
						
						//ADD BY PEGGY 20210421
						sql = " update tsc.tsc_shipping_advise_lines b"+
							  " set  (CARTON_NUM_FR,CARTON_NUM_TO,CARTON_QTY,CARTON_PER_QTY,TOTAL_QTY,SHIP_QTY)=(SELECT min(to_number(carton_no)),max(to_number(carton_no)), max(to_number(carton_no))-min(to_number(carton_no))+1,sum(QTY)/(max(to_number(carton_no))-min(to_number(carton_no))+1),sum(QTY),sum(QTY) FROM tsc.tsc_pick_confirm_lines a WHERE a.advise_line_id=b.advise_line_id)"+
							  " where tew_advise_no=?"+
							  " and advise_line_id=?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,ADVISE_NO);
						pstmtDt.setString(2,rs3.getString("advise_line_id"));
						pstmtDt.executeQuery();
						pstmtDt.close();																					
					}
				}
				rs3.close();
				statement3.close();
				
				//刪除不在pick confirm裡的advise line id
				sql =" delete tsc.tsc_shipping_advise_lines a"+
                     " where TEW_ADVISE_NO=?"+
                     " and not exists (select 1 from tsc.tsc_pick_confirm_lines b where b.tew_advise_no=a.tew_advise_no"+
                     " and b.advise_header_id=a.advise_header_id"+
                     " and b.advise_line_id=a.advise_line_id)";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				//檢查advise 數量與pc出貨通知數量是否相符
				sql = " select x.* from (select tew_advise_no,so_no,so_line_number,so_line_id,sum(SHIP_QTY) ship_qty,nvl(( select SHIP_QTY from tsc.tsc_shipping_advise_pc_sg b where b.pc_advise_id=a.pc_advise_id),0) pc_ship_qty FROM tsc.tsc_shipping_advise_lines a"+
                      " where tew_advise_no in ('"+ADVISE_NO+"')"+
                      " group by tew_advise_no,so_no,so_line_number,so_line_id,pc_advise_id) x"+
                      " where x.ship_qty-x.pc_ship_qty<>0";
				Statement statement11=con.createStatement();
				ResultSet rs11=statement11.executeQuery(sql);
				if (rs11.next())
				{
					throw new Exception("編箱出貨量與PC排定出貨量不符");
				}
				rs11.close();
				statement11.close();	
				
				//檢查advise 數量,箱號與撿貨數量,箱號是否相符
				//sql = " SELECT x.* FROM (select A.tew_aDvise_no,a.so_line_id,a.advise_line_id,a.ship_qty,NVL((select sum(qty) from tsc.tsc_pick_confirm_lines b where b.advise_line_id=a.advise_line_id),0) PICK_QTY"+
                //      " from tsc.tsc_shipping_advise_lines a"+
                //      " where tew_advise_no in ('"+ADVISE_NO+"')) X"+
                //      " WHERE X.SHIP_QTY-x.PICK_QTY <>0";
				sql = " SELECT x.* FROM (select A.tew_aDvise_no,a.so_line_id,a.advise_line_id,a.ship_qty,a.carton_num_fr,a.carton_num_to,sum(b.qty) pick_qty,min(to_number(b.carton_no)) pick_s_carton,max(to_number(b.carton_no)) pick_e_carton"+
                      " from tsc.tsc_shipping_advise_lines a,tsc.tsc_pick_confirm_lines b"+
                      " where a.tew_advise_no in ('"+ADVISE_NO+"')"+
                      " and b.advise_line_id=a.advise_line_id"+
                      " group by A.tew_aDvise_no,a.so_line_id,a.advise_line_id,a.ship_qty,a.carton_num_fr,a.carton_num_to) x"+
                      " WHERE X.SHIP_QTY-x.PICK_QTY <>0 or x.carton_num_fr <>x.pick_s_carton"+
                      " or x.carton_num_to<>x.pick_e_carton";
				statement11=con.createStatement();
				rs11=statement11.executeQuery(sql);
				if (rs11.next())
				{
					throw new Exception("編箱出貨量與撿貨量不符");
				}
				rs11.close();
				statement11.close();	
													  					 
				sql = " update tsc.tsc_shipping_advise_lines a"+
                      " set (NET_WEIGHT,GROSS_WEIGHT)=(SELECT case when mod(y.SHIP_QTY,y.CARTON_QTY)=0 then y.NW else case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) < 0.01 then 0.01 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) end end as ACT_NW"+
					  "      ,null"+ //毛重單獨重算,add by Peggy 20201204
                      //" ,case when mod(y.SHIP_QTY,y.CARTON_QTY)=0 then y.GW else case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) < 1 and y.carton_cnt=1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) end end as ACT_GW"+
                      "       FROM (SELECT x.* ,row_number() over (partition by x.ADVISE_LINE_ID order by SEQNO) ROWSEQ"+
                      "            FROM (select 1 SEQNO,a.vendor_id,a.vendor_site_code,a.ADVISE_LINE_ID,a.SO_NO,a.ITEM_DESC,a.SHIPPING_REMARK,a.CARTON_PER_QTY  SHIP_QTY,b.CARTON_QTY,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.product_group,a.tsc_package,a.packing_code,a.CARTON_QTY carton_cnt,a.carton_num_fr "+
                      //"                  FROM (select c.vendor_id,c.vendor_site_code,a.*,count(1) over (partition by a.tew_advise_no,a.carton_num_fr) carton_cnt from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
					  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
                      "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
                      "                  where TEW_ADVISE_NO in (?)"+
                      "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
                      "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
                      "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
                      "                  and a.vendor_id = b.vendor_id(+)"+
                      "                  and a.ITEM_DESC =b.TSC_PARTNO(+)"+
                      "                  and b.TSC_PARTNO is not null"+
                      "                  UNION ALL"+
                      "                  select 2 SEQNO,a.vendor_id,a.vendor_site_code,a.ADVISE_LINE_ID,a.SO_NO,a.ITEM_DESC,a.SHIPPING_REMARK,a.CARTON_PER_QTY  HIP_QTY,b.CARTON_QTY,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.product_group,a.tsc_package,a.packing_code,a.CARTON_QTY carton_cnt,a.carton_num_fr "+
                      //"                  FROM (select c.vendor_id,c.vendor_site_code,a.*,count(1) over (partition by a.tew_advise_no,a.carton_num_fr) carton_cnt from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
					  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
                      "                       ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
                      "                  where TEW_ADVISE_NO in (?)"+
                      "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
                      "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
                      "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
                      "                  and a.vendor_id = b.vendor_id(+)"+
                      "                  and b.TSC_PARTNO is null"+
                      "                  ORDER BY vendor_site_code,SHIPPING_REMARK"+
                      "                  ) x"+
                      "           ) y where ROWSEQ=1 and y.advise_line_id=a.advise_line_id)"+
                      " where tew_advise_no=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.setString(3,ADVISE_NO);
				pstmtDt.executeQuery();
				pstmtDt.close();					  

				//add by Peggy 20201204
				sql = " update tsc.tsc_shipping_advise_lines a"+
                      " set (GROSS_WEIGHT)=(select case when mod(y.SHIP_QTY,y.CARTON_QTY)=0 then y.GW else case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) < 1 and y.carton_cnt=1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) end end as ACT_GW"+
                      "   from (SELECT x.* ,row_number() over (partition by x.carton_num_fr order by SEQNO,CARTON_RANK) ROWSEQ"+
                      "            FROM (select 1 SEQNO,a.vendor_id,a.vendor_site_code,a.ADVISE_LINE_ID,a.SO_NO,a.ITEM_DESC,a.SHIPPING_REMARK,sum(a.CARTON_PER_QTY) over (partition by a.carton_num_fr)  SHIP_QTY,b.CARTON_QTY,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.product_group,a.tsc_package,a.packing_code,a.CARTON_QTY carton_cnt,a.carton_num_fr "+
                      "                  ,row_number() over (partition by a.carton_num_fr  order by a.advise_line_id) carton_rank"+
                      "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
                      "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
                      "                  where TEW_ADVISE_NO in (?)"+
                      "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
                      "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
                      "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
                      "                  and a.vendor_id = b.vendor_id(+)"+
                      "                  and a.ITEM_DESC =b.TSC_PARTNO(+)"+
                      "                  and b.TSC_PARTNO is not null"+
                      "                  UNION ALL"+
                      "                  select 2 SEQNO,a.vendor_id,a.vendor_site_code,a.ADVISE_LINE_ID,a.SO_NO,a.ITEM_DESC,a.SHIPPING_REMARK,sum(a.CARTON_PER_QTY) over (partition by a.carton_num_fr)  HIP_QTY,b.CARTON_QTY,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,a.product_group,a.tsc_package,a.packing_code,a.CARTON_QTY carton_cnt,a.carton_num_fr "+
                      "                  ,row_number() over (partition by a.carton_num_fr  order by a.advise_line_id) carton_rank"+
                      "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+)) a"+
                      "                       ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
                      "                  where TEW_ADVISE_NO in (?)"+
                      "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
                      "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
                      "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
                      "                  and a.vendor_id = b.vendor_id(+)"+
                      "                  and b.TSC_PARTNO is null"+
                      "                  ORDER BY vendor_site_code,SHIPPING_REMARK"+
                      "                  ) x"+
                      "          ) y where ROWSEQ=1 and y.advise_line_id=a.advise_line_id)"+
                      " where tew_advise_no=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.setString(3,ADVISE_NO);
				pstmtDt.executeQuery();
				pstmtDt.close();					  
				
				sql = " update tsc.tsc_shipping_advise_lines b"+
				      " set b.cubic_meter=0"+
					  " where b.tew_advise_no=?"+
					  " and exists  (select 1 from (select advise_line_id,carton_num_fr,rank() over (partition by carton_num_fr order by advise_line_id) carton_rank "+
					  " FROM tsc.tsc_shipping_advise_lines a  where tew_advise_no =?) x where x.carton_rank <>1 and x.advise_line_id=b.advise_line_id)";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,ADVISE_NO);
				pstmtDt.executeQuery();
				pstmtDt.close();
				out.println("<font style='font-family:arial;font-size:12px'>         4.批號分配作業完成</font>");
									  
				sql = " UPDATE oraddman.tssg_stock_overview A"+
                      " SET SHIPPED_QTY=nvl(SHIPPED_QTY,0)+nvl((SELECT SUM(QTY) FROM tsc.tsc_pick_confirm_headers X,tsc.tsc_pick_confirm_lines Y"+
                      " WHERE X.PICK_CONFIRM_DATE IS NOT NULL "+
                      " AND X.ADVISE_HEADER_ID=Y.ADVISE_HEADER_ID"+
					  " AND X.ADVISE_NO=?"+
                      " AND Y.SG_STOCK_ID=A.SG_STOCK_ID),0)"+
					  " WHERE EXISTS (SELECT 1 FROM  oraddman.TSSG_LOT_DISTRIBUTION_TEMP b WHERE b.SG_DISTRIBUTION_ID=? and b.sg_stock_id=a.sg_stock_id)";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ADVISE_NO);
				pstmtDt.setString(2,DISTRIBUTION_ID);
				pstmtDt.executeQuery();
				pstmtDt.close();
				out.println("<font style='font-family:arial;font-size:12px'>        5.出貨確認作業完成<br></font>");

				advise_cnt++;
				ADVISE_LIST =ADVISE_LIST+ADVISE_NO+"<br>";
			}
			rs2.close();
			statement2.close();
										
			con.commit();
			out.println("<div style='color:#0000ff;font-family:arial;font-size:12px'>上傳成功,共產生"+advise_cnt+"筆Advise..<br>"+ADVISE_LIST+"</div>");
				
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>上傳失敗!!錯誤原因如下說明<br>"+e.getMessage()+"<br>上述完成交易已全數取消...</div>");
		}
	}
	
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();		
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
