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
<title>TSCC EDI Delforp Query</title>
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
<FORM ACTION="../jsp/TSCCEDIDelforPQeury.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TSCC DELFORP EDI Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
	    <td rowspan="2" width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">K3 Cust No/ERP Cust No/Name:</td> 
		<td rowspan="2" width="10%">
<%
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	try
	{   
		Statement statement=con.createStatement();
		sql = " select a.erp_cust_number,'('||c.cust_code||'/'||a.erp_cust_number||')'||a.edi_address_desc customer_name"+
                     " from edi.tscc_edi_customers a,ar_customers b,oraddman.tscc_k3_cust_link_erp c"+
                     " where a.delforp_folder_name is not null"+
                     " and nvl(a.inactive_date,to_date('20990101','yyyymmdd'))>trunc(sysdate)"+
                     " and a.erp_cust_number=b.customer_number(+)"+
                     " and b.customer_number=c.erp_cust_number(+)"+
					 " order by 2"; 
		ResultSet rs=statement.executeQuery(sql);
		out.println("<select NAME='ERPCUSTOMER' style='font-family:ARIAL'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
			if (s1.equals(ERPCUSTOMER)) 
			{
				out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
			} 
			else 
			{
				out.println("<OPTION VALUE='"+s1+"'>"+s2);
			}        
		} 
		out.println("</select>"); 
		statement.close();		  		  
		rs.close();        	 
	} 
	catch (Exception e) 
	{ 
		out.println("Exception1:"+e.getMessage()); 
	} 		
%>		
		</td>
		<td rowspan="2" width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">Customer PO :</td>   
		<td rowspan="2" width="8%"><textarea cols="18" rows="4" name="CUSTOMERPO" class="style5"><%=CUSTOMERPO%></textarea></td> 
		<td rowspan="2" width="7%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">TSC Part No:</td>   
		<td rowspan="2" width="10%"><textarea cols="20" rows="4" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>  
	    <td rowspan="2" width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Cust Part No:</td> 
		<td rowspan="2" width="10%"><textarea cols="20" rows="4" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
	    <td width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">DelforP Submit Date:</td> 
		<td width="22%"><input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			~<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
    </tr>
	<tr>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Delivery Date:</td> 
		<td ><input type="TEXT" name="SDATE1" value="<%=SDATE1%>"  style="font-family: Tahoma,Georgia;" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE1);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			~<input type="TEXT" name="EDATE1" value="<%=EDATE1%>"  style="font-family: Tahoma,Georgia;" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE1);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
	  <td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCCEDIDelforPQeury.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='Delforp Submit'  style="font-family:ARIAL" onClick='setUpload("../jsp/TSCCEDIDelforPUpload.jsp")' >
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT A.DELFORP_DOC_NO"+
	      ",A.DELFORP_VERSION_NO"+
		  ",A.EDI_ADDRESS_CODE"+
		  ",A.CUST_PO"+
		  ",A.CUST_NAME"+
		  ",D.CUSTOMER_NUMBER"+
		  ",(SELECT distinct edi_address_desc FROM edi.tscc_edi_customers x where x.ERP_CUST_NUMBER=D.CUSTOMER_NUMBER) CUSTOMER_NAME"+
		  ",TO_CHAR(A.CREATION_DATE,'YYYY/MM/DD HH24:MI') CREATION_DATE"+
		  ",A.CREATED_BY"+
		  ",A.EDI_ELEMENT_VALUES"+
		  ",B.CUST_PARTNO_LIST"+
		  ",B.TSC_PARTNO_LIST"+
		  ",B.DELIVERY_DATE_LIST"+
		  ",B.QTY_LIST"+ 
		  ",A.FILE_NAME"+
          " FROM EDI.TSCC_DELFORP_ELEMENTS A"+
          ",(SELECT X.DELFORP_DOC_NO,X.DELFORP_VERSION_NO,X.K3_CUST_NUMBER,LISTAGG(X.CUST_PARTNO,'<br>') WITHIN GROUP(ORDER BY X.DELIVERY_DATE) CUST_PARTNO_LIST"+
          ",LISTAGG(X.TSC_PARTNO,'<br>') WITHIN GROUP(ORDER BY X.DELIVERY_DATE) TSC_PARTNO_LIST"+
          ",LISTAGG(TO_CHAR(X.DELIVERY_DATE,'YYYY/MM/DD'),'<br>') WITHIN GROUP(ORDER BY X.DELIVERY_DATE) DELIVERY_DATE_LIST"+
          ",LISTAGG(X.DELIVERY_QTY,'<br>') WITHIN GROUP(ORDER BY X.DELIVERY_DATE) QTY_LIST"+ 
		  " FROM EDI.TSCC_DELFORP_DELIVERY X "+
		  " WHERE 1=1";
	if (!TSCPARTNO.equals(""))
	{
		String [] strTSCPARTNO = TSCPARTNO.split("\n");
		String TSCPARTNOList = "";
		for (int x = 0 ; x < strTSCPARTNO.length ; x++)
		{
			if (TSCPARTNOList.length() >0) TSCPARTNOList += ",";
			TSCPARTNOList += "'"+strTSCPARTNO[x].trim()+"'";
		}
		sql += " AND X.TSC_PARTNO in ("+TSCPARTNOList+")";
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
		sql += " AND X.CUST_PARTNO IN ("+CUSTPARTNOList+")";
	}	
	if (!SDATE1.equals(""))
	{
		sql += " AND X.DELIVERY_DATE >= TO_DATE('"+SDATE1+"','YYYYMMDD')";
	}
	if (!EDATE1.equals(""))
	{
		sql += " AND X.DELIVERY_DATE <= TO_DATE('"+EDATE1+"','YYYYMMDD')";
	}		  
	sql +=" GROUP BY X.DELFORP_DOC_NO,X.DELFORP_VERSION_NO,X.K3_CUST_NUMBER) B"+
          ",(SELECT * FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP WHERE ACTIVE_FLAG='A') C"+
          ",AR_CUSTOMERS D"+
          " WHERE A.DELFORP_DOC_NO=B.DELFORP_DOC_NO"+
          " AND A.DELFORP_VERSION_NO=B.DELFORP_VERSION_NO"+
          " AND B.K3_CUST_NUMBER=C.CUST_CODE(+)"+
          " AND C.ERP_CUST_NUMBER=D.CUSTOMER_NUMBER(+)";
	if (!CUSTOMERPO.equals(""))
	{
		String [] strCUSTOMERPO = CUSTOMERPO.split("\n");
		String CUSTOMERPOList = "";
		for (int x = 0 ; x < strCUSTOMERPO.length ; x++)
		{
			if (CUSTOMERPOList.length() >0) CUSTOMERPOList += ",";
			CUSTOMERPOList += "'"+strCUSTOMERPO[x].trim()+"'";
		}
		sql += " AND A.CUST_PO in ("+CUSTOMERPOList+")";
	}
	if (!ERPCUSTOMER.equals("") &&!ERPCUSTOMER.equals("--"))
	{
		sql += " and d.CUSTOMER_NUMBER='"+ERPCUSTOMER+"'";
	}	
	
	if (!SDATE.equals(""))
	{
		sql += " AND A.CREATION_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		sql += " AND A.CREATION_DATE <= TO_DATE('"+EDATE+"','yyyymmdd')";
	}	
	sql += " ORDER BY A.DELFORP_DOC_NO DESC";
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
				<td width="12%" style="color:#006666" align="center">Delforp Doc No</td>
				<td width="4%" style="color:#006666" align="center">Delforp Version No</td>
				<td width="8%" style="color:#006666" align="center">Customer PO</td>
				<td width="8%" style="color:#006666" align="center">TSC Part No</td>
				<td width="8%" style="color:#006666" align="center">Cust Part No</td>
				<td width="8%" style="color:#006666" align="center">Delivery Date</td>
				<td width="5%" style="color:#006666" align="center">Qty</td>
				<td width="10%" style="color:#006666" align="center">DelforP Submit Date</td>
				<td width="8%" style="color:#006666" align="center">Created by</td>
				<td width="5%" style="color:#006666" align="center">Delforp File</td>
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
			<td><%=rs.getString("DELFORP_DOC_NO")%></td>
			<td><%=rs.getString("DELFORP_VERSION_NO")%></td>
			<td><%=rs.getString("CUST_PO")%></td>
			<td><%=rs.getString("TSC_PARTNO_LIST")%></td>
			<td><%=rs.getString("CUST_PARTNO_LIST")%></td>
			<td align="center"><%=rs.getString("DELIVERY_DATE_LIST")%></td>
			<td align="right"><%=rs.getString("QTY_LIST")%></td>
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

