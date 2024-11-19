<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,SendMailBean,WorkingDateBean,CodeUtil" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
</head>

<body>
<%
    String userMail=null;
	String UserID=null;
	String urAddress=null;
	String getWebID = null;
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
			
	
	 dateBean.setAdjDate(-1);
	 String strFirstDayWeek = dateBean.getYearMonthDay();
	 String strLastDayWeek = strFirstDayWeek;
     dateBean.setAdjDate(1);

    String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME,WEBID from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE   "+
   						  "  where lockflag = 'N'    and rolename IN ('admin') "+
		 				  "		or  username in ( "+
    					  "		select distinct A.USER_NAME  "+
							"	 from     "+
							"    (select  OOL.LINE_ID,ODS.LINE_LOCATION_ID,FUSER.USER_NAME,ODS.PO_HEADER_ID,  "+
					        "			  ( sum(OOL.ORDERED_QUANTITY)-nvl(sum(OOL.SHIPPED_QUANTITY),0))*( decode(OOL.ORDER_QUANTITY_UOM,'PCE',1,'KPC',1000)) as MO_PCEQTY		  "+		       
  							"	  	 from OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL,OE_DROP_SHIP_SOURCES ODS ,RA_CUSTOMERS RA ,FND_USER FUSER   "+
							"        where  OOH.HEADER_ID=OOL.HEADER_ID     "+
							"               and ODS.LINE_ID=OOL.LINE_ID     "+
							"  	      and OOL.CANCELLED_FLAG !='Y'     "+
							"  	      and OOL.FLOW_STATUS_CODE != 'CLOSED'    "+
							" 		  and RA.CUSTOMER_ID = OOH.SOLD_TO_ORG_ID    "+ 
							" 		  and OOH.CREATED_BY = FUSER.USER_ID   "+
							"  	 group by OOL.LINE_ID,ODS.LINE_LOCATION_ID,FUSER.USER_NAME,OOL.SHIPPED_QUANTITY,OOL.ORDER_QUANTITY_UOM ,ODS.PO_HEADER_ID) A,     "+ 
				"                  (select distinct pll.line_location_id,ODS.LINE_ID,poh.po_header_id ,  "+
				" 		                  (sum(pll.quantity)-nvl(sum(pll.quantity_received),0))*( decode(POL.UNIT_MEAS_LOOKUP_CODE,'PCE',1,'KPC',1000)) as PO_PCEQTY   "+
				"                   from oe_drop_ship_sources ods,po_headers_all poh,po_line_locations_all pll , po_lines_all pol     "+
				"                   where ods.PO_HEADER_ID=poh.PO_HEADER_ID      "+
				"                         and ods.LINE_LOCATION_ID=pll.line_location_id      "+ 
				"  		                 and poh.po_header_id=pll.po_header_id   "+
				"                         and pol.po_line_id=pll.po_line_id        "+
				"  		              and pll.closed_code !='CLOSED'     "+
				" 					  and poh.AUTHORIZATION_STATUS='APPROVED'   "+
				" 					  group by pll.line_location_id,ODS.LINE_ID,pll.quantity_received,POL.UNIT_MEAS_LOOKUP_CODE,poh.po_header_id  ) B   "+
   				" where A.PO_HEADER_ID=B.PO_HEADER_ID(+)     "+
				"         and A.LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)     "+
				" 	    and B.LINE_ID(+)=A.LINE_ID        "+
				" 	    and a.MO_PCEQTY != b.PO_PCEQTY  )  ";
	//out.println(sSqlMailUser);
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	  // 再找 當日有開單的名單發E-Mail
String  sSql =  " select count(A.USER_NAME)  "+
 	 			" from     "+
				"    (select      OOL.LINE_ID,ODS.LINE_LOCATION_ID,FUSER.USER_NAME,ODS.PO_HEADER_ID,  "+
				 "         ( sum(OOL.ORDERED_QUANTITY)-nvl(sum(OOL.SHIPPED_QUANTITY),0))*( decode(OOL.ORDER_QUANTITY_UOM,'PCE',1,'KPC',1000)) as MO_PCEQTY		  "+		       
  				" 	 from OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL,OE_DROP_SHIP_SOURCES ODS ,RA_CUSTOMERS RA ,FND_USER FUSER   "+
				"        where  OOH.HEADER_ID=OOL.HEADER_ID     "+
				"               and ODS.LINE_ID=OOL.LINE_ID     "+
				"  	      and OOL.CANCELLED_FLAG !='Y'     "+
				"  	      and OOL.FLOW_STATUS_CODE != 'CLOSED'    "+
				" 		  and RA.CUSTOMER_ID = OOH.SOLD_TO_ORG_ID    "+ 
				" 		  and OOH.CREATED_BY = FUSER.USER_ID   "+
				"  	 group by OOL.LINE_ID,ODS.LINE_LOCATION_ID,FUSER.USER_NAME,OOL.SHIPPED_QUANTITY,OOL.ORDER_QUANTITY_UOM ,ODS.PO_HEADER_ID) A,     "+ 
				"                  (select distinct pll.line_location_id,ODS.LINE_ID,poh.po_header_id ,  "+
				" 		                  (sum(pll.quantity)-nvl(sum(pll.quantity_received),0))*( decode(POL.UNIT_MEAS_LOOKUP_CODE,'PCE',1,'KPC',1000)) as PO_PCEQTY   "+
				"                   from oe_drop_ship_sources ods,po_headers_all poh,po_line_locations_all pll , po_lines_all pol     "+
				"                   where ods.PO_HEADER_ID=poh.PO_HEADER_ID      "+
				"                         and ods.LINE_LOCATION_ID=pll.line_location_id      "+ 
				"  		                 and poh.po_header_id=pll.po_header_id   "+
				"                         and pol.po_line_id=pll.po_line_id        "+
				"  		              and pll.closed_code !='CLOSED'     "+
				" 					  and poh.AUTHORIZATION_STATUS='APPROVED'   "+
				" 					  group by pll.line_location_id,ODS.LINE_ID,pll.quantity_received,POL.UNIT_MEAS_LOOKUP_CODE,poh.po_header_id  ) B   "+
   				" where A.PO_HEADER_ID=B.PO_HEADER_ID(+)     "+
				"         and A.LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)     "+
				" 	    and B.LINE_ID(+)=A.LINE_ID        "+
				" 	    and a.MO_PCEQTY != b.PO_PCEQTY    "+
				"	    and A.USER_NAME='"+rsMail.getString("USERNAME")+"' ";

  //sSql = sSql + sFrom + sWhere  ;

