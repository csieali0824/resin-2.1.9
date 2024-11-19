<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String ringerCode=request.getParameter("RINGERCODE");
String ringerName=request.getParameter("RINGERNAME");
String ringerFile=request.getParameter("RINGERFILE");
File the_file=new File(ringerFile);
String file_name=the_file.getName();

try
{  
  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  stmt.executeUpdate("insert into PIRINGER values('"+ringerCode+"','"+ringerName+"',empty_blob() )");
  ResultSet rs=stmt.executeQuery("select RINGERFILE from PIRINGER where RINGERCODE='"+ringerCode+"' for UPDATE");
  
  if (rs.next())
  {
   BLOB myblob=((OracleResultSet)rs).getBLOB(1);
   FileInputStream instream=new FileInputStream(the_file);
   OutputStream outstream=myblob.getBinaryOutputStream();
   int bufsize=myblob.getBufferSize();
   byte[] buffer = new byte[bufsize];
   int length=0;
   while ((length=instream.read(buffer))!=-1)   
   outstream.write(buffer,0,length);
   out.println("file upload and insert into database successful!!");
   instream.close();	 
   outstream.close();  
  } // end of rs if  
  stmt.close();
  rs.close();
  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
