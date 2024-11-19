<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>領料申請單</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSA01WIPRequestExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String dateStartType="";
String dateEndType="";
String YearFr=request.getParameter("YEARFR");
dateBean.setAdjDate(-1);
if (YearFr ==null) YearFr = dateBean.getYearString();
if (YearFr.equals("--")){YearFr ="";}else{dateStartType +="yyyy";}
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null) MonthFr = dateBean.getMonthString();
if (MonthFr.equals("--")){MonthFr ="";}else{	dateStartType +="mm";}
String DayFr=request.getParameter("DAYFR");
if (DayFr == null) DayFr = dateBean.getDayString();
if (DayFr.equals("--")){DayFr ="";}else{dateStartType +="dd";}
String dateSetBegin=YearFr+MonthFr+DayFr;  
dateSetBegin.replace("--","");
dateBean.setAdjDate(1);
String YearTo=request.getParameter("YEARTO");
if (YearTo == null) YearTo = dateBean.getYearString();
if (YearTo.equals("--")){YearTo ="";}else{dateEndType +="yyyy";}
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null) MonthTo = dateBean.getMonthString();
if (MonthTo.equals("--") ){MonthTo ="";}else{dateEndType +="mm";}
String DayTo=request.getParameter("DAYTO");
if (DayTo == null) DayTo = dateBean.getDayString();
if (DayTo.equals("--")){DayTo ="";}else{ dateEndType +="dd";}
String dateSetEnd = YearTo+MonthTo+DayTo; 
String TRANS_TYPE=request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String WIP_NO=request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String ITEM_NAME=request.getParameter("ITEMNAME");
if (ITEM_NAME==null) ITEM_NAME="";
String REQUEST_NO=request.getParameter("REQUESTNO");
if (REQUEST_NO==null) REQUEST_NO="";
String PICK_NO=request.getParameter("PICKNO");
if (PICK_NO==null) PICK_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String FileName="",RPTName="",sql="",swhere="",sql_h="",imageFile="",s_created_by="",s_approved_by="",s_inv_worked_by="";
String end_str="****** This copyright of document and business secret belong to TSC,and no copies should be made without any permission ******";
String rpt_code="AQ4PD08-C";
int fontsize=9,colcnt=0;
try 
{ 	
	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	OutputStream os = null;	
	FileName = "WIP_Request-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}

	//公司名稱中文平行置中     
	WritableCellFormat wCompCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("細明體"), 12 ,WritableFont.NO_BOLD,false));   
	wCompCName.setAlignment(jxl.format.Alignment.CENTRE);
		
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("細明體"), 10, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);

	//公司名稱中文平行置中     
	WritableCellFormat wCompCNameE = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 12 ,WritableFont.NO_BOLD,false));   
	wCompCNameE.setAlignment(jxl.format.Alignment.CENTRE);
		
	//報表名稱平行置中    
	WritableCellFormat wRptNameE = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 10, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptNameE.setAlignment(jxl.format.Alignment.CENTRE);
	
	//表尾行置左    
	WritableCellFormat wRptEndL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEndL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wRptEndL.setAlignment(jxl.format.Alignment.LEFT);
	
	//表尾行置右    
	WritableCellFormat wRptEndR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEndR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wRptEndR.setAlignment(jxl.format.Alignment.RIGHT);

	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = null;

	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	//sql = " select x.WIP_ENTITY_NAME || case when seq_no =1 then '' else '('||(seq_no-1)||')' end as wip_no,x.ORGANIZATION_ID,x.INVENTORY_ITEM_ID,x.REQUEST_TYPE,x.REQUEST_NO,x.WIP_ENTITY_NAME,x.WIP_ENTITY_ID,x.CREATION_DATE,x.ITEM_NAME "+
	//      " from (select ORGANIZATION_ID,REQUEST_TYPE,REQUEST_NO,WIP_ENTITY_NAME,WIP_ENTITY_ID,CREATION_DATE,INVENTORY_ITEM_ID,ITEM_NAME  ,row_number() over (partition by wip_entity_name order by request_no) seq_no"+
	//	  "       from oraddman.TSA01_REQUEST_HEADERS_ALL a "+
	//	  "       where a.STATUS not in ('REJECT','DISAGREE')  ?01 order by WIP_ENTITY_NAME,REQUEST_NO) x ";
	sql = " SELECT organization_id,request_type,request_no, wip_entity_name, wip_entity_id,creation_date,inventory_item_id,item_name,"+
          " WIP_ENTITY_NAME || case when (ROW_NUMBER ()  OVER (PARTITION BY wip_entity_name ORDER BY request_no))= 1 then '' else '-'|| ((ROW_NUMBER () OVER (PARTITION BY wip_entity_name ORDER BY request_no))-1) end as wip_no"+
          " FROM oraddman.tsa01_request_headers_all a"+
          " WHERE a.status NOT IN ('REJECT', 'DISAGREE')  ?01";
	if (TRANS_TYPE!=null && !TRANS_TYPE.equals("--") && !TRANS_TYPE.equals("")) swhere += " and a.request_type='"+TRANS_TYPE+"'";
	if (WIP_NO!=null && !WIP_NO.equals("")) swhere += "and a.wip_entity_name like '"+ WIP_NO.toUpperCase()+"%'";
	if (REQUEST_NO!=null && !REQUEST_NO.equals("")) swhere += " and a.REQUEST_NO LIKE '"+REQUEST_NO+"%'";
	if (PICK_NO!=null && !PICK_NO.equals("")) swhere += " and EXISTS (SELECT 1 FROM ORADDMAN.TSA01_REQUEST_LINES_ALL X WHERE X.PICK_NO like '"+ PICK_NO+"%' AND X.REQUEST_NO=A.REQUEST_NO)";
	if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) swhere += " and a.STATUS='"+ STATUS+"'";
	if (ITEM_NAME!=null && !ITEM_NAME.equals(""))
	{
		swhere += " and ( EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B X WHERE (X.description like '%"+ ITEM_NAME +"%' or  X.SEGMENT1 like '"+ITEM_NAME +"%') AND X.ORGANIZATION_ID=A.ORGANIZATION_ID AND X.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID)"+
		       " or ( exists (select 1 from ORADDMAN.TSA01_REQUEST_LINES_ALL X WHERE X.REQUEST_NO=A.REQUEST_NO AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B Y WHERE (Y.DESCRIPTION LIKE '%"+ITEM_NAME+"%' or Y.SEGMENT1 LIKE '"+ITEM_NAME+"%') AND Y.ORGANIZATION_ID=X.ORGANIZATION_ID=Y.INVENTORY_ITEM_ID=X.INVENTORY_ITEM_ID)))";
	}
	if (dateSetBegin!=null && !dateSetBegin.equals(""))
	{
		swhere += " and a.creation_date >=to_DATE('"+dateSetBegin+"','"+dateStartType+"') ";
	}
	if (dateSetEnd!=null && !dateSetEnd.equals("")) swhere += " and a.creation_date <=to_DATE('"+dateSetEnd+"','"+dateEndType+"')+0.99999";
	sql_h=sql.replace("?01",swhere);
	//out.println(sql_h);
	Statement statement2=con.createStatement();
	ResultSet rs2=statement2.executeQuery(sql_h);
	int sheet_cnt =0;
	while (rs2.next())
	{
		wwb.createSheet(rs2.getString("wip_no"), sheet_cnt);
		sheet_cnt++;
	}
	rs2.close();
	statement2.close(); 

	sql = " select a.WIP_NO"+
          ",a.REQUEST_TYPE"+
          ",a.REQUEST_NO"+
          ",a.WIP_ENTITY_NAME"+
          ",a.WIP_ENTITY_ID"+
          ",to_char(a.CREATION_DATE,'yyyy/mm/dd') CREATION_DATE"+
          ",a.ITEM_NAME"+
          ",c.DESCRIPTION ITEM_DESC"+
          ",b.LINE_NO"+
          ",nvl(b.COMP_TYPE_NO,a.COMP_TYPE_NO) COMP_TYPE_NO"+
          ",nvl(e.COMP_TYPE_NAME,a.COMP_TYPE_NAME) COMP_TYPE_NAME"+
          ",a.CONCATENATED_SEGMENTS COMPONENT_NAME"+
          ",d.DESCRIPTION COMPONENT_DESC"+
          ",a.ITEM_PRIMARY_UOM_CODE UOM"+
          ",b.REQUEST_QTY"+
          ",f.TYPE_NAME REQUEST_TYPE_NAME"+
		  ",b.CREATED_BY"+
          ",b.APPROVED_BY"+
          ",b.INV_WORKED_BY"+
          ",CASE WHEN a.supply_subinventory IS NOT NULL THEN  a.supply_subinventory || '倉'  ELSE  ''  END  remarks"+
          ",(SELECT listagg (RPAD (k.lot, 15, ' ') || ' ' || k.lot_qty || k.uom || CASE WHEN k.remarks IS NULL THEN '' ELSE '(' || k.remarks || ')' END, ' ') WITHIN GROUP (ORDER BY k.lot)  FROM oraddman.tsa01_request_wafer_lot_all k  WHERE b.request_no = k.request_no AND b.line_no = k.line_no) lot_list"+
          ",(SELECT COUNT (1) FROM oraddman.tsa01_request_wafer_lot_all k WHERE a.request_no = k.request_no AND b.line_no = k.line_no) lot_cnt"+
		  " from (select a.*,b.INVENTORY_ITEM_ID CONCATENATED_ITEM_ID,b.CONCATENATED_SEGMENTS,b.ITEM_PRIMARY_UOM_CODE,b.OPERATION_SEQ_NUM ,b.supply_subinventory,d.COMP_TYPE_NO,d.COMP_TYPE_NAME"+
          "       from ("+sql_h+") a,"+
          "        wip_requirement_operations_v b, "+
		  "        ORADDMAN.TSA01_COMPONENT_DETAIL C,"+
		  "        ORADDMAN.TSA01_COMPONENT_TYPE D"+
          "        where a.wip_entity_id = b.wip_entity_id"+
          "        and a.organization_id = b.organization_id "+
          "        and B.ORGANIZATION_ID=C.ORGANIZATION_ID"+
          "        and B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID"+
          "        and C.COMP_TYPE_NO=D.COMP_TYPE_NO) a,"+
          " oraddman.tsa01_request_lines_all b,"+
          " inv.mtl_system_items_b c,"+
          " inv.mtl_system_items_b d,"+
          " (SELECT * FROM oraddman.tsa01_component_type  WHERE NVL (active_flag, 'N') = 'Y') e,"+
          " (SELECT type_name, type_value  FROM oraddman.tsa01_base_setup WHERE type_code = 'REQ_TYPE') f"+
          " where a.request_no=b.request_no(+)"+
          " and a.CONCATENATED_ITEM_ID=b.component_item_id(+)"+
          " and a.organization_id=b.organization_id(+)"+
          " and to_char(a.operation_seq_num)=b.op_seq_num(+)"+
          " and a.organization_id = c.organization_id"+
          " and a.inventory_item_id = c.inventory_item_id"+
          " and a.organization_id = d.organization_id"+
          " and a.CONCATENATED_ITEM_ID = d.inventory_item_id"+
          " and b.comp_type_no = e.comp_type_no(+)"+
          " and a.request_type = f.type_value(+)"+    
          " order by a.wip_no, a.wip_entity_name, nvl(b.line_no,100+rownum)";
	/*
	sql = " SELECT A.WIP_NO,A.REQUEST_TYPE,A.REQUEST_NO,A.WIP_ENTITY_NAME,A.WIP_ENTITY_ID,TO_CHAR(A.CREATION_DATE,'YYYY/MM/DD') CREATION_DATE,A.ITEM_NAME,C.DESCRIPTION ITEM_DESC"+
          " ,B.LINE_NO,B.COMP_TYPE_NO,E.COMP_TYPE_NAME,B.COMPONENT_NAME,D.DESCRIPTION COMPONENT_DESC,B.UOM,B.REQUEST_QTY,F.TYPE_NAME REQUEST_TYPE_NAME"+
		  " ,b.remarks"+
		  " ,B.LOT_LIST"+
		  " ,(SELECT COUNT(1) FROM  oraddman.tsa01_request_wafer_lot_all k WHERE a.request_no = k.request_no AND B.line_no = k.line_no) lot_cnt"+
	      " FROM ("+sql_h+") A,"+
		  //" ORADDMAN.TSA01_REQUEST_LINES_ALL B,"+
		  "(SELECT A.REQUEST_NO,A.LINE_NO,A.COMP_TYPE_NO,A.ORGANIZATION_ID,A.COMPONENT_NAME,A.COMPONENT_ITEM_ID,A.UOM,A.REQUEST_QTY"+
          ",(select listagg(RPAD(k.LOT,15,' ') ||'  ' ||K.LOT_QTY||K.UOM || CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'\n') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k where  a.request_no=k.request_no"+
          " and a.line_no=k.line_no) lot_list,'' remarks"+
          " FROM ORADDMAN.TSA01_REQUEST_LINES_ALL A "+
          " UNION ALL"+
          " SELECT  A.REQUEST_NO,ROW_NUMBER() OVER (PARTITION BY A.REQUEST_NO,B.WIP_ENTITY_ID ORDER BY B.INVENTORY_ITEM_ID)+100 LINE_NO,D.COMP_TYPE_NO,B.ORGANIZATION_ID, C.ITEM_NAME component_name,C.INVENTORY_ITEM_ID component_item_id,B.item_primary_uom_code UOM,null as request_qty"+
		  ",'' lot_list,CASE WHEN B.SUPPLY_SUBINVENTORY IS NOT NULL then B.SUPPLY_SUBINVENTORY||'倉' ELSE '' END remarks"+
          " FROM  ORADDMAN.TSA01_REQUEST_HEADERS_ALL A, WIP_REQUIREMENT_OPERATIONS_V B,ORADDMAN.TSA01_COMPONENT_DETAIL C,ORADDMAN.TSA01_COMPONENT_TYPE D"+
          " WHERE A.WIP_ENTITY_ID=B.WIP_ENTITY_ID"+
          " AND A.ORGANIZATION_ID=B.ORGANIZATION_ID"+
          " AND B.ORGANIZATION_ID=C.ORGANIZATION_ID"+
          " AND B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID"+
          " AND C.COMP_TYPE_NO=D.COMP_TYPE_NO"+
          " AND NOT EXISTS (SELECT 1 FROM ORADDMAN.TSA01_REQUEST_LINES_ALL X WHERE X.REQUEST_NO=A.REQUEST_NO AND X.COMPONENT_ITEM_ID=B.INVENTORY_ITEM_ID AND X.ORGANIZATION_ID=B.ORGANIZATION_ID)"+
          " ORDER BY 1,2) B,"+
		  " INV.MTL_SYSTEM_ITEMS_B C,"+
		  " INV.MTL_SYSTEM_ITEMS_B D,"+
          " (SELECT * FROM ORADDMAN.TSA01_COMPONENT_TYPE WHERE NVL(ACTIVE_FLAG,'N')='Y') E,"+
          " (SELECT TYPE_NAME,TYPE_VALUE FROM ORADDMAN.TSA01_BASE_SETUP WHERE TYPE_CODE='REQ_TYPE') F "+
          " WHERE A.REQUEST_NO=B.REQUEST_NO"+
          " AND A.ORGANIZATION_ID=C.ORGANIZATION_ID"+
          " AND A.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID "+
          " AND B.ORGANIZATION_ID=D.ORGANIZATION_ID"+
          " AND B.COMPONENT_ITEM_ID=D.INVENTORY_ITEM_ID"+
          " AND B.COMP_TYPE_NO=E.COMP_TYPE_NO"+
          " AND A.REQUEST_TYPE=F.TYPE_VALUE"+
		  " ORDER BY A.WIP_NO,A.WIP_ENTITY_NAME,B.LINE_NO";*/
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	String wip_no ="";
	while (rs.next())
	{
		if (!wip_no.equals(rs.getString("wip_no")))
		{
			if (reccnt >0)
			{
				row+=3;
				col=0;
				ws.setRowView(row,500);		
				//ws.mergeCells(col, row, col, row);     
				ws.addCell(new jxl.write.Label(col, row,"製造部主管/PD Supervisor:", wRptEndL)); 
				col +=1;
				imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_approved_by+".PNG";
				File f = new File(imageFile);
				if(f.exists()) 
				{
					jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.5,0.8, f); 
					ws.addImage(image1);
				}		
				col +=1;
				
				//ws.mergeCells(col, row, col+1, row);     
				ws.addCell(new jxl.write.Label(col, row,"倉庫/Warehouse:", wRptEndL)); 
				ws.setColumnView(col,15);
				col +=1;
				imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_inv_worked_by+".PNG";
				f = new File(imageFile);
				if(f.exists()) 
				{
					jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.3,0.8, f); 
					ws.addImage(image1);
				}		
				ws.setColumnView(col,45);
				col +=1;
				
				ws.mergeCells(col, row, col+1, row);     
				ws.addCell(new jxl.write.Label(col, row,"申請人/Applicant:", wRptEnd)); 
				col +=2;
				imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_created_by+".PNG";
				f = new File(imageFile);
				if(f.exists()) 
				{
					jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.3,0.8, f); 
					ws.addImage(image1);
				}			
				row+=2;//列+1
				col=0;
				ws.mergeCells(col, row, col+5, row);     
				ws.addCell(new jxl.write.Label(col, row,end_str, wRptEnd)); 
				row++;//列+1
				col=0;
				ws.mergeCells(col, row, col+5, row);     
				ws.addCell(new jxl.write.Label(col, row,"("+rpt_code+")", wRptEndR)); 
				row++;//列+1
			}
			wip_no=rs.getString("wip_no");
			ws = wwb.getSheet(wip_no);
			s_created_by="";s_approved_by="";s_inv_worked_by="";
			reccnt =0;
		}
		if (reccnt==0)
		{
			col=0;row=0;
			SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
			settings.setZoomFactor(100);    //顯示縮放比例
			settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
			settings.setScaleFactor(85);   // 打印縮放比例
			settings.setHeaderMargin(0.3);
			settings.setBottomMargin(0.5);
			settings.setLeftMargin(0.2);
			settings.setRightMargin(0.2);
			settings.setTopMargin(0.5);
			settings.setFooterMargin(0.3);	
				
			//logo
			jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1.5,row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
			ws.addImage(image); 
						
			String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCName));
			//ws.setColumnView(col,50);	
			row++;//列+1

			strCTitle = "Taiwan Semiconductor Co., Ltd";
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCNameE));
			//ws.setColumnView(col,50);	
			row++;//列+1
			
			String strETitle = "封裝"+(rs.getString("request_type").equals("ISSUE")?"領料":(rs.getString("request_type").equals("RETURN")?"退料":""))+"申請單-原料";
			ws.setRowView(row,300);
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strETitle , wRptName));
			row++;//列+1

			strETitle = "Assembly "+(rs.getString("request_type").equals("ISSUE")?"Requisition ":(rs.getString("request_type").equals("RETURN")?"Return ":""))+"Application-Raw Material";
			ws.setRowView(row,300);
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strETitle , wRptNameE));
			row++;//列+1
			
			col=0;
			ws.setRowView(row,300);
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row,"領料單號/Requisition No.:"+rs.getString("REQUEST_NO"), wRptEndL)); 
			col +=2;
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row,"領料單位/Dept.:5402", wRptEndL)); 
			col +=2;
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row,"申請日期/Request Date:"+rs.getString("CREATION_DATE"), wRptEndL)); 
			col +=3;
			row++;//列+1

			col=0;
			ws.setRowView(row,300);
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row,"工單號碼/Work Order No.:"+rs.getString("WIP_ENTITY_NAME"), wRptEndL)); 
			col +=2;
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row,"品名/Item Desc:"+rs.getString("ITEM_DESC"), wRptEndL)); 
			col +=2;
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row,"料號/Item Name:"+rs.getString("ITEM_NAME"), wRptEndL)); 
			col +=3;
			row++;//列+1
			
			col=0;
			ws.setRowView(row, 300);		
			ws.addCell(new jxl.write.Label(col, row, "類別/Category" , ACenterBL));
			ws.setColumnView(col,22);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "料號/Item No." , ACenterBL));
			ws.setColumnView(col,33);	
			col++;	

			ws.mergeCells(col, row, col+1, row);   
			ws.addCell(new jxl.write.Label(col, row, "品名/Item" , ACenterBL));
			ws.setColumnView(col,60);	
			col+=2;	

			ws.addCell(new jxl.write.Label(col, row, "單位/Unit" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "領用數量/Q'ty" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "備註/Remarks" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;	
			row++;
			
		}
		
		if (s_created_by.equals("") && rs.getString("CREATED_BY")!=null)
		{
			s_created_by=rs.getString("CREATED_BY");
		}
		if (s_approved_by.equals("") && rs.getString("APPROVED_BY")!=null)
		{
			s_approved_by=rs.getString("APPROVED_BY");
		} 
		if (s_inv_worked_by.equals("") && rs.getString("INV_WORKED_BY")!=null)
		{
			s_inv_worked_by=rs.getString("INV_WORKED_BY");
		} 
		col=0;
		ws.setRowView(row, (rs.getInt("lot_cnt")>1?300*rs.getInt("lot_cnt"):300));
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMP_TYPE_NAME") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_NAME") , ALeftL));
		col++;	
		ws.mergeCells(col, row, col+1, row);   
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_DESC") ,ALeftL));
		col+=2;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		col++;	
		if (rs.getString("REQUEST_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks"))+(rs.getString("lot_list")==null?"":rs.getString("lot_list")) , ALeftL));
		col++;	
		row++;
		reccnt++;
		totcnt++;
	}
	if (reccnt >0)
	{
		row+=3;
		col=0;
		ws.setRowView(row,500);		
		//ws.mergeCells(col, row, col, row);     
		ws.addCell(new jxl.write.Label(col, row,"製造部主管/PD Supervisor:", wRptEndL)); 
		col +=1;
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_approved_by+".PNG";
		File f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.5,0.8, f); 
			ws.addImage(image1);
		}		
		col +=1;
		
		//ws.mergeCells(col, row, col+1, row);     
		ws.addCell(new jxl.write.Label(col, row,"倉庫/Warehouse:", wRptEndL)); 
		ws.setColumnView(col,15);
		col +=1;
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_inv_worked_by+".PNG";
		f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.3,0.8, f); 
			ws.addImage(image1);
		}		
		ws.setColumnView(col,45);
		col +=1;
		
		ws.mergeCells(col, row, col+1, row);     
		ws.addCell(new jxl.write.Label(col, row,"申請人/Applicant:", wRptEnd)); 
		col +=2;
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+s_created_by+".PNG";
		f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col,row+0.1,0.3,0.8, f); 
			ws.addImage(image1);
		}			
		row+=2;//列+1
		
		col=0;
		ws.mergeCells(col, row, col+6, row);     
		ws.addCell(new jxl.write.Label(col, row,end_str, wRptEnd)); 
		row++;//列+1
		col=0;
		ws.mergeCells(col, row, col+6, row);     
		ws.addCell(new jxl.write.Label(col, row,"("+rpt_code+")", wRptEndR)); 
		row++;//列+1
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
			
	rs.close();
	statement.close();		
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
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
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName+".xls"; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
