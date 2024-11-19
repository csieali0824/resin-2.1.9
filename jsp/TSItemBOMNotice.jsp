<!-- 20160809 by Peggy,add tsc_package & tsc_family column-->
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
<FORM ACTION="../jsp/TSItemBOMNotice.jsp" METHOD="post" name="MYFORM">
<%
String sql = "",RPTName ="",FileName = "",remarks="";
int fontsize=8,colcnt=0,row=0,col=0,reccnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd hh:mm");

try 
{ 	
	OutputStream os = null;	
	RPTName = "A01_BOM_LIST";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 	

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
	
	sql = " select distinct b.segment1 bom_item"+
	      ",b.description"+
		  //",tsc_om_category(b.inventory_item_id,b.organization_id,'TSC_Package') TSC_Package"+
		  //",tsc_om_category(b.inventory_item_id,b.organization_id,'TSC_Family') TSC_Family"+
		  ",tsc_inv_category(b.inventory_item_id,b.organization_id,23) TSC_Package"+
		  ",tsc_inv_category(b.inventory_item_id,b.organization_id,21) TSC_Family"+
		  ",d.segment1 component_name"+
		  ",d.description component_desc"+
		  ",c.COMPONENT_QUANTITY"+
		  ",d.PRIMARY_UNIT_OF_MEASURE uom"+
		  ",to_char(a.creation_date,'yyyy/mm/dd hh24:mi') creation_date"+
		  ",to_char(a.last_update_date,'yyyy/mm/dd hh24:mi') last_update_date"+
          " from  bom_bill_of_materials a,inv.mtl_system_items_b b"+
          ",(select * from bom_inventory_components where DISABLE_DATE is null or DISABLE_DATE > trunc(sysdate)) c"+
          ",(select * from inv.mtl_system_items_b where organization_id=?) d"+
          " where a.ORGANIZATION_ID =?"+
          " and a.organization_id=b.organization_id "+
		  " and b.inventory_item_status_code<>'Inactive'"+
          " and a.assembly_item_id=b.inventory_item_id"+
          " and a.bill_sequence_id =c.bill_sequence_id(+)"+
          " and c.component_item_id=d.inventory_item_id(+)"+
          " order by 1";
	//out.println(sql);
	PreparedStatement state = con.prepareStatement(sql);
	state.setInt(1,606);
	state.setInt(2,606);
	ResultSet rs=state.executeQuery();	
	while (rs.next())	
	{
		if (reccnt==0)
		{
			col=0;row=0;
			sst.setVerticalFreeze(row+1);  //凍結窗格
			for (int g =1 ; g <=2 ;g++ )
			{
				sst.setHorizontalFreeze(g);
			}	
			//package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	

			//family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;	

			//Finished Goods
			ws.addCell(new jxl.write.Label(col, row, "Finished Goods" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;						
						
			//Finished Goods desc
			ws.addCell(new jxl.write.Label(col, row, "Finished Goods Desc" , ACenterBL));
			ws.setColumnView(col,35);	
			col++;	

			//Component Name
			ws.addCell(new jxl.write.Label(col, row, "Component Name" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	

			//Component desc
			ws.addCell(new jxl.write.Label(col, row, "Component Desc" , ACenterBL));
			ws.setColumnView(col,40);	
			col++;	

			//Component Qty
			ws.addCell(new jxl.write.Label(col, row, "Component Qty" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			//UOM
			ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
				
			//Creation Date
			ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	

			//Last Update Date
			ws.addCell(new jxl.write.Label(col, row, "Last Update Date" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			row++;
			
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("BOM_ITEM")==null?"":rs.getString("BOM_ITEM")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DESCRIPTION")==null?"":rs.getString("DESCRIPTION")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("COMPONENT_NAME")==null?"":rs.getString("COMPONENT_NAME")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("COMPONENT_DESC")==null?"":rs.getString("COMPONENT_DESC")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("COMPONENT_QUANTITY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("UOM")==null?"":rs.getString("UOM")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) ,DATE_FORMAT));
		col++;
		ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("LAST_UPDATE_DATE")) ,DATE_FORMAT));
		col++;
		row++;
		reccnt++;
		
	}
	wwb.write(); 
	wwb.close();

	rs.close();
	state.close();
		
	if (reccnt >0)
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(這是來自RFQ測試區的信件)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jamie.liu@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setHeader("Subject", MimeUtility.encodeText(("A01 BOM List")+remarks, "UTF-8", null));				
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
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
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
