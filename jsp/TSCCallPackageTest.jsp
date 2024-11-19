<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<A HREF='../RepairMainMenu.jsp'>首頁</A>&nbsp;&nbsp;<A HREF='../jsp/RPKeyAccountUpfile.jsp'>回上一頁</A><BR>  
<%


String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //


  // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
      
     //CallableStatement cs1 = con.prepareCall("{call TSC_RUN_ITEM_IMPORT(?)}");	
	 //cs1.setString(1,"43");  /*  application */	
	 //cs1.execute();    
     //cs1.close();
	 
	 CallableStatement cs1 = con.prepareCall("{call TSC_RUN_ITEM_IMPORT(?,?)}");			 
	 cs1.setString(1,"43");  /*  application */	
	 cs1.registerOutParameter(2, Types.INTEGER); 
	 cs1.execute();
     // out.println("Procedure : Execute Success !!! ");
	 int requestID = cs1.getInt(2);
     cs1.close();
	 
	 out.println("Request ID="+requestID);
 
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->