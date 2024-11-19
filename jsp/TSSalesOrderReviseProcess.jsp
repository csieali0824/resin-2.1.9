<!--20160503 by Peggy,FOR TSCH ORDER RESCHEDULE-->
<!--20160713 by Peggy,add resend參數-->
<!--20170426 by Peggy,記錄resend原始temp_id及seq_id-->
<!--20181222 by Peggy,新增original customer part no-->
<!--20190225 by Peggy,add End customer part name-->
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
<title>Sales Order Revise Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
function setExcel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSalesOrderReviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql11="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt11=con.prepareStatement(sql11);
pstmt11.executeUpdate(); 
pstmt11.close();

String sql ="",vRequestNo="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String temp_id = request.getParameter("ID");
if (temp_id==null) temp_id="";
String RESEND_FLAG = request.getParameter("RESEND_FLAG");  //add by Peggy 20160713
if (RESEND_FLAG==null) RESEND_FLAG="";
String REQUESTNO="",resend_id="";
String V_PASS_WORD="CFM FROM FACTORY";  //add by Peggy 20220810
String V_PASS_DELTA="DELTA FOR SHIP REVISE";  //add by Peggy 20230310
int v_edi_cnt =0;  //add by Peggy 20190319
String pc_adj_remark="PC調整";  //add by Peggy 20230824

