<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function subWindowCustInfoFind(cust_No,cust_Name)
{ 
   if (event.keyCode==13)
   {    
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+cust_No+"&NAME="+cust_Name,"subwin");  
   }	
}
function setCustInfoFind(cust_No,cust_Name)
{      
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+cust_No+"&NAME="+cust_Name,"subwin");  
}
function subWindowItemFind(invItem,itemDesc)
{    
  subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function setItemFindCheck(invItem,itemDesc)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 
   }
}
function setBeginDateTypeCheck(date_Type)
{
   if (document.MYFORM.DATETYPE.value == null || document.MYFORM.DATETYPE.value == "--" || document.MYFORM.DATETYPE.value == "")
   { 
     alert("Date Type Can't be empty!!");
	 document.MYFORM.DATETYPE.focus();
   }
   else
   {
     gfPop.fPopCalendar(document.MYFORM.BEGINDATE);return false;
   }
}
function setEndDateTypeCheck()
{
   if (document.MYFORM.DATETYPE.value == null || document.MYFORM.DATETYPE.value == "--" || document.MYFORM.DATETYPE.value == "")
   { 
     alert("Date Type Can't be empty!!");
	 document.MYFORM.DATETYPE.focus();
   }
   else
   {
     gfPop.fPopCalendar(document.MYFORM.ENDDATE);return false;
   }
}
</script>

<html>
<head>
<title>Aven Test</title>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池============-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<% /* 宣告用 Block */
  String d_Type = "";
  String group_Name = request.getParameter("GROUP_NAME");
  String order_Type = request.getParameter("ORDERTYPE");
  String sales_Rep = request.getParameter("SALESREP");
  String date_Type = request.getParameter("DATETYPE");
  String begin_Date = request.getParameter("BEGINDATE");
  String end_Date = request.getParameter("ENDDATE");
  String item_No = request.getParameter("INVITEM");
  String item_Name = request.getParameter("ITEMDESC");
  String item_Spqp = request.getParameter("SPQP");
  String cust_ID=request.getParameter("CUSTOMERID");
  String cust_No = request.getParameter("CUSTOMERNO");
  String cust_Name = request.getParameter("CUSTOMERNAME");
  String cust_Active=request.getParameter("CUSTACTIVE");
  String custAROverdue = request.getParameter("CUSTOMERAROVERDUE");  
  String custAROverdueDesc = request.getParameter("AROVERDUEDESC");  
  String ordnum_From = request.getParameter("ORDNUMFROM");
  String ordnum_To = request.getParameter("ORDNUMTO");

  if (begin_Date == null || begin_Date.equals("")) begin_Date = dateBean.getYearMonthDay();
  if (end_Date == null || end_Date.equals("")) end_Date = dateBean.getYearMonthDay();
  if (cust_No == null || cust_No.equals("")) cust_No = "";
  if (cust_Name == null || cust_Name.equals("")) cust_Name = "";
  if (item_No == null || item_No.equals("")) item_No = "";
  if (item_Name == null || item_Name.equals("")) item_Name = "";
  if (ordnum_From == null || ordnum_From.equals("")) ordnum_From = "";
  if (ordnum_To == null || ordnum_To.equals("")) ordnum_To = "";
%>

<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">

<FORM ACTION="../jsp/aventest.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesOrder"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
  <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>

<table cellspacing='0' bordercolordark='#CCCC99'  cellpadding='1' width='100%' align='center' bordercolorlight='#ffffff' border='1'>
  <tr>
    <td width="19%" colspan="1" nowrap><font color="#006666" size="2"><strong>
      <jsp:getProperty name="rPH" property="pgFirmOrderType"/>
    </strong> </font> </td>
    <td><%
	      try
          {   
		    String a[] = {"ORDER","RETURN"};
			arrayComboBoxBean.setArrayString(a);
		    arrayComboBoxBean.setSelection("ORDER");
	        arrayComboBoxBean.setFieldName("ORDERTYPE");	   
            out.println(arrayComboBoxBean.getArrayString());     	 
          } //end of try		 
          catch (Exception e)
		  { 
		    out.println("Exception:"+e.getMessage());
		  }
	    %>    </td>
    <td width="19%" colspan="1" nowrap><font color="#006666" size="2"><strong>
      <jsp:getProperty name="rPH" property="pgSalesArea"/>
    </strong> </font> </td>
    <td><%
		  try
		  { //動態取Sales Group;
		    Statement stateGetP=con.createStatement();
            ResultSet rsGetP = null;				      									  
			String sqlGetP = " select GROUP_ID,GROUP_NAME " +
			                 " from APPS.TSC_OM_GROUP " +
							 " where org_id = 41 " +
			  		    	 " order by GROUP_NAME ";
            rsGetP = stateGetP.executeQuery(sqlGetP);
			comboBoxAllBean.setRs(rsGetP);
		    comboBoxAllBean.setSelection(group_Name);
	        comboBoxAllBean.setFieldName("GROUP_NAME");
            out.println(comboBoxAllBean.getRsString());
			stateGetP.close();
		    rsGetP.close();
	      } //end of try		 
          catch (Exception e)
		  { 
		    out.println("Exception:" + e.getMessage());
		  } 
		%>    </td>
  </tr>
  <tr>
    <td><font color="#006666" size="2"><strong>
      <jsp:getProperty name="rPH" property="pgSalesMan"/>
    </strong></font> </td>
    <td><%
		  try
          { // 動態取業務名
	        Statement stateGetP=con.createStatement();
            ResultSet rsGetP = null;				      									  
			String sqlGetP = " select SALESREP_ID, NAME AS SALESREP" +
  							 " from JTF.JTF_RS_SALESREPS " +
 							 " WHERE STATUS = 'A' " +
    						 " AND SALESREP_ID != -3 " +
   							 " AND SYSDATE BETWEEN START_DATE_ACTIVE " +
							 " AND NVL(END_DATE_ACTIVE,SYSDATE) " +
							 " ORDER BY NAME ";
            rsGetP = stateGetP.executeQuery(sqlGetP);
			comboBoxAllBean.setRs(rsGetP);
		    comboBoxAllBean.setSelection(sales_Rep);
	        comboBoxAllBean.setFieldName("SALESREP");
            out.println(comboBoxAllBean.getRsString());
			stateGetP.close();
		    rsGetP.close();
	      } //end of try		 
          catch (Exception e)
		  { 
		    out.println("Exception:" + e.getMessage());
		  } 
		%>    </td>
    <td><font color="#006666" size="2"><strong>
      <jsp:getProperty name="rPH" property="pgDateType"/>
    </strong></font> </td>
    <td><%
	      try
          {   
		    String a[] = {"Order Date","Request Date","Schedule Ship Date","Actual Shipment Date"};
			arrayComboBoxBean.setArrayString(a);
		    arrayComboBoxBean.setSelection("Order Date");
	        arrayComboBoxBean.setFieldName("DATETYPE");	   
            out.println(arrayComboBoxBean.getArrayString());     	 
          } //end of try		 
          catch (Exception e)
		  { 
		    out.println("Exception:"+e.getMessage());
		  }
	    %>    </td>
  </tr>
  <tr>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgDateFr"/></strong></font> </td>
    <td width="18%" bgcolor="#ffffff"><input name="BEGINDATE" tabindex="2" type="text" size="10" value="<%=begin_Date%>" readonly>
      <a href='javascript:void(0)' onClick='setBeginDateTypeCheck()'><img name='popcal' border='0' src='../image/calbtn.gif'></a> </td>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font> </td>
    <td width="18%" bgcolor="#ffffff"><input name="ENDDATE" tabindex="2" type="text" size="10" value="<%=end_Date%>" readonly>
      <a href='javascript:void(0)' onClick='setEndDateTypeCheck()'><img name='popcal' border='0' src='../image/calbtn.gif'></a> </td>
  </tr>
  <tr>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgFr"/></strong></font> </td>
    <td><input type="text" size="30" name="ORDNUMFROM" value="<%=ordnum_From%>"></td>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgTo_"/></strong></font> </td>
    <td><input type="text" size="30" name="ORDNUMTO" value="<%=ordnum_To%>"></td>
  </tr>
  <tr>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font> </td>
    <td colspan="3"><input type="text" size="10" name="CUSTOMERNO" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=cust_No%>">
        <input name="button" type="button" onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)'  value="...">
        <input type="text" size="50" name="CUSTOMERNAME" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=cust_Name%>">    </td>
  </tr>
  <tr>
    <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgOrderedItem"/></strong></font> </td>
    <td colspan="3"><input type="text" size="10" name="INVITEM" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' value="<%=item_No%>">
        <input name="button" type="button" onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'  value="...">
        <input type="text" size="50" name="ITEMDESC" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' value="<%=item_Name%>">    </td>
  </tr>
  <tr>
    <td colspan="5" align="center"><input name="button" type="button" onClick='setSubmit("../jsp/aventest.jsp")'  value='<jsp:getProperty name="rPH" property="pgQuery"/>' align="middle" >
      <input name="button2" type="button" onClick='setSubmit("../jsp/TSSalesDRQAssignInf2Excel.jsp")' value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' align="middle" ></td>
  </tr>
