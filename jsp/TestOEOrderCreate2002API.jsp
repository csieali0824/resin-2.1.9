<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<!--%//@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Sales Delivery Request M Data Process</title>
<%@ page import="DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%

String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);;
   
   
 String processStatus = "";
 int headerID = 1;   // 把第二次的更新 Header ID 取到
 
 String orderNo = "";
 String errorMessageHeader = "";
   java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
   java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
   java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
   java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
   java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date
   
	String customerPO=request.getParameter("customerPO");
	String status =request.getParameter("status");
	String customerID =request.getParameter("customerID");
		
	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
    CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', 41)}");
	cs1.execute();
	cs1.close();

		//out.println("customerPO="+customerPO);
		//out.println("status="+status);
	try{   
		
		         CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_2002API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	             cs3.setString(1,"41");  /*  Org ID */	
				 cs3.setInt(2,3077);  /* User ID */	                   //out.println("oraUserID="+oraUserID);
				 cs3.setInt(3,50124);  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	//out.println("respID="+respID);
				 cs3.setInt(4,1021);  /*  Order Type ID */	       //out.println("firmOrderType="+firmOrderType);
				 cs3.setInt(5,1023);  /*  SoldToOrg = 客戶代號*/	   //out.println("firmSoldToOrg="+firmSoldToOrg);				
				 cs3.setInt(6,6039);  /*  PriceList */	           //out.println("firmPriceList="+firmPriceList);
				 cs3.setInt(7,1037);  /*  Ship To Org */                //out.println("ShipToOrg="+ShipToOrg);
				 cs3.setDate(8,orderedDate);  /*  Ordered Date */                              //out.println("orderedDate="+orderedDate);
				 cs3.setInt(9,1035);  /*  Bill To Org(Invoice To Org) */   //out.println("billTo="+billTo);
				 cs3.setInt(10,1023);  /*  Payment Term ID */           //out.println("payTermID="+payTermID); 
				 cs3.setString(11,"TRUCK");  /*  Shipping Method Code */	                   //out.println("shipMethod="+shipMethod); 
				 cs3.setString(12,"FOB TAIWAN");  /*  FOB Point Code  */                           //out.println("fobPoint="+fobPoint);    
				 cs3.setString(13,"TEST-JSP");  /*  Customer PO  */     	//out.println("custPO="+custPO);
				 cs3.setString(14,"N/A");  /*  Currency Code  */	// 不傳入Currency Code,由Price List自己帶入	 //out.println("Currency Code=N/A"); 	   	 
				 cs3.setInt(15,3346);  /*  InventoryItemID */	 //out.println("InventoryItemID="+aSalesOrderGenerateCode[i][7]);
				 cs3.setString(16,"1060-081R0016060000000");  /*  Ordered Item  */	                     //out.println("Ordered Item="+aSalesOrderGenerateCode[i][1]);				  
				 cs3.setFloat(17,1);  /*  Ordered Quantity */                                   //out.println("orderQty="+orderQty);   
				 cs3.setInt(18,1007);  /*  Line Type */	   //out.println("Line Type="+aSalesOrderGenerateCode[i][9]); 
				 cs3.setDate(19,shipdate);  /*  Schedule Shup Date */	                               //out.println("shipdate="+shipdate); 
				// cs3.setDate(20,requestdate);  /*  Request Date */	                                   //out.println("requestdate="+requestdate);  
				// cs3.setDate(21,pricedate);  /*  Pricing Date */	                                   //out.println("pricedate="+pricedate); 
				// cs3.setDate(22,promisedate);  /*  Promise Date */                                     //out.println("promisedate="+promisedate);   
				 cs3.setString(20,"INTERNAL");  /*  Source Type Code  */		                   //out.println("sourceTypeCode="+sourceTypeCode);
				 cs3.setFloat(21,0);  /*  Unit Selling Price */	//out.println("Unit Selling Price="+aSalesOrderGenerateCode[i][8]); 				 
				 cs3.setString(22,"SHIPPING INVOICE");  /*  Shipping Instructions發票號  */                            //out.println("Shipping Instructions=");
				 cs3.setString(23,"I");  /*  Packing Instructions生管判定產地  */         //out.println("packInstructions="+packInstructions); 
				 cs3.setString(24,"16-FEB-2006");  /*  Attributes8 生管交期排定日  */                     //out.println("oPcAcpDate="+oPcAcpDate);
				 cs3.setFloat(25,0);  /*  Unit Selling Price Per Q'ty */    //out.println("Unit Selling Price Per Q'ty="+aSalesOrderGenerateCode[i][8]);				 
				 cs3.setString(26,"KPC");  /*  更改的訂購單位  */                                 //out.println("primaryUOM="+primaryUOM);
				 cs3.setInt(27,3346);  /*  客戶料件ID  */  //out.println("客戶料件ID="+aSalesOrderGenerateCode[i][13]);				 
				 cs3.setString(28,"INT");  /*  Item ID Type  */              // out.println("Item ID Type="+aSalesOrderGenerateCode[i][14]);
				 cs3.setString(29,"N");  /*  Calculate Price Flag  */                         //out.println("calPriceFlag="+calPriceFlag);
				 cs3.setString(30,"N/A");  /*  Line Attribute1 --> 1211MO單之 Packing List No  */
				 cs3.setString(31,"TS00620060127-003");  /*  Header Attribute10 --> 置入交期詢問單號  */
				 cs3.setInt(32,0);  /* line 的 Warehouse ID-->Ship From ID  */				
	             cs3.registerOutParameter(33, Types.VARCHAR); /*  訂單處理訊息 */	
				 cs3.registerOutParameter(34, Types.INTEGER); /*  訂單HEADER ID */	
				 //cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
				 cs3.registerOutParameter(35, Types.VARCHAR); /*  訂單號碼 */	
				 cs3.registerOutParameter(36, Types.VARCHAR); /*  未成功錯誤訊息 */
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
				 processStatus = cs3.getString(33);
	             headerID = cs3.getInt(34);   // 把第二次的更新 Header ID 取到
				 //double orderNo = cs3.getDouble(12);
				 orderNo = cs3.getString(35);
				 errorMessageHeader = cs3.getString(36);
                 cs3.close();				  
	             if (errorMessageHeader==null ) 
				 { 
				   //errorMessageHeader = "&nbsp;";						   
				 } // End of if ()
	             //out.println("Request ID="+requestID);				
					 
					 
					 
					 out.println("headerID ="+headerID+"<br>");
					 out.println("processStatus ="+processStatus+"<br>");
					 out.println("orderNo ="+orderNo+"<br>");
					 out.println("errorMessageHeader ="+errorMessageHeader+"<br>");
					 cs3.close();			
		 
		 
	   }catch (Exception e) { out.println("Exception1:"+e.getMessage()); } 
 
  //	
				   

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
