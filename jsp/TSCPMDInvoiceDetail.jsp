<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<title>供應商發票明細</title>
</head>
<body>
<%
String INVOICENO = request.getParameter("INVOICENO");
String TRANSTYPE = request.getParameter("TRANSTYPE");
String FILENAME = request.getParameter("FILENAME");
if (FILENAME==null) FILENAME="";
if (TRANSTYPE == null) TRANSTYPE="";
String VENDORNO = "",VENDOR_NAME = "",CURRENCY = "",RATE="",TAX="",INVOICE_AMOUNT="",CREATEDBY="",CREATION_DATE="";
String PO="",ITEM_NAME="",ITEM_DESC="",OTHER_CHARGE="",QTY="",UNITPRICE="",AMOUNT="",TOTAMOUNT="0";
try
{
	String sql = " SELECT  a.vendor_code, a.vendor_site_id, a.vendor_name,"+
                 " a.currency_code, a.tot_amount, a.rate, a.tax, a.invoice_amount,"+
                 " a.created_by, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date "+
                 " FROM oraddman.tspmd_invoice_headers_all a"+
				 " where a.invoice_no ='" + INVOICENO + "'";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		VENDORNO = rs.getString("vendor_code");
		VENDOR_NAME = rs.getString("vendor_name");
		CURRENCY = rs.getString("currency_code");
		RATE = rs.getString("rate");
		TAX= rs.getString("tax");
		INVOICE_AMOUNT = rs.getString("invoice_amount");
		CREATEDBY= rs.getString("created_by");
		CREATION_DATE= rs.getString("creation_date");
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
		alert("資料不存在，請重新確認，謝謝!");
		document.location.href="../jsp/TSCPMDInvoiceSummaryReport.jsp";
		</script>	
	<%
	}
	rs.close();
	statement.close();

	if (TRANSTYPE.equals("UPLOAD"))
	{
		File f1 = new File("D:/resin-2.1.9/webapps/oradds/jsp/upload_exl/F1005_"+FILENAME+".xls");
      	File f2 = new File("D:/resin-2.1.9/webapps/oradds/jsp/PMD_Invoice/"+INVOICENO+".xls");
      	InputStream in = new FileInputStream(f1);
      
      	OutputStream outt = new FileOutputStream(f2);

		byte[] buf = new byte[1024];
		int len;
		while ((len = in.read(buf)) > 0)
		{
			outt.write(buf, 0, len);
		}
		in.close();
		outt.close();
	
		/*
		java.io.File file = new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/upload_exl/F1-005_"+FILENAME+".xls"); 
		if (file.exists()) 
		{	
			boolean b = file.renameTo(new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/PMD_Invoice/"+INVOICENO+".xls"));
		}
		*/
	}
