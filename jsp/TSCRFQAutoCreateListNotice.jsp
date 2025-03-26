<!-- 20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>RFQ Auto Create ERP Order Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCRFQAutoCreateListNotice.jsp" METHOD="post" name="MYFORM">
<%
String FileName="",sql="",remarks="",p_sdate ="",p_edate ="", p_stime="",p_etime="",p_times="";
//String p_tsch_sz = "TSCCSZ020";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
int nowHour=0;
try  
{ 	
	nowHour = dateBean.getHour();
	//nowHour=8;
	
	if (nowHour ==8 || nowHour ==12 || nowHour==16)
	{
		OutputStream os = null;	
		if (nowHour <= 8)
		{
			dateBean.setAdjDate(-1);
			p_sdate = dateBean.getYearMonthDay()+"160100";
			dateBean.setAdjDate(1);
			p_edate = dateBean.getYearMonthDay()+"080059";
			//p_sdate ="20210612"+"160100";
			//p_edate ="20210613"+"080059";
			p_stime = "04:00 P.M.";
			p_etime = "08:00 A.M.";
			p_times = "1";
		}
		else if (nowHour <= 12)
		{
			p_sdate = dateBean.getYearMonthDay()+"080100";
			p_edate = dateBean.getYearMonthDay()+"120059";
			//p_sdate ="20210613"+"080100";
			//p_edate ="20210613"+"120059";
			p_stime = "08:00 A.M.";
			p_etime = "12:00 P.M.";
			p_times = "2";
		}
		else if (nowHour <= 16)
		{
			p_sdate = dateBean.getYearMonthDay()+"120100";
			p_edate = dateBean.getYearMonthDay()+"160059";
			//p_sdate ="20210809"+"120100";
			//p_edate ="20210809"+"160059";
			p_stime = "12:00 P.M.";
			p_etime = "16:00 P.M.";
			p_times = "3";
		}

			
		sql = " select a.SALES_AREA_NO,a.sales_area_name from oraddman.tssales_area a "+
              //" UNION ALL"+
              //" SELECT 'TSCH-SZ' SALES_AREA_NO,'深圳' sales_area_name from dual"+
              " order by 1 ";
		Statement state1=con.createStatement();     
		ResultSet rs1=state1.executeQuery(sql);
		while (rs1.next())	
		{
			reccnt=0;row=0;
			//英文內文水平垂直置中-粗體-格線   
			WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
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
	
			FileName="("+rs1.getString("SALES_AREA_NO")+")"+"ERP_Order_autocreate_list";
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
			WritableWorkbook wwb = Workbook.createWorkbook(os); 
			WritableSheet ws = wwb.createSheet("Sheet1", 0); 
			SheetSettings sst = ws.getSettings(); 
		 
			sql = " select b.tsareano SalesAreaName,"+
                  " c.username \"Created by\","+
                  " '('||b.tscustomerid||')'|| replace(b.customer,',','') as Customer,"+
                  " a.dndocno \"RFQ No\","+
                  " a.line_no \"RFQ LineNo\","+
                  " a.item_segment1 \"Item Name\","+
                  " a.item_description Description,"+
                  //" a.quantity,"+
				  " to_char(a.quantity,'99990.99999') quantity,"+ //modify by Peggy 20140116
				  " a.PRIMARY_UOM UOM,"+
                  " to_char(to_date(a.creation_date,'yyyy-mm-dd hh24:mi:ss'),'yyyy/mm/dd hh24:mi') \"Creation Date\" ,"+
                  " to_char(to_date(a.request_date,'yyyy-mm-dd hh24:mi:ss'),'yyyy/mm/dd hh24:mi') \"Request Date\","+
                  " to_char(to_date(a.ftacpdate,'yyyy-mm-dd hh24:mi:ss'),'yyyy/mm/dd hh24:mi') \"Factory Accept Date\","+
                  " a.assign_manufact ||'('||d.MANUFACTORY_NAME||')' as \"Assign Manufactory\","+
                  " to_char(to_date(a.ship_date,'yyyy-mm-dd hh24:mi:ss'),'yyyy/mm/dd hh24:mi') \"Ship Date\","+
                  " to_char(to_date(a.LAST_UPDATE_DATE,'yyyy-mm-dd hh24:mi:ss'),'yyyy/mm/dd hh24:mi') \" ERP ORDER CREATE DATE\","+
                  " nvl(a.CUST_PO_NUMBER,b.cust_po) \"CUSTOMER PO NUMBER\","+
                  " a.orderno \"ERP Order No\","+
                  " replace(a.REMARK,',','') remarks,"+
				  " a.PC_COMMENT pc_remarks"+
                  " FROM oraddman.tsdelivery_notice_detail a,oraddman.TSDELIVERY_NOTICE b"+
                  ",(select username,webid from (SELECT username, webid ,row_number() over (partition by webid order by username) as row_num FROM oraddman.wsuser) k where row_num=1) c "+
		          ",oraddman.tsprod_manufactory d"+
                  " where a.dndocno=b.dndocno"+
                  " and a.created_by = c.webid"+
				  " and a.assign_manufact=d.MANUFACTORY_NO"+
				  " and b.tsareano = '"+ rs1.getString("SALES_AREA_NO")+"'"+ //modify by Peggy 20171221
                  //" and decode(a.created_by,'"+p_tsch_sz+"','TSCH-SZ',b.tsareano) = '"+ rs1.getString("SALES_AREA_NO")+"'"+
                  //" and not exists (select 1 from dual where '"+rs1.getString("SALES_AREA	_NO")+"'='002' and '"+p_tsch_sz+"'=a.created_by)"+
                  " and nvl(a.autocreate_flag,'N')='Y'"+
                  " and a.orderno is not null and a.orderno <>'N/A'"+
                  " and a.LAST_UPDATE_DATE BETWEEN '"+p_sdate+"' and '"+p_edate+"'"+
                  " order by  b.tsareano,a.dndocno,a.line_no";
			//out.println(sql);
			Statement state=con.createStatement();     
			ResultSet rs=state.executeQuery(sql);
			while (rs.next())	
			{ 
				if (reccnt==0)
				{
					ResultSetMetaData md=rs.getMetaData();
					colcnt =md.getColumnCount();
		
					for (int i=1;i<=colcnt;i++) 
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
						if (i==3)
						{
							ws.setColumnView(col+(i-1),50);	
						}
						else if (i==6 || i==15)
						{
							ws.setColumnView(col+(i-1),25);	
						}
						else if (i==13 || i==16 || i==19)
						{
							ws.setColumnView(col+(i-1),30);	
						}
						else
						{
							ws.setColumnView(col+(i-1),20);	
						}
					}
					row++;
				}
				for (int i =1 ; i <= colcnt ; i++)
				{
					if (i==3)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ALeftL));
						ws.setColumnView(col+(i-1),50);
					}
					else if (i==6)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ALeftL));
						ws.setColumnView(col+(i-1),25);
					}
					else if (i==13 || i==16 || i==19)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ALeftL));
						ws.setColumnView(col+(i-1),30);
					}
					else if (i==15)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ACenterL));
						ws.setColumnView(col+(i-1),25);
					}
					else if (i==5 || i==8)
					{
						if (i==8)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.####")).format(Float.parseFloat(rs.getString(i))) , ARightL));
						}
						else
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ARightL));
						}
						ws.setColumnView(col+(i-1),20);
					}
					else if (i==10 || i==11 || i==12 || i==14 || i==17)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
						ws.setColumnView(col+(i-1),20);
					}
					else 
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
						ws.setColumnView(col+(i-1),20);
					}
				}	
				reccnt++;
				row++;
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
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
				{
					remarks="(此為測試信件，請勿理會)";
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				}
				else
				{
					remarks="";
					if (rs1.getString("SALES_AREA_NO").equals("001"))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
					}
					else if (rs1.getString("SALES_AREA_NO").equals("003"))
					{				
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					}
					else if (rs1.getString("SALES_AREA_NO").equals("002") || rs1.getString("SALES_AREA_NO").equals("012")  || rs1.getString("SALES_AREA_NO").equals("022"))
					{				
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));						
					}
					else if (rs1.getString("SALES_AREA_NO").equals("004"))
					{				
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					}
					else if (rs1.getString("SALES_AREA_NO").equals("005"))
					{				
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian.chou@ts.com.tw"));  //add by Peggy 20190329
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zoe.wu@ts.com.tw")); //add by Peggy 20210224
						
					}
					else if (rs1.getString("SALES_AREA_NO").equals("006"))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kristin.wu@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zoe.wu@ts.com.tw")); //add by Peggy 20210224
						
					}
					else if (rs1.getString("SALES_AREA_NO").equals("008"))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cindy.huang@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
					}
					else if (rs1.getString("SALES_AREA_NO").equals("009"))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisa.chen@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alvin.lin@ts.com.tw")); //add by Peggy 20140902
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anu@tscind.in"));  //add by Peggy 20220426
					}
					else if (rs1.getString("SALES_AREA_NO").equals("020"))
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("JENNY.LIAO@ts.com.tw"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("judy.cho@ts.com.tw")); //add by Peggy 20190329
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rebecca_yeh@ts.com.tw")); //add by Peggy 20210111
					}
					else if (rs1.getString("SALES_AREA_NO").equals("015"))
					{
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sylvia_wang@ts.com.tw"));
						//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lisa@ts.com.tw"));
					}
					//else if (rs1.getString("SALES_AREA_NO").equals("TSCH-SZ"))
					else if (rs1.getString("SALES_AREA_NO").equals("018"))
					{
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
						//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					}
					else if (rs1.getString("SALES_AREA_NO").equals("023"))
					{				
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));						
					}					
					else 
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
					}	
				}
				message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
					
				message.setSubject(p_edate.substring(0,8)+"("+p_times+") ERP Order AutoCreate Notification!"+remarks);
				javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
				javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
				String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>Dear All:<p>"+
				               "附檔為 ?01,從?02由系統自動產生的訂單明細.<p><p>"+
							   "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
      			mbp.setContent(str_d.replace("?01","("+rs1.getString("SALES_AREA_NO")+")"+rs1.getString("sales_area_name")).replace("?02",p_sdate+" "+p_stime+"~"+p_edate+" "+p_etime), "text/html;charset=UTF-8");
     			mp.addBodyPart(mbp);
				mbp = new javax.mail.internet.MimeBodyPart();
				javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
				mbp.setDataHandler(new javax.activation.DataHandler(fds));
				mbp.setFileName(fds.getName());
			
				// create the Multipart and add its parts to it
				mp.addBodyPart(mbp);
				message.setContent(mp);
				Transport.send(message);	
			}
		}
		rs1.close();
		state1.close();
		os.close();  
	}		
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
out.close(); 
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

