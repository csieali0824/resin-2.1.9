<%@ page import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
   String ringerCode=request.getParameter("RINGERCODE");
   int    bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   Blob blob ;   
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from PIRINGER where RINGERCODE='"+ringerCode+"'");
  rs.next();
  
  blob = (Blob)rs.getObject("RINGERFILE") ;  
  bbuff = blob.getBytes(1, (int)blob.length());
  
  out.clearBuffer(); 
  response.setContentType("Audio/mid");  
  response.getOutputStream().write(bbuff) ;   
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
