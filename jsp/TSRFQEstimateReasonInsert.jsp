<%@ page language="java" import="java.sql.*,java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
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
     // ���s�J����榡��US�Ҷq,�N�y�t���]������²��
	    String sql="alter SESSION set NLS_CHARACTERSET = 'UTF8' ";     
        PreparedStatement pstmt=con.prepareStatement(sql);
		                  pstmt.executeUpdate(); 
                          pstmt.close();
	  //�����s�ɫ�^�_
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
	 // ���s�J����榡��US�Ҷq,�N�y�t���]������²��
	     sql="alter SESSION set NLS_CHARACTERSET = 'AL32UTF8' ";     
         pstmt=con.prepareStatement(sql);
		 pstmt.executeUpdate(); 
         pstmt.close();
	 //�����s�ɫ�^�_�������c��
*/ 
	 out.println("Insert inot Estimate Reason O.K !!");

%>
<!--=============�H�U�Ϭq������s����==========--> 
 <%@ include file="/jsp/include/ReleaseConnRFQDBPage.jsp"%>
<!--=================================-->
</body>
</html>
