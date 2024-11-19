<!--20180912 Peggy,新增"類別"欄位 -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	if  ((document.MYFORM.TRANS_TYPE.value =="" || document.MYFORM.TRANS_TYPE.value=="--") && document.MYFORM.WIP_NO.value==""&& document.MYFORM.REQUEST_NO.value=="" && document.MYFORM.PICK_NO.value=="" && document.MYFORM.LOT.value=="" && document.MYFORM.ITEM_NAME.value=="" 
	&& document.MYFORM.YEARFR.value=="--" && document.MYFORM.MONTHFR.value=="--" && document.MYFORM.DAYFR.value=="--" && document.MYFORM.YEARTO.value=="--" && document.MYFORM.MONTHTO.value=="--" && document.MYFORM.DAYTO.value=="--"
    && document.MYFORM.ERPYEARFR.value=="--" && document.MYFORM.ERPMONTHFR.value=="--" && document.MYFORM.ERPDAYFR.value=="--" && document.MYFORM.ERPYEARTO.value=="--" && document.MYFORM.ERPMONTHTO.value=="--" && document.MYFORM.ERPDAYTO.value=="--")
	{
		alert("請輸入查詢條件!!");
		return false;
	}	 
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setChange()
{
	document.MYFORM.YEARFR.value="--";
	document.MYFORM.MONTHFR.value="--";
	document.MYFORM.DAYFR.value="--";
	document.MYFORM.YEARTO.value="--";
	document.MYFORM.MONTHTO.value="--";
	document.MYFORM.DAYTO.value="--";
	document.MYFORM.ERPYEARFR.value="--";
	document.MYFORM.ERPMONTHFR.value="--";
	document.MYFORM.ERPDAYFR.value="--";
	document.MYFORM.ERPYEARTO.value="--";
	document.MYFORM.ERPMONTHTO.value="--";
	document.MYFORM.ERPDAYTO.value="--";
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>TSA01 WIP Issue or Return Lot  Query</title>
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
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
String colorStr = "";

String dateStartType="";
String dateEndType="";
String YearFr=request.getParameter("YEARFR");
//dateBean.setAdjDate(-1);
if (YearFr ==null) YearFr ="";
if (YearFr.equals("--")){YearFr ="";}else{dateStartType +="yyyy";}
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null) MonthFr = "";
if (MonthFr.equals("--")){MonthFr ="";}else{	dateStartType +="mm";}
String DayFr=request.getParameter("DAYFR");
if (DayFr == null) DayFr = "";
if (DayFr.equals("--")){DayFr ="";}else{dateStartType +="dd";}
String dateSetBegin=YearFr+MonthFr+DayFr;  
dateSetBegin.replace("--","");
//dateBean.setAdjDate(1);
String YearTo=request.getParameter("YEARTO");
if (YearTo == null) YearTo = "";
if (YearTo.equals("--")){YearTo ="";}else{dateEndType +="yyyy";}
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null) MonthTo = "";
if (MonthTo.equals("--") ){MonthTo ="";}else{dateEndType +="mm";}
String DayTo=request.getParameter("DAYTO");
if (DayTo == null) DayTo = "";
if (DayTo.equals("--")){DayTo ="";}else{ dateEndType +="dd";}
String dateSetEnd = YearTo+MonthTo+DayTo; 

String ERPdateStartType="";
String ERPdateEndType="";
String ERPYearFr=request.getParameter("ERPYEARFR");
if (ERPYearFr ==null) ERPYearFr = dateBean.getYearString();
if (ERPYearFr.equals("--"))
{
	ERPYearFr ="";
}
else
{
	ERPdateStartType +="yyyy";
}
String ERPMonthFr=request.getParameter("ERPMONTHFR");
if (ERPMonthFr ==null) ERPMonthFr = dateBean.getMonthString();
if (ERPMonthFr.equals("--"))
{
	ERPMonthFr ="";
}
else
{	
	ERPdateStartType +="mm";
}
String ERPDayFr=request.getParameter("ERPDAYFR");
if (ERPDayFr == null) ERPDayFr = dateBean.getDayString();
if (ERPDayFr.equals("--"))
{
	ERPDayFr ="";
}
else
{
	ERPdateStartType +="dd";
}
String ERPdateSetBegin=ERPYearFr+ERPMonthFr+ERPDayFr;  
ERPdateSetBegin.replace("--","");
//dateBean.setAdjDate(1);
String ERPYearTo=request.getParameter("ERPYEARTO");
if (ERPYearTo == null) ERPYearTo = dateBean.getYearString();
if (ERPYearTo.equals("--"))
{
	ERPYearTo ="";
}
else
{
	ERPdateEndType +="yyyy";
}
String ERPMonthTo=request.getParameter("ERPMONTHTO");
if (ERPMonthTo ==null) ERPMonthTo = dateBean.getMonthString();
if (ERPMonthTo.equals("--"))
{
	ERPMonthTo ="";
}
else
{
	ERPdateEndType +="mm";
}
String ERPDayTo=request.getParameter("ERPDAYTO");
if (ERPDayTo == null) ERPDayTo = dateBean.getDayString();
if (ERPDayTo.equals("--"))
{
	ERPDayTo ="";
}
else
{ 
	ERPdateEndType +="dd";
}
String ERPdateSetEnd = ERPYearTo+ERPMonthTo+ERPDayTo; 


