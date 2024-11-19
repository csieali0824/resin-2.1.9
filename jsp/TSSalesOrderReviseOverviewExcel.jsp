<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderReviseOverviewExcel.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null||EDATE.equals("")) EDATE=dateBean.getYearMonthDay();
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String FileName="",RPTName="",PLANTNAME="",sql="",sql1="",ERP_USERID="",remarks="",price_show="N";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_sheet1="Overview",v_sheet2="Row data";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");

try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "All sales order revise report";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet(v_sheet1, 0);
	wwb.createSheet(v_sheet2, 1);
	WritableSheet ws = null;

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(false);	
			
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(false);
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(false);

	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(false);
	
	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	
		
	sql = "SELECT erp_user_id from oraddman.wsuser a where USERNAME ='"+UserName+"'";
	Statement st3=con.createStatement();
	ResultSet rs3=st3.executeQuery(sql);
	if (rs3.next())
	{
		ERP_USERID=rs3.getString(1);
	}
	rs3.close();
	st3.close();
	
	sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	
	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sql1="";
		
		if (i==0)
		{
			for (int j=1 ; j<=4 ; j++)
			{
				if (!sql1.equals("")) sql1 += " union all";
				if (j==1 || j==2)
				{
					sql1 += " SELECT a.sales_group as \"業務區\"";
				}
				else
				{
					sql1 += " SELECT 'Total' as \"業務區\" ";
				}
				if (j==1 || j==3)
				{
                	sql1 +=  ",case when NVL(a.so_qty,a.SOURCE_SO_QTY)=0 then 'Cancel'"+
                          "      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) < a.source_ssd then 'Pull in'"+
                          "      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) > a.source_ssd then 'Push Out'"+
                          "      else 'Others' end as revise_remarks";
				}
				else
				{
					sql1 +=  ",'Total' as revise_remarks";
				}
                sql1 += ",ROUND(case when NVL(a.so_qty,a.SOURCE_SO_QTY)<a.SOURCE_SO_QTY then a.SOURCE_SO_QTY-a.so_qty else NVL(a.so_qty,a.SOURCE_SO_QTY) end * nvl(a.source_selling_price,a.selling_price)* (SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(a.CREATION_DATE) AND FROM_CURRENCY=c.transactional_curr_code),0) TWD_AMT"+
                       " from tsc_om_salesorderrevise_req_v a"+
                       ",ont.oe_order_headers_all c"+
                       ",ont.oe_order_lines_all d"+
                       " where a.so_header_id=c.header_id(+)"+
                       " and a.so_line_id=d.line_id(+)"+
                       " and c.org_id in (?,?,?)"+
                       " and case when ? is not null then case when to_char(a.CREATION_DATE,'hh24')>=? then  trunc(a.CREATION_DATE)+? else trunc(a.CREATION_DATE) end else a.CREATION_DATE end BETWEEN TO_DATE(?,'yyyymmdd') and TO_DATE(?,'yyyymmdd')+0.99999";
			}
			sql = " select * from ("+sql1 +") x"+
                  " pivot (SUM(twd_amt) for REVISE_REMARKS in ('Cancel','Pull in','Push Out','Others','Total')) P order by 1";    
		}
		else if (i==1)
		{
			sql = " select a.request_no as \"申請單號\""+
			      ",to_char(a.creation_date,'yyyy/mm/dd') as \"申請日期\""+
                  ",a.sales_group as \"業務區\""+
                  ",cust.account_name as \"客戶\""+
                  ",NVL(NVL( DECODE (pp.party_type,'ORGANIZATION', pp.organization_name_phonetic,NULL), SUBSTRB (pp.party_name, 1, 50)),CASE WHEN a.sales_group IN ('TSCA','TSCR-ROW','TSCI','TSCJ') then d.attribute13 else '' end) as \"終端客戶\""+
                  ",a.so_no as \"訂單號碼\""+
                  ",a.line_no as \"訂單項次\""+
                  ",msi.segment1  as \"22D/30D\""+
                  ",msi.description as \"型號\""+
                  ",d.ordered_item as \"客戶品號\""+
                  ",d.customer_line_number \"客戶PO\""+
                  ",a.SOURCE_SO_QTY as \"原始訂單量\""+
                  ",to_char(a.source_ssd,'yyyy/mm/dd') as \"原始交期\""+
                  ",NVL(a.so_qty,a.SOURCE_SO_QTY) as \"訂單新數量\""+
                  ",to_char(a.schedule_ship_date,'yyyy/mm/dd') as \"訂單新交期\""+      
                  //",nvl(a.source_selling_price,a.selling_price) as \"單價\""+
                  ",case when NVL(a.so_qty,a.SOURCE_SO_QTY)<a.SOURCE_SO_QTY then a.SOURCE_SO_QTY-a.so_qty else NVL(a.so_qty,a.SOURCE_SO_QTY) end * nvl(a.source_selling_price,a.selling_price) as \"原幣金額\""+
                  ",ROUND(case when NVL(a.so_qty,a.SOURCE_SO_QTY)<a.SOURCE_SO_QTY then a.SOURCE_SO_QTY-a.so_qty else NVL(a.so_qty,a.SOURCE_SO_QTY) end  * nvl(a.source_selling_price,a.selling_price)* (SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(a.CREATION_DATE) AND FROM_CURRENCY=c.transactional_curr_code),0) as \"台幣金額\""+
                  ",c.transactional_curr_code as \"幣別\""+
                  ",a.remarks"+              
                  ",a.packing_instructions as \"生管判定\""+
                  ",a.change_reason as \"change reason\""+
                  ",a.change_comments as \"change comments\""+
                  ",a.created_by as \"申請人\""+
                  ",a.status as \"申請狀態\""+
                  ",case when NVL(a.so_qty,a.SOURCE_SO_QTY)=0 then 'Cancel'"+
				  "  when sum(NVL(a.so_qty,a.SOURCE_SO_QTY)) over (partition by temp_id,so_line_id)<a.SOURCE_SO_QTY then 'Cancel'"+
                  "  when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) < a.source_ssd then 'Pull in'"+
                  "  when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) > a.source_ssd then 'Push Out'"+
                  "  else 'Others' end as \"申請類別\""+
                  //",rank() over (partition by d.header_id,d.line_id order by a.request_no desc) odr_revise_seq"+   
         		  ",tsc_order_revise_pkg.GET_REVISE_DESC(a.temp_id,a.seq_id,'ALL') as \"Revise info\""+
                  " from tsc_om_salesorderrevise_req_v a"+
                  ",oraddman.tsprod_manufactory b"+
                  ",ont.oe_order_headers_all c"+
                  ",ont.oe_order_lines_all d"+
                  ",hz_cust_accounts cust"+
                  ",hz_cust_accounts end_cust "+
                  ",hz_cust_accounts cc"+
                  ",hz_parties pp"+
                  ",inv.mtl_system_items_b msi"+
                  " where a.so_header_id=c.header_id(+)"+
                  " and a.so_line_id=d.line_id(+)"+
                  " and c.org_id in (?,?,?)"+
                  " and c.sold_to_org_id = cust.cust_account_id"+
                  " and d.end_customer_id = end_cust.cust_account_id(+)"+
                  " and  a.source_customer_id = cust.cust_account_id"+
                  " and a.plant_code =b.manufactory_no(+)"+    
                  " and d.end_customer_id = cc.cust_account_id(+)"+
                  " and cc.party_id = pp.party_id(+) "+    
                  " and d.inventory_item_id=msi.inventory_item_id"+
                  " and d.ship_from_org_id=msi.organization_id"+          
                  " and case when ? is not null then case when to_char(a.CREATION_DATE,'hh24')>=? then  trunc(a.CREATION_DATE)+? else trunc(a.CREATION_DATE) end else a.CREATION_DATE end BETWEEN TO_DATE(?,'yyyymmdd') and TO_DATE(?,'yyyymmdd')+0.99999"+
                  " order by a.SALES_GROUP,a.SO_NO||'-'||a.LINE_NO ";                     
		}
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setInt(1,41);
		statement.setInt(2,325);
		statement.setInt(3,906);
		statement.setString(4,ACTTYPE);
		statement.setInt(5,17);
		statement.setInt(6,1);							
		statement.setString(7,SDATE);
		statement.setString(8,EDATE);

		if (i==0)
		{		
			statement.setInt(9,41);
			statement.setInt(10,325);
			statement.setInt(11,906);
			statement.setString(12,ACTTYPE);
			statement.setInt(13,17);
			statement.setInt(14,1);					
			statement.setString(15,SDATE);
			statement.setString(16,EDATE);
			statement.setInt(17,41);
			statement.setInt(18,325);
			statement.setInt(19,906);
			statement.setString(20,ACTTYPE);
			statement.setInt(21,17);
			statement.setInt(22,1);							
			statement.setString(23,SDATE);
			statement.setString(24,EDATE);
			statement.setInt(25,41);
			statement.setInt(26,325);
			statement.setInt(27,906);	
			statement.setString(28,ACTTYPE);
			statement.setInt(29,17);
			statement.setInt(30,1);						
			statement.setString(31,SDATE);
			statement.setString(32,EDATE);	
		}				
		ResultSet rs=statement.executeQuery();
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		if (i==0)
		{
			//申請日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "申請日期:" +SDATE+(SDATE.equals(EDATE)?"":"~"+EDATE), LeftBLY));
			row++;
		}			
		for (int icol=1;icol<=colCount;icol++) 
		{
			ws.addCell(new jxl.write.Label(col, row,md.getColumnLabel(icol) , ACenterBL));
			ws.setColumnView(col,15);	
			col++;			
		} 					                     
		row++;

		while (rs.next()) 
		{ 	
			col=0;
			for (int icol=1;icol<=colCount;icol++) 
			{
				if (i==0)
				{			
					if (icol==1)
					{
						ws.addCell(new jxl.write.Label(col, row,rs.getString(icol).trim() , ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString(icol)==null?"0":rs.getString(icol)).doubleValue(), ARightL));
					}
					ws.setColumnView(col,15);	
					col++;	
				}
				else
				{
					if (icol==12 || icol==14 || icol==16 || icol==17)
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString(icol)==null?"0":rs.getString(icol)).doubleValue(), ARightL));
					}
					else
					{
						ws.addCell(new jxl.write.Label(col, row,(rs.getString(icol)==null?"":rs.getString(icol)) , ALeftL));
					}
					ws.setColumnView(col,15);	
					col++;					
				}		
			} 			
			row++;				
			reccnt ++;
		}
		rs.close();
		statement.close();			
		//if (reccnt>0) sheetcnt++;
		sheetcnt++;
	}	
	wwb.write(); 
	wwb.close();

	if (sheetcnt >0)
	{
		if (!ACTTYPE.equals(""))
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amy.liu@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("june.wang@ts.com.tw"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText(SDATE+(!SDATE.equals(EDATE)?"-"+EDATE:"")+"業務改單明細"+remarks, "UTF-8", null));				
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
