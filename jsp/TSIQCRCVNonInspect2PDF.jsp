<%@ page import="javax.swing.*,org.jfree.report.JFreeReport,javax.swing.table.DefaultTableModel,javax.swing.table.TableModel,org.jfree.report.ReportProcessingException"%>
<%@ page import="CodeUtil,DateBean"%>
<%@ page import="org.jfree.report.ext.servletdemo.AbstractPageableReportServletWorker,
                 java.sql.*,java.util.*,java.net.URL,
				  org.jfree.report.ext.servletdemo.DefaultPageableReportServletWorker,                 
                 org.jfree.report.modules.output.pageable.graphics.G2OutputTarget,                 
				 org.jfree.report.ext.servletdemo.StaticTableModelProvider,
				 org.jfree.report.PageHeader,java.awt.Image,java.awt.Toolkit,
                 org.jfree.report.ext.servletdemo.DemoModelProvider,java.awt.Graphics2D,java.awt.Color,
				 java.awt.image.BufferedImage,java.awt.print.PageFormat,com.keypoint.PngEncoder,				 
				 org.jfree.report.util.CloseableTableModel,
				 org.jfree.report.modules.misc.tablemodel.ResultSetTableModelFactory,								 
				 org.jfree.report.modules.parser.base.ReportGenerator,
				 org.jfree.report.modules.output.pageable.pdf.PDFOutputTarget,
				 org.jfree.report.modules.output.pageable.base.PageableReportProcessor,
				 java.io.OutputStream,java.io.BufferedOutputStream,java.io.FileOutputStream,java.io.File,
				 org.jfree.report.modules.output.table.html.HtmlProcessor,
				 org.jfree.report.modules.output.table.html.StreamHtmlFilesystem,
				 org.jfree.report.ext.servletdemo.DefaultTableReportServletWorker,
				 org.jfree.report.ext.servletdemo.AbstractTableReportServletWorker,
				 org.jfree.report.ext.servletdemo.StaticPageableReportServletWorker,
				 org.jfree.report.modules.output.table.xls.ExcelProcessor,
				 org.jfree.report.JFreeReportBoot,
				 org.jfree.report.modules.parser.simple.FontFactory"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>IQC Receipt Non-Inspect Detail Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%
String docNo=request.getParameter("DOCNO");//取得前一頁之支付單文件編號

String sSql="";
int itemCount=1;//每一筆PO之項次

if (docNo==null || docNo.equals("")) docNo = "";

//==below is the report generator=====
URL in = getClass().getResource("/reportDefine/IQCNonInspectReportDefine.xml");
if (in == null)
{
    throw new ServletException("Missing Resource: *.xml");
}
JFreeReportBoot.getInstance().start();
ReportGenerator generator=ReportGenerator.getInstance();
JFreeReport report=generator.parseReport(in);

Statement statement=con.createStatement();
ResultSet rs=null;
PreparedStatement pstmt=null;
		 
try
{     
  if (docNo!=null) 
  {  	
     /*      
	  sSql="select c.VNDNAM,a.PVEND,b.TNAME,a.PSHIP,i.THADVN,a.PORD,a.PLINE,a.PODESC,a.PQORD,(a.PECST*a.PQORD) as PACST,i.THUPI,(a.PECST*a.PQORD)+i.THUPI as pait,i.TCOM,c.VCURR,t.VTMDSC from HPO a,ith i,EST b,AVM c,AVT t "+ 
			" where a.PSHIP=b.TSHIP and a.PVEND=c.VENDOR and a.PORD=i.tref  and a.PLINE=i.THLIN and c.VTERMS=t.VTERM and ( i.TTYPE='U' or  i.TTYPE='U1')";//只取出已收料但尚未請款之資料
	  sSql=sSql+" and TCOM='"+docNo+"'";		
	  sSql=sSql+" ORDER BY PVEND,PSHIP,PORD,PLINE";		
	 */
	  String sql = " select ROWNUM, RT.INTERFACE_TRANSACTION_ID, RT.PO_HEADER_ID, RT.UOM_CODE, RT.VENDOR_ID, NVL(RT.VENDOR_LOT_NUM,'null') as VENDOR_LOT_NUM, RT.CURRENCY_CODE, "+
	                  "        RSH.RECEIPT_NUM, PH.SEGMENT1, RT.PO_LINE_ID, RT.PO_LINE_LOCATION_ID, RT.SHIPMENT_HEADER_ID, RT.SHIPMENT_LINE_ID, RT.ORGANIZATION_ID, "+
	                  "        RT.SOURCE_DOC_QUANTITY, PL.ITEM_DESCRIPTION, RT.QUANTITY, RT.TRANSACTION_TYPE, b.USER_NAME, to_char(RT.TRANSACTION_DATE,'YYYY-MM-DD') as TRANSACTION_DATE, "+
					  "        RSL.QUANTITY_SHIPPED, PV.VENDOR_NAME "+		 
 			          "   from RCV_TRANSACTIONS RT, FND_USER b, PO_HEADERS_ALL PH, PO_LINES_ALL PL, "+
					  "        RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL, PO_VENDORS PV ";
      String where = "  where RT.CREATED_BY = b.USER_ID and PH.VENDOR_ID=PV.VENDOR_ID "+
	                    "    and PH.PO_HEADER_ID = PL.PO_HEADER_ID and RT.PO_HEADER_ID = PH.PO_HEADER_ID  "+
                        "    and RT.PO_HEADER_ID = PH.PO_HEADER_ID and RT.PO_LINE_ID = PL.PO_LINE_ID "+
                        "    and RT.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID "+
					    "    and RT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID "+
					    "    and RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID "+
	                    "    and RT.INTERFACE_TRANSACTION_ID not in ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where LSTATUSID != '013' ) "+
	                    "    and RT.TRANSACTION_TYPE ='RECEIVE' and PH.ORG_ID = 325  "+
					    "    and RT.WIP_ENTITY_ID IS NULL and PL.LINE_TYPE_ID = 1 "+
					    "    and RT.TRANSACTION_DATE+4 < SYSDATE ";
      String orderBy = " order by RT.TRANSACTION_DATE ";
	  sql = sql + where + orderBy;	
	  sSql = sql;
	  rs=statement.executeQuery(sSql);
	  CloseableTableModel result=ResultSetTableModelFactory.getInstance().createTableModel(rs);	  
	
	  report.setData(result); 
	
	 //==========以下為輸出到PDF檔且螢幕顯示=======================================================       
	   AbstractPageableReportServletWorker worker =new DefaultPageableReportServletWorker(null,in,new StaticTableModelProvider(result));  
	  
	   out.clearBuffer(); 
	   response.setHeader("Content-Type", "application/pdf");
	
	   // display the content in the browser window (see RFC2183)
	   response.setHeader("Content-Disposition", "inline; filename=\"first.pdf\"");	  
	   ServletOutputStream ot = response.getOutputStream();  
	   org.jfree.report.modules.output.pageable.pdf.PDFOutputTarget tt = new org.jfree.report.modules.output.pageable.pdf.PDFOutputTarget(ot);
		  tt.setProperty(PDFOutputTarget.TITLE, "Title");
		  tt.setProperty(PDFOutputTarget.AUTHOR, "Author");
		  worker.setOutputTarget(tt);
		  worker.processReport();  
		  tt.open();    
	   response.getOutputStream().flush();
	   out.close();        
	
		rs.close();
		result.close();  	
	} //end of chChoose array if null 	
	statement.close();		
}  catch (Exception ee)  {
  System.out.println(ee);
  %> 
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%
}
%>
</body>
</html>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>