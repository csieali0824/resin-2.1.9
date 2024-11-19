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
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	cs1.execute();
	cs1.close();

		//out.println("customerPO="+customerPO);
		//out.println("status="+status);
	try{   
		
		            //Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
					 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_CREATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
					 cs3.setString(1,"41");  //  Org ID 	
					 cs3.setInt(2,3077); // User ID 					 
					 cs3.setInt(3,50124);  //  使用的Responsibility ID --> TSC_OM_Semi_SU						 
					 cs3.setInt(4,1091);  //  Order Type ID 						 
					 cs3.setInt(5,2214);  //  SoldToOrg = 客戶代號					
					 cs3.setInt(6,7331);  //  PriceList 	
					 cs3.setInt(7,6626);  //  Ship To Org 
					 cs3.setDate(8,orderedDate);  //  Ordered Date 				 
					 cs3.setInt(9,3740);  //  Bill To Org(Invoice To Org) 					 
					 cs3.setInt(10,1149);  //  Payment Term ID  					 
					 cs3.setString(11,"AIR");  //  Shipping Method Code					 
					 cs3.setString(12,"DDP");  //  FOB Point Code  					 
					 cs3.setString(13,"123456");  //  Customer PO  					 
					 cs3.setString(14,"N/A");  //  Currency Code  	 // 不傳入Currency Code,由Price List自己帶入			 	 
					 cs3.setInt(15,7880);  //  InventoryItemID 						
					 cs3.setString(16,"1020-011R0011000000002");  //  Inventory Item					 
					 cs3.setFloat(17,3);  //  Ordered Quantity
					 cs3.setInt(18,1007);  //  Line Type 						 
					 cs3.setDate(19,shipdate);  //  Schedule Shup Date					 
					 cs3.setDate(20,requestdate);  //  Request Date					 	
					 cs3.setDate(21,pricedate);  //  Pricing Date					 
					 cs3.setDate(22,promisedate);  //  Promise Date					 
					 cs3.setString(23,"INTERNAL");  //  Source Type Code					 	
					 cs3.setFloat(24,0);  //  Unit Selling Price 					 
					 cs3.setString(25,"");  //  Shipping Instructions發票號					 
					 cs3.setString(26,"T");  //  Packing Instructions生管判定產地					 
					 cs3.setString(27,"28-JAN-2006");  //  Attributes8 生管交期排定日					 
					 cs3.setFloat(28,0);  //  Unit Selling Price Per Q'ty 				 
					 cs3.setString(29,"PCE");  //  更改的訂購單位				
					 cs3.setInt(30,0);  //  
					 cs3.setString(31,"INT");  //   
					 cs3.setString(32,"N");  //					
					 cs3.registerOutParameter(33, Types.VARCHAR); //  訂單處理訊息 
					 cs3.registerOutParameter(34, Types.INTEGER); //  訂單HEADER ID 
					 cs3.registerOutParameter(35, Types.VARCHAR); //  訂單號碼 
					 cs3.registerOutParameter(36, Types.VARCHAR); //  未成功錯誤訊息 
					 cs3.execute();
					 // out.println("Procedure : Execute Success !!! ");
					 processStatus = cs3.getString(33);					
					 headerID = cs3.getInt(34);   // 把第二次的更新 Header ID 取到<br>					 
					 //double orderNo = cs3.getDouble(12);
					 orderNo = cs3.getString(35);					 
					 errorMessageHeader = cs3.getString(36);
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

