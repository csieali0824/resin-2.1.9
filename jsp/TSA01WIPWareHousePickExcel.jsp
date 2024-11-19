<!--20161021 Peggy,新增庫存說明欄位-->
<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.text.AttributedString,java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>撿貨單</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSA01WIPWareHousePickExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String FileName="",RPTName="",sql="";
int fontsize=8,colcnt=0,ipage=56,nowpage=0;
long strItemId=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	String advise_no="";
	OutputStream os = null;	
	FileName = PICK_NO+"("+UserName+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}

	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置左  
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),10,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	
	//英文內文水平垂直置右 
	WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),10 ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);	
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-正常-格線 -字體紅  
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);
	
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
	wwb.createSheet("Pick List", 0);
	wwb.createSheet("Row Data", 1);
	WritableSheet ws = null;	

	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;totcnt=0;nowpage=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings settings = ws.getSettings(); 
		settings.setSelected();
		if (i==0)
		{
			//settings.setZoomFactor(90);    //顯示縮放比例
			settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
			settings.setScaleFactor(65);   // 打印縮放比例
			settings.setHeaderMargin(0.3);
			settings.setBottomMargin(0.3);
			settings.setLeftMargin(0.2);
			settings.setRightMargin(0.2);
			settings.setTopMargin(0.3);
			settings.setFooterMargin(0.3);	
	
			sql = " SELECT x.*,TSA01_WIP_PKG.GET_SUM_DESC(x.COMP_TYPE_NO,x.ORGANIZATION_ID,x.INVENTORY_ITEM_ID,x.ONHAND-NVL(x.REQUEST_QTY,0)) ONHAND_SUM_DESC"+
			      " FROM (SELECT A.PICK_NO"+
			      ",(SELECT TYPE_NAME FROM ORADDMAN.TSA01_BASE_SETUP Z WHERE Z.TYPE_CODE='REQ_TYPE' AND Z.TYPE_VALUE=A.REQUEST_TYPE) REQUEST_TYPE_NAME"+
				  ",(SELECT case when a.request_type IN ('MISC','RDMISC','QCMISC')  then case when NVL(a.REQUEST_QTY,0)<0 then '領用' else '領退' end else TYPE_NAME end FROM ORADDMAN.TSA01_BASE_SETUP Z WHERE Z.TYPE_CODE='REQ_TYPE' AND Z.TYPE_VALUE=A.REQUEST_TYPE) req_type_name"+//add by Peggy 20180927
				  ",C.COMP_TYPE_NAME"+
				  ",A.COMPONENT_ITEM_ID INVENTORY_ITEM_ID"+
				  ",A.COMPONENT_NAME ITEM_NAME"+
				  ",D.DESCRIPTION ITEM_DESC"+
				  ",A.UOM"+
				  ",E.ORGANIZATION_CODE"+
				  ",A.REQUEST_QTY"+
				  ",nvl((SELECT SUM(x.TRANSACTION_QUANTITY) FROM INV.MTL_ONHAND_QUANTITIES_DETAIL X"+
                  "      WHERE X.SUBINVENTORY_CODE IN ('01','02','11','21')"+
                  "      AND X.ORGANIZATION_ID=A.ORGANIZATION_ID"+
                  "      AND x.INVENTORY_ITEM_ID=A.COMPONENT_ITEM_ID),0) ONHAND"+
                  ",A.MOQ"+
				  ",A.COMP_TYPE_NO"+
				  ",A.ORGANIZATION_ID"+
				  //",CEIL(NVL(A.REQUEST_QTY,0)/A.MOQ)*A.MOQ PICK_QTY"+
                  //",TSA01_WIP_PKG.GET_SUM_DESC(A.COMP_TYPE_NO,A.ORGANIZATION_ID,A.COMPONENT_ITEM_ID,CEIL(NVL(A.REQUEST_QTY,0)/A.MOQ)*A.MOQ) SUM_DESC"+
				  ",CASE WHEN A.REQUEST_TYPE IN ('MISC','RDMISC','QCMISC') THEN A.REQUEST_QTY ELSE CEIL(NVL(A.REQUEST_QTY,0)/A.MOQ)*A.MOQ END AS PICK_QTY"+   //add by Peggy 20180926
                  ",CASE WHEN A.REQUEST_TYPE IN ('MISC','RDMISC','QCMISC') THEN '' ELSE TSA01_WIP_PKG.GET_SUM_DESC(A.COMP_TYPE_NO,A.ORGANIZATION_ID,A.COMPONENT_ITEM_ID,CEIL(NVL(A.REQUEST_QTY,0)/A.MOQ)*A.MOQ) END AS SUM_DESC"+ //add by Peggy 20180926
                  ",B.SUBINVENTORY_CODE"+
				  ",B.LOT_NUMBER"+
				  ",A.REQUEST_TYPE"+
				  ",NVL(B.LOT_QTY,0) LOT_QTY"+
				  ",(COUNT(1) OVER (PARTITION BY A.COMPONENT_ITEM_ID, E.ORGANIZATION_CODE)) LINE_CNT"+
				  ",B.MISCELLANEOUS_FLAG"+ //add by Peggy 20161207
				  ",CASE WHEN A.REQUEST_QTY-(SUM(NVL(B.LOT_QTY,0)) OVER (PARTITION BY A.COMPONENT_ITEM_ID, E.ORGANIZATION_CODE)) >0 THEN '庫存少'|| (A.REQUEST_QTY-(SUM(NVL(B.LOT_QTY,0)) OVER (PARTITION BY A.COMPONENT_ITEM_ID, E.ORGANIZATION_CODE))) || A.UOM ELSE '' END AS REMARKS"+
                  " FROM  (SELECT X.PICK_NO,Y.REQUEST_TYPE,X.ORGANIZATION_ID,X.COMPONENT_ITEM_ID,X.COMPONENT_NAME,X.COMP_TYPE_NO,X.UOM,X.MOQ,SUM(X.REQUEST_QTY) REQUEST_QTY  "+
                  "        FROM ORADDMAN.TSA01_REQUEST_LINES_ALL X,ORADDMAN.TSA01_REQUEST_HEADERS_ALL Y"+
                  "        WHERE X.PICK_NO=?"+
                  "        AND X.REQUEST_NO=Y.REQUEST_NO"+
                  "        GROUP BY X.PICK_NO,Y.REQUEST_TYPE,X.ORGANIZATION_ID,X.COMPONENT_ITEM_ID,X.COMPONENT_NAME,X.COMP_TYPE_NO,X.UOM,X.MOQ) A"+
                  ",(SELECT X.ORGANIZATION_ID,X.COMPONENT_ITEM_ID,X.SUBINVENTORY_CODE,X.LOT_NUMBER,X.MISCELLANEOUS_FLAG,SUM(X.LOT_QTY) LOT_QTY FROM ORADDMAN.TSA01_REQUEST_LINE_LOTS_ALL X"+
                  "       WHERE EXISTS (SELECT 1 FROM ORADDMAN.TSA01_REQUEST_LINES_ALL Y WHERE Y.PICK_NO=? AND Y.REQUEST_NO=X.REQUEST_NO AND Y.LINE_NO=X.LINE_NO)"+
                  "       GROUP BY X.ORGANIZATION_ID,X.COMPONENT_ITEM_ID,X.SUBINVENTORY_CODE,X.LOT_NUMBER,X.MISCELLANEOUS_FLAG) B"+
                  ",ORADDMAN.TSA01_COMPONENT_TYPE C"+
                  ",INV.MTL_SYSTEM_ITEMS_B D"+
                  ",INV.MTL_PARAMETERS E"+
                  " WHERE A.ORGANIZATION_ID=B.ORGANIZATION_ID(+) "+
                  " AND A.COMPONENT_ITEM_ID=B.COMPONENT_ITEM_ID(+)"+
                  " AND A.COMP_TYPE_NO=C.COMP_TYPE_NO(+)"+
                  " AND B.ORGANIZATION_ID=D.ORGANIZATION_ID"+
                  " AND B.COMPONENT_ITEM_ID=D.INVENTORY_ITEM_ID"+
                  " AND B.ORGANIZATION_ID=E.ORGANIZATION_ID"+
                  " ORDER BY case when a.request_type  IN ('MISC','RDMISC','QCMISC') then case when NVL(B.LOT_QTY,0)>=0 then 1 else 2 end else 3 end, C.COMP_TYPE_NO,a.component_name ,B.LOT_NUMBER) x";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,PICK_NO);
			statement.setString(2,PICK_NO);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				if (reccnt==0)
				{
				
					String strRPTtitle = "倉庫撿貨單";
					ws.mergeCells(col, row, col+13, row);     
					ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName));
					row+=1;//列+1
				
					ws.setRowView(row, 450);
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,"撿貨單號："+PICK_NO,ALEFT));
					ws.mergeCells(12, row, 13, row);     
					ws.addCell(new jxl.write.Label(12, row,"交易類型："+rs.getString("request_type_name"),ARIGHT));
					row++;//列+1
		
					ws.setRowView(row, 400);
					ws.addCell(new jxl.write.Label(col, row, "領用/領退" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "類別" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBL));
					ws.setColumnView(col,22);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBL));
					ws.setColumnView(col,35);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "庫存數量" , ACenterBL));
					ws.setColumnView(col,11);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "領用數量" , ACenterBL));
					ws.setColumnView(col,9);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "最小發料量" , ACenterBL));
					ws.setColumnView(col,9);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "撿貨數量" , ACenterBL));
					ws.setColumnView(col,9);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "撿貨說明" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "剩餘庫存說明" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "組織" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "倉庫" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
					ws.setColumnView(col,18);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBL));
					ws.setColumnView(col,9);	
					col++;		

					ws.addCell(new jxl.write.Label(col, row, "工程批" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;		
					
					//ws.addCell(new jxl.write.Label(col, row, "有效期" , ACenterBL));
					//ws.setColumnView(col,15);	
					//col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;		
					
					row++;
				}
		
				col=0;
				ws.setRowView(row, 400);
				if (strItemId != rs.getInt("INVENTORY_ITEM_ID"))
				{
					strItemId = rs.getInt("INVENTORY_ITEM_ID");
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("req_type_name") ,(rs.getString("req_type_name").equals("領退")?ACenterLR:ACenterL)));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("COMP_TYPE_NAME") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"),ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"),ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), ARightL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					if (rs.getString("REQUEST_QTY")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue(), ARightL));
					}
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					if (rs.getString("MOQ")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("MOQ")).doubleValue(), ARightL));
					}
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					if (rs.getString("PICK_QTY")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PICK_QTY")).doubleValue(), ARightL));
					}
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("SUM_DESC") , ACenterL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1);     
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ONHAND_SUM_DESC") , ACenterL));
					col++;	
					
				}
				else
				{
					col=11;
				}
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORGANIZATION_CODE")==null?"":rs.getString("ORGANIZATION_CODE")), ACenterL));
				col++;			
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("SUBINVENTORY_CODE")==null?"":rs.getString("SUBINVENTORY_CODE")), ACenterL));
				col++;			
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("LOT_NUMBER")==null?"":rs.getString("LOT_NUMBER")) , ALeftL));
				col++;		
				if (rs.getString("LOT_QTY")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LOT_QTY")).doubleValue(), ARightL));
				}
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (!rs.getString("REQUEST_TYPE").equals("MISC") && !rs.getString("REQUEST_TYPE").equals("RDMISC") && !rs.getString("REQUEST_TYPE").equals("QCMISC") && rs.getString("MISCELLANEOUS_FLAG")!=null && rs.getString("MISCELLANEOUS_FLAG").equals("Y")?"Y":"") , ACenterL));
				col++;		
				//ws.addCell(new jxl.write.Label(col, row, (rs.getString("EXPIRATION_DATE")==null?"":rs.getString("EXPIRATION_DATE")), ACenterL));
				//col++;			
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")),ALeftL));
				col++;	
				row++;
		
				reccnt++;
			}
	
			rs.close();
			statement.close();		
		}
		else if (i==1)				
		{
			settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
			settings.setZoomFactor(100);    //顯示縮放比例
			settings.setScaleFactor(80);   // 打印縮放比例
			settings.setHeaderMargin(0.3);
			settings.setBottomMargin(0.3);
			settings.setLeftMargin(0.2);
			settings.setRightMargin(0.2);
			settings.setTopMargin(0.3);
			settings.setFooterMargin(0.3);	
			
			sql = " SELECT a.request_no"+
			      ", a.request_type"+
				  ", g.organization_code"+
				  ", a.organization_id"+
                  ", a.wip_entity_name"+
				  ", a.wip_entity_id"+
				  ", a.inventory_item_id"+
				  ", a.item_name"+
				  ", a.tsc_package"+
				  ", a.created_by"+
				  ", to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
                  ", a.last_updated_by"+
				  ", to_char(a.last_update_date,'yyyy-mm-dd') last_update_date"+
				  ", nvl(d.TYPE_VALUE ,a.status) status"+
				  ", a.version_id"+
				  ", e.PICK_NO"+
                  ", c.TYPE_NAME"+
				  ", case when c.type_value IN ('MISC','RDMISC','RDMISC') then case when  e.request_qty<0 then '領用' else '領退' end else c.type_name end as request_type_name"+ //add by Peggy 20180927
				  ", b.description component_item_desc"+
				  ", e.line_no"+
				  ", e.comp_type_no"+
				  ", f.comp_type_name"+
				  ", e.component_item_id"+
				  ", e.component_name"+
                  ", e.uom"+
				  ", e.request_qty"+
				  ", e.remarks"+
				  ", ceil(count(1) over (partition by e.pick_no)/?) page_cnt"+
                  ",(select listagg(CASE WHEN NVL(k.MISCELLANEOUS_FLAG,'N')='Y' and a.request_type NOT IN ('MISC','RDMISC','RDMISC') THEN '工程批:' ELSE '' END || k.LOT ||'  ' ||K.LOT_QTY||K.UOM ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'\n') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
				  " where e.request_no=k.request_no"+
                  " and e.line_no=k.line_no) lot_list"+
		          " ,(SELECT COUNT(1) FROM  oraddman.tsa01_request_wafer_lot_all k WHERE e.request_no = k.request_no AND e.line_no = k.line_no) lot_cnt"+
                  " FROM oraddman.tsa01_request_headers_all a"+
                  " ,inv.mtl_system_items_b b"+
                  " ,(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
                  " ,(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
                  " ,oraddman.tsa01_request_lines_all e"+
                  " ,oraddman.tsa01_component_type f"+
                  " ,mtl_parameters g"+
                  " where e.organization_id=b.organization_id "+
                  " and e.component_item_id=b.inventory_item_id "+
                  " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
                  " and a.status=d.TYPE_NAME(+)"+
                  " and a.request_no=e.request_no(+)"+
                  " and e.COMP_TYPE_NO=f.COMP_TYPE_NO(+)"+
                  " and a.organization_id=g.organization_id(+)"+
                  " and e.pick_no=?"+
                  " order by a.request_no,e.LINE_NO";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setInt(1,ipage-1);
			statement.setString(2,PICK_NO);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				if (reccnt >=ipage)
				{
					ws.addRowPageBreak(row);
					reccnt=0;col=0;		
				}
				if (reccnt==0)
				{
					nowpage++;
					ws.setRowView(row, 450);
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,"撿貨單號："+PICK_NO,ALEFT));
					ws.addCell(new jxl.write.Label(9, row,"頁數："+nowpage+"/"+rs.getInt("page_cnt"),ALEFT));
					row++;//列+1
		
					ws.setRowView(row, 400);
					ws.addCell(new jxl.write.Label(col, row, "交易類型" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "領用/領退" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "組織" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "領料單號" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "工單號碼" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
		
					//ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBL));
					//ws.setColumnView(col,25);	
					//col++;	

					ws.addCell(new jxl.write.Label(col, row, "類別" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "原物料名稱" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBL));
					ws.setColumnView(col,35);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "領用數量" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
					ws.setColumnView(col,30);	
					col++;	
					row++;
				}
		
				col=0;
				ws.setRowView(row, (rs.getInt("lot_cnt")>1?300*rs.getInt("lot_cnt"):400));
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TYPE_NAME") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_TYPE_NAME") , (rs.getString("REQUEST_TYPE_NAME").equals("領退")?ACenterLR:ACenterL)));  //add by Peggy 20180927
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_CODE"),ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO"),ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("WIP_ENTITY_NAME"),ACenterL));
				col++;	
				//ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"),ALeftL));
				//col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("COMP_TYPE_NAME"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_NAME"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_ITEM_DESC"),ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
				col++;	
				if (rs.getString("REQUEST_QTY")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue(), ARightL));
				}
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))+(rs.getString("lot_list")==null?"":rs.getString("lot_list")), ALeftL));
				col++;			
				row++;
		
				reccnt=reccnt + (rs.getInt("lot_cnt")<=1?1:rs.getInt("lot_cnt"));
				totcnt++;
			}
	
			rs.close();
			statement.close();				
		}
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
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
