<%@ page contentType="text/html;charset=utf-8"   language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSPCOrderReviseHisExcel.jsp" METHOD="post" name="MYFORM">
<%
String sql = "";
String PLANTCODE = request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String userProdCenterNo=request.getParameter("userProdCenterNo");
if (userProdCenterNo==null) userProdCenterNo="";
if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0)
{
	PLANTCODE=userProdCenterNo;
}
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String SALES_RESULT = request.getParameter("SALES_RESULT");
if(SALES_RESULT==null || SALES_RESULT.equals("--")) SALES_RESULT="";
String CONFIRMEDBY=request.getParameter("CONFIRMEDBY");
if (CONFIRMEDBY==null || CONFIRMEDBY.equals("--")) CONFIRMEDBY="";
String REQ_TYPE =request.getParameter("REQ_TYPE");
if (REQ_TYPE==null) REQ_TYPE="";
String REQ_TYPE_P =request.getParameter("REQ_TYPE_P");
if (REQ_TYPE_P==null) REQ_TYPE_P="";
String REQ_TYPE_O =request.getParameter("REQ_TYPE_O");
if (REQ_TYPE_O==null) REQ_TYPE_O="";
String REQ_TYPE_E =request.getParameter("REQ_TYPE_E");
if (REQ_TYPE_E==null) REQ_TYPE_E="";
String MO_LIST=request.getParameter("MO_LIST");
if (MO_LIST==null) MO_LIST="";
String CUST_LIST=request.getParameter("CUST_LIST");
if (CUST_LIST==null) CUST_LIST="";
String ITEM_DESC_LIST=request.getParameter("ITEM_DESC_LIST");
if (ITEM_DESC_LIST==null) ITEM_DESC_LIST="";
String CUST_ITEM_LIST=request.getParameter("CUST_ITEM_LIST");
if (CUST_ITEM_LIST==null) CUST_ITEM_LIST="";
String SALES_SDATE=request.getParameter("SALES_SDATE");
if (SALES_SDATE==null) SALES_SDATE="";
String SALES_EDATE=request.getParameter("SALES_EDATE");
if (SALES_EDATE==null) SALES_EDATE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String SALES_COM_DATE=request.getParameter("SALES_COM_DATE");
if (SALES_COM_DATE==null) SALES_COM_DATE="";


SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
SimpleDateFormat formatter1 = new SimpleDateFormat("yyyy/MM/dd HH:mm");
String FileName="",RPTName="",remarks="";
try 
{ 
	int row =0,col=0,reccnt=0,fontsize=8;
	OutputStream os = null;	
	if (ACTTYPE.equals("AUTO"))
	{
		RPTName="Sales Confirm Order Notice on ?01";
		sql = " SELECT PLANT_CODE,LISTAGG(USERMAIL,',') WITHIN GROUP(ORDER BY PLANT_CODE) USERMAIL FROM (SELECT DISTINCT a.PLANT_CODE,a.created_by,b.USERMAIL"+
              " FROM tsc_om_salesorderrevise_pc_v a,oraddman.wsuser b"+
              " WHERE trunc(a.SALES_CONFIRMED_DATE)=to_date(?,'yyyymmdd')"+
			  " AND a.SALES_CONFIRMED_RESULT=?"+
			  " AND a.created_by=b.username) X"+
			  " GROUP BY PLANT_CODE"+
              " ORDER BY  1,2";
	}
	else
	{
		RPTName="PC Order Revise";
		sql = " select 'ALL' plant_code,'System' created_by from dual";
	}
	PreparedStatement statement1 = con.prepareStatement(sql);
	if (ACTTYPE.equals("AUTO"))
	{	
		statement1.setString(1,SALES_COM_DATE);
		statement1.setString(2,"A");
	}
	ResultSet rs1=statement1.executeQuery();
	while (rs1.next())
	{
		
		FileName =(ACTTYPE.equals("AUTO")? RPTName.replace("?01",SALES_COM_DATE):RPTName)+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableSheet ws = null;
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		reccnt=0;col=0;row=0;
		wwb.createSheet("Sheet1", 0);
	
		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_bold_w = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
		//英文內文水平垂直置中-粗體-格線-底色灰  
		WritableCellFormat ACenterBLGY = new WritableCellFormat(font_bold);   
		ACenterBLGY.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLGY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLGY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLGY.setBackground(jxl.write.Colour.ICE_BLUE); 
		ACenterBLGY.setWrap(true);
		
		//英文內文水平垂直置中-粗體-格線-底色藍  
		WritableCellFormat ACenterBL = new WritableCellFormat(font_bold_w);   
		ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBL.setBackground(jxl.write.Colour.INDIGO); 
		//ACenterBL.setBackground(jxl.write.Colour.TEAL2);
		ACenterBL.setWrap(true);	
	
		//英文內文水平垂直置中-粗體-格線-底色藍  
		WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
		ACenterBLB.setWrap(true);
	
		//英文內文水平垂直置中-粗體-格線-底色黃  
		WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
		ACenterBLY.setWrap(true);	
		
		//英文內文水平垂直置中-粗體-格線-底色粉紅
		WritableCellFormat ACenterBLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLP.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLP.setBackground(jxl.write.Colour.ROSE); 
		ACenterBLP.setWrap(true);	
		
		//英文內文水平垂直置中-粗體-格線-底色橘
		WritableCellFormat ACenterBLO = new WritableCellFormat(font_bold_w);   
		ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		//ACenterBLO.setBackground(jxl.write.Colour.ORANGE); 
		ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
		ACenterBLO.setWrap(true);		
		
		//英文內文水平垂直置中-粗體-格線-底色綠
		WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
		ACenterBLG.setWrap(true);	
				
		//英文內文水平垂直置中-正常-格線   
		WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
		ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterL.setWrap(true);
	
	
		//英文內文水平垂直置右-正常-格線   
		WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
		ARightL.setAlignment(jxl.format.Alignment.RIGHT);
		ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightL.setWrap(true);
	
		//英文內文水平垂直置左-正常-格線   
		WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
		ALeftL.setAlignment(jxl.format.Alignment.LEFT);
		ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftL.setWrap(true);
		
		//英文內文水平垂直置中-正常-格線   
		WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
		ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterLB.setWrap(true);
	
	
		//英文內文水平垂直置右-正常-格線   
		WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
		ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
		ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightLB.setWrap(true);
	
		//英文內文水平垂直置左-正常-格線   
		WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
		ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
		ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftLB.setWrap(true);
			
		//日期格式
		WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT.setWrap(true);
	
		//日期格式
		WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd HH:mm")); 
		DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT1.setWrap(true);
	
	
		sql = " select a.request_no"+
			  ", a.request_type"+
			  ", a.seq_id"+
			  ", a.sales_group"+
			  ", a.so_no"+
			  ", a.line_no"+
			  ", a.so_header_id"+
			  ", a.so_line_id"+
			  ", a.source_customer_id"+
			  ", a.source_ship_from_org_id"+
			  ", a.source_item_id"+
			  ", a.source_item_desc"+
			  ", a.source_cust_item_id"+
			  ", a.source_cust_item_name"+
			  ", a.source_customer_po"+
			  ", a.source_shipping_method"+
			  ", a.source_so_qty"+
			  ", to_char(a.source_ssd,'yyyy/mm/dd') source_ssd"+
			  ", to_char(a.source_request_date,'yyyy/mm/dd') source_request_date"+
			  ", a.tsc_prod_group"+
			  ", a.packing_instructions"+
			  ", a.plant_code"+
			  ", a.inventory_item_id"+
			  ", a.item_name"+
			  ", a.item_desc"+
			  ", a.shipping_method"+
			  ", a.so_qty"+
			  ", to_char(a.schedule_ship_date,'yyyy/mm/dd') schedule_ship_date"+
			  ", to_char(a.schedule_ship_date_tw,'yyyy/mm/dd') schedule_ship_date_tw"+
			  ", a.reason_desc"+
			  ", a.remarks"+
			  ", a.change_reason"+
			  ", a.change_comments"+
			  ", a.sales_confirmed_qty"+
			  ", to_char(a.sales_confirmed_ssd,'yyyy/mm/dd') sales_confirmed_ssd"+
			  ", to_char(a.overdue_early_warning_new_ssd,'yyyy/mm/dd') overdue_early_warning_new_ssd"+
			  ", a.sales_confirmed_result"+
			  ", a.sales_confirmed_remarks"+	  
			  ", a.status"+
			  ", a.created_by"+
			  ", to_char(a.creation_date,'yyyy/mm/dd hh24:mi') creation_date"+
			  ", a.sales_confirmed_by"+
			  ", to_char(a.sales_confirmed_date,'yyyy/mm/dd hh24:mi') sales_confirmed_date"+
			  ", a.last_updated_by"+
			  ", to_char(a.last_update_date,'yyyy/mm/dd hh24:mi') last_update_date"+
			  ", a.hold_code"+
			  ", a.hold_reason"+
			  ", a.new_so_no"+
			  ", a.new_line_no"+
			  ", b.MANUFACTORY_NAME"+
			  ", '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
			  ",nvl(a.to_tw_days,0) to_tw_days"+ 
			  ",to_char(d.schedule_ship_date,'yyyy/mm/dd') erp_ssd"+ 
			  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ 
			  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
			  ",row_number() over (partition by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no order by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no,nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
			  ",count(1) over (partition by a.request_type,a.request_no,a.so_line_id) line_cnt"+
			  ",to_char(a.source_ssd_tw,'yyyy/mm/dd') source_ssd_tw"+
			  ",hd.meaning hold_name"+		
			  ",a.ascription_by"+  
			  ",case when a.status='INACTIVE' then 48 else round(((a.sales_confirmed_date-a.creation_date)-tsc_get_holiday_days( a.creation_date, a.sales_confirmed_date,'006'))*24,2) end as confirm_times"+
			  ",tsc_inv_category(a.inventory_item_id,43,1100000103) tsc_volt"+ //add by Peggy 20230504	
			  ",tsc_inv_category(a.inventory_item_id,43,1100000003) tsc_prod_group"+ //add by Peggy 20230505	
			  ",tsc_inv_category(a.inventory_item_id,43,21) tsc_family"+ //add by Peggy 20230505		
		      ",ROUND(NVL(a.so_qty,a.SOURCE_SO_QTY) * d.unit_selling_price * nvl((SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(a.creation_date) AND FROM_CURRENCY=c.transactional_curr_code),1),0) TWD_AMT"+
			  //" from oraddman.tsc_om_salesorderrevise_pc a"+
			  " from tsc_om_salesorderrevise_pc_v a"+ //add by Peggy 20240617
			  ",oraddman.tsprod_manufactory b"+
			  ",ont.oe_order_headers_all c"+
			  ",ont.oe_order_lines_all d"+
			  ",tsc_customer_all_v ar"+
			  ",(select lookup_code,meaning FROM fnd_lookup_values WHERE lookup_type = 'YES_NO_HOLD' AND language = 'US' AND enabled_flag = 'Y') hd"+
			  ",hz_cust_accounts end_cust"+ 
			  " where a.so_header_id=c.header_id(+)"+  
			  " and a.so_line_id=d.line_id(+)"+
			  " and a.plant_code =b.manufactory_no(+)"+
			  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
			  " and d.end_customer_id = end_cust.cust_account_id(+)"+ 
			  " and a.hold_code=hd.lookup_code(+)";
		if (ACTTYPE.equals("AUTO"))
		{	
			sql += " and a.PLANT_CODE='"+rs1.getString("plant_code")+"'"+
			       //" and a.SALES_CONFIRMED_RESULT='A'"+ //esther要求不管acc或rej都要看到,modify by Peggy 20210804
				   " and trunc(a.SALES_CONFIRMED_DATE)=to_date('"+SALES_COM_DATE+"','yyyymmdd')"+
				   " and a.STATUS='CLOSED'";
		}
		else
		{				  
			if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
			{
				sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
			}		  
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
			}
			else if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JENNY_LIAO")<0) || (UserRoles.indexOf("Sale")>=0  && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JENNY_LIAO")<0 ))
			{
				sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_pc_v e"+
					   " where x.TSSALEAREANO=b.SALES_AREA_NO "+
					   " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
					   " and c.master_group_id=d.master_group_id"+
					   " and d.group_name=e.SALES_GROUP"+
					   " and x.USERNAME ='"+UserName+"'"+
					   " and d.group_name=a.sales_group"+
					   " and b.SALES_AREA_NO<>'020')"+
					   " or exists (select 1 from oraddman.tsrecperson x where (x.USERNAME='"+UserName+"' or 'CYTSOU'='"+UserName+"')"+
					   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";	
			}
			if (!CONFIRMEDBY.equals("") && !CONFIRMEDBY.equals("--"))
			{
				sql += " and a.SALES_CONFIRMED_BY ='"+CONFIRMEDBY+"'";
			}
			if (!STATUS.equals("") && !STATUS.equals("--"))
			{
				sql += " and a.STATUS = '"+STATUS+"'";
			}	
			if (!SDATE.equals("") || !EDATE.equals(""))
			{
				sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
			}	
			if (!SALES_SDATE.equals("") || !SALES_EDATE.equals(""))
			{
				sql += " and a.sales_confirmed_date  BETWEEN TO_DATE('"+(SALES_SDATE.equals("")?"20210701":SALES_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (SALES_EDATE.equals("")?dateBean.getYearMonthDay():SALES_EDATE)+"','yyyymmdd')+0.99999";
			}	
			if (!REQUESTNO.equals(""))
			{
				sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
			}
			if (!SALES_RESULT.equals("") && !SALES_RESULT.equals("--"))
			{
				sql += " and a.SALES_CONFIRMED_RESULT ='"+SALES_RESULT+"'";
			}
			//if (!REQ_TYPE.equals("") && !REQ_TYPE.equals("--"))
			//{
			//	sql += " and a.REQUEST_TYPE='"+REQ_TYPE+"'";
			//}
			if (!REQ_TYPE_P.equals("") || !REQ_TYPE_O.equals("") || !REQ_TYPE_E.equals(""))
			{
				sql += " and a.REQUEST_TYPE IN ('"+REQ_TYPE_P+"','"+REQ_TYPE_O+"','"+REQ_TYPE_E+"')";
			}	
			if (!ITEM_DESC_LIST.equals(""))
			{
				String [] sArray = ITEM_DESC_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (a.SOURCE_ITEM_DESC like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or a.SOURCE_ITEM_DESC like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}	
			}
			if (!CUST_ITEM_LIST.equals(""))
			{
				String [] sArray = CUST_ITEM_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (a.SOURCE_CUST_ITEM_NAME like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or a.SOURCE_CUST_ITEM_NAME like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}	
			}
			if (!CUST_LIST.equals(""))
			{
				String [] sArray = CUST_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}		
			if (!MO_LIST.equals(""))
			{
				String [] sArray = MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and a.SO_NO IN ('"+sArray[x].trim().toUpperCase()+"'";
					}
					else
					{
						sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}			
		}
		sql += "  order by a.request_type,a.plant_code,a.request_no,a.sales_group,a.so_no,a.line_no,nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		//String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 	
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet("Sheet1");
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				sst.setVerticalFreeze(1);  //凍結窗格
				for (int g =1 ; g <= 15 ;g++ )
				{
					sst.setHorizontalFreeze(g);
				}	
				
				//Request No
				ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBLGY));
				ws.setColumnView(col,11);	
				col++;					
					
				//Request Type
				ws.addCell(new jxl.write.Label(col, row, "Request Type" , ACenterBLGY));
				ws.setColumnView(col,14);	
				col++;	
	
				//Sales Group
				ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
	
				//Customer
				ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLGY));
				ws.setColumnView(col,25);	
				col++;	
	
				//MO#
				ws.addCell(new jxl.write.Label(col, row, "MO#" ,ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
	
				//Line#
				ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBLGY));
				ws.setColumnView(col,6);	
				col++;	
	
				//Original Item Desc
				ws.addCell(new jxl.write.Label(col, row, "Original Item Desc" ,ACenterBLGY));
				ws.setColumnView(col,18);	
				col++;	
	
				//Cust Item 
				ws.addCell(new jxl.write.Label(col, row, "Cust Item" ,ACenterBLGY));
				ws.setColumnView(col,18);	
				col++;	
	
				//Cust PO 
				ws.addCell(new jxl.write.Label(col, row, "Cust PO" ,ACenterBLGY));
				ws.setColumnView(col,18);	
				col++;	
		
				//TSC Package
				ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
		
				//Original Qty 
				ws.addCell(new jxl.write.Label(col, row, "Original Qty " , ACenterBLGY));
				ws.setColumnView(col,9);	
				col++;	
	
				//CRD
				ws.addCell(new jxl.write.Label(col, row, "Original CRD" ,ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;		
				
				//Original TW SS
				ws.addCell(new jxl.write.Label(col, row, "Original TW SSD" ,ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;		
				
				//Original SSD 
				ws.addCell(new jxl.write.Label(col, row, "Original SSD " ,ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;	
	
				//shipping method
				ws.addCell(new jxl.write.Label(col, row, "Shipping Method " ,ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
	
				//Ascription By
				ws.addCell(new jxl.write.Label(col, row, "Ascription By" , ACenterBL));
				ws.setColumnView(col,9);	
				col++;	
				
				//Order Qty
				ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBL));
				ws.setColumnView(col,9);	
				col++;	
				
				//TW SSD pull in/out
				ws.addCell(new jxl.write.Label(col, row, "TW SSD pull in/out" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;		
				
				//SSD pull in/out
				ws.addCell(new jxl.write.Label(col, row, "SSD pull in/out" , ACenterBL));
				ws.setColumnView(col,10);
				col++;	
				
				//Reason
				ws.addCell(new jxl.write.Label(col, row, "Reason" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
								
				//Remarks
				ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;	
				
				//Sales Confirm Qty
				ws.addCell(new jxl.write.Label(col, row, "Sales Confirm Qty" , ACenterBLO));
				ws.setColumnView(col,8);	
				col++;				
				
				//Sales Confirm SSD
				ws.addCell(new jxl.write.Label(col, row, "Sales Confirm SSD" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;				
	
				//Shipping method
				ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;				
				
				//Hold
				ws.addCell(new jxl.write.Label(col, row, "Hold" , ACenterBLO));
				ws.setColumnView(col,5);	
				col++;	
							
				//Sales Confirm Result 
				ws.addCell(new jxl.write.Label(col, row, "Sales Confirm Result" , ACenterBLO));
				ws.setColumnView(col,8);	
				col++;		
	
				//Sales Confirm remarks 
				ws.addCell(new jxl.write.Label(col, row, "Sales Confirm Remarks" , ACenterBLO));
				ws.setColumnView(col,15);	
				col++;		
	
				//Overdue/Early Warning New SSD
				ws.addCell(new jxl.write.Label(col, row, "Overdue/Early Warning New SSD" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;		
				
				//New MO#
				ws.addCell(new jxl.write.Label(col, row, "New MO#" , ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;																						
				
				//New Line#
				ws.addCell(new jxl.write.Label(col, row, "New Line#" , ACenterBLGY));
				ws.setColumnView(col,8);	
				col++;																						
	
				//Plant Name
				ws.addCell(new jxl.write.Label(col, row, "Plant Name" , ACenterBLGY));
				ws.setColumnView(col,18);	
				col++;					
	
				//Ascription By
				ws.addCell(new jxl.write.Label(col, row, "Ascription By" , ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;	
								
				//Created by 
				ws.addCell(new jxl.write.Label(col, row, "Created by " , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;
				
				//Creation Date 
				ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLGY));
				ws.setColumnView(col,15);	
				col++;		
				
				//Sales Confrimed By
				ws.addCell(new jxl.write.Label(col, row, "Sales Confrimed By" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;		
				
				//Sales Confrimed Date 
				ws.addCell(new jxl.write.Label(col, row, "Sales Confrimed Date" , ACenterBLGY));
				ws.setColumnView(col,15);	
				col++;	
				
				//Last Updated by 
				ws.addCell(new jxl.write.Label(col, row, "Last Updated by" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;
				
				//Last Update Date
				ws.addCell(new jxl.write.Label(col, row, "Last Update Date" , ACenterBLGY));
				ws.setColumnView(col,15);	
				col++;	
				
				//Status
				ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBLGY));
				ws.setColumnView(col,20);	
				col++;
				
				if (!REQ_TYPE_P.equals("") && REQ_TYPE_O.equals("") && REQ_TYPE_E.equals(""))
				{
					//Status
					ws.addCell(new jxl.write.Label(col, row, "Confirm Hours" , ACenterBLGY));
					ws.setColumnView(col,8);	
					col++;				
				}
				//prod group
				ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLGY));
				ws.setColumnView(col,8);	
				col++;					
				
				//tsc family
				ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLGY));
				ws.setColumnView(col,15);	
				col++;	
								
				//VOLT
				ws.addCell(new jxl.write.Label(col, row, "TSC Volt" , ACenterBLGY));
				ws.setColumnView(col,8);	
				col++;
				
				//add by Peggy 20230710
				if (UserName.startsWith("JUDY") || 	UserName.startsWith("PERRY.JUAN") || UserName.startsWith("JUNE") || UserRoles.indexOf("admin")>=0)
				{
					ws.addCell(new jxl.write.Label(col, row, (UserName.startsWith("JUNE")?"台幣金額":"TWD Amount") , ACenterBLGY));
					ws.setColumnView(col,8);	
					col++;							
				}									
				row++;																							
			}			
	
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("request_type"), (rs.getString("request_type").equals("Overdue")?ACenterBLP:(rs.getString("request_type").equals("Early Ship")?ACenterBLG:ACenterBLY))));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("customer"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_ITEM_DESC"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUST_ITEM_NAME"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUSTOMER_PO"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SOURCE_SO_QTY")).doubleValue(), ARightL));
			col++;			
			if (rs.getString("SOURCE_REQUEST_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_REQUEST_DATE")) ,DATE_FORMAT));
			}
			col++;					
			if (rs.getString("SOURCE_SSD_TW")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_SSD_TW")) ,DATE_FORMAT));
			}
			col++;					
			if (rs.getString("SOURCE_SSD")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_SSD")) ,DATE_FORMAT));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("SOURCE_SHIPPING_METHOD")==null?"":rs.getString("SOURCE_SHIPPING_METHOD")),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ASCRIPTION_BY"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
			col++;	
			if (rs.getString("SCHEDULE_SHIP_DATE_TW")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE_TW")) ,DATE_FORMAT));
			}
			col++;					
			if (rs.getString("SCHEDULE_SHIP_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			}
			col++;		
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("reason_desc")==null?"":rs.getString("reason_desc")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")) , ALeftL));
			col++;				
			if (rs.getString("SALES_CONFIRMED_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{		
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SALES_CONFIRMED_QTY")).doubleValue(), ARightL));
			}
			col++;		
			if (rs.getString("SALES_CONFIRMED_SSD")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SALES_CONFIRMED_SSD")) ,DATE_FORMAT));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD")),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("hold_name"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_CONFIRMED_RESULT"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_CONFIRMED_REMARKS"),ALeftL));
			col++;		
			if (rs.getString("OVERDUE_EARLY_WARNING_NEW_SSD")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("OVERDUE_EARLY_WARNING_NEW_SSD")) ,DATE_FORMAT));
			}
			col++;			
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("NEW_SO_NO")==null?"":rs.getString("NEW_SO_NO")),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("NEW_LINE_NO")==null?"":rs.getString("NEW_LINE_NO")),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME"), ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ascription_by"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY"),ALeftL));
			col++;
			if (rs.getString("CREATION_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter1.parse(rs.getString("CREATION_DATE")) ,DATE_FORMAT1));
			}
			col++;														
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_CONFIRMED_BY"),ALeftL));
			col++;
			if (rs.getString("SALES_CONFIRMED_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter1.parse(rs.getString("SALES_CONFIRMED_DATE")) ,DATE_FORMAT1));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LAST_UPDATED_BY"),ALeftL));
			col++;
			if (rs.getString("LAST_UPDATE_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter1.parse(rs.getString("LAST_UPDATE_DATE")) ,DATE_FORMAT1));
			}
			col++;							
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("status")==null?"":rs.getString("status")),ALeftL));
			col++;
			if (!REQ_TYPE_P.equals("") && REQ_TYPE_O.equals("") && REQ_TYPE_E.equals(""))
			{
				if (rs.getString("confirm_times")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("confirm_times")).doubleValue(), ARightL));
				}
				col++;				
			}	

			ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_prod_group"),ALeftL));	
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family"),ALeftL));	
			col++;			
			ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_volt"),ALeftL));	
			col++;	
			//add by Peggy 20230710
			if (UserName.startsWith("JUDY") || 	UserName.startsWith("PERRY.JUAN") || UserName.startsWith("JUNE") || UserRoles.indexOf("admin")>0)
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("twd_amt")).doubleValue(), ARightL));
				col++;							
			}															
			row++;				
			
			reccnt ++;
		}
		rs.close();
		statement.close();
		wwb.write(); 
		wwb.close();
		
		if (ACTTYPE.equals("AUTO"))
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			remarks="";
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else 
			{
		  		String[] temArryStr = rs1.getString("USERMAIL").split(",");
	            for (int i = 0; i < temArryStr.length; i++)
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(temArryStr[i]));
					if (temArryStr[i].toLowerCase().indexOf("may@")>=0) //add by Peggy 20211014
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("jamie.liu@ts.com.tw"));
					}
					else if (temArryStr[i].toLowerCase().indexOf("ice@")>=0) //add by Peggy 20230112
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("feng@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("amanda@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("geng_limei@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("guoying@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("YQ_Li@MAIL.TSYEW.COM.CN"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("maomao@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("yanyan@mail.tsyew.com.cn"));
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lixia.wang@mail.tsyew.com.cn"));  //add 立霞 by Peggy 20230703
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("judy.cho@ts.com.tw"));  //add Judy by Peggy 20240131
					}					
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs1.getString("USERMAIL")));
				}
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));

			message.setHeader("Subject", MimeUtility.encodeText(SALES_COM_DATE+"業務已確認工廠Early Ship/Overdue/Early warning通知"+remarks, "UTF-8", null));	
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);
		}
	}

	os.close();  
	out.close(); 
	
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()+sql); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
try
{
	if (ACTTYPE.equals(""))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
