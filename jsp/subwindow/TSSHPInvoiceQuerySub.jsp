<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>

<%
 String tsInvoiceNo  =request.getParameter("TSINVOICENO");
 String customerNo   =request.getParameter("CUSTOMERNO");
 String customerName =request.getParameter("CUSTOMERNAME");
 String ShipToOrg	 =request.getParameter("SHIPTOORG"); 
 String shipAddress	 =request.getParameter("SHIPADDRESS");
 String shipDate	 =request.getParameter("SHIPDATE");
 String shipMethod	 =request.getParameter("SHIPMETHOD");
 String fobPoint	 =request.getParameter("FOBPOINT");
 String paymentTerm	 =request.getParameter("PAYTERM");
 String salesOrderNo=request.getParameter("SALESORDERNO");
 String lineNum=request.getParameter("LINE_NUM");
 String invItem=request.getParameter("INV_ITEM");
 String itemDesc=request.getParameter("ITEM_DESC");
 String orderItem=request.getParameter("ORDERED_ITEM");
 String uom=request.getParameter("UOM");
 String orderQty=request.getParameter("ORDER_QTY");
 String shipQty=request.getParameter("SHIP_QTY");
 String action	 =request.getParameter("ACTION");  //action=001 查詢Invoice明細   002=查詢mo明細
 String colorStr="";
 int caseCount=0;
 int iRow=0;
 int mRow=0; 
 

 try
  {
   if (tsInvoiceNo==null)
     { tsInvoiceNo="0";  }
	 
   if (salesOrderNo==null)
     { salesOrderNo="0";  } 
	 
 if ((iRow % 2) == 0)
		   { colorStr = "E7E7E7"; }
	  else
		   { colorStr = "E7E7E7"; }
  } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>TSC Invoice Infomation Query</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function Submit1()
{   

 this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSSHPInvoiceQuerySub.jsp">

  <%  
  //out.print("salesorderno="+salesOrderNo+"   action="+action);
 /*  找尋合法的發票資訊 */
try
{
if(tsInvoiceNo !=null && action.equals("001"))
{
String  sSql =  " select B.SALESORDERNO||'-'|| B.LINE_NO as SELECTFLAG, A.TSINVOICENO,A.SHIPDATE,A.CUSTOMERNO,A.CUSTOMERNAME,A.STATUS, "+
       			"        A.CONFIRM_DATE,A.CONFIRM_BY,A.SHIPTOORG,A.SHIPADDRESS,A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM, "+
                "        B.SALESORDERNO,B.LINE_NO,B.INV_ITEM,B.ITEM_DESC,B.CUSTITEMNO,B.PO_UOM,B.RCVQTY,B.DS_LINE_ID ";
                           
							
String sFrom =  "   from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B " ;


String   sSqlCNT = "  select count(B.DS_LINE_ID) as CASECOUNT ";

String   sWhere =  "  where A.TSINVOICENO=B.TSINVOICENO and A.TSINVOICENO = upper('"+tsInvoiceNo+"') ";
			 
String sOrderBy =  " order by A.TSINVOICENO, B.SALESORDERNO,B.LINE_NO  ";			 


  sSql = sSql + sFrom + sWhere + sOrderBy ;
  sSqlCNT = sSqlCNT  + sFrom + sWhere ;

  //out.println("sSqlCNT ="+sSqlCNT ); 
  //out.println("sSqlTT="+sSql);    
 
//計算筆數 
   Statement statementcnt=con.createStatement();
   ResultSet rscnt=statementcnt.executeQuery(sSqlCNT);
   if (rscnt.next())
   {
     caseCount = rscnt.getInt("CASECOUNT");     
   }
   rscnt.close();
   statementcnt.close(); 
   
   
   Statement statementTC=con.createStatement(); 
   ResultSet rsTC=statementTC.executeQuery(sSql);
   //out.print("sSql="+sSql);
   while (rsTC.next())  
	{ 
		customerNo     = rsTC.getString("CUSTOMERNO");
	    customerName   = rsTC.getString("CUSTOMERNAME");
	    ShipToOrg      = rsTC.getString("SHIPTOORG");
		shipAddress    = rsTC.getString("SHIPADDRESS");
		shipDate       = rsTC.getString("SHIPDATE");
		shipMethod     = rsTC.getString("SHIPMETHOD");
		fobPoint       = rsTC.getString("FOBPOINT");
		paymentTerm    = rsTC.getString("PAYTERM");	  
	  


 if (iRow==0) //列印表頭列
{ %>

 <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#ECE9D8" bgcolor="#E8E8E8" >
 <tr><td colspan="8" height="20" ><div align="left" class="style2"><font size="+2"><strong><%=tsInvoiceNo.toUpperCase()%>&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td></td>
 </tr>
  <tr >
    <td width="10%" height="20" ><div align="center" class="style2 style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></div></td>
    <td colspan=3 width="30%" height="22"><div align="left" class="style7"><font size="2"><%=customerNo%>&nbsp;&nbsp;<%=customerName%></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font></div></td>
    <td colspan=4 width="30%" height="22" ><div align="left" class="style9"><font size="2"><%=ShipToOrg%>&nbsp;&nbsp;<%=shipAddress%></font></div></td>
  </tr>
    <tr>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipDate"/></strong></font></div></td>
    <td width="10%" height="20"><div align="left" class="style9"><font size="2"><%=shipDate%></font></div></td>
    <td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShippingMethod"/></strong></font></div></td>
    <td width="15%" height="20"><div align="left" class="style9"><font size="2"><%=shipMethod%></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgFOB"/></strong></font></div></td>
    <td width="15%" height="20"><div align="left" class="style9"><font size="2"><%=fobPoint%></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgPaymentTerm"/>	</strong></font></div></td>
    <td width="15%" height="20"><div align="left" class="style9"><font size="2"><%=paymentTerm%></font></div></td>
  </tr>
  </table>
  <table width="100%" border="0" bordercolor="#000066">
    <tr bgcolor="#E8E8E8"> 
	  <td width="3%" height="22" nowrap><div align="center" class="style14"><font color="#000066" size="2">&nbsp;</font></div></td> 
      <td width="12%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgDetail"/><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td>            
      <td width="15%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgPart"/></font></div></td> 
	  <td width="20%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></font></div></td> 
	  <td width="20%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgUOM"/></font></div></td> 
	  <td width="10%" nowrap><div align="center"><font color="#000066" size="2"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td> 
   </tr>

<% } //表頭列印完畢 %>
		
   <font face="Arial, Helvetica, sans-serif"> <tr bgcolor="<%=colorStr%>"> 
      <td width="3%"><div align="center"><font size="2" color="#006666"><%out.println(iRow+1);%></font></div></td>
      <td width="12%" nowrap><div align="center" class="style4"><font size="2" color="#000066"><%=rsTC.getString("SALESORDERNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("LINE_NO")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("ITEM_DESC")%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("CUSTITEMNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("PO_UOM")%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#000066"><%=rsTC.getString("RCVQTY")%></font></div></td>
     </tr></font>
    <%
      iRow++;

    }//end of while
  %><tr bgcolor="#E8E8E8"> 
	<td height="23" colspan="8" ><span class="style12"><font color="#000033" size="2"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#000066' face="Arial"><strong><%=caseCount%></strong></font></span>
	</td>
	</tr>
<%
   rsTC.close();
   statementTC.close(); 
}//end if tsinvoiceno !=null 
}//end of try
 catch (Exception e)
 {
   out.println("Exception2:"+e.getMessage());
 }  
 %> 

<% /*
if(salesOrderNo !=null && action.equals("002"))
{ out.print("******"+salesOrderNo);
//salesOrderNo='11520000003';
String sSql = " select	OOH.CUSTOMER_NUMBER as CUSTOMERNO,OOH.SHIP_TO_ORG_ID AS SHIPTOORG, "+
        	  "         OOL.SHIPPING_METHOD_CODE as SHIPMETHOD,OOL.FOB_POINT_CODE as FOBPOINT,OOL.TERMS as PAYTERM, "+
			  "			OOL.LINE_NUMBER as LINE_NUM,MSI.SEGMENT1 as INV_ITEM ,MSI.DESCRIPTION as ITEM_DESC,OOL.ORDERED_ITEM, "+
			  "	    	OOL.ORDER_QUANTITY_UOM as UOM,OOL.ORDERED_QUANTITY as ORDER_QTY,NVL (OOL.SHIPPED_QUANTITY, 0) as SHIP_QTY	"+	 
			  "	  from APPS.OE_ORDER_LINES_V ool,APPS.OE_ORDER_HEADERS_V OOH,APPS.MTL_SYSTEM_ITEMS MSI "+
			  "	 where OOH.HEADER_ID=OOL.HEADER_ID and OOL.CANCELLED_FLAG !='Y' AND OOL.FLOW_STATUS_CODE !='SHIPPED'  "+
		 	  "	       and OOL.FLOW_STATUS_CODE != 'CLOSED'  and OOL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID  "+
		 	  "        and OOH.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID  and OOH.ORDER_NUMBER = 11520000003";
			  //+salesOrderNo;
			  
 Statement statementTC=con.createStatement(); 
 ResultSet rsTC=statementTC.executeQuery(sSql);
   out.print("sSql="+sSql);			  

 while (rsTC.next()) 
 {
		customerNo     = rsTC.getString("CUSTOMERNO");
	    ShipToOrg      = rsTC.getString("SHIPTOORG");
	    shipMethod     = rsTC.getString("SHIPMETHOD");
		fobPoint       = rsTC.getString("FOBPOINT");
		paymentTerm    = rsTC.getString("PAYTERM");
		lineNum        = rsTC.getString("LINE_NUM");
		invItem        = rsTC.getString("INV_ITEM");
		itemDesc       = rsTC.getString("ITEM_DESC");	
		orderItem      = rsTC.getString("ORDERED_ITEM");
		uom            = rsTC.getString("UOM");
		orderQty       = rsTC.getString("ORDER_QTY");		
		shipQty        = rsTC.getString("SHIP_QTY");

			  
if (mRow==0) //列印表頭列
{ %>

 <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#ECE9D8" bgcolor="#E8E8E8" >
 <tr><td colspan="8" height="20" ><div align="left" class="style2">&nbsp;</div></td></td>
 </tr>
  <tr >
    
    <td width="5%" height="22" nowrap><div align="left" class="style7"><font size="2"><strong><jsp:getProperty name="rPH" property="pgAnItem"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font></div></td>
	<td width="5%" height="20" nowrap><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font></div></td>
    <td width="8%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShippingMethod"/></strong></font></div></td>
	<td width="8%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgFOB"/></strong></font></div></td>
	<td width="8%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgPaymentTerm"/>	</strong></font></div></td>
    <td width="12%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgDetail"/><jsp:getProperty name="rPH" property="pgAnItem"/></strong></font></div></td>
    <td width="12%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgPart"/></strong></font></div></td>
	<td width="12%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgMRDesc"/></strong></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgCustItemNo"/></strong></font></div></td>
    <td width="10%" height="20"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgUOM"/></strong></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgQty"/></strong></font></div></td>
	<td width="10%" height="20"><div align="center" class="style9"><font size="2"><jsp:getProperty name="rPH" property="pgAvailableShip"/><jsp:getProperty name="rPH" property="pgQty"/></strong></font></div></td>	
  </tr>
  <!--/table-->

    
<% } //表頭列印完畢 %>
  <!--table width="100%" border="0" bordercolor="#000066"-->		
   <font face="Arial, Helvetica, sans-serif"> <tr bgcolor="<%=colorStr%>"> 
      <td width="3%"><div align="center"><font size="2" color="#006666"><%out.println(mRow+1);%></font></div></td>
      <td width="12%" nowrap><div align="center" class="style4"><font size="2" color="#000066"><%=customerNo%>></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000066"><%=ShipToOrg%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000066"><%=shipMethod%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=fobPoint%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=paymentTerm%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000066"><%=lineNum%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#000066"><%=invItem%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000066"><%=itemDesc%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=orderItem%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#000066"><%=uom%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000066"><%=orderQty%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#000066"><%=shipQty%></font></div></td>	  
     </tr></font>
	 
    <%
      mRow++;
  
 }//end while			  
} //end action=002 */
%>

  <tr><td colspan="8" align="center"> <input name="CLOSEWIN" type="button"  onClick="Submit1()" value="Close Windows"></td></tr>
</table>  

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
