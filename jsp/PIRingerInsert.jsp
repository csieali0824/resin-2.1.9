<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<html>
<head>
<title>Upload File and Insert into Database</title>
</head>
<body>
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
String ringerCode=mySmartUpload.getRequest().getParameter("RINGERCODE");
String ringerName=mySmartUpload.getRequest().getParameter("RINGERNAME");

com.jspsmart.upload.File the_file = mySmartUpload.getFiles().getFile(0); 
the_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+the_file.getFileName()); 
String filepath="c://clientupload/"+request.getRemoteAddr()+"-"+the_file.getFileName();

try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  stmt.executeUpdate("insert into PIRINGER values('"+ringerCode+"','"+ringerName+"',empty_blob() )");
  ResultSet rs=stmt.executeQuery("select RINGERFILE from PIRINGER where RINGERCODE='"+ringerCode+"' for UPDATE");    
	
  if (rs.next())
  {      
   BLOB myblob=((OracleResultSet)rs).getBLOB(1);
   FileInputStream instream=new FileInputStream(filepath);
   OutputStream outstream=myblob.getBinaryOutputStream();
   int bufsize=myblob.getBufferSize();
   byte[] buffer = new byte[bufsize];
   int length=0;
   while ((length=instream.read(buffer))!=-1)   
       outstream.write(buffer,0,length);
   out.println("file upload and insert into database successful!!");
    out.println("<BR><A href='PIRingerInput.jsp'>Add New Ringer Data</A>&nbsp;&nbsp;<A href='PIRingerQueryAll.jsp'>Query All Ringer Data</A>");
   instream.close();	 
   outstream.close();   
  }  
  rs.close();
  stmt.close();
} //end of try
catch (Exception e)
{ 
 out.println("error is:"+e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
