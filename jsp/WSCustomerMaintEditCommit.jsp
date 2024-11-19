<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Repair System-Action Code Edit Commit Page</title>
</head>
<body>
<%
     //String localeSet=request.getParameter("LOCALE");     
    
	 String ssal2=request.getParameter("SSAL2");
     String sname=request.getParameter("SNAME");
     String ccust=request.getParameter("CCUST");
     String cnme=request.getParameter("CNME"); 

    
     
     try
     {  
      // !±o!Psou-!N-i|]¢DDAE
       String sSqUpMAT="update rcm set CSAL=?,CLUSR=? where CCUST='"+ccust+"' ";   
       out.println(sSqUpMAT);
         
       PreparedStatement stmtUpMAT=bpcscon.prepareStatement(sSqUpMAT);             
       stmtUpMAT.setString(1,ssal2); 
       //stmtUpMAT.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
       stmtUpMAT.setString(2,userID);                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
 
 <input name="SNAME" type="hidden" value="<%=sname%>">
 <input name="CCUST" type="hidden" value="<%=ccust%>">
 <input name="CNME" type="hidden" value="<%=cnme%>"> 

 <%
 response.sendRedirect("../jsp/WSCustomerMaintenance.jsp?SSAL="+ssal2+"&SNAME="+sname+"&CCUST="+ccust+"&CNME="+cnme);	 
%>
</body>
<!--=============¢FFDH?U¢FFXI?q?¢FFXAAcn3s¢FGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
