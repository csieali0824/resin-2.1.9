<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	if (document.MYFORM.DTYPE.value==null|| document.MYFORM.DTYPE.value=="")
	{
		alert("Please choose stock type");
		document.MYFORM.DTYPE.foucs();
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>TSCC EDI INV Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String DTYPE_LIST []= new String[]{"Stock Report","Stock Movement(Reception)","Stock Movement(Consumption)"};
String DTYPE=request.getParameter("DTYPE");
if (DTYPE==null || DTYPE.equals("--")) DTYPE=DTYPE_LIST[0];
String SYEAR=request.getParameter("SYEAR");
if (SYEAR==null || SYEAR.equals("--")) SYEAR="";
String SMON=request.getParameter("SMON");
if (SMON==null || SMON.equals("--")) SMON="";
String ERPCUSTOMER=request.getParameter("ERPCUSTOMER");
if(ERPCUSTOMER==null || ERPCUSTOMER.equals("--")) ERPCUSTOMER="";
String CUSTPARTNO =request.getParameter("CUSTPARTNO");
if(CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if(TSCPARTNO==null) TSCPARTNO="";
String sql ="",stock_color="",FileName="",strPath="";
File strFile =null;

%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCCEDIINVRPTQeury.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TSCC INVRPT EDI Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Stock Type:</td> 
		<td width="10%">
		<%
			try
			{       
				arrayComboBoxBean.setArrayString(DTYPE_LIST );
				if (!DTYPE.equals(""))
				{
					arrayComboBoxBean.setSelection(DTYPE);
				}
				arrayComboBoxBean.setFieldName("DTYPE");	   
				out.println(arrayComboBoxBean.getArrayString());		      		 
			}
			catch (Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}	
		%>			
	 	</td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">ERP Cust Name:</td> 
		<td width="10%">
		<%
			sql = " SELECT DISTINCT a.ERP_CUST_NUMBER,'('||b.CUSTOMER_NUMBER||')'||b.customer_name customer_name"+
			      " FROM edi.tscc_invrpt_elements a,ar_customers b"+
			  	  " where a.ERP_CUST_NUMBER=b.CUSTOMER_NUMBER"+
				  " order by 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(ERPCUSTOMER);
			comboBoxBean.setFieldName("ERPCUSTOMER");	
			comboBoxBean.setFontName("Tahoma,Georgia");  
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();
		%>
		</td>
		<td width="10%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">TSC Part No:</td>   
		<td width="10%"><textarea cols="20" rows="3" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>  
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Cust Part No:</td> 
		<td width="10%"><textarea cols="20" rows="3" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Doc Issue Date:</td> 
		<td width="10%">Year:
		<%
			sql = " SELECT distinct to_char(DOC_ISSUE_DATE,'yyyy') SYEAR,to_char(DOC_ISSUE_DATE,'yyyy') SYEAR1"+
			      " FROM edi.tscc_invrpt_elements a"+
				  " order by 1";
			statement=con.createStatement();
			rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SYEAR);
			comboBoxBean.setFieldName("SYEAR");	
			comboBoxBean.setFontName("Tahoma,Georgia");  
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();		
		%>
		<BR>Month:
		<%
			try
			{       
				int  j =0; 
				String b[]= new String[12];
				for (int i =1;i <= 12;i++)
				{
					if (i <10)	b[j++] = "0"+i;
					else b[j++] = ""+i;		
				}
				arrayComboBoxBean.setArrayString(b);
				if (SMON!=null)
				{
					arrayComboBoxBean.setSelection(SMON);
				}
				arrayComboBoxBean.setFieldName("SMON");	   
				out.println(arrayComboBoxBean.getArrayString());		      		 
			}
			catch (Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}	
		%>	
		</td>
    </tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCCEDIINVRPTQeury.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSCCEDIINVRPTNotice.jsp")' >
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select row_number() over (partition by e.customer_number,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end,c.cust_part_no,inv_move_reason_name order by a.doc_issue_date,a.doc_header_id) group_seq"+
	      ",count(1) over (partition by e.customer_number,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end,c.cust_part_no,inv_move_reason_name) group_cnt"+
          ",e.customer_number,e.customer_name,a.doc_no,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end doc_name"+
		  ",to_char(a.doc_issue_date,'yyyy/mm/dd') doc_issue_date,b.location_code,c.cust_part_no,c.tsc_part_no"+
		  ",d.doc_header_id, d.line_number, d.inv_move_code,d.inv_move_reason_code, d.inv_move_reason_name, d.stock_move_qty,"+
          " d.stock_move_qty_uom, d.actual_stock_qty, d.actual_stock_qty_uom,d.previous_qty, d.previous_qty_uom, to_char(d.posting_date,'yyyymmdd') posting_date,"+
          " d.previous_report_date, d.delivery_note_number,d.goods_receipt_number, d.aggregation_number, d.orig_delivery_note_number, d.order_document,a.file_name,"+
		  " a.edi_element_values"+
          " from edi.tscc_invrpt_elements a"+
		  ",edi.tscc_invrpt_headers_all b"+
		  ",edi.tscc_invrpt_lines_all c"+
		  ",edi.tscc_invrpt_line_stock_all d"+
		  ",ar_customers e"+
          " where a.doc_header_id=b.doc_header_id"+
          " and b.doc_header_id=c.doc_header_id"+
          " and c.doc_header_id=d.doc_header_id"+
          " and c.line_number=d.line_number"+
          " and a.erp_cust_number=e.customer_number";
	if (DTYPE.equals(DTYPE_LIST[0]))
	{
		sql += " and a.doc_code='35'";
	}
	else if (DTYPE.equals(DTYPE_LIST[1]))
	{
		sql += " and a.doc_code='78' and d.inv_move_reason_name='Reception'";	
	}
	else if (DTYPE.equals(DTYPE_LIST[2]))
	{
		sql += " and a.doc_code='78' and d.inv_move_reason_name='Consumption'";	
	}	
	if (!ERPCUSTOMER.equals(""))
	{
		sql += " and e.customer_number ='"+ERPCUSTOMER+"'";
	}		  
	if (!TSCPARTNO.equals(""))
	{
		String [] strTSCPARTNO = TSCPARTNO.split("\n");
		String TSCPARTNOList = "";
		for (int x = 0 ; x < strTSCPARTNO.length ; x++)
		{
			if (TSCPARTNOList.length() >0) TSCPARTNOList += ",";
			TSCPARTNOList += "'"+strTSCPARTNO[x].trim()+"'";
		}
		sql += " and c.tsc_part_no in ("+TSCPARTNOList+")";
	}	
	if (!CUSTPARTNO.equals(""))
	{
		String [] strCUSTPARTNO = CUSTPARTNO.split("\n");
		String CUSTPARTNOList = "";
		for (int x = 0 ; x < strCUSTPARTNO.length ; x++)
		{
			if (CUSTPARTNOList.length() >0) CUSTPARTNOList += ",";
			CUSTPARTNOList += "'"+strCUSTPARTNO[x].trim()+"'";
		}
		sql += " and c.cust_part_no in ("+CUSTPARTNOList+")";
	}	
	if (!SYEAR.equals(""))
	{
		sql += " and to_char(a.doc_issue_date,'yyyy') ='"+SYEAR+"'";
	}
	if (!SMON.equals(""))
	{
		sql += " and to_char(a.doc_issue_date,'mm') ='"+SMON+"'";
	}
	sql +=  " order by e.customer_number,c.cust_part_no,a.doc_code,d.INV_MOVE_REASON_NAME,a.doc_issue_date,1,a.doc_header_id";		  
	//out.println(sql);
	statement=con.createStatement(); 
	rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
			<% 
			if (rs.getString("DOC_NAME").equals("Stock Report"))
			{
			%>
				<td width="8%" style="color:#006666" align="center">STOCK TYPE</td>
				<td width="18%" style="color:#006666" align="center">ERP CUST NAME</td>
				<td width="11%" style="color:#006666" align="center">CUST PART NO</td>
				<td width="11%" style="color:#006666" align="center">TSC PART NO</td>
				<td width="10%" style="color:#006666" align="center">ISSUE DATE</td>
				<td width="6%" style="color:#006666" align="center">LOCATION</td>
				<td width="6%" style="color:#006666" align="center">ACTUAL STOCK QTY </td>
				<td width="4%" style="color:#006666" align="center">UOM</td>
				<td width="26%" style="color:#006666" align="center">INVRPT File </td>
			<%
			}
			else if (rs.getString("INV_MOVE_REASON_NAME").equals("Reception"))
			{
			%>
				<td width="7%" style="color:#006666" align="center">STOCK TYPE</td>
				<td width="16%" style="color:#006666" align="center">ERP CUST NAME</td>
				<td width="9%" style="color:#006666" align="center">CUST PART NO</td>
				<td width="9%" style="color:#006666" align="center">TSC PART NO</td>
				<td width="6%" style="color:#006666" align="center">ISSUE DATE</td>
				<td width="7%" style="color:#006666" align="center">DATA TYPE</td>
				<td width="4%" style="color:#006666" align="center">QTY </td>
				<td width="3%" style="color:#006666" align="center">UOM</td>
				<td width="4%" style="color:#006666" align="center">ACTUAL STOCK QTY </td>
				<td width="3%" style="color:#006666" align="center">UOM</td>
				<td width="5%" style="color:#006666" align="center">POSTING DATE</td>
				<td width="8%" style="color:#006666" align="center">DELIVERY NOTE NUMBER</td>
				<td width="19%" style="color:#006666" align="center">INVRPT File </td>
			<%
			}
			else if (rs.getString("INV_MOVE_REASON_NAME").equals("Consumption"))
			{
			%>
				<td width="7%" style="color:#006666" align="center">STOCK TYPE</td>
				<td width="16%" style="color:#006666" align="center">ERP CUST NAME</td>
				<td width="6%" style="color:#006666" align="center">CUST PO</td>
				<td width="8%" style="color:#006666" align="center">CUST PART NO</td>
				<td width="8%" style="color:#006666" align="center">TSC PART NO</td>
				<td width="6%" style="color:#006666" align="center">ISSUE DATE</td>
				<td width="7%" style="color:#006666" align="center">DATA TYPE</td>
				<td width="8%" style="color:#006666" align="center">AGGREGATION NUMBER</td>
				<td width="4%" style="color:#006666" align="center">QTY </td>
				<td width="3%" style="color:#006666" align="center">UOM</td>
				<td width="5%" style="color:#006666" align="center">POSTING DATE</td>
				<td width="8%" style="color:#006666" align="center">DELIVERY NOTE NUMBER</td>
				<td width="14%" style="color:#006666" align="center">INVRPT File </td>			
			<%
			}
			%>			
			
			</tr>
		<% 
		}
		FileName=rs.getString("file_name");
	
	 	strPath = "\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName;
	 	strFile = new File(strPath);
	 	boolean fileCreated = strFile.createNewFile();
		 //File appending
		Writer objWriter = new BufferedWriter(new FileWriter(strFile));
	 	objWriter.write((rs.getClob("edi_element_values")).getSubString(1,(int)(rs.getClob("edi_element_values")).length()));
	 	objWriter.flush();		
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
		<% 
		if (rs.getString("DOC_NAME").equals("Stock Report"))
		{
		%>		
			<td><%=rs.getString("DOC_NAME")%></td>
			<td><%="("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME")%></td>
			<td><%=rs.getString("CUST_PART_NO")%></td>
			<td><%=rs.getString("TSC_PART_NO")%></td>
			<td align="center"><%=rs.getString("DOC_ISSUE_DATE")%></td>
			<td align="center"><%=rs.getString("LOCATION_CODE")%></td>
			<td align="right"><%=(rs.getString("ACTUAL_STOCK_QTY")==null?"&nbsp;":rs.getString("ACTUAL_STOCK_QTY"))%></td>
			<td align="center"><%=rs.getString("ACTUAL_STOCK_QTY_UOM")%></td>
			<td><a href="/oradds/report/<%=rs.getString("FILE_NAME")%>" target="_blank"><%=rs.getString("FILE_NAME")%></a></td>
		<%
		}
		else if (rs.getString("INV_MOVE_REASON_NAME").equals("Reception"))
		{
		%>	
			<td><%=rs.getString("DOC_NAME")%></td>
			<td><%="("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME")%></td>
			<td><%=rs.getString("CUST_PART_NO")%></td>
			<td><%=rs.getString("TSC_PART_NO")%></td>
			<td align="center"><%=rs.getString("DOC_ISSUE_DATE")%></td>
			<td><%=rs.getString("INV_MOVE_REASON_NAME")%></td>
			<td align="right"><%=(rs.getString("STOCK_MOVE_QTY")==null?"&nbsp;":rs.getString("STOCK_MOVE_QTY"))%></td>
			<td align="center"><%=rs.getString("STOCK_MOVE_QTY_UOM")%></td>
			<td align="right"><%=(rs.getString("ACTUAL_STOCK_QTY")==null?"&nbsp;":rs.getString("ACTUAL_STOCK_QTY"))%></td>
			<td align="center"><%=rs.getString("ACTUAL_STOCK_QTY_UOM")%></td>
			<td align="center"><%=rs.getString("POSTING_DATE")%></td>
			<td><%=rs.getString("ORIG_DELIVERY_NOTE_NUMBER")%></td>
			<td style="font-size:9px"><a href="/oradds/report/<%=rs.getString("FILE_NAME")%>" target="_blank"><%=rs.getString("FILE_NAME")%></a></td>
		
		<%
		}
		else if (rs.getString("INV_MOVE_REASON_NAME").equals("Consumption"))
		{
		%>		
			<td><%=rs.getString("DOC_NAME")%></td>
			<td><%="("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME")%></td>
			<td><%=rs.getString("ORDER_DOCUMENT")%></td>
			<td><%=rs.getString("CUST_PART_NO")%></td>
			<td><%=rs.getString("TSC_PART_NO")%></td>
			<td><%=rs.getString("DOC_ISSUE_DATE")%></td>
			<td><%=rs.getString("INV_MOVE_REASON_NAME")%></td>
			<td><%=rs.getString("AGGREGATION_NUMBER")%></td>
			<td><%=(rs.getString("STOCK_MOVE_QTY")==null?"&nbsp;":rs.getString("STOCK_MOVE_QTY"))%></td>
			<td><%=rs.getString("STOCK_MOVE_QTY_UOM")%></td>
			<td><%=rs.getString("POSTING_DATE")%></td>
			<td><%=rs.getString("ORIG_DELIVERY_NOTE_NUMBER")%></td>
			<td style="font-size:9px"><a href="/oradds/report/<%=rs.getString("FILE_NAME")%>" target="_blank"><%=rs.getString("FILE_NAME")%></a></td>
		<%
		}
		%>				
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

