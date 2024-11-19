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
     String brand=request.getParameter("BRAND");          
     String segment=request.getParameter("SEGMENTUP");
     //out.println("step2");
     String sgmntFr=request.getParameter("SGMNTFR"); 
     String sgmntTo=request.getParameter("SGMNTTO");

            
     //if (actionCode==null || actionCode.equals("")) { actionCode= ""; }
     //if (symptomCode==null || symptomCode.equals("") ) { symptomCode= ""; }    
     
     try
     {  
      // §o·sou-×-i|]¥DAE
       String sSqUpMAT="update PSALES_PRICE_SGMNT set SGMNT_FR=?,SGMNT_TO=?,GUSER=?,GDATE=? where SREGION='"+region+"' and SCOUNTRY='"+country+"' and SG_BRAND='"+brand+"' and SEGMENT='"+segment+"' ";   
       out.println(sSqUpMAT+" "+sSqUpMAT+" "+segment);
         
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT); 
       stmtUpMAT.setString(1,sgmntFr);
       stmtUpMAT.setString(2,sgmntTo);      
       stmtUpMAT.setString(3,WebID); 
       stmtUpMAT.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());                
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
 <input name="BRAND" type="hidden" value="<%=brand%>"> 
 <input name="SEGMENT" type="hidden" value="<%=segment%>"> 
 
<%
  response.sendRedirect("../jsp/WSPriceSegmentMaintenance.jsp?REGION="+region+"&COUNTRY="+country+"&BRAND="+brand+"&SEGMENT="+segment);	 
%>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
