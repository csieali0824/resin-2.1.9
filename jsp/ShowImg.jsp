<%@ page import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
   String projectCode=request.getParameter("PROJECTCODE");
   if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW
   int    bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   Blob blob ;   
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from PIIMAGE where PROJECTCODE='"+projectCode+"'");
  if (rs.next())
  {  
    blob = (Blob)rs.getObject(whichView) ;  
    bbuff = blob.getBytes(1, (int)blob.length());
  
    out.clearBuffer(); 
    response.setContentType("text/html");  
    response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush(); 	
    out.close(); 	
  } else {
    out.println("No Pic!");
  }   
  stmt.close();
  rs.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
