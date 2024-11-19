<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="SalesDRQPageHeaderBean" %-->
<!--jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/-->
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
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
             
</STYLE>
<title>The Stock Detail Data</title>
</head>
<body>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A> 
<% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
  String currentWeek = workingDateBean.getWeekString();

  String itemId=request.getParameter("ITEM_ID");
  String subItemId=request.getParameter("SUB_ITEM_ID");
  String organizationId=request.getParameter("ORGANIZATION_ID");
  String typeId=request.getParameter("TYPEID");   //typeid 1=成品庫存明細    2=訂單保留明細  3=工令明細
  String invItem="",itemDesc="",inventory="",lotNumber="",lotQty="",itemUom="",recvDate="";
  String woNo="",woStatus="",dateRelease="",woQty="",qtyComplete="",qtyScrape="";
  String lineNo="",cancelQty="",recvQty="",recvUom="";

 /* 
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
  
  String oriQty="", oriReason="",creationDate="",creationBy="",updateQty="",updateReason="" ;
*/
  String conti="N";
  int k=1;
  
//out.print("<br> itemd="+itemId+"  org="+organizationId+" type="+typeId);

if (typeId=="1" || typeId.equals("1"))  //typeid=1  //成品庫存量
{
  try
  {   
    String sqla = " select MSI.SEGMENT1 ITEM_NO,MSI.DESCRIPTION,MSI.PRIMARY_UNIT_OF_MEASURE UOM, "+
       			  "        MOQ.SUBINVENTORY_CODE,MOQ.LOT_NUMBER,MOQ.PRIMARY_TRANSACTION_QUANTITY FG_OH_QTY,  "+
			      "        to_char(trunc(MOQ.ORIG_DATE_RECEIVED),'yyyy/mm/dd') RECV_DATE "+
				  "   from MTL_ONHAND_QUANTITIES_DETAIL MOQ,MTL_SYSTEM_ITEMS MSI ";
    String where = " where MOQ.INVENTORY_ITEM_ID(+)=MSI.INVENTORY_ITEM_ID  and MOQ.ORGANIZATION_ID(+)=MSI.ORGANIZATION_ID "+
  				   "   and MSI.ORGANIZATION_ID = "+organizationId+"  and MSI.INVENTORY_ITEM_ID= "+itemId+" ";
	 			   				   				 
    String orderBy = " order by MOQ.SUBINVENTORY_CODE,MOQ.ORIG_DATE_RECEIVED ";				 			   				   
	 
    sqla = sqla + where + orderBy;	
    // out.println("sqla="+sqla);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqla);	
    
   %>
     <HR>
     <table cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>料號</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>品名/規格</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>倉別</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>批號</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>數量</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>單位</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>接收日</FONT></td>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem=rs.getString("ITEM_NO");  
	 itemDesc=rs.getString("DESCRIPTION");
	 inventory=rs.getString("SUBINVENTORY_CODE");
	 lotNumber=rs.getString("LOT_NUMBER");
	 lotQty=rs.getString("FG_OH_QTY");
	 itemUom=rs.getString("UOM");
	 recvDate=rs.getString("RECV_DATE");
    %>	 
	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=inventory%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=lotNumber%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=lotQty%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemUom%></FONT></TD>	 
	   <TD NOWRAP><FONT SIZE=2><%=recvDate%></FONT></TD>	   
    </TR> 
	<%
	k=k+1;
   } //end of while
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=1  //成品庫存量

if (typeId=="2" || typeId.equals("2"))   //typeid=1  訂單保留量
{
  try
  {   
    String sqlB = " SELECT MSI.SEGMENT1 ITEM_NO,MSI.DESCRIPTION,OOHA.ORDER_NUMBER, "+
        		  "        OOLA.LINE_NUMBER||'.'||OOLA.SHIPMENT_NUMBER AS RES_LINE_NUMBER, "+
				  "        TO_CHAR(OOLA.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') AS SCHEDULE_SHIP_DATE, "+
				  "        OOLA.ORDERED_QUANTITY   AS ORDERED_QTY, OOLA.ORDER_QUANTITY_UOM   AS ORDER_QUANTITY_UOM, "+
				  "        OOLA.CANCELLED_QUANTITY  AS CANCELLED_QTY,RVS.RESERVATION_QUANTITY AS RESERVATION_QTY, "+
			      "        RVS.RESERVATION_UOM_CODE AS RESERVATION_UOM, OOLA.CUSTOMER_LINE_NUMBER  AS END_CUSTOMER_PO,RVS.LOT_NUMBER "+
   				  "        FROM MTL_RESERVATIONS RVS ,OE_ORDER_HEADERS_ALL OOHA, OE_ORDER_LINES_ALL OOLA, MTL_SYSTEM_ITEMS MSI  ";
    String where = " where MSI.ORGANIZATION_ID= RVS.ORGANIZATION_ID   AND ooha.header_id = oola.header_id  "+
   				   "    AND oola.inventory_item_id = msi.inventory_item_id   AND oola.ship_from_org_id = msi.organization_id  "+ 
				   "    AND oola.line_id = RVS.demand_source_line_id(+) "+
  				   "   and RVS.ORGANIZATION_ID = "+organizationId+"  and RVS.INVENTORY_ITEM_ID= "+itemId+" ";
	 			   				   				 
    String orderBy = " order by  oola.schedule_ship_date  ";				 			   				   
	 
    sqlB = sqlB + where + orderBy;	
    // out.println("sqla="+sqla);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlB);	
    
   %>
     <HR>
     <table cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR="#000044">
	   <td NOWRAP><FONT  COLOR="#EEEEEE">No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>料號</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>品名/規格</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>訂單號</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>項次</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>預交日</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>訂單數量</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>UOM</FONT></td>	
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>保留數量</FONT></td> 
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>UOM</FONT></td> 
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>批號</FONT></td> 
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem=rs.getString("ITEM_NO");  
	 itemDesc=rs.getString("DESCRIPTION");
	 woNo=rs.getString("ORDER_NUMBER");
     lineNo=rs.getString("RES_LINE_NUMBER");
	 recvDate=rs.getString("SCHEDULE_SHIP_DATE");
	 woQty=rs.getString("ORDERED_QTY");
	 itemUom=rs.getString("ORDER_QUANTITY_UOM");
	 recvQty=rs.getString("RESERVATION_QTY");
	 recvUom=rs.getString("RESERVATION_UOM");
	 lotNumber=rs.getString("LOT_NUMBER");
    %>	 
	 
     <TR BGCOLOR="#FFFFFF"> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woNo%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=lineNo%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=recvDate%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woQty%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemUom%></FONT></TD>	
	   <TD NOWRAP><FONT SIZE=2><%=recvQty%></FONT></TD>	
	   <TD NOWRAP><FONT SIZE=2><%=recvUom%></FONT></TD>	
	   <TD NOWRAP><FONT SIZE=2><%=lotNumber%></FONT></TD>	 
    </TR> 
	<%
	k=k+1;
   } //end of while
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=2  //訂單保留量


if (typeId=="3" || typeId.equals("3"))   //typeid=3  工令數量
{
  try
  {   
    String sqlC = "  select YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_NO,decode(WDJ.STATUS_TYPE,'3','Release') WO_STATUS, "+
       			  "         trunc(WDJ.DATE_RELEASED) DATE_RELEASED,WDJ.START_QUANTITY WO_QTY,WDJ.QUANTITY_COMPLETED,WDJ.QUANTITY_SCRAPPED "+
   				  "    from WIP_DISCRETE_JOBS WDJ,YEW_WORKORDER_ALL YWA  ";

    String where = "  where WDJ.ORGANIZATION_ID = YWA.ORGANIZATION_ID  and WDJ.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID  and WDJ.STATUS_TYPE =3 "+
	 			   "   and WDJ.ORGANIZATION_ID = "+organizationId+" and WDJ.PRIMARY_ITEM_ID = "+itemId+"  ";
	 			   				   				 
    String orderBy = " order by YWA.WO_NO  ";				 			   				   
	 
    sqlC = sqlC + where + orderBy;	
    // out.println("sqlC="+sqlC);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlC);	
    
   %>
     <HR>
     <table cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR="#005500">
	   <td NOWRAP><FONT  COLOR="#EEEEEE">No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>料號</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>品名/規格</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>工令號</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>狀態</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>展卡日</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>工令數量</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>已完工數</FONT></td>	
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>報廢數</FONT></td>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem=rs.getString("INV_ITEM");  
	 itemDesc=rs.getString("ITEM_DESC");
	 woNo=rs.getString("WO_NO");
	 woStatus=rs.getString("WO_STATUS");
	 dateRelease=rs.getString("DATE_RELEASED");
	 woQty=rs.getString("WO_QTY");
	 qtyComplete=rs.getString("QUANTITY_COMPLETED");
	 qtyScrape=rs.getString("QUANTITY_SCRAPPED");
    %>	 
	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><a href="../jsp/TSCMfgWoDetail.jsp?WO_NO=<%=woNo%>"><%=woNo%></a></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woStatus%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=dateRelease%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woQty%></FONT></TD>	 
	   <TD NOWRAP><FONT SIZE=2><%=qtyComplete%></FONT></TD>	  
	   <TD NOWRAP><FONT SIZE=2><%=qtyScrape%></FONT></TD>	  
    </TR> 
	<%
	k=k+1;
   } //end of while
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=3  //工令數量


if (typeId=="4" || typeId.equals("4"))  //typeid=4  //半成品庫存量
{
  try
  {   
    String sqla = " select MSI.SEGMENT1 ITEM_NO,MSI.DESCRIPTION,MSI.PRIMARY_UNIT_OF_MEASURE UOM, "+
       			  "        MOQ.SUBINVENTORY_CODE,MOQ.LOT_NUMBER,MOQ.PRIMARY_TRANSACTION_QUANTITY FG_OH_QTY,  "+
			      "        to_char(trunc(MOQ.ORIG_DATE_RECEIVED),'yyyy/mm/dd') RECV_DATE "+
				  "   from MTL_ONHAND_QUANTITIES_DETAIL MOQ,MTL_SYSTEM_ITEMS MSI ";
    String where = " where MOQ.INVENTORY_ITEM_ID(+)=MSI.INVENTORY_ITEM_ID  and MOQ.ORGANIZATION_ID(+)=MSI.ORGANIZATION_ID "+
  				   "   and MSI.ORGANIZATION_ID = "+organizationId+"  and MSI.INVENTORY_ITEM_ID= "+subItemId+" ";
	 			   				   				 
    String orderBy = " order by MOQ.SUBINVENTORY_CODE,MOQ.ORIG_DATE_RECEIVED ";				 			   				   
	 
    sqla = sqla + where + orderBy;	
    // out.println("sqla="+sqla);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqla);	
    
   %>
     <HR>
     <table cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR="#000088">
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>料號</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>品名/規格</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>倉別</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>批號</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>數量</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>單位</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>接收日</FONT></td>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem=rs.getString("ITEM_NO");  
	 itemDesc=rs.getString("DESCRIPTION");
	 inventory=rs.getString("SUBINVENTORY_CODE");
	 lotNumber=rs.getString("LOT_NUMBER");
	 lotQty=rs.getString("FG_OH_QTY");
	 itemUom=rs.getString("UOM");
	 recvDate=rs.getString("RECV_DATE");
    %>	 
	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=inventory%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=lotNumber%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=lotQty%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=itemUom%></FONT></TD>	 
	   <TD NOWRAP><FONT SIZE=2><%=recvDate%></FONT></TD>	   
    </TR> 
	<%
	k=k+1;
   } //end of while
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=4  //半成品庫存量

if (typeId=="5" || typeId.equals("5"))   //typeid=3  工令數量
{
  try
  {   
    String sqlC = "  select YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_NO,decode(WDJ.STATUS_TYPE,'3','Release') WO_STATUS, "+
       			  "         trunc(WDJ.DATE_RELEASED) DATE_RELEASED,WDJ.START_QUANTITY WO_QTY,WDJ.QUANTITY_COMPLETED,WDJ.QUANTITY_SCRAPPED "+
   				  "    from WIP_DISCRETE_JOBS WDJ,YEW_WORKORDER_ALL YWA  ";

    String where = "  where WDJ.ORGANIZATION_ID = YWA.ORGANIZATION_ID  and WDJ.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID  and WDJ.STATUS_TYPE =3 "+
	 			   "   and WDJ.ORGANIZATION_ID = "+organizationId+" and WDJ.PRIMARY_ITEM_ID = "+subItemId+"  ";
	 			   				   				 
    String orderBy = " order by YWA.WO_NO  ";				 			   				   
	 
    sqlC = sqlC + where + orderBy;	
    // out.println("sqlC="+sqlC);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlC);	
    
   %>
     <HR>
     <table cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR="#005500">
	   <td NOWRAP><FONT  COLOR="#EEEEEE">No</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>料號</FONT></td>	   
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>品名/規格</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>工令號</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>狀態</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>展卡日</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>工令數量</FONT></td>
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>已完工數</FONT></td>	
	   <td NOWRAP><FONT  COLOR='#EEEEEE'>報廢數</FONT></td>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem=rs.getString("INV_ITEM");  
	 itemDesc=rs.getString("ITEM_DESC");
	 woNo=rs.getString("WO_NO");
	 woStatus=rs.getString("WO_STATUS");
	 dateRelease=rs.getString("DATE_RELEASED");
	 woQty=rs.getString("WO_QTY");
	 qtyComplete=rs.getString("QUANTITY_COMPLETED");
	 qtyScrape=rs.getString("QUANTITY_SCRAPPED");
    %>	 
	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=invItem%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=itemDesc%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><a href="../jsp/TSCMfgWoDetail.jsp?WO_NO=<%=woNo%>"><%=woNo%></a></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woStatus%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=dateRelease%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=woQty%></FONT></TD>	 
	   <TD NOWRAP><FONT SIZE=2><%=qtyComplete%></FONT></TD>	  
	   <TD NOWRAP><FONT SIZE=2><%=qtyScrape%></FONT></TD>	  
    </TR> 
	<%
	k=k+1;
   } //end of while
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
}  //end typeid=5  //前段工令數量


 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

