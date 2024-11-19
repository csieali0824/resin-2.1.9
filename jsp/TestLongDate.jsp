<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="DateBean" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>無標題文件</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>

<body>
<%
   java.sql.Date shippingDate = null; //將SHIPDATE轉換成日期格式以符丟入API格式
   java.util.Date longDate = null;
   shippingDate = new java.sql.Date(Integer.parseInt(dateBean.getYearString())-1900,Integer.parseInt(dateBean.getMonthString())-1,Integer.parseInt(dateBean.getDayString()));  // 給Shipping Date
   longDate = new java.util.Date(Integer.parseInt(dateBean.getYearString())-1900,Integer.parseInt(dateBean.getMonthString())-1,Integer.parseInt(dateBean.getDayString()),Integer.parseInt(dateBean.getHourMinuteSecond().substring(0,2)),Integer.parseInt(dateBean.getHourMinuteSecond().substring(2,4)),Integer.parseInt(dateBean.getHourMinuteSecond().substring(4,6)));  // 給Shipping Date
   //out.println(shippingDate);
   out.println(longDate);
   
         String sqlDate="  select TO_DATE('20060728173502','YYYYMMDDHH24MISS') from DUAL   ";  					
         Statement stateDate=con.createStatement();
         ResultSet rsDate=stateDate.executeQuery(sqlDate);
		 if (rsDate.next())
		 { shippingDate  = rsDate.getDate(1);  }
		 rsDate.close();
         stateDate.close();	
          out.println("shippingDate"+shippingDate);
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
