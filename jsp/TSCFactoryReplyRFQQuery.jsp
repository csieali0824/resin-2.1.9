<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setExportXLS(URL)
{    
	if (document.MYFORM.YEARFR.value =="" || document.MYFORM.YEARFR.value =="--")
	{
		alert("Please enter the start year!");
		document.MYFORM.YEARFR.focus(); 
		return false;
	}
	else if (document.MYFORM.YEARTO.value =="" || document.MYFORM.YEARTO.value =="--")
	{
		alert("Please enter the end year!");
		document.MYFORM.YEARTO.focus(); 
		return false;
	}
	else if (document.MYFORM.MONTHFR.value =="" || document.MYFORM.MONTHFR.value =="--")
	{
		alert("Please enter the start month!");
		document.MYFORM.MONTHFR.focus(); 
		return false;
	}	
	else if (document.MYFORM.MONTHTO.value =="" || document.MYFORM.MONTHTO.value =="--")
	{
		alert("Please enter the end month!");
		document.MYFORM.MONTHTO.focus(); 
		return false;
	}	
	else if (document.MYFORM.DAYFR.value =="" || document.MYFORM.DAYFR.value =="--")
	{
		alert("Please enter the start day!");
		document.MYFORM.DAYFR.focus(); 
		return false;
	}	
	else if (document.MYFORM.DAYTO.value =="" || document.MYFORM.DAYTO.value =="--")
	{
		alert("Please enter the end day!");
		document.MYFORM.DAYTO.focus(); 
		return false;
	}	
	
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
<title>Factory Reply RFQ</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<%
String YearFr=request.getParameter("YEARFR");
if (YearFr==null || YearFr.equals("--")) YearFr=dateBean.getYearString();
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null || MonthFr.equals("--")) MonthFr=dateBean.getMonthString();
String DayFr=request.getParameter("DAYFR");
if (DayFr==null || DayFr.equals("--")) DayFr="01";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null || YearTo.equals("--")) YearTo=dateBean.getYearString();
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null || MonthTo.equals("--")) MonthTo=dateBean.getMonthString();
String DayTo=request.getParameter("DAYTO");
if (DayTo==null || DayTo.equals("--")) DayTo=dateBean.getDayString();
String PLANTCODE= request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String sql="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWStockOverview.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">工廠回覆交期時間統計表</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='1' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1' bordercolor="#cccccc">
		  <td width="10%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">日期區間:</td>   
		    <td width="30%">
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
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
		</td>
		<td width="10%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">廠別:</td> 	
		<td width="50%">
		<%
		try
		{   
			sql = "select MANUFACTORY_NO,MANUFACTORY_NAME from  oraddman.tsprod_manufactory a where MANUFACTORY_NO in ('002','005','006','008','010','011')";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(12);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(PLANTCODE);
			comboBoxBean.setFieldName("PLANTCODE");	
			if (UserRoles.indexOf("admin")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY")<0  && UserName.indexOf("PERRY.JUAN")<0)
			{
				comboBoxBean.setOnChangeJS("this.value="+'"'+userProdCenterNo+'"');  
			}			   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>		
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSCFactoryReplyRFQReport.jsp")' > 
	</tr>
</table>
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

