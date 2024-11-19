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
   blob = (Blob)rs.getObject("SPECFILE") ;  
   bbuff = blob.getBytes(1, (int)blob.length());
       
   int specFileNameLngth = rs.getString("SPECFILE_NAME").length();
   String specFileExtName = rs.getString("SPECFILE_NAME").substring(specFileNameLngth-3,specFileNameLngth);
   if (specFileExtName=="XLS" || specFileExtName.equals("XLS") || specFileExtName=="xls" || specFileExtName.equals("xls"))
   { 
    out.clearBuffer();
	response.setContentType("application/vnd.ms-excel");
   } 
   else if (specFileExtName=="PPT" || specFileExtName.equals("PPT") || specFileExtName=="ppt" || specFileExtName.equals("ppt"))      
   {
    out.clearBuffer();     
    response.setContentType("application/vnd.ms-powerpoint");
   }
   else if (specFileExtName=="DOC" || specFileExtName.equals("DOC") || specFileExtName=="doc" || specFileExtName.equals("doc"))      
   {
    out.clearBuffer();     
    response.setContentType("application/msword");
   } 
   else if (specFileExtName=="PDF" || specFileExtName.equals("PDF") || specFileExtName=="pdf" || specFileExtName.equals("pdf"))      
   {
    out.clearBuffer();     
    response.setContentType("application/pdf");
   }
   else if (specFileExtName=="MPG" || specFileExtName.equals("MPG") || specFileExtName=="mpg" || specFileExtName.equals("mpg"))      
   {
    out.clearBuffer();     
    response.setContentType("video/mpg");
   }
   else if (specFileExtName=="AVI" || specFileExtName.equals("AVI") || specFileExtName=="avi" || specFileExtName.equals("avi"))      
   {
    out.clearBuffer();     
    response.setContentType("video/avi");
   }
   else if (specFileExtName=="WMV" || specFileExtName.equals("WMV") || specFileExtName=="wmv" || specFileExtName.equals("wmv"))      
   {
    out.clearBuffer();     
    response.setContentType("video/wmv");
   }
   else if (specFileExtName=="RAR" || specFileExtName.equals("RAR") || specFileExtName=="rar" || specFileExtName.equals("rar"))      
   {
    out.clearBuffer();     
    response.setContentType("application/x-rar-compressed");
   }
   else if (specFileExtName=="ZIP" || specFileExtName.equals("ZIP") || specFileExtName=="zip" || specFileExtName.equals("zip"))      
   {
    out.clearBuffer();     
    response.setContentType("application/x-zip-compressed");
   }
   else 
   {
    out.clearBuffer();     
    response.setContentType("text/html");
   }       
   //response.setContentType("text/html"); 
   //response.setContentType("application/vnd.ms-excel"); 
   //response.setContentType("application/vnd.ms-powerpoint");
   //response.setContentType("application/msword");
   //response.setContentType("application/x-zip-compressed");
   //response.setContentType("application/x-rar-compressed");
   //response.setContentType("application/x-msdownload");  
   //response.setContentType("application/application/vnd.visio"); 
   //response.setContentType("application/application/pdf"); 
   //response.setContentType("video/mpeg");  response.setContentType("video/mpg");  
   //response.setContentType("video/avi");        
   response.getOutputStream().write(bbuff) ;   
   response.getOutputStream().flush();  
   out.close(); 
 } 
 else {
    out.println("No Specification File !");
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