//out.println("  sqpl="+sSql+"<br>");

	  Statement stmentRFQ=con.createStatement();
      ResultSet rsRFQ=stmentRFQ.executeQuery(sSql);
	  if (rsRFQ.next() && rsRFQ.getInt(1)>0) // 判斷昨日有開單的人,才寄送郵件
	  {
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		
		   getWebID = rsMail.getString("WEBID");   
	       //userMail="kerwin@mail.ts.com.tw";
		   //UserID ="liling";		
		   //getWebID ="AG000392"; 
           out.println("mail="+rsMail.getString("USERMAIL"));

		   urAddress = serverHostName+":8080/oradds/jsp/TSSHPMoNoBalanceRPT.jsp";
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(userMail); 
		//  sendMailBean.setFrom(UserID);        
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("DropShip Invoice Process System E-Mail- SalesOrder mapping PO not Balence Report("+strFirstDayWeek+"~"+strLastDayWeek+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自DROPSHIP出貨發票處理系統的郵件: 客戶訂單與採購單數量不平報表-("+strFirstDayWeek+"~"+strLastDayWeek+")"));     
		  // sendMailBean.setUrlName(rsMail.getString("USERMAIL")+" Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自DROPSHIP出貨發票處理系統的郵件: 客戶訂單與採購單數量不平報表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   System.out.println("UserID="+UserID);
	       sendMailBean.setUrlAddr(urAddress);
		   System.out.println("userMail="+userMail);
           sendMailBean.sendMail();
		
		  } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch	
		}  // End of if (rsRFQ.next() && rsRFQ.getInt(1)>0)  
		stmentRFQ.close();
		rsRFQ.close();
		
		  
    } // End of while
	stmentMail.close();
	rsMail.close();
	
	workingDateBean.setAdjWeek(1);  // 把週別調整回來
   out.println("send mail completed!!");
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

