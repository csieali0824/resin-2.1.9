<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Repair System-Action Code Edit Commit Page</title>
</head>
<body>
<%
     //String localeSet=request.getParameter("LOCALE");     
     String interModel=request.getParameter("INTERMODEL");
     String exterModel=request.getParameter("EXTERMODEL");
     String brand=request.getParameter("BRAND");
     String designHouse=request.getParameter("DESIGNHOUSE");
     String platForm=request.getParameter("PLATFORM");
     String launchDate=request.getParameter("LAUNCHDATE");
     String prodDesc = request.getParameter("PRODDESC"); 

     //String mUser=request.getParameter("MUSER");
     //String mDate=request.getParameter("MDATE");
     //String mTime=request.getParameter("MTIME");
     String YearFr = launchDate.substring(2,6); 
     String MonthFr = launchDate.substring(0,2); 
     String YearTo = YearFr;
     String MonthTo = MonthFr;        
     //if (actionCode==null || actionCode.equals("")) { actionCode= ""; }
     //if (symptomCode==null || symptomCode.equals("") ) { symptomCode= ""; }    
     
     try
     {  
      // §o·sou-×-i|]¥DAE
       String sSqUpMAT="update PSALES_PROD_CENTER set EXT_MODEL=?, BRAND=?,DESIGNHOUSE=?,PLATFORM=?,LAUNCH_DATE=?,PROD_DESC=?,CREATE_USER=?,CREATE_DATE=? where INTER_MODEL='"+interModel+"' ";   
       out.println(sSqUpMAT+" "+sSqUpMAT+" "+interModel);
         
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT); 
       stmtUpMAT.setString(1,exterModel);
       stmtUpMAT.setString(2,brand);
       stmtUpMAT.setString(3,designHouse);
       stmtUpMAT.setString(4,platForm);
       stmtUpMAT.setString(5,launchDate);     
       stmtUpMAT.setString(6,prodDesc); 
       stmtUpMAT.setString(7,userID); 
       stmtUpMAT.setString(8,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
 <input name="INTERMODEL" type="hidden" value="<%=interModel%>">
 <input name="BRAND" type="hidden" value="<%=brand%>"> 
 <input name="DESIGNHOUSE" type="hidden" value="<%=designHouse%>">
 <input name="PLATFORM" type="hidden" value="<%=platForm%>">  
 
<%
  response.sendRedirect("../jsp/WSProductCenterMaintenance.jsp?INTERMODEL="+interModel+"&BRAND="+brand+"&DESIGNHOUSE="+designHouse+"&PLATFORM="+platForm+"&YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&YEARTO="+YearTo+"&MONTHTO="+MonthTo);	 
%>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>