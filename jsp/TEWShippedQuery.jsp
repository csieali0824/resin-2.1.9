<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- modify by Peggy 20150703,新增TEW_RCV_PKG.GET_SO_DESTINATION取代JSP 取訂單目的地的code-->
<!-- modify by Peggy 20160322,訂單嘜頭列入customer欄位search條件-->
<!-- modify by Peggy 20160616,新增"回T訂單"查詢條件-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2..-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
		document.MYFORM.EYEARFR.value = datevalue.substr(0,4);
		document.MYFORM.EMONTHFR.value = datevalue.substr(4,2);
		document.MYFORM.EDAYFR.value = datevalue.substr(6,2);
		document.MYFORM.EYEARTO.value = datevalue.substr(9,4);
		document.MYFORM.EMONTHTO.value = datevalue.substr(13,2);
		document.MYFORM.EDAYTO.value = datevalue.substr(15,2);	
	}
	else if (datevalue.length ==8)
	{
		document.MYFORM.EYEARFR.value = "--";
		document.MYFORM.EMONTHFR.value = "--";
		document.MYFORM.EDAYFR.value = "--";
		document.MYFORM.EYEARTO.value = datevalue.substr(0,4);
		document.MYFORM.EMONTHTO.value = datevalue.substr(4,2);
		document.MYFORM.EDAYTO.value = datevalue.substr(6,2);	
	}
	else
	{
		document.MYFORM.YEARFR.value = "--";
		document.MYFORM.MONTHFR.value = "--";
		document.MYFORM.DAYFR.value = "--";
		document.MYFORM.YEARTO.value = "--";
		document.MYFORM.MONTHTO.value = "--";
		document.MYFORM.DAYTO.value = "--";	
		document.MYFORM.EYEARFR.value = "--";
		document.MYFORM.EMONTHFR.value = "--";
		document.MYFORM.EDAYFR.value = "--";
		document.MYFORM.EYEARTO.value = "--";
		document.MYFORM.EMONTHTO.value = "--";
		document.MYFORM.EDAYTO.value = "--";	
	}
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUpdate(URL)
{    
	subWin=window.open(URL,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function chgObj(objvalue)
{
	if (objvalue!="")
	{
		DateValueOf("");
		document.MYFORM.SUPPLIER.value="";
	}
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
<title>TEW Shipped Query</title>
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
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String MONO = request.getParameter("MONO");
if (MONO==null) MONO="";
String LOT = request.getParameter("LOT");
if (LOT==null) LOT="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String VENDOR_INVOICE = request.getParameter("VENDOR_INVOICE");
if (VENDOR_INVOICE==null) VENDOR_INVOICE="";
String TSC_INVOICE = request.getParameter("TSC_INVOICE");
if (TSC_INVOICE==null) TSC_INVOICE="";
String YearFr1=request.getParameter("EYEARFR");
if (YearFr1==null) YearFr1=dateBean.getYearString();
String MonthFr1=request.getParameter("EMONTHFR");
if (MonthFr1==null) MonthFr1=dateBean.getMonthString();
String DayFr1=request.getParameter("EDAYFR");
if (DayFr1==null)
{
	dateBean.setAdjDate(-1);
	YearFr1=dateBean.getYearString();
	MonthFr1=dateBean.getMonthString();
	DayFr1=dateBean.getDayString();
	dateBean.setAdjDate(1);
}
String YearTo1=request.getParameter("EYEARTO");
if (YearTo1==null) YearTo1="--"; 
String MonthTo1=request.getParameter("EMONTHTO");
if (MonthTo1==null) MonthTo1="--";
String DayTo1=request.getParameter("EDAYTO");
if (DayTo1==null) DayTo1="--";
String RECEIPTNUM = request.getParameter("RECEIPTNUM");  //add by Peggy 20140814
if (RECEIPTNUM==null) RECEIPTNUM="";
String DATECODE = request.getParameter("DATECODE");  //add by Peggy 20140814
if (DATECODE==null) DATECODE="";
String CUSTOMER = request.getParameter("CUSTOMER");  //add by Peggy 20140814
if (CUSTOMER==null) CUSTOMER="";
String TOTW = request.getParameter("TOTW");  //add by Peggy 20160616
if (TOTW==null) TOTW="";
String sql ="",stock_color="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShippedQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨資料查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Advise No:</td> 
		<td width="8%"><input type="text" name="ADVISENO" value="<%=ADVISENO%>" style="font-family: Tahoma,Georgia;font-size:12px" size="15" onChange="chgObj(this.form.ADVISENO.value);"></td>
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商:</td> 
		<td width="8%">
		<%
		try
		{
			sql = " select vendor_site_id,vendor_site_code from ap.ap_supplier_sites_all a where exists (select 1 from oraddman.tewpo_receive_header b where b.vendor_site_id=a.vendor_site_id) order by vendor_site_code";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SUPPLIER);
			comboBoxBean.setFieldName("SUPPLIER");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>		
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">客戶號碼或名稱:</td> 
		<td width="8%"><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.CUSTOMER.value);"></td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">出貨日期:</td>   
		<td width="28%" colspan="5">
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
	<tr>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">台半料號或型號:</td>   
		<td><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia; font-size: 12px " size="15" onChange="chgObj(this.form.ITEM.value);"></td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">LOT:</td>   
		<td><input type="text" name="LOT" value="<%=LOT%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.LOT.value);"></td>  		
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Date Code:</td>   
		<td><input type="text" name="DATECODE" value="<%=DATECODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.DATECODE.value);"></td>  		
		<td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">ERP交易日:</td> 
		<td colspan="5">
<%
	String CurrYear1 = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2014+1];
		for (int i = 2014; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
		if (YearFr1==null)
		{
		    CurrYear1=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear1);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(YearFr1);
		}
		arrayComboBoxBean.setFieldName("EYEARFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception7:"+e.getMessage());
    }
		  
	String CurrMonth1 = null;	     		 
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
	  	if (MonthFr1==null)
	  	{
			CurrMonth1=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonth1);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthFr1);
	  	}
		arrayComboBoxBean.setFieldName("EMONTHFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception8:"+e.getMessage());
    }

	String CurrDay1 = null;	     		 
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
		if (DayFr1==null)
		{
			CurrDay1=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay1);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(DayFr1);
		}
		arrayComboBoxBean.setFieldName("EDAYFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
	catch (Exception e)
	{
		out.println("Exception9:"+e.getMessage());
	}	
%>
		~</strong></font>
<%
	String CurrYearTo1 = null;	     		 
	try
    {  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2014+1];
		for (int i = 2014; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
	  	if (YearTo1==null)
	  	{
			CurrYearTo1=dateBean.getYearString();
			arrayComboBoxBean.setSelection(CurrYearTo1);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(YearTo1);
	  	}
		arrayComboBoxBean.setFieldName("EYEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
	}
    catch (Exception e)
    {
    	out.println("Exception10:"+e.getMessage());
    }
	
	String CurrMonthTo1 = null;	     		 
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
	  	if (MonthTo1==null)
	  	{
			CurrMonthTo1=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonthTo1);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthTo1);
	  	}
		arrayComboBoxBean.setFieldName("EMONTHTO");	   
		out.println(arrayComboBoxBean.getArrayString());		    
	}
	catch (Exception e)
	{
		out.println("Exception5:"+e.getMessage());
	}
	
	String CurrDayTo1 = null;	     		 
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
		if (DayTo1==null)
		{
			CurrDayTo1=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo1);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(DayTo1);
		}
		arrayComboBoxBean.setFieldName("EDAYTO");	   
    	out.println(arrayComboBoxBean.getArrayString());	
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>  
		</td> 
	</tr>
	<tr>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">採購單號:</td> 
		<td><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.PONO.value);"></td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">驗收單號:</td>   
		<td><input type="text" name="RECEIPTNUM" value="<%=RECEIPTNUM%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.LOT.value);"></td>  		
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商發票號碼:</td> 
		<td><input type="text" name="VENDOR_INVOICE" value="<%=VENDOR_INVOICE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.VENDOR_INVOICE.value);"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">台半發票號碼:</td> 
		<td><input type="text" name="TSC_INVOICE" value="<%=TSC_INVOICE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.TSC_INVOICE.value);"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">訂單號碼:</td> 
		<td><input type="text" name="MONO" value="<%=MONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.MONO.value);"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">回T訂單:</td> 
		<td>
		<%
		try
		{
			sql = "  select 'Y' , '是' FROM dual union all select 'N' ,'否' FROM DUAL";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TOTW);
			comboBoxBean.setFieldName("TOTW");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}		
		%>
		</td>
	</tr>
