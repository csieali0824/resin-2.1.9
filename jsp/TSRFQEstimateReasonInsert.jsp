<%@ page language="java" import="java.sql.*,java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnRFQDBPoolPage.jsp"%>
<%@ page import="CodeUtil" %>
<title>Estimate Reason Code Insert Page</title>
</head>
<body>
<A HREF="../jsp/TSRFQEstimateReasonInput.jsp">Previous Page</A>
<%
   String No=request.getParameter("NO");
   String reasonCode=request.getParameter("CODE");   
   String reasonDesc=request.getParameter("DESC");   
   String inLocale = request.getParameter("LOCALE"); 
   
   String sql= "";
   PreparedStatement pstmt=null;
/*
     // 為存入日期格式為US考量,將語系先設為中文簡體
	    String sql="alter SESSION set NLS_CHARACTERSET = 'UTF8' ";     
        PreparedStatement pstmt=con.prepareStatement(sql);
		                  pstmt.executeUpdate(); 
                          pstmt.close();
	  //完成存檔後回復
*/
     // String tempDesc = CodeUtil.unicodeToBig5(reasonDesc); out.println(tempDesc);
	  String sqlInsert = "insert into ORADDMAN.TSREASON values(?,?,?,?)";
	         pstmt=conRFQ.prepareStatement(sqlInsert);
			 pstmt.setString(1,No);  // 
			 pstmt.setString(2,reasonCode);  // 
			 pstmt.setString(3,reasonDesc);  //
			 pstmt.setString(4,inLocale);  //
		     pstmt.executeUpdate(); 
             pstmt.close();
/*
	 // 為存入日期格式為US考量,將語系先設為中文簡體
	     sql="alter SESSION set NLS_CHARACTERSET = 'AL32UTF8' ";     
         pstmt=con.prepareStatement(sql);
		 pstmt.executeUpdate(); 
         pstmt.close();
	 //完成存檔後回復為中文繁體
*/ 
	 out.println("Insert inot Estimate Reason O.K !!");

%>
<!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnRFQDBPage.jsp"%>
<!--=================================-->
</body>
</html>