</table>
  <table width="150%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#99CC99">
      <td width="1%" height="22" nowrap><div align="center"><font color="#000000" size="2">&nbsp;</font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></div></td>
      <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgItmFly"/></font></div></td>            
      <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgItmPkg"/></font></div></td>            
      <td width="5%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgItemDesc"/></font></div></td>            
      <td width="5%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCustomerName"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCustPONo"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgOrdD"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgRequestDate"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSSD"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgShipDate"/></font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgShippingMethod"/></font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCurr"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCostPrice"/></font></div></td>

	</tr>
<%
  String where_h = "";
  if (order_Type != null && !order_Type.equals("--") && order_Type != "")
  {
  	  if (order_Type != null && !order_Type.equals("--") && order_Type != "") 
	  {
		where_h = where_h + " AND  OOL.LINE_CATEGORY_CODE = '" + order_Type + "' ";
	  }  
	  if (group_Name != null && !group_Name.equals("--") && group_Name != "ALL" && group_Name != "") 
	  {
		where_h = where_h + " AND  TOG.GROUP_ID = " + group_Name + " ";
	  }  
	  
	  if (sales_Rep != null && !sales_Rep.equals("--") && sales_Rep != "ALL" && sales_Rep != "") 
	  {
		where_h = where_h + " AND  OOL.SALESREP_ID = '" + sales_Rep + "' ";
	  }  
	  if (date_Type != null && !date_Type.equals("--") && date_Type != "")
	  {
		if (date_Type.equals("Order Date"))
		  d_Type = " AND TRUNC(OOH.ORDERED_DATE)";
	
		if (date_Type.equals("Request Date"))
		  d_Type =  "AND TRUNC(OOL.REQUEST_DATE)";
	
		if (date_Type.equals("Schedule Ship Date"))
		  d_Type = " AND TRUNC(OOL.SCHEDULE_SHIP_DAT) ";
	
		if (date_Type.equals("Actual Shipment Date"))
		  d_Type = " AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)";
	  }
	  if (begin_Date != null && begin_Date != "") 
	  {
		where_h = where_h + d_Type + " >= TO_DATE('" + begin_Date +"','YYYYMMDD') ";
	  }  
	
	  if (end_Date != null && end_Date != "") 
	  {
		where_h = where_h + d_Type + " <= TO_DATE('" + end_Date +"','YYYYMMDD') ";
	  }

    String s_SQL = " SELECT TOG.GROUP_NAME, " +
				   " OOL.LINE_CATEGORY_CODE CATEGORY, " +
				   " OOH.ORDER_NUMBER, " +
				   " OOH.ATTRIBUTE3 VERSION, " +
				   " RC.CUSTOMER_NAME_PHONETIC CUSTOMER, " +
				   " OOL.CUST_PO_NUMBER CUST_PO, " +
				   " OOL.CUSTOMER_JOB CUST_PARTNO, " +
				   " MICV1.CATEGORY_CONCAT_SEGS TSC_FAMILY, " +
				   " MICV2.CATEGORY_CONCAT_SEGS TSC_PACKAGE, " +
				   " MSI.SEGMENT1 ITEM_NUMBER, " +
				   " MSI.DESCRIPTION ITEM_NAME, " +
				   " OOH.TRANSACTIONAL_CURR_CODE CURRENCY, " +
				   " TRUNC(OOH.ORDERED_DATE) ORDERED_DATE, " +
				   " TRUNC(OOL.REQUEST_DATE) CRD, " +
				   " TRUNC(OOL.SCHEDULE_SHIP_DATE) SCHEDULE_SHIP_DATE, " +
				   " TRUNC(OOL.ACTUAL_SHIPMENT_DATE) ACTUAL_SHIP_DATE, " +
				   " OOL.SHIPPING_METHOD_CODE SHIPPING_METHOD, " +
				   " OOL.FOB_POINT_CODE SHIPPING_TERM, " +
				   " TSC_PRICING_PAG.Get_TP_Price(OOL.INVENTORY_ITEM_ID) TP, " +
				   " OOL.UNIT_SELLING_PRICE, " +
				   " SUM(DECODE(OOL.ORDER_QUANTITY_UOM,'KPC',NVL(OOL.ORDERED_QUANTITY,0) * 1000,NVL(OOL.ORDERED_QUANTITY,0))) ORDER_QTY, " +
				   " SUM(NVL(OOL.ORDERED_QUANTITY,0) * NVL(OOL.UNIT_SELLING_PRICE,0)) ORDERED_AMT_O, " +
				   " SUM(NVL(OOL.ORDERED_QUANTITY,0) * NVL(OOL.UNIT_SELLING_PRICE,0) * NVL(GDR.CONVERSION_RATE,1)) ORDERED_AMT_F, " +
				   " SUM(DECODE(OOL.ORDER_QUANTITY_UOM,'KPC',NVL(OOL.SHIPPED_QUANTITY,0) * 1000,NVL(OOL.SHIPPED_QUANTITY,0))) SHIPPED_QTY, " +
				   " SUM(NVL(OOL.SHIPPED_QUANTITY,0) * NVL(OOL.UNIT_SELLING_PRICE,0)) SHIPPED_AMT_O, " +
				   " SUM(NVL(OOL.SHIPPED_QUANTITY,0) * NVL(OOL.UNIT_SELLING_PRICE,0) * NVL(GDR.CONVERSION_RATE,1)) SHIPPED_AMT_F, " +
				   " SUM(DECODE(OOL.ORDER_QUANTITY_UOM,'KPC',(NVL(OOL.ORDERED_QUANTITY,0) - NVL(OOL.SHIPPED_QUANTITY,0)) * 1000,NVL(OOL.ORDERED_QUANTITY,0) - NVL(OOL.SHIPPED_QUANTITY,0))) UNSHIP_QTY, " +
				   " SUM((NVL(OOL.ORDERED_QUANTITY,0) - NVL(OOL.SHIPPED_QUANTITY,0)) * NVL(OOL.UNIT_SELLING_PRICE,0)) UNSHIP_AMT_O, " +
				   " SUM((NVL(OOL.ORDERED_QUANTITY,0) - NVL(OOL.SHIPPED_QUANTITY,0)) * NVL(OOL.UNIT_SELLING_PRICE,0) * NVL(GDR.CONVERSION_RATE,1)) UNSHIP_AMT_F, " +
				   " JRS.NAME SALESREP " +
			  " FROM OE_ORDER_LINES_ALL OOL, " +
				   " OE_ORDER_HEADERS_ALL OOH, " +
				   " MTL_SYSTEM_ITEMS_B MSI, " +
				   " MTL_ITEM_CATEGORIES_V MICV1, " +
				   " MTL_ITEM_CATEGORIES_V MICV2, " +
				   " RA_CUSTOMERS RC, " +
				   " HZ_CUST_SITE_USES_ALL HCSU, " +
				   " JTF_RS_SALESREPS JRS, " +
				   " GL_DAILY_RATES GDR, " +
				   " TSC_OM_GROUP TOG " +
			 " WHERE OOH.ORG_ID = OOL.ORG_ID " +
			   " AND OOH.HEADER_ID = OOL.HEADER_ID " +
			   " AND OOL.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID " +
			   " AND OOL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID " +
			   " AND MICV1.ORGANIZATION_ID(+) = OOL.SHIP_FROM_ORG_ID " +
			   " AND MICV1.INVENTORY_ITEM_ID(+) = OOL.INVENTORY_ITEM_ID " +
			   " AND MICV1.CATEGORY_SET_NAME(+) = 'TSC_Family' " +
			   " AND MICV2.ORGANIZATION_ID(+) = OOL.SHIP_FROM_ORG_ID " +
			   " AND MICV2.INVENTORY_ITEM_ID(+) = OOL.INVENTORY_ITEM_ID " +
			   " AND MICV2.CATEGORY_SET_NAME(+) = 'TSC_Package' " +
			   " AND OOH.SOLD_TO_ORG_ID = RC.CUSTOMER_ID " +
			   " AND OOH.ORG_ID = HCSU.ORG_ID " +
			   " AND OOH.INVOICE_TO_ORG_ID = HCSU.SITE_USE_ID " +
			   " AND JRS.ORG_ID(+) = OOL.ORG_ID " +
			   " AND JRS.SALESREP_ID(+) = OOL.SALESREP_ID " +
			   " AND TRUNC(GDR.CONVERSION_DATE(+)) = TRUNC(OOH.ORDERED_DATE) " +
			   " AND GDR.FROM_CURRENCY(+) = OOH.TRANSACTIONAL_CURR_CODE " +
			   " AND GDR.TO_CURRENCY(+) = 'TWD' " +
			   " AND GDR.CONVERSION_TYPE(+) = 1000 " +
			   " AND TOG.ORG_ID = OOH.ORG_ID " +
			   " AND TOG.GROUP_ID = HCSU.ATTRIBUTE1 " +
			   " AND OOH.CANCELLED_FLAG != 'Y' " +
			   " AND OOL.CANCELLED_FLAG != 'Y' " +
			   " AND OOH.FLOW_STATUS_CODE <> 'CANCELLED' " +
			   " AND OOL.FLOW_STATUS_CODE <> 'CANCELLED' " +
			   " AND OOH.ORG_ID = 41 ";
			   
    String s_Group = " GROUP BY TOG.GROUP_NAME, " +
					 " OOL.LINE_CATEGORY_CODE, " +
					 " OOH.ORDER_NUMBER, " +
					 " OOH.ATTRIBUTE3, " +
					 " RC.CUSTOMER_NAME_PHONETIC, " +
					 " OOL.CUST_PO_NUMBER, " +
					 " OOL.CUSTOMER_JOB, " +
					 " MICV1.CATEGORY_CONCAT_SEGS, " +
					 " MICV2.CATEGORY_CONCAT_SEGS, " +
					 " OOL.INVENTORY_ITEM_ID, " +
					 " MSI.SEGMENT1, " +
					 " MSI.DESCRIPTION, " +
					 " OOH.TRANSACTIONAL_CURR_CODE, " +
					 " TRUNC(OOH.ORDERED_DATE), " +
					 " TRUNC(OOL.REQUEST_DATE), " +
					 " TRUNC(OOL.SCHEDULE_SHIP_DATE), " +
					 " TRUNC(OOL.ACTUAL_SHIPMENT_DATE), " +
					 " OOL.SHIPPING_METHOD_CODE, " +
					 " OOL.FOB_POINT_CODE, " +
					 " OOL.UNIT_SELLING_PRICE, " +
					 " JRS.NAME ";
		 
    s_SQL = s_SQL + where_h + s_Group;
    try
	{
      Statement stmt = con.createStatement(); 
      ResultSet rs = stmt.executeQuery(s_SQL);
	  while (rs.next())
	  {
	  int a = rs.getRow();
	    out.println("<tr>");
	    out.println("<td>"+a+"</td>");
	    out.println("<td>"+rs.getString("GROUP_NAME")+"</td>");
	    out.println("<td>"+rs.getString("SALESREP")+"</td>");
	    out.println("<td>"+rs.getString("ORDER_NUMBER")+"</td>");
	    out.println("<td>"+rs.getString("TSC_FAMILY")+"</td>");
	    out.println("<td>"+rs.getString("TSC_PACKAGE")+"</td>");
	    out.println("<td>"+rs.getString("ITEM_NAME")+"</td>");
	    out.println("<td>"+rs.getString("CUST_PARTNO")+"</td>");
	    out.println("<td>"+rs.getString("CUSTOMER")+"</td>");
	    out.println("<td>"+rs.getString("ORDER_NUMBER")+"</td>");
	    out.println("<td>"+rs.getString("ORDERED_DATE")+"</td>");
	    out.println("<td>"+rs.getString("CRD")+"</td>");
	    out.println("<td>"+rs.getString("SCHEDULE_SHIP_DATE")+"</td>");
	    out.println("<td>"+rs.getString("ACTUAL_SHIP_DATE")+"</td>");
	    out.println("<td>"+rs.getString("CUSTOMER")+"</td>");
		out.println("<td>"+rs.getString("CURRENCY")+"</td>");
	    out.println("<td>"+rs.getString("TP")+"</td>");
	    out.println("<td>"+rs.getString("UNIT_SELLING_PRICE")+"</td>");
		out.println("<td>"+rs.getString("ORDER_QTY")+"</td>");
	    out.println("<td>"+rs.getString("ORDERED_AMT_O")+"</td>");
	    out.println("<td>"+rs.getString("ORDERED_AMT_F")+"</td>");
		out.println("<td>"+rs.getString("SHIPPED_QTY")+"</td>");
	    out.println("<td>"+rs.getString("SHIPPED_AMT_O")+"</td>");
	    out.println("<td>"+rs.getString("SHIPPED_AMT_F")+"</td>");
		out.println("<td>"+rs.getString("UNSHIP_QTY")+"</td>");
	    out.println("<td>"+rs.getString("UNSHIP_AMT_O")+"</td>");
	    out.println("<td>"+rs.getString("UNSHIP_AMT_F")+"</td>");
	    out.println("</tr>");
//	    rs.next();
	  }
	    rs.close();
        stmt.close();
	}
	catch (Exception e)
    { 
	  out.println("Exception(rs):"+e.getMessage());
	}	
  }
%>
  </table>
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=cust_ID%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=cust_Active%>">
<input type="hidden" size="1" name="CUSTOMERAROVERDUE" value="<%=custAROverdue%>">
<input type="hidden" size="1" name="AROVERDUEDESC" value="<%=custAROverdueDesc%>">
<input type="hidden" size="1" name="SPQP" value="<%=item_Spqp%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--===========================================-->
</body>
</html>
<%

%>