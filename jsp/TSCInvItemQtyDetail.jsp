<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
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
.style2 {color: #000066}
</STYLE>
<title>INV Item Demand/Supply Information</title>
</head>
<body>
<div align="right"><a href="JavaScript:self.close()">Closed Windows</a>
  <% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
  String currentWeek = workingDateBean.getWeekString();

  String woNo=request.getParameter("WONO");
  String runCardNo=request.getParameter("RUNCARDNO");
  
  String dateSetBegin=request.getParameter("DATESETBEGIN");
  String dateSetEnd=request.getParameter("DATESETEND");
  
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");    
  if (YearFr==null && MonthFr==null && DayFr==null) dateSetBegin="20060110"; 
  else  dateSetBegin = YearFr+MonthFr+DayFr;  

  String YearTo=request.getParameter("YEARTO");
  String MonthTo=request.getParameter("MONTHTO");
  String DayTo=request.getParameter("DAYTO");
  if (YearTo==null && MonthTo==null && DayTo==null) dateSetEnd="20101231"; 
  else  dateSetEnd = YearTo+MonthTo+DayTo;
  
  String itemID=request.getParameter("ITEM_ID");
  String assignManufact=request.getParameter("ASSIGN_MANUFACT");
  String organizationID="",subinventoryCode="",description="",onhandQty="",uom="";
  float assetQty=0;


  
  String Sql="";
  String conti="N";
  int k=1;
  
  try
  {   

  //各倉別庫存數
    String sql = " SELECT a.subinventory_code, b.description,SUM(a.transaction_quantity) onhand_qty,a.TRANSACTION_UOM_CODE UOM FROM mtl_onhand_quantities_detail a, mtl_secondary_inventories b ";
    String where = " WHERE a.subinventory_code = b.secondary_inventory_name  AND a.organization_id = b.organization_id "+
				   "   AND a.inventory_item_id = '"+itemID+"' ";

//資產倉總數量
    String assetSql = " SELECT sum(a.transaction_quantity) asset_qty  FROM mtl_onhand_quantities_detail a, mtl_secondary_inventories b " ;
    String assetWhere = " WHERE a.subinventory_code = b.secondary_inventory_name   AND a.organization_id = b.organization_id   AND b.asset_inventory='1' "+
                        "    AND a.inventory_item_id = '"+itemID+"' ";

      if ( assignManufact=="002" || assignManufact.equals("002") )
          { 
            where = where + "  and a.organization_id='327'  ";
            assetWhere = assetWhere +"  and a.organization_id='327'  ";
            organizationID="327";
          }
      else if ( assignManufact=="003" || assignManufact.equals("003") 
             || assignManufact=="004" || assignManufact.equals("004")
             || assignManufact=="005" || assignManufact.equals("005") 
             || assignManufact=="006" || assignManufact.equals("006"))
            { 
             where = where + " and a.organization_id='49'  ";
             assetWhere = assetWhere +"  and a.organization_id='49'  ";
             organizationID="49"; 
             }
      else { 
             where = where + "  and a.organization_id='0'  ";
             assetWhere = assetWhere +"  and a.organization_id='0'  ";
             organizationID="0";
            }
	 			   				   				 
    String gorup	= " GROUP BY a.organization_id, b.description, a.subinventory_code,a.TRANSACTION_UOM_CODE " ;  

    

    assetSql = assetSql + assetWhere ;	
    //out.println("<br>assetSql="+assetSql);

    Statement stateat=con.createStatement(); 
    ResultSet rsat=stateat.executeQuery(assetSql);
    if (rsat.next())
    {
		assetQty=rsat.getFloat("ASSET_QTY"); 
      //  out.print("***assetQty="+assetQty);
    }
    rsat.close();   
    stateat.close();
     			   				   
	 
    sql = sql + where + gorup;	
    //  out.println("<br>sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sql);	
   %>
</div>
<TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' align='center' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399" height="3"><TD NOWRAP bgcolor="#000055" colspan="5"><div align="center"><FONT color="#FFFFFF"><strong>SUBINENTORY ONHAND QTY List</strong></FONT></div></TD>
      </TR>
      <TR bgcolor="#003399">
       <TD NOWRAP width="10%"><FONT color="#FFFFFF">&nbsp;</FONT></TD>
	   <TD NOWRAP width="20%"><div align="center"><FONT color="#FFFFFF">Subinventory</FONT></div></TD>
	   <TD NOWRAP width="30%"><div align="center"><FONT COLOR='#FFFFFF'>Code</FONT></div></TD>
	   <TD NOWRAP width="20%"><div align="center"><FONT COLOR='#FFFFFF'>Onhand Qty</FONT></div></TD>
        <TD NOWRAP width="20%"><div align="center"><FONT COLOR='#FFFFFF'>UOM</FONT></div></TD>
	  </TR> 
   <%   
   while (rs.next())
   { 
     subinventoryCode=rs.getString("SUBINVENTORY_CODE");  
	 description=rs.getString("DESCRIPTION");
	 onhandQty=rs.getString("ONHAND_QTY");
     uom=rs.getString("UOM");

    %>	 	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><div align="center"><FONT COLOR='#000000'><%=k%></FONT></div></TD>
	   <TD NOWRAP><div align="center"><FONT COLOR='#000000'><%=subinventoryCode%></FONT></div></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=description%></FONT></TD>
       <TD NOWRAP align="right"><div align="center"><FONT COLOR='#000000'><%=onhandQty%></FONT></div></TD>
       <TD NOWRAP align="right"><div align="center"><FONT COLOR='#000000'><%=uom%></FONT></div></TD>
  </TR> 
	<%
	k=k+1;
   } //end of while

   rs.close();   
   statement.close();
%>
</TABLE>
<br><br><br>

<%
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  try
  { 

   String requirementDate="",dsType="",dataNum="";
   float txnQty=0;
   int h=1;
   
   String sqlds=" SELECT msi.inventory_item_id,ool.SHIP_FROM_ORG_ID,'Sales Order' SUPPLY_DEMAND_TYPE, "+
     		    " 		 to_char(ooh.order_number) IDENTIFIER,msi.segment1 item_no, "+
				"  	     decode(ORDER_QUANTITY_UOM,'PCE',ool.ORDERED_QUANTITY/1000, ool.ORDERED_QUANTITY)*-1 QTY, "+
     			"  		 trunc(ool.SCHEDULE_SHIP_DATE)  REQUIREMENT_DATE "+
				"   from oe_order_headers_all ooh, oe_order_lines_all ool,mtl_system_items msi "+
				"   where ooh.HEADER_ID = ool.HEADER_ID "+
 			    "     and ool.inventory_item_id  = msi.inventory_item_id "+
 				"	  and ool.OPEN_FLAG='Y' "+
				"	  and ool.SHIP_FROM_ORG_ID = msi.organization_id "+
 				" 	  and ool.FLOW_STATUS_CODE in ('AWAITING_SHIPPING','ENTERED') "+
 				"	  and ool.inventory_item_id = "+itemID+" "+
 				"     and ool.SHIP_FROM_ORG_ID = "+organizationID+" "+
				" UNION ALL  "+
				"  SELECT ms.item_id , ms.to_organization_id , 'Purchase Order' demand_supply_type ,   "+
				"         pha.segment1 po_number  , msi.segment1 item_no , ms.quantity , ms.expected_delivery_date   "+
				"	 FROM mtl_supply ms, MTL_SYSTEM_ITEMS_B msi , po_headers_all pha   "+
				" 	WHERE ms.item_id = msi.inventory_item_id   "+
				"	  AND ms.to_organization_id = msi.organization_id  "+
				"	  AND ms.po_header_id = pha.po_header_id  "+
				" 	  AND ms.item_id= "+itemID+" "+
				"	  AND ms.to_organization_id = "+organizationID+" "+
				" UNION ALL  "+
				"  SELECT ms.item_id, ms.to_organization_id, 'PO Requisition' demand_supply_type, "+ 
				"         pra.segment1 pr_number, msi.segment1 item_no , ms.quantity , ms.expected_delivery_date "+  
				"	 FROM mtl_supply ms, mtl_system_items_b msi, po_requisition_headers_all pra  "+
				"	WHERE ms.item_id = msi.inventory_item_id  "+
				"     AND ms.to_organization_id = msi.organization_id   "+
				"	  AND ms.req_header_id = pra.requisition_header_id "+
				"	  AND ms.item_id="+itemID+" "+
				"	  AND ms.to_organization_id =  "+organizationID+" "+
				"   UNION ALL  "+
				"  SELECT wro.inventory_item_id, wro.organization_id , 'WIP Job Demand' supply_demand_type, we.wip_entity_name, "+  
      			"	      wro.segment1, (wro.required_quantity - wro.quantity_issued)*-1 qty_open , wro.date_required "+
				"	 FROM wip_discrete_jobs wdj, wip_entities we, wip_requirement_operations wro   "+
				"	WHERE wdj.wip_entity_id = we.wip_entity_id  "+
				"	  AND we.wip_entity_id = wro.wip_entity_id  "+
				"	  AND wdj.status_type = 3  "+
				"	  AND wro.required_quantity - wro.quantity_issued > 0  "+
				"	  AND wro.inventory_item_id = "+itemID+" "+
				"	  AND we.organization_id =  "+organizationID+" "+
				"	UNION ALL  "+
				"  SELECT wdj.primary_item_id , wdj.organization_id , 'WIP Job Supply' supply_demand_type, we.wip_entity_name , "+
       			"         msi.segment1, wdj.start_quantity  - wdj.quantity_completed quantity_pending , wdj.scheduled_completion_date    "+
				"	 FROM wip_discrete_jobs wdj, wip_entities we, MTL_SYSTEM_ITEMS_B msi  "+
				"	WHERE wdj.wip_entity_id = we.wip_entity_id  "+
				"	  AND wdj.status_type = 3  "+
				"	  AND wdj.primary_item_id = msi.inventory_item_id  "+
				"	  AND wdj.organization_id = msi.organization_id  "+
				"	  AND wdj.primary_item_id = "+itemID+" "+
				"	  AND wdj.organization_id =  "+organizationID+" ";
   String gorupds=" order by 6,4 ";

    sqlds = sqlds + gorupds;	
     //out.println("<br>sqlds="+sqlds);
    Statement stateds=con.createStatement(); 
    ResultSet rsds=stateds.executeQuery(sqlds);	
%>
<hr>
<br>
<TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' align='center' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399" height="3"><TD NOWRAP bgcolor="#669900" colspan="6"><div align="center"><FONT color="#FFFFFF"><strong> Item Supply / Demand List </strong></FONT></div></TD>
      </TR>
      <TR bgcolor="#003399">
       <TD width="10%" NOWRAP bgcolor="#99CC33">&nbsp;</TD>
       <TD width="20%" NOWRAP bgcolor="#99CC33"><div align="center" class="style2">DATE</div></TD>
	   <TD width="20%" NOWRAP bgcolor="#99CC33"><div align="center" class="style2">SUPPLY_DEMAND_TYPE</div></TD>
	   <TD width="20%" NOWRAP bgcolor="#99CC33"><div align="center" class="style2">IDENTIFIER</div></TD>
	   <TD width="15%" NOWRAP bgcolor="#99CC33"><div align="center" class="style2">Transaction Qty</div></TD>
       <TD width="15%" NOWRAP bgcolor="#99CC33"><div align="center" class="style2">Balance</div></TD>
	  </TR> 
	  <TR BGCOLOR='#FFFFFF'>
       <TD NOWRAP align="center" colspan="5"><div align="right"><strong><FONT COLOR='#000000'>&nbsp;</FONT></strong></div></TD>
       <TD NOWRAP align="center" ><div align="center"><strong><FONT COLOR='#000000'><%=assetQty%></FONT></strong></div></TD>
      </TR>
   <%   
   while (rsds.next())
   { 
     requirementDate=rsds.getString("REQUIREMENT_DATE");  
	 dsType=rsds.getString("SUPPLY_DEMAND_TYPE");
	 dataNum=rsds.getString("IDENTIFIER");
     txnQty=rsds.getFloat("QTY");
     assetQty=assetQty+txnQty;

     String fontColor="#000000";
     if ( assetQty <=0 ) fontColor="#FF0000";

     String colorStr="#FFFFFF";
    %>	 	 
     <TR  onmouseover=bgColor='#FBFE81' onmouseout=bgColor='<%=colorStr%>'> 
	   <TD NOWRAP><div align="center"><FONT COLOR='#000000'><%=h%></FONT></div></TD>
	   <TD NOWRAP><div align="center"><FONT COLOR='#000000'><%=requirementDate%></FONT></div></TD>
	   <TD NOWRAP><div align="center"><FONT COLOR='#000000'><%=dsType%></FONT></div></TD>
       <TD NOWRAP align="right"><div align="center"><FONT COLOR='#000000'><%=dataNum%></FONT></div></TD>
       <TD NOWRAP align="right"><div align="center"><FONT COLOR='#000000'><%=txnQty%></FONT></div></TD>
       <TD NOWRAP align="right"><div align="center"><FONT COLOR='<%=fontColor%>'><%=assetQty%></FONT></div></TD>
  </TR> 
	<%
	h=h+1;
   } //end of while
   //out.println("</TABLE><BR><P><P><P>");
   rsds.close();   
   stateds.close();
  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception 2:"+e.getMessage());
  }
 %>
</TABLE>


</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

