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
 String salesOrderNo =request.getParameter("ORDER_NUM");
 String customerNo   =request.getParameter("CUSTOMERNO");
 String customerName =request.getParameter("CUSTOMERNAME");
 String lineNum 	 =request.getParameter("LINE_NUM"); 
 String orederdItem	 =request.getParameter("ORDERED_ITEM");
 String invItem	     =request.getParameter("INV_ITEM");
 String itemDesc	 =request.getParameter("ITEM_DESC");
 String moUom	     =request.getParameter("MO_UOM");
 String unshipQty	 =request.getParameter("UNSHIP_QTY");
 String undeliveryQty=request.getParameter("UNDELIVERY_QTY");
 String poNum=request.getParameter("PO_NUM");
 String poUom=request.getParameter("PO_UOM");
 String createdBy=request.getParameter("CREATED_BY");

 String action	 =request.getParameter("ACTION");  //action=001 查詢Invoice明細   002=查詢mo明細
   		




 String colorStr="";
 int caseCount=0;
 int iRow=0;
 int mRow=0; 
 

 try
  {
//   if (tsInvoiceNo==null)
//     { tsInvoiceNo="0";  }
	 
//   if (salesOrderNo==null)
//     { salesOrderNo="0";  } 
	 
 if ((iRow % 2) == 0)
		   { colorStr = "#EEFFFF"; }
	  else
		   { colorStr = "#408080"; }
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
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>     
<FORM METHOD="post" ACTION="TSSHPMoNoBalanceRPT.jsp">
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>SalesOrder Mapping PurchaseOrder No Balance Report</strong></font>
<!--strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgWith"/><jsp:getProperty name="rPH" property="pgPono"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font-->
<HR>
  <%  
  //out.print("salesorderno="+salesOrderNo+"   action="+action);
 /*  找尋合法的發票資訊 */
try
{

String  sSql =  " select A.ORDER_NUM, A.HEADER_ID,A.LINE_NUM,A.LINE_ID,A.ORDERED_ITEM, C.SEGMENT1 as INV_ITEM,C.INVENTORY_ITEM_ID, "+
	   			" 	C.DESCRIPTION as ITEM_DESC, A.MO_UOM,A.UNSHIP_QTY,  B.UNDELIVERY_QTY, B.PO_UOM, "+
	   			" 	A.SHIPTOORG,A.CUSTOMERID,B.PO_HEADER_ID,B.PO_NUM,B.PO_LINE_ID, "+
	     		"	A.ORDERED_DATE,A.REQUEST_DATE,A.SCHEDULE_SHIP_DATE,A.ACTUAL_SHIPMENT_DATE,A.CUSTOMER_NAME,A.USER_NAME as CREATED_BY ";
String sFrom =	" from    "+
				"   (select OOH.ORDER_NUMBER as ORDER_NUM,OOH.HEADER_ID,OOH.SHIP_FROM_ORG_ID,OOL.LINE_NUMBER as LINE_NUM,  "+
				"	    OOL.LINE_ID,OOH.SHIP_TO_ORG_ID as SHIPTOORG,OOL.ORDERED_ITEM,OOL.INVENTORY_ITEM_ID, "+
				"	    OOL.ORDER_QUANTITY_UOM as MO_UOM,sum(OOL.ORDERED_QUANTITY) as ORDER_QTY, "+
				"	    nvl(sum(OOL.SHIPPED_QUANTITY),0) as SHIP_QTY,sum(OOL.ORDERED_QUANTITY)-nvl(sum(OOL.SHIPPED_QUANTITY),0) UNSHIP_QTY,   "+
				"            ODS.PO_HEADER_ID ,ODS.LINE_LOCATION_ID,OOH.SOLD_TO_ORG_ID as CUSTOMERID, "+
				"            ( sum(OOL.ORDERED_QUANTITY)-nvl(sum(OOL.SHIPPED_QUANTITY),0))*( decode(OOL.ORDER_QUANTITY_UOM,'PCE',1,'KPC',1000)) as MO_PCEQTY, "+
				"			OOH.ORDERED_DATE,OOL.REQUEST_DATE,OOL.SCHEDULE_SHIP_DATE,OOL.ACTUAL_SHIPMENT_DATE,RA.CUSTOMER_NAME ,FUSER.USER_NAME "+
				"       from OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL,OE_DROP_SHIP_SOURCES ODS ,RA_CUSTOMERS RA ,FND_USER FUSER "+
				"       where  OOH.HEADER_ID=OOL.HEADER_ID   "+
				"              and ODS.LINE_ID=OOL.LINE_ID   "+
				" 	      and OOL.CANCELLED_FLAG !='Y'   "+
				" 	      and OOL.FLOW_STATUS_CODE != 'CLOSED'  "+
				"		  and RA.CUSTOMER_ID = OOH.SOLD_TO_ORG_ID   "+
				"		  and OOH.CREATED_BY = FUSER.USER_ID "+
				" 	 group by OOH.ORDER_NUMBER  ,OOH.HEADER_ID,OOH.SHIP_FROM_ORG_ID,OOL.LINE_NUMBER  , "+
				"	        OOL.LINE_ID,OOH.SHIP_TO_ORG_ID  ,OOL.ORDERED_ITEM,OOL.INVENTORY_ITEM_ID, "+
				"			OOL.ORDER_QUANTITY_UOM  , ODS.PO_HEADER_ID ,ODS.LINE_LOCATION_ID,OOH.SOLD_TO_ORG_ID ,OOH.ORDERED_DATE,OOL.REQUEST_DATE, "+
				"			OOL.SCHEDULE_SHIP_DATE,OOL.ACTUAL_SHIPMENT_DATE,RA.CUSTOMER_NAME,FUSER.USER_NAME  ) A,    "+
				"                 (select distinct poh.segment1 PO_NUM,poh.po_header_id,pll.line_location_id,ODS.LINE_ID,ODS.PO_LINE_ID, POL.UNIT_MEAS_LOOKUP_CODE as PO_UOM ,  "+
				"				                  sum(pll.quantity),sum(pll.quantity_received),(sum(pll.quantity)-nvl(sum(pll.quantity_received),0)) undelivery_qty, "+
				"		                  (sum(pll.quantity)-nvl(sum(pll.quantity_received),0))*( decode(POL.UNIT_MEAS_LOOKUP_CODE,'PCE',1,'KPC',1000)) as PO_PCEQTY "+
				"                  from oe_drop_ship_sources ods,po_headers_all poh,po_line_locations_all pll , po_lines_all pol   "+
				"                  where ods.PO_HEADER_ID=poh.PO_HEADER_ID    "+
				"                        and ods.LINE_LOCATION_ID=pll.line_location_id  "+   
				" 		                 and poh.po_header_id=pll.po_header_id "+
				"                        and pol.po_line_id=pll.po_line_id   "+   
				" 		              and pll.closed_code !='CLOSED'   "+
				"					  and poh.AUTHORIZATION_STATUS='APPROVED' "+
				"					  group by poh.segment1,poh.po_header_id,pll.line_location_id,ODS.LINE_ID,ODS.PO_LINE_ID,POL.UNIT_MEAS_LOOKUP_CODE  ) B, MTL_SYSTEM_ITEMS  C   ";
String   sWhere="  where A.PO_HEADER_ID=B.PO_HEADER_ID(+)   "+
				"        and A.LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)   "+
				" 	    and B.LINE_ID(+)=A.LINE_ID   "+
				" 	    and C.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID   "+
				" 	    and C.ORGANIZATION_ID = A.SHIP_FROM_ORG_ID  "+
				"	    and c.inventory_item_id=a.inventory_item_id "+
				"	    and c.organization_id = a.ship_from_org_id "+
				"	    and a.MO_PCEQTY != b.PO_PCEQTY  ";
                        							


String   sSqlCNT = "  select count(A.LINE_NUM) as CASECOUNT ";

			 
String sOrderBy =  " order by A.ORDER_NUM, A.LINE_NUM  ";			 


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
   		salesOrderNo   = rsTC.getString("ORDER_NUM");
		//customerNo     = rsTC.getString("CUSTOMERNO");
	    customerName   = rsTC.getString("CUSTOMER_NAME");
	    lineNum      = rsTC.getString("LINE_NUM");
		//shipAddress    = rsTC.getString("SHIPADDRESS");
		orederdItem    = rsTC.getString("ORDERED_ITEM");
		invItem        = rsTC.getString("INV_ITEM");
		itemDesc       = rsTC.getString("ITEM_DESC");
		moUom          = rsTC.getString("MO_UOM");
		unshipQty      = rsTC.getString("UNSHIP_QTY");
		undeliveryQty  = rsTC.getString("UNDELIVERY_QTY");
		poNum          = rsTC.getString("PO_NUM");
		poUom          = rsTC.getString("PO_UOM");
		createdBy      = rsTC.getString("CREATED_BY");	  


 if (iRow==0) //列印表頭列
{ 
%>


  <table width="100%" border="2" bordercolor="#408080">
    <tr bgcolor="#CCEEFFCC"> 
	  <td width="3%" border="1" height="22" nowrap><div align="center" class="style14"><font color="#000088" size="2">&nbsp;</font></div></td> 
      <td width="10%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgCustomerName"/></font></strong></div></td>
      <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></strong></div></td>            
      <td width="2%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgAnItem"/></font></strong></div></td> 
	  <td width="18%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></strong></div></td> 
	  <td width="18%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgPart"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgMRDesc"/></font></strong></div></td> 
	  <td width="10%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgUOM"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgQty"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgPono"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgPono"/><jsp:getProperty name="rPH" property="pgUOM"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><jsp:getProperty name="rPH" property="pgPono"/><jsp:getProperty name="rPH" property="pgQty"/></font></strong></div></td> 
	  <td width="5%" nowrap><div align="center"><strong><font color="#000088" size="2"><A>Created_BY</A></font></strong></div></td> 
   </tr>

<% } //表頭列印完畢 %>
		
   <font face="Arial, Helvetica, sans-serif"> <tr bgcolor="<%=colorStr%>"> 
      <td width="3%"><div align="center"><font size="2" color="#000080"><%out.println(iRow+1);%></font></div></td>
      <td width="10%" nowrap><div align="center" class="style4"><font size="2" color="#000080"><%=customerName%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000080"><%=salesOrderNo%></font></div></td>
	  <td width="2%" nowrap><div align="center"><font size="2" color="#000080"><%=lineNum%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000080"><%=orederdItem%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000080"><%=invItem%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#000080"><%=itemDesc%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000080"><%=moUom%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#ff0000"><%=unshipQty%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#000080"><%=poNum%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#000080"><%=poUom%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#ff0000"><%=undeliveryQty%></font></div></td>
	  <td width="5%" nowrap><font size="2" color="#000080"><%=createdBy%></font></td>
     </tr></font>
    <%
      iRow++;

    }//end of while
  %><tr bgcolor="#CCEEFFCC"> 
	<td height="23" colspan="13" ><span class="style12"><strong><font color="#000033" size="2"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font></strong>
	 <font color='#000066' face="Arial"><strong><%=caseCount%></font></span>
	</td>
	</tr>
<%
   rsTC.close();
   statementTC.close(); 
 
}//end of try
 catch (Exception e)
 {
   out.println("Exception2:"+e.getMessage());
 }  
 %> 


<!--
  <tr><td colspan="8" align="center"> <input name="CLOSEWIN" type="button"  onClick="Submit1()" value="Close Windows"></td></tr>-->
</table>  

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