if (ACODE.equals("SAVE"))
{
	try
	{
		sql = " select 1 from oraddman.tsc_om_salesorderrevise_temp a"+
			  " where temp_id='"+temp_id+"'"+
			  " and CREATED_BY='"+ UserName+"'"+
			  " and not exists (select 1 from oraddman.tsc_om_salesorderrevise_req b"+
			  " where b.temp_id=a.temp_id"+
			  " and b.seq_id=a.seq_id)";
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if (!rs.next())
		{
			throw new Exception("No Data Found!!");
		}
		rs.close();
		statement.close();
		
		//檢查訂單是否申請中或已confirm未處理
		sql = " select DISTINCT SO_NO,LINE_NO from ORADDMAN.TSC_OM_SALESORDERREVISE_REQ a"+
              " where A.STATUS NOT IN ('CLOSED','CANCELLED')"+
              " and exists (select 1 from ORADDMAN.TSC_OM_SALESORDERREVISE_TEMP b"+
              " where b.SO_HEADER_ID=a.SO_HEADER_ID"+
              " and b.SO_LINE_ID=a.SO_LINE_ID"+
              " and b.TEMP_ID='"+temp_id+"')";
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql);
		int cnt=0;
		while (rs1.next())
		{
			if (cnt==0)
			{
				out.println("<div>The following orders have not been processed to complete..</div>");
				out.println("<div>MO#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Line#</div>");
				out.println("<div>===============================================</div>");
			}
			out.println("<div>"+rs1.getString("so_no")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+rs1.getString("line_no")+"</div>");
			cnt++;
		}
		rs1.close();
		statement1.close();
		if (cnt >0)
		{
			out.println("<div>===============================================</div>");
			throw new Exception("");		
		}
		for (int i = 1 ; i <=Integer.parseInt(request.getParameter("ROWCNT")); i++)
		{
			sql = " update oraddman.tsc_om_salesorderrevise_temp a"+
			      " set change_reason=?"+
     			  ",change_comments=?"+
				  ",CHANGE_REASON_CODE=( SELECT lookup_code  FROM fnd_lookup_values WHERE lookup_type = ? AND language = ? AND enabled_flag = ? AND meaning =?)"+
				  ",remarks=?"+
				  //",schedule_ship_date= case'"+RESEND_FLAG+"' when 'Y' then to_date(?,'yyyymmdd') else schedule_ship_date end "+  //add by Peggy 20160713
				  //",shipping_method= case'"+RESEND_FLAG+"' when 'Y'  then ? else shipping_method end "+  //add by Peggy 20160905
				  //",request_date=case'"+RESEND_FLAG+"' when 'Y'  then to_date(?,'yyyymmdd') else request_date end "+  //add by Peggy 20170426
				  //",so_qty=case'"+RESEND_FLAG+"' when 'Y'  then to_number(?) else so_qty end "+  //add by Peggy 20170612
				  ",schedule_ship_date= to_date(?,'yyyymmdd')-nvl(to_tw_days,0) "+  //add by Peggy 20190827SELECT 
				  ",schedule_ship_date_tw= to_date(?,'yyyymmdd') "+  //add by Peggy 20190827SELECT 
				  ",shipping_method= ? "+  //add by Peggy 20190827
				  ",request_date=to_date(?,'yyyymmdd') "+  //add by Peggy 20190827
				  ",so_qty=to_number(?)"+  //add by Peggy 20190827
				  " where temp_id=?"+				  
				  " and seq_id=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,(request.getParameter("CHANGE_REASON_"+i).equals("--")?null:request.getParameter("CHANGE_REASON_"+i)));
			pstmtDt.setString(2,request.getParameter("CHANGE_COMMENTS_"+i));
			pstmtDt.setString(3,"CANCEL_CODE");
			pstmtDt.setString(4,"US");
			pstmtDt.setString(5,"Y");
			pstmtDt.setString(6,(request.getParameter("CHANGE_REASON_"+i).equals("--")?null:request.getParameter("CHANGE_REASON_"+i)));
			pstmtDt.setString(7,request.getParameter("REMARKS_"+i));
			pstmtDt.setString(8,(request.getParameter("CHANGE_SSD_"+i)==null?"":request.getParameter("CHANGE_SSD_"+i)));  //add by Peggy 20160713
			pstmtDt.setString(9,(request.getParameter("CHANGE_SSD_"+i)==null?"":request.getParameter("CHANGE_SSD_"+i)));  //add by Peggy 20160713
			pstmtDt.setString(10,(request.getParameter("SHIPMETHOD_"+i)==null?"":request.getParameter("SHIPMETHOD_"+i)));  //add by Peggy 20160905
			pstmtDt.setString(11,(request.getParameter("CHANGE_REQ_DATE_"+i)==null?"":request.getParameter("CHANGE_REQ_DATE_"+i)));  //add by Peggy 20170426
			pstmtDt.setString(12,(request.getParameter("CHANGE_QTY_"+i)==null?"":request.getParameter("CHANGE_QTY_"+i)));  //add by Peggy 20170426
			pstmtDt.setString(13,temp_id);
			pstmtDt.setString(14,request.getParameter("SEQ_ID_"+i));
			pstmtDt.executeQuery();
			pstmtDt.close();				  
		}
		
		sql = "select tsc_order_revise_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual";
		statement=con.createStatement();
		rs=statement.executeQuery(sql);
		if (!rs.next())
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			REQUESTNO=rs.getString(1);
		}
		rs.close();
		statement.close();		
		
		sql = "insert into oraddman.tsc_om_salesorderrevise_req"+
			  "("+
			  " sales_group"+
			  ",so_no"+
			  ",line_no"+
			  ",source_customer_id"+
			  ",so_header_id"+
			  ",so_line_id"+
			  ",order_type"+
			  ",customer_number"+
			  ",customer_name"+
			  ",ship_to_org_id"+
			  ",ship_to"+
			  ",tsc_prod_group"+
			  ",inventory_item_id"+
			  ",item_name"+
			  ",item_desc"+
			  ",cust_item_id"+
			  ",cust_item_name"+
			  ",customer_po"+
			  ",shipping_method"+
			  ",so_qty"+
			  ",Request_date"+
			  ",schedule_ship_date"+
			  ",packing_instructions"+
			  ",plant_code"+
			  ",change_reason"+
			  ",change_comments"+
			  ",created_by"+
			  ",creation_date"+
			  ",last_updated_by"+
			  ",last_update_date"+
			  ",status"+
			  ",temp_id"+
			  ",seq_id"+
			  ",remarks"+	
			  ",CUSTOMER_ID_REF"+
			  ",CUSTOMER_PO_REF"+		  
			  ",CUSTOMER_PO_LINE_REF"+
			  ",VERSION_ID_REF"+
			  ",SOURCE_CUSTOMER_PO"+
			  ",SOURCE_REQUEST_DATE"+
			  ",SOURCE_SSD"+
			  ",SOURCE_SO_QTY"+
			  ",SOURCE_ITEM_ID"+
			  ",SOURCE_ITEM_DESC"+
			  ",SOURCE_CUST_ITEM_ID"+
			  ",SOURCE_CUST_ITEM_NAME"+
			  ",SOURCE_SHIP_FROM_ORG_ID"+
			  ",SOURCE_SHIPPING_METHOD"+
			  ",SOURCE_SHIP_TO_ORG_ID"+
			  ",SHIP_TO_LOCATION_ID"+
			  ",DELIVER_TO_LOCATION_ID"+
			  ",DELIVER_TO_ORG_ID"+
			  ",DELIVER_TO"+
			  ",SOURCE_DELIVER_TO_ORG_ID"+
              ",BILL_TO_LOCATION_ID"+
			  ",BILL_TO_ORG_ID"+
			  ",BILL_TO"+
			  ",SOURCE_BILL_TO_ORG_ID"+			  
			  ",REQUEST_NO"+
			  ",SOURCE_BILL_TO_LOCATION_ID"+
			  ",SOURCE_SHIP_TO_LOCATION_ID"+
			  ",SOURCE_DELIVER_TO_LOCATION_ID"+
			  ",FOB_POINT_CODE"+
			  ",SOURCE_FOB_POINT_CODE"+
			  ",FOB"+
			  ",TAX_CODE"+
			  ",SOURCE_TAX_CODE"+
			  ",SEND_FROM_TEMP_ID"+   //add by Peggy 20170426
			  ",SEND_FROM_SEQ_ID"+    //add by Peggy 20170426
			  ",SOURCE_SELLING_PRICE"+
			  ",SELLING_PRICE"+
			  ",SOURCE_CURRENCY_CODE"+
			  ",CURRENCY_CODE"+
			  ",SOURCE_PRICE_LIST_ID"+
			  ",LIST_PRICE"+	
			  ",SOURCE_END_CUSTOMER_ID"+
			  ",SOURCE_END_CUSTOMER_NO"+
			  ",END_CUSTOMER_ID"+
			  ",END_CUSTOMER_NO"+	
			  ",NEW_TSCH_SO_NO"+
			  ",NEW_TSCH_LINE_NO"+
			  ",NEW_TSCH_END_CUSTOMER"+
			  ",SOURCE_TSCH_SO_NO"+
			  ",SOURCE_TSCH_LINE_NO"+
			  ",SOURCE_TSCH_END_CUSTOMER"+	 
			  ",END_CUSTOMER_PARTNO"+         //add by Peggy 20190225 
			  ",SOURCE_END_CUSTOMER_PARTNO"+  //add by Peggy 20190225 
			  ",SOURCE_YEW_SSD"+              //add by Peggy 20190320
			  ",SCHEDULE_SHIP_DATE_TW"+       //add by Peggy 20191004
			  ",TO_TW_DAYS"+                  //add by Peggy 20191004
			  ",SYSTEM_REMARKS"+              //add by Peggy 20201023
			  ",SUPPLIER_NUMBER"+             //add by Peggy 20220428
			  ",SOURCE_SUPPLIER_NUMBER"+      //add by Peggy 20220428
			  ",HOLD_CODE"+                   //add by Peggy 20230325
			  ",HOLD_REASON"+                 //add by Peggy 20230325
			  ",NEW_HOLD_CODE"+               //add by Peggy 20230325
			  ",NEW_HOLD_REASON"+             //add by Peggy 20230325
			  ",NEW_FORECAST_SSD"+            //add by Peggy 20230412
			  ",CANCEL_MOVE_FLAG"+            //add by Peggy 20230414
			  ",CHANGE_REASON_CODE"+          //add by Peggy 20230419
			  ",AUTOCONFIRM_NOTICE_DATE"+     //add by Peggy 20230512
			  ")"+
			  " SELECT "+
			  " sales_group"+
			  ",so_no"+
			  ",line_no"+
			  ",source_customer_id"+
			  ",so_header_id"+
			  ",so_line_id"+
			  ",order_type"+
			  ",customer_number"+
			  ",customer_name"+
			  ",ship_to_org_id"+
			  ",ship_to"+
			  ",tsc_prod_group"+
			  ",inventory_item_id"+
			  ",item_name"+
			  ",item_desc"+
			  ",cust_item_id"+
			  ",cust_item_name"+
			  ",customer_po"+
			  ",shipping_method"+
			  ",so_qty"+
			  ",Request_date"+
			  ",schedule_ship_date"+
			  ",packing_instructions"+
			  ",plant_code"+
			  ",change_reason"+
			  ",change_comments"+
			  ",?"+
			  ",sysdate"+
			  ",?"+
			  ",sysdate"+
			  ",case when CANCEL_MOVE_FLAG in (?,?) then ? else ? end"+
			  ",temp_id"+
			  ",seq_id"+	
			  ",remarks"+	
			  ",CUSTOMER_ID_REF"+
			  ",CUSTOMER_PO_REF"+		  
			  ",CUSTOMER_PO_LINE_REF"+
			  ",VERSION_ID_REF"+
			  ",SOURCE_CUSTOMER_PO"+
			  ",SOURCE_REQUEST_DATE"+
			  ",SOURCE_SSD"+
			  ",SOURCE_SO_QTY"+
			  ",SOURCE_ITEM_ID"+
			  ",SOURCE_ITEM_DESC"+
			  ",SOURCE_CUST_ITEM_ID"+
			  ",SOURCE_CUST_ITEM_NAME"+
			  ",SOURCE_SHIP_FROM_ORG_ID"+
			  ",SOURCE_SHIPPING_METHOD"+
			  ",SOURCE_SHIP_TO_ORG_ID"+
			  ",SHIP_TO_LOCATION_ID"+
			  ",DELIVER_TO_LOCATION_ID"+
			  ",DELIVER_TO_ORG_ID"+
			  ",DELIVER_TO"+
			  ",SOURCE_DELIVER_TO_ORG_ID"+	
              ",BILL_TO_LOCATION_ID"+
			  ",BILL_TO_ORG_ID"+
			  ",BILL_TO"+
			  ",SOURCE_BILL_TO_ORG_ID"+					  
			  //",tsc_order_revise_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd'))"+	
			  ",?"+	  
			  ",SOURCE_BILL_TO_LOCATION_ID"+
			  ",SOURCE_SHIP_TO_LOCATION_ID"+
			  ",SOURCE_DELIVER_TO_LOCATION_ID"+
			  ",FOB_POINT_CODE"+
			  ",SOURCE_FOB_POINT_CODE"+
			  ",FOB"+
			  ",TAX_CODE"+
			  ",SOURCE_TAX_CODE"+
			  ",SEND_FROM_TEMP_ID"+  //add by Peggy 20170426
			  ",SEND_FROM_SEQ_ID"+  //add by Peggy 20170426
			  ",SOURCE_SELLING_PRICE"+
			  ",SELLING_PRICE"+
			  ",SOURCE_CURRENCY_CODE"+ 
			  ",CURRENCY_CODE"+
			  ",SOURCE_PRICE_LIST_ID"+
			  ",LIST_PRICE"+
			  ",SOURCE_END_CUSTOMER_ID"+
			  ",SOURCE_END_CUSTOMER_NO"+
			  ",END_CUSTOMER_ID"+
			  ",END_CUSTOMER_NO"+	
			  ",NEW_TSCH_SO_NO"+
			  ",NEW_TSCH_LINE_NO"+
			  ",NEW_TSCH_END_CUSTOMER"+
			  ",SOURCE_TSCH_SO_NO"+
			  ",SOURCE_TSCH_LINE_NO"+
			  ",SOURCE_TSCH_END_CUSTOMER"+	  	
			  ",END_CUSTOMER_PARTNO"+
			  ",SOURCE_END_CUSTOMER_PARTNO"+	
			  ",SOURCE_YEW_SSD"+ //add by Peggy 20190320	  
			  ",SCHEDULE_SHIP_DATE_TW"+       //add by Peggy 20191004
			  ",TO_TW_DAYS"+                  //add by Peggy 20191004
			  ",SYSTEM_REMARKS"+              //add by Peggy 20201023
			  ",SUPPLIER_NUMBER"+             //add by Peggy 20220428
			  ",SOURCE_SUPPLIER_NUMBER"+      //add by Peggy 20220428
			  ",HOLD_CODE"+                   //add by Peggy 20230325
			  ",HOLD_REASON"+                 //add by Peggy 20230325
			  ",NEW_HOLD_CODE"+               //add by Peggy 20230325
			  ",NEW_HOLD_REASON"+             //add by Peggy 20230325	
			  ",NEW_FORECAST_SSD"+            //add by Peggy 20230412	
			  ",CANCEL_MOVE_FLAG"+            //add by Peggy 20230414	  
			  ",CHANGE_REASON_CODE"+          //add by Peggy 20230419
			  ",AUTOCONFIRM_NOTICE_DATE"+     //add by Peggy 20230512
			  " from oraddman.tsc_om_salesorderrevise_temp a"+
			  " where temp_id=?";
		//out.println(sql);
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,UserName);
		pstmtDt.setString(2,UserName);
		pstmtDt.setString(3,"N");
		pstmtDt.setString(4,"1");				
		pstmtDt.setString(5,"AWAITING_CONFIRM");		
		pstmtDt.setString(6,"AWAITING_APPROVE");
		pstmtDt.setString(7,REQUESTNO);
		pstmtDt.setString(8,temp_id);
		pstmtDt.executeQuery();
		pstmtDt.close();
		con.commit();
		
		//TSCC只改SHIP TO自動CONFIRM,add by Peggy 20201216
		sql = " UPDATE oraddman.tsc_om_salesorderrevise_req a"+
              " SET STATUS=?"+
              ",PC_CONFIRMED_RESULT=?"+
              ",PC_SO_QTY=NVL(SO_QTY,SOURCE_SO_QTY)"+
              //",PC_SCHEDULE_SHIP_DATE=NVL(SCHEDULE_SHIP_DATE,SOURCE_SSD)-NVL(TO_TW_DAYS,0)"+
			  ",PC_SCHEDULE_SHIP_DATE=NVL(SCHEDULE_SHIP_DATE,SOURCE_SSD)"+ //modify by Peggy 20220127
              ",PC_CONFIRMED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
              ",PC_CONFIRMED_DATE=SYSDATE"+
              ",PC_REMARKS=?||SALES_GROUP||?"+
              ",LAST_UPDATED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
              ",LAST_UPDATE_DATE=SYSDATE"+
              ",PC_CONFIRM_ID=apps.tsc_order_revise_pc_id_s.nextval"+
              " WHERE REQUEST_NO=?"+
              " AND ("+
			  "    ((((INSTR(SALES_GROUP,?)>0 OR INSTR(SALES_GROUP,?)>0)"+
			  " AND CREATED_BY in (?,?)"+
              " AND BILL_TO_ORG_ID IS NULL"+
              " AND DELIVER_TO_ORG_ID IS NULL"+
              " AND SHIPPING_METHOD IS NULL"+
              " AND FOB_POINT_CODE IS NULL)"+
			  " OR (SALES_GROUP=? AND instr(upper(REMARKS),?)>0))"+
			  " AND PLANT_CODE IN (?,?,?,?,?,?)"+ //add ILAN PMD/A01/ TEW PMD by Peggy 20210207
              " AND ORDER_TYPE IS NULL "+
              " AND CUSTOMER_NUMBER IS NULL"+
              " AND SHIP_TO_ORG_ID IS NOT NULL"+
              " AND NVL(INVENTORY_ITEM_ID,SOURCE_ITEM_ID)=SOURCE_ITEM_ID"+
              " AND CUST_ITEM_ID IS NULL"+
              " AND CUSTOMER_PO IS NULL"+
              " AND SO_QTY IS NULL"+
              " AND REQUEST_DATE IS NULL"+
              " AND NVL(SCHEDULE_SHIP_DATE+TO_TW_DAYS,SOURCE_SSD)=SOURCE_SSD"+
              " AND TAX_CODE IS NULL"+
              " AND HOLD_CODE IS NULL"+
              " AND HOLD_REASON IS NULL"+
              " AND END_CUSTOMER_ID IS NULL"+
              " AND SELLING_PRICE IS NULL"+
              " AND CURRENCY_CODE IS NULL)"+
			  " OR instr(upper(REMARKS),?)>0"+ //add by Peggy 20220810
			  " OR instr(upper(REMARKS),?)>0)";//add by Peggy 20230310 
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,"CONFIRMED");
		pstmtDt.setString(2,"A");
		pstmtDt.setString(3,"002");
		pstmtDt.setString(4,"AMANDA");
		pstmtDt.setString(5,"005");
		pstmtDt.setString(6,"AGGIE");
		pstmtDt.setString(7,"008");
		pstmtDt.setString(8,"PRDPC");
		pstmtDt.setString(9,"006");
		pstmtDt.setString(10,"ESTHER");
		pstmtDt.setString(11,"010");
		pstmtDt.setString(12,"MAY");
		pstmtDt.setString(13,"011");
		pstmtDt.setString(14,"AGGIE_P");
		pstmtDt.setString(15,"");
		pstmtDt.setString(16,"Auto Confirm For ");
		pstmtDt.setString(17," ship issue");
		pstmtDt.setString(18,"002");
		pstmtDt.setString(19,"AMANDA");
		pstmtDt.setString(20,"005");
		pstmtDt.setString(21,"AGGIE");
		pstmtDt.setString(22,"008");
		pstmtDt.setString(23,"PRDPC");
		pstmtDt.setString(24,"006");
		pstmtDt.setString(25,"ESTHER");
		pstmtDt.setString(26,"010");
		pstmtDt.setString(27,"MAY");
		pstmtDt.setString(28,"011");
		pstmtDt.setString(29,"AGGIE_P");		
		pstmtDt.setString(30,"");
		pstmtDt.setString(31,REQUESTNO);
		pstmtDt.setString(32,"TSCC");
		pstmtDt.setString(33,"TSCH");
		pstmtDt.setString(34,"TSCC JOYCE");
		pstmtDt.setString(35,"COCO");
		pstmtDt.setString(36,"TSCA");
		pstmtDt.setString(37,"DROP SHIP");
		pstmtDt.setString(38,"002");
		pstmtDt.setString(39,"005");
		pstmtDt.setString(40,"008");
		pstmtDt.setString(41,"006");
		pstmtDt.setString(42,"010");
		pstmtDt.setString(43,"011");
		pstmtDt.setString(44,V_PASS_WORD);   //add by Peggy 20220810
		pstmtDt.setString(45,V_PASS_DELTA);  //add by Peggy 20230310
		pstmtDt.executeQuery();
		pstmtDt.close();		  
		con.commit();
		
		sql = " SELECT a.sales_group,a.temp_id,a.seq_id,row_number() over (partition by a.temp_id order by a.seq_id) row_seq"+
		      " FROM oraddman.tsc_om_salesorderrevise_req a"+
	  		  " WHERE REQUEST_NO=?"+
	          " AND STATUS=?"+
			  " order by a.temp_id,a.seq_id";
		PreparedStatement statement21 = con.prepareStatement(sql);
        statement21.setString(1,REQUESTNO);
        statement21.setString(2,"AWAITING_APPROVE");
		ResultSet rs21=statement21.executeQuery();		
        while (rs21.next())
        {
			sql = " insert into oraddman.tsc_om_salesorderrevise_wkfw"+
			      " (request_no, temp_id, seq_id, region_sales_head_person,hq_sales_head_person)"+
				  " values"+
				  " (?,?,?,?,?)";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUESTNO);
			pstmtDt.setInt(2,rs21.getInt("temp_id"));
			pstmtDt.setInt(3,rs21.getInt("seq_id"));
			if (rs21.getString("sales_group").startsWith("TSCE"))
			{
				pstmtDt.setString(4,"RALF_WELTER");
			}
			else if (rs21.getString("sales_group").startsWith("TSCA"))
			{
				pstmtDt.setString(4,"DAVID.LATOURETTE");
			}
			else if (rs21.getString("sales_group").startsWith("TSCJ"))
			{
				pstmtDt.setString(4,"SHIRATSUCHI");
			}	
			else if (rs21.getString("sales_group").startsWith("TSCK"))
			{	
				pstmtDt.setString(4,"MARK");
			}
			else if (rs21.getString("sales_group").startsWith("TSCH"))
			{
				pstmtDt.setString(4,"JODIE");
			}
			else if (rs21.getString("sales_group").startsWith("TSCC"))
			{
				pstmtDt.setString(4,"JODIE");			
			}
			else if (rs21.getString("sales_group").startsWith("TSCT"))
			{
				pstmtDt.setString(4,"RIKA_LIN");	
			}	
			else if (rs21.getString("sales_group").startsWith("TSCR"))
			{
				//pstmtDt.setString(4,"LISA");	
				pstmtDt.setString(4,"JUNE");  //modify by Peggy 20230728
			}	
			else if (rs21.getString("sales_group").startsWith("TSCI"))
			{
				pstmtDt.setString(4,"");	
			}												
			pstmtDt.setString(5,"AMY");				
			pstmtDt.executeQuery();
			pstmtDt.close();
			con.commit();
        }
		rs21.close();
		statement21.close();

		if (RESEND_FLAG.equals("Y"))
		{
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("Request No:<%=REQUESTNO%>\r Would you like to go to the order change confirmation job to process the next order(yes press OK, no press cancel)?"))
			{
				setSubmit("../jsp/TSSalesOrderReviseConfirm.jsp");
			}
			else
			{
				setSubmit("../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO=<%=REQUESTNO%>");
			}
		</script>
	<%			
		}
		else
		{
			int V_PASS_CNT=0;
			sql = " SELECT COUNT(1) FROM oraddman.tsc_om_salesorderrevise_req a"+
			      " WHERE REQUEST_NO=?"+
				  " AND instr(upper(REMARKS),?)+instr(upper(REMARKS),?)>0";
			PreparedStatement statement2 = con.prepareStatement(sql);
			statement2.setString(1,REQUESTNO);
			statement2.setString(2,V_PASS_WORD);
			statement2.setString(3,V_PASS_DELTA);
			ResultSet rs2=statement2.executeQuery();
			while (rs2.next())
			{
				V_PASS_CNT =rs2.getInt(1);
			}
			rs2.close();
			statement2.close();	
			
			if (V_PASS_CNT>0) 
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					setSubmit("../jsp/TSSalesOrderReviseConfirm.jsp?REQUESTNO=<%=REQUESTNO%>");
				</script>
			<%	
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					if (confirm("Request No:<%=REQUESTNO%>\r Do you want to process the next PULL IN/OUT upload(yes press OK, no press cancel)?"))
					{
						setSubmit("../jsp/TSSalesOrderReviseRequest.jsp");
					}
					else
					{
						setSubmit("../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO=<%=REQUESTNO%>");
					}
				</script>
			<%	
			}
		}	
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>Exceution Fail!!Please contact MIS!!<br>"+e.getMessage()+"<br><br><a href='TSSalesOrderReviseRequest.jsp'>回業務訂單變更申請作業</a></font>");
	}
}
else if (ACODE.equals("CONFIRMED"))
{
	try
	{
		String id="",pc_id="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.tsc_order_revise_pc_id_s.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				pc_id = rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			//String s_list ="";
			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tsc_om_salesorderrevise_req a"+
					  " set STATUS=?"+
					  ",PC_CONFIRMED_BY=?"+
					  ",PC_CONFIRMED_DATE=SYSDATE"+
					  ",PC_CONFIRMED_RESULT=?"+
					  ",PC_REMARKS=UTL_I18N.UNESCAPE_REFERENCE(NVL((SELECT PC_REMARKS from oraddman.tsc_om_salesorderrevise_u x where batch_id=? and x.temp_id=a.temp_id and x.seq_id=a.seq_id),?))"+  //解決html code字符問題 by Peggy 20201112
					  ",PC_CONFIRMED_REASON=nvl((select a_value from oraddman.tsc_rfq_setup WHERE A_CODE='PC_ORDER_CONFIRM_REASON' and a_seq=?),'')"+ //add by Peggy 20230907
					  ",PC_SCHEDULE_SHIP_DATE=to_date(?,'yyyymmdd')"+
					  ",PC_SO_QTY=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=SYSDATE"+
					  ",PC_CONFIRM_ID=?"+
					  " WHERE TEMP_ID=SUBSTR(?,1,INSTR(?,'.')-1)"+
					  " AND SEQ_ID=SUBSTR(?,INSTR(?,'.')+1)"+
					  " AND STATUS=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ACODE);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(4,request.getParameter("batchid"));
				pstmtDt.setString(5,request.getParameter("pcremark_"+chk[i]));
				pstmtDt.setString(6,(request.getParameter("PC_CONFIRM_REASON_"+chk[i]).equals("--")?"":request.getParameter("PC_CONFIRM_REASON_"+chk[i])));	//add by Peggy 20230907			
				pstmtDt.setString(7,(request.getParameter("rdo_"+chk[i]).equals("A")?request.getParameter("ssd_"+chk[i]):null));
				pstmtDt.setString(8,(request.getParameter("rdo_"+chk[i]).equals("A")?request.getParameter("qty_"+chk[i]):null));
				pstmtDt.setString(9,UserName);
				pstmtDt.setString(10,pc_id);
				pstmtDt.setString(11,chk[i]);
				pstmtDt.setString(12,chk[i]);
				pstmtDt.setString(13,chk[i]);
				pstmtDt.setString(14,chk[i]);
				pstmtDt.setString(15,"AWAITING_CONFIRM");
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			//PC合計同意數量與SALES不同時,差量部份要INSERT 原交期
			sql = " select TEMP_ID,SO_HEADER_ID,SO_LINE_ID, SO_QTY - PC_SO_QTY AS PC_SO_QTY"+
                  " from (select TEMP_ID,SO_HEADER_ID,SO_LINE_ID,sum(NVL(SO_QTY,SOURCE_SO_QTY)) SO_QTY,(select SUM(PC_SO_QTY) from oraddman.tsc_om_salesorderrevise_req b where b.temp_id=a.temp_id and b.SO_HEADER_ID=a.SO_HEADER_ID AND B.SO_LINE_ID=a.SO_LINE_ID and b.PC_CONFIRMED_RESULT='A') PC_SO_QTY FROM oraddman.tsc_om_salesorderrevise_req a"+
                  " where pc_confirm_id="+pc_id+
                  " group by TEMP_ID,SO_HEADER_ID,SO_LINE_ID ) x"+
                  " where SO_QTY > PC_SO_QTY AND PC_SO_QTY>0";
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(sql);
			int cnt=0;
			while (rs1.next())
			{
				//out.println(sql);
				sql = "insert into oraddman.tsc_om_salesorderrevise_req"+
					  "("+
					  " sales_group"+                    //0 
					  ",so_no"+                          //1
					  ",line_no"+                        //2
					  ",source_customer_id"+             //3
					  ",so_header_id"+                   //4
					  ",so_line_id"+                     //5
					  ",order_type"+                     //6
					  ",customer_number"+                //7
					  ",customer_name"+                  //8
					  ",ship_to_org_id"+                 //9
					  ",ship_to"+                        //10
					  ",tsc_prod_group"+                 //11
					  ",inventory_item_id"+              //12
					  ",item_name"+                      //13
					  ",item_desc"+                      //14
					  ",cust_item_id"+                   //15
					  ",cust_item_name"+                 //16
					  ",customer_po"+                    //17
					  ",shipping_method"+                //18
					  ",so_qty"+                         //19
					  ",Request_date"+                   //20 
					  ",schedule_ship_date"+             //21
					  ",packing_instructions"+           //22
					  ",plant_code"+                     //23
					  ",change_reason"+                  //24
					  ",change_comments"+                //25
					  ",created_by"+                     //26
					  ",creation_date"+                  //27
					  ",last_updated_by"+                //28
					  ",last_update_date"+               //29
					  ",status"+                         //30
					  ",temp_id"+                        //31
					  ",seq_id"+                         //32
					  ",remarks"+	                     //33
					  ",CUSTOMER_ID_REF"+                //34
					  ",CUSTOMER_PO_REF"+		         //35
					  ",CUSTOMER_PO_LINE_REF"+           //36
					  ",VERSION_ID_REF"+                 //37
					  ",SOURCE_CUSTOMER_PO"+             //38
					  ",SOURCE_REQUEST_DATE"+            //39
					  ",SOURCE_SSD"+                     //40
					  ",SOURCE_SO_QTY"+                  //41
					  ",SOURCE_ITEM_ID"+                 //42
					  ",SOURCE_ITEM_DESC"+               //43
					  ",SOURCE_CUST_ITEM_ID"+            //44
					  ",SOURCE_CUST_ITEM_NAME"+          //45
					  ",SOURCE_SHIP_FROM_ORG_ID"+        //46
					  ",SOURCE_SHIPPING_METHOD"+         //47
					  ",SOURCE_SHIP_TO_ORG_ID"+          //48
					  ",SOURCE_DELIVER_TO_ORG_ID"+       //49
					  ",REQUEST_NO"+                     //50
					  ",SHIP_TO_LOCATION_ID"+            //51
					  ",DELIVER_TO_LOCATION_ID"+         //52
					  ",DELIVER_TO_ORG_ID"+              //53
					  ",DELIVER_TO"+                     //54
					  ",PC_CONFIRMED_BY"+                //55
					  ",PC_CONFIRMED_DATE"+              //56
					  ",PC_CONFIRMED_RESULT"+            //57
					  ",PC_REMARKS"+                     //58
					  ",PC_SCHEDULE_SHIP_DATE"+          //59
					  ",PC_SO_QTY"+                      //60
					  ",BILL_TO_LOCATION_ID"+            //61
					  ",BILL_TO_ORG_ID"+                 //62
					  ",BILL_TO"+                        //63
					  ",SOURCE_BILL_TO_ORG_ID"+		     //64
					  ",SOURCE_SHIP_TO_LOCATION_ID"+	 //65
					  ",SOURCE_BILL_TO_LOCATION_ID"+     //66
					  ",SOURCE_DELIVER_TO_LOCATION_ID"+  //67
					  ",SOURCE_FOB_POINT_CODE"+          //68
					  ",TAX_CODE"+                       //69
					  ",TSCH_TEMP_ID"+                   //70:add by Peggy 20160503 for tsch
					  ",TSCH_SEQ_ID"+                    //71:add by Peggy 20160503 for tsch
         			  ",SOURCE_SELLING_PRICE"+           //72
		         	  ",SOURCE_CURRENCY_CODE"+			 //73
           			  ",END_CUSTOMER_PARTNO"+            //74:add by Peggy 20190225 
			          ",SOURCE_END_CUSTOMER_PARTNO"+     //75:add by Peggy 20190225 
					  ",SOURCE_YEW_SSD"+                 //76:add by Peggy 20190320
					  ",SCHEDULE_SHIP_DATE_TW"+          //77:add by Peggy 20191004
					  ",TO_TW_DAYS"+                     //78:add by Peggy 20191004
					  ",SUPPLIER_NUMBER"+                //79:add by Peggy 20220428
					  ",SOURCE_SUPPLIER_NUMBER"+         //80:add by Peggy 20220428
			          ",HOLD_CODE"+                      //81:add by Peggy 20230325
			          ",HOLD_REASON"+                    //82:add by Peggy 20230325
			          ",NEW_HOLD_CODE"+                  //83:add by Peggy 20230325
			          ",NEW_HOLD_REASON"+                //84:add by Peggy 20230325	
					  ",NEW_FORECAST_SSD"+               //85:add by Peggy 20230412
					  ",CANCEL_MOVE_FLAG"+               //86:add by Peggy 20230414
					  ",CHANGE_REASON_CODE"+             //87:add by Peggy 20230419
					  ",AUTOCONFIRM_NOTICE_DATE"+        //88:add by Peggy 20230512
					  ",PC_CONFIRMED_REASON"+            //89:add by Peggy 20230907
					  ")"+
					  " SELECT "+
					  " sales_group"+                    //0
					  ",so_no"+                          //1
					  ",line_no"+                        //2
					  ",source_customer_id"+             //3
					  ",so_header_id"+                   //4
					  ",so_line_id"+                     //5
					  ",order_type"+                     //6
					  ",customer_number"+                //7
					  ",customer_name"+                  //8
					  ",ship_to_org_id"+                 //9
					  ",ship_to"+                        //10
					  ",tsc_prod_group"+                 //11
					  ",inventory_item_id"+              //12
					  ",item_name"+                      //13
					  ",item_desc"+                      //14
					  ",cust_item_id"+                   //15
					  ",cust_item_name"+                 //16
					  ",customer_po"+                    //17 
					  ",shipping_method"+                //18
					  ",?"+                              //19
					  ",null"+                           //20
					  ",SOURCE_SSD-NVL(TO_TW_DAYS,0)"+   //21
					  ",packing_instructions"+           //22
					  ",plant_code"+                     //23
					  //",change_reason"+                  //24
					  ",'Qty and SSD Move'"+             //24,modify by Peggy 20230824
					  ",change_comments"+                //25
					  ",created_by"+                     //26
					  ",sysdate"+                        //27
					  ",?"+                              //28
					  ",sysdate"+                        //29
					  ",?"+                              //30
					  ",temp_id"+                        //31
					  ",(select max(seq_id)+1 from oraddman.tsc_om_salesorderrevise_req x where x.temp_id=a.temp_id)"+	 //32
					  ",remarks"+	                     //33
					  ",CUSTOMER_ID_REF"+                //34
					  ",CUSTOMER_PO_REF"+		         //35
					  ",CUSTOMER_PO_LINE_REF"+           //36
					  ",VERSION_ID_REF"+                 //37
					  ",SOURCE_CUSTOMER_PO"+             //38
					  ",SOURCE_REQUEST_DATE"+            //39
					  ",SOURCE_SSD"+                     //40
					  ",SOURCE_SO_QTY"+                  //41
					  ",SOURCE_ITEM_ID"+                 //42
					  ",SOURCE_ITEM_DESC"+               //43
					  ",SOURCE_CUST_ITEM_ID"+            //44
					  ",SOURCE_CUST_ITEM_NAME"+          //45
					  ",SOURCE_SHIP_FROM_ORG_ID"+        //46
					  ",SOURCE_SHIPPING_METHOD"+         //47
					  ",SOURCE_SHIP_TO_ORG_ID"+          //48
					  ",SOURCE_DELIVER_TO_ORG_ID"+       //49
					  ",REQUEST_NO"+                     //50
					  ",SHIP_TO_LOCATION_ID"+            //51
					  ",DELIVER_TO_LOCATION_ID"+         //52
					  ",DELIVER_TO_ORG_ID"+              //53
					  ",DELIVER_TO"+                     //54
					  ",?"+                              //55
					  ",sysdate"+                        //56
					  ",?"+                              //57
					  ",?"+                              //58
					  ",SOURCE_SSD-NVL(TO_TW_DAYS,0)"+   //59 
					  ",?"+                              //60
					  ",BILL_TO_LOCATION_ID"+            //61
					  ",BILL_TO_ORG_ID"+                 //62
					  ",BILL_TO"+                        //63
					  ",SOURCE_BILL_TO_ORG_ID"+			 //64
					  ",SOURCE_SHIP_TO_LOCATION_ID"+     //65
					  ",SOURCE_BILL_TO_LOCATION_ID"+	 //66	 
					  ",SOURCE_DELIVER_TO_LOCATION_ID"+  //67
					  ",SOURCE_FOB_POINT_CODE"+		     //68
					  ",TAX_CODE"+                       //69
					  ",TSCH_TEMP_ID"+                   //70:add by Peggy 20160503 for tsch
					  ",TSCH_SEQ_ID"+                    //71:add by Peggy 20160503 for tsch
         			  ",SOURCE_SELLING_PRICE"+           //72
		         	  ",SOURCE_CURRENCY_CODE"+	         //73	
           			  ",END_CUSTOMER_PARTNO"+            //74:add by Peggy 20190225 
			          ",SOURCE_END_CUSTOMER_PARTNO"+     //75:add by Peggy 20190225 
					  ",SOURCE_YEW_SSD"+                 //76:add by Peggy 20190320
					  ",SCHEDULE_SHIP_DATE_TW"+          //77:add by Peggy 20191004
					  ",TO_TW_DAYS"+                     //78:add by Peggy 20191004
					  ",SUPPLIER_NUMBER"+                //79:add by Peggy 20220428
					  ",SOURCE_SUPPLIER_NUMBER"+         //80:add by Peggy 20220428
			          ",HOLD_CODE"+                      //81:add by Peggy 20230325
			          ",HOLD_REASON"+                    //82:add by Peggy 20230325
			          ",NEW_HOLD_CODE"+                  //83:add by Peggy 20230325
			          ",NEW_HOLD_REASON"+                //84:add by Peggy 20230325	
				      ",NEW_FORECAST_SSD"+               //85:add by Peggy 20230412		
					  ",CANCEL_MOVE_FLAG"+               //86:add by Peggy 20230414	
					  //",CHANGE_REASON_CODE"+             //87:add by Peggy 20230419
					  ",'QTY/SSD REVISE'"+               //87:modify by Peggy 20230824	
					  ",AUTOCONFIRM_NOTICE_DATE"+        //88:add by Peggy 20230512	 
					  ",PC_CONFIRMED_REASON"+            //89:add by Peggy 20230907 					  
					  " from oraddman.tsc_om_salesorderrevise_req a"+
					  " where temp_id=?"+
					  " and so_header_id=?"+
					  " and so_line_id=?"+
					  " and rownum=1";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"0");
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,ACODE);
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,"A");
				pstmtDt.setString(6,pc_adj_remark);
				pstmtDt.setString(7,rs1.getString("pc_so_qty"));
				pstmtDt.setString(8,rs1.getString("temp_id"));
				pstmtDt.setString(9,rs1.getString("SO_HEADER_ID"));
				pstmtDt.setString(10,rs1.getString("SO_LINE_ID"));
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " update oraddman.tsc_om_salesorderrevise_req a"+
					  " set change_reason_code=case when change_reason_code=? then ? else change_reason_code end"+
					  ",change_reason=case when change_reason_code=? then ? else change_reason end"+
					  " where temp_id=?"+
					  " and so_header_id=?"+
					  " and so_line_id=?"+
					  " and instr(nvl(pc_remarks,' '),?)=0";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"CUSTOMER REQUIRE");
				pstmtDt.setString(2,"QTY/SSD REVISE");
				pstmtDt.setString(3,"CUSTOMER REQUIRE");				
				pstmtDt.setString(4,"Qty and SSD Move");
				pstmtDt.setString(5,rs1.getString("temp_id"));
				pstmtDt.setString(6,rs1.getString("SO_HEADER_ID"));
				pstmtDt.setString(7,rs1.getString("SO_LINE_ID"));
				pstmtDt.setString(8,pc_adj_remark);
				pstmtDt.executeQuery();
				pstmtDt.close();				
			}
			rs1.close();
			statement1.close();	
					
			con.commit();

			%>
			<script language="JavaScript" type="text/JavaScript">
				alert("Action Success!");
				setSubmit("../jsp/TSSalesOrderReviseReply.jsp");
			</script>
			<%
		}		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>Exceution Fail!!Please contact MIS!!<br>"+e.getMessage()+"<br><br><a href='TSSalesOrderReviseReply.jsp'>回工廠回覆訂單變更結果</a></font>");
	}
}
else if (ACODE.equals("REVISE") || ACODE.equals("HOLD") || ACODE.equals("CLOSED"))
{
	try
	{
		int err_cnt =0,rowcnt=0,seq_id =0,rowcnt1=0;
		String err_msg="",mo="",mo_line="",so_line_id="";
		String group_id="";
		String vResend=request.getParameter("chkpull");//重新pullin
		if (vResend==null) vResend="";
		
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			if (ACODE.equals("HOLD"))
			{
				for(int i=0; i< chk.length ;i++)
				{			
					//check mo status 
					err_msg="";
					sql = " select SO_NO,LINE_NO, NVL(group_id,0)  group_id,tsc_order_revise_pkg.CHECK_USER_SALES_GROUP(a.SALES_GROUP,?) err1,tsc_order_revise_pkg.GET_ORDER_SHIP_STATUS(a.SO_HEADER_ID,a.SO_LINE_ID) err2 "+
						  " from oraddman.tsc_om_salesorderrevise_req a"+
						  " WHERE a.TEMP_ID||'.'||a.SEQ_ID=?";
					PreparedStatement statement1 = con.prepareStatement(sql);
					statement1.setString(1,UserName);
					statement1.setString(2,chk[i]);
					ResultSet rs1=statement1.executeQuery();
					while (rs1.next())
					{
						mo=rs1.getString("SO_NO");
						mo_line=rs1.getString("LINE_NO");
						if (rs1.getInt("group_id")>0)
						{
							err_msg+=((err_msg.length()>0?",":"")+" Order has been processed,not allow duplicate to request");
						}
						err_msg+=((err_msg.length()>0?",":"")+(rs1.getString("err1")==null?"":rs1.getString("err1")));
						err_msg+=((err_msg.length()>0?",":"")+(rs1.getString("err2")==null?"":rs1.getString("err2")));
					}
					rs1.close();
					statement1.close();
					
					if (err_msg!=null && err_msg.length() >0)
					{
						out.println("<div style='color:#ff0000;font-size:12px;font-family:Tahoma,Georgia'>MO#:"+mo+"&nbsp;&nbsp;Line#:"+mo_line+"&nbsp;&nbsp;&nbsp;&nbsp;"+err_msg+"</div>");
						err_cnt ++;
					}
				}
				if (err_cnt > 0)
				{
					throw new Exception("");
				}
			}
		
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.tsc_order_revise_group_id_s.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("GROUP ID not Found!!");
			}
			else
			{
				group_id = rs.getString(1);
			}
			rs.close();
			statement.close();		

			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tsc_om_salesorderrevise_req a"+
					  " set group_id=?"+
					  ",temp_group_id=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=SYSDATE"+
					  ",SALES_CONFIRMED_RESULT=CASE ? WHEN 'REVISE' THEN '1' WHEN 'HOLD' THEN '2' ELSE '0' END"+	
					  //",HOLD_CODE=?"+
					  //",HOLD_REASON=UTL_I18N.UNESCAPE_REFERENCE(?)"+	//解決html code字符問題 by Peggy 20201112
					  ",NEW_HOLD_CODE=CASE WHEN ?='HOLD' THEN ? ELSE NEW_HOLD_CODE END "+         //改寫入NEW_HOLD_CODE by Peggy 20230325
					  ",NEW_HOLD_REASON=CASE WHEN ?='HOLD' THEN UTL_I18N.UNESCAPE_REFERENCE(?) ELSE NEW_HOLD_REASON END"+   //改寫入NEW_HOLD_CODE by Peggy 20230325	
					  ",STATUS=case when ?='REVISE' THEN STATUS ELSE 'CLOSED' END "+					  				  
					  " WHERE TEMP_ID=SUBSTR(?,1,INSTR(?,'.')-1)"+
					  " AND SEQ_ID=SUBSTR(?,INSTR(?,'.')+1)"+
					  " and group_id is null";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,group_id);
				pstmtDt.setString(2,group_id);
				pstmtDt.setString(3,UserName);
				pstmtDt.setString(4,ACODE);
				pstmtDt.setString(5,ACODE);
				pstmtDt.setString(6,(request.getParameter("HOLD_CODE")==null?"":request.getParameter("HOLD_CODE")));
				pstmtDt.setString(7,ACODE);
				pstmtDt.setString(8,(request.getParameter("HOLD_REASON")==null?"":request.getParameter("HOLD_REASON")));
				pstmtDt.setString(9,ACODE);
				pstmtDt.setString(10,chk[i]);
				pstmtDt.setString(11,chk[i]);
				pstmtDt.setString(12,chk[i]);
				pstmtDt.setString(13,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
				//out.println(sql);
				
				if (ACODE.equals("HOLD"))
				{
					sql = " update ont.oe_order_lines_all a "+
						  " set ATTRIBUTE20=?"+
						  ",ATTRIBUTE5=?"+
						  ",LAST_UPDATE_DATE=SYSDATE"+
						  ",LAST_UPDATED_BY=(select ERP_USER_ID from oraddman.wsuser where USERNAME=?)"+
						  " where exists (select 1 from  oraddman.tsc_om_salesorderrevise_req b where b.SO_LINE_ID=a.LINE_ID"+
						  " and b.TEMP_ID||'.'||b.SEQ_ID=?)";
					//out.println(sql);
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,request.getParameter("HOLD_CODE"));
					pstmtDt.setString(2,request.getParameter("HOLD_REASON"));
					pstmtDt.setString(3,UserName);
					pstmtDt.setString(4,chk[i]);
					pstmtDt.executeQuery();
					pstmtDt.close();	
				}
				else if (ACODE.equals("CLOSED") || ACODE.equals("REVISE"))  //20170426 add by Peggy accept也可resend
				{
					if (vResend.equals("Y")) //重新pull in
					{
						if (resend_id.equals(""))
						{
							Statement statement1=con.createStatement();
							ResultSet rs1=statement1.executeQuery(" SELECT TSC_ORDER_REVISE_TEMP_ID_S.nextval from dual");
							if (rs1.next())
							{
								resend_id = rs1.getString(1);
							}
							else
							{
								throw new Exception("Get Temp ID fail!!");
							}
							rs1.close();
							statement1.close();								
						}
						
						sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_TEMP "+
							  "select "+
							  " ?"+
							  ",?"+
							  ",a.sales_group"+
							  ",a.so_no"+
							  ",a.line_no"+
							  ",a.so_header_id"+
							  ",a.so_line_id"+
							  ",a.source_customer_id"+
							  ",a.source_ship_to_org_id"+
							  ",a.source_ship_from_org_id"+
							  ",a.source_item_id"+
							  ",a.source_item_desc"+
							  ",a.source_cust_item_id"+
							  ",a.source_cust_item_name"+
							  ",a.source_customer_po"+
							  ",a.source_shipping_method"+
							  ",a.source_so_qty"+
							  ",a.source_ssd"+
							  ",a.source_request_date"+
							  ",a.tsc_prod_group"+
							  ",a.packing_instructions"+
							  ",a.plant_code"+
							  ",a.order_type"+
							  ",a.customer_number"+
							  ",a.customer_name"+
							  ",a.ship_to_org_id"+
							  ",a.ship_to"+
							  ",a.inventory_item_id"+
							  ",a.item_name"+
							  ",a.item_desc"+
							  ",a.cust_item_id"+
							  ",a.cust_item_name"+
							  ",a.customer_po"+
							  ",a.shipping_method"+
							  ",a.so_qty"+
							  ",a.request_date"+
							  ",a.schedule_ship_date"+
							  ",a.remarks"+
							  ",a.change_reason"+
							  ",a.change_comments"+
							  ",?"+
							  ",a.customer_id_ref"+
							  ",a.customer_po_ref"+
							  ",a.customer_po_line_ref"+
							  ",a.version_id_ref"+
							  ",?"+
							  ",sysdate"+
							  ",null"+
							  ",a.ship_to_location_id"+
							  ",a.deliver_to_location_id"+
							  ",a.deliver_to_org_id"+
							  ",a.deliver_to"+
							  ",a.source_deliver_to_org_id"+
							  ",a.bill_to_location_id"+
							  ",a.bill_to_org_id"+
							  ",a.bill_to"+
							  ",a.source_bill_to_org_id"+
							  ",a.source_bill_to_location_id"+
							  ",a.source_ship_to_location_id"+
							  ",a.source_deliver_to_location_id"+
							  ",a.fob_point_code"+
							  ",a.source_fob_point_code"+
							  ",a.fob"+
							  ",a.tax_code"+
							  ",a.source_end_customer_id"+
							  ",a.source_end_customer_no"+
                              ",a.end_customer_id"+
							  ",a.end_customer_no"+
							  ",a.source_selling_price"+
							  ",a.selling_price"+
							  ",a.source_currency_code"+
							  ",a.currency_code"+
							  ",a.TSCH_TEMP_ID"+                       //add by Peggy 20160503 for tsch
							  ",a.TSCH_SEQ_ID"+                        //add by Peggy 20160503 for tsch
							  ",41"+                                   //add by Peggy 20160615
							  ",null"+                                 //add by Peggy 20160615
							  ",null"+                                 //add by Peggy 20160615
							  ",null"+                                 //add by Peggy 20161007
							  ",NVL(a.SEND_FROM_TEMP_ID,a.TEMP_ID)"+   //add by Peggy 20170426,resend from temp_id
							  ",NVL(a.SEND_FROM_SEQ_ID,a.SEQ_ID)"+     //add by Peggy 20170426,resend from seq_id
							  ",a.SOURCE_TAX_CODE"+
         			          ",a.SOURCE_PRICE_LIST_ID"+      
		         	          ",a.LIST_PRICE"+	 
							  ",a.NEW_TSCH_SO_NO"+                     //add by Peggy 20171215
							  ",a.NEW_TSCH_LINE_NO"+                   //add by Peggy 20171215	
							  ",a.NEW_TSCH_END_CUSTOMER"+              //add by Peggy 20171215
							  ",a.SOURCE_TSCH_SO_NO"+                  //add by Peggy 20171215
							  ",a.SOURCE_TSCH_LINE_NO"+	               //add by Peggy 20171215		
							  ",a.SOURCE_TSCH_END_CUSTOMER"+           //add by Peggy 20171215	
           		         	  ",a.END_CUSTOMER_PARTNO"+                //add by Peggy 20190225 
			                  ",a.SOURCE_END_CUSTOMER_PARTNO"+         //add by Peggy 20190225 
							  ",a.SOURCE_YEW_SSD"+                     //add by Peggy 20190320
							  ",a.SCHEDULE_SHIP_DATE_TW"+              //add by Peggy 20191004
							  ",a.TO_TW_DAYS"+                         //add by Peggy 20191004
							  ",a.SYSTEM_REMARKS" +                    //add by Peggy 20201023
							  ",a.SUPPLIER_NUMBER"+                    //add by Peggy 20220428
							  ",a.SOURCE_SUPPLIER_NUMBER"+             //add by Peggy 20220428
							  ",a.NEW_HOLD_CODE"+                      //add by Peggy 20230325
							  ",a.NEW_HOLD_REASON"+                    //add by Peggy 20230325
							  ",a.HOLD_CODE"+                          //add by Peggy 20230325
							  ",a.HOLD_REASON"+                        //add by Peggy 20230325
							  ",a.CANCEL_MOVE_FLAG"+                   //add by Peggy 20230412
							  ",a.NEW_FORECAST_SSD"+                   //add by Peggy 20230412
							  ",a.CHANGE_REASON_CODE"+                 //add by Peggy 20230419
							  ",a.AUTOCONFIRM_NOTICE_DATE"+            //add by Peggy 20230512
							  " from oraddman.tsc_om_salesorderrevise_req a"+						  
							  " WHERE TEMP_ID||'.'||SEQ_ID=?";
						//out.println(sql);
						//out.println(resend_id);
						//out.println(chk[i]);
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,resend_id);
						pstmtDt.setString(2,""+(i+1));
						pstmtDt.setString(3,"Y");
						pstmtDt.setString(4,UserName);
						pstmtDt.setString(5,chk[i]);
						pstmtDt.executeQuery();
						pstmtDt.close();							
					}		
				}
			}
				
		 	if (ACODE.equals("REVISE"))
			{			
				//改單
				CallableStatement cs3 = con.prepareCall("{call tsc_order_revise_pkg.main(?,?)}");			 
				cs3.setString(1,group_id); 
				cs3.setString(2,UserName); 
				cs3.execute();		
				cs3.close();
			}
			else
			{
				//改CRD
				CallableStatement cs3 = con.prepareCall("{call tsc_order_revise_pkg.REVISE_ORDER_CRD(?,?)}");			 
				cs3.setString(1,group_id); 
				cs3.setString(2,UserName); 
				cs3.execute();		
				cs3.close();				
			}

			//tsce 1214
			sql = " select a.ERP_CUSTOMER_ID,b.CUSTOMER_PO,b.PO_LINE_NO,b.VERSION_ID"+
				  " from oraddman.tsce_purchase_order_headers a,oraddman.tsce_purchase_order_lines b,oraddman.tsc_om_salesorderrevise_req c"+
				  " where c.GROUP_ID=?"+
				  " and c.SALES_GROUP=?"+
				  " and c.ERROR_MESSAGE  is null"+
				  " and c.CUSTOMER_ID_REF=a.ERP_CUSTOMER_ID"+
				  " and c.CUSTOMER_PO_REF=b.CUSTOMER_PO"+
				  " and c.CUSTOMER_PO_LINE_REF=b.PO_LINE_NO"+
				  " and c.VERSION_ID_REF=b.VERSION_ID"+
				  " and a.customer_po = b.customer_po"+
				  " and a.version_id = b.version_id"+
				  " and b.data_flag=?";
			PreparedStatement state2 = con.prepareStatement(sql);
			state2.setString(1,group_id);
			state2.setString(2,"TSCE");
			state2.setString(3,"E");
			ResultSet rs2=state2.executeQuery();
			while (rs2.next())
			{	
				//update tsce hub po待確認
				sql = " update oraddman.tsce_purchase_order_lines a"+
					  " set a.DATA_FLAG=?"+
					  ",LAST_UPDATED_BY=?"+        
					  ",LAST_UPDATE_DATE=sysdate"+ 
					  " where CUSTOMER_PO=?"+
					  " AND VERSION_ID=?"+
					  " and a.PO_LINE_NO=?";
				PreparedStatement pstmt3=con.prepareStatement(sql);
				pstmt3.setString(1,"Y");
				pstmt3.setString(2,UserName);
				pstmt3.setString(3,rs2.getString("CUSTOMER_PO"));
				pstmt3.setString(4,rs2.getString("VERSION_ID"));
				pstmt3.setString(5,rs2.getString("PO_LINE_NO"));
				pstmt3.executeUpdate();		
				pstmt3.close();				
			}
			rs2.close();
			state2.close();
			
			//EDI 		
			sql = " select b.request_no,a.customer_po,a.erp_customer_id,b.cust_po_line_no,a.currency_code  "+
				  " from tsc_edi_orders_his_h a"+
				  ",tsc_edi_orders_his_d b"+
				  ",oraddman.tsc_om_salesorderrevise_req c"+
				  " where b.ERP_CUSTOMER_ID =c.CUSTOMER_ID_REF"+
				  " and b.request_no=c.CUSTOMER_PO_REF"+
				  " and b.CUST_PO_LINE_NO=c.CUSTOMER_PO_LINE_REF"+
				  " and a.request_no = b.request_no"+
				  " and a.erp_customer_id = b.erp_customer_id"+
				  " and b.data_flag=?"+
				  " and c.GROUP_ID=?"+
				  " and exists (select 1 from tsc_edi_customer x where x.REGION1=c.sales_group and (x.INACTIVE_DATE is null or trunc(x.INACTIVE_DATE) > trunc(sysdate)))"+
				  " and c.ERROR_MESSAGE  is null  ";
			//out.println(sql);
			//out.println(group_id);
			state2 = con.prepareStatement(sql);
			v_edi_cnt=0;
			state2.setString(1,"N");
			state2.setString(2,group_id);
			rs2=state2.executeQuery();
			while (rs2.next())
			{
				v_edi_cnt++;
				//add by Peggy 20190319
				if (v_edi_cnt==1)
				{
					sql = " SELECT 1  FROM tsc_edi_orders_header a  "+
					      " where case when ERP_CUSTOMER_ID in (?,?) then 1 else ERP_CUSTOMER_ID end =case when to_number(?) in (?,?) then 1 else to_number(?) end"+ //modify by Peggy 20201030
						  " and CUSTOMER_PO=?";
					//out.println(sql);
					PreparedStatement state1 = con.prepareStatement(sql);
					state1.setInt(1,690290);
					state1.setInt(2,702294);
					state1.setString(3,rs2.getString("erp_customer_id"));
					state1.setInt(4,690290);
					state1.setInt(5,702294);
					state1.setString(6,rs2.getString("erp_customer_id"));
					state1.setString(7,rs2.getString("customer_po"));
					ResultSet rs1=state1.executeQuery();
					if (!rs1.next())
					{
						sql=" insert into tsc_edi_orders_header(erp_customer_id, customer_po, version_id, request_date, by_code, dp_code, se_code, currency_code,creation_date, data_flag)"+
							" select a.erp_customer_id,a.customer_po,0,a.request_date,a.by_code,a.dp_code,a.se_code,a.currency_code,sysdate,'Y' "+
							" from tsc_edi_orders_his_h a  "+     
							" where a.request_no=?"+
							" and a.erp_customer_id=?"+
							" and a.customer_po=?";
						//out.println(sql);
						PreparedStatement pstmtDt3=con.prepareStatement(sql);  
						pstmtDt3.setString(1,rs2.getString("request_no")); 
						pstmtDt3.setString(2,rs2.getString("erp_customer_id"));
						pstmtDt3.setString(3,rs2.getString("customer_po")); 
						pstmtDt3.executeQuery();
						pstmtDt3.close();
					}
					else
					{
						sql=" update tsc_edi_orders_header a "+
						    " set erp_customer_id=?  "+     
							",currency_code=?"+
					        " where case when ERP_CUSTOMER_ID in (?,?) then 1 else ERP_CUSTOMER_ID end =case when to_number(?) in (?,?) then 1 else to_number(?) end"+ //modify by Peggy 20201030
						    " and CUSTOMER_PO=?";
						//out.println(sql);
						PreparedStatement pstmtDt3=con.prepareStatement(sql);  
						pstmtDt3.setString(1,rs2.getString("erp_customer_id"));
						pstmtDt3.setString(2,rs2.getString("currency_code"));
						pstmtDt3.setInt(3,690290);
						pstmtDt3.setInt(4,702294);
						pstmtDt3.setString(5,rs2.getString("erp_customer_id"));
					    pstmtDt3.setInt(6,690290);
						pstmtDt3.setInt(7,702294);
						pstmtDt3.setString(8,rs2.getString("erp_customer_id"));
						pstmtDt3.setString(9,rs2.getString("customer_po"));
						pstmtDt3.executeQuery();
						pstmtDt3.close();					
					}
					rs1.close();
					state1.close(); 
				}			
				
				sql = " delete tsc_edi_orders_detail a"+
					  //" where a.erp_customer_id=?"+
					  " where case when a.ERP_CUSTOMER_ID in (?,?) then 1 else a.ERP_CUSTOMER_ID end =case when to_number(?) in (?,?) then 1 else to_number(?) end"+ //modify by Peggy 20201030
					  " and a.customer_po=?"+
					  " and a.version_id=?"+
					  " and a.cust_po_line_no =?";
				//out.println(sql);
				PreparedStatement pstmt1=con.prepareStatement(sql);
				//pstmt1.setString(1,rs2.getString("erp_customer_id"));
				pstmt1.setInt(1,690290);
				pstmt1.setInt(2,702294);
				pstmt1.setString(3,rs2.getString("erp_customer_id"));
				pstmt1.setInt(4,690290);
				pstmt1.setInt(5,702294);
				pstmt1.setString(6,rs2.getString("erp_customer_id"));
				pstmt1.setString(7,rs2.getString("customer_po"));
				pstmt1.setString(8,"0");
				pstmt1.setString(9,rs2.getString("cust_po_line_no"));
				pstmt1.executeUpdate();		
				pstmt1.close();		
					  
				sql = " insert into tsc_edi_orders_detail (erp_customer_id, customer_po, version_id,"+
					  " cust_po_line_no, seq_no, cust_item_name, tsc_item_name,"+
					  " quantity, uom, unit_price, cust_request_date,creation_date,orig_cust_item_name,orig_tsc_item_name)"+ //add orig_cust_item_name by Peggy 20181222
					  " SELECT a.erp_customer_id, b.customer_po,?,a.cust_po_line_no,a.cust_po_line_no||'.'||row_number() over (partition by a.cust_po_line_no order by a.seq_no) seq_no,"+
					  " a.cust_item_name, a.tsc_item_name, a.quantity, a.uom,"+
					  " a.unit_price, a.cust_request_date, sysdate,a.orig_cust_item_name,orig_tsc_item_name"+  //add orig_cust_item_name by Peggy 20181222
					  " FROM tsc_edi_orders_his_d a"+
					  ",tsc_edi_orders_his_h b"+
					  " where a.request_no=b.request_no"+
					  " and a.erp_customer_id=b.erp_customer_id"+
					  " and a.request_no=?"+
					  " and a.erp_customer_id=?"+
					  " and b.customer_po=?"+
					  " and a.cust_po_line_no =?"+
					  " and a.ACTION_CODE<>'2'";
				//out.println(sql);
				PreparedStatement pstmt2=con.prepareStatement(sql);
				pstmt2.setString(1,"0");
				pstmt2.setString(2,rs2.getString("request_no"));
				pstmt2.setString(3,rs2.getString("erp_customer_id"));
				pstmt2.setString(4,rs2.getString("customer_po"));
				pstmt2.setString(5,rs2.getString("cust_po_line_no"));
				pstmt2.executeUpdate();
				pstmt2.close();		
				
				//add by Peggy 20160408 start,只有一個line且cancel時要補一筆資料到tsc_edi_orders_detail
				sql = " select 1 from tsc_edi_orders_detail a"+
					  " where a.erp_customer_id=?"+
					  " and a.customer_po=?"+
					  " and a.version_id=?";
				//out.println(sql);					  
				PreparedStatement state3 = con.prepareStatement(sql);
				state3.setString(1,rs2.getString("erp_customer_id"));
				state3.setString(2,rs2.getString("customer_po"));
				state3.setString(3,"0");
				ResultSet rs3=state3.executeQuery();
				if (!rs3.next())
				{	
					sql = " insert into tsc_edi_orders_detail (erp_customer_id, customer_po, version_id,"+
						  " cust_po_line_no, seq_no, cust_item_name, tsc_item_name,"+
						  " quantity, uom, unit_price, cust_request_date,creation_date,DATA_FLAG,orig_cust_item_name,orig_tsc_item_name)"+ //add orig_cust_item_name by Peggy 20181222
						  " SELECT a.erp_customer_id, b.customer_po,?,a.cust_po_line_no,a.cust_po_line_no||'.'||row_number() over (partition by a.cust_po_line_no order by a.seq_no) seq_no,"+
						  " a.cust_item_name, a.tsc_item_name, a.quantity, a.uom,"+
						  " a.unit_price, a.cust_request_date, sysdate,?,a.orig_cust_item_name,a.orig_tsc_item_name"+  //add orig_cust_item_name by Peggy 20181222
						  " FROM tsc_edi_orders_his_d a,tsc_edi_orders_his_h b"+
						  " where a.request_no=b.request_no"+
						  " and a.erp_customer_id=b.erp_customer_id"+
						  " and a.request_no=?"+
						  " and a.erp_customer_id=?"+
						  " and b.customer_po=?"+
						  " and a.cust_po_line_no =?"+
						  " and a.ACTION_CODE=?"+
						  " and rownum=1";
					//out.println(sql);
					PreparedStatement pstmt5=con.prepareStatement(sql);
					pstmt5.setString(1,"0");
					pstmt5.setString(2,"C");
					pstmt5.setString(3,rs2.getString("request_no"));
					pstmt5.setString(4,rs2.getString("erp_customer_id"));
					pstmt5.setString(5,rs2.getString("customer_po"));
					pstmt5.setString(6,rs2.getString("cust_po_line_no"));
					pstmt5.setString(7,"2");
					pstmt5.executeUpdate();
					pstmt5.close();				
				}
				rs3.close();
				state3.close();
				//add by Peggy 20160408 end
							
				sql = " update tsc_edi_orders_his_d a"+
					  " set a.DATA_FLAG=?"+
					  ",LAST_UPDATED_BY=?"+        
					  ",LAST_UPDATE_DATE=sysdate"+ 
					  " where a.REQUEST_NO=?"+
					  " and case when a.ERP_CUSTOMER_ID in (?,?) then 1 else a.ERP_CUSTOMER_ID end =case when to_number(?) in (?,?) then 1 else to_number(?) end "+
					  " and a.CUST_PO_LINE_NO=?";
				PreparedStatement pstmt3=con.prepareStatement(sql);
				pstmt3.setString(1,"Y");
				pstmt3.setString(2,UserName);  
				pstmt3.setString(3,rs2.getString("request_no"));
				pstmt3.setInt(4,690290);
				pstmt3.setInt(5,702294);
				pstmt3.setString(6,rs2.getString("erp_customer_id"));
				pstmt3.setInt(7,690290);
				pstmt3.setInt(8,702294);
				pstmt3.setString(9,rs2.getString("erp_customer_id"));
				pstmt3.setString(10,rs2.getString("cust_po_line_no"));
				pstmt3.executeUpdate();		
				pstmt3.close();	
			}
			rs2.close();
			state2.close();
			
			con.commit();
			
			if (ACODE.equals("REVISE"))
			{	
				sql = "select a.sales_group"+
					  ",a.so_no"+
					  ",a.line_no"+
					  ",a.so_header_id"+
					  ",a.so_line_id"+
					  ",a.order_type"+
					  ",a.customer_number"+
					  ",a.customer_name"+
					  ",a.ship_to_org_id"+
					  ",a.deliver_to_org_id"+
					  ",a.tsc_prod_group"+
					  ",a.inventory_item_id"+
					  ",a.item_name"+
					  ",a.item_desc"+
					  ",a.cust_item_id"+
					  ",a.cust_item_name"+
					  ",a.SOURCE_CUSTOMER_PO"+
					  ",a.customer_po "+
					  ",a.shipping_method"+
					  ",nvl(a.so_qty,a.source_so_qty) so_qty"+
					  ",to_char(a.request_date,'yyyymmdd') request_date"+
					  //",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
					  //",to_char(a.pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date"+
					  //",to_char(a.schedule_ship_date+nvl(a.to_tw_days,0),'yyyymmdd') schedule_ship_date"+        //add by Peggy 20191004
					  ",to_char(nvl(a.schedule_ship_date_tw, a.schedule_ship_date),'yyyymmdd') schedule_ship_date"+        //add by Peggy 20191004
					  ",to_char(a.pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date"+  //add by Peggy 20191004
					  //",to_char(nvl(d.schedule_ship_date,c.schedule_ship_date),'yyyymmdd') tw_schedule_ship_date"+  //add by Peggy 20190322
					  ",to_char(nvl(a.pc_schedule_ship_date,a.schedule_ship_date) +nvl(a.to_tw_days,0),'yyyymmdd') tw_schedule_ship_date"+ //modify by Peggy 201910014
					  ",a.packing_instructions"+
					  ",a.plant_code"+
					  ",a.temp_id"+
					  ",a.seq_id"+
					  ",a.ship_to"+
					  ",a.deliver_to"+
					  ",a.pc_remarks"+
					  ",a.remarks"+
					  ",a.pc_confirmed_result"+
					  ",a.pc_so_qty"+
					  ",b.ALENGNAME"+
					  ",a.SOURCE_SO_QTY orig_so_qty"+
					  ",a.SOURCE_ITEM_DESC orig_item_desc"+
					  ",to_char(a.SOURCE_SSD,'yyyymmdd') orig_schedule_ship_date"+
					  //",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
					  ",'('||e.customer_number||')'||nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+ //modify by Peggy 20220810
					  ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end as result"+
					  ",decode(a.NEW_SO_NO ,null,'',' New MO#：'||a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '<br>New Line#'||a.NEW_LINE_NO) || decode(a.ERROR_MESSAGE,NULL,'','<br>'||a.ERROR_MESSAGE)  as result_remark"+
					  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
					  ",a.ship_to_location_id"+
					  ",a.deliver_to_location_id"+
					  ",BILL_TO_LOCATION_ID"+
					  ",FOB"+
					  ",SUPPLIER_NUMBER"+  //add by Peggy 20220428
					  " from oraddman.tsc_om_salesorderrevise_req a"+
					  ",oraddman.tsprod_manufactory b"+
					  ",ont.oe_order_lines_all c"+
					  ",ont.oe_order_lines_all d"+
					  ",ar_customers e"+
					  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS f"+  //modify by Peggy 20200911
					  " where a.SOURCE_CUSTOMER_ID=e.customer_id"+
					  " and a.plant_code =b.manufactory_no(+)"+
					  " and a.temp_group_id='"+group_id+"'"+
					  //" AND A.PLANT_CODE=F.PLANT_CODE(+)"+                          //add by Peggy 20190322
					  " AND a.so_line_id=c.line_id(+)"+                             //add by Peggy 20190322
					  " AND a.new_so_line_id=d.line_id(+)"+                         //add by Peggy 20190415
                      //" AND NVL(A.ORDER_TYPE,SUBSTR(A.SO_NO,1,4))=F.ORDER_NUM(+)"+  //add by Peggy 20190322
					  " order by a.so_no,a.line_no,case when nvl(a.schedule_ship_date,a.SOURCE_SSD) =a.SOURCE_SSD then 1 else 2 end";
				//out.println(sql);
				statement=con.createStatement();
				rs=statement.executeQuery(sql);
				while (rs.next())
				{
					if (rowcnt==0)
					{
					%>
						<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
							<tr style="background-color:#E1E3F0;color:#000000">
								<td rowspan="2" width="6%" align="center">Customer</td>
								<td rowspan="2" width="6%" align="center">MO#</td>
								<td rowspan="2" width="3%" align="center">Line#</td>	
								<td rowspan="2" width="7%" align="center">Orig Item Desc </td>	
								<td rowspan="2" width="5%" align="center">Orig Cust PO </td>	
								<td rowspan="2" width="3%" align="center">Orig Qty </td>	
								<td rowspan="2" width="5%" align="center">Orig SSD </td>	
								<td width="56%" style="background-color:#006699;color:#ffffff" colspan="17" align="center">Order Revise Detail </td>
								<td rowspan="2" width="4%" align="center">Execution Resut </td>
								<td rowspan="2" width="5%" align="center">System Remarks</td>
	
							</tr>
							<tr style="background-color:#BDD2DD;">
								<td width="3%">Order Qty</td>
								<td width="3%">PC Qty </td>
								<td width="4%">SSD pull in/out</td>
								<td width="4%">PC SSD </td>
								<td width="4%">TW SSD </td>
								<td width="3%" align="center">Order<br>Type</td>	
								<td width="4%" >Customer</td>
								<td width="3%">Ship To</td>
								<td width="3%">Bill To</td>
								<td width="3%">Deliver To</td>
								<td width="4%">Item Desc</td>
								<td width="3%">Cust P/N</td>
								<td width="4%">Cust PO</td>
								<td width="3%">Shipping<br>Method</td>
								<td width="3%">Request Date</td>
								<td width="3%">FOB</td>
								<td width="3%">Supplier<br>Number</td>
							</tr>
					<%
					}
					%>
					<tr <%=(!(rs.getString("result")).toUpperCase().equals("OK")?"style='background-color:#E7FA5F'":"")%>>
						<%
						if (!rs.getString("so_line_id").equals(so_line_id))
						{
							so_line_id=rs.getString("so_line_id");
						
						%>					
						<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_customer")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("SO_NO")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("LINE_NO")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_item_desc")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>" align="right"><%=rs.getString("orig_so_qty")%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%></td>
						<%
						}
						%>
						<td align="right"><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
						<td align="right"<%=(rs.getString("PC_SO_QTY")!=null && !rs.getString("SO_QTY").equals(rs.getString("PC_SO_QTY"))?" style='color:#0000FF'":"")%>><%=(rs.getString("PC_SO_QTY")==null?"&nbsp;":rs.getString("PC_SO_QTY"))%></td>
						<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%></td>
						<td align="center"<%=(rs.getString("PC_SCHEDULE_SHIP_DATE")!=null && rs.getString("SCHEDULE_SHIP_DATE")!= null && !rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("PC_SCHEDULE_SHIP_DATE"))?" style='color:#0000FF'":"")%>><%=(rs.getString("PC_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("PC_SCHEDULE_SHIP_DATE"))%></td>
						<td align="center"<%=(rs.getString("TW_SCHEDULE_SHIP_DATE")!=null && rs.getString("SCHEDULE_SHIP_DATE")!= null && !rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("PC_SCHEDULE_SHIP_DATE"))?" style='color:#0000FF'":"")%>><%=(rs.getString("TW_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("TW_SCHEDULE_SHIP_DATE"))%></td>
						<td><%=(rs.getString("ORDER_TYPE")==null?"&nbsp;":rs.getString("ORDER_TYPE"))%></td>
						<td><%=(rs.getString("CUSTOMER_NUMBER")==null?"&nbsp;":"("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"))%></td>
						<td><%=(rs.getString("SHIP_TO_location_ID")==null?"&nbsp;":rs.getString("SHIP_TO_location_ID"))%></td>
						<td><%=(rs.getString("bill_TO_location_ID")==null?"&nbsp;":rs.getString("bill_TO_location_ID"))%></td>
						<td><%=(rs.getString("deliver_to_location_ID")==null?"&nbsp;":rs.getString("deliver_to_location_ID"))%></td>
						<td><%=(rs.getString("item_desc")==null?"&nbsp;":rs.getString("item_desc"))%></td>
						<td><%=(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))%></td>
						<td><%=(rs.getString("CUSTOMER_PO")==null?"&nbsp;":rs.getString("CUSTOMER_PO"))%></td>
						<td><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></td>
						<td><%=(rs.getString("REQUEST_DATE")==null?"&nbsp;":rs.getString("REQUEST_DATE"))%></td>
						<td><%=(rs.getString("FOB")==null?"&nbsp;":rs.getString("FOB"))%></td>
						<td><%=(rs.getString("SUPPLIER_NUMBER")==null?"&nbsp;":rs.getString("SUPPLIER_NUMBER"))%></td>
						<td align="center"><%=(rs.getString("RESULT")==null?"&nbsp;":((rs.getString("RESULT")).toUpperCase().equals("OK")?"<font style='color:#0000ff;font-weight:bold'>"+rs.getString("RESULT")+"</font>":"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("result")+"</font>"))%></td>
						<td><%=(rs.getString("RESULT_REMARK")==null?"&nbsp;":rs.getString("RESULT_REMARK"))%></td>
					</tr>
				<%	
					rowcnt++;
				}
				rs.close();
				statement.close();	
				if (rowcnt>0)
				{
				%>
				</table>
				<%
				}
				
				sql = "select a.so_no"+
                      ",a.line_no"+
                      ",a.so_header_id"+
                      ",a.so_line_id"+
                      ",a.tsc_prod_group"+
                      ",a.SOURCE_CUSTOMER_PO"+
                      ",b.ordered_quantity so_qty"+
                      ",to_char(b.request_date,'yyyymmdd') request_date"+
                      ",to_char(b.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
                      ",a.temp_id"+
                      ",a.seq_id"+
                      ",a.remarks"+
                      ",a.SOURCE_SO_QTY orig_so_qty"+
                      ",a.SOURCE_ITEM_DESC orig_item_desc"+
                      ",to_char(a.SOURCE_SSD,'yyyymmdd') orig_schedule_ship_date"+
                      ",to_char(a.SOURCE_REQUEST_DATE,'yyyymmdd') orig_request_date"+
                      //",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
					  ",'('||e.customer_number||')'||nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+ //modify by Peggy 20220810
                      ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end as result"+
                      ",decode(a.NEW_SO_NO ,null,'',' New MO#：'||a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '<br>New Line#'||a.NEW_LINE_NO) || decode(a.ERROR_MESSAGE,NULL,'','<br>'||a.ERROR_MESSAGE)  as result_remark"+
                      ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
                      " from oraddman.tsc_om_salesorderrevise_tsch a"+
                      ",ont.oe_order_lines_all b"+
                      ",ar_customers e"+
                      " where a.SOURCE_CUSTOMER_ID=e.customer_id "+
                      " and a.so_line_id=b.line_id"+
                      " and a.temp_group_id='"+group_id+"'"+
                      " order by a.so_no,a.line_no,case when nvl(a.schedule_ship_date,a.SOURCE_SSD) =a.SOURCE_SSD then 1 else 2 end";
				//out.println(sql);
				statement=con.createStatement();
				rs=statement.executeQuery(sql);
				while (rs.next())
				{
					if (rowcnt1==0)
					{
					%>
						<p>
						<div style="font-family:Tahoma,Georgia;">TSCH Order List</div>
						<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
							<tr style="background-color:#E1E3F0;color:#000000">
								<td width="7%" align="center">Customer</td>
								<td width="6%" align="center">MO#</td>
								<td width="3%" align="center">Line#</td>	
								<td width="7%" align="center">Orig Item Desc </td>	
								<td width="6%" align="center">Orig Cust PO </td>	
								<td width="4%" align="center">Orig Qty </td>	
								<td width="5%" align="center">Orig CRD </td>	
								<td width="5%" align="center">Orig SSD </td>	
								<td width="4%" align="center">New Qty </td>	
								<td width="5%" align="center">New CRD </td>	
								<td width="5%" align="center">New SSD </td>	
								<td width="4%" align="center">Execution Resut </td>
								<td width="5%" align="center">System Remarks</td>
	
							</tr>
					<%
					}
					%>
					<tr <%=(!(rs.getString("result")).toUpperCase().equals("OK")?"style='background-color:#E7FA5F'":"")%>>
						<td><%=rs.getString("orig_customer")%></td>
						<td align="center"><%=rs.getString("SO_NO")%></td>
						<td align="center"><%=rs.getString("LINE_NO")%></td>
						<td><%=rs.getString("orig_item_desc")%></td>
						<td><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
						<td align="right"><%=rs.getString("orig_so_qty")%></td>
						<td align="center"><%=(rs.getString("orig_request_date")==null?"&nbsp;":rs.getString("orig_request_date"))%></td>
						<td align="center"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%></td>
						<td align="right"><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
						<td align="center"><%=(rs.getString("request_date")==null?"&nbsp;":rs.getString("request_date"))%></td>
						<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%></td>
						<td align="center"><%=(rs.getString("RESULT")==null?"&nbsp;":((rs.getString("RESULT")).toUpperCase().equals("OK")?"<font style='color:#0000ff;font-weight:bold'>"+rs.getString("RESULT")+"</font>":"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("result")+"</font>"))%></td>
						<td><%=(rs.getString("RESULT_REMARK")==null?"&nbsp;":rs.getString("RESULT_REMARK"))%></td>
					</tr>
				<%	
					rowcnt1++;
				}
						
				if (rowcnt1>0)
				{
				%>
				</table>
				<%
				}
				if (rowcnt+rowcnt1>0)
				{
				%>
				<p>
				<div align="center">
				<%
					if (vResend.equals("Y"))  //add by Peggy 20170426
					{	
				%>
					<a href="TSSalesOrderReviseRequest.jsp?ID=<%=resend_id%>&ActionType=UPLOAD&RESEND_FLAG=Y" style="font-size:12px">回業務訂單變更申請作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp
				<%
					}
				%>			
				<a href="TSSalesOrderReviseConfirm.jsp" style="font-size:12px">回訂單變更確認作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
				<%
				}
			}
			else if (ACODE.equals("CLOSED") && vResend.equals("Y"))
			{		
				
		%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Action Successful!!");
					setSubmit("../jsp/TSSalesOrderReviseRequest.jsp?ID=<%=resend_id%>&ActionType=UPLOAD&RESEND_FLAG=Y");  //add RESEND參數 by Peggy 20160713 
				</script>
		<%	
			}
			else
			{
				sql = "select a.sales_group"+
					  ",a.so_no"+
					  ",a.line_no"+
					  ",a.so_header_id"+
					  ",a.so_line_id"+
					  ",a.SOURCE_CUSTOMER_PO"+
					  ",a.SOURCE_SO_QTY orig_so_qty"+
					  ",a.SOURCE_ITEM_DESC orig_item_desc"+
					  ",to_char(a.SOURCE_REQUEST_DATE,'yyyymmdd') orig_request_date"+
					  //",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
					  ",'('||e.customer_number||')'||nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+ //modify by Peggy 20220810
					  ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end as result"+
					  ",to_char(max(a.request_date),'yyyymmdd') request_date"+
					  ",a.ERROR_MESSAGE RESULT_REMARK"+
					  " from oraddman.tsc_om_salesorderrevise_req a"+
					  ",ar_customers e"+
					  " where a.temp_group_id='"+group_id+"'"+
					  " and a.SOURCE_CUSTOMER_ID=e.customer_id"+
					  " and (NVL(a.CRD_REVISE_FLAG,'N')='Y'"+
					  " OR  a.ERROR_MESSAGE IS NOT NULL)"+
					  " group by a.sales_group"+
					  ",a.so_no"+
					  ",a.line_no"+
					  ",a.so_header_id"+
					  ",a.so_line_id"+
					  ",a.SOURCE_CUSTOMER_PO"+
					  ",a.SOURCE_SO_QTY"+
					  ",a.SOURCE_ITEM_DESC "+
					  ",to_char(a.SOURCE_REQUEST_DATE,'yyyymmdd') "+
					  ",e.customer_number"+
					  ",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) "+
					  ",a.ERROR_MESSAGE"+
					  ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end"+
					  " order by a.so_no,a.line_no";
				//out.println(sql);
				statement=con.createStatement();
				rs=statement.executeQuery(sql);
				while (rs.next())
				{
					if (rowcnt==0)
					{
					%>
						<table align="center" width="70%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
							<tr style="background-color:#E1E3F0;color:#000000">
								<td width="15%" align="center">Customer</td>
								<td width="7%" align="center">MO#</td>
								<td width="4%" align="center">Line#</td>	
								<td width="9%" align="center">Orig Item Desc </td>	
								<td width="9%" align="center">Orig Cust PO </td>	
								<td width="6%" align="center">Orig Qty </td>	
								<td width="7%" align="center">Orig CRD </td>	
								<td width="7%" align="center">New CRD</td>	
								<td width="8%" align="center">Execution Resut </td>
								<td width="10%" align="center">System Remarks</td>
							</tr>

					<%
					}
					%>
					<tr>
						<td><%=rs.getString("orig_customer")%></td>
						<td align="center"><%=rs.getString("SO_NO")%></td>
						<td align="center"><%=rs.getString("LINE_NO")%></td>
						<td><%=rs.getString("orig_item_desc")%></td>
						<td><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
						<td align="right"><%=rs.getString("orig_so_qty")%></td>
						<td align="center"><%=(rs.getString("orig_request_date")==null?"&nbsp;":rs.getString("orig_request_date"))%></td>
						<td align="center"><%=(rs.getString("request_date")==null?"&nbsp;":rs.getString("request_date"))%></td>
						<td align="center"><%=(rs.getString("RESULT")==null?"&nbsp;":((rs.getString("RESULT")).toUpperCase().equals("OK")?"<font style='color:#0000ff;font-weight:bold'>CRD Update "+rs.getString("RESULT")+"</font>":"<font style='color:#ff0000;font-weight:bold'>CRD Update "+rs.getString("result")+"</font>"))%></td>
						<td><%=(rs.getString("RESULT_REMARK")==null?"&nbsp;":rs.getString("RESULT_REMARK"))%></td>
					</tr>
				<%	
					rowcnt++;
				}
				rs.close();
				statement.close();			
				if (rowcnt>0)
				{
				%>
				</table>
				<p>
				<div align="center"><a href="TSSalesOrderReviseConfirm.jsp" style="font-size:12px">回業務確認訂單變更作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
				<%
				}
				else
				{
		%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Action Successful!!");
					setSubmit("../jsp/TSSalesOrderReviseConfirm.jsp");
				</script>
		<%	
				}
			}			
		}						
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>Exceution Fail!!Please contact MIS!!!!<br>"+e.getMessage()+"<br><br><a href='TSSalesOrderReviseConfirm.jsp'>業務確認訂單變更作業</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

