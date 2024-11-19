<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
   String custNo=request.getParameter("CUST_NO");
   String stationNo=request.getParameter("STATNO");
   String typeID=request.getParameter("TYPE_ID");
   String organizationID=request.getParameter("MARKETTYPE");
   
   //out.println("custNo="+custNo);
   
   //if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   //String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW
   int    bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   Blob blob ;   
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID="+typeID+" and ORGANIZATION_ID='"+organizationID+"' ");
  if (rs.next())
  {
   blob = (Blob)rs.getObject("CUST_BLOBICON") ;  
   bbuff = blob.getBytes(1, (int)blob.length());
       
   int iconFileNameLngth = rs.getString("CUST_ICONFILE").length();
   String iconFileExtName = rs.getString("CUST_ICONFILE").substring(iconFileNameLngth-3,iconFileNameLngth);
   if (iconFileExtName=="ICO" || iconFileExtName.equals("ICO") || iconFileExtName=="ico" || iconFileExtName.equals("ico"))
   { 
    out.clearBuffer();     
    response.setContentType("image/ico");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close();  
   } 
   else if (iconFileExtName=="GIF" || iconFileExtName.equals("GIF") || iconFileExtName=="gif" || iconFileExtName.equals("gif"))      
   {
    out.clearBuffer();     
    response.setContentType("image/gif");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (iconFileExtName=="BMP" || iconFileExtName.equals("BMP") || iconFileExtName=="bmp" || iconFileExtName.equals("bmp"))      
   {
    out.clearBuffer();     
    response.setContentType("image/bmp");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   } 
   else if (iconFileExtName=="TIF" || iconFileExtName.equals("TIF") || iconFileExtName=="tif" || iconFileExtName.equals("tif"))      
   {
    out.clearBuffer();     
    response.setContentType("image/tif");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }   
   else if (iconFileExtName=="JPG" || iconFileExtName.equals("JPG") || iconFileExtName=="jpg" || iconFileExtName.equals("jpg") || iconFileExtName=="jpeg" || iconFileExtName.equals("jpeg"))      
   {
    out.clearBuffer();     
    response.setContentType("image/jpeg");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }   
   else 
   {
    out.clearBuffer();     
    response.setContentType("text/html");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
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
   
 } 
 else {
    out.println("No Attachment File !");
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
