<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean"%>

<html>
<head>

<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnORADDSPoolPage.jsp"%>
<!--=================================-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="queryAllBean" scope="page" class="QueryAllBean"/>
<%
  
   String synonmsName=request.getParameter("SYNONMSNAME");
   String sSql = "select * from "+synonmsName+" ";
   out.println("SQL  ==> "+sSql);
   
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery(sSql);
   queryAllBean.setRs(rs);
   //queryAllBean.setFieldName("CH");
   out.println(queryAllBean.getRsString());
   rs.close();
   statement.close();
 
%>
