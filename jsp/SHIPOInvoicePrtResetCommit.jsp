<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>SHIP IPO Invoice Print Flag Reset Commit Page</title>
</head>
<body>
<%
     //String localeSet=request.getParameter("LOCALE"); 
     //String WebID=(String)session.getAttribute("WEBID");      
     String invoiceNo=request.getParameter("INVOICENO");
     String invhPrt=request.getParameter("INVHPRT");     

            
     //if (actionCode==null || actionCode.equals("")) { actionCode= ""; }
     //if (symptomCode==null || symptomCode.equals("") ) { symptomCode= ""; }    
     
     try
     {  
      // !!Oo!Psou-!N-i|]¢FDDAE
       String sSqUpMAT="update IPOINV_H set INVH_PRT=?, HM_USER=?, HM_DATE=?, HM_TIME=? where INVH='"+invoiceNo+"' ";   
       //out.println(sSqUpMAT+" "+sSqUpMAT+" "+interModel);
         
       PreparedStatement stmtUpMAT=ifxdbexpcon.prepareStatement(sSqUpMAT);             
       stmtUpMAT.setString(1,invhPrt); 
       stmtUpMAT.setString(2,UserRoles);
       stmtUpMAT.setString(3,dateBean.getYearMonthDay()); 
       stmtUpMAT.setString(4,dateBean.getHourMinuteSecond());                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
  
<%
  response.sendRedirect("../jsp/SHIPOInvoiceInquiry.jsp");	 
%>
</body>
<!--=============¢FFFDH?U¢FFFXI?q?¢FFFXAAcn3s¢FFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<!--=================================-->
</html>
