<!-- modify by Peggy 20140903,增加庫存數量查詢條件-->
<!-- modify by Peggy 20140922,增加need by date欄位-->
<!-- modify by Peggy 20151118,增加調撥數量欄位-->
<!-- modify by Peggy 20170920,新增remarks欄位-->
<!-- modify by Peggy 20171205,新增不符FIFO原因-->
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
function ReturnToVendorQuery(seqid)
{
	subWin=window.open("TEWPOReturnToVendor.jsp?seqid="+seqid,"subwin","width=440,height=250,scrollbars=no,menubar=no,location=no");  
}
function POAllotQuery(seqid)
{
	subWin=window.open("TEWPOAllotDetail.jsp?seqid="+seqid,"subwin","width=750,height=300,scrollbars=yes,menubar=no,location=no");  
}
function POShippedQuery(seqid)
{
	subWin=window.open("TEWPOAllotDetail.jsp?type=shipped&seqid="+seqid,"subwin","width=750,height=300,scrollbars=yes,menubar=no,location=no");  
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
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
String STOCK = request.getParameter("STOCK");  //add by Peggy 20140903
if (STOCK==null) STOCK="";
String sql ="",stock_color="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWPOReceiveQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW PO Receive Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">Org Code:</td>   
		<td width="8%"><select NAME="ORGCODE" style="width:68;font-family: Tahoma,Georgia; font-size:12px">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>
		<OPTION VALUE="566" <%if (ORGCODE.equals("566")) out.println("selected");%>>I20</OPTION>
		</select>
		</td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">收料日期:</td>   
		<td width="36%" colspan="3">
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
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商:</td> 
		<td width="12%">
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
		</td>
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">採購單號:</td> 
		<td width="12%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="setChange();"></td>
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
		<td><input type="text" name="LOT_NUMBER" value="<%=LOT_NUMBER%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Date Code:</td> 
		<td><input type="text" name="DATE_CODE" value="<%=DATE_CODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="setChange();"></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">庫存條件:</td> 
		<td><select NAME="STOCK" style="font-family: Tahoma,Georgia; font-size:12px">
		<OPTION VALUE=-- <%if (STOCK.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="1" <%if (STOCK.equals("1")) out.println("selected");%>>庫存數量>0</OPTION>
		<OPTION VALUE="2" <%if (STOCK.equals("2")) out.println("selected");%>>庫存數量=0</OPTION>
		</select></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWPOReceiveQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TEWPOReceiveExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT  trunc(sysdate)-orh.received_date stock_age"+
	      //",orh.po_line_location_id"+
		  ",to_char(orh.received_date,'yyyy-mm-dd') receive_date"+
		  ",orh.*"+
		  ",odr.order_number"+
		  ",odr.line_number"+
		  ",nvl(odr.cust_partno,pla.note_to_vendor) cust_partno"+
		  ",pph.CURRENCY_CODE"+
		  ",axs.VENDOR_SITE_CODE VENDOR_NAME"+
		  ",pla.line_num"+
		  ",to_char(pll.need_by_date,'yyyy-mm-dd') need_by_date"+
		  //",nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allot_quantity,0) onhand"+
		  ",nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0)-nvl(orh.allot_quantity,0) onhand"+
	      ",(select count(1) from oraddman.tewpo_receive_revise x where x.po_line_location_id = orh.po_line_location_id and x.old_lot_number=orh.lot_number and x.old_date_code=orh.date_code and x.old_received_date=orh.received_date AND NVL(x.APPROVE_FLAG,'N') <>'Y') confirm_cnt"+
          " FROM (SELECT trh.organization_id,"+
		  "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
          "              trd.date_code,"+
		  "              trd.seq_id,"+
		  "              trh.vendor_site_id,"+
		  "              trd.CREATED_BY,"+
		  "              nvl(trd.remarks,'') remarks,"+
		  "              nvl(trd.no_match_fifo_reason,'') no_match_fifo_reason,"+
          "              SUM (NVL (trd.received_quantity, 0))+SUM (NVL (trr.return_quantity,0))+SUM (NVL (tra.allocation_quantity,0)) received_quantity,"+
          "              SUM (NVL (trd.shipped_quantity, 0)) shipped_quantity,"+
		  "              SUM (NVL (trr.return_quantity,0)) return_quantity,"+
		  "              SUM (NVL (tra.allocation_quantity,0)) allocation_quantity,"+
		  "              (select nvl(sum(ALLOT_QTY),0)/1000 from oraddman.tew_lot_allot_detail tlad where nvl(CONFIRM_FLAG,'N')<>'Y' and tlad.po_line_location_id=trh.po_line_location_id and tlad.lot_number=trd.lot_number and tlad.seq_id = trd.seq_id) allot_quantity"+
          "        FROM oraddman.tewpo_receive_header trh,"+
          "        oraddman.tewpo_receive_detail trd,"+
		  "        (select PO_LINE_LOCATION_ID,SEQ_ID,SUM((OLD_RECEIVED_QUANTITY-NEW_RECEIVED_QUANTITY)) RETURN_QUANTITY"+
          "        from  oraddman.tewpo_receive_revise where nvl(APPROVE_FLAG,'N')='Y' AND CHANGE_TYPE='1' GROUP BY PO_LINE_LOCATION_ID,SEQ_ID) trr,"+
		  "        (select PO_LINE_LOCATION_ID,SEQ_ID,SUM((OLD_RECEIVED_QUANTITY-NEW_RECEIVED_QUANTITY)) ALLOCATION_QUANTITY"+
          "        from  oraddman.tewpo_receive_revise where nvl(APPROVE_FLAG,'N')='Y' AND CHANGE_TYPE='3' GROUP BY PO_LINE_LOCATION_ID,SEQ_ID) tra"+
          "        WHERE trh.po_line_location_id = trd.po_line_location_id"+
		  "        and trd.po_line_location_id=trr.po_line_location_id(+)"+
		  "        and trd.seq_id=trr.seq_id(+)"+
		  "        and trd.po_line_location_id=tra.po_line_location_id(+)"+
		  "        and trd.seq_id=tra.seq_id(+)"+
		  "        and nvl(trd.received_quantity,0)+nvl(trr.return_quantity,0)+nvl(tra.allocation_quantity,0) >0"+
          "        GROUP BY trh.organization_id,"+
          "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
          "              trd.date_code,"+
		  "              trd.seq_id,"+
		  "              trh.vendor_site_id,"+
		  "              trd.CREATED_BY,"+
		  "              nvl(trd.remarks,''),"+
		  "              nvl(trd.no_match_fifo_reason,'')"+
          "       ) orh,"+
          " po.po_line_locations_all pll,"+
		  " po.po_lines_all pla,"+
          " (SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
          "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
          "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr,"+
          " PO.PO_HEADERS_ALL  pph,"+
		  " AP.AP_SUPPLIER_SITES_ALL axs,"+
          " AP.AP_SUPPLIERS aas"+
          " WHERE orh.po_line_location_id = pll.line_location_id"+
          " AND orh.po_header_id = pph.PO_HEADER_ID"+
		  " and orh.vendor_site_id = axs.vendor_site_id"+
          " AND axs.VENDOR_ID=aas.VENDOR_ID"+
		  " AND pll.po_line_id=pla.po_line_id"+
		  " AND pll.po_header_id=pla.po_header_id"+
          " AND SUBSTR (pll.note_to_receiver,1, INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          " AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)";
	if (ORGCODE.equals("") && ORGCODE.equals("--"))
	{
		sql += " AND orh.organization_id = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND orh.PO_NO LIKE '"+ PONO+"%'";
	}	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(orh.item_name) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(orh.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		//sql += " AND aas.VENDOR_NAME LIKE '"+SUPPLIER+"%'";
		sql += " AND orh.VENDOR_SITE_ID = '"+ SUPPLIER+"'";
	}
	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND orh.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}	
	if (!DATE_CODE.equals(""))
	{
		sql += " AND orh.date_code = '"+ DATE_CODE+"'";
	}	
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(orh.RECEIVED_DATE,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2010":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND to_char(orh.RECEIVED_DATE,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (STOCK.equals("1")) //add by Peggy 20140903,庫存數量>0
	{
		sql += " AND nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0) >0";
	}
	else if (STOCK.equals("2")) //add by Peggy 20140903,庫存數量=0
	{
		sql += " AND nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0) =0";
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
		<table border="0" width="100%">
			<tr>
				<td bgcolor="#00ff00" width="1%">&nbsp;</td><td width="7%">庫齡<=90天</td>
				<td bgcolor="#ffff00" width="1%">&nbsp;</td><td width="7%">庫齡91~179天</td>
				<td bgcolor="#ff0000" width="1%">&nbsp;</td><td width="7%">庫齡>=180天</td>
				<td width="76%">&nbsp;</td>
			</tr>
		</table>		
		<table width="1660" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="40" height="22" nowrap>&nbsp;&nbsp;&nbsp;</td> 
				<td width="40" style="color:#006666" align="center">庫齡(天)</td>
				<td width="70" style="color:#006666" align="center">收料日期</td>
				<td width="130" style="color:#006666" align="center">料號</td>
				<td width="120" style="color:#006666" align="center">型號</td>            
				<td width="70" style="color:#006666" align="center">LOT</td>            
				<td width="50" style="color:#006666" align="center">收貨數量(K)</td>            
				<td width="50" style="color:#006666" align="center">撿貨數量(K)</td>            
				<td width="50" style="color:#006666" align="center">出貨數量(K)</td>            
				<td width="50" style="color:#006666" align="center">退貨數量(K)</td>            
				<td width="50" style="color:#006666" align="center">調撥數量(K)</td>            
				<td width="50" style="color:#006666" align="center">庫存數量(K)</td>            
				<td width="50" style="color:#006666" align="center">D/C</td>
				<td width="80" style="color:#006666" align="center">M/O單號</td>
				<td width="160" style="color:#006666" align="center">客戶品號</td>            
				<td width="80" style="color:#006666" align="center">採購單號</td>            
				<td width="40" style="color:#006666" align="center">採購單項次</td>            
				<td width="70" style="color:#006666" align="center">需求日</td>            
				<td width="100" style="color:#006666" align="center">備註</td>
				<td width="100" style="color:#006666" align="center">不符FIFO原因</td>
				<td width="40" style="color:#006666" align="center">幣別</font></div></td>
				<td width="70" style="color:#006666" align="center">供應商</td>
				<td width="70" style="color:#006666" align="center">收貨員</td>
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'" <% if (rs.getInt("confirm_cnt")>0) out.println("title='簽核中'");%>>
			<td align="center">
		<% 
			if (rs.getDouble("received_quantity")==(rs.getDouble("return_quantity")+rs.getDouble("allocation_quantity")) || UserRoles.indexOf("TEW_BUYER") >=0 || UserRoles.indexOf("TEW_PC") >=0)
			{
				out.println("&nbsp;");
			}
			else
			{
		%>
			<input type="button" id="btn_<%=iCnt%>" value="修改" onClick='setUpdate("../jsp/TEWPOReceiveRevise.jsp?LINE=<%=iCnt%>&ID=<%=rs.getString("po_line_location_id")%>&LOT=<%=rs.getString("LOT_NUMBER")%>&RDATE=<%=rs.getString("RECEIVE_DATE").replace("-","")%>&DC=<%=rs.getString("DATE_CODE")%>&SEQ_ID=<%=rs.getString("seq_id")%>")' style="color:#FFFFFF;background-color:#006666;font-size:11px" <% if (rs.getInt("confirm_cnt")>0){out.println("style='width:0px;visibility:hidden'");}else{ out.println("style='visibility:visable'");}%> ><img id="img_<%=iCnt%>" border="0" src="images/updateicon_enabled.gif" <% if (rs.getInt("confirm_cnt")==0){out.println(" width='0' style='visibility:hidden'");}else{ out.println(" width='20' style='visibility:visable'");}%>>		
		<%
			}
		%>
			</td>
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
			<td align="center"><%=rs.getString("RECEIVE_DATE")%></td>
			<td style="font-size:10px"><%=rs.getString("ITEM_NAME")%></td>
			<td style="font-size:10px"><%=rs.getString("ITEM_DESC")%></td>
			<td><%=rs.getString("LOT_NUMBER")%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RECEIVED_QUANTITY")))%></td>
		<%
			if (rs.getFloat("ALLOT_QUANTITY")>0)
			{
		%>			
			<td align="right"><a style='color:#0000ff' href='javaScript:POAllotQuery("<%=rs.getString("SEQ_ID")%>")'><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ALLOT_QUANTITY")))%></a></td>
		<%
			}
			else
			{
				out.println("<td align='right'>"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ALLOT_QUANTITY")))+"</td>");
			}
		%>
		<%
			if (rs.getFloat("SHIPPED_QUANTITY")>0)
			{
		%>			
			<td align="right"><a style='color:#0000ff' href='javaScript:POShippedQuery("<%=rs.getString("SEQ_ID")%>")'><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIPPED_QUANTITY")))%></a></td>
		<%
			}
			else
			{
				out.println("<td align='right'>"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIPPED_QUANTITY")))+"</td>");
			}
			if (rs.getFloat("RETURN_QUANTITY")>0)
			{
		%>
			<td align="right"><a style='color:#ff0000' href='javaScript:ReturnToVendorQuery("<%=rs.getString("SEQ_ID")%>")'><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RETURN_QUANTITY")))%></a></td>
		<%
			}
			else
			{
				out.println("<td align='right'>"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RETURN_QUANTITY")))+"</td>");
			}
			out.println("<td align='right'>"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ALLOCATION_QUANTITY")))+"</td>");
		%>		
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ONHAND")))%></td>
			<td><%=rs.getString("DATE_CODE")%></td>
			<td align="center"><%=(rs.getString("ORDER_NUMBER")==null?"&nbsp;":rs.getString("ORDER_NUMBER"))%></td>
			<td style="font-size:10px"><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%></td>
			<td align="center"><%=rs.getString("PO_NO")%></td>
			<td align="center"><%=rs.getString("line_num")%></td>
			<td align="center"><%=rs.getString("need_by_date")%></td>
			<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
			<td><%=(rs.getString("no_match_fifo_reason")==null?"&nbsp;":rs.getString("no_match_fifo_reason"))%></td>
			<td align="center"><%=rs.getString("CURRENCY_CODE")%></td>
			<td><font style="font-size:11px"><%=rs.getString("VENDOR_NAME")%></font></td>
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

