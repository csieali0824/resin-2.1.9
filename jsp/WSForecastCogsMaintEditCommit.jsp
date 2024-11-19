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
     String comp=request.getParameter("FCCOMP");
     String type=request.getParameter("FCTYPE");	 
     String region=request.getParameter("FCREG");
     String country=request.getParameter("FCCOUN"); 
	 String curr=request.getParameter("FCCURR");
     String model=request.getParameter("FCPRJCD");
     String year=request.getParameter("FCYEAR");
     String month=request.getParameter("FCMONTH");
	 String version=request.getParameter("FCMVER");
	 String cogs=request.getParameter("FCCOGS");

    
     
     try
     {  
      // !±o!Psou-!N-i|]¢DDAE
       String sSqUpMAT="update psales_fore_cogs  set FCCOGS=?,FCLUSER=? where FCCOMP='"+comp+"' and FCTYPE='"+type+"' and FCREG='"+region+"' and FCCOUN='"+country+"' and FCCURR='"+curr+"' and FCPRJCD='"+model+"' and FCYEAR='"+year+"' and FCMONTH='"+month+"' and FCMVER='"+version+"' ";   
       out.println(sSqUpMAT);
         
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT);             
       stmtUpMAT.setString(1,cogs); 
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
  <input name="FCCOMP" type="hidden" value="<%=comp%>"> 
 <input name="FCTYPE" type="hidden" value="<%=type%>">
 <input name="FCREG" type="hidden" value="<%=region%>">
 <input name="FCCOUN" type="hidden" value="<%=country%>">   
 <input name="FCCURR" type="hidden" value="<%=curr%>">
 <input name="FCPRJCD" type="hidden" value="<%=model%>">  
 <input name="FCYEAR" type="hidden" value="<%=year%>"> 
 <input name="FCMONTH" type="hidden" value="<%=month%>"> 
 <input name="FCMVER" type="hidden" value="<%=version%>"> 
 
<%
  response.sendRedirect("../jsp/WSForecastCogsMaintenance.jsp?FCCOMP="+comp+"&FCTYPE="+type+"&FCREG="+region+"&FCCOUN="+country+"&FCCURR="+curr+"&FCPRJCD="+model+"&FCYEAR="+year+"&FCMONTH="+month);	 
%>
</body>
<!--=============¢FFDH?U¢FFXI?q?¢FFXAAcn3s¢FGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
