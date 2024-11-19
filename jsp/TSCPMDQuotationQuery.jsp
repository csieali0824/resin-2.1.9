<!--20161106,新增PRD外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function changeURL(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function changeEvent1()
{
	document.MYFORM.YEARFR.value = "--";
	document.MYFORM.YEARTO.value = "--";
	document.MYFORM.MONTHFR.value = "--";
	document.MYFORM.MONTHTO.value = "--";
	document.MYFORM.DAYFR.value = "--";
	document.MYFORM.DAYTO.value = "--";
}
function changeEvent()
{
	var docNo = document.MYFORM.REQUESTNO.value;
	if (docNo.length >=3)
	{
		var year = docNo.substring(1,3);
		var year = "20"+year;
		try
		{
			document.MYFORM.YEARFR.value = year;
			document.MYFORM.YEARTO.value = year;
		}
		catch(err)
		{
			document.MYFORM.YEARFR.value = "--";
			document.MYFORM.YEARTO.value = "--";
		}
	}
	if (docNo.length >=5)
	{
		var months = docNo.substring(3,5);
		try
		{
			document.MYFORM.MONTHFR.value = months;
			document.MYFORM.MONTHTO.value = months;
		}
		catch(err)
		{
			document.MYFORM.MONTHFR.value = "--";
			document.MYFORM.MONTHTO.value = "--";
		}
	}
	if (docNo.length >=7)
	{
		var day = docNo.substring(5,7);
		try
		{
			document.MYFORM.DAYFR.value = day;
			document.MYFORM.DAYTO.value = day;
		}
		catch(err)
		{
			document.MYFORM.DAYFR.value = "--";
			document.MYFORM.DAYTO.value = "--";
		}
	}	
	return;
}
function rdojs(objtype)
{
	if (objtype=="3")
	{
		/*document.MYFORM.REQUESTNO.value="";
		document.MYFORM.STATUS.value="--";
		document.MYFORM.YEARFR.value="--";
		document.MYFORM.MONTHFR.value="--";
		document.MYFORM.DAYFR.value="--";
		document.MYFORM.YEARTO.value="--";
		document.MYFORM.MONTHTO.value="--";
		document.MYFORM.DAYTO.value="--";		
		document.MYFORM.REQUESTNO.disabled=true;
		document.MYFORM.STATUS.disabled=true;
		document.MYFORM.YEARFR.disabled=true;
		document.MYFORM.MONTHFR.disabled=true;
		document.MYFORM.DAYFR.disabled=true;
		document.MYFORM.YEARTO.disabled=true;
		document.MYFORM.MONTHTO.disabled=true;
		document.MYFORM.DAYTO.disabled=true;*/
		document.MYFORM.submit2.style.visibility="visible"; 	
		document.MYFORM.HIS_FLAG.style.visibility="visible";
		document.getElementById("span1").style.visibility="visible"; 	
	}
	else
	{
		/*document.MYFORM.REQUESTNO.disabled=false;
		document.MYFORM.STATUS.disabled=false;
		document.MYFORM.YEARFR.disabled=false;
		document.MYFORM.MONTHFR.disabled=false;
		document.MYFORM.DAYFR.disabled=false;
		document.MYFORM.YEARTO.disabled=false;
		document.MYFORM.MONTHTO.disabled=false;
		document.MYFORM.DAYTO.disabled=false;*/
		document.MYFORM.submit2.style.visibility="hidden"; 	
		document.MYFORM.HIS_FLAG.style.visibility="hidden"; 	
		document.getElementById("span1").style.visibility="hidden";
	}
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
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}            
.style2 {
	color: #FFFFFF;
	font-weight: bold;
}
</STYLE>
<title>外包PO單價查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String colorStr = "";

String dateStartType="";
String dateEndType="";
String BaseOption=request.getParameter("BaseOption");
if (BaseOption==null) BaseOption="1";
String YearFr=request.getParameter("YEARFR");
if (YearFr ==null)
{
	if (!BaseOption.equals("3"))
	{
		YearFr = dateBean.getYearString();
	}
	else
	{
		YearFr = "--";
	}
}
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null)
{
	if (!BaseOption.equals("3"))
	{
		MonthFr =dateBean.getMonthString();
	}
	else
	{
		MonthFr ="--";
	}
}
String DayFr=request.getParameter("DAYFR");
if (DayFr == null) DayFr = "--";
String YearTo=request.getParameter("YEARTO");
if (YearTo == null) YearTo = "--";
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null) MonthTo = "--";
String DayTo=request.getParameter("DAYTO");
if (DayTo == null) DayTo = "--";
String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String REQUESTNO=request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 100;
String HIS_FLAG=request.getParameter("HIS_FLAG");
if (HIS_FLAG==null) HIS_FLAG="N";
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCPMDOEMInformationQuery.jsp" METHOD="post" NAME="MYFORM">
<font color="#006666" size="+2" face="Times New Roman"> 
<strong>外包PO單價<jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td width="8%" bgcolor="99CCFF"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgVendor"/></strong></font></td> 
		<td width="15%"><input type="text" name="VENDOR" value="<%=VENDOR%>" size="25" style="font-family:Tahoma,Georgia;" onKeyUp="changeEvent1()"></td>
        <td width="8%" bgcolor="99CCFF"><div align="left"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgPart"/>或<jsp:getProperty name="rPH" property="pgItemDesc"/></strong></font></div></td>
	    <td width="15%"><input type="text" name="ITEMNAME" size="25" value="<%=ITEMNAME%>"  style="font-family:Tahoma,Georgia;" onKeyUp="changeEvent1()"></td> 
	    <td width="8%" bgcolor="99CCFF"><font color="#006666" ><strong>申請單號</strong></font></td> 
		<td width="28%" ><div align="left"><font color="#006666" ><strong> </strong></font><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>"  style="font-family:Tahoma,Georgia;" onKeyUp="changeEvent()" <%=(BaseOption.equals("3")?"disabled":"")%>></div></td> 
		<td width="8%" bgcolor="99CCFF"><font color="#006666" ><strong>申請狀態</strong></font></td>   
		<td width="10%" colspan="1" nowrap><div align="left">   
