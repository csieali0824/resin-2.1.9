<html>
<head>
<title>Order Import SPQ Quantity Change</title>

</head>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page contentType="text/html;charset=Big5" %>
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ page language="java" import="java.io.*" %>

<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>

<% 
 String nSPQty     = request.getParameter("NSPQTY");
 String nSPQtyLoop = request.getParameter("NSPQTYLOOP");
 int nSPQ = Integer.parseInt(nSPQtyLoop);
%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<ul><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">

<%
  String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
  q[nSPQ][3]=nSPQty;
  
  String urlDir = "TSCRFQImportSPQCheck.jsp";
  response.sendRedirect(urlDir);
  //if (q!=null) 
   // {
	//out.println(arrayRFQDocumentInputBean.getArray2DBufferString());
   // }
  //out.println(nSPQty);
 // out.println(nSPQtyLoop);

%>
<!--=============Release Database Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
