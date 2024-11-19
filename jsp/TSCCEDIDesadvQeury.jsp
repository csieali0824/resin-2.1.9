<%@ page language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,"%>
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
function setUpload(URL)
{    
	subWin=window.open(URL,"subwin","width=840,height=550,scrollbars=yes,menubar=no");  
}
function setGetNo(URL)
{    
	subWin=window.open(URL,"subwin","width=30,height=50,scrollbars=yes,menubar=no");  
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
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
<title>TSCC EDI Desadv Query</title>
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
String SDATE1=request.getParameter("SDATE1");
if (SDATE1==null) SDATE1="";
String EDATE1=request.getParameter("EDATE1");
if (EDATE1==null) EDATE1="";
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
String sql ="",stock_color="",FileName="",strPath="";
File strFile =null;
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCCEDIDesadvQeury.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TSCC DESADV EDI Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td rowspan="2" width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">Customer PO :</td>   
		<td rowspan="2" width="8%"><textarea cols="18" rows="4" name="CUSTOMERPO" class="style5"><%=CUSTOMERPO%></textarea></td> 
	    <td rowspan="2" width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">ERP Cust No/Name:</td> 
		<td rowspan="2" width="10%"><textarea cols="18" rows="4" name="ERPCUSTOMER" class="style5"><%=ERPCUSTOMER%></textarea></td>
		<td rowspan="2" width="7%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">TSC Part No:</td>   
		<td rowspan="2" width="10%"><textarea cols="20" rows="4" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>  
	    <td rowspan="2" width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Cust Part No:</td> 
		<td rowspan="2" width="10%"><textarea cols="20" rows="4" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
	    <td width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Despatch Date:</td> 
		<td width="22%"><input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			~<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
    </tr>
	<tr>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Delivery Date:</td> 
		<td ><input type="TEXT" name="SDATE1" value="<%=SDATE1%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE1);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			~<input type="TEXT" name="EDATE1" value="<%=EDATE1%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE1);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
	  <td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCCEDIDesadvQeury.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='ASN Despatch'  style="font-family:ARIAL" onClick='setUpload("../jsp/TSCCEDIDesadvUpload.jsp")' >
			&nbsp;&nbsp;&nbsp;
			<INPUT name="button" TYPE="button"  style="font-family:ARIAL" onClick='setGetNo("../jsp/TSCCEDIDesadvNo.jsp")'  value='Get ASN No' align="middle" >
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.despatch_no"+
	      ",a.despatch_version_no"+
		  ",a.edi_order_type"+
		  ",a.edi_address_code"+
		  ",a.cust_name"+
		  ",a.edi_element_values"+
		  ",a.status_code"+
		  ",a.batch_id"+
		  ",a.file_name"+
		  ",a.cust_po"+
		  ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
		  ",c.customer_number"+
		  ",c.customer_name"+
		  ",d.cust_code"+
		  ",e.cust_name k3_cust_name"+
		  ",f.k3_item_no"+
		  ",f.k3_item_desc"+
		  ",f.cust_part_no"+
		  ",a.created_by"+
		  ",to_char(f.delivery_date,'yyyy-mm-dd') delivery_date"+
		  ",f.qty"+
          " from edi.tscc_desadv_elements a"+
		  //",edi.tscc_edi_customers b"+
		  ",(SELECT * FROM EDI.TSCC_EDI_CUSTOMERS WHERE nvl(INACTIVE_DATE,to_date('20990101','yyyymmdd'))>trunc(sysdate)) b"+ //modify by Peggy 20200827
		  ",ar_customers c"+
		  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') d"+
		  ",oraddman.tscc_k3_cust e"+
		  ",(select  despatch_no, despatch_version_no,cust_po,k3_item_no, k3_item_desc,cust_part_no,sum(QTY) qty,max(DELIVERY_DATE) DELIVERY_DATE from edi.tscc_delivery_details"+
          " group by  despatch_no, despatch_version_no,cust_po,k3_item_no, k3_item_desc,cust_part_no) f"+
          " where a.cust_location_code=b.edi_cust_code"+
          " and b.erp_cust_number=c.customer_number(+)"+
          " and c.customer_number=d.erp_cust_number(+)"+
          " and d.cust_code=e.cust_code(+)"+
		  " and a.despatch_no=f.despatch_no(+)"+
		  " and a.despatch_version_no=f.despatch_version_no(+)"+
		  " and a.cust_po=f.cust_po"; //add by Peggy 20191014
	if (!CUSTOMERPO.equals(""))
	{
		String [] strCUSTOMERPO = CUSTOMERPO.split("\n");
		String CUSTOMERPOList = "";
		for (int x = 0 ; x < strCUSTOMERPO.length ; x++)
		{
			if (CUSTOMERPOList.length() >0) CUSTOMERPOList += ",";
			CUSTOMERPOList += "'"+strCUSTOMERPO[x].trim()+"'";
		}
		sql += " and a.cust_po in ("+CUSTOMERPOList+")";
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
		sql += " and f.k3_item_no in ("+TSCPARTNOList+")";
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
	if (!SDATE1.equals(""))
	{
		sql += " and f.delivery_date >= TO_DATE('"+SDATE1+"','yyyymmdd')";
	}
	if (!EDATE1.equals(""))
	{
		sql += " and f.delivery_date <= TO_DATE('"+EDATE1+"','yyyymmdd')";
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
				<td width="7%" style="color:#006666" align="center">EDI Cust</td>
				<td width="15%" style="color:#006666" align="center">ERP Cust Name</td>
				<td width="12%" style="color:#006666" align="center">Despatch No</td>
				<td width="4%" style="color:#006666" align="center">Despatch Version No</td>
				<td width="8%" style="color:#006666" align="center">Customer PO</td>
				<td width="8%" style="color:#006666" align="center">TSC Part No</td>
				<td width="8%" style="color:#006666" align="center">Cust Part No</td>
				<td width="8%" style="color:#006666" align="center">Delivery Date</td>
				<td width="7%" style="color:#006666" align="center">Qty</td>
				<td width="8%" style="color:#006666" align="center">Despatch Date</td>
				<td width="8%" style="color:#006666" align="center">Created by</td>
				<td width="5%" style="color:#006666" align="center">ASN File</td>
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
			<td><%=rs.getString("CUST_NAME")%></td>
			<td><%=rs.getString("CUSTOMER_NUMBER")+" "+rs.getString("CUSTOMER_NAME")%></td>
			<td><%=rs.getString("DESPATCH_NO")%></td>
			<td><%=rs.getString("DESPATCH_VERSION_NO")%></td>
			<td><%=rs.getString("CUST_PO")%></td>
			<td><%=rs.getString("K3_ITEM_NO")%></td>
			<td><%=rs.getString("CUST_PART_NO")%></td>
			<td align="center"><%=rs.getString("DELIVERY_DATE")%></td>
			<td align="right"><%=rs.getString("QTY")%></td>
			<td align="center"><%=rs.getString("CREATION_DATE")%></td>
			<td align="center"><%=rs.getString("CREATED_BY")%></td>
			<td align="center"><a href="/oradds/report/<%=rs.getString("FILE_NAME")%>" target="_blank"><img src='images/download.png' border='0'></a></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='·s²Ó©úÅé'><strong>No Data Found!</strong></font></div>");
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

