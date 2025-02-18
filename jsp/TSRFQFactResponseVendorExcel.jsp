<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
	<title>Download Excel File</title>
	<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSRFQFactResponseVendorExcel.jsp" METHOD="post" name="MYFORM">
	<%
		String serverHostName=request.getServerName();
		String dateSetBegin=request.getParameter("DATESETBEGIN");
		String dateSetEnd=request.getParameter("DATESETEND");
		String CdateSetBegin=request.getParameter("CDATESETBEGIN");
		String CdateSetEnd=request.getParameter("CDATESETEND");
		String prodManufactory=request.getParameter("PRODMANUFACTORY");
		String status=request.getParameter("STATUS");
		String salesAreaNo=request.getParameter("SALESAREANO");
		String NYearFr=request.getParameter("NYEARFR");
		if (NYearFr==null) NYearFr="--";
		String NMonthFr=request.getParameter("NMONTHFR");
		if (NMonthFr==null) NMonthFr="--";
		String NDayFr=request.getParameter("NDAYFR");
		if (NDayFr==null) NDayFr="--";
		String NYearTo=request.getParameter("NYEARTO");
		if (NYearTo==null) NYearTo="--";
		String NMonthTo=request.getParameter("NMONTHTO");
		if (NMonthTo==null) NMonthTo="--";
		String NDayTo=request.getParameter("NDAYTO");
		if (NDayTo==null) NDayTo="--";
//if (dnDocNo==null) dnDocNo = "";
		String FileName="",RPTName="",ColumnName="",sql="",where="";
		int fontsize=9,colcnt=0;
		try
		{

			int row =0,col=0,reccnt=0;
			OutputStream os = null;
			RPTName = "TEW_Outsourcing_RFQ_Rpt";
			FileName = RPTName+"("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
			if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
			{ // For Unix Platform
				os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
			}
			else
			{

				os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
			}
			WritableWorkbook wwb = Workbook.createWorkbook(os);
			WritableSheet ws = wwb.createSheet(RPTName, 0);

			//英文內文水平垂直置中-粗體-格線-底色灰
			WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));
			ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBLB.setBackground(jxl.write.Colour.GRAY_25);
			ACenterBLB.setWrap(true);

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

			sql = " select rq.*"+
					" ,case when rq.TOTW_DAYS>0 and rq.assign_manufact in ('005','008') and  to_char(TO_DATE(rq.FACTORY_SSD,'YYYY/MM/DD'),'D') <>3 then to_char(next_day(TO_DATE(rq.FACTORY_SSD,'YYYY/MM/DD')-case when  to_char(TO_DATE(rq.FACTORY_SSD,'YYYY/MM/DD'),'D')<3 then 7 else 0 end,3),'yyyy/mm/dd') else rq.FACTORY_SSD end FACTORY_NEW_SSD"+  //add by Peggy 20220308
					" from (select to_char(sysdate,'yyyy/mm/dd') today,case when a.tscustomerid=5274 then ar.CUSTOMER_SNAME||'('||nvl(nvl(end_cust.CUSTOMER_SNAME,end_cust.customer_name),b.end_customer)||')' else a.customer end as customer,a.dndocno,b.item_description,b.quantity,b.uom,to_char(to_date(substr(b.request_date,1,8),'yyyymmdd'),'yyyy/mm/dd') ssd"+
					" ,case when a.tscustomerid=269290 then b.remark|| case when length(nvl(b.remark,''))>0 then ',' else '' end ||'走蘇州物流園' else b.remark end as remarks"+
					" ,b.item_segment1 item_name,tsc_inv_category(b.inventory_item_id,43,23) tsc_package,tsc_inv_category(b.inventory_item_id,43,21) tsc_family"+ //add by 20200325
					//",tsc_get_china_to_tw_days(null,NVL(decode(b.orderno,'N/A',null,b.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=a.tsareano and oto.otype_id=nvl(b.ORDER_TYPE_ID,a.ORDER_TYPE_ID))),b.inventory_item_id,b.assign_manufact,a.tscustomerid,null) * CASE WHEN b.direct_ship_to_cust =1  and b.assign_manufact='002' THEN 0 ELSE 1 END as totw_days"+ //add by Peggy 20200325
					",tsc_get_china_to_tw_days(\n" +
					"case when b.assign_manufact in ('011') and b.item_description in (\n" +
					"            'TSM4925DCS RLG','TSM4953DCS RLG','TSM4936DCS RLG','TSM2302CX RFG','TSM2305CX RFG','TSM2306CX RFG','TSM2307CX RFG','TSM2308CX RFG','TSM2312CX RFG',\n" +
					"            'TSM2314CX RFG','TSM2318CX RFG','TSM2323CX RFG','TSM2328CX RFG','TSM9409CS RLG','TSM3443CX6 RFG','TSM3481CX6 RFG','TSM3457CX6 RFG','TSM3911DCX6 RFG')\n" +
					"        then 'T' else (SELECT ALNAME FROM ORADDMAN.TSPROD_MANUFACTORY WHERE MANUFACTORY_NO=b.assign_manufact) end \n" +
					",NVL(decode(b.orderno,'N/A',null,b.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=a.tsareano and oto.otype_id=nvl(b.ORDER_TYPE_ID,a.ORDER_TYPE_ID))),b.inventory_item_id,b.assign_manufact,a.tscustomerid,case when b.SASCODATE<>'N/A' then substr(b.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end,nvl(b.CUST_PO_NUMBER,a.CUST_PO)) * CASE WHEN b.direct_ship_to_cust =1  and b.assign_manufact='002' THEN 0 ELSE 1 END as totw_days"+ //add by Peggy 20200916
					",to_char(to_date(b.creation_date,'yyyymmddhh24miss'),'yyyy/mm/dd hh24:mi') creation_date"+//add by Peggy 20200326
					",to_char(to_date(substr(b.request_date,1,8),'yyyymmdd')-tsc_get_china_to_tw_days(\n" +
					"case when b.assign_manufact in ('011') and b.item_description in (\n" +
					"            'TSM4925DCS RLG','TSM4953DCS RLG','TSM4936DCS RLG','TSM2302CX RFG','TSM2305CX RFG','TSM2306CX RFG','TSM2307CX RFG','TSM2308CX RFG','TSM2312CX RFG',\n" +
					"            'TSM2314CX RFG','TSM2318CX RFG','TSM2323CX RFG','TSM2328CX RFG','TSM9409CS RLG','TSM3443CX6 RFG','TSM3481CX6 RFG','TSM3457CX6 RFG','TSM3911DCX6 RFG')\n" +
					"        then 'T' else (SELECT ALNAME FROM ORADDMAN.TSPROD_MANUFACTORY WHERE MANUFACTORY_NO=b.assign_manufact) end \n" +
					",NVL(decode(b.orderno,'N/A',null,b.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=a.tsareano and oto.otype_id=nvl(b.ORDER_TYPE_ID,a.ORDER_TYPE_ID))),b.inventory_item_id,b.assign_manufact,a.tscustomerid,case when b.SASCODATE<>'N/A' then substr(b.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end,nvl(b.CUST_PO_NUMBER,a.CUST_PO)) * CASE WHEN b.direct_ship_to_cust =1  and b.assign_manufact='002' THEN 0 ELSE 1 END,'yyyy/mm/dd') as factory_ssd"+
					",moq.moq/1000 moq"+ //add by Peggy 20211206
					",nvl(moq.vendor_moq,moq.moq)/1000 vendor_moq"+ //add by Peggy 20211206
					",b.assign_manufact"+ //add by Peggy 20220308
					",b.line_no"+ //add by Peggy 20220308
					" from oraddman.tsdelivery_notice a"+
					",oraddman.tsdelivery_notice_detail b"+
					",oraddman.tsprod_manufactory c"+
					",tsc_customer_all_v end_cust "+
					",tsc_customer_all_v ar"+
					//",(SELECT dndocno,line_no,cdatetime,arranged_date,pc_remark FROM oraddman.tsdelivery_detail_history WHERE oristatusid = '004' AND actionid = '009') d"+
					",(select * from (SELECT dndocno,line_no,cdatetime,arranged_date,pc_remark,row_number() over (partition by dndocno,line_no order by cdatetime desc) rec_rank FROM oraddman.tsdelivery_detail_history WHERE oristatusid = '004' AND actionid = '009') x where rec_rank=1) d"+
					",table(TSC_GET_ITEM_SPQ_MOQ(b.inventory_item_id,'TS',b.assign_manufact)) moq"+ //add by Peggy 20211206
					" where a.dndocno=b.dndocno"+
					" and b.assign_manufact=c.manufactory_no(+)"+
					" and b.dndocno = d.dndocno(+)"+
					" and b.line_no = d.line_no(+)"+
					" and a.tscustomerid=ar.customer_id"+
					" and b.end_customer_id=end_cust.customer_id(+)";
			if (prodManufactory !=null && !prodManufactory.equals("") && !prodManufactory.equals("--"))
			{
				sql += " and b.assign_manufact='"+prodManufactory+"'";
			}
			if (salesAreaNo !=null && !salesAreaNo.equals("") && !salesAreaNo.equals("--"))
			{
				sql += " and a.tsareano='"+salesAreaNo+"'";
			}
			if (status != null && !status.equals("") && !status.equals("--"))
			{
				sql += " and b.lstatusid='"+ status+"'";
			}
			if ((CdateSetBegin!=null && !CdateSetBegin.equals("") && !CdateSetBegin.equals("------")) || (CdateSetEnd!=null && !CdateSetEnd.equals("") && !CdateSetEnd.equals("------")))
			{
				sql += " and substr(b.creation_date,1,8) between nvl('"+CdateSetBegin+"','20100101') and nvl('"+CdateSetEnd+"',to_char(sysdate,'yyyymmdd'))";
			}
			if ((dateSetBegin!=null && !dateSetBegin.equals("") && !dateSetBegin.equals("------")) || (dateSetEnd!=null && !dateSetEnd.equals("") && !dateSetEnd.equals("------")))
			{
				sql += " and substr(d.cdatetime,1,8)  between nvl('"+dateSetBegin+"','20100101') and nvl('"+dateSetEnd+"',to_char(sysdate,'yyyymmdd'))";
			}
			if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
			{
				sql+= " and substr(b.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
			}
			if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
			{
				sql+= " and substr(b.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
			}
			sql += ") rq order by rq.dndocno,rq.line_no";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				if (reccnt==0)
				{
					col=0;row=0;

					if (prodManufactory.equals("005"))
					{
						//詢問日
						ws.addCell(new jxl.write.Label(col, row, "詢問日" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//客戶
						ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
						ws.setColumnView(col,50);
						col++;

						//料號
						ws.addCell(new jxl.write.Label(col, row, "台半料號" , ACenterBLB));
						ws.setColumnView(col,30);
						col++;

						//詢問單號
						ws.addCell(new jxl.write.Label(col, row, "詢問單號" , ACenterBLB));
						ws.setColumnView(col,20);
						col++;

						//品名
						ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
						ws.setColumnView(col,25);
						col++;

						//數量
						ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//單位
						//ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
						//ws.setColumnView(col,8);
						//col++;


						//回T
						ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBLB));
						ws.setColumnView(col,8);
						col++;

						//備註
						ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
						ws.setColumnView(col,30);
						col++;

						//供應商MOQ,ADD BY PEGGY 20211206
						ws.addCell(new jxl.write.Label(col, row, "Vendor MOQ(K)" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//需求日
						ws.addCell(new jxl.write.Label(col, row, "需求日" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//Package
						ws.addCell(new jxl.write.Label(col, row, "Package" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;

						//Family
						ws.addCell(new jxl.write.Label(col, row, "Fmaily" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;

						//業務開單日
						ws.addCell(new jxl.write.Label(col, row, "業務開單日" , ACenterBLB));
						ws.setColumnView(col,16);
						col++;
						row++;
					}
					else
					{
						//詢問日
						ws.addCell(new jxl.write.Label(col, row, "詢問日" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//客戶
						ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
						ws.setColumnView(col,50);
						col++;

						//詢問單號
						ws.addCell(new jxl.write.Label(col, row, "詢問單號" , ACenterBLB));
						ws.setColumnView(col,20);
						col++;

						//品名
						ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
						ws.setColumnView(col,25);
						col++;

						//數量
						ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//單位
						//ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
						//ws.setColumnView(col,8);
						//col++;


						//回T
						ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBLB));
						ws.setColumnView(col,8);
						col++;

						//需求日
						ws.addCell(new jxl.write.Label(col, row, "需求日" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//備註
						ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
						ws.setColumnView(col,30);
						col++;

						//供應商MOQ,ADD BY PEGGY 20211206
						ws.addCell(new jxl.write.Label(col, row, "Vendor MOQ" , ACenterBLB));
						ws.setColumnView(col,12);
						col++;

						//Package
						ws.addCell(new jxl.write.Label(col, row, "Package" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;

						//Family
						ws.addCell(new jxl.write.Label(col, row, "Fmaily" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;

						//業務開單日
						ws.addCell(new jxl.write.Label(col, row, "業務開單日" , ACenterBLB));
						ws.setColumnView(col,16);
						col++;

						//料號
						ws.addCell(new jxl.write.Label(col, row, "台半料號" , ACenterBLB));
						ws.setColumnView(col,35);
						col++;
						row++;
					}
				}

				if (prodManufactory.equals("005"))
				{
					col=0;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("TODAY") , ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER"),  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("item_name") ,  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("DNDOCNO"), ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESCRIPTION") , ALeftL));
					col++;
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue() , ARightL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, (rs.getInt("totw_days")>0?"Y":"") , ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("REMARKS") , ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_MOQ")!=null && !rs.getString("VENDOR_MOQ").equals((rs.getString("MOQ")==null?"0":rs.getString("MOQ")))?rs.getString("VENDOR_MOQ"):"") , ARightL));  //add by Peggy 20211206
					col++;
					//ws.addCell(new jxl.write.Label(col, row, rs.getString("SSD") , ACenterL));
					//ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY_SSD") , ACenterL));
					ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY_NEW_SSD") , ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") ,  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("creation_date") ,  ALeftL));
					col++;
					row++;
				}
				else
				{
					col=0;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("TODAY") , ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER"),  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("DNDOCNO"), ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESCRIPTION") , ALeftL));
					col++;
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue() , ARightL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, (rs.getInt("totw_days")>0?"Y":"") , ACenterL));
					col++;
					//ws.addCell(new jxl.write.Label(col, row, rs.getString("SSD") , ACenterL));
					//ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY_SSD") , ACenterL));
					ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY_NEW_SSD") , ACenterL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")) , ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_MOQ")!=null && !rs.getString("VENDOR_MOQ").equals((rs.getString("MOQ")==null?"0":rs.getString("MOQ")))?rs.getString("VENDOR_MOQ"):"") , ALeftL));  //add by Peggy 20211206
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") ,  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("creation_date") ,  ALeftL));
					col++;
					ws.addCell(new jxl.write.Label(col, row, rs.getString("item_name") ,  ALeftL));
					col++;
					row++;
				}
				reccnt ++;
			}
			wwb.write();

			rs.close();
			statement.close();

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
