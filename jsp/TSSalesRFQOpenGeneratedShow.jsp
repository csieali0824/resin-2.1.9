<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<%@ page import="DateBean" %>
<!--=============以下區段為取得連結池==========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Repair Action Code Monthly Statistic</title>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="RPActionMonthChart.jsp" METHOD="post" NAME="MYFORM" >
  <table width="100%" border="0">
    <tr> 
      <td height="26" align="center"><div align="left"><strong><font color="#0000FF" face="Arial"> 
  <%     
  //String modelNo = request.getParameter("MODELNO");
//  out.println("center : "+repCenterNo+" id :"+UserID);

  
%>
          </font><font color="#0000FF" size="+2" face="Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font color="#0000FF" size="+2" face="Arial">&nbsp; 
          &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;前週各區RFQ開單暨生成MO統計</font><font color="#0000FF" face="Arial">&nbsp;&nbsp; 
          &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;</font></strong></div></td>
    </tr>
  </table>
  <table width="100%" border="0" bordercolor="#000000" >
    <tr bgcolor="#66CCFF"> 
      <td width="40%"><font color="#000000" face="Arial Black"><strong> </strong></font> 
      </td>
      <td width="22%">&nbsp; </td>
      <td width="19%"> <font color="#000000" face="Arial Black">&nbsp;</font></td>
      <td width="19%">&nbsp;</td>

    </tr>
  </table>

  <BR>
<%@ include file="/jsp/TSSalesRFQOpenRateChart.jsp"%>  
<%       
       out.println("<img src='TSSalesRFQOpenRateIMap.jsp'>&nbsp;&nbsp;");
//     out.println("<img src='RPFaultMonthChart.jsp?MODELNO="+modelNo+"&MONTHNO="+YearFr+MonthFr+dd_end+"&REPCENTERNO="+repCenterNo+"&SVRTYPENO=001'>&nbsp;&nbsp;");
%>  
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
