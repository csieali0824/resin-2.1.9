<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%->
<!--=======To get Connection from different DB======-->
<%@ include file ="/jsp/include/ConnectionPoolPage.jsp" %>
<%@ page import="bean.ComboBoxAllBean,bean.DateBean,bean.ArrayComboBoxBean,java.text.DecimalFormat,bean.RsCountBean" %>

<jsp:useBean id="comboBoxAllBean" scope="page" class="bean.ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="bean.DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="bean.RsCountBean"/>

<script language="JavaScript" type="text/JavaScript"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Report on Web -DBTEL Incorporated</title>
</head>

<body>

<img src="../image/top.jpg" width="750" height="89">


<%
  String ItemDesc = null;
             String itemCodeGet = "";
             int itemCodeGetLength = 0;     
             Statement stateItemDesc=con.createStatement(); 
             ResultSet rsItemDesc=stateItemDesc.executeQuery("select DISTINCT MITEM from prodmodel  where MFLAG=1 and MCOUNTRY='886' ");
             while (rsItemDesc.next()) 
             { 
              ItemDesc = rsItemDesc.getString(1);
	          itemCodeGet = itemCodeGet+"'"+ItemDesc+"'"+","; 
             }
			 out.print(itemCodeGet);
             rsItemDesc.close();
             stateItemDesc.close(); 

           
%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--===========================================-->