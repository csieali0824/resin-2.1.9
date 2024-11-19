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
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUpdate(URL)
{    
	subWin=window.open(URL,"subwin","width=740,height=550,scrollbars=yes,menubar=no");  
}
//function ReturnToVendorQuery(seqid)
//{
//	subWin=window.open("TEWPOReturnToVendor.jsp?seqid="+seqid,"subwin","width=440,height=250,scrollbars=no,menubar=no,location=no");  
//}
//function POAllotQuery(seqid)
//{
//	subWin=window.open("TEWPOAllotDetail.jsp?seqid="+seqid,"subwin","width=750,height=300,scrollbars=yes,menubar=no,location=no");  
//}
//function POShippedQuery(seqid)
//{
//	subWin=window.open("TEWPOAllotDetail.jsp?type=shipped&seqid="+seqid,"subwin","width=750,height=300,scrollbars=yes,menubar=no,location=no");  
//}
function setChange()
{
	document.MYFORM.YEARFR.value = "--";
	document.MYFORM.MONTHFR.value = "--";
	document.MYFORM.DAYFR.value = "--";
	document.MYFORM.YEARTO.value = "--";
	document.MYFORM.MONTHTO.value = "--";
	document.MYFORM.DAYTO.value = "--";	
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
String STOCK_AGE = request.getParameter("STOCK_AGE");
if (STOCK_AGE==null) STOCK_AGE="";
String ORGCODE= request.getParameter("ORGCODE");
if (ORGCODE==null) ORGCODE="";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String DATE_CODE = request.getParameter("DATE_CODE");
if (DATE_CODE==null) DATE_CODE="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String STOCK = request.getParameter("STOCK"); 
if (STOCK==null) STOCK="";
String sql ="",stock_color="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGPOReceiveDetailQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG PO Receive Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td  Width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">內外銷:</td>   
		<td width="7%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:12px'>");
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
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">收料日期:</td>   
		<td width="44%" colspan="3">
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
	    <td width="6%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " select y.vendor_site_id,y.vendor_site_code from po_headers_all x,ap_supplier_sites_all y where x.TYPE_LOOKUP_CODE='BLANKET' and x.vendor_site_id=y.vendor_site_id and x.org_id=906 order by 2";
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
		</td>
	    <td width="6%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">採購單號:</td> 
		<td width="10%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="setChange();"></td>
	</tr>
	<tr>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">庫齡天數:</td>   
		<td><select NAME="STOCK_AGE" style="font-family: Tahoma,Georgia; font-size: 12px" onChange="DateValueOf(this.value)">
		<OPTION VALUE=-- <%if (STOCK_AGE.equals("")) out.println("selected");%>>--</OPTION>
	<%
		sql = "select '<=30',to_char(trunc(sysdate)-30,'yyyymmdd') ||'-'||to_char(trunc(sysdate),'yyyymmdd') EDATE from dual"+
              " UNION ALL"+
              " select '31~60',to_char(trunc(sysdate)-60,'yyyymmdd') ||'-'||to_char(trunc(sysdate)-31,'yyyymmdd') EDATE from dual"+
              " UNION ALL"+
              " select '61~90',to_char(trunc(sysdate)-90,'yyyymmdd') ||'-'||to_char(trunc(sysdate)-61,'yyyymmdd') EDATE from dual"+
              " UNION ALL"+
              " select '91~179',to_char(trunc(sysdate)-179,'yyyymmdd') ||'-'||to_char(trunc(sysdate)-91,'yyyymmdd') EDATE from dual"+
              " UNION ALL"+
              " select '>=180',to_char(trunc(sysdate)-180,'yyyymmdd') EDATE from dual";
		Statement statement1=con.createStatement(); 
		ResultSet rs1=statement1.executeQuery(sql);
		while (rs1.next()) 
		{
	%>
		<OPTION VALUE="<%=rs1.getString(2)%>" <%if (STOCK_AGE.equals(rs1.getString(2))) out.println("selected");%>><%=rs1.getString(1)%></OPTION>
	<%
		}
		rs1.close();
		statement1.close();
	%>
		</select>
		</td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">台半料號或型號:</td>   
		<td><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia; font-size: 12px " size="30" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">LOT Number:</td> 
		<td><input type="text" name="LOT_NUMBER" value="<%=LOT_NUMBER%>" style="font-family: Tahoma,Georgia; font-size:12px" size="25" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Date Code:</td> 
		<td><input type="text" name="DATE_CODE" value="<%=DATE_CODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">數量條件:</td> 
		<td><select NAME="STOCK" style="font-family: Tahoma,Georgia; font-size:12px" onChange="setChange();">
		<OPTION VALUE=-- <%if (STOCK.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="1" <%if (STOCK.equals("1")) out.println("selected");%>>庫存數量>0</OPTION>
		<OPTION VALUE="2" <%if (STOCK.equals("2")) out.println("selected");%>>庫存數量=0</OPTION>
		<OPTION VALUE="3" <%if (STOCK.equals("3")) out.println("selected");%>>退貨數量>0</OPTION>
		<OPTION VALUE="4" <%if (STOCK.equals("4")) out.println("selected");%>>撿貨數量>0</OPTION>
		<OPTION VALUE="5" <%if (STOCK.equals("5")) out.println("selected");%>>出貨數量>0</OPTION>
		<OPTION VALUE="6" <%if (STOCK.equals("6")) out.println("selected");%>>調撥數量>0</OPTION>
		</select></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGPOReceiveDetailQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSCSGPOReceiveDetailExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT X.*,X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY) ONHAND "+
	      " FROM (SELECT A.SG_STOCK_ID"+
		  "       ,A.ORGANIZATION_ID"+
          "       ,CASE A.ORGANIZATION_ID WHEN 907 THEN '內銷' WHEN 908 THEN '外銷' ELSE '??' END AS organization_name"+
          "       ,TRUNC(SYSDATE)-TRUNC(A.RECEIVED_DATE) STOCK_AGE"+
          "       ,A.INVENTORY_ITEM_ID ITEM_ID"+
          "       ,A.ITEM_NAME"+
          "       ,A.ITEM_DESC"+
          "       ,A.SUBINVENTORY_CODE"+
          "       ,A.LOT_NUMBER"+
          "       ,A.DATE_CODE"+
          "       ,A.DC_YYWW"+
          "       ,NVL(A.RECEIVED_QTY,0)/1000 RECEIVED_QTY"+
          "       ,NVL(A.ALLOCATE_IN_QTY,0)/1000 ALLOCATE_IN_QTY"+
          "       ,NVL(A.RETURN_QTY,0)/1000 RETURN_QTY"+
          "       ,NVL(A.ALLOCATE_OUT_QTY,0)/1000 ALLOCATE_OUT_QTY"+
          "       ,NVL(A.SHIPPED_QTY,0)/1000 SHIPPED_QTY"+
          "       ,NVL((SELECT SUM(TPCL.QTY) QTY FROM TSC_PICK_CONFIRM_LINES TPCL,TSC_PICK_CONFIRM_HEADERS TPCH WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.PICK_CONFIRM_DATE IS NULL AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID),0)/1000 PICK_QTY"+
          "       ,TO_CHAR(A.RECEIVED_DATE,'YYYY/MM/DD') RECEIVED_DATE"+
          "       ,B.NOTE_TO_RECEIVER"+
          "       ,A.VENDOR_CARTON_NO"+
          "       ,D.SEGMENT1 PO_NO"+
          "       ,D.CURRENCY_CODE"+
          "       ,C.LINE_NUM"+
		  "       ,TO_CHAR(B.NEED_BY_DATE,'YYYY/MM/DD') NEED_BY_DATE"+
          "       ,A.VENDOR_SITE_ID"+
          "       ,A.VENDOR_SITE_CODE"+
          //"       ,NVL(A.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(C.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN C.NOTE_TO_VENDOR ELSE SUBSTR(C.NOTE_TO_VENDOR,1,INSTR(C.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          "       ,NVL(A.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(C.NOTE_TO_VENDOR)"+  //modify by Peggy 20230607
          "       ,CASE WHEN B.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "       FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "       WHERE x.org_id= CASE WHEN SUBSTR(B.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "       AND x.header_id=y.header_id"+
          "       AND y.packing_instructions='T'"+
          "       AND x.order_number= SUBSTR(B.NOTE_TO_RECEIVER,1,INSTR(B.NOTE_TO_RECEIVER,'.')-1)"+
          "       AND y.shipment_number=1 and y.line_number=SUBSTR(B.NOTE_TO_RECEIVER,INSTR(B.NOTE_TO_RECEIVER,'.')+1))"+
          "       ELSE '' END)) PO_CUST_PARTNO"+
		  "       ,A.CREATED_BY"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE "+  
          "       FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          "       ,PO.PO_LINE_LOCATIONS_ALL B"+
          "       ,PO.PO_LINES_ALL C"+
          "       ,PO.PO_HEADERS_ALL D"+
          "       WHERE A.RECEIVED_DATE between to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2020":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"02":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"','yyyymmdd')"+
 		  "       AND to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')+0.99999"+
          "       AND A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)"+
          "       AND B.PO_LINE_ID=C.PO_LINE_ID(+)"+
          "       AND A.PO_HEADER_ID=D.PO_HEADER_ID(+)) X "+
		  "       WHERE 1=1";
	/*sql = " select a.* from TSSG_ONHAND_V a"+
          " where a.TRANSACTION_DATE between to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2020":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"02":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"','yyyymmdd')"+
 		  " AND to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')+0.99999";*/
	if (!ORGCODE.equals("") && !ORGCODE.equals("--"))
	{
		sql += " AND X.ORGANIZATION_ID = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND X.PO_NO LIKE '"+ PONO+"%'";
	}	
	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(X.ITEM_NAME) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(X.ITEM_DESC) LIKE '"+ITEM.toUpperCase()+"%')";
	}	

	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		sql += " AND X.VENDOR_SITE_ID = '"+ SUPPLIER+"'";
	}	

	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND X.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}	
	if (!DATE_CODE.equals(""))
	{
		sql += " AND X.DATE_CODE = '"+ DATE_CODE+"'";
	}		
	if (STOCK.equals("1"))
	{
		sql += " AND X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY)<>0";
	}
	else if (STOCK.equals("2")) 
	{
		sql += " AND X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY)=0";
	}
	else if (STOCK.equals("3"))
	{
		sql += " AND NVL(x.RETURN_QTY,0)>0";
	}
	else if (STOCK.equals("4"))
	{
		sql += " AND NVL(x.PICK_QTY,0)>0";
	}
	else if (STOCK.equals("5"))
	{
		sql += " AND NVL(x.SHIPPED_QTY,0)>0";
	}
	else if (STOCK.equals("6"))
	{
		sql += " AND NVL(x.ALLOCATE_IN_QTY,0)+NVL(x.ALLOCATE_OUT_QTY,0)>0";
	}
    sql +=" ORDER BY X.STOCK_AGE,X.ORGANIZATION_ID,X.ITEM_DESC,X.RECEIVED_DATE,X.LOT_NUMBER,X.DATE_CODE,X.DC_YYWW,NVL(X.VENDOR_CARTON_NO,'0')";
	
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table border="0" width="100%">
			<tr>
				<td bgcolor="#00ff00" width="1%">&nbsp;</td><td width="7%">庫齡<=90天</td>
				<td bgcolor="#ffff00" width="1%">&nbsp;</td><td width="7%">庫齡91~179天</td>
				<td bgcolor="#ff0000" width="1%">&nbsp;</td><td width="7%">庫齡>=180天</td>
				<td width="76%">&nbsp;</td>
			</tr>
		</table>		
		<table width="1530" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="40" style="color:#006666" align="center">庫齡(天)</td>
				<td width="50" style="color:#006666" align="center">內外銷</td>
				<td width="70" style="color:#006666" align="center">收料日期</td>
				<td width="180" style="color:#006666" align="center">料號</td>
				<td width="130" style="color:#006666" align="center">型號</td>            
				<td width="30" style="color:#006666" align="center">倉別</td>            
				<td width="130" style="color:#006666" align="center">LOT</td>            
				<td width="50" style="color:#006666" align="center">D/C</td>
				<td width="40" style="color:#006666" align="center">DC YYWW</td>            
				<td width="40" style="color:#006666" align="center">收貨量(K)</td>            
				<td width="40" style="color:#006666" align="center">退貨量(K)</td>            
				<td width="40" style="color:#006666" align="center">調撥入(K)</td>            
				<td width="40" style="color:#006666" align="center">調撥出(K)</td>            
				<td width="40" style="color:#006666" align="center">出貨量(K)</td>            
				<td width="40" style="color:#006666" align="center">撿貨量(K)</td>            
				<td width="40" style="color:#006666" align="center">庫存量(K)</td>            
				<td width="110" style="color:#006666" align="center">客戶品號</td>            
				<td width="100" style="color:#006666" align="center">採購單號/項次</td>            
				<td width="70" style="color:#006666" align="center">需求日</td>            
				<td width="40" style="color:#006666" align="center">幣別</font></div></td>
				<td width="70" style="color:#006666" align="center">供應商</td>
				<td width="70" style="color:#006666" align="center">供應商箱號</td>
				<td width="70" style="color:#006666" align="center">收貨員</td>
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
		<%
			if  (Integer.parseInt(rs.getString("STOCK_AGE")) <=90)
			{
				stock_color = "#00ff00";
			}
			else if (Integer.parseInt(rs.getString("STOCK_AGE")) >90 && Integer.parseInt(rs.getString("STOCK_AGE")) < 180)
			{
				stock_color = "#ffff00";
			}
			else
			{
				stock_color = "#ff0000";
			}
		%>
			<td align="center" style="background-color:<%=stock_color%>"><%=rs.getString("STOCK_AGE")%></td>
			<td align="center"><%=rs.getString("ORGANIZATION_NAME")%></td>
			<td align="center"><%=rs.getString("RECEIVED_DATE")%></td>
			<td style="font-size:10px"><%=rs.getString("ITEM_NAME")%></td>
			<td style="font-size:10px"><%=rs.getString("ITEM_DESC")%></td>
			<td <%=(rs.getString("SUBINVENTORY_CODE").equals("02")?"style='font-weight:bold'":"")%>><%=rs.getString("SUBINVENTORY_CODE")%></td>
			<td><%=rs.getString("LOT_NUMBER")%></td>
			<td><%=rs.getString("DATE_CODE")%></td>
			<td align="center"><%=(rs.getString("DC_YYWW")==null?"&nbsp;":rs.getString("DC_YYWW"))%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RECEIVED_QTY")))%></td>
			<td align="right" <%=(!rs.getString("RETURN_QTY").equals("0")?"style='color:#ff9900;font-weight:bold'":"")%>><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RETURN_QTY")))%></td>
			<td align="right" <%=(!rs.getString("ALLOCATE_IN_QTY").equals("0")?"style='color:#009900;font-weight:bold'":"")%>><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ALLOCATE_IN_QTY")))%></td>
			<td align="right" <%=(!rs.getString("ALLOCATE_OUT_QTY").equals("0")?"style='color:#FF88AA;font-weight:bold'":"")%>><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ALLOCATE_OUT_QTY")))%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIPPED_QTY")))%></td>
			<td align="right" <%=(!rs.getString("PICK_QTY").equals("0")?"style='font-weight:bold'":"")%>><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("PICK_QTY")))%></td>
			<td align="right" style="<%=(rs.getFloat("ONHAND")>0 ?"color:#0000FF;font-weight:bold":(rs.getFloat("ONHAND")<0 ?"color:#FF0000;font-weight:bold":"color:#000000"))%>"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ONHAND")))%></td>
			<td style="font-size:10px"><%=(rs.getString("PO_CUST_PARTNO")==null?"&nbsp;":rs.getString("PO_CUST_PARTNO"))%></td>
			<td align="center"><%=(rs.getString("PO_NO")==null?"&nbsp;":rs.getString("PO_NO"))%><%=(rs.getString("line_num")==null?"&nbsp;":"/"+rs.getString("line_num"))%></td>
			<td align="center"><%=(rs.getString("need_by_date")==null?"&nbsp;":rs.getString("need_by_date"))%></td>
			<td align="center"><%=(rs.getString("CURRENCY_CODE")==null?"&nbsp;":rs.getString("CURRENCY_CODE"))%></td>
			<td><font style="font-size:11px"><%=(rs.getString("VENDOR_SITE_CODE")==null?"&nbsp;":rs.getString("VENDOR_SITE_CODE"))%></font></td>
			<td><font style="font-size:11px"><%=(rs.getString("VENDOR_CARTON_NO")==null?"&nbsp;":rs.getString("VENDOR_CARTON_NO"))%></font></td>
			<td><%=rs.getString("CREATED_BY")%></td>
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

