<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Tsc Other Invoice Create Commit</title>
</head>
<%
    String invoiceNo=request.getParameter("INVOICENO");
    String shipMark=request.getParameter("SHIPMARK");	
%>
<body>
<%
   // Step1. 依據使用者自行再製的Mark 更新 Shipping Mark欄位
  if (shipMark != null && !shipMark.equals(""))  // 若由客戶檔訂單表頭可得ShipMark資料,則以訂單表頭為主.
  {
       String sql="update DAPHNE_INVOICE_OTHER set DOCU='"+shipMark+"' where NAME='"+invoiceNo+"'";     
       PreparedStatement pstmt=con.prepareStatement(sql);				  		  
       pstmt.executeUpdate();
       pstmt.close();
  }
  
  //out.println("shipMark="+shipMark);
%> 
<!--=============¢結束Connection Pool 的連線==========-->
<!--%@ include file="/jsp/include/ReleaseConnTest2Page.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%  
  // Step2. 重新導向至發票檢視頁
  response.sendRedirect("http://intranet.ts.com.tw/joetest/other/otherindex2.asp?invoice_no="+invoiceNo); 
%>
</body>
</html>
