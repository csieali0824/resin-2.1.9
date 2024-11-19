<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCE End Customer List</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCE1214CustomerExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String CURRENCYCODE = request.getParameter("CURRENCYCODE");
if (CURRENCYCODE==null) CURRENCYCODE="";
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSCE_END_CUST_LIST";
	FileName = RPTName+"("+userID+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
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
	SheetSettings sst = ws.getSettings(); 
	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(false);

	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(false);	

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(false);

	//英文內文水平垂直置左-正常-格線-紅字   
	WritableCellFormat ALeftLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLR.setWrap(false);	

	/*sql = " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
				 " a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
				 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end  from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_1) erp_customer_1"+
				 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end  from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_2) erp_customer_2"+
				 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end  from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_3) erp_customer_3"+
				 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end  from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_4) erp_customer_4"+
				 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end  from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_5) erp_customer_5"+
				 " FROM oraddman.TSCE_END_CUSTOMER_LIST a where 1=1";*/
	sql = " select x.* from (SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
          "        a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
          "       ,1 cust_priority ,B.customer_number erp_cust_number ,b.customer_name erp_cust_name ,case when STATUS='I' then 'Inactive' else 'Active' end erp_cust_status"+
          "        FROM oraddman.TSCE_END_CUSTOMER_LIST a,ar_customers b "+
          "        where a.ERP_CUSTOMER_ID_1 IS NOT NULL "+
          "        AND b.customer_id =a.ERP_CUSTOMER_ID_1"+
          "        union all "+
          " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
          "        a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
          "       ,2 cust_priority ,B.customer_number erp_cust_number ,b.customer_name erp_cust_name ,case when STATUS='I' then 'Inactive' else 'Active' end erp_cust_status"+
          "        FROM oraddman.TSCE_END_CUSTOMER_LIST a,ar_customers b "+
          "        where a.ERP_CUSTOMER_ID_2 IS NOT NULL"+
          "        AND b.customer_id =a.ERP_CUSTOMER_ID_2"+
          "        union all "+ 
          " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
          "        a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
          "       ,3 cust_priority ,B.customer_number erp_cust_number ,b.customer_name erp_cust_name ,case when STATUS='I' then 'Inactive' else 'Active' end erp_cust_status"+
          "        FROM oraddman.TSCE_END_CUSTOMER_LIST a,ar_customers b "+
          "        where a.ERP_CUSTOMER_ID_3 IS NOT NULL "+      
          "        AND b.customer_id =a.ERP_CUSTOMER_ID_3"+
          "        union all "+  
          " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
          "        a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
          "       ,4 cust_priority , B.customer_number erp_cust_number ,b.customer_name erp_cust_name ,case when STATUS='I' then 'Inactive' else 'Active' end erp_cust_status"+
          "        FROM oraddman.TSCE_END_CUSTOMER_LIST a,ar_customers b "+
          "        where a.ERP_CUSTOMER_ID_4 IS NOT NULL"+       
          "        AND b.customer_id =a.ERP_CUSTOMER_ID_4"+
          "        union all "+
          " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
          "        a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, decode(a.active_flag,'A','Active','Inactive') ACTIVE_FLAG"+
          "       ,5 cust_priority ,B.customer_number erp_cust_number ,b.customer_name erp_cust_name ,case when STATUS='I' then 'Inactive' else 'Active' end erp_cust_status"+
          "        FROM oraddman.TSCE_END_CUSTOMER_LIST a,ar_customers b "+
          "        where a.ERP_CUSTOMER_ID_5 IS NOT NULL   "+    
          "        AND b.customer_id =a.ERP_CUSTOMER_ID_5) x where 1=1";
	if (!CUSTOMER.equals(""))
	{
		sql += " and (x.CUSTOMER_ID like '"+CUSTOMER+"%' or upper(x.CUSTOMER_NAME) like '%"+CUSTOMER.toUpperCase()+"%')";
	}
	if (!CURRENCYCODE.equals(""))
	{
		sql += " and x.CURRENCY_CODE ='" + CURRENCYCODE+"'";
	}
	sql += "  order by x.customer_id,x.CUST_PRIORITY";				 
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
				ws.setColumnView(col+(i-1),20);	
			}
			row++;
		}
		for (int i =1 ; i <= colcnt ; i++)
		{
			if (i==2)
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
				ws.setColumnView(col+(i-1),30);
			}
			else if (i>=9)
			{
				if (i<=10)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, (rs.getString(i)==null?"":rs.getString(i)) ,(rs.getString(i)!=null && rs.getString(12).indexOf("Inactive")>=0?ACenterLR:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, (rs.getString(i)==null?"":rs.getString(i)) ,(rs.getString(i)!=null && rs.getString(12).indexOf("Inactive")>=0?ALeftLR:ALeftL)));
				}
				ws.setColumnView(col+(i-1),(i==11?50:16));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
				ws.setColumnView(col+(i-1),20);
			}
		}	
		reccnt++;
		row++;
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	state.close();

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
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
