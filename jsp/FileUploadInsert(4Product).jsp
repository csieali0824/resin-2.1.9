<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
</head>
<body>
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();

com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName();

String dateString=dateBean.getYearMonthDay();

try
{	               	 	        
  if  (!upload_file.isMissing())
  {  	    
    BufferedReader br=new BufferedReader(new FileReader(uploadFilePath));
	String s=null;
	
	while (br.ready())
	{	 
	 s=br.readLine();	 	 
	 if (s!=null && !s.equals("")) 
	 {
	   String sql="insert into PSALES_PROD_CENTER(INTER_MODEL,EXT_MODEL,BRAND,DESIGNHOUSE,PLATFORM,LAUNCH_DATE,CREATE_DATE,CREATE_USER) values(?,?,?,?,?,?,?,?)";
       PreparedStatement pstmt=con.prepareStatement(sql);              	  
	  
	  int beginIDX=0;
	  int endIDX=0; 	   
	  int column=1;
	  while (s.indexOf("|",beginIDX)>=0 && beginIDX>=0) //if beginIDX<0 that means end of line
	  {	   
	   endIDX=s.indexOf("|",beginIDX);	   	
       pstmt.setString(column,s.substring(beginIDX,endIDX));			  	  	                    	   	  
	   	   
	   beginIDX=endIDX+1;	
	   column++;   	   
	  }	  
	  pstmt.setString(7,dateString);
	  pstmt.setString(8,"B01732"); //WRITE THE LAST COLUMN THAT IS the man who upload this file 	  
	  pstmt.executeUpdate();
	  pstmt.close();  
	 } 
	} //end of while to read file	
	br.close();	
	
	out.println("FILE UPLOAD SUCCESSFULLY");	
  } else {
    out.println("The file has been missing!! Please try it again!!<BR>"); 
  }   
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