<%
	try
	{   
		Statement statement=con.createStatement();
		String sql = " select TYPE_NAME,TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
					 " where DATA_TYPE ='F2_ACTION' AND NVL(STATUS_FLAG,'I') = 'A' "; 
		ResultSet rs=statement.executeQuery(sql);
		out.println("<select NAME='STATUS' style='font-family:ARIAL' "+(BaseOption.equals("3")?"disabled":"")+">");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
			if (s1==STATUS || s1.equals(STATUS)) 
			{
				out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
			} 
			else 
			{
				out.println("<OPTION VALUE='"+s1+"'>"+s2);
			}        
		} 
		statement.close();		  		  
		rs.close();        	 
	} 
	catch (Exception e) 
	{ 
		out.println("Exception1:"+e.getMessage()); 
	} 		
%>
		</div>
		</td>   
	</tr>
	<tr>
		<td nowrap bgcolor="99CCFF"><font color="#006666" ><strong>申請日期</strong></font></td>
		<td nowrap colspan="3"><font color="#006666" >
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2012+1];
		for (int i = 2012; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
		if (BaseOption.equals("3"))
		{   
			out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));		      		 
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());		      		 
		}
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
		if (BaseOption.equals("3"))
		{   
			out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));		      		 
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());
		}
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
		if (BaseOption.equals("3"))
		{   
			out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));		      		 
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());
		}
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
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2012+1];
		for (int i = 2012; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
		if (BaseOption.equals("3"))
		{   
	        out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));		      		 
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());
		}
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
		if (BaseOption.equals("3"))
		{   
			out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));		    
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());
		}
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
		if (BaseOption.equals("3"))
		{   
	    	out.println((arrayComboBoxBean.getArrayString()).replace("style='font-size:12'>","style='font-size:12' disabled>"));	
		}
		else
		{
			out.println(arrayComboBoxBean.getArrayString());
		}
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>    
		</td>  
		<td nowrap bgcolor="99CCFF"><font color="#006666"><strong>查詢類型</strong></font></td>
		<td>
			<input type="radio" name="BaseOption" value="1" <%if (BaseOption.equals("1")) out.println("checked"); else out.println("");%>  onClick="rdojs('1')"><label for="no">申請單</label>
			<input type="radio" name="BaseOption" value="2" <%if (BaseOption.equals("2")) out.println("checked"); else out.println("");%>  onClick="rdojs('2')"><label for="no">申請明細</label>
			<input type="radio" name="BaseOption" value="3" <%if (BaseOption.equals("3")) out.println("checked"); else out.println("");%>  onClick="rdojs('3')"><label for="no">價格表</label>
			<input type="checkbox" name="HIS_FLAG" value="Y" <%if (BaseOption.equals("3")) out.println("style='visibility:visible'"); else out.println("style='visibility:hidden'");%>><span id="span1" <%if (BaseOption.equals("3")) out.println("style='visibility:visible'"); else out.println("style='visibility:hidden'");%>>包含歷史價格</span>
		</td>
		<td colspan="2">
		    <INPUT TYPE="button" align="middle"  name="submit1" value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCPMDQuotationQuery.jsp")' > 
			&nbsp;&nbsp;
			<INPUT TYPE="button" name="submit2" value="匯出EXCEL" style="font-family:ARIAL" onClick="setExportXLS('../jsp/TSCPMDQuotationExcel.jsp')"  <%=(!BaseOption.equals("3")?"style='visibility:hidden'":"")%>>
		</td>
   </tr>
