<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="bean.ComboBoxAllBean,bean.ComboBoxBean,bean.DateBean,bean.ArrayComboBoxBean,bean.ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="bean.ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="bean.ArrayListCheckBoxBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>無標題文件</title>
</head>
<body>
<%   
  try
  {
   out.print("ok");
   CallableStatement cs = bpcscon.prepareCall("{call pbom010()}");
   boolean bl = cs.execute();
   
   out.println(bl);
   
   //out.print(bVersion);
   out.println("Procedure Success !!! ");
   cs.close();
  }
  catch(Exception e)
  {
   System.out.println(e);
  }
%>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

