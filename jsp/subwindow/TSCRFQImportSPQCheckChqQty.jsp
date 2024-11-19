<!-- 20150715 Peggy ,add line參數-->
<!-- 20151203 Peggy,保留原始remark-->
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
// String nSPQtyLoop = request.getParameter("NSPQTYLOOP");
 String RFQTYPE    = request.getParameter("RFQTYPE");
 String REMARKS    = request.getParameter("REMARKS");   //add by Peggy 20140310
 if (REMARKS==null) REMARKS ="";
 String PCODE      = request.getParameter("PCODE");   //add by Peggy 20140408
 if (PCODE==null) PCODE="";
 //int nSPQ = Integer.parseInt(nSPQtyLoop);
 int nSPQ = Integer.parseInt(request.getParameter("LINE")); //add by Peggy 20150715
 String SAMPLEORDER = request.getParameter("SAMPLEORDER");  //add by Peggy 20150715
%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<ul><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">

<%
  String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
  q[nSPQ][3]=nSPQty;
  q[nSPQ][9]=(q[nSPQ][9]==null||q[nSPQ][9].equals("")||q[nSPQ][9].startsWith("&nbsp")?"":q[nSPQ][9]+",")+REMARKS;  //add by Peggy 20140310
  
  //String urlDir = "TSCRFQImportSPQCheck.jsp?RFQTYPE="+RFQTYPE+"";
  String urlDir = "TSCRFQImportSPQCheck.jsp?PCODE="+PCODE+"&RFQTYPE="+RFQTYPE+"&SAMPLEORDER="+SAMPLEORDER; //add by Peggy 20140408
  response.sendRedirect(urlDir);

%>
<!--=============Release Database Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
