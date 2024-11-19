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
   blob = (Blob)rs.getObject("LABEL_BLOBPREV") ;  
   bbuff = blob.getBytes(1, (int)blob.length());
       
   int prevFileNameLngth = rs.getString("LABEL_PREVFILE").length();
   String prevFileExtName = rs.getString("LABEL_PREVFILE").substring(prevFileNameLngth-3,prevFileNameLngth);
   if (prevFileExtName=="ICO" || prevFileExtName.equals("ICO") || prevFileExtName=="ico" || prevFileExtName.equals("ico"))
   { 
    out.clearBuffer();     
    response.setContentType("image/ico");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close();  
   } 
   else if (prevFileExtName=="GIF" || prevFileExtName.equals("GIF") || prevFileExtName=="gif" || prevFileExtName.equals("gif"))      
   {
    out.clearBuffer();     
    response.setContentType("image/gif");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (prevFileExtName=="BMP" || prevFileExtName.equals("BMP") || prevFileExtName=="bmp" || prevFileExtName.equals("bmp"))      
   {
    out.clearBuffer();     
    response.setContentType("image/bmp");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   } 
   else if (prevFileExtName=="TIF" || prevFileExtName.equals("TIF") || prevFileExtName=="tif" || prevFileExtName.equals("tif"))      
   {
    out.clearBuffer();     
    response.setContentType("image/tif");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }   
   else if (prevFileExtName=="JPG" || prevFileExtName.equals("JPG") || prevFileExtName=="jpg" || prevFileExtName.equals("jpg") || prevFileExtName=="jpeg" || prevFileExtName.equals("jpeg"))      
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
