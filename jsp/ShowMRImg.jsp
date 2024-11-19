<%@ page import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
   String appNo=request.getParameter("APPNO");
   String modelNo=request.getParameter("MODELNO");       
   //if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   //String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW
   int    bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   Blob blob ;   
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from MRMODEL_DOCMNT where APPNO='"+appNo+"'");
  if (rs.next())
  {  
    blob = (Blob)rs.getObject("IMAGEVIEW") ;  
    bbuff = blob.getBytes(1, (int)blob.length());
    
   int imgFileNameLngth = rs.getString("IMAGEVIEW_NAME").length();
   String imgFileExtName = rs.getString("IMAGEVIEW_NAME").substring(imgFileNameLngth-3,imgFileNameLngth);
   if (imgFileExtName=="GIF" || imgFileExtName.equals("GIF") || imgFileExtName=="gif" || imgFileExtName.equals("gif"))
   { 
    out.clearBuffer();
	response.setContentType("image/gif");
   } 
   else if (imgFileExtName=="TIF" || imgFileExtName.equals("TIF") || imgFileExtName=="tif" || imgFileExtName.equals("tif"))
   { 
    out.clearBuffer();
	response.setContentType("image/tif");
   }
   else
   { 
    out.clearBuffer(); 
    response.setContentType("text/html");  
   }
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
