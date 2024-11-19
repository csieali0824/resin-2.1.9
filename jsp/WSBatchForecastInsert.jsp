<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert forecast UploadFile into Database</title>
<%@ page import="java.io.*,DateBean,WorkingDateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="DateBean"/> <!--做為調整用之datebean-->
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
</head>
<body>
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.setMaxFileSize(50000);
mySmartUpload.upload();

String vYear=mySmartUpload.getRequest().getParameter("VYEAR"); 
String vMonth=mySmartUpload.getRequest().getParameter("VMONTH");  
String comp=mySmartUpload.getRequest().getParameter("COMP");   
String type=mySmartUpload.getRequest().getParameter("TYPE");
String region=mySmartUpload.getRequest().getParameter("REGION");
String country=mySmartUpload.getRequest().getParameter("COUNTRY"); 
String curr=mySmartUpload.getRequest().getParameter("CURR");  
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
	 adjDateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);
	 s=br.readLine();	 	 
	 if (s!=null && !s.equals("")) 
	 {               	  	  
	  int beginIDX=0;
	  int endIDX=0; 	   
	  int column=1;
	  endIDX=s.indexOf("|",beginIDX);//先取得第一個欄位MODEL的位置
	  String model=s.substring(beginIDX,endIDX);//取得MODEL NAME
	  model=model.toUpperCase(); //轉成大寫
	  beginIDX=endIDX+1;
	  while (s.indexOf("|",beginIDX)>=0 && beginIDX>=0) //if beginIDX<0 that means end of line
	  {	   
	   String sql="insert into PSALES_FORE_MONTH(FMCOMP,FMYEAR,FMMONTH,FMREG,FMCOUN,FMTYPE,FMPRJCD,FMQTY,FMVER,FMLUSER,FMLDATE) values(?,?,?,?,?,?,?,?,?,?,?)";
       PreparedStatement pstmt=con.prepareStatement(sql);
	  
	   endIDX=s.indexOf("|",beginIDX);	
	   
	   pstmt.setString(1,comp);
       pstmt.setString(2,adjDateBean.getYearString());  
       pstmt.setString(3,adjDateBean.getMonthString());
       pstmt.setString(4,region);
       pstmt.setString(5,country);
       pstmt.setString(6,type);
       pstmt.setString(7,model.trim()); //MODEL
	   String qty=s.substring(beginIDX,endIDX);
	   qty=qty.trim();
	   if (qty.equals("")) qty="0";	
       pstmt.setString(8,qty); //寫入抓取的各月數字	 
       pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinute());
       pstmt.setString(10,userID);
	   pstmt.setString(11,dateString);		     
       pstmt.executeUpdate();
	   pstmt.close();	   	        			  	  	                    	   	  
	   	   
	   beginIDX=endIDX+1;
	   adjDateBean.setAdjMonth(1);		    
	  }	//END OF SEARCH STRING WHILE		    
	 } //END OF S IF NOT NULL
	} //end of while to read file	
	br.close();	
	
	out.println("FORECAST FILE UPLOAD SUCCESSFULLY");
	out.println("<BR><A HREF=../jsp/WSBatchFileUploadEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+"&VYEAR="+vYear+"&VMONTH="+vMonth+">Batch data Upload Entry</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to SubMenu</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");	
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
