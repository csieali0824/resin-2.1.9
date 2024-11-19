<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean"%>
<html>
<head>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
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
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
