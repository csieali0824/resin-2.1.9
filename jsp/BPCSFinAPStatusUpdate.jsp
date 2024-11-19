<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS應付帳款付款狀態修改寫入</title>
</head>

<body>
<%
     String serial=request.getParameter("SERIAL");
	 String status=request.getParameter("STATUS");
	 //out.println(serial);
	 //out.println(status);
%>
<%
     try
	    {
	     String sql="update amh set amhsts='"+status+"' where serialcolumn='"+serial+"' ";
	     //out.println(sql);
	     PreparedStatement pt=ifxTestCon.prepareStatement(sql);
		 //PreparedStatement pt=ifxDbtelcon.prepareStatement(sql);
	     pt.executeUpdate();
	     pt.close();
	   } // end of try
     catch (Exception e) {
	     out.println("Exception :"+e.getMessage());
	   }
     out.println("資料修改完成!!"+"<br>");
%>
<a href="/wins/WinsMainMenu.jsp">回首頁 </a><A HREF="../jsp/BPCSFinAPUnpayList.jsp">查詢所有應付帳款---未付清單</A><br>
</body>
</html>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%-->