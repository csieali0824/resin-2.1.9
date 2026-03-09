<%@ page import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="bean.ShowImageBean"%>
<jsp:useBean id="showImageBean" scope="application" class="bean.ShowImageBean"/>

<%
   String projectCode=request.getParameter("PROJECTCODE");
   if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW  
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from PIIMAGE where PROJECTCODE='"+projectCode+"'");
  showImageBean.setRs(rs);
  showImageBean.setWhichView(whichView);
    
   out.clearBuffer(); 
   response.setContentType("text/html");  
   response.getOutputStream().write(showImageBean.getBLOB()) ;   
   response.getOutputStream().flush(); 	
   out.close();   
     
  stmt.close();
  rs.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
