<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
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
<title>TW PO Receive Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String MONO = request.getParameter("MONO");
if (MONO==null) MONO="";
String LOT = request.getParameter("LOT");
if (LOT==null) LOT="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String VENDOR_INVOICE = request.getParameter("VENDOR_INVOICE");
if (VENDOR_INVOICE==null) VENDOR_INVOICE="";
String RECEIPTNUM = request.getParameter("RECEIPTNUM");  
if (RECEIPTNUM==null) RECEIPTNUM="";
String DATECODE = request.getParameter("DATECODE");  
if (DATECODE==null) DATECODE="";
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
String sql ="",stock_color="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWTOTWPOReceiveQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">回T訂單驗收資料查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
<table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
	<tr>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">台半料號或型號:</td>   
		<td><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia; font-size: 12px " size="15" onChange="chgObj(this.form.ITEM.value);"></td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">LOT:</td>   
		<td><input type="text" name="LOT" value="<%=LOT%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.LOT.value);"></td>  		
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Date Code:</td>   
		<td><input type="text" name="DATECODE" value="<%=DATECODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.DATECODE.value);"></td>  		
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">採購單號:</td> 
		<td><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.PONO.value);"></td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">驗收單號:</td>   
		<td><input type="text" name="RECEIPTNUM" value="<%=RECEIPTNUM%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.LOT.value);"></td>  		
	</tr>
	<tr>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商發票號碼:</td> 
		<td><input type="text" name="VENDOR_INVOICE" value="<%=VENDOR_INVOICE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.VENDOR_INVOICE.value);"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">訂單號碼:</td> 
		<td><input type="text" name="MONO" value="<%=MONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.MONO.value);"></td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">驗收日期:</td>   
		<td colspan="5">
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2014+1];
		for (int i = 2014; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2014+1];
		for (int i = 2014; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
	</tr>
</table>
<BR>
<div align="center"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWTOTWPOReceiveQuery.jsp")' > 
&nbsp;&nbsp;<input type="button" value="到貨驗收確認" name="btn1" onClick='setSubmit("../jsp/TEWTOTWPOReceive.jsp")'>
</div>
<hr>
<%
try
{       
	
	int iCnt = 0;
	sql = " select a.invoice_no"+
	      ",a.receipt_num"+
		  ",a.tew_advise_no"+
		  ",a.advise_no"+
		  ",a.advise_header_id"+
		  ",a.advise_line_id"+
		  ",a.carton_no"+
		  ",a.so_no"+
		  ",a.so_line_number"+
		  ",a.so_header_id"+
		  ",a.so_line_id"+
		  ",a.organization_id"+
		  ",a.subinventory"+
		  ",a.inventory_item_id"+
		  ",a.item_no"+
		  ",a.lot"+
		  ",a.date_code"+
		  ",a.qty"+
		  ",a.po_no"+
		  ",a.po_header_id"+
		  ",a.po_line_location_id"+
		  ",b.description"+
          ",c.organization_code"+
          ",e.line_num po_line_num"+
		  ",nvl(a.PROCESS_FLAG,'N') PROCESS_FLAG"+
		  ",a.CREATED_BY"+
		  ",to_char(a.RECEIVE_DATE,'yyyy-mm-dd') RECEIVE_DATE"+
		  " from oraddman.tewpo_receive_tw a"+
          ",inv.mtl_system_items_b b"+
		  ",mtl_parameters c"+
		  ",po_line_locations_all d"+
		  ",po_lines_all e"+
          " where a.inventory_item_id=b.inventory_item_id"+
          " and a.organization_id=b.organization_id"+
          " and a.organization_id=c.organization_id"+
          " and a.po_line_location_id=d.line_location_id"+
          " and d.po_line_id=e.po_line_id";
	if (!PONO.equals(""))
	{
		sql += " AND a.PO_NO = '"+ PONO+"'";
	}	
	if (!MONO.equals(""))
	{
		sql += " AND a.SO_NO = '"+ MONO+"'";
	}	
	if (!LOT.equals(""))
	{
		sql += " AND a.lot ='" + LOT+"'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(b.item_no) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(b.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!VENDOR_INVOICE.equals(""))
	{
		sql += " AND a.INVOICE_NO LIKE '"+VENDOR_INVOICE+"%'";
	}
	if (!RECEIPTNUM.equals(""))  
	{
		sql += " AND a.receipt_num LIKE '"+ RECEIPTNUM +"%'";
	}
	if (!DATECODE.equals(""))  
	{
		sql += " AND a.date_code LIKE '"+ DATECODE +"%'";
	}	
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2010":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	sql += " order by  a.invoice_no";
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
				<td width="6%" style="color:#006666" align="center">供應商發票號</td>
				<td width="8%" style="color:#006666" align="center">驗收單號</td>
				<td width="7%" style="color:#006666" align="center">TEW Advise No</td>
				<td width="7%" style="color:#006666" align="center">MO#</td>
				<td width="5%" style="color:#006666" align="center">MO Line#</td>
				<td width="11%" style="color:#006666" align="center">型號</td>            
				<td width="5%" style="color:#006666" align="center">箱號</td>            
				<td width="7%" style="color:#006666" align="center">LOT</td>            
				<td width="6%" style="color:#006666" align="center">D/C</td>
				<td width="5%" style="color:#006666" align="center">數量(K)</td>            
				<td width="5%" style="color:#006666" align="center">Org Code</td>            
				<td width="5%" style="color:#006666" align="center">入庫倉</td>            
				<td width="7%" style="color:#006666" align="center">採購單號</td>            
				<td width="4%" style="color:#006666" align="center">採購單項次</td>            
				<td width="6%" style="color:#006666" align="center">驗收者</td>            
				<td width="6%" style="color:#006666" align="center">驗收日期</td>            
			</tr>
		<% 
		}
		%>		
		<tr id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center"><%=rs.getString("INVOICE_NO")%></td>
			<td align="center"><%=(rs.getString("RECEIPT_NUM")==null?(rs.getString("PROCESS_FLAG").equals("Y")?"驗收交易正在處理中":"&nbsp;"):rs.getString("RECEIPT_NUM"))%></td>
			<td align="center"><%=rs.getString("TEW_ADVISE_NO")%></td>
			<td align="center"><%=rs.getString("SO_NO")%></td>
			<td><%=rs.getString("SO_LINE_NUMBER")%></td>
			<td><%=rs.getString("description")%></td>
			<td><%=rs.getString("CARTON_NO")%></td>
			<td><%=rs.getString("LOT")%></td>
			<td><%=rs.getString("DATE_CODE")%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("QTY")))%></td>
			<td align="center"><%=rs.getString("ORGANIZATION_CODE")%></td>
			<td align="center"><%=rs.getString("SUBINVENTORY")%></td>
			<td align="center"><%=rs.getString("PO_NO")%></td>
			<td align="center"><%=rs.getString("po_line_num")%></td>
			<td align="center"><%=rs.getString("CREATED_BY")%></td>
			<td align="center"><%=rs.getString("RECEIVE_DATE")%></td>
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

