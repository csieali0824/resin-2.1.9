<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%>--
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnTest2PoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="RepairPageHeaderBean" %-->
<!--jsp:useBean id="rPH" scope="application" class="RepairPageHeaderBean"/-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>(I6)Invoice Create for Hongkong</title>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function setSubmit(URL)
{   
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
}

function setSubmit2(URL)
{    
  flag=confirm("Confirm Create invoice for HK ? ");  
  if (flag) 
  {   
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
  }
  else
  { 
    return(false);
  } 
}

function rpIssueItemReport(pp)
{    
  subWin=window.open("RPIssueAppReportPrint.jsp?RPTXCOM="+pp);  
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">TSC(CN)</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Invoice Not Ship Confirm Query Program(HK)</strong></font>
<FORM ACTION="../jsp/DaphneInvoiceCN2HKSubmit.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 200;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
 %>
<A HREF="http://intranet.ts.com.tw/new/index.htm">回首頁</A> 
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     
     String [] addItems=request.getParameterValues("ADDITEMS");
     //String regionNo=request.getParameter("REGION");
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
     String DayFr=request.getParameter("DAYFR");
     String invoiceDate=YearFr+MonthFr+DayFr;
	 
	 String invoiceNo=request.getParameter("INVOICENO");
	 String custCharge=request.getParameter("CUSTCHARGE");
	 String freightCharge=request.getParameter("FREIGHTCHARGE");
	 String palletCharge=request.getParameter("PALLETCHARGE");	
	 String insuranceCharge=request.getParameter("INSURANCECHARGE");
	 String serviceItem=request.getParameter("SERVICEITEM"); 

  
     if (DayFr==null) { invoiceDate = dateBean.getYearMonthDay(); }  
     if (invoiceNo==null || invoiceNo.equals("")) { invoiceNo=""; };
	 if (custCharge==null || custCharge.equals("")) { custCharge=""; }; 
	 if (freightCharge==null || freightCharge.equals("")) { freightCharge=""; };
	 if (palletCharge==null || palletCharge.equals("")) { palletCharge=""; };
	 if (insuranceCharge==null || insuranceCharge.equals("")) { insuranceCharge=""; };
	 if (serviceItem==null || serviceItem.equals("")) { serviceItem=""; };
     
  %>
<table width="100%" border="0">
  <tr bgcolor="#339999">    
    <td bordercolor="#FFFFFF" nowrap colspan="2"><div align="center"><font color="#FFFF00"><strong>Please Input Invoice No.</strong></font>
        <input name="INVOICENO" type="text" value="<%=invoiceNo%>" size="20" maxlength="15"></div>
    </td>	
  </tr>
  <tr bgcolor="#339999">    
     <td width="38%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>Invoice Date</strong></font>
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
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
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
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
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
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
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>   
    <td width="32%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>CUSTOMS CHARGE</strong></font>
        <input name="CUSTCHARGE" type="text" value="<%=custCharge%>" size="20" maxlength="15">
    </td>
       
  </tr>
  <tr bgcolor="#339999">
    <td width="30%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>FREIGHT CHARGE</strong></font>
	    <input name="FREIGHTCHARGE" type="text" value="<%=freightCharge%>" size="20" maxlength="15">     
    </td>  
    <td width="38%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>PALLETISED CHARGE</strong></font>
       <input name="PALLETCHARGE" type="text" value="<%=palletCharge%>" size="20" maxlength="15">   
    </td>   
  </tr> 
  <tr bgcolor="#339999">
    <td width="38%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>INSURANCE CHARGE</strong></font>
       <input name="INSURANCECHARGE" type="text" value="<%=insuranceCharge%>" size="20" maxlength="15">   
    </td>          
    <td width="38%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>SERVICE ITEM</strong></font>
       <input name="SERVICEITEM" type="text" value="<%=serviceItem%>" size="20" maxlength="15">   
    </td>      
    
  </tr> 
  <tr>
    <td bordercolor="#FFFFFF" nowrap colspan="2"><div align="center">
    <font color="#FFFF00"><strong><input name="submit2" type="submit" value="Submit" onClick='return setSubmit2("../jsp/DaphneInvoiceCN2HKSubmit.jsp")'></strong></font>
     &nbsp;	
	<input name="submit1" type="reset" value='Reset'></div>
	</td> 
  </tr> 
</table>
<BR>

<div align="left"></div>
 <%  
   
 %>
</FORM>

</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnTest2Page.jsp"%>
<!--=================================-->
</html>
