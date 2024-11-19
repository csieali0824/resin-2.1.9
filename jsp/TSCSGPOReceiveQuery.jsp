<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
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
function DateValueOf(datevalue)
{
	if (datevalue.length >8)
	{
		document.MYFORM.YEARFR.value = datevalue.substr(0,4);
		document.MYFORM.MONTHFR.value = datevalue.substr(4,2);
		document.MYFORM.DAYFR.value = datevalue.substr(6,2);
		document.MYFORM.YEARTO.value = datevalue.substr(9,4);
		document.MYFORM.MONTHTO.value = datevalue.substr(13,2);
		document.MYFORM.DAYTO.value = datevalue.substr(15,2);	
		document.MYFORM.STOCK.value = "1";
	}
	else if (datevalue.length ==8)
	{
		document.MYFORM.YEARFR.value = "--";
		document.MYFORM.MONTHFR.value = "--";
		document.MYFORM.DAYFR.value = "--";
		document.MYFORM.YEARTO.value = datevalue.substr(0,4);
		document.MYFORM.MONTHTO.value = datevalue.substr(4,2);
		document.MYFORM.DAYTO.value = datevalue.substr(6,2);	
		document.MYFORM.STOCK.value = "1";
	}
	else
	{
		document.MYFORM.YEARFR.value = "--";
		document.MYFORM.MONTHFR.value = "--";
		document.MYFORM.DAYFR.value = "--";
		document.MYFORM.YEARTO.value = "--";
		document.MYFORM.MONTHTO.value = "--";
		document.MYFORM.DAYTO.value = "--";	
		document.MYFORM.STOCK.value = "--";
	}
}
function setChange()
{
	document.MYFORM.YEARFR.value = "--";
	document.MYFORM.MONTHFR.value = "--";
	document.MYFORM.DAYFR.value = "--";
	document.MYFORM.YEARTO.value = "--";
	document.MYFORM.MONTHTO.value = "--";
	document.MYFORM.DAYTO.value = "--";	
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
<title>SG PO Receive Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr=dateBean.getYearString();
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr=dateBean.getMonthString();
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr=dateBean.getDayString();;
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
String ORGCODE= request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String VENDOR_NAME = request.getParameter("VENDOR_NAME");
if (VENDOR_NAME==null) VENDOR_NAME="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String DATE_CODE = request.getParameter("DATE_CODE");
if (DATE_CODE==null) DATE_CODE="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String RECEIPT_NUM=request.getParameter("RECEIPT_NUM");
if (RECEIPT_NUM==null) RECEIPT_NUM="";
String sql ="",stock_color="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGPOReceiveQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG PO Receive Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">內外銷:</td>   
		<td width="8%">
		<%		
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>			
		<!--<select NAME="ORGCODE" style="width:68;font-family: Tahoma,Georgia; font-size:11px">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG2</OPTION>
		</select>-->
		</td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Receive Date :</td>   
		<td width="36%" colspan="3">
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2020+1];
		for (int i = 2020; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
		if (YearFr==null)
		{
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(YearFr);
		}
		arrayComboBoxBean.setFieldName("YEARFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
		  
	String CurrMonth = null;	     		 
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
	  	if (MonthFr==null)
	  	{
			CurrMonth=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonth);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthFr);
	  	}
		arrayComboBoxBean.setFieldName("MONTHFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception2:"+e.getMessage());
    }

	String CurrDay = null;	     		 
	try
	{       
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(c);
		if (DayFr==null)
		{
			CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(DayFr);
		}
		arrayComboBoxBean.setFieldName("DAYFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}	
%>
		~</strong></font>
<%
	String CurrYearTo = null;	     		 
	try
    {  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2020+1];
		for (int i = 2020; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
	  	if (YearTo==null)
	  	{
			CurrYearTo=dateBean.getYearString();
			arrayComboBoxBean.setSelection(CurrYearTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(YearTo);
	  	}
		arrayComboBoxBean.setFieldName("YEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
	}
    catch (Exception e)
    {
    	out.println("Exception4:"+e.getMessage());
    }
	
	String CurrMonthTo = null;	     		 
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
	  	if (MonthTo==null)
	  	{
			CurrMonthTo=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonthTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthTo);
	  	}
		arrayComboBoxBean.setFieldName("MONTHTO");	   
		out.println(arrayComboBoxBean.getArrayString());		    
	}
	catch (Exception e)
	{
		out.println("Exception5:"+e.getMessage());
	}
	
	String CurrDayTo = null;	     		 
	try
    {     
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(c);
		if (DayTo==null)
		{
			CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(DayTo);
		}
		arrayComboBoxBean.setFieldName("DAYTO");	   
    	out.println(arrayComboBoxBean.getArrayString());	
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>    
		</td>  
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Vendor:</td> 
		<td width="12%" colspan="3">
		<%
		try
		{
			sql = " select distinct vendor_name,vendor_name vendor_name1 from oraddman.tssg_po_receive_detail order by vendor_name";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(12);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(VENDOR_NAME);
			comboBoxBean.setFieldName("VENDOR_NAME");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>
		</td>
	</tr>
	<tr>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Receipt Num :</td>   
		<td><input type="text" name="RECEIPT_NUM" value="<%=RECEIPT_NUM%>" style="font-family: Tahoma,Georgia; font-size: 11px " size="12"></td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family:Tahoma,Georgia">Item Desc :</td>   
		<td><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia;font-size:11px" size="30" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">LOT Number:</td> 
		<td><input type="text" name="LOT_NUMBER" value="<%=LOT_NUMBER%>" style="font-family: Tahoma,Georgia; font-size:11px" size="12" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Date Code:</td> 
		<td><input type="text" name="DATE_CODE" value="<%=DATE_CODE%>" style="font-family: Tahoma,Georgia; font-size:11px" size="12" onChange="setChange();"></td>
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">PO NO:</td> 
		<td width="12%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia; font-size:11px" size="12" onChange="setChange();"></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGPOReceiveQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family: Tahoma,Georgia" onClick='setExportXLS("../jsp/TSCSGPOReceiveExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.lot_number"+
	      ", a.date_code"+
		  ", a.rcv_qty/1000 rcv_qty"+
          ", a.po_no"+
		  ", nvl(d.vendor_site_code,a.vendor_name) vendor_name"+
		  ", a.item_name"+
		  ", a.item_desc"+
		  ", to_char(a.receive_date,'yyyymmdd') receive_date"+
		  ", case a.inspect_result when 'A' then 'ACCEPT'  when 'W' then 'WAVE' when 'R' then 'REJECT' else '' end inspect_result "+
		  ", a.inspect_reason"+
		  ", a.inspect_remark"+
		  ", to_char(a.creation_date,'yyyymmdd') creation_date"+
		  ", a.created_by"+
		  ", to_char(a.last_update_date,'yyyymmdd') last_updated_date"+
		  ", a.last_updated_by"+
		  ", a.receipt_num"+
		  ", a.organization_id"+
		  ", a.vendor_site_id"+
		  ", a.remarks"+
		  ", a.no_match_fifo_reason"+
		  ", a.status"+
		  ", a.subinventory_code"+
          ", to_char(a.lot_expiration_date,'yyyymmdd') lot_expiration_date"+
		  ", to_char(a.inspection_date,'yyyymmdd') inspection_date"+
		  ", a.inspected_by"+
		  ", b.organization_code"+
		  ", replace(c.note_to_receiver,'.','/') note_to_receiver"+
		  ",a.return_qty"+
		  ",a.return_reason"+
		  ",case  b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
		  ",a.buyer_result"+
          ",a.buyer_reason"+
		  ",a.buyer_remark"+
		  ",a.vendor_carton_no"+ //add by Peggy 20200416
		  ",nvl(a.delivery_type,'') delivery_type"+ //add by Peggy 20200424
		  ",a.dc_yyww"+ //add by Peggy 20220728
		  " from oraddman.tssg_po_receive_detail a"+
  	      ",mtl_parameters b"+
		  ",po.po_line_locations_all c"+
		  ",ap.ap_supplier_sites_all d"+
          " where a.organization_id=b.organization_id"+
		  " and a.po_line_location_id=c.line_location_id(+)"+
		  " and a.vendor_site_id=d.vendor_site_id";
	if (!ORGCODE.equals("") && !ORGCODE.equals("--"))
	{
		sql += " AND a.organization_id = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND a.PO_NO LIKE '"+ PONO+"%'";
	}	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(a.item_name) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(a.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!VENDOR_NAME.equals("") && !VENDOR_NAME.equals("--"))
	{
		sql += " and a.vendor_name ='"+VENDOR_NAME+"'";
	}
	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND a.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}	
	if (!DATE_CODE.equals(""))
	{
		sql += " AND a.date_code = '"+ DATE_CODE+"'";
	}	
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2019":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (!RECEIPT_NUM.equals("") && !RECEIPT_NUM.equals("--"))
	{
		sql += " and a.receipt_num ='"+RECEIPT_NUM+"'";
	}	
	sql += " ORDER BY receive_date DESC, item_name, lot_number DESC";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="1500" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0" style="font-size:10px"> 
				<td width="50" style="color:#006666" align="center">內外銷</td>
				<td width="50" style="color:#006666" align="center">廠商直出</td>
				<td width="80" style="color:#006666" align="center">Vendor</td>
				<td width="50" style="color:#006666" align="center">Rcv Date</td>
				<td width="70" style="color:#006666" align="center">Receipt Num</td>
				<td width="70" style="color:#006666" align="center">PO NO</td>
				<td width="85" style="color:#006666" align="center">MO#</td>
				<td width="125" style="color:#006666" align="center">Item Name</td>
				<td width="100" style="color:#006666" align="center">Item Desc</td>            
				<td width="90" style="color:#006666" align="center">LOT</td>            
				<td width="35" style="color:#006666" align="center">Date Code</td>            
				<td width="30" style="color:#006666" align="center">DC YYWW</td>            
				<td width="35" style="color:#006666" align="center">Carton No</td>            
				<td width="40" style="color:#006666" align="center">Qty(K)</td>            
				<td width="55" style="color:#006666" align="center">Lot Expiration Date</td>            
				<td width="50" style="color:#006666" align="center">QC Result</td>            
				<td width="65" style="color:#006666" align="center">QC Rej Reason</td>            
				<td width="65" style="color:#006666" align="center">QC Remarks</td>            
				<td width="25" style="color:#006666" align="center">Subinv Code</td>            
				<td width="50" style="color:#006666" align="center">No FIFO Reason</td>
				<td width="50" style="color:#006666" align="center">Return Qty</td>
				<td width="50" style="color:#006666" align="center">Return Reason</td>
				<td width="50" style="color:#006666" align="center">Status</td>
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB"  style="font-size:10px" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center"><%=rs.getString("ORGANIZATION_NAME")%></td>
			<td align="center"><%=(rs.getString("delivery_type")==null?"&nbsp;":rs.getString("delivery_type"))%></td>
			<td><%=rs.getString("VENDOR_NAME")%></td>
			<td align="center"><%=rs.getString("RECEIVE_DATE")%></td>
			<td align="center"><%=rs.getString("RECEIPT_NUM")%></td>
			<td align="center"><%=rs.getString("PO_NO")%></td>
			<td align="center"><%=(rs.getString("note_to_receiver")==null?"&nbsp;":rs.getString("note_to_receiver"))%></td>
			<td><%=rs.getString("ITEM_NAME")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td><%=rs.getString("LOT_NUMBER")%></td>
			<td align="center"><%=rs.getString("DATE_CODE")%></td>
			<td align="center"><%=(rs.getString("DC_YYWW")==null?"&nbsp;":rs.getString("DC_YYWW"))%></td>
			<td align="center"><%=(rs.getString("VENDOR_CARTON_NO")==null?"&nbsp;":rs.getString("VENDOR_CARTON_NO"))%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RCV_QTY")))%></td>
			<td align="center"><%=rs.getString("lot_expiration_date")%></td>
			<td align="center"><%=(rs.getString("INSPECT_RESULT")==null?"&nbsp;":rs.getString("INSPECT_RESULT"))%></td>
			<td><%=(rs.getString("INSPECT_REASON")==null?"&nbsp;":rs.getString("INSPECT_REASON"))%></td>
			<td><%=(rs.getString("INSPECT_REMARK")==null?"&nbsp;":rs.getString("INSPECT_REMARK"))%></td>
			<td align="center"><%=(rs.getString("SUBINVENTORY_CODE")==null?"&nbsp;":rs.getString("SUBINVENTORY_CODE"))%></td>
			<td><%=(rs.getString("NO_MATCH_FIFO_REASON")==null?"&nbsp;":rs.getString("NO_MATCH_FIFO_REASON"))%></td>
			<td><%=(rs.getString("RETURN_QTY")==null?"&nbsp;":rs.getString("RETURN_QTY"))%></td>
			<td><%=(rs.getString("RETURN_REASON")==null?"&nbsp;":rs.getString("RETURN_REASON"))%></td>
			<td align="center"><%=rs.getString("STATUS")%></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
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

