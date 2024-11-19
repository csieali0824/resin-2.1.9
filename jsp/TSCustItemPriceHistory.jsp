<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
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
<title>The History Record about Ordered Item Price Data</title>
</head>
<body> 
<% 
   //out.println("0");
  String inquType=request.getParameter("INQUTYPE");
  String inspLotNo=request.getParameter("INSPLOTNO"); 
  String line_No=request.getParameter("LINE_NO"); 
  String headerID=request.getParameter("HEADERID");
  
  String vendorLotNum=request.getParameter("VENDORLOTNO");
  
  String custID=request.getParameter("CUSTID");
  String invItemID=request.getParameter("ITEMID"); 
  
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
  
  //String invItem="", itemDesc="",transactionDate="",frOpSeqNum="",frOpCode="",toOpSeqNum="",toOpCode="";
  //String stepTypeCode="",transactionQty="",transactionUom="",lastUpdateBy="",lastUpdateDate="";
  
  if (inquType==null || inquType.equals(""))  inquType = "IQC"; // 由IQC 查詢,則含倉庫暫收資訊皆顯示
  
  if (inspLotNo==null || inspLotNo.equals("") || inspLotNo.equals("null")) inspLotNo = "尚未檢驗";
  
  if (headerID==null || headerID.equals("")) headerID = "";
  
   String orgOU = "";
   Statement stateOU=con.createStatement();   
   ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
   if (rsOU.next())
   {
     orgOU = rsOU.getString(1);
   }
   rsOU.close();
   stateOU.close();
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 //cs1.setString(1,"305"); 
	 cs1.setString(1,"41");  /*  41 --> 為台半半導體  42 --> 為事務機   325 --> YEW SEMI  */ 
	 cs1.execute();
     // out.println("Procedure : Execute Success !!! ");
     cs1.close(); 
	 
	/*  
	 if (interfaceID==null || interfaceID.equals(""))
	 { // 以IQC查詢,則找出當初暫收ID
	    //  取PO收料接收日期  // 
	    
	   String sqlRCVDate = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS where ATTRIBUTE6 = '"+inspLotNo+"' and TRANSACTION_TYPE ='RECEIVE' ";
	   Statement stateRCVDate=con.createStatement(); 
       ResultSet rsRCVDate=stateRCVDate.executeQuery(sqlRCVDate); 
	   if (rsRCVDate.next())
	   {
	      interfaceID = rsRCVDate.getString("INTERFACE_TRANSACTION_ID");
	   }
	   rsRCVDate.close();
	   stateRCVDate.close();
	   //  取PO收料接收日期  //	 
	 }
     */ 
	 
	   String sqlCUST = "select CUSTOMER_NAME from RA_CUSTOMERS where CUSTOMER_ID = '"+custID+"' ";
	   Statement stateCUST=con.createStatement(); 
       ResultSet rsCUST=stateCUST.executeQuery(sqlCUST); 
	   if (rsCUST.next())
	   {
	      inspLotNo = rsCUST.getString("CUSTOMER_NAME");
	   }
	   rsCUST.close();
	   stateCUST.close();
	   
	   String invItem = "";
	   String sqlItem = "select SEGMENT1, DESCRIPTION from MTL_SYSTEM_ITEMS where INVENTORY_ITEM_ID = '"+invItemID+"' and ORGANIZATION_ID = 43 ";
	   Statement stateItem=con.createStatement(); 
       ResultSet rsItem=stateItem.executeQuery(sqlItem); 
	   if (rsItem.next())
	   {
	      invItem = rsItem.getString("SEGMENT1")+"("+rsItem.getString("DESCRIPTION")+")";
	   }
	   rsItem.close();
	   stateItem.close();
 %>   
 </TABLE><BR>
<%
 
  
  String Sql="";
  String conti="N";
  int k=1;
  
  try
  {   
    String sql = " select (TO_CHAR(b.LINE_NUMBER)||'.'||TO_CHAR(b.SHIPMENT_NUMBER)) AS ITEM_NO, "+
       		     "        c.ORDER_NUMBER, to_char(b.REQUEST_DATE,'YYYY/MM/DD') as REQUEST_DATE, "+
				 "        to_char(b.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') as SCHEDULE_SHIP_DATE, "+
				 "        b.UNIT_SELLING_PRICE, b.UNIT_LIST_PRICE, a.OPERAND, "+	
				 "        b.PRICING_QUANTITY, b.SOLD_TO_ORG_ID, to_char(a.CREATION_DATE,'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE, "+
				 "        a.CREATED_BY, a.ADJUSTMENT_NAME, c.HEADER_ID,  "+		 
				 "        to_char(a.CREATION_DATE,'YYYYMMDDHH24MISS') || '-' ||  c.HEADER_ID as ORDERDATE "+
 			     "   from OE_PRICE_ADJUSTMENTS_V a, OE_ORDER_LINES_ALL b, OE_ORDER_HEADERS_ALL c ";
    String where = " where a.HEADER_ID = b.HEADER_ID and a.LINE_ID = b.LINE_ID "+
	               "   and a.HEADER_ID = c.HEADER_ID  "+
				   "   and b.INVENTORY_ITEM_ID = "+invItemID+" and b.SOLD_TO_ORG_ID = "+custID+" "+
	               "   and a.LIST_LINE_TYPE_CODE != 'TAX' ";
				   
	//if (line_No!=null && !line_No.equals("")) where = where + "and IQD.LINE_NO = "+line_No+" ";
	 			   				   				 
    String orderBy = " order by ORDERDATE desc ";				 			   				   
	 
    sql = sql + where + orderBy;	
    //out.println("sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sql);	
    
   %>
    <BR><font color="#330066" size="+2" face="Arial"><strong>Sales Order Item Price History</strong></font><BR>
	<font color="#993333" size="+2">Customer:</font><font color="#003399" size="+2"><%=inspLotNo%></font><font color="#993333" size="+2"></font>
	<BR>
	<font color="#993333" size="+2">Item Info:</font><font color="#003399" size="+2"><%=invItem%></font><font color="#993333" size="+2"></font>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='70%' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">	   
	   <TD width="4%" NOWRAP><FONT color="#FFFFFF">項次</FONT></TD>	   
	   <TD width="12%" NOWRAP><FONT COLOR='#FFFFFF'>銷售訂單號</FONT></TD>
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>需求日期</FONT></TD>
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>出貨日期</FONT></TD>
	   <TD width="15%" NOWRAP><FONT COLOR='#FFFFFF'>售價(Selling Price)</FONT></TD>
	   <TD width="13%" NOWRAP><FONT COLOR='#FFFFFF'>牌價(List Price)</FONT></TD>
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>調整價差</FONT></TD>
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>價格數量</FONT></TD>	   
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>執行人員</FONT></TD>
	   <TD width="8%" NOWRAP><FONT COLOR='#FFFFFF'>執行日期</FONT></TD>	       
	  </TR> 
   <%   
   while (rs.next())
   { 
     //out.println("1");
     //  取PO收料接收日期  // 
	   String createdBy = "";
	   String sqlRCVDate = "select USER_NAME from FND_USER where  USER_ID= "+rs.getString("CREATED_BY")+" ";
	   Statement stateRCVDate=con.createStatement(); 
       ResultSet rsRCVDate=stateRCVDate.executeQuery(sqlRCVDate); 
	   if (rsRCVDate.next())
	   {
	      createdBy = rsRCVDate.getString(1);
	   }
	   rsRCVDate.close();
	   stateRCVDate.close();
	 //  取PO收料接收日期  // 
	 
   //out.println("2");
	
   String itemNo="",className="",supplierName="",poNum="",inspectDate="";
   String action="",oriStatusId="",oriStatus="",lastUpdateBy="",lastUpdateDate="",processRemark="";
   //out.println("3");
     itemNo=rs.getString("ITEM_NO");  
	 /*
	 className=rs.getString("CLASS_NAME");
	 supplierName=rs.getString("SUPPLIER_NAME");
	 poNum=rs.getString("PO_NO");	 
	 inspectDate=rs.getString("INSPECT_DATE");	 
	 action=rs.getString("ACTIONNAME");
	 oriStatusId=rs.getString("ORISTATUSID");
	 oriStatus=rs.getString("ORISTATUS");
	 lastUpdateBy=rs.getString("USER_NAME");
	 lastUpdateDate=rs.getString("CDATETIME");
	 processRemark=rs.getString("PROCESS_REMARK");
	 oriStatus = oriStatusId + "("+oriStatus+")";
	 */
	//out.println("4"); 
    %>	 	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'>
	    <%
	      if (headerID.equals(rs.getString("HEADER_ID")))
		  {
	       out.println("<strong>"+itemNo+"</strong>");
		  } else {  out.println(itemNo);  }
	    %></FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#000000'>
	    <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("ORDER_NUMBER")+"</strong>");
		   } else {  out.println(rs.getString("ORDER_NUMBER"));  }
		%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'>
	    <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("REQUEST_DATE")+"</strong>");
		   } else {  out.println(rs.getString("REQUEST_DATE"));  }
		%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'>
	    <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("SCHEDULE_SHIP_DATE")+"</strong>");
		   } else {  out.println(rs.getString("SCHEDULE_SHIP_DATE"));  }
		%></FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#000000'>
	     <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("UNIT_SELLING_PRICE")+"</strong>");
		   } else {  out.println(rs.getString("UNIT_SELLING_PRICE"));  }
		 %></FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#000000'>
	     <%
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("UNIT_LIST_PRICE")+"</strong>");
		   } else {  out.println(rs.getString("UNIT_LIST_PRICE"));  }
		 %></FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#000000'>
	     <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("OPERAND")+"</strong>");
		   } else {  out.println(rs.getString("OPERAND"));  }
		 %></FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#000000'>
	     <% 
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+rs.getString("PRICING_QUANTITY")+"</strong>");
		   } else {  out.println(rs.getString("PRICING_QUANTITY"));  }
		 %></FONT></TD>	  
	   <TD NOWRAP><FONT COLOR='#000000'>
	     <%
		   if (headerID.equals(rs.getString("HEADER_ID")))
		   {
		     out.println("<strong>"+createdBy+"</strong>");
		   } else {  out.println(createdBy);  }
		 %></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'>
	     <%
		    if (headerID.equals(rs.getString("HEADER_ID")))
		    {
		     out.println("<strong>"+rs.getString("CREATION_DATE")+"</strong>");
		    } else {  out.println(rs.getString("CREATION_DATE"));  }
		 %></FONT></TD>	   		  
	  </TR> 
	<%
	  k=k+1;
   } //end of while
   //out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }  
  
  
%>
 </TABLE>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