String TRANS_TYPE=request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String WIP_NO=request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String ITEM_NAME=request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String REQUEST_NO=request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String PICK_NO=request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String LOT=request.getParameter("LOT");
if (LOT==null) LOT="";
String COMP_TYPE=request.getParameter("COMP_TYPE");  //add by Peggy 20180912
if (COMP_TYPE==null) COMP_TYPE="";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50;
String sql="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPWareHouseHistoy.jsp'" METHOD="post" NAME="MYFORM">
<font color="#006666" size="+2" face="Times New Roman"> 
<strong>A01工單領退料明細查詢</strong></font>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td width="6%"><font color="#006666" ><strong>領料單號</strong></font></td> 
		<td width="12%"><input type="text" name="REQUEST_NO" value="<%=REQUEST_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange()" size="15"></td> 
		<td width="6%"><font color="#006666" ><strong>交易類型</strong></font></td>   
		<td width="8%">
		<%
		try
		{   
			sql = "select a.type_value,a.type_name from oraddman.tsa01_base_setup a where a.type_code='REQ_TYPE'";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TRANS_TYPE);
			comboBoxBean.setFieldName("TRANS_TYPE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>		
		</td>    
		<td width="6%"><font color="#006666" ><strong>類別</strong></font></td>   
		<td width="8%">
		<%
		try
		{   
			sql = "SELECT a.comp_type_no, a.comp_type_name from oraddman.tsa01_component_type a order by a.comp_type_no";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(COMP_TYPE);
			comboBoxBean.setFieldName("COMP_TYPE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>		
		</td>    
		<td width="6%"><font color="#006666" ><strong>工單號碼</strong></font></td>
	    <td width="12%"><input type="text" name="WIP_NO" value="<%=WIP_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange()" size="15"></td>
	    <td width="6%"><font color="#006666" ><strong>撿貨單號</strong></font></td> 
		<td width="12%"><input type="text" name="PICK_NO" value="<%=PICK_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange()" size="15"></td> 
		<td width="6%"><strong><font color="#006666">LOT</font></strong></td>   
		<td width="12%"><input type="text" name="LOT" value="<%=LOT%>" style="font-family:Tahoma,Georgia;" size="15"></td>
		
	</tr>
	<TR>
	    <td><div align="left"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgPart"/>
	    </strong></font></div></td>
	    <td><input type="text" name="ITEM_NAME" size="15" value="<%=ITEM_NAME%>"  style="font-family:Tahoma,Georgia;"></td> 
		<td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font></td>
		<td colspan="5">
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
    	out.println("Exception1:"+e.getMessage());
    }
%>    
		</td> 
		<td><font color="#006666" ><strong>ERP交易日</strong></font></td>
		<td colspan="3">
<%
	String ERPCurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
		if (ERPYearFr==null)
		{
		    ERPCurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(ERPCurrYear);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(ERPYearFr);
		}
		arrayComboBoxBean.setFieldName("ERPYEARFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
		  
	String ERPCurrMonth = null;	     		 
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
	  	if (ERPMonthFr==null)
	  	{
			ERPCurrMonth=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(ERPCurrMonth);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(ERPMonthFr);
	  	}
		arrayComboBoxBean.setFieldName("ERPMONTHFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception2:"+e.getMessage());
    }

	String ERPCurrDay = null;	     		 
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
		if (ERPDayFr==null)
		{
			ERPCurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(ERPCurrDay);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(ERPDayFr);
		}
		arrayComboBoxBean.setFieldName("ERPDAYFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}	
%>
		~</strong></font>
<%
	String ERPCurrYearTo = null;	     		 
	try
    {  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
	  	if (ERPYearTo==null)
	  	{
			ERPCurrYearTo=dateBean.getYearString();
			arrayComboBoxBean.setSelection(ERPCurrYearTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(ERPYearTo);
	  	}
		arrayComboBoxBean.setFieldName("ERPYEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
	}
    catch (Exception e)
    {
    	out.println("Exception4:"+e.getMessage());
    }
	
	String ERPCurrMonthTo = null;	     		 
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
	  	if (ERPMonthTo==null)
	  	{
			ERPCurrMonthTo=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(ERPCurrMonthTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(ERPMonthTo);
	  	}
		arrayComboBoxBean.setFieldName("ERPMONTHTO");	   
		out.println(arrayComboBoxBean.getArrayString());		    
	}
	catch (Exception e)
	{
		out.println("Exception5:"+e.getMessage());
	}
	
	String ERPCurrDayTo = null;	     		 
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
		if (ERPDayTo==null)
		{
			ERPCurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(ERPCurrDayTo);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(ERPDayTo);
		}
		arrayComboBoxBean.setFieldName("ERPDAYTO");	   
    	out.println(arrayComboBoxBean.getArrayString());	
	}
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
%>    
		</td>  
	</tr>
	<tr>  
		<td colspan="12" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPWareHouseHistoy.jsp")' > 
			&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value="EXCEL" onClick='setExportXLS("../jsp/TSA01WIPWareHouseExcel.jsp")' style="font-family: Tahoma,Georgia;" > 
		</td>
   </tr>
</table>  
<br>
<%
try
{       	 

	int iCnt = 0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	sql = " SELECT A.REQUEST_NO"+
	      ",A.REQUEST_TYPE"+
		  ",E.TYPE_NAME REQUEST_TYPE_NAME"+
		  ",A.WIP_ENTITY_NAME"+
		  ",D.ORGANIZATION_CODE"+
		  ",A.ORGANIZATION_ID"+
		  ",A.ITEM_NAME"+
		  ",A.CREATED_BY"+
		  ",TO_CHAR(A.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE"+
		  ",B.LINE_NO"+
		  ",B.COMP_TYPE_NO"+
		  ",F.COMP_TYPE_NAME"+
		  ",C.COMPONENT_NAME"+
		  ",C.UOM"+
		  ",C.SUBINVENTORY_CODE"+
		  ",C.LOT_NUMBER"+
		  ",C.LOT_QTY"+
		  ",b.PICK_NO"+
		  ",TO_CHAR(C.EXPIRATION_DATE,'yyyy-mm-dd') EXPIRATION_DATE"+
		  ",B.INV_WORKED_BY"+
		  ",TO_CHAR(B.INV_WORK_DATE,'yyyy-mm-dd hh24:mi') INV_WORK_DATE"+
		  ",row_number() over (partition by a.organization_id order by A.WIP_ENTITY_NAME desc,A.REQUEST_NO desc,B.LINE_NO desc) tot_cnt"+
		  ",C.TRANSFER_SUBINVENTORY"+
		  ",G.REMARKS LOT_REMARKS"+
          " FROM ORADDMAN.TSA01_REQUEST_HEADERS_ALL A"+
		  ",ORADDMAN.TSA01_REQUEST_LINES_ALL B"+
		  ",ORADDMAN.TSA01_REQUEST_LINE_LOTS_ALL C"+
		  ",INV.MTL_PARAMETERS D"+
          ",(select * from oraddman.tsa01_base_setup where type_code='REQ_TYPE') E"+
		  ",ORADDMAN.TSA01_COMPONENT_TYPE F"+
		  ",ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL G"+
          " WHERE A.REQUEST_NO=B.REQUEST_NO"+
          " AND B.REQUEST_NO=C.REQUEST_NO"+
          " AND B.LINE_NO=C.LINE_NO"+
          " AND A.ORGANIZATION_ID=D.ORGANIZATION_ID"+
          " AND A.REQUEST_TYPE=E.TYPE_VALUE"+
          " AND B.COMP_TYPE_NO=F.COMP_TYPE_NO"+
		  " AND C.REQUEST_NO=G.REQUEST_NO(+)"+
		  " AND C.LINE_NO=G.LINE_NO(+)"+
		  " AND C.COMPONENT_ITEM_ID=G.INVENTORY_ITEM_ID(+)"+
		  " AND C.LOT_NUMBER=G.LOT(+)"+
		  " AND C.LOT_QTY >0";
	if (TRANS_TYPE!=null && !TRANS_TYPE.equals("--") && !TRANS_TYPE.equals("")) sql += " and a.request_type='"+TRANS_TYPE+"'";
	if (COMP_TYPE!=null && !COMP_TYPE.equals("--") && !COMP_TYPE.equals("")) sql += " and b.comp_type_no='"+COMP_TYPE+"'"; //add by Peggy 20180912
	if (WIP_NO!=null && !WIP_NO.equals("")) sql += " and UPPER(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	if (REQUEST_NO!=null && !REQUEST_NO.equals("")) sql += " and a.REQUEST_NO LIKE '"+REQUEST_NO+"%'";
	if (PICK_NO!=null && !PICK_NO.equals("")) sql += " and b.PICK_NO like '"+ PICK_NO+"%'";
	if (LOT!=null && !LOT.equals("")) sql += " and c.LOT_NUMBER='"+ LOT+"'";
	if (ITEM_NAME!=null && !ITEM_NAME.equals("")) sql += " and (a.ITEM_NAME like '"+ ITEM_NAME +"%' or  b.COMPONENT_NAME like '"+ITEM_NAME +"%')";
	if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and a.creation_date >=to_date('"+dateSetBegin+"','"+dateStartType+"')";
	if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and a.creation_date <= to_date('"+dateSetEnd+"','"+dateEndType+"')+0.99999";
	if (ERPdateSetBegin!=null && !ERPdateSetBegin.equals("")) sql += " and B.INV_WORK_DATE >=to_date('"+ERPdateSetBegin+"','"+ERPdateStartType+"')";
	if (ERPdateSetEnd!=null && !ERPdateSetEnd.equals("")) sql += " and B.INV_WORK_DATE <= to_date('"+ERPdateSetEnd+"','"+ERPdateEndType+"')+0.99999";
	sql += " ORDER BY A.WIP_ENTITY_NAME,A.REQUEST_NO,B.LINE_NO";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
			//總筆數
			dataCnt = Long.parseLong(rs.getString("tot_cnt"));
			//最後頁數
			LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
				
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#CC0066' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
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
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPWareHouseHistoy.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPWareHouseHistoy.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPWareHouseHistoy.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPWareHouseHistoy.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");		
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
%> <br>

<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF"> 
	<tr bgcolor="#C9E2D0" height="30"> 
	  	<td width="5%" align="center">領料單號</td>
	  	<td width="4%" align="center">交易類型</td>
      	<td width="7%" align="center">工單號碼</td> 
      	<!--<td width="11%"align="center">料號</td> -->
      	<td width="5%" align="center">類別</td>
      	<td width="11%" align="center">原物料料號</td>
      	<td width="3%" align="center">組織</td>
      	<td width="4%" align="center">來源庫房</td>
      	<td width="4%" align="center">目的庫房</td>
      	<td width="8%" align="center">LOT</td>
      	<td width="7%" align="center">LOT備註</td>
      	<td width="4%" align="center">數量</td>
      	<td width="4%" align="center">單位</td>
      	<!--<td width="5%" align="center">有效日</td>-->
	  	<td width="6%" align="center">申請人</td>                    
	  	<td width="8%" align="center">申請日期</td>                    
	  	<td width="6%" align="center">撿貨單號</td>                    
	  	<td width="6%" align="center">倉庫人員</td>                    
	  	<td width="8%" align="center">ERP交易日</td>                    
    </tr>
    <% 
		}
		
		if ((iCnt) > sCnt && (iCnt) <= eCnt)
		{
   %>
		<tr id="tr_<%=iCnt%>" height="22" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center" style="font-size:11px"><%=rs.getString("REQUEST_NO")%></td>
			<td align="center" valign="middle" style="font-size:11px"><%=rs.getString("REQUEST_TYPE_NAME")%></td>
			<td align="center" style="font-size:11px"><%=rs.getString("WIP_ENTITY_NAME")%></td>
			<!--<td style="font-size:11px"><%=rs.getString("ITEM_NAME")%></td>-->
			<td style="font-size:11px"><%=rs.getString("COMP_TYPE_NAME")%></td>
			<td style="font-size:11px"><%=rs.getString("COMPONENT_NAME")%></td>
			<td style="font-size:11px" align="center"><%=rs.getString("ORGANIZATION_CODE")%></td>
			<td style="font-size:11px" align="center"><%=(rs.getString("SUBINVENTORY_CODE")==null?"&nbsp;":rs.getString("SUBINVENTORY_CODE"))%></td>
			<td style="font-size:11px" align="center"><%=(rs.getString("TRANSFER_SUBINVENTORY")==null?"&nbsp;":rs.getString("TRANSFER_SUBINVENTORY"))%></td>
			<td style="font-size:11px"><%=rs.getString("LOT_NUMBER")%></td>
			<td style="font-size:11px"><%=(rs.getString("LOT_REMARKS")==null?"&nbsp;":rs.getString("LOT_REMARKS"))%></td>
			<td style="font-size:11px" align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("LOT_QTY")))%></td>
			<td style="font-size:11px" align="center"><%=rs.getString("UOM")%></td>
			<!--<td style="font-size:11px" align="center"><%=(rs.getString("EXPIRATION_DATE")==null?"&nbsp;":rs.getString("EXPIRATION_DATE"))%></td>-->
			<td style="font-size:11px" align="center"><%=rs.getString("CREATED_BY")%></td>
			<td style="font-size:11px" align="center"><%=rs.getString("CREATION_DATE")%></td>
			<td style="font-size:11px" align="center"><%=(rs.getString("PICK_NO")==null?"&nbsp;":rs.getString("PICK_NO"))%></td>
			<td style="font-size:11px" align="center"><%=(rs.getString("INV_WORKED_BY")==null?"&nbsp;":rs.getString("INV_WORKED_BY"))%></td>
			<td style="font-size:11px" align="center"><%=(rs.getString("INV_WORK_DATE")==null?"&nbsp;":rs.getString("INV_WORK_DATE"))%></td>
		</tr>
	<%
		}
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font>");
	}
	else
	{
%>
</table>
</td>
</tr>
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

