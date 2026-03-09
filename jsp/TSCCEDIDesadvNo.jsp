<%@ page language="java" import="java.sql.*"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.DateBean"%>
<html>
<head>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<title>Get Desadv No</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCCEDIDesadvNo.jsp">
<BR>
<%  
String strDesadvNo="";
CallableStatement csf = con.prepareCall("{call TSCC_EDI_PKG.GET_DESADV_NO(?,?)}");
csf.setString(1,"TS-"+(dateBean.getYearString()).substring(2)+dateBean.getMonthString());
csf.registerOutParameter(2, Types.VARCHAR);  
csf.execute();
strDesadvNo = csf.getString(2);                
csf.close();			
%>
<div style="font-size:16px;font-family:Times New Roman;">ASN No:<input type="text" value="<%=strDesadvNo%>" size="10" style="font-size:16px;font-family:Times New Roman;color:#003399"></div>
<!--%���Ѽ�%-->
</FORM>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
