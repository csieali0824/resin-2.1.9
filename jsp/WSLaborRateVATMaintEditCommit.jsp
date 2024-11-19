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
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY");   
     //String brand=request.getParameter("BRAND");          
     String interModel=request.getParameter("INTERMODEL");
     String laborLoad=request.getParameter("LABORLOAD");
     String exRate=request.getParameter("EXRATE");
     String vat=request.getParameter("VAT");
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");

     //String mUser=request.getParameter("MUSER");
     //String mDate=request.getParameter("MDATE");
     //String mTime=request.getParameter("MTIME");
            
     //if (actionCode==null || actionCode.equals("")) { actionCode= ""; }
     //if (symptomCode==null || symptomCode.equals("") ) { symptomCode= ""; }    
     
     try
     {  
      // !!Oo!Psou-!N-i|]¢FDDAE
       String sSqUpMAT="update PSALES_LBLRATE_VAT set LBL_LOAD=?,EXRATE=?,VAT=?,MTDATE=?,MTUSER=? where REGION='"+region+"' and COUNTRY='"+country+"' and INT_MODEL='"+interModel+"' and SYEAR='"+YearTo+"' and SMONTH='"+MonthTo+"' ";   
       out.println(sSqUpMAT+" "+sSqUpMAT+" "+interModel);
         
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT);             
       stmtUpMAT.setString(1,laborLoad);
       stmtUpMAT.setString(2,exRate); 
       stmtUpMAT.setString(3,vat); 
       stmtUpMAT.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
       stmtUpMAT.setString(5,WebID);                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
 <input name="REGION" type="hidden" value="<%=region%>">
 <input name="COUNTRY" type="hidden" value="<%=country%>"> 
 <input name="INTERMODEL" type="hidden" value="<%=interModel%>"> 
 
<%
  response.sendRedirect("../jsp/WSLaborRateVATMaintenance.jsp?REGION="+region+"&COUNTRY="+country+"&INTERMODEL="+interModel);	 
%>
</body>
<!--=============¢FFFDH?U¢FFFXI?q?¢FFFXAAcn3s¢FFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
