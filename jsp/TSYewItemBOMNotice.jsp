<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Email Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSYewItemBOMNotice.jsp" METHOD="post" name="MYFORM">
<%
String sql = "",RPTName ="",FileName = "",remarks="",strPath="";
int fontsize=8,colcnt=0,row=0,col=0,reccnt=0,comp_num=0,sheetcnt=0,max_comp_num=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd hh:mm");
String bom_item ="";

try 
{ 	
	OutputStream os = null;	
	RPTName = "YEW_BOM_LIST";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	strPath ="\\resin-2.1.9\\webapps\\oradds\\YEWBOMData\\"+FileName;
	os = new FileOutputStream(strPath);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	wwb.createSheet("FG", 0);
	wwb.createSheet("SA", 1);	
	WritableSheet ws = null;

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(true);
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色黃
	WritableCellFormat ALeftBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftBLG.setAlignment(jxl.format.Alignment.LEFT);
	ALeftBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftBLG.setBackground(jxl.write.Colour.YELLOW); 
	ALeftBLG.setWrap(true);	
			
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
	
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLP.setBackground(jxl.write.Colour.PINK); 	
	ACenterLP.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLG.setWrap(true);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd HH:MM")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
	
	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
			
		sql = " select a.bill_sequence_id,b.segment1 bom_item"+
			  ",b.item_type"+
			  ",b.description"+
			  ",TSC_INV_Category(b.inventory_item_id,b.organization_id,'23') TSC_Package"+
			  ",d.segment1 component_name"+
			  ",d.description component_desc"+
			  ",c.COMPONENT_QUANTITY"+
			  ",d.PRIMARY_UNIT_OF_MEASURE uom"+
			  ",a.rank_seq"+
			  ",(select max(comp_cnt) from (select x.bill_sequence_id,count(1) comp_cnt "+
			  "                             from bom_inventory_components x "+
			  "                             where exists (select 1 from bom_bill_of_materials y,inv.mtl_system_items_b m "+
			  "                                           where y.bill_sequence_id=x.bill_sequence_id "+
			  "                                           and y.IS_PREFERRED='Y'"+
			  "                                           AND y.ALTERNATE_BOM_DESIGNATOR is null"+
			  "                                           and y.organization_id in (?,?) "+
			  "                                           and y.assembly_item_id=m.inventory_item_id "+
			  "                                           and y.organization_id=m.organization_id "+
			  "                                          and m.item_type in (?)) "+
			  "                             and  (x.DISABLE_DATE is null or x.DISABLE_DATE > trunc(sysdate)) "+
			  "                             group by x.bill_sequence_id) z) max_comp_num"+
			  ",case substr(d.segment1,1,3) when '10-' then  1 when '1B-' then 1 when '11-' then 1 when '15-' then 3 else 6 end as col_seq"+
			  " from  (select a.*,row_number() over (partition by a.assembly_item_id order by a.last_update_date desc) rank_seq from bom_bill_of_materials a where a.ORGANIZATION_ID in (?,?)  and A.IS_PREFERRED='Y' AND A.ALTERNATE_BOM_DESIGNATOR IS NULL) a"+
			  ",inv.mtl_system_items_b b"+
			  ",(select * from bom_inventory_components"+
			  " where DISABLE_DATE is null or DISABLE_DATE > trunc(sysdate)) c"+
			  ",(select * from inv.mtl_system_items_b where organization_id in (?,?)) d"+
			  " where a.ORGANIZATION_ID in (?,?)"+
			  " and a.organization_id=b.organization_id"+ 
			  " and b.inventory_item_status_code<>'Inactive'"+
			  " and a.assembly_item_id=b.inventory_item_id"+
			  " and a.bill_sequence_id =c.bill_sequence_id"+
			  " and c.component_item_id=d.inventory_item_id"+
			  " and a.organization_id=d.organization_id"+
			  " and b.item_type in (?)"+
			  " and a.RANK_SEQ=1"+
			  " and d.inventory_item_status_code<>'Inactive'";
		if (i==1) //sa
		{
			sql += " and b.segment1 not like '1A-%' "+
			       " order by b.segment1,case substr(d.segment1,1,3) when '10-' then  1 when '1B-' then 1 when '11-' then 1 when '15-' then 3 else 6 end,d.segment1";
		}
		else
		{
			sql +=" order by 1";
		}
			  //" and a.BILL_SEQUENCE_ID=2477405";
		//out.println(sql);
		PreparedStatement state = con.prepareStatement(sql);
		state.setInt(1,326);
		state.setInt(2,327);
		state.setString(3,(i==0?"FG":"SA"));
		state.setInt(4,326);
		state.setInt(5,327);
		state.setInt(6,326);
		state.setInt(7,327);
		state.setInt(8,326);
		state.setInt(9,327);
		state.setString(10,(i==0?"FG":"SA"));
		ResultSet rs=state.executeQuery();	
		while (rs.next())	
		{
			if (reccnt==0)
			{
				col=0;row=0;
				sst.setVerticalFreeze(row+1);  //凍結窗格
				sst.setHorizontalFreeze(1);
				sst.setHorizontalFreeze(2);
				sst.setHorizontalFreeze(3);
				
				max_comp_num =rs.getInt("max_comp_num"); 
				//package
				ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;	
	
				//Finished Goods
				ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;						
							
				//Finished Goods desc
				ws.addCell(new jxl.write.Label(col, row, "品名規格" , ACenterBL));
				ws.setColumnView(col,35);	
				col++;	
	
				for (int g =1 ; g <= max_comp_num ;g++ )
				{
					//Component Name
					ws.addCell(new jxl.write.Label(col, row, "料號"+g , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
		
					//Component desc
					ws.addCell(new jxl.write.Label(col, row, "品名"+g , ACenterBL));
					ws.setColumnView(col,40);	
					col++;	
		
					//Component Qty
					ws.addCell(new jxl.write.Label(col, row, "用量"+g , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					//UOM
					ws.addCell(new jxl.write.Label(col, row, "單位"+g , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
				}	
			}
			if (!rs.getString("BOM_ITEM").equals(bom_item))
			{
				if (reccnt!=0) 
				{
					for (int k=1; k<=max_comp_num-comp_num ; k++)
					{
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
					}
				}
				bom_item = rs.getString("BOM_ITEM"); 
				col=0;row++;reccnt++;comp_num=0;
	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("BOM_ITEM")==null?"":rs.getString("BOM_ITEM")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("DESCRIPTION")==null?"":rs.getString("DESCRIPTION")), ALeftL));
				col++;	
			}
			if (rs.getString("item_type").equals("SA"))
			{
				if ((rs.getInt("col_seq")>=6 && col<23) || (rs.getInt("col_seq")==3 && col<11))
				{
					for (int k=((col-3)/4)+1; k<=rs.getInt("col_seq")-1 ; k++)
					{
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						col++;
						comp_num++;	
					}					
				}
			}
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("COMPONENT_NAME")==null?"":rs.getString("COMPONENT_NAME")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("COMPONENT_DESC")==null?"":rs.getString("COMPONENT_DESC")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("COMPONENT_QUANTITY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("UOM")==null?"":rs.getString("UOM")), ACenterL));
			col++;
			comp_num++;	
			
		}
		for (int k=1; k<=max_comp_num-comp_num ; k++)
		{
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			col++;	
		}		
		rs.close();
		state.close();
		sheetcnt++;
	}
	wwb.write(); 
	wwb.close();

	/*if (sheetcnt >0)
	{

		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@mail.ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(這是來自RFQ測試區的信件)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@mail.ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hana@mail.tsyew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy_chen@mail.ts.com.tw"));
			
		message.setHeader("Subject", MimeUtility.encodeText(("YEW BOM List")+remarks, "UTF-8", null));				
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		if (request.getRequestURL().toString().toLowerCase().indexOf("10.0.3.16")>=0)
		{
			mbp.setContent("<a href="+'"'+"file:///\\10.0.3.16\\"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
		}
		else
		{
			mbp.setContent("<a href="+'"'+"file:///\\10.0.1.135\\"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
		}		
		//javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		//mbp.setDataHandler(new javax.activation.DataHandler(fds));
		//mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	}*/
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
	if (sheetcnt >0)
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/YEWBOMData/"+FileName; 
		response.sendRedirect(strURL);
	}
%>
</html>