%>
<form name="MYFORM"  METHOD="post" >
<table  align="center" width="75%">
	<tr>
		<td align="center" style="font-weight:bold;font-family:標楷體;font-size:28px;color:#000000">供應商發票明細</td>
	</tr>
	<tr>
		<td align="right">
		<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-family:'標楷體';font-size:16px">回首頁</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<A href="../jsp/TSCPMDInvoiceSummaryReport.jsp" style="font-family:'標楷體';font-size:16px">發票查詢</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<A href="../jsp/TSCPMDInvoiceUpload.jsp" style="font-family:標楷體;font-size:16px;background-color:#E4E4E4">發票明細匯入</A></td>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" align="left" cellpadding="0" cellspacing="0"  bordercolorlight="#ffffff"  bordercolordark="#999999">
				<tr>
					<td height="25" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">供應商:</td>
					<td colspan="5" style="font-family:'arial';font-size:16px;font-weight:bold"><%="("+VENDORNO+")"+VENDOR_NAME%></td> 	
					<td height="25" width="10%" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">發票號碼:</td>
					<td width="18%" align="center" style="font-weight:bold;font-family:'arial';font-size:16px;color:#0000CC"><%=INVOICENO%><input type="hidden" name="INVOICENO" value="<%=INVOICENO%>"></td> 	
				</tr>
				<tr>
					<td width="10%" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">匯率:</td>
					<td width="12%" style="font-family:'aril';font-size:12px"><%=RATE%></td> 	
					<td width="10%" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">稅率:</td>
					<td width="12%" style="font-family:'arial';font-size:12px"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(TAX))%></td> 	
					<td bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">幣別:</td>
					<td style="font-family:'arial';font-size:12px"><%=CURRENCY%></td> 	
					<td width="10%" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">含稅金額:</td>
					<td width="18%" align="center" style="font-weight:bold;font-family:'arial';font-size:16px;color:#0000CC"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(INVOICE_AMOUNT))%></td> 
				</tr>   
				<tr>
					<TD height="21" colspan="8" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">發票明細:</td>
				</tr>
				<tr>
					<td colspan="8">
						<table width="100%" cellspacing="0" bordercolorlight="#ffffff"  bordercolordark="#999999" border="1">
							<tr bgcolor="#AFBDD6">
								<td height="25" width="5%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">項次</td>
								<td width="15%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">採購單號</td>
								<td width="20%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">台半料號</td>
								<td width="16%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">台半品名</td>
								<td width="11%" style="font-family:'arial';font-size:12px;color:#000000">Other Charge</td>
								<td width="11%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">數量</td>
								<td width="11%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">單價</td>
								<td width="11%" align="center" style="font-family:'細明體';font-size:12px;color:#000000">金額</td>
							</tr>
							<% 
							sql = " SELECT  a.line_no, a.po_no, a.other_charge,"+
                                  " a.item_name, a.item_description, a.qty,"+
                                  " a.unit_price, a.amount FROM oraddman.tspmd_invoice_lines_all a"+
								  " where a.invoice_no ='" + INVOICENO + "' order by line_no";
							Statement statementd=con.createStatement();
							ResultSet rsd=statementd.executeQuery(sql);
							int i =0;
							while (rsd.next())				
							{
								PO=rsd.getString("po_no");
								ITEM_NAME=rsd.getString("item_name");
								ITEM_DESC=rsd.getString("item_description");
								OTHER_CHARGE=rsd.getString("other_charge");
								if (OTHER_CHARGE ==null || OTHER_CHARGE.equals("")) OTHER_CHARGE ="&nbsp;";
								QTY=rsd.getString("qty");
								UNITPRICE=rsd.getString("unit_price");
								AMOUNT=rsd.getString("amount");
								i++;
							%>
							<tr>
								<TD align="center" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=i%></td>
								<TD align="center" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=PO%></td>
								<TD align="center" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=ITEM_NAME%></td>
								<TD align="center" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=ITEM_DESC%></td>
								<TD align="center" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=OTHER_CHARGE%></td>
								<TD align="right" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=QTY%></td>
								<TD align="right" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(UNITPRICE))%></TD>
								<TD align="right" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(AMOUNT))%></td>
							</tr>
							<%
								TOTAMOUNT = ""+ (Float.parseFloat(TOTAMOUNT) + Float.parseFloat(AMOUNT));
							}
							rsd.close();
							statementd.close();
							
							if (i >0)
							{
							%>
							<tr>
								<TD colspan="7" align="right" style="font-family:'ARIAL';font-size:12px;color:#000000">Total:</TD>
								<TD align="right" style="font-family:'ARIAL';font-size:12px;color:#000000"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(TOTAMOUNT))%></td>
							</tr>
							<%
							}
							%>
						</table>	  
				  	</TD>
				</TR>
				<tr>
					<TD height="21" colspan="8" bgcolor="#97BFD2" style="font-family:'細明體';font-size:12px;color:#000000">&nbsp;</td>
				</tr>
				<tr>
					<td height="25" width="10%" bgcolor="#97BFD2" style="font-family:'ARIAL';font-size:12px;color:#000000">原始文件</td>
					<td colspan="3">
					<%
					String rootName = "/jsp/PMD_Invoice/";
					String rootPath = application.getRealPath(rootName);
					File fp = new File(rootPath);
					if (fp.exists()) 
					{  
						String[] list = fp.list();
						for(int j=0; j<list.length;j++)
						{
							File inFp = new File(rootPath + fp.separator + list[j]);
							if (inFp.getName().startsWith(INVOICENO))
							{
								out.println("&nbsp;<img src='images/xls.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+ list[j]+"' target='_blank'>"+list[j]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font><br>");
								break;
							}
						}
						if (list.length==0) out.println("&nbsp;<br>&nbsp;");
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
					%>
					</td>
					<td bgcolor="#97BFD2" style="font-family:'ARIAL';font-size:12px;color:#000000">上傳人員</td>
					<td style="font-family:'ARIAL';font-size:12px;color:#000000"><%=CREATEDBY%></td>
					<td bgcolor="#97BFD2" style="font-family:'ARIAL';font-size:12px;color:#000000">上傳日期</td>
					<td style="font-family:'ARIAL';font-size:12px;color:#000000"><%=CREATION_DATE%></td>
				</tr>
			</table>
	  	</td>
	</tr>
</table>
<%
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());	
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
if (TRANSTYPE.equals("UPLOAD"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("上傳成功!!\n\n若要繼續上傳資料，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDInvoiceUpload.jsp";
	}	
	</script>
<%
}

%>

</html>
