<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<title>Wins System-IMEI Tracking Edit Commit Page</title>
</head>
<body>
<%
      String locale=request.getParameter("LOCALE");     
      String CenterNo=request.getParameter("CENTERNO");  
      String imei =request.getParameter("IMEI"); 
      String agentName =request.getParameter("AGENTNAME"); 
      String agentNameOld =request.getParameter("AGENTNAMEOLD"); 
      String agentTel =request.getParameter("AGENTTEL");
      String agentFax =request.getParameter("AGENTFAX");
      String unitNo =request.getParameter("UNITNO");
      String contactName =request.getParameter("CONTACT");
      String agentAddress =request.getParameter("AGADDRESS");
     try
     {  
        String agentCount = "00001";
        Statement stateAgent=con.createStatement(); 
        ResultSet rsACNT=stateAgent.executeQuery("select lpad(to_char(count(*)),5,0) as COUNT from IMEI_TRACKING where CUST_NAME='"+agentName+"' ");
        if (rsACNT.next()) 
       {
          agentCount =rsACNT.getString(1);
          if (agentCount=="00000" || agentCount.equals("00000")) { agentCount = "00001"; }
       }   
        else { agentCount = "00001"; }
        rsACNT.close();

      // !!Oo!Psou-!N-i|]¢FFDDAE
       String sSqUpMAT="update IMEI_TRACKING set CUST_NO=?,CUST_NAME=?,CONTACT_TEL=?,CONTACT_FAX=?,CONTACT_NAME=?,UNIT_NO=?,CUST_ADDRESS=? where IMEI='"+imei+"'  ";   
       //out.println(sSqUpMAT+" "+sSqUpMAT+" "+interModel);
         
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT);        
       stmtUpMAT.setString(1,CenterNo+"-"+agentCount);    
       stmtUpMAT.setString(2,agentName);
       stmtUpMAT.setString(3,agentTel); 
       stmtUpMAT.setString(4,agentFax); 
       stmtUpMAT.setString(5,contactName); 
       stmtUpMAT.setString(6,unitNo); 
       stmtUpMAT.setString(7,agentAddress);                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();    
      out.println("locale="+locale);  
      out.println("Step0");
      String sqlAgent =  "select * from WSCUST_AGENT a where AGENTNAME='"+agentName+"' ";
      ResultSet rsAgent=stateAgent.executeQuery(sqlAgent);
	  if (rsAgent.next())
      {  // ???,???
        /*   Fix don't update original Agent Information 2004/05/25
         String sqlUp = "update WSCUST_AGENT set AGENTNAME=?,AGENTTEL=?,AGENTFAX=?,CONTACTMAN=?,AGENT_UNITNO=?,AGENTADDR=?,AGENTNO=? where AGENTNAME='"+agentNameOld+"' ";
         PreparedStatement stmtUp=con.prepareStatement(sqlUp);             
         stmtUp.setString(1,agentName);
         stmtUp.setString(2,agentTel); 
         stmtUp.setString(3,agentFax); 
         stmtUp.setString(4,contactName); 
         stmtUp.setString(5,unitNo); 
         stmtUp.setString(6,agentAddress); 
         stmtUp.setString(7,CenterNo+"-"+agentCount);                
         stmtUp.executeUpdate();
         stmtUp.close();
         out.println("Step1");
        */  //Fix don't update original Agent Information 2004/05/25
      } 
      else
      {  // ???,???
         String sqlIn = "insert into WSCUST_AGENT(AGENTNAME,AGENTTEL,AGENTFAX,CONTACTMAN,AGENT_UNITNO,AGENTADDR,AGENTNO, LOCALE) values(?,?,?,?,?,?,?,?) ";
         PreparedStatement stmtIn=con.prepareStatement(sqlIn);             
         stmtIn.setString(1,agentName);
         stmtIn.setString(2,agentTel); 
         stmtIn.setString(3,agentFax); 
         stmtIn.setString(4,contactName); 
         stmtIn.setString(5,unitNo); 
         stmtIn.setString(6,agentAddress); 
         stmtIn.setString(7,CenterNo+"-"+"00001"); 
         stmtIn.setString(8,locale);                 
         stmtIn.executeUpdate();
         stmtIn.close();
        out.println("Step2");   
      }    
      rsAgent.close();
      stateAgent.close();           
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
 
 
<%
  response.sendRedirect("../jsp/WSIMEITrackingInquiry.jsp");	 
%>
</body>
<!--=============¢FFFFDH?U¢FFFFXI?q?¢FFFFXAAcn3s¢FFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
