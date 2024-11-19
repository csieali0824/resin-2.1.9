<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>

<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function popMenuMsg(clkDesc)
{
 alert(clkDesc);
}

function setSubmit(URL)
{ //alert();
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

function TSCINVI6StockDetail(itemid,typeId,subInv,orgId)
{            
    subWin=window.open("../jsp/TSCINVI6StockDetail.jsp?ITEM_ID="+itemid+"&TYPEID="+typeId+"&SUBINV="+subInv+"&ORGANIZATION_ID="+orgId,"subwin","top=0,left=0,width=1000,height=650,scrollbars=yes,menubar=yes,status=yes");    	
}

</script>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
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
             
</STYLE>
<title>The HUB Stock Detail Data</title>
</head>
<body>
<FORM ACTION="../jsp/TSCINVI6StockDetail.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/oradds/ORADDSMainMenu.jsp">Home</A><div align="right"><a href="JavaScript:self.close()">Closed Windows</A></div>
<% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  //  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   //  
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 
  String currentWeek = workingDateBean.getWeekString();

  String itemId=request.getParameter("ITEM_ID");
  String subInv=request.getParameter("SUBINV");
  String subItemId=request.getParameter("SUB_ITEM_ID");
  String organizationId=request.getParameter("ORGANIZATION_ID");
  String orgId=request.getParameter("ORGID");
  String typeId=request.getParameter("TYPEID");   //typeid 0=item mmt 1=1213未交    2=1211未交  ,3= I1 訂單未交,4= I1 倉庫ON_HAND
  String invItem="",itemDesc="",groupArea="",hub="",custName="",orderNo="",orderDate="",schDate="",orderQty="",itemUom="KPC";
  String txnType="",docNo="",sourceCode="",sourceLineId="",invoiceNo="&nbsp;",originalNo="&nbsp;",packingList="&nbsp;";
  float orderQtyf=0,sumQtyf=0;

  String conti="N";
  int k=1;
  
//out.print("<br> itemd="+itemId+"  org="+organizationId+" type="+typeId);

if (typeId=="0" || typeId.equals("0"))  //typeid=0  //ITEM MMT
{ 
  try
  {   
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
  	//cs1.setString(1,userParOrgID);  // ~�致arOrgID
  	cs1.execute();
  	cs1.close();   
  
    String sqla = " SELECT   mmt.transaction_id, mmt.item_ord, mmt.description,to_char(trunc(mmt.transaction_date),'yyyy/mm/dd') transaction_date,  "+
        		  //"          mmt.subinventory, mmt.transaction_type_name,mmt.primary_quantity, mmt.primary_uom_code, "+
				  "          mmt.subinventory, mmt.transaction_type_name,mmt.primary_quantity/case when primary_uom_code='PCE' THEN 1000 ELSE 1 END AS primary_quantity, 'KPC' primary_uom_code, "+
				  "          mmt.TRANSACTION_SOURCE_TYPE_NAME SOURCE_CODE, mmt.TRANSACTION_REFERENCE DOC_NO,mmt.source_line_id "+
   				  "   FROM mtl_txns_all_v mmt ";
    // String where = " WHERE mmt.organization_id = "+organizationId+"  AND mmt.transaction_type_id != 52 and mmt.TRANSACTION_ACTION_ID!=24 "+
	String where = " WHERE mmt.organization_id = "+organizationId+"  AND mmt.transaction_type_id != 52 and mmt.TRANSACTION_ACTION_ID not in (7,9,10,24) "+  //20140318 liling modify
  				   "   AND mmt.inventory_item_id =  '"+itemId+"' AND mmt.subinventory = '"+subInv+"' ";
	 			   				   				 
    String orderBy = " ORDER BY mmt.transaction_date ";				 			   				   
	 
    sqla = sqla + where + orderBy;	
    //out.println("sqla="+sqla);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqla);	
    
   %>

  <table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">
      <tr><td colspan="13" align="right">
         <input type='button' name='IMPORT' size='20' value='EXCEL' onClick='setSubmit("../jsp/TSCINVI6StockExcel.jsp?TYPEID=0&ITEM_ID=<%=itemId%>&ORGANIZATION_ID=<%=organizationId%>&SUBINV=<%=subInv%>")'>
      </tr>
      <TR BGCOLOR="#000088">
	   <td NOWRAP width="3%"><FONT  COLOR="#EEEEEE">&nbsp;</FONT></td>
	   <!--td NOWRAP width="15%"><FONT  COLOR="#EEEEEE">Item No</FONT></td-->
	   <td NOWRAP width="10%"><FONT  COLOR="#EEEEEE">Description</FONT></td>
	   <td NOWRAP width="8%"><FONT  COLOR="#EEEEEE">Txn Date</FONT></td>	 
	   <td NOWRAP width="3%"><FONT  COLOR="#EEEEEE">Inventory</FONT></td>	
	   <td  width="8%"><FONT  COLOR="#EEEEEE">Transaction Type</FONT></td>
	   <td  width="10%"><FONT  COLOR="#EEEEEE">Doc No</FONT></td>	
	   <td  width="9%"><FONT  COLOR="#EEEEEE">Invoice</FONT></td>	
	   <td  width="17%"><FONT  COLOR="#EEEEEE">Customer Name</FONT></td>		   
	   <td  width="8%"><FONT  COLOR="#EEEEEE">Original INV#</FONT></td>	
	   <td  width="9%"><FONT  COLOR="#EEEEEE">Packing List</FONT></td>		   	   	   
	   <td NOWRAP width="4%"><FONT  COLOR="#EEEEEE">Qty</FONT></td>  
       <td NOWRAP width="3%"><FONT  COLOR="#EEEEEE">UOM</FONT></td> 
       <td NOWRAP width="4%"><FONT  COLOR="#EEEEEE">StockQty</FONT></td>   
	  </TR> 
   <%   
   while (rs.next())
   { 

   //  groupArea=rs.getString("GROUP_NAME");
  //   hub=rs.getString("HUB");
 //    custName=rs.getString("CUSTOMER_NAME");
//	 orderNo=rs.getString("ORDER_NUMBER");
     invItem=rs.getString("ITEM_ORD");  
	 itemDesc=rs.getString("DESCRIPTION");
	 orderDate=rs.getString("TRANSACTION_DATE");
	 subInv=rs.getString("SUBINVENTORY");
	 txnType=rs.getString("TRANSACTION_TYPE_NAME");
     orderQty=rs.getString("PRIMARY_QUANTITY");
     itemUom=rs.getString("PRIMARY_UOM_CODE");
     orderQtyf=rs.getFloat("PRIMARY_QUANTITY");
	 sourceCode=rs.getString("SOURCE_CODE");
	 sourceLineId=rs.getString("SOURCE_LINE_ID");
	 docNo=rs.getString("DOC_NO");
     orderQty=rs.getString("PRIMARY_QUANTITY");
     sumQtyf=sumQtyf+orderQtyf;
	 originalNo ="&nbsp;";     //add by Peggy 20150706
	 packingList = "&nbsp;";   //add by Peggy 20150706
	 custName="&nbsp";	       //add by Peggy 20150706 

  //   if (groupArea==null || groupArea.equals("")) groupArea="&nbsp"; 
  //   if (hub==null || hub.equals("")) hub="&nbsp"; 
  //   if (custName==null || custName.equals("")) custName="&nbsp"; 
  //   if (orderNo==null || orderNo.equals("")) orderNo="&nbsp"; 
  //   if (orderDate==null || orderDate.equals("")) orderDate="N/A"; 
  //   if (schDate==null || schDate.equals("")) schDate="N/A";
       if (sourceCode=="Inventory" || sourceCode.equals("Inventory")) 
	    {
		   docNo=rs.getString("DOC_NO");   // Inventory大多為inter-org 移來有 reference 有打1213訂單號
		   invoiceNo=rs.getString("DOC_NO");
		   if (invoiceNo==null || invoiceNo.equals(null)) invoiceNo ="&nbsp;";
		 }


       if (sourceCode=="Sales order" || sourceCode.equals("Sales order")) 
        {
 			String sqlfnd = "  select ooh.order_number , ool.SHIPPING_INSTRUCTIONS,ool.ATTRIBUTE1 from oe_order_headers_all ooh,oe_order_lines_all ool "+
 						    "   where ooh.header_id = ool.header_id  and ool.line_id= '"+sourceLineId+ "'";
			Statement stateFndId=con.createStatement();
            ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
			if (rsFndId.next())
			{
				 docNo = rsFndId.getString("ORDER_NUMBER"); 
				 originalNo = rsFndId.getString("SHIPPING_INSTRUCTIONS"); 
				 packingList = rsFndId.getString("ATTRIBUTE1"); 				 
				  if (originalNo==null || originalNo.equals(null)) originalNo ="&nbsp;";
				  if (packingList==null || packingList.equals(null)) packingList ="&nbsp;";				  
			 }
			 rsFndId.close();
			 stateFndId.close();        
         
 			String sqlinv = " SELECT MAX(INVOICE_NO) INVOICE_NO FROM TSC_INVOICE_LINES TIL WHERE  TIL.ORDER_NUMBER = '"+docNo+ "'";
			Statement stateFndInv=con.createStatement();
            ResultSet rsFndInv=stateFndInv.executeQuery(sqlinv);
			if (rsFndInv.next())
			{
				 invoiceNo = rsFndInv.getString("INVOICE_NO"); 
			 }
			 rsFndInv.close();
			 stateFndInv.close(); 
			 if (invoiceNo==null || invoiceNo.equals("null")) invoiceNo ="&nbsp;"; 
			 if (originalNo==null || originalNo.equals(null)) originalNo ="&nbsp;";		 
			 if (packingList==null || packingList.equals(null)) packingList ="&nbsp;";				 
        }
       else if (sourceCode=="RMA" || sourceCode.equals("RMA"))
        {
 			String sqlrma = "   select ooh.order_number,ooh.SOLD_TO from rcv_transactions rt,oe_order_headers_v ooh "+
 						    "    where rt.OE_ORDER_HEADER_ID = ooh.header_id and  rt.transaction_id= '"+sourceLineId+ "'";
			Statement staterma=con.createStatement();
            ResultSet rsrma=staterma.executeQuery(sqlrma);
			if (rsrma.next())
			{
				 docNo = rsrma.getString("ORDER_NUMBER"); 
				 custName = rsrma.getString("SOLD_TO"); 				 
			 }
			 rsrma.close();
			 staterma.close(); 
			 invoiceNo ="&nbsp;";
			 originalNo ="&nbsp;";
			 packingList = "&nbsp;";
         }
       else if (sourceCode=="Purchase order" || sourceCode.equals("Purchase order"))
        { 
 			String sqlPo = "   SELECT poh.segment1 || ' / ' || pol.note_to_receiver segment1 FROM rcv_transactions rt, po_headers_all poh, po_line_locations_all pol "+
 						   "    WHERE rt.po_header_id = poh.po_header_id  AND rt.po_line_location_id = pol.line_location_id  AND pol.po_header_id = poh.po_header_id "+
                           "      and rt.transaction_id='"+sourceLineId+ "'";
			Statement statePo=con.createStatement();
            ResultSet rsPo=statePo.executeQuery(sqlPo);
			if (rsPo.next())
			{
				 docNo = rsPo.getString("SEGMENT1"); 
			 }
			 rsPo.close();
			 statePo.close(); 
			 invoiceNo ="&nbsp;";
			 originalNo ="&nbsp;";
			 packingList = "&nbsp;";
         } 
		else  //20140324 liling
		{
		   invoiceNo ="&nbsp;";
		   custName="&nbsp";
		}

      if (docNo==null || docNo.equals("null")) docNo="&nbsp";

	//customer name  
	  if (invoiceNo==null || invoiceNo.equals("null")) 
	    {  if (custName==null || custName.equals("null"))
		     { custName="&nbsp"; }
	    }
	  else 
	    {
 			String sqlCust = "  select CUSTOMER_NAME from tsc_invoice_headers  where invoice_no='"+invoiceNo+ "'";
			Statement stateCust=con.createStatement();
            ResultSet rsCust=stateCust.executeQuery(sqlCust);
			if (rsCust.next())
			{
				 custName = rsCust.getString("CUSTOMER_NAME"); 
			 }
			 rsCust.close();    //add by Peggy 20150706
			 stateCust.close(); //add by Peggy 20150706
		 } //end invoice is null
	 
	  
	  
	  
  /* 
      String clkDesc = "";
      String sqlInv = "   SELECT DESCRIPTION FROM MTL_SECONDARY_INVENTORIES WHERE ORGANIZATION_ID=163 AND SECONDARY_INVENTORY_NAME='"+subInv+ "'";
	  Statement stateInv=con.createStatement();
      ResultSet rsInv=stateInv.executeQuery(sqlInv);
	  if (rsInv.next())
		{
	 	  clkDesc = rsInv.getString("DESCRIPTION"); 
		 }
	  rsInv.close();
	  stateInv.close(); 
*/
    %>	 
    <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <!--TD NOWRAP><FONT SIZE=2><%//=invItem%></FONT></TD-->
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderDate%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=subInv%></FONT></TD>
	   <TD ><FONT SIZE=2><%=txnType%></FONT></TD>	 
	   <TD ><FONT SIZE=2><%=docNo%></FONT></TD>	
	   <TD ><FONT SIZE=2><%=invoiceNo%></FONT></TD>	
	   <TD ><FONT SIZE=2><%=custName%></FONT></TD>		   
	   <TD ><FONT SIZE=2><%=originalNo%></FONT></TD>	   
	   <TD ><FONT SIZE=2><%=packingList%></FONT></TD>		   	   
	   <TD NOWRAP><div align="right"><FONT SIZE=2><%=orderQty%>&nbsp;&nbsp;</FONT></div></TD>	
 	   <TD NOWRAP><div align="center"><FONT SIZE=2><%=itemUom%></FONT></div></TD>
       <TD NOWRAP><div align="center"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD>
    </TR>


	<%
	k=k+1;
   } //end of while
   %>
   <TR  bgcolor="#BBD3E1">
       <TD NOWRAP colspan="10"><div align="right"><FONT SIZE=2> Total </FONT></div></TD>
       <TD NOWRAP><div align="right"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD> 
       <TD><div align="center">KPC</div></TD>
       <TD>&nbsp;</TD>
   </TR>
   </TABLE>
   <%
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //endif  typeid=0  //ITEM MMT

if (typeId=="1" || typeId.equals("1"))  //typeid=1  //1213未交
{ 
  try
  {   
    String sqla = " select a.GROUP_NAME,a.HUB,a.CUSTOMER_NAME,a.ORDER_NUMBER,to_char(a.ORDERED_DATE,'yyyy/mm/dd') ORDERED_DATE,  "+
       			  " 	   to_char(a.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,a.ITEM,a.ITEM_DESC,(a.ORDER_QTY)/1000 AS ORDER_1213,a.ITEM_ID "+
  				  "   from tsc_om_1213 a ";
    String where = " where a.L_STATUS not in ('CLOSED','CANCELLED') "+
  				   "   and A.ITEM_ID = '"+itemId+"' and a.hub = '"+subInv+"' ";
	 			   				   				 
    String orderBy = " order by a.SCHEDULE_SHIP_DATE ";				 			   				   
	 
    sqla = sqla + where + orderBy;	
    //out.println("sqla="+sqla);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqla);	
    
   %>

  <table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">
      <tr><td colspan="10" align="right">
         <input type='button' name='IMPORT' size='20' value='EXCEL' onClick='setSubmit("../jsp/TSCINVI6StockExcel.jsp?TYPEID=1&ITEM_ID=<%=itemId%>&SUBINV=<%=subInv%>")'>
      </td></tr>
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR="#EEEEEE">No</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">GROUP</FONT></td>	   
	   <td NOWRAP><FONT  COLOR="#EEEEEE">HUB</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Custome Name</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Order No</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Item No</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Description</FONT></td>
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Order Date</FONT></td>	 
	   <td NOWRAP><FONT  COLOR="#EEEEEE">Schedule Ship Date</FONT></td>	
	   <td NOWRAP><FONT  COLOR="#EEEEEE">1213/1214 unship Qty</FONT></td>	
	   <td NOWRAP><FONT  COLOR="#EEEEEE">UOM</FONT></td>  
	  </TR> 
   <%   
   while (rs.next())
   { 

     groupArea=rs.getString("GROUP_NAME");
     hub=rs.getString("HUB");
     custName=rs.getString("CUSTOMER_NAME");
	 orderNo=rs.getString("ORDER_NUMBER");
     invItem=rs.getString("ITEM");  
	 itemDesc=rs.getString("ITEM_DESC");
	 orderDate=rs.getString("ORDERED_DATE");
	 schDate=rs.getString("SCHEDULE_SHIP_DATE");
	 orderQty=rs.getString("ORDER_1213");
     orderQtyf=rs.getFloat("ORDER_1213");
     sumQtyf=sumQtyf+orderQtyf;

     if (groupArea==null || groupArea.equals("")) groupArea="&nbsp"; 
     if (hub==null || hub.equals("")) hub="&nbsp"; 
     if (custName==null || custName.equals("")) custName="&nbsp"; 
     if (orderNo==null || orderNo.equals("")) orderNo="&nbsp"; 
     if (orderDate==null || orderDate.equals("")) orderDate="N/A"; 
     if (schDate==null || schDate.equals("")) schDate="N/A";
     if (orderQty==null || orderQty.equals("")) orderQty="&nbsp";  


    %>	 
      <TR onmouseover=bgColor='#FFCCFF' onmouseout=bgColor='#FFFFFF'>
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=groupArea%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=hub%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=custName%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderNo%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderDate%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=schDate%></FONT></TD>	 
	   <TD NOWRAP><div align="right"><FONT SIZE=2><%=orderQty%>&nbsp;&nbsp;</FONT></div></TD>	
 	   <TD NOWRAP><div align="center"><FONT SIZE=2><%=itemUom%></FONT></div></TD>
    </TR>


	<%
	k=k+1;
   } //end of while
   %>
   <TR  bgcolor="#BBD3E1">
       <TD NOWRAP colspan="9"><div align="right"><FONT SIZE=2> Total 未交數</FONT></div></TD>
       <TD><div align="right"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD> 
       <TD><div align="center">KPC</div></TD>
   </TR>
   </TABLE>
   <%
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //endif  typeid=1  //1213未交

if (typeId=="2" || typeId.equals("2"))   //typeid=2  1211訂單未交
{
  try
  {   
    String sqlB = " select a.GROUP_NAME,a.HUB,a.CUSTOMER_NAME,a.ORDER_NUMBER,to_char(a.ORDERED_DATE,'yyyy/mm/dd') ORDERED_DATE,  "+
       			  " 	   to_char(a.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,a.ITEM,a.ITEM_DESC,(a.ORDER_QTY/1000) AS ORDER_1211,A.ITEM_ID  "+
  				  "   from tsc_om_1211 a ";

    String where = " where a.L_STATUS NOT IN ('CLOSED', 'CANCELLED') "+    //tsc_om_1211 的 H_STATUS 代表om line 的狀態 
 				   "   and a.ITEM_ID = '"+itemId+"' and a.hub='"+subInv+"' ";
	 			   				   				 
    String orderBy = " order by  a.schedule_ship_date  ";				 			   				   
	 
    sqlB = sqlB + where + orderBy;	
     //out.println("sqlB="+sqlB);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlB);	
   %>
  <table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#000088">
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>GROUP</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>HUB</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Customer Name</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Order No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Item No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Description</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Order Date</FONT></td>	 
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Schedule Ship Date</FONT></td>	
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>1211 unship Qty</FONT></td>	
	   <td NOWRAP><FONT  COLOR="#EEEEEE">UOM</FONT></td> 
	  </TR> 
   <%   
   while (rs.next())
   { 
     groupArea=rs.getString("GROUP_NAME");
     hub=rs.getString("HUB");
     custName=rs.getString("CUSTOMER_NAME");
	 orderNo=rs.getString("ORDER_NUMBER");
     invItem=rs.getString("ITEM");  
	 itemDesc=rs.getString("ITEM_DESC");
	 orderDate=rs.getString("ORDERED_DATE");
	 schDate=rs.getString("SCHEDULE_SHIP_DATE");
	 orderQty=rs.getString("ORDER_1211");
     orderQtyf=rs.getFloat("ORDER_1211");
     sumQtyf=sumQtyf+orderQtyf;

     if (groupArea==null || groupArea.equals("")) groupArea="&nbsp"; 
     if (hub==null || hub.equals("")) hub="&nbsp"; 
     if (custName==null || custName.equals("")) custName="&nbsp"; 
     if (orderNo==null || orderNo.equals("")) orderNo="&nbsp"; 
     if (orderDate==null || orderDate.equals("")) orderDate="N/A"; 
     if (schDate==null || schDate.equals("")) schDate="N/A";
     if (orderQty==null || orderQty.equals("")) orderQty="&nbsp";  
    %>	 
     <TR onmouseover=bgColor='#CCFF99' onmouseout=bgColor='#FFFFFF'>
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=groupArea%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=hub%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=custName%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderNo%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderDate%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=schDate%></FONT></TD>	 
	   <TD NOWRAP><div align="right"><FONT SIZE=2><%=orderQty%>&nbsp;&nbsp;</FONT></div></TD>	
 	   <TD NOWRAP><div align="center"><FONT SIZE=2><%=itemUom%></FONT></div></TD>
    </TR>	 

	<%
	k=k+1;
   } //end of while
  %>
     <TR bgcolor="#BBD3E1">
       <TD NOWRAP colspan="9"><div align="right"><FONT SIZE=2> Total 1211未交數</FONT></div></TD>
       <TD><div align="right"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD> 
       <TD><div align="center">KPC</div></TD>
     </TR>
     </TABLE>
   <%
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=2  //訂單保留量


//===============================================

if (typeId=="3" || typeId.equals("3"))   //typeid=3  訂單未交
{

  try
  {
    if( organizationId == "326" || organizationId.equals("326"))
     {   
       orgId="325"; 
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('325')}");
 	    CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '325')}");
	   cs1.execute();
       cs1.close();
      }
    else
     {    
       orgId="41"; 
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	   cs1.execute();
       cs1.close();
      }
    } //end of try
    catch (Exception e)
    {
     out.println("Exception aa:"+e.getMessage());
     }
  try
  {   
    //String sqlB = " SELECT tsc_intercompany_pkg.get_sales_group (ooh.header_id) group_name,AC.CUSTOMER_NAME, ooh.order_number, "+
	String sqlB = " SELECT TSC_OM_Get_Sales_Group (ooh.header_id) group_name,AC.CUSTOMER_NAME, ooh.order_number, "+
       			  "		   TO_CHAR (TRUNC (ooh.ordered_date), 'yyyy/mm/dd') ordered_date, "+
	   			  "        TO_CHAR (TRUNC (ool.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date, "+
       			  //"        msi.segment1 item_no, msi.description,  msi.primary_unit_of_measure UOM, ool.inventory_item_id , "+
				  "        msi.segment1 item_no, msi.description,  'KPC' UOM, ool.inventory_item_id , "+
	  			  "        DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000,ool.ordered_quantity) order_qty "+
 				  "   FROM oe_order_lines_all ool, oe_order_headers_all ooh, mtl_system_items msi , AR_CUSTOMERS AC ";

    String where = "  WHERE ool.ship_from_org_id = '"+organizationId+"'   AND ool.header_id = ooh.header_id "+
   				  // "	AND ooh.org_id = '"+orgId+"'   AND ool.line_category_code = 'ORDER' "+ 
   				   "	AND ool.line_category_code = 'ORDER' AND OOH.SOLD_TO_ORG_ID = AC.CUSTOMER_ID "+ 
   				   "	AND ool.cancelled_flag = 'N'   AND ool.ship_from_org_id = msi.organization_id "+ 
   				   "    AND ool.inventory_item_id = msi.inventory_item_id "+ 
   				   "    AND ool.inventory_item_id NOT IN (29570, 29560, 29562, 66996) "+
  				   "    AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING','AWAITING_APPROVE') "+   
 				   "    AND ool.inventory_item_id = '"+itemId+"' ";
	 			   				   				 
    String orderBy = " order by  ool.schedule_ship_date  ";				 			   				   
	 
    sqlB = sqlB + where + orderBy;	
    // out.println("sqlB="+sqlB);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlB);	
   %>
  <table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">
      <tr><td colspan="10" align="right">
         <input type='button' name='IMPORT' size='20' value='EXCEL' onClick='setSubmit("../jsp/TSCINVI6StockExcel.jsp?TYPEID=3&ITEM_ID=<%=itemId%>&ORGANIZATION_ID=<%=organizationId%>")'>
      </td></tr>
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>GROUP</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Customer Name</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Order No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Item No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Description</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Order Date</FONT></td>	 
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Schedule Ship Date</FONT></td>	
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Unship Qty</FONT></td>	
	   <td NOWRAP><FONT  COLOR="#EEEEEE">UOM</FONT></td> 
	  </TR> 
   <%   
   while (rs.next())
   { 
     groupArea=rs.getString("GROUP_NAME");
     //hub=rs.getString("HUB");
     custName=rs.getString("CUSTOMER_NAME");
	 orderNo=rs.getString("ORDER_NUMBER");
     invItem=rs.getString("ITEM_NO");  
	 itemDesc=rs.getString("DESCRIPTION");
	 orderDate=rs.getString("ORDERED_DATE");
	 schDate=rs.getString("SCHEDULE_SHIP_DATE");
	 orderQty=rs.getString("ORDER_QTY");
     orderQtyf=rs.getFloat("ORDER_QTY");
     itemUom=rs.getString("UOM");  
     sumQtyf=sumQtyf+orderQtyf;

     if (groupArea==null || groupArea.equals("")) groupArea="&nbsp"; 
    // if (hub==null || hub.equals("")) hub="&nbsp"; 
     if (custName==null || custName.equals("")) custName="&nbsp"; 
     if (orderNo==null || orderNo.equals("")) orderNo="&nbsp"; 
     if (orderDate==null || orderDate.equals("")) orderDate="N/A"; 
     if (schDate==null || schDate.equals("")) schDate="N/A";
     if (orderQty==null || orderQty.equals("")) orderQty="&nbsp";  
    %>	 
     <TR onmouseover=bgColor='#CCFF99' onmouseout=bgColor='#FFFFFF'>
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=groupArea%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=custName%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderNo%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=orderDate%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=schDate%></FONT></TD>	 
	   <TD NOWRAP><div align="right"><FONT SIZE=2><%=orderQty%>&nbsp;&nbsp;</FONT></div></TD>	
 	   <TD NOWRAP><div align="center"><FONT SIZE=2><%=itemUom%></FONT></div></TD>
    </TR>	 

	<%
	k=k+1;
   } //end of while
  %>
     <TR bgcolor="#BBD3E1">
       <TD NOWRAP colspan="8"><div align="right"><FONT SIZE=2> Total 未交數</FONT></div></TD>
       <TD><div align="right"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD> 
       <TD><div align="center">KPC</div></TD>
     </TR>
     </TABLE>
   <%
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=3 //I1 訂單未交


if (typeId=="4" || typeId.equals("4"))   //typeid=4  // subinventory on_hand list
{
  String invCode="",invDesc="";
 
    if( organizationId == "326" || organizationId.equals("326"))
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('325')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '325')}");
	   cs1.execute();
       cs1.close();
      }
    else
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	   cs1.execute();
       cs1.close();
      }

  try
  {   
    String sqlB = "  SELECT  inv.secondary_inventory_name inv_code,inv.description inv_desc, msi.segment1 item_no, msi.description, "+
                  //"          SUM (moq.primary_transaction_quantity) onhand_qty,msi.primary_uom_code uom, moq.inventory_item_id "+
				  "          SUM (moq.TRANSACTION_QUANTITY/case when TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END) onhand_qty,'KPC' uom, moq.inventory_item_id "+
              	  "    FROM mtl_onhand_quantities_detail moq,mtl_secondary_inventories inv, mtl_system_items msi ";

    String where = "  WHERE moq.organization_id = msi.organization_id   AND moq.inventory_item_id = msi.inventory_item_id "+
              	   "    AND moq.organization_id = '"+organizationId+"'   AND moq.organization_id = inv.organization_id "+
			   	   "    AND moq.subinventory_code = inv.secondary_inventory_name "+
			 	   "    AND moq.inventory_item_id='"+itemId+"'";

    String groupBy ="   GROUP BY inv.SECONDARY_INVENTORY_NAME,INV.DESCRIPTION,msi.segment1,msi.description,moq.inventory_item_id  ";
		            //"             msi.primary_uom_code,moq.inventory_item_id ";
	 			   				   				 
    String orderBy = " order by  inv.secondary_inventory_name   ";				 			   				   
	 
    sqlB = sqlB + where +groupBy+ orderBy;	
     //out.println("sqlB="+sqlB);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlB);	
   %>
  <table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="80%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#000088">
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>SUB_INV Code</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>SUB_INV Desc</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Item No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>Description</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>On Hand Qty</FONT></td>	 
	   <td NOWRAP><FONT  COLOR="#EEEEEE">UOM</FONT></td> 
	  </TR> 
   <%   
   while (rs.next())
   { 
     invCode=rs.getString("INV_CODE");
     invDesc=rs.getString("INV_DESC");
     invItem=rs.getString("ITEM_NO");  
	 itemDesc=rs.getString("DESCRIPTION");
	 orderQty=rs.getString("ONHAND_QTY");
     orderQtyf=rs.getFloat("ONHAND_QTY");
     itemUom=rs.getString("UOM");  
     sumQtyf=sumQtyf+orderQtyf;

     if (invCode==null || invCode.equals("")) invCode="&nbsp"; 
    // if (hub==null || hub.equals("")) hub="&nbsp"; 
     if (invDesc==null || invDesc.equals("")) invDesc="&nbsp"; 

    %>	 
     <TR onmouseover=bgColor='#FFFFCC' onmouseout=bgColor='#FFFFFF'>
	   <TD NOWRAP><FONT SIZE=2><%=invCode%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invDesc%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><div align="right"><FONT SIZE=2><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=0%>','<%=invCode%>','<%=organizationId%>')"><%=orderQty%></a></FONT></div></TD>	
 	   <TD NOWRAP><div align="center"><FONT SIZE=2><%=itemUom%></FONT></div></TD>
    </TR>	 

	<%
	k=k+1;
   } //end of while
  %>
     <TR bgcolor="#BBD3E1">
       <TD NOWRAP colspan="4"><div align="right"><FONT SIZE=2> Total Qty</FONT></div></TD>
       <TD><div align="right"><FONT SIZE=2><%=(new DecimalFormat("######0.###")).format(sumQtyf)%></FONT></div></TD> 
       <TD><div align="center">KPC</div></TD>
     </TR>
     </TABLE>
   <%
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=4 // subinventory on_hand list
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%

%>
</html>