</table>  
<%
try
{       	 

	int iCnt = 0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0,iseq=0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	String sql = "";
	if (BaseOption.equals("3"))
	{
		sql = " select a.VENDOR_NAME,a.INVENTORY_ITEM_NAME,c.description,min(a.START_QTY)||' - '||max(a.END_QTY) QTY_RANGE,a.UOM,a.UNIT_PRICE,b.INVOICE_CURRENCY_CODE CURRENCY_CODE,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE,d.CREATED_BY_NAME,d.request_no"+
		      " from oraddman.tspmd_item_quotation a,ap.ap_supplier_sites_all b,inv.mtl_system_items_b c,"+
    		  " (select x.* from (select a.REQUEST_NO, a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,a.CREATED_BY_NAME,min(b.START_QTY) || ' - '|| max(b.END_QTY) QTY_RANGE,b.UNIT_PRICE,row_number() over (partition by a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,b.UNIT_PRICE order by b.LAST_UPDATE_DATE desc) seq_no"+
		      " from oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
 		      " where b.STATUS='Approved' "+
		      " and a.request_no=b.request_no "+
			  " group by a.REQUEST_NO, a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,a.CREATED_BY_NAME,b.UNIT_PRICE,b.LAST_UPDATE_DATE) x where seq_no=1) d "+
		      " where a.vendor_site_id=b.vendor_site_id "+
		      " and a.inventory_item_id=c.inventory_item_id"+
		      " and c.organization_id=49"+
		      " and a.vendor_site_id=d.vendor_site_id"+
		      " and a.inventory_item_id=d.inventory_item_id "+
		      " and a.UNIT_PRICE=d.UNIT_PRICE";
		if (VENDOR!=null && !VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR+"%'";
		if (ITEMNAME!=null && !ITEMNAME.equals("")) sql += " and (c.description like '"+ ITEMNAME +"%' or  b.inventory_item_name like '"+ITEMNAME +"%')";
		sql += " group by a.VENDOR_NAME,a.INVENTORY_ITEM_NAME,c.description,a.UOM,a.UNIT_PRICE,b.INVOICE_CURRENCY_CODE ,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi'),d.CREATED_BY_NAME ,d.request_no"+
		      " order by a.VENDOR_NAME,a.INVENTORY_ITEM_NAME";
	}
	else
	{
		if (BaseOption.equals("1"))
		{
			sql = " SELECT distinct a.request_no,'('|| a.vendor_code||') ' || a.vendor_name vendor_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.created_by_name, "+
				  " to_char(a.approve_date,'yyyy-mm-dd hh24:mi') approve_date, a.approved_by_name, a.status FROM oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
				  " where a.request_no = b.request_no";
		}
		else
		{
			sql = " SELECT a.request_no, '('|| a.vendor_code||') ' || a.vendor_name vendor_name, b.inventory_item_name,b.item_description,b.unit_price,a.currency_code,b.start_date ||'~'|| b.end_date availdate,"+
				  " to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.created_by_name,nvl(b.start_qty,0) || ' - ' || nvl(b.end_qty,0) range_qty, b.uom,"+
				  " to_char(a.approve_date,'yyyy-mm-dd hh24:mi') approve_date, a.approved_by_name, a.status FROM oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
				  " where a.request_no = b.request_no";
		}
		if (VENDOR!=null && !VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR+"%'";
		if (REQUESTNO!=null && !REQUESTNO.equals("")) sql += " and a.REQUEST_NO LIKE '"+REQUESTNO+"%'";
		if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) sql += " and a.STATUS='"+ STATUS+"'";
		if (ITEMNAME!=null && !ITEMNAME.equals("")) sql += " and (b.item_description like '"+ ITEMNAME +"%' or  b.inventory_item_name like '"+ITEMNAME +"%')";
		//if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and to_char(a.creation_date,'"+dateStartType+"') >='"+dateSetBegin+"'";
		//if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and to_char(a.creation_date,'"+dateEndType+"') <='"+dateSetEnd+"'";
		if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
		{
			sql += " AND to_char(a.creation_date,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2012":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
		}
		if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
		{
			sql += " AND to_char(a.creation_date,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
		}
		sql += " order by a.request_no ";
	}
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
			String sqlt = " select count(1) rowcnt from ("+sql+") ss";
			Statement statement1=con.createStatement(); 
			ResultSet rs1 =statement1.executeQuery(sqlt);
			while (rs1.next())
			{
				//總筆數
				dataCnt = Long.parseLong(rs1.getString("rowcnt"));
				//最後頁數
				LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
			}
			rs1.close();
			statement1.close();
				
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#1144BB' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			if (LastPage==1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}
			else if (NowPage == 1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
			}
			else if (NowPage == LastPage)
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}				
			else
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
			}
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationQuery.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationQuery.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#1144BB' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationQuery.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationQuery.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");		
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
		%> 
		<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
			<tr bgcolor="#99CCFF"> 
			<%
			if (BaseOption.equals("1"))	
			{
			%>
				<td width="2%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;</font></div></td> 
				<td width="4%" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;&nbsp;</font></div></td> 
				<td width="8%" nowrap><div align="center"><font color="#006666">申請單號</font></div></td>
				<td width="18%" nowrap><div align="center"><font color="#006666">廠商名稱</font></div></td>
				<td width="4%" nowrap><div align="center"><font color="#006666">幣別</font></div></td>            
				<td width="6%" nowrap><div align="center"><font color="#006666">申請狀態</font></div></td> 
				<td width="58%" nowrap><div align="center"><font color="#006666">簽核歷程</font></div></td>
			<%
			}
			else if (BaseOption.equals("3"))
			{
			%>
				<td width="3%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;</font></div></td> 
				<td width="20%" nowrap><div align="center"><font color="#006666">廠商名稱</font></div></td>
				<td width="15%" nowrap><div align="center"><font color="#006666">料號</font></div></td>            
				<td width="12%" nowrap><div align="center"><font color="#006666">品名</font></div></td>            
				<td width="8%" nowrap><div align="center"><font color="#006666">起訖訂單量</font></div></td>
				<td width="4%" nowrap><div align="center"><font color="#006666">單位</font></div></td>
				<td width="7%" nowrap><div align="center"><font color="#006666">單價</font></div></td>            
				<td width="5%" nowrap><div align="center"><font color="#006666">幣別</font></div></td>            
				<td width="10%" nowrap><div align="center"><font color="#006666">申請日期</font></div></td>
				<td width="8%" nowrap><div align="center"><font color="#006666">申請人</font></div></td>
				<td width="7%" nowrap><div align="center"><font color="#006666">申請單號</font></div></td>
				
			<%
			}
			else
			{
			%>
				<td width="3%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;</font></div></td> 
				<td width="7%" nowrap><div align="center"><font color="#006666">申請單號</font></div></td>
				<td width="17%" nowrap><div align="center"><font color="#006666">廠商名稱</font></div></td>
				<td width="13%" nowrap><div align="center"><font color="#006666">料號</font></div></td>            
				<td width="10%" nowrap><div align="center"><font color="#006666">品名</font></div></td>            
				<td width="8%" nowrap><div align="center"><font color="#006666">起訖訂單量</font></div></td>
				<td width="4%" nowrap><div align="center"><font color="#006666">單位</font></div></td>
				<td width="7%" nowrap><div align="center"><font color="#006666">單價</font></div></td>            
				<td width="5%" nowrap><div align="center"><font color="#006666">幣別</font></div></td>            
				<td width="10%" nowrap><div align="center"><font color="#006666">申請日期</font></div></td>
				<td width="9%" nowrap><div align="center"><font color="#006666">申請人</font></div></td>
				<td width="7%" nowrap><div align="center"><font color="#006666">申請狀態</font></div></td> 
			<%
			}
			%>                
			</tr>
		<% 
		}
		int iRow = 0; 	
		if ((iCnt) > sCnt && (iCnt) <= eCnt)
		{
			if ((showCnt % 2) == 0)
			{
				//colorStr = "99DDAA";'
				colorStr = "#DFDDDB";
			}
			else
			{
				//colorStr = "#FFCCCC"; 
				colorStr = "#F1CC99"; 
			}
    %>
		<tr bgcolor="<%=colorStr%>"> 
	<%
			if (BaseOption.equals("1"))	
			{
				String str_color="";
				if (rs.getString("status").equals("Submit") || rs.getString("status").equals("Approved"))
				{
					str_color="#FFCC00";
				}
				else if (rs.getString("status").equals("Reject"))
				{
					str_color="#CC0000";
				}
				else if (rs.getString("status").equals("Closed"))
				{
					str_color="#00CC66";
				}
				else if (rs.getString("status").equals("Cancelled"))
				{
					str_color="#CCCC88";
				}			
	%>
			<td bgcolor="#99CCFF" width="4%"><div align="center"><font  color="#006666"><%=iCnt%></font></div></td>
	<%
				if (rs.getString("status").equals("Reject"))
				{
	%>
			<td nowrap bgcolor="<%=str_color%>"><div align="center" title="點我,進入退件處理功能!"><A href='../jsp/TSCPMDQuotationCreate.jsp?ACTIONCODE=<%=rs.getString("status")%>&REQUESTNO=<%=rs.getString("REQUEST_NO")%>'><font color="#FFFFFF">退件處理</font></A></div></td>
	<%
				}
				else
				{
					out.println("<td nowrap bgcolor='"+str_color+"'>&nbsp;</td>");
				}
	%>
			<td nowrap><div align="center" title="點我,進入申請明細畫面!"><A href='../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO=<%=rs.getString("REQUEST_NO")%>'><font  color="#990099"><%=rs.getString("REQUEST_NO")%></font></A></div></td>
			<td nowrap><div align="left"><font  color="#0000FF"><%=rs.getString("VENDOR_NAME")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("CURRENCY_CODE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("status")%></font></div></td>
			<td>
	<%
				iseq=0;
				sql = " SELECT  a.action_name,c.type_name action_desc, to_char(a.action_date,'yyyy-mm-dd hh24:mi:ss')  action_date,a.actor, a.remark "+
					  " FROM oraddman.tspmd_action_history a"+
					  " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE ='F2_ACTION') b"+
					  " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE like 'F2-%') c"+
					  " where a.request_no ='" + rs.getString("REQUEST_NO")+"' and a.ACTION_NAME = b.type_name and b.type_no = c.type_no order by a.action_date";
				//out.println(sql);
				Statement statement1=con.createStatement(); 
				ResultSet rs1=statement1.executeQuery(sql);
				while (rs1.next()) 
				{ 
					if (iseq==0)
					{
					%>
					<table width="100%" border="1" bordercolordark="#FFFFFF" bordercolorlight="#999966" cellpadding="1" cellspacing="0">
						<tr bgcolor="#66CC99">
							<td width="15%">交易名稱</td>
							<td width="18%">交易日期</td>
							<td width="15%">交易人員</td>
							<td>備註說明</td>
						</tr>
					<%
					}
					out.println("<tr>");
					out.println("<td>"+rs1.getString("action_name")+"</td>");
					out.println("<td>"+rs1.getString("action_date")+"</td>");
					out.println("<td>"+rs1.getString("actor")+"</td>");
					out.println("<td>"+(rs1.getString("remark")==null?"&nbsp;":rs1.getString("remark"))+"</td>");
					out.println("</tr>");
					iseq++;
				}
				if (iseq>0)
				{
				%>
					</table>
				<%
				}
				rs1.close();  
				statement1.close();	
	%>
			</td>
	<%
			}
			else if (BaseOption.equals("3"))	
			{
	%>
			<td bgcolor="#99CCFF"><div align="center"><font  color="#006666"><%out.println(iCnt);%></font></div></td>
			<td nowrap><div align="left"><font  color="#0000FF"><%=rs.getString("VENDOR_NAME")%></font></div></td>
			<td nowrap><div align="left"><font  color="#000000"><%=rs.getString("INVENTORY_ITEM_NAME")%></font></div></td>
			<td nowrap><div align="left"><font  color="#000000"><%=rs.getString("DESCRIPTION")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("QTY_RANGE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("uom")%></font></div></td>
			<td nowrap><div align="right"><font  color="#000000"><%=(new DecimalFormat("##,##0.0##")).format(Float.parseFloat(rs.getString("unit_price")))%>&nbsp;</font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("CURRENCY_CODE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("CREATION_DATE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("created_by_name")%></font></div></td>
			<td nowrap><div align="center" title="點我,可進入申請明細畫面!"><A href='../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO=<%=rs.getString("REQUEST_NO")%>'><font  color="#990099"><%=rs.getString("REQUEST_NO")%></font></A></div></td>
	<%
			}
			else
			{
	%>
			<td bgcolor="#99CCFF"><div align="center"><font  color="#006666"><%out.println(iCnt);%></font></div></td>
			<td nowrap><div align="center" title="點我,可進入申請明細畫面!"><A href='../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO=<%=rs.getString("REQUEST_NO")%>'><font  color="#990099"><%=rs.getString("REQUEST_NO")%></font></A></div></td>
			<td nowrap><div align="left"><font  color="#0000FF"><%=rs.getString("VENDOR_NAME")%></font></div></td>
			<td nowrap><div align="left"><font  color="#000000"><%=rs.getString("inventory_item_name")%></font></div></td>
			<td nowrap><div align="left"><font  color="#000000"><%=rs.getString("item_description")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("range_qty")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("uom")%></font></div></td>
			<td nowrap><div align="right"><font  color="#000000"><%=(new DecimalFormat("##,##0.0##")).format(Float.parseFloat(rs.getString("unit_price")))%>&nbsp;</font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("CURRENCY_CODE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("CREATION_DATE")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("created_by_name")%></font></div></td>
			<td nowrap><div align="center"><font color="#000000"><%=rs.getString("status")%></font></div></td>
	<%
			}
	%>
		</tr>
<%
			showCnt++;
		}
	}
%>
	</table>
<%
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font>");
	}
	else
	{
		out.println("</td>");		
		out.println("</tr>");	
		out.println("</table>");	
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

