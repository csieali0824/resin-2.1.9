<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,DateBean,JCopy" %>
<!--=============¥H?U°I?q?°‥u±o3sμ2|A==========-->
<%//@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="jCopy" scope="page" class="JCopy"/>
</head>
<body>
<%
dateBean.setAdjDate(-1);
String sDate=dateBean.getMonthString()+dateBean.getDayString()+dateBean.getYearString(); 
String sGFilename=sDate+".txt"; 
//out.println(sGFilename); 

File url1= new File("I:/Tw9900/TEXTLOG/"+sGFilename);

//File url2= new File("d:/ftp/DBTEL_Daily_Tmp.txt");
File url2= new File("L:/ftp/DBTEL_Daily_Tmp.txt");
jCopy.copyFile(url1,url2); 




%>
</body>
</html>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%//@ include file="/jsp/include/ReleaseConnPage.jsp"%>

