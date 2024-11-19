<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC ITEM INFO</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCItemInfoReport.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sql2="",sql3="",where="";
int fontsize=8,colcnt=0;
int row =0,col=0,reccnt=0;
String strAECQ="",strDesc="",strCartonSize="",strGW="",strwebstatus="",strgroup="",obsoletedate="";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	OutputStream os = null;	
	RPTName = "TSC Item Price Info";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://10.0.1.60:3306?user=remote&password=6huA=MUvs$T>>MAT");
		
    sql = "select a.*,CASE WHEN a.OPERAND IS NOT NULL THEN  decode( a.PRODUCT_UOM_CODE,'KPC', a.OPERAND/1000,a.OPERAND) ELSE decode( D.PRODUCT_UOM_CODE,'KPC', D.OPERAND/1000,d.OPERAND) END AS PRICE"+
          ",to_char(CASE WHEN a.OPERAND IS NOT NULL THEN  a.last_update_date  ELSE  d.last_update_date END,'yyyy-mm-dd') AS price_last_update_date"+
          ",'PCE' UOM"+
          ",qq.SPQ"+
          ",qq.MOQ"+
          ",qq.SAMPLE_SPQ"+
          ",tt.LEAD_TIME"+
          ",tt.NO_WAFER_LEAD_TIME"+
          " FROM (SELECT msi.organization_id,msi.segment1,msi.description,msi.inventory_item_id,msi.attribute3,msi.attribute4 PM,msi.inventory_item_status_code status,"+
          "       TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_Package') TSC_PACKAGE , "+
          "       TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_PROD_GROUP') TSC_PROD_GROUP, "+
          "       TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_Family') TSC_FAMILY,"+
          "       TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_PROD_CATEGORY') TSC_PROD_CATEGORY,"+
          "       CASE WHEN TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_PROD_GROUP') IN ('PMD','SSD','SSP') THEN TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_PROD_FAMILY') ELSE '' END TSC_PROD_FAMILY,"+
          "       TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id) PACKAGE_CODE ,"+
          "       TSC_OM_CATEGORY(msi.inventory_item_id,43,'TSC_PartNO') item_desc,"+
          //"       TRIM(REPLACE(CASE WHEN INSTR( MSI.description,'-0')>0 OR INSTR( MSI.description,'-1')>0 OR INSTR( MSI.description,'-2')>0 OR INSTR( MSI.description,'-3')>0  OR INSTR( MSI.description,'-4')>0  OR INSTR( MSI.description,'-6')>0 OR INSTR( MSI.description,'-7')>0  OR INSTR( MSI.description,'-8')>0 OR INSTR( MSI.description,'-6')>0 OR INSTR( MSI.description,'-T')>0 OR INSTR( MSI.description,'-K')>0 or INSTR( MSI.description,'/')>0 then substr(MSI.description,1,length(MSI.description)-INSTR(REVERSE(MSI.description),'-',1)) else trim(substr(MSI.description,1,length(MSI.description)-  (LENGTH (tsc_get_item_packing_code (msi.organization_id, msi.inventory_item_id)) + 1 ))) end,'Fairchild',''))  as item_desc"+
          "       tm.ALENGNAME factory_code,"+
          "       qm.PRODUCT_UOM_CODE ,"+
		  "       qm.OPERAND ,"+
		  "       qm.last_update_date,"+
          "       pcn.pcn_list,"+
		  "       to_char(pt.CREATION_DATE,'yyyy-mm-dd') parts_release_date"+
          "       FROM MTL_SYSTEM_ITEMS  msi"+
          "       ,oraddman.tsprod_manufactory tm"+
          "       ,(select xx.* from (select msi.inventory_item_id,msi.segment1,msi.description,qml.note_header_id,to_number(nvl(qml.Product_Attr_Value,0)) category_id,qml.PRODUCT_UOM_CODE , qml.OPERAND ,msi.segment1 category_name,qml.last_update_date,ROW_NUMBER() OVER(PARTITION BY msi.segment1,qml.NOTE_HEADER_ID,qml.PRODUCT_ATTR_VALUE ORDER BY qml.LAST_UPDATE_DATE DESC,NOTE_LINE_ID DESC) REC_SEQ  from QP_MODIFY_NOTE_LINES qml, qp_modify_note_headers qmh,inv.mtl_system_items_b msi where qml.note_header_id =qmh.note_header_id (+) and qml.Product_Attribute ='PRICING_ATTRIBUTE1' and to_number(nvl(qml.Product_Attr_Value,0))=msi.inventory_item_id and msi.organization_id=43"+
          "                           union all"+
          "                            select msi.inventory_item_id,msi.segment1,msi.description,qml.note_header_id,to_number(nvl(qml.Product_Attr_Value,0)) category_id,qml.PRODUCT_UOM_CODE , qml.OPERAND,qic.category_name ,qml.last_update_date,ROW_NUMBER() OVER(PARTITION BY msi.segment1,qml.NOTE_HEADER_ID,qml.PRODUCT_ATTR_VALUE ORDER BY qml.LAST_UPDATE_DATE DESC,NOTE_LINE_ID DESC) REC_SEQ from QP_MODIFY_NOTE_LINES qml, qp_modify_note_headers qmh,qp_item_categories_v qic ,inv.mtl_system_items_b msi where  qml.note_header_id =qmh.note_header_id (+) and qml.Product_Attribute ='PRICING_ATTRIBUTE2' and qml.PRODUCT_ATTR_VALUE=qic.category_id and msi.organization_id=43"+
          "                         and qic.category_name=trim(substr(MSI.description,1,length(MSI.description)-  (LENGTH (tsc_get_item_packing_code (msi.organization_id, msi.inventory_item_id)) + 1 )))"+
          "                          and not exists (select 1 from QP_MODIFY_NOTE_LINES x where x.Product_Attribute ='PRICING_ATTRIBUTE1' and to_number(nvl(x.Product_Attr_Value,0))=msi.inventory_item_id)"+
          "                         ) xx"+
          "       where  REC_SEQ=1) qm"+ 
          "       ,(SELECT TSC_PART_NO,listagg(PCN_NUMBER,',') within group(order by PCN_NUMBER) pcn_list"+
          "         FROM (SELECT TSC_PART_NO,PCN_NUMBER FROM oraddman.tsqra_pcn_item_detail a "+
          "         WHERE SOURCE_TYPE=1"+
          "         GROUP BY TSC_PART_NO,PCN_NUMBER) X "+
          "         group by TSC_PART_NO) pcn"+
		  "        ,(SELECT distinct y.INVENTORY_ITEM_ID,y.ORGANIZATION_ID, x.SEGMENT1,x.CREATION_DATE"+
          "         FROM inv.mtl_categories_b x,inv.mtl_item_categories y "+
          "         WHERE STRUCTURE_ID=50203"+
          "         and x.CATEGORY_ID=y.CATEGORY_ID"+
          "         and y.CATEGORY_SET_ID=24) pt"+
          "       WHERE msi.ORGANIZATION_ID=49"+
          "       AND LENGTH(msi.SEGMENT1)>=22"+
          "       AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'"+
          "       AND UPPER(msi.DESCRIPTION) NOT LIKE '%DISABLE%'"+
          "       AND msi.attribute3=tm.manufactory_no(+)"+
          "       and msi.description=pcn.TSC_PART_NO(+)"+
		  "       and msi.organization_id=pt.ORGANIZATION_ID(+)"+
          "       and msi.INVENTORY_ITEM_ID=pt.INVENTORY_ITEM_ID(+)"+
          "       AND qm.NOTE_HEADER_ID(+)=case when msi.attribute3 in ('002','010') then 73 else 74 end"+
          "       AND msi.inventory_item_id=qm.inventory_item_id(+)) A "+
          "       , (select xx.* from  (select qml.note_header_id,to_number(nvl(qml.Product_Attr_Value,0)) inventory_item_id,qml.PRODUCT_UOM_CODE , qml.OPERAND,qic.category_name ,qml.last_update_date,ROW_NUMBER() OVER(PARTITION BY qml.NOTE_HEADER_ID,qml.PRODUCT_ATTR_VALUE ORDER BY qml.LAST_UPDATE_DATE DESC,NOTE_LINE_ID DESC) REC_SEQ from QP_MODIFY_NOTE_LINES qml, qp_modify_note_headers qmh,qp_item_categories_v qic where  qml.note_header_id =qmh.note_header_id (+) and qml.Product_Attribute ='PRICING_ATTRIBUTE2' and qml.PRODUCT_ATTR_VALUE=qic.category_id) xx where xx.rec_seq=1) D "+
          "       ,TABLE(TSC_GET_ITEM_SPQ_MOQ(a.inventory_item_id,'TS',NULL)) qq"+
          "       ,TABLE(TSC_GET_ITEM_LEADTIME(a.inventory_item_id,a.attribute3,NULL)) tt"+
          "      where  a.item_desc =d.category_name(+)"+
		  //"      and a.segment1='1030-011X0015406000003'"+
          "      and case when a.attribute3 in ('002','010') then 73 else 74 end = d.note_header_id(+)";
		  //"      order by 3";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "資料日期:" +dateBean.getDate(), LeftBLY));
			row++;

			//ITEM ID
			ws.addCell(new jxl.write.Label(col, row, "Item ID" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//22-Digit-Code
			ws.addCell(new jxl.write.Label(col, row, "22-Digit-Code" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	
			
			//TSC PART NO
			ws.addCell(new jxl.write.Label(col, row, "TSC PART NO" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//PM
			ws.addCell(new jxl.write.Label(col, row, "PM" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//STATUS
			ws.addCell(new jxl.write.Label(col, row, "STATUS" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			
			
			//PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//FAMILY
			ws.addCell(new jxl.write.Label(col, row, "FAMILY" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//PROD FAMILY
			ws.addCell(new jxl.write.Label(col, row, "PROD FAMILY" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//PACKAGE
			ws.addCell(new jxl.write.Label(col, row, "PACKAGE" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//PACKAGE CODE
			ws.addCell(new jxl.write.Label(col, row, "PACKAGE CODE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//SPQ
			ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//MOQ
			ws.addCell(new jxl.write.Label(col, row, "MOQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//SAMPLE SPQ
			ws.addCell(new jxl.write.Label(col, row, "SAMPLE SPQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//Lead Time(Week)
			ws.addCell(new jxl.write.Label(col, row, "Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Lead Time UOM
			ws.addCell(new jxl.write.Label(col, row, "Lead Time UOM" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//No Wafer Lead Time(Week)
			ws.addCell(new jxl.write.Label(col, row, "No Wafer Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//PRICE
			ws.addCell(new jxl.write.Label(col, row, "PRICE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			//UOM
			ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//PRICE last update date
			ws.addCell(new jxl.write.Label(col, row, "PRICE LAST UPDATE DATE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			//Factory
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//Part Name
			ws.addCell(new jxl.write.Label(col, row, "Part Name" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			
			//Series AECQ
			ws.addCell(new jxl.write.Label(col, row, "Series AECQ" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Description
			ws.addCell(new jxl.write.Label(col, row, "Description" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//website status
			ws.addCell(new jxl.write.Label(col, row, "Website Status" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Obsolete timestamp
			ws.addCell(new jxl.write.Label(col, row, "Obsolete Timestamp" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Carton Size
			ws.addCell(new jxl.write.Label(col, row, "Carton Size" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	

			//Carton Weight
			ws.addCell(new jxl.write.Label(col, row, "Carton Weight" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//PCN/PDN
			ws.addCell(new jxl.write.Label(col, row, "PCN/PDN" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Product Group 8
			ws.addCell(new jxl.write.Label(col, row, "Product Group 8" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
				
			//Part Name create Date
			ws.addCell(new jxl.write.Label(col, row, "Part Name create Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		
				
			row++;

		}
		col=0;

		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVENTORY_ITEM_ID"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PM"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("STATUS"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE_CODE") , ALeftL));
		col++;	
		if (rs.getString("SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("MOQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("MOQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("SAMPLE_SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SAMPLE_SPQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("LEAD_TIME")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LEAD_TIME")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("NO_WAFER_LEAD_TIME")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("NO_WAFER_LEAD_TIME")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "Week" , ACenterL));
		col++;	
		if (rs.getString("PRICE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PRICE")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("price_last_update_date") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("factory_code") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	

		sql2 = " select p.name , description, s.name as status,ifnull(f.numeric_value,0)  aecq ,concat(left(pd.status_change_date,10)) as status_change_date"+ 
               " from tsc.products as p "+
               " left join tsc.product_statuses as s "+
               " on p.product_status_id=s.id "+
               " left join ( select sppv.product_id, sppv.numeric_value ,sppf.name aecq_name "+
               "             from tsc.product_parameter_values sppv "+
               "             inner join "+
               "             (select * from tsc.product_parameter_fields where slug in ('aec-q')) as sppf "+
               "             on sppf.id = sppv.product_parameter_field_id) f"+
               "  on p.id = f.product_id  "+
			   " left join ( select product_id,max(t.status_change_date) status_change_date from "+
               "             (select * from tsc.product_status_details order by id desc )  as t"+
               "             group by product_id) as pd "+
               "  on p.id=pd.product_id "+
			   " where p.name  ='"+rs.getString("ITEM_DESC")+"'"+
               " order by p.name asc";
		//out.println(sql2);		   
		Statement st = conn.createStatement();
		ResultSet rss = st.executeQuery(sql2);		
		strAECQ="";strDesc="";strwebstatus="";obsoletedate="";
		if (rss.next())
		{
			strAECQ=(rss.getInt("aecq")>0?"Y":"N");
			strDesc= rss.getString("description");
			strwebstatus=rss.getString("status");
			obsoletedate=rss.getString("status_change_date");
		}
		rss.close();
		st.close();
		
		ws.addCell(new jxl.write.Label(col, row, strAECQ, ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, strDesc , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, strwebstatus , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, obsoletedate , ACenterL));
		col++;	
		
		
		sql3 = " SELECT CartonSize_mm,GrossWeight_kg_Carton FROM tsc.packing_information a"+
		       " where upper(PackageType)='"+rs.getString("TSC_PACKAGE").trim().toUpperCase()+"'"+
			   " and upper(PackingCode)='"+rs.getString("PACKAGE_CODE").trim().toUpperCase().substring(0,2)+"'";
		//out.println(sql3);
		Statement st1 = conn.createStatement();
		ResultSet rs1 = st1.executeQuery(sql3);		
		strCartonSize="";strGW="";
		if (rs1.next())
		{
			strCartonSize=rs1.getString("CartonSize_mm");
			strGW=rs1.getString("GrossWeight_kg_Carton");
		}
		rs1.close();
		st1.close();
		
		ws.addCell(new jxl.write.Label(col, row, strCartonSize, ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, strGW , ARightL));
		col++;	
			   
		ws.addCell(new jxl.write.Label(col, row, rs.getString("pcn_list") , ALeftL));
		col++;	
		
		if (rs.getString("TSC_PROD_GROUP").toUpperCase().startsWith("PRD"))
		{
			if (rs.getString("TSC_FAMILY").toUpperCase().startsWith("TVS GPP") ||rs.getString("TSC_FAMILY").toUpperCase().equals("ZENER"))
			{
				strgroup="TVS";
			}
			else if (rs.getString("TSC_FAMILY").toUpperCase().startsWith("TRENCH SKY"))
			{
				strgroup="TRENCH SCHOTTKY";
			}
			else
			{
				strgroup="PRD";
			}
		}
		else if (rs.getString("TSC_PROD_GROUP").toUpperCase().startsWith("PMD"))
		{
			if (rs.getString("TSC_PROD_CATEGORY").toUpperCase().equals("LIGHTING IC"))
			{
				strgroup=rs.getString("TSC_PROD_CATEGORY").toUpperCase();
			}
			else if (rs.getString("TSC_PROD_CATEGORY").toUpperCase().startsWith("MOSFET"))
			{
				if (rs.getString("TSC_FAMILY").toUpperCase().equals("SUPER JUNCTION"))
				{
					strgroup=rs.getString("TSC_FAMILY");
				}
				else
				{
					strgroup="MOSFET";
				}
			}
			else
			{
				strgroup=rs.getString("TSC_PROD_GROUP");
			}
		}
		else if (rs.getString("TSC_PROD_GROUP").startsWith("SSD"))
		{
			strgroup=rs.getString("TSC_PROD_GROUP");
		}
		ws.addCell(new jxl.write.Label(col, row, strgroup , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PARTS_RELEASE_DATE") , ACenterL));
		col++;	
		
		row++;
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();
	conn.close();

	if (RTYPE.equals("AUTO") && reccnt>0)
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		String remarks="";
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&  request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TS Item Price Report - "+dateBean.getYearMonthDay()+remarks);
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
	os.close();  
	out.close(); 
	
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()+" cnt:"+reccnt); 
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
	if (!RTYPE.equals("AUTO"))
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