</table>
<BR>
<div align="center"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWShippedQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TEWShippedExcel.jsp")' > 
</div>
<hr>
<%
try
{       
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
	
	int iCnt = 0;
	sql = " select x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,sum(x.QTY) QTY,x.pono,x.vendor_site_code,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.receipt_num,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM"+
	      ",tew_rcv_pkg.GET_SO_DESTINATION(x.advise_no,x.so_no) destination"+ //add by Peggy 20150703
		  " from (select  b.tew_advise_no advise_no"+
	      ",b.so_no"+
		  ",b.item_no"+
		  ",b.item_desc"+
		  ",to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyy-mm-dd') PC_SCHEDULE_SHIP_DATE"+
		  ",a.shipping_method"+
		  //",c.CARTON_NO||a.POST_FIX_CODE CARTON_NO"+
		  ",case when length(b.SHIPPING_REMARK) >=12 and substr(b.SHIPPING_REMARK,0,12) ='CHANNEL WELL' or instr(b.SHIPPING_REMARK,'駱騰')>0  then a.POST_FIX_CODE||c.CARTON_NO else c.CARTON_NO||a.POST_FIX_CODE end as CARTON_NO"+ //modify by Peggy 20140902
		  ",c.SUBINVENTORY"+
		  ",c.lot"+
		  ",c.date_code"+
		  ",c.QTY/1000 QTY"+
		  ",e.segment1 pono"+
		  ",f.vendor_site_code"+
		  ",DECODE(g.ITEM_IDENTIFIER_TYPE,'CUST',g.ORDERED_ITEM,'') CUST_ITEM"+
		  ",TO_CHAR(h.PICK_CONFIRM_DATE,'yyyy-mm-dd') PICK_CONFIRM_DATE"+
		  ",c.receipt_num"+
		  ",i.INVOICE_NO"+
		  ",j.INVOICE_NO TSC_INVOICE_NO"+
		  ",b.SHIPPING_REMARK"+
		  ",b.so_header_id"+
		  ",a.to_tw"+
		  //",case when a.to_tw='Y' and substr(b.so_no,1,4)='1121' then 'CKS AIRPORT' "+
		  //"      when a.to_tw='Y' and substr(b.so_no,1,4)<>'1121' then 'KEELUNG' "+
		  //" else '' end as DESTINATION"+
		  ",'('||m.customer_number||')'||m.CUSTOMER_NAME_PHONETIC customer"+
		  ",c.CARTON_NO CARTON_NUM"+
          " from tsc.tsc_shipping_advise_headers a"+
		  ",tsc.tsc_shipping_advise_lines b"+
		  ",tsc.tsc_pick_confirm_lines c"+
		  ",po.po_line_locations_all d"+
		  ",po_headers_all e"+
		  ",ap_supplier_sites_all f"+
		  ",ont.oe_order_lines_all g"+
		  ",tsc.tsc_pick_confirm_headers h"+
		  ",(SELECT TEW_ADVISE_NO,INVOICE_NO from apps.TSC_VENDOR_INVOICE_LINES GROUP BY TEW_ADVISE_NO,INVOICE_NO) i"+
		  ",(select distinct x.ADVISE_HEADER_ID,y.DELIVERY_NAME INVOICE_NO from tsc.tsc_advise_dn_header_int x, tsc.tsc_advise_dn_line_int y where x.STATUS='S' and x.INTERFACE_HEADER_ID=y.INTERFACE_HEADER_ID and x.ADVISE_HEADER_ID=y.ADVISE_HEADER_ID) j"+
		  ",ar_customers m"+
          " where a.shipping_from='TEW'"+
		  " and b.tew_advise_no is not null"+
		  " AND a.advise_header_id = b.advise_header_id "+
		  " and b.advise_header_id=c.advise_header_id"+
		  " and b.advise_line_id = c.advise_line_id"+
		  " and c.po_line_location_id = d.line_location_id"+
		  " and d.po_header_id=e.po_header_id "+
          " and e.vendor_site_id =f.vendor_site_id"+
		  " and b.so_header_id = g.header_id "+
		  " and b.so_line_id = g.line_id"+
		  " and a.CUSTOMER_ID=m.customer_id"+
		  " and a.advise_header_id = j.advise_header_id(+)"+
		  " and c.advise_header_id = h.advise_header_id"+
          " and b.tew_advise_no = i.tew_advise_no(+)";
	if (!ADVISENO.equals(""))
	{
		sql += " AND b.tew_advise_no like '"+ ADVISENO+"%'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND e.SEGMENT1 = '"+ PONO+"'";
	}	
	if (!MONO.equals(""))
	{
		sql += " AND b.so_no = '"+ MONO+"'";
	}	
	if (!LOT.equals(""))
	{
		sql += " AND c.lot ='" + LOT+"'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(b.item_no) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(b.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		sql += " AND f.vendor_site_id = '"+SUPPLIER+"'";
	}
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')  >= '" + (YearFr.equals("--") || YearFr.equals("")?"2014":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") && !DayTo.equals("")))
	{
		sql += " AND to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')  <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (!VENDOR_INVOICE.equals(""))
	{
		sql += " AND i.INVOICE_NO LIKE '"+VENDOR_INVOICE+"%'";
	}
	if (!TSC_INVOICE.equals(""))
	{
		sql += " AND j.INVOICE_NO LIKE '"+TSC_INVOICE+"%'";
	}	
	if ((!YearFr1.equals("--") && !YearFr1.equals("")) || (!MonthFr1.equals("--") && !MonthFr1.equals("")) || (!DayFr1.equals("--") && !DayFr1.equals("")))
	{
		sql += " AND TO_DATE(TO_CHAR(h.PICK_CONFIRM_DATE,'yyyymmdd'),'yyyymmdd')  >= TO_DATE('" + (YearFr1.equals("--") || YearFr1.equals("")?"2014":YearFr1)+(MonthFr1.equals("--") || MonthFr1.equals("")?"01":MonthFr1)+(DayFr1.equals("--") || DayFr1.equals("")?"01":DayFr1)+"','yyyymmdd')";
	}
	if ((!YearTo1.equals("--") && !YearTo1.equals("")) || (!MonthTo1.equals("--") && !MonthTo1.equals("")) || (!DayTo1.equals("--") && !DayTo1.equals("")))
	{
		sql += " AND TO_DATE(TO_CHAR(h.PICK_CONFIRM_DATE,'yyyymmdd'),'yyyymmdd')  <= TO_DATE('" + (YearTo1.equals("--") || YearTo1.equals("")?dateBean.getYearString():YearTo1)+(MonthTo1.equals("--") || MonthTo1.equals("")?dateBean.getMonthString():MonthTo1)+(DayTo1.equals("--") || DayTo1.equals("")?dateBean.getDayString():DayTo1)+"','yyyymmdd')";
	}	
	if (!RECEIPTNUM.equals(""))  //add by Peggy 20140814
	{
		sql += " AND c.receipt_num LIKE '"+ RECEIPTNUM +"%'";
	}
	if (!DATECODE.equals(""))  //add by Peggy 20140814
	{
		sql += " AND c.date_code LIKE '"+ DATECODE +"%'";
	}	
	if (!CUSTOMER.equals("")) //add by Peggy 20140814
	{
		sql += " AND (m.CUSTOMER_NUMBER like '"+CUSTOMER+"%' or upper(m.CUSTOMER_NAME_PHONETIC) like '%"+CUSTOMER.toUpperCase()+"%' or upper(b.SHIPPING_REMARK) like '%"+CUSTOMER.toUpperCase()+"%')";
	}
	if (!TOTW.equals("--") && !TOTW.equals(""))
	{
		sql += " and a.TO_TW='"+TOTW+"'";
	}
	sql += ") x "+
	       " group by x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,x.pono,x.vendor_site_code,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.receipt_num,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM"+
		   " ORDER BY x.PC_SCHEDULE_SHIP_DATE , x.advise_no,to_number(x.CARTON_NUM),x.lot";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="1700" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="70" style="color:#006666" align="center">Advise No</td>
				<td width="160" style="color:#006666" align="center">客戶</td>
				<td width="120" style="color:#006666" align="center">型號</td>            
				<td width="100" style="color:#006666" align="center">客戶品號</td>            
				<td width="120" style="color:#006666" align="center">嘜頭</td>            
				<td width="70" style="color:#006666" align="center">出貨日期</td>
				<td width="50" style="color:#006666" align="center">箱號</td>            
				<td width="80" style="color:#006666" align="center">LOT</td>            
				<td width="50" style="color:#006666" align="center">D/C</td>
				<td width="50" style="color:#006666" align="center">數量(K)</td>            
				<td width="80" style="color:#006666" align="center">供應商發票號</td>
				<td width="80" style="color:#006666" align="center">驗收單號</td>
				<td width="90" style="color:#006666" align="center">台半發票號</td>
				<td width="70" style="color:#006666" align="center">ERP交易日</td>
				<td width="80" style="color:#006666" align="center">MO單號</td>
				<td width="80" style="color:#006666" align="center">出貨方式</td>            
				<td width="90" style="color:#006666" align="center">目的地</td>            
				<td width="50" style="color:#006666" align="center">供應商</td>
				<td width="70" style="color:#006666" align="center">採購單號</td>            
			</tr>
		<% 
		}
		destination=rs.getString("destination");
		//modify by Peggy 20150703,call TEW_RCV_PKG.GET_SO_DESTINATION取目的地
		//if (rs.getString("to_tw").equals("N"))
		//{
		//	sql = " SELECT  FDLT.LONG_TEXT  FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT"+
		//		  " WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND FADFV.CATEGORY_DESCRIPTION = 'SHIPPING MARKS' AND FADFV.PK1_VALUE = to_char(?) AND FADFV.MEDIA_ID = FDLT.MEDIA_ID  AND fadfv.USER_ENTITY_NAME = 'OM Order Header'";  
		//	//out.println(sql);
		//	//out.println(rs.getString("so_header_id"));
		//	PreparedStatement statementp = con.prepareStatement(sql);
		//	statementp.setString(1,rs.getString("so_header_id"));
		//	ResultSet rsp=statementp.executeQuery();
		//	if  (rsp.next())
		//	{
		//		String splitStr[] = rsp.getString("LONG_TEXT").split("\n");	
		//		for (int k=0;k <splitStr.length;k++)
		//		{
		//			if (splitStr[k].indexOf("C/N")>=0 || splitStr[k].indexOf("C/O NO")>=0)
		//			{
		//				for (int m=k-1 ; m>=0 ; m--)
		//				{
		//					if (splitStr[m].equals("") || splitStr[m].indexOf("P/NO") >= 0 || splitStr[m].indexOf("P/N NO")>=0 || splitStr[m].indexOf("P/O NO")>=0) continue;
		//					destination = splitStr[m].replace("CHINA","");
		//					break;
		//				}
		//			}
		//		}			
		//	}
		//	rsp.close();
		//	statementp.close();
		//}
		//else
		//{
		//	destination = rs.getString("destination");
		//}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center"><%=rs.getString("advise_no")%></td>
			<td align="left"><%=rs.getString("customer")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%></td>
			<td><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
			<td align="center"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></td>
			<td align="center"><%=rs.getString("CARTON_NO")%></td>
			<td><%=rs.getString("LOT")%></td>
			<td align="center"><%=rs.getString("DATE_CODE")%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("QTY")))%></td>
			<td align="center"><%=(rs.getString("INVOICE_NO")==null?"&nbsp;":rs.getString("INVOICE_NO"))%></td>
			<td align="center"><%=(rs.getString("RECEIPT_NUM")==null?"&nbsp;":rs.getString("RECEIPT_NUM"))%></td>
			<td align="center"><%=(rs.getString("TSC_INVOICE_NO")==null?"&nbsp;":rs.getString("TSC_INVOICE_NO"))%></td>
			<td align="center"><%=(rs.getString("PICK_CONFIRM_DATE")==null?"&nbsp;":rs.getString("PICK_CONFIRM_DATE"))%></td>
			<td align="center"><%=rs.getString("so_no")%></td>
			<td><%=rs.getString("shipping_method")%></td>
			<td style="font-size:10px"><%=(destination==null || destination.equals("")?"&nbsp;":destination)%></td>
			<td><%=rs.getString("VENDOR_SITE_CODE")%></td>
			<td align="center"><%=rs.getString("PONO")%></td>
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
	
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();		
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

