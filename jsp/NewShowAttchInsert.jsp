<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,DateBean,ArrayCheckBoxBean" %>
<html>
<head>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!-- 2004-10-20 ADD 上市日期 to PIMASTER -->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<%// By Kerwin for upload file%>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<%// By Kerwin for upload file%>
</head>
<body>
<%
// For upload file By Kerwin
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
// For upload file By Kerwin

String APPNO="";

String dnDocNo=mySmartUpload.getRequest().getParameter("DNDOCNO");
String newsType=mySmartUpload.getRequest().getParameter("TOPIC");
String newsId=mySmartUpload.getRequest().getParameter("NEWSID");
String ownerName=mySmartUpload.getRequest().getParameter("PUBLISHUSER");
String publishDate=mySmartUpload.getRequest().getParameter("PUBLISHDATE");
String newsDesc=mySmartUpload.getRequest().getParameter("NEWSDESC");

String SPLATFM_NAME="";

System.err.println("Step1");

// FOR UPLOAD FILE bY KERWIN //

com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
front_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
String frontFile_name=front_file.getFileName();
String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();


// FOR UPLOAD FILE bY KERWIN //

System.err.println("Step2");


try
{ 
    
   PreparedStatement pstmtRCV=con.prepareStatement("delete from ORADDMAN.TSNEWS where NEWSID='"+newsId+"' ");    
   pstmtRCV.executeUpdate();
   pstmtRCV.close();   
  
   PreparedStatement pstmtType=con.prepareStatement("insert into ORADDMAN.TSNEWS(NEWSID,ESDATE,NEWSDESC,OWNERNAME,NEWSTYPE) values('"+newsId+"','"+publishDate+"','"+newsDesc+"','"+ownerName+"','"+newsType+"')");   
   pstmtType.executeUpdate();
   pstmtType.close(); 

// Start up for upload file by Kerwin

   Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
   stmt.executeUpdate("insert into ORADDMAN.TSDNOTICE_DOC(DNDOCNO,SOURCE_FILE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,TYPE,FILE_NAME) values('"+dnDocNo+"',empty_blob(),'"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','NEWS','"+frontFile_name+"')");	
  //inser Binary File To DB    
  if  (!front_file.isMissing()) 
  {
    ResultSet rs7=stmt.executeQuery("select SOURCE_FILE from ORADDMAN.TSDNOTICE_DOC where DNDOCNO='"+dnDocNo+"' and TYPE='NEWS' for UPDATE");  	
    if (rs7.next())
    {
     BLOB myblob=null;
     FileInputStream instream=null;
     OutputStream outstream=null;
     int bufsize=0;
     byte[] buffer =null;
     int fileLength=0;   
     
	 if  (!front_file.isMissing())
	 {
       myblob=((OracleResultSet)rs7).getBLOB(1);
       instream=new FileInputStream(frontFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	        	   
	 } //end of frontviewfile if
	   
System.err.println("Step3");

     out.println("Attach file upload success!!<BR>");  	          
    } // end of rs if  
	stmt.close();
    rs7.close();
  } //enf of open_file,front_file,side_file if	


 // End of upload file by Kerwin  

 //執行sendMail動作
  
   //  out.println("<img src='../jsp/WSMRNewModelSendMail.jsp?APPUSERID="+WEBID+"&APPNO='"+seqnoApp+"' height='0' width='0'>&nbsp;&nbsp;");	

//end of //執行sendMail動作
 
  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch

session.setAttribute("NewsID",dnDocNo);
response.sendRedirect("NewsShowDetail.jsp?NewsID="+dnDocNo);

%>

<br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
