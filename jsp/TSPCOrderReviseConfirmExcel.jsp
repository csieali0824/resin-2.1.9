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
<FORM ACTION="../jsp/TSPCOrderReviseConfirmExcel" METHOD="post" name="MYFORM">
<%
String sql = "",so_line_id="",show_flag="",id="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String userProdCenterNo=request.getParameter("userProdCenterNo");
if (userProdCenterNo==null) userProdCenterNo="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null) salesGroup="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String ACTIONTYPE="AWAITING_CONFIRM";
String CUSTOMER=request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String REQUEST_DATE = request.getParameter("REQUEST_DATE"); 
if (REQUEST_DATE==null || REQUEST_DATE.equals("--")) REQUEST_DATE="";
String so_qty="",so_ssd="",sales_remarks="",sales_result="",remarks="";
String REQ_TYPE =request.getParameter("REQ_TYPE");
if (REQ_TYPE==null) REQ_TYPE="";
String ITEM_DESC=request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String CUST_ITEM=request.getParameter("CUST_ITEM");
if (CUST_ITEM==null) CUST_ITEM="";
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
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String NEW_REQ = request.getParameter("NEW_REQ");
if (NEW_REQ==null) NEW_REQ="";
String SALES_REGION="",REQ_NAME="";
int rowcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
SimpleDateFormat formatter1 = new SimpleDateFormat("yyyyMMdd HH:mm");
String FileName="",RPTName="",V_CUST_LIST="";
try 
{ 
	int row =0,col=0,reccnt=0,fontsize=8;
	String strContent="",strUrl= request.getRequestURL().toString(),strProgram="";
	strUrl=strUrl.substring(0,strUrl.lastIndexOf("/"));
	strUrl=strUrl.replace("10.0.3.109:8081","10.0.1.144:8080");
	
	OutputStream os = null;	
	if (ACTTYPE.equals("AUTO"))
	{
		RPTName="Order Revise From PC(?01) Notice";
		sql = " SELECT DISTINCT a.request_no, DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group) sales_region,created_by"+
              " FROM oraddman.tsc_om_salesorderrevise_pc a"+
              " WHERE REQUEST_NO=?"+
			  " AND notice_date is null"+
              " ORDER BY  1,2";
	}
	else if (ACTTYPE.equals("REMINDER"))
	{
		RPTName="Order Revise From PC(?01) Notice";
		sql = " SELECT DISTINCT a.request_no, DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group) sales_region,created_by"+
              " FROM oraddman.tsc_om_salesorderrevise_pc a"+
              " WHERE REQUEST_TYPE=?"+
			  " AND notice_date is not null"+
			  " AND STATUS=?"+
              " ORDER BY  1,2";	
	}
	else if (ACTTYPE.equals("ALLOVERDUE"))
	{
		RPTName="Factory Overdue Early-warning Weekly Report";
		sql = " SELECT DISTINCT 'ALL' request_no, DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC-TSCH','TSCH','TSCC-TSCH',a.sales_group) sales_region,'System' created_by"+
              " FROM oraddman.tsc_om_salesorderrevise_pc a"+
              " where exists (select 1 from (select y.* from (select x.request_no,x.plant_code,x.request_type,row_number() over (partition by x.plant_code,x.request_type order by x.request_no desc) seq_no "+
              "                                              from (select a.request_no,a.plant_code,a.request_type"+
              "                                                    from oraddman.tsc_om_salesorderrevise_pc a"+
              "                                                    where a.request_type in (?,?)"+
			  "                                                    and a.creation_date>=trunc(sysdate)-?"+ //add by Peggy 20230529 
              "                                                    and a.status<>?"+
              "                                                    group by a.request_no,a.plant_code,a.request_type) x"+
			  "                                               ) y where y.seq_no=?"+
			  "                              ) z"+
			  "               where z.request_no=a.request_no) "+
			  //" and a.sales_group in ('TSCE','TSCK')"+
			  " order by 1";
	}	
	else
	{
		RPTName="Sales Order Revise Confirm";
		sql = " select 'ALL' request_no,'ALL' sales_region,'System' created_by from dual";
	}
	PreparedStatement statement1 = con.prepareStatement(sql);
	if (ACTTYPE.equals("AUTO"))
	{	
		statement1.setString(1,NEW_REQ);
	}
	else if (ACTTYPE.equals("REMINDER"))
	{
		statement1.setString(1,"Early Ship");
		statement1.setString(2,"AWAITING_CONFIRM");
	}	
	else if (ACTTYPE.equals("ALLOVERDUE"))
	{
		statement1.setString(1,"Early Warning");
		statement1.setString(2,"Overdue");
		statement1.setInt(3,7);
		statement1.setString(4,"INACTIVE");
		statement1.setInt(5,1);
	}	
	ResultSet rs1=statement1.executeQuery();
	while (rs1.next())
	{
		SALES_REGION=rs1.getString("sales_region");
		REQ_NAME=rs1.getString("created_by");
		if (ACTTYPE.equals("REMINDER"))	NEW_REQ=rs1.getString("request_no");
		strProgram =strUrl+"/TSPCOrderReviseConfirm.jsp?REQUEST_NO="+NEW_REQ ;
		if (ACTTYPE.equals("AUTO") || ACTTYPE.equals("REMINDER"))
		{
			FileName = SALES_REGION+" "+RPTName.replace("?01",REQ_NAME)+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		}
		else if (ACTTYPE.equals("ALLOVERDUE"))
		{
			FileName = "("+SALES_REGION+")"+RPTName+"-"+dateBean.getYearMonthDay()+".xls";
		}
		else
		{
			FileName = RPTName+"-"+UserName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		}
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableSheet ws = null;
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		reccnt=0;col=0;row=0;
		wwb.createSheet("Sheet1", 0);

		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
		//公司名稱英文平行置中     
		WritableCellFormat wEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 14 ,WritableFont.BOLD,false));   
		wEName.setAlignment(jxl.format.Alignment.LEFT);
	
		//英文內文水平垂直置中-粗體-格線-底色灰  
		WritableCellFormat ACenterBLGY = new WritableCellFormat(font_bold);   
		ACenterBLGY.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLGY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLGY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLGY.setBackground(jxl.write.Colour.GRAY_25); 
		ACenterBLGY.setWrap(true);
		
		//英文內文水平垂直置中-粗體-格線-底色藍  
		WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
		ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBL.setBackground(jxl.write.Colour.ICE_BLUE); 
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
		WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLO.setBackground(jxl.write.Colour.ORANGE); 
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
		WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyyMMdd HH:mm")); 
		DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT1.setWrap(true);
	
	
		sql = " select a.request_no"+
			  ", a.request_type"+
			  ", '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
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
			  ", to_char(a.source_ssd,'yyyymmdd') source_ssd"+
			  ", to_char(a.source_request_date,'yyyymmdd') source_request_date"+
			  ", a.tsc_prod_group"+
			  ", a.packing_instructions"+
			  ", a.plant_code"+
			  ", a.inventory_item_id"+
			  ", a.item_name"+
			  ", a.item_desc"+
			  ", a.shipping_method"+
			  ", a.so_qty"+
			  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
			  ", to_char(a.schedule_ship_date_tw,'yyyymmdd')schedule_ship_date_tw"+
			  ", a.reason_desc"+
			  ", a.remarks"+
			  ", a.change_reason"+
			  ", a.change_comments"+
			  ", a.sales_confirmed_result"+
			  ", a.status"+
			  ", a.created_by"+
			  ", to_char(a.creation_date,'yyyymmdd hh24:mi') creation_date"+
			  ", a.sales_confirmed_by"+
			  ", to_char(a.sales_confirmed_date,'yyyymmdd hh24:mi') sales_confirmed_date"+
			  ", a.last_updated_by"+
			  ", to_char(a.last_update_date,'yyyymmdd hh24:mi') last_update_date"+
			  ", a.hold_code"+
			  ", a.hold_reason"+
			  ", a.new_so_no"+
			  ", a.new_line_no"+
			  ", b.MANUFACTORY_NAME"+
			  //", '('||ar.account_number||')'||nvl(ar.customer_sname,ar.customer_name) customer"+
			  ",nvl(a.to_tw_days,0) to_tw_days"+ 
			  ",to_char(d.schedule_ship_date,'yyyymmdd') erp_ssd"+ 
			  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ 
			  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
			  ",row_number() over (partition by a.request_type,a.request_no,a.so_line_id order by a.seq_id,nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
			  ",count(1) over (partition by a.request_type,a.request_no,a.so_line_id) line_cnt"+
			  ",to_char(a.source_ssd_tw,'yyyymmdd') source_ssd_tw"+
			  ",to_number(to_char(a.source_ssd_tw,'yyyymmdd'))-to_number(to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd')) change_ssd"+
			  ",c.version_number"+
			  ",to_char(c.ordered_date,'yyyymmdd') ordered_date"+
			  ",(select to_char(max(creation_date),'yyyymmdd') from oraddman.tsc_om_salesorderrevise_pc x where x.request_no =a.request_no) max_creation_date"+
			  ",d.attribute20"+ //hold by Peggy 20221229
		      ",to_char(case when a.sales_group='TSCE' then tsce_get_eta_date(lc.meaning,NVL(d.FOB_POINT_CODE,c.FOB_POINT_CODE),substr(c.order_number,1,4),d.packing_instructions,trunc(d.schedule_ship_date),c.sold_to_org_id,null,d.deliver_to_org_id) else null end,'yyyymmdd') eta_date"+
			  " from oraddman.tsc_om_salesorderrevise_pc a"+
			  ",oraddman.tsprod_manufactory b"+
			  ",ont.oe_order_headers_all c"+
			  ",ont.oe_order_lines_all d"+
			  ",tsc_customer_all_v ar"+
			  ",hz_cust_accounts end_cust"+ 
		      ",(SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc"+			  
			  " where a.so_header_id=c.header_id(+)"+  
			  " and a.so_line_id=d.line_id(+)"+
			  " and a.plant_code =b.manufactory_no(+)"+
			  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
			  " and d.end_customer_id = end_cust.cust_account_id(+)"+
			  " and d.SHIPPING_METHOD_CODE = lc.lookup_code (+)";
		if (ACTTYPE.equals("AUTO"))
		{	
			sql += " and a.status=?"+
                   " and DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group)=?"+
			       " and a.REQUEST_NO=?";
		}
		else if (ACTTYPE.equals("REMINDER"))
		{			       
			sql += " and a.status=?"+
			       " and DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group)=?"+
			       " and a.REQUEST_NO=?";
		}
		else if (ACTTYPE.equals("ALLOVERDUE"))
		{	
			sql += " and a.status<>?"+
			       " and DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC-TSCH','TSCH','TSCC-TSCH',a.sales_group)=?"+
			       " and exists (select 1 from (select y.* from (select x.request_no,x.plant_code,x.request_type,row_number() over (partition by x.plant_code,x.request_type order by x.request_no desc) seq_no "+
                   "                                             from (select a.request_no,a.plant_code,a.request_type"+
                   "                                                    from oraddman.tsc_om_salesorderrevise_pc a"+
                   "                                                    where a.request_type in (?,?)"+
			       "                                                    and a.creation_date>=trunc(sysdate)-?"+ //add by Peggy 20230529                    
				   "                                                    and a.status<>?"+
                   "                                                    group by a.request_no,a.plant_code,a.request_type) x"+
			       "                                               ) y where y.seq_no=?"+
			       "                              ) z"+
			       "               where z.request_no=a.request_no) ";
		}	
		else
		{	
			sql += " and a.status=?"+
		           " AND NVL(a.ASCRIPTION_BY,'XX') NOT IN (?)";  //因為改單不異動,所以sales hold不顯示 add by Peggy 20230111			  
			if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
			{
				sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
			}
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
				if (salesGroup.equals("TSCH-HK"))
				{
					sql += " and (d.sold_to_org_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))) "+
                           " or end_cust.cust_account_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))))";
				}					
			}
			else if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0  && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0) || (UserRoles.indexOf("Sale")>=0  && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 ))
			{
				sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
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
			if (!CUSTOMER.equals("--") && !CUSTOMER.equals(""))
			{
				sql += " and AR.ACCOUNT_NUMBER='"+CUSTOMER+"'";
			}	
			if (!REQUESTNO.equals("") && !REQUESTNO.equals("--"))
			{
				sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
			}
			if (!REQUEST_DATE.equals("") && !REQUEST_DATE.equals("--"))
			{
				sql += " and a.CREATION_DATE BETWEEN TO_DATE('"+ REQUEST_DATE+"','yyyymmdd') and TO_DATE('"+ REQUEST_DATE+"','yyyymmdd')+0.99999";
			}	
			//if (!REQ_TYPE.equals("") && !REQ_TYPE.equals("--"))
			//{
			//	sql += " and a.REQUEST_TYPE='"+REQ_TYPE+"'";
			//}				
			if (!REQ_TYPE_P.equals("") || !REQ_TYPE_O.equals("") || !REQ_TYPE_E.equals(""))
			{
				sql += " and a.REQUEST_TYPE IN ('"+REQ_TYPE_P+"','"+REQ_TYPE_O+"','"+REQ_TYPE_E+"')";
			}
			if (!ITEM_DESC.equals(""))
			{
				//swhere += " and a.SOURCE_ITEM_DESC='"+ITEM_DESC+"'";
				String [] sArray = ITEM_DESC.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (a.SOURCE_ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or a.SOURCE_ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}				
			}
			if (!CUST_ITEM.equals("") && !CUST_ITEM.equals("--"))
			{
				sql += " and a.SOURCE_CUST_ITEM_NAME='"+CUST_ITEM+"'";
			}
			if (!CUST_LIST.equals("") && !CUST_LIST.equals("--"))
			{
				/*String [] sArray = CUST_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						swhere += " and (UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then upper(substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1)) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						swhere += " or UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then upper(substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1)) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) swhere += ")";
				}*/
				sql += " and '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			             " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end = '"+ CUST_LIST+"'";
			}		
			if (!MO_LIST.equals(""))
			{
				String [] sArray = MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and a.SO_NO in ('"+sArray[x].trim().toUpperCase()+"'";
					}
					else
					{
						sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}	
		}
		if (ACTTYPE.equals("ALLOVERDUE"))
		{	
			sql += " order by 2,1,5,3,6,to_number(7),13,9,4";	
		}
		else
		{
			sql += " order by 2,1,3,5,6,to_number(7),13,9,4";
		}
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		if (ACTTYPE.equals("AUTO"))
		{	
			statement.setString(1,ACTIONTYPE);			
			statement.setString(2,SALES_REGION);
			statement.setString(3,NEW_REQ);			
		}
		else if (ACTTYPE.equals("REMINDER"))
		{			       
			statement.setString(1,ACTIONTYPE);			
			statement.setString(2,SALES_REGION);
			statement.setString(3,NEW_REQ);			
		}
		else if (ACTTYPE.equals("ALLOVERDUE"))
		{	
			statement.setString(1,"INACTIVE");			
			statement.setString(2,SALES_REGION);
			statement.setString(3,"Early Warning");			
			statement.setString(4,"Overdue");	
			statement.setInt(5,7);
			statement.setString(6,"INACTIVE");
			statement.setInt(7,1);
		}
		else
		{
			statement.setString(1,ACTIONTYPE);	
			statement.setString(2,"Sales");			
		}		
		ResultSet rs=statement.executeQuery();
		//String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 	
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet("Sheet1");
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				if (ACTTYPE.equals("ALLOVERDUE"))
				{
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row, "UPDATE:"+dateBean.getYearMonthDay() , wEName));
					ws.setColumnView(col,60);	
					row++;
									
					sst.setVerticalFreeze(2);  //凍結窗格
					for (int g =1 ; g <= 6 ;g++ )
					{
						sst.setHorizontalFreeze(g);
					}	
					//Request No
					ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBLGY));
					ws.setColumnView(col,11);	
					col++;					
	
					//Plant Name
					ws.addCell(new jxl.write.Label(col, row, "Plant Name" , ACenterBLGY));
					ws.setColumnView(col,15);	
					col++;					
		
					//MO#
					ws.addCell(new jxl.write.Label(col, row, "M/O No" ,ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
							
					//Revision No.
					ws.addCell(new jxl.write.Label(col, row, "Revision No." ,ACenterBLGY));
					ws.setColumnView(col,8);	
					col++;
		
					//Line#
					ws.addCell(new jxl.write.Label(col, row, "LINE NO" , ACenterBLGY));
					ws.setColumnView(col,8);	
					col++;
							
					//Part Number
					ws.addCell(new jxl.write.Label(col, row, "Part Number" , ACenterBLGY));
					ws.setColumnView(col,18);	
					col++;	
																								
					//Sales Group
					ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
		
					//Customer
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLGY));
					ws.setColumnView(col,30);	
					col++;	

					//Order Entry Date
					ws.addCell(new jxl.write.Label(col, row, "Order Entry Date" ,ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
		
					//CRD
					ws.addCell(new jxl.write.Label(col, row, "CRD" ,ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
					
					//Schedule Ship Date
					ws.addCell(new jxl.write.Label(col, row, "Schedule Ship Date" ,ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;			
		
					//Quantity
					ws.addCell(new jxl.write.Label(col, row, "Quantity" , ACenterBLGY));
					ws.setColumnView(col,9);	
					col++;	
		
					//Ship Method
					ws.addCell(new jxl.write.Label(col, row, "Ship Method" ,ACenterBLGY));
					ws.setColumnView(col,15);	
					col++;	
					
					//Customer PN
					ws.addCell(new jxl.write.Label(col, row, "Customer PN" ,ACenterBLGY));
					ws.setColumnView(col,15);	
					col++;	
		
					//P/O
					ws.addCell(new jxl.write.Label(col, row, "P/O" ,ACenterBLGY));
					ws.setColumnView(col,15);	
					col++;	
					
					//Status 
					ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBLO));
					ws.setColumnView(col,10);	
					col++;				
					
					//Balance date(factory)
					ws.addCell(new jxl.write.Label(col, row, "Balance date(factory)" , ACenterBLO));
					ws.setColumnView(col,12);	
					col++;				
		
					//Balance Q'TY(factory)(Pcs)
					ws.addCell(new jxl.write.Label(col, row, "Balance Q'TY(factory)(Pcs)" , ACenterBLO));
					ws.setColumnView(col,12);	
					col++;				
					
					//Details Description
					ws.addCell(new jxl.write.Label(col, row, "Details Description" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;	
										
					//Main Category Analysis
					ws.addCell(new jxl.write.Label(col, row, "Main Category Analysis" , ACenterBLO));
					ws.setColumnView(col,12);	
					col++;	
					row++;	
				}
				else
				{
					sst.setVerticalFreeze(1);  //凍結窗格
					for (int g =1 ; g <= 14 ;g++ )
					{
						sst.setHorizontalFreeze(g);
					}	
					//Request No
					ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBLGY));
					ws.setColumnView(col,11);	
					col++;					
					
					//SEQ NO
					ws.addCell(new jxl.write.Label(col, row, "Seq No" , ACenterBLGY));
					ws.setColumnView(col,5);	
					col++;
								
					//Plant Name
					ws.addCell(new jxl.write.Label(col, row, "Plant Name" , ACenterBLGY));
					ws.setColumnView(col,15);	
					col++;					
				
					//Sales Group
					ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
		
					//Customer
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLGY));
					ws.setColumnView(col,30);	
					col++;	
		
					//MO#
					ws.addCell(new jxl.write.Label(col, row, "MO#" ,ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;	
		
					//Line#
					ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBLGY));
					ws.setColumnView(col,8);	
					col++;	
		
					//Original Item Desc
					ws.addCell(new jxl.write.Label(col, row, "Original Item Desc" ,ACenterBLGY));
					ws.setColumnView(col,18);	
					col++;	
		
					//Customer Item
					ws.addCell(new jxl.write.Label(col, row, "Original Cust Item" ,ACenterBLGY));
					ws.setColumnView(col,14);	
					col++;	
					
					//Customer PO
					ws.addCell(new jxl.write.Label(col, row, "Original Cust PO" ,ACenterBLGY));
					ws.setColumnView(col,16);	
					col++;			
		
					//Original Qty 
					ws.addCell(new jxl.write.Label(col, row, "Original Qty " , ACenterBLGY));
					ws.setColumnView(col,9);	
					col++;	
					
					if (rs.getString("SALES_GROUP").equals("TSCE"))  //add by Peggy 20240521
					{
						//Original CRD 
						ws.addCell(new jxl.write.Label(col, row, "Original ETA " ,ACenterBLGY));
						ws.setColumnView(col,10);	
						col++;	
					}
							
					//Original CRD 
					ws.addCell(new jxl.write.Label(col, row, "Original CRD " ,ACenterBLGY));
					ws.setColumnView(col,10);	
					col++;	
					
					//Original SSD 
					ws.addCell(new jxl.write.Label(col, row, "Original SSD " ,ACenterBLGY));
					ws.setColumnView(col,10);	
					col++;	
		
					//Shipping method
					ws.addCell(new jxl.write.Label(col, row, "Shipping Method " ,ACenterBLGY));
					ws.setColumnView(col,10);	
					col++;	
					
					//Sales Confirm Qty
					ws.addCell(new jxl.write.Label(col, row, "Sales Confirm Qty" , ACenterBLO));
					ws.setColumnView(col,8);	
					col++;				
					
					//Sales Confirm SSD
					ws.addCell(new jxl.write.Label(col, row, "Sales Confirm SSD" , ACenterBLO));
					ws.setColumnView(col,8);	
					col++;				
		
					//New Shipping method
					ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLO));
					ws.setColumnView(col,12);	
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
					
					//Request Type
					ws.addCell(new jxl.write.Label(col, row, "Request Type" , ACenterBLB));
					ws.setColumnView(col,14);	
					col++;	
		
					//Order Qty
					ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBLB));
					ws.setColumnView(col,9);	
					col++;	
					
					//TW SSD pull in/out
					ws.addCell(new jxl.write.Label(col, row, "TW SSD pull in/out" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;		
					
					//SSD pull in/out
					ws.addCell(new jxl.write.Label(col, row, "SSD pull in/out" ,ACenterBLB));
					ws.setColumnView(col,10);
					col++;	
					
					//Remarks
					ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
					ws.setColumnView(col,30);	
					col++;
					
					//ERP HOLD STATUS
					ws.addCell(new jxl.write.Label(col, row, "ERP Hold Status" , ACenterBLGY));
					ws.setColumnView(col,12);	
					col++;							
					row++;	
				}																						
			}			
	
			col=0;
			if (ACTTYPE.equals("ALLOVERDUE"))
			{
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME"), ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("version_number"),ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_ITEM_DESC"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("customer"),ALeftL));
				col++;
				if (rs.getString("ordered_date")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ordered_date")) ,DATE_FORMAT));
				}
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
				if (rs.getString("SO_QTY")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{		
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
				}
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("SOURCE_SHIPPING_METHOD")==null?"":rs.getString("SOURCE_SHIPPING_METHOD")),ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUST_ITEM_NAME"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUSTOMER_PO"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_type"), (rs.getString("request_type").equals("Overdue")?ACenterBLP:(rs.getString("request_type").equals("Early Ship")?ACenterBLG:ACenterBLY))));
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
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("reason_desc")==null?"":rs.getString("reason_desc")),ALeftL));
				col++;	
				row++;
				reccnt++;																																					
			}
			else
			{			
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("seq_id"), ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME"), ALeftL));
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
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SOURCE_SO_QTY")).doubleValue(), ARightL));
				col++;	
				if (rs.getString("SALES_GROUP").equals("TSCE")) //add by Peggy 20240521
				{
					if (rs.getString("ETA_DATE")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ETA_DATE")) ,DATE_FORMAT));
					}
					col++;				
				}						
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
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("SOURCE_SHIPPING_METHOD")==null?"":rs.getString("SOURCE_SHIPPING_METHOD")),ALeftL));
				col++;	
				if (rs.getString("SO_QTY")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{		
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
				}
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
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
				col++;
				ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
				col++;
				ws.addCell(new jxl.write.Label(col, row,"",ALeftL));
				col++;		
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_type"), (rs.getString("request_type").equals("Overdue")?ACenterBLP:(rs.getString("request_type").equals("Early Ship")?ACenterBLG:ACenterBLY))));
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
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("reason_desc")==null?"":rs.getString("reason_desc"))+(rs.getString("reason_desc")!=null && rs.getString("remarks")!=null?",":"")+(rs.getString("remarks")==null?"":rs.getString("remarks")),ALeftL));
				col++;	
				if (rs.getString("attribute20")==null) //add by Peggy 20221229
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row, rs.getString("attribute20"),ALeftL));
				}
				col++;					
				row++;
				reccnt++;
			}
		}
		rs.close();
		statement.close();
		wwb.write(); 
		wwb.close();
	
		if (ACTTYPE.equals("AUTO") || ACTTYPE.equals("REMINDER") || ACTTYPE.equals("ALLOVERDUE"))
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			}
			else 
			{
				if (SALES_REGION.equals("TSCE"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.huang@ts.com.tw"));
					if (ACTTYPE.equals("ALLOVERDUE") && remarks.equals(""))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ralf.welter@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jean-jacques.meli@tsceu.com"));
						////message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.huang@ts.com.tw"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("colin.cope@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("fabian.storek@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alexander.eder@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("isnalvia.lischke@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("christine.klein@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Lisa.Schwaiger@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Dragana.Stojic@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alexander.nather@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Patrizia.Fischer@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("pat.howard@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Dieter.Leinert@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tobias.ramsaier@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Martina.Hellmann@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("George.Delis@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Cristina.Jimenez@tsceu.com"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("stefanie.kanter@tsceu.com"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSC-HQ-Reports@tsceu.com")); //add by Peggy 20231229
					}
					else
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
					}
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
				}
				else if (SALES_REGION.equals("TSCA"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("cindy.huang@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}
				else if (SALES_REGION.equals("TSCJ"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("jacksonl@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}
				else if (SALES_REGION.equals("TSCH-HK"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("fiona_chen@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("gina@mail.tew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("regina_pu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy_sun@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sophia_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tingting@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs001@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs003@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Lauren_pei@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kara_tian@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs005@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("candy_pan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian_zhan@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}	
				else if (SALES_REGION.equals("TSCC"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs003@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lauren_pei@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kara_tian@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("chris_wen@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian_zhan@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ccyang@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs001@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));					
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("daphne_zhang@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}
				else if (SALES_REGION.equals("TSCC-TSCH"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("candy_pan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("fiona_chen@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("regina_pu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy_sun@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sophia_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs001@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs003@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs005@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco_liu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian_zhan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("xiongyu@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));					
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("chris_wen@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));					
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ccyang@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("mery_heng@ts-china.com.cn"));					
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("daphne_zhang@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
				}
				else if (SALES_REGION.equals("TSCK"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}							
				else if (SALES_REGION.equals("TSCR-ROW"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alvin.lin@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joginder@tscind.in"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("priya.thakur@tscind.in"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lisa.chen@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}							
				else if (SALES_REGION.equals("TSCT-DA"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian.chou@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zoe.wu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rika_lin@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("olivia.hsu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ashley.chen@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}							
				else if (SALES_REGION.equals("TSCT-Disty"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kristin.wu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sofia.liu@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));					
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}		
				else if (SALES_REGION.equals("SAMPLE"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jenny.liao@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi.kao@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june@ts.com.tw"));
					if (REQ_NAME.toUpperCase().equals("NONO") && ACTTYPE.equals("AUTO"))
					{
						message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
					}
					
				}								
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));

			V_CUST_LIST="";
			if (!ACTTYPE.equals("ALLOVERDUE"))
			{
				sql = " SELECT DISTINCT '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end"+
					  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id in (14980,1019) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
					  " FROM oraddman.tsc_om_salesorderrevise_pc a"+
					  " ,ont.oe_order_lines_all d"+
					  " ,tsc_customer_all_v ar"+
					  " ,hz_cust_accounts end_cust"+
					  " WHERE REQUEST_NO=?"+
					  " AND DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group)=?"+
					  " AND a.STATUS=?"+
					  " AND a.so_line_id=d.line_id"+
					  " AND a.SOURCE_CUSTOMER_ID=ar.customer_id"+
					  " AND d.end_customer_id = end_cust.cust_account_id(+)";
				PreparedStatement statement2 = con.prepareStatement(sql);
				statement2.setString(1,NEW_REQ);
				statement2.setString(2,SALES_REGION);
				statement2.setString(3,"AWAITING_CONFIRM");
				//out.println(SALES_REGION);
				ResultSet rs2=statement2.executeQuery();
				while (rs2.next())
				{	
					if (!V_CUST_LIST.equals("")) V_CUST_LIST =V_CUST_LIST+"<br>";
					V_CUST_LIST =V_CUST_LIST+rs2.getString(1);	
				}
				rs2.close();
				statement2.close();
				strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to confirm order revise.<p>"+
							 "Include the following customer list in this request..<br>"+V_CUST_LIST;
			}
			
			message.setHeader("Subject", MimeUtility.encodeText((ACTTYPE.equals("REMINDER")?"Reminder-":"")+(ACTTYPE.equals("ALLOVERDUE")?"Factory Overdue Early-Warning Weekly Report":"工廠Early Ship/Overdue/Early warning通知(申請單號:"+NEW_REQ+")")+remarks, "UTF-8", null));	
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp.setContent(strContent, "text/html;charset=UTF-8");
			mp.addBodyPart(mbp);
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
	rs1.close();
	statement1.close();	
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
	else
	{
	%>
	<script language="JavaScript" type="text/JavaScript">
		window.close();		
	</script>	
	<%	
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
