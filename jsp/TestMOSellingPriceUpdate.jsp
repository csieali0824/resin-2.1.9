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
		
		            //Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
					 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_SPRICE_UPDATE(?,?,?,?,?,?,?,?,?,?,?,?)}");			 
					 cs3.setString(1,"41");  //  Org ID 	
					 cs3.setInt(2,3077); // User ID 					 
					 cs3.setInt(3,50124);  //  使用的Responsibility ID --> TSC_OM_Semi_SU									 
					 cs3.setString(4,"6042");  //  Customer Price List						 
					 cs3.setInt(5,89036);  //  Order Header ID 	
					 cs3.setInt(6,1);  //   Order line No 						 
					 cs3.setInt(7,11036);  //  Inventory Item ID	
					 cs3.setDouble(8,3500);  //  User Selling Price 						 					  		
					 cs3.registerOutParameter(9, Types.VARCHAR); //  訂單處理訊息 
					 cs3.registerOutParameter(10, Types.INTEGER); //  訂單HEADER ID 
					 cs3.registerOutParameter(11, Types.VARCHAR); //  訂單號碼 
					 cs3.registerOutParameter(12, Types.VARCHAR); //  未成功錯誤訊息 
					 cs3.execute();
					 // out.println("Procedure : Execute Success !!! ");
					 processStatus = cs3.getString(9);					
					 headerID = cs3.getInt(10);   // 把第二次的更新 Header ID 取到<br>					 
					 //double orderNo = cs3.getDouble(12);
					 orderNo = cs3.getString(11);					 
					 errorMessageHeader = cs3.getString(12);
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
