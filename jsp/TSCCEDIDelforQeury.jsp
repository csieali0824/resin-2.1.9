<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
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
<title>TEW PO Receive Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String CUSTOMERPO=request.getParameter("CUSTOMERPO");
if(CUSTOMERPO==null) CUSTOMERPO="";
String K3CUSTOMER=request.getParameter("K3CUSTOMER");
if(K3CUSTOMER==null) K3CUSTOMER="";
String ERPCUSTOMER=request.getParameter("ERPCUSTOMER");
if(ERPCUSTOMER==null) ERPCUSTOMER="";
String CUSTPARTNO =request.getParameter("CUSTPARTNO");
if(CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if(TSCPARTNO==null) TSCPARTNO="";
if (CUSTOMERPO.equals("") &&  K3CUSTOMER.equals("") && ERPCUSTOMER.equals("") && CUSTPARTNO.equals("") && TSCPARTNO.equals("") && SDATE.equals("") && EDATE.equals(""))
{
	SDATE = dateBean.getYearString()+dateBean.getMonthString()+"01";
}
String sql ="",stock_color="",FileName="",strPath="";
File strFile =null;
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCCEDIDelforQeury.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TSCC DELFOR EDI Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">Customer PO :</td>   
		<td width="8%"><textarea cols="18" rows="4" name="CUSTOMERPO" class="style5"><%=CUSTOMERPO%></textarea></td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">K3 Cust No/Name:</td>   
		<td width="10%"><textarea cols="18" rows="4" name="K3CUSTOMER" class="style5"><%=K3CUSTOMER%></textarea></td>  
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">ERP Cust No/Name:</td> 
		<td width="10%"><textarea cols="18" rows="4" name="ERPCUSTOMER" class="style5"><%=ERPCUSTOMER%></textarea></td>
		<td width="6%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">TSC Part No:</td>   
		<td width="10%"><textarea cols="20" rows="4" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>  
	    <td width="6%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Cust Part No:</td> 
		<td width="10%"><textarea cols="20" rows="4" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
	    <td width="6%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Doc Issue Date:</td> 
		<td width="20%">From
		  <input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href="javascript:void(0)" onclick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>		
			<BR>
			To
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href="javascript:void(0)" onclick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>		
		</td>
    </tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCCEDIDelforQeury.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <!--<INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSCCEDIDDelforExcel.jsp")' >-->
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.doc_no"+
	      ",a.doc_version_no"+
		  ",a.edi_order_type"+
		  ",a.edi_address_code"+
		  ",a.cust_name"+
		  ",a.edi_element_values"+
		  ",a.file_name"+
		  ",a.status_code"+
		  ",a.batch_id"+
		  ",a.error_msg"+
		  ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
		  ",c.customer_number"+
		  ",c.customer_name"+
		  ",d.cust_code"+
		  ",e.cust_name k3_cust_name"+
		  ",f.cust_part_no"+
		  ",f.tsc_item_desc"+
          " from edi.tscc_delfor_elements a"+
		  ",edi.tscc_edi_customers b"+
		  ",ar_customers c"+
		  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') d"+
		  ",oraddman.tscc_k3_cust e"+
		  ",(select distinct cust_name, cust_po, cust_po_version_no,cust_part_no,tsc_item_desc from edi.tscc_delfor_lines_all) f"+
          " where a.edi_cust_code=b.edi_cust_code"+
          " and b.erp_cust_number=c.customer_number(+)"+
          " and c.customer_number=d.erp_cust_number(+)"+
          " and d.cust_code=e.cust_code(+)"+
		  " and a.cust_name=f.cust_name(+)"+
		  " and a.doc_no=f.cust_po(+)"+
		  " and a.doc_version_no=f.cust_po_version_no(+)";		  
	if (!CUSTOMERPO.equals(""))
	{
		String [] strCUSTOMERPO = CUSTOMERPO.split("\n");
		String CUSTOMERPOList = "";
		for (int x = 0 ; x < strCUSTOMERPO.length ; x++)
		{
			if (CUSTOMERPOList.length() >0) CUSTOMERPOList += ",";
			CUSTOMERPOList += "'"+strCUSTOMERPO[x].trim()+"'";
		}
		sql += " and a.DOC_NO in ("+CUSTOMERPOList+")";
	}
	if (!K3CUSTOMER.equals(""))
	{
		String [] strK3CUSTOMER = K3CUSTOMER.split("\n");
		String K3CUSTOMERList = "",K3CUSTNAMEList ="";
		for (int x = 0 ; x < strK3CUSTOMER.length ; x++)
		{
			if (K3CUSTOMERList.length() >0) K3CUSTOMERList += ",";
			K3CUSTOMERList += "'"+strK3CUSTOMER[x].trim()+"'";
			K3CUSTNAMEList += " or e.cust_name like '%"+strK3CUSTOMER[x].trim()+"%'";
		}
		sql += " and (d.cust_code in ("+K3CUSTOMERList+") "+K3CUSTNAMEList+")";
	}	
	if (!ERPCUSTOMER.equals(""))
	{
		String [] strERPCUSTOMER =ERPCUSTOMER.split("\n");
		String ERPCUSTOMERList = "",ERPCUSTNAMEList ="";
		for (int x = 0 ; x < strERPCUSTOMER.length ; x++)
		{
			if (ERPCUSTOMERList.length() >0) ERPCUSTOMERList += ",";
			ERPCUSTOMERList += "'"+strERPCUSTOMER[x].trim()+"'";
			ERPCUSTNAMEList += " or c.customer_name like '%"+strERPCUSTOMER[x].trim()+"%'";
		}
		sql += " and (c.customer_number in ("+ERPCUSTOMERList+") "+ERPCUSTNAMEList+")";
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
		sql += " and f.tsc_item_desc in ("+TSCPARTNOList+")";
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
		sql += " and f.cust_part_no in ("+CUSTPARTNOList+")";
	}	
	if (!SDATE.equals(""))
	{
		sql += " and a.creation_date >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		sql += " and a.creation_date <= TO_DATE('"+EDATE+"','yyyymmdd')";
	}	
	sql += " order by a.creation_date desc";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="3%" nowrap>&nbsp;&nbsp;&nbsp;</td> 
				<td width="5%" style="color:#006666" align="center">EDI Code </td>
				<td width="7%" style="color:#006666" align="center">EDI Cust </td>
				<td width="18%" style="color:#006666" align="center">K3 Cust Name</td>
				<td width="18%" style="color:#006666" align="center">ERP Cust Name</td>
				<td width="8%" style="color:#006666" align="center">Cust PO</td>
				<td width="4%" style="color:#006666" align="center">Cust PO version </td>
				<td width="8%" style="color:#006666" align="center">TSC Part No</td>
				<td width="8%" style="color:#006666" align="center">Cust Part No</td>
				<td width="7%" style="color:#006666" align="center">Doc Issue Date</td>
				<td width="14%" style="color:#006666" align="center">DELFOR File </td>
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
			<td><%=iCnt%></td>
			<td><%=rs.getString("EDI_ADDRESS_CODE")%></td>
			<td><%=rs.getString("CUST_NAME")%></td>
			<td><%=rs.getString("CUST_CODE")+" "+rs.getString("K3_CUST_NAME")%></td>
			<td><%=rs.getString("CUSTOMER_NUMBER")+" "+rs.getString("CUSTOMER_NAME")%></td>
			<td><%=rs.getString("DOC_NO")%></td>
			<td><%=rs.getString("DOC_VERSION_NO")%></td>
			<td><%=rs.getString("tsc_item_desc")%></td>
			<td><%=rs.getString("CUST_PART_NO")%></td>
			<td align="center"><%=rs.getString("CREATION_DATE")%></td>
			<td><a href="/oradds/report/<%=rs.getString("FILE_NAME")%>" target="_blank"><%=rs.getString("FILE_NAME")%></a></td>
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
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

