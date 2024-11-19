<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
   String custNo=request.getParameter("CUST_NO");
   String stationNo=request.getParameter("STATNO");
   
   out.println("custNo="+custNo);
   
   //if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   //String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW
   int    bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   Blob blob ;   
   
try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=stmt.executeQuery("select * from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' ");
  if (rs.next())
  {
   blob = (Blob)rs.getObject("LABEL_BLOBFILE") ;  
   bbuff = blob.getBytes(1, (int)blob.length());
       
   int specFileNameLngth = rs.getString("LABEL_TEMPFILE").length();
   String specFileExtName = rs.getString("LABEL_TEMPFILE").substring(specFileNameLngth-3,specFileNameLngth);
   if (specFileExtName=="XLS" || specFileExtName.equals("XLS") || specFileExtName=="xls" || specFileExtName.equals("xls"))
   { 
    out.clearBuffer();
	response.setContentType("application/vnd.ms-excel");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   } 
   else if (specFileExtName=="PPT" || specFileExtName.equals("PPT") || specFileExtName=="ppt" || specFileExtName.equals("ppt"))      
   {
    out.clearBuffer();     
    response.setContentType("application/vnd.ms-powerpoint");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="DOC" || specFileExtName.equals("DOC") || specFileExtName=="doc" || specFileExtName.equals("doc"))      
   {
    out.clearBuffer();     
    response.setContentType("application/msword");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   } 
   else if (specFileExtName=="PDF" || specFileExtName.equals("PDF") || specFileExtName=="pdf" || specFileExtName.equals("pdf"))      
   {
    out.clearBuffer();     
    response.setContentType("application/pdf");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="MPG" || specFileExtName.equals("MPG") || specFileExtName=="mpg" || specFileExtName.equals("mpg"))      
   {
    out.clearBuffer();     
    response.setContentType("video/mpg");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="AVI" || specFileExtName.equals("AVI") || specFileExtName=="avi" || specFileExtName.equals("avi"))      
   {
    out.clearBuffer();     
    response.setContentType("video/avi");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="WMV" || specFileExtName.equals("WMV") || specFileExtName=="wmv" || specFileExtName.equals("wmv"))      
   {
    out.clearBuffer();     
    response.setContentType("video/wmv");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="RAR" || specFileExtName.equals("RAR") || specFileExtName=="rar" || specFileExtName.equals("rar"))      
   {
    out.clearBuffer();     
    response.setContentType("application/x-rar-compressed");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="ZIP" || specFileExtName.equals("ZIP") || specFileExtName=="zip" || specFileExtName.equals("zip"))      
   {
    out.clearBuffer();     
    response.setContentType("application/x-zip-compressed");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }
   else if (specFileExtName=="JPG" || specFileExtName.equals("JPG") || specFileExtName=="jpg" || specFileExtName.equals("jpg") || specFileExtName=="jpeg" || specFileExtName.equals("jpeg"))      
   {
    out.clearBuffer();     
    response.setContentType("image/jpeg");
	
	response.getOutputStream().write(bbuff) ;   
    response.getOutputStream().flush();  
    out.close(); 
   }       
   else if (specFileExtName=="LBL" || specFileExtName.equals("LBL") || specFileExtName=="lbl")
   { // 若格式是條碼檔,則以Java呼叫外部程式呼叫 Nice Label
      out.println("LBL File Open="+specFileExtName);
      Runtime runtime = Runtime.getRuntime();
      Process process =null;
      String line=null;
      InputStream is =null;
      InputStreamReader isr=null;
      BufferedReader br =null;
      try
      {
         process = runtime.exec("cmd /c C:\\Program Files\\EuroPlus\\LE\\Bin\\nicele3.exe open=D:\\sample.lbl");
         //process = runtime.exec("cmd /c java a");
         is = process.getInputStream();
         isr=new InputStreamReader(is);
         br =new BufferedReader(isr);
         out.println("<pre>");
         while( (line = br.readLine()) != null )
         {
          out.println(line);
          out.flush();
         }
         out.println("</pre>");
         is.close();
         isr.close();
         br.close();
       }
       catch(IOException e )
       {
         out.println(e);
         runtime.exit(1);
       }   
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
    out.println("No Attactment File !");
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
