<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,DateBean,ArrayCheckBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayCheckBoxBean4Ringer" scope="session" class="ArrayCheckBoxBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
</head>
<body>
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
String projectCode=mySmartUpload.getRequest().getParameter("PROJECTCODE");
String salesCode=mySmartUpload.getRequest().getParameter("SALESCODE");
String productType=mySmartUpload.getRequest().getParameter("PRODUCTTYPE");
String brand=mySmartUpload.getRequest().getParameter("BRAND");
String length=mySmartUpload.getRequest().getParameter("LENGTH");
String width=mySmartUpload.getRequest().getParameter("WIDTH");
String height=mySmartUpload.getRequest().getParameter("HEIGHT");
String weight=mySmartUpload.getRequest().getParameter("WEIGHT");
String launchYear=mySmartUpload.getRequest().getParameter("LAUNCHYEAR");
String launchMonth=mySmartUpload.getRequest().getParameter("LAUNCHMONTH");
String launchDay=mySmartUpload.getRequest().getParameter("LAUNCHDAY");
String launchDateString=launchYear+launchMonth+launchDay;
if (launchDateString.equals("------")) launchDateString="--------";
String deLaunchYear=mySmartUpload.getRequest().getParameter("DELAUNCHYEAR");
String deLaunchMonth=mySmartUpload.getRequest().getParameter("DELAUNCHMONTH");
String deLaunchDay=mySmartUpload.getRequest().getParameter("DELAUNCHDAY");
String deLaunchDateString=deLaunchYear+deLaunchMonth+deLaunchDay;
if (deLaunchDateString.equals("------")) deLaunchDateString="--------";
String taYear=mySmartUpload.getRequest().getParameter("TAYEAR");
String taMonth=mySmartUpload.getRequest().getParameter("TAMONTH");
String taDay=mySmartUpload.getRequest().getParameter("TADAY");
String taDateString=taYear+taMonth+taDay;
if (taDateString.equals("------")) taDateString="--------";
String taStatus=mySmartUpload.getRequest().getParameter("TASTATUS");
String designHouse=mySmartUpload.getRequest().getParameter("DESIGNHOUSE");
String systemMode=mySmartUpload.getRequest().getParameter("SYSTEMMODE");
String platform=mySmartUpload.getRequest().getParameter("PLATFORM");

String camera=mySmartUpload.getRequest().getParameter("CAMERA");
String cameraCode=mySmartUpload.getRequest().getParameter("CAMERACODE");
String displayMain=mySmartUpload.getRequest().getParameter("DISPLAYMAIN");
String displaySub=mySmartUpload.getRequest().getParameter("DISPLAYSUB");
String ringtoneCode=mySmartUpload.getRequest().getParameter("RINGTONECODE");
String bandMode=mySmartUpload.getRequest().getParameter("BANDMODE");
String remark=mySmartUpload.getRequest().getParameter("REMARK");
String phonebook=mySmartUpload.getRequest().getParameter("PHONEBOOK");
String[] comm=mySmartUpload.getRequest().getParameterValues("COMM");
String [][] chooseFeatures=arrayCheckBoxBean.getArray2DContent();
String [][] chooseRingers=arrayCheckBoxBean4Ringer.getArray2DContent();

String wap=mySmartUpload.getRequest().getParameter("WAP");
String wap_ver=mySmartUpload.getRequest().getParameter("WAP_VER");
String gprs=mySmartUpload.getRequest().getParameter("GPRS");
String gprs_ver=mySmartUpload.getRequest().getParameter("GPRS_VER");

com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
front_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
String frontFile_name=front_file.getFileName();
String frontFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();
com.jspsmart.upload.File side_file=mySmartUpload.getFiles().getFile(1); 
side_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName());
String sideFile_name=side_file.getFileName();
String sideFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName();
com.jspsmart.upload.File open_file=mySmartUpload.getFiles().getFile(2); 
open_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+open_file.getFileName());
String openFile_name=open_file.getFileName();
String openFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+open_file.getFileName();
com.jspsmart.upload.File back_file=mySmartUpload.getFiles().getFile(3); 
back_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+back_file.getFileName());
String backFile_name=back_file.getFileName();
String backFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+back_file.getFileName();

try
{  
  String sql="insert into PIMASTER (PROJECTCODE,SALESCODE,PRODUCTTYPE,BRAND,TADATE,TASTATUS,LAUNCHDATE,DELAUNCHDATE"+
  ",CAMERA,CAMERACODE,WEIGHT,LENGTH,WIDTH,HEIGHT,DISPLAYMAIN,DISPLAYSUB,RINGTONECODE,BANDMODE,REMARK,CREATEDBY,CREATEDDATE"+
  ",PHONEBOOK,WAP,WAP_VER,GPRS,GPRS_VER,DESIGNHOUSE,SYSTEMMODE,PLATFORM) "+
  " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);
  pstmt.setString(1,projectCode);
  pstmt.setString(2,salesCode);
  pstmt.setString(3,productType);
  pstmt.setString(4,brand);
  pstmt.setString(5,taDateString);
  pstmt.setString(6,taStatus);
  pstmt.setString(7,launchDateString);
  pstmt.setString(8,deLaunchDateString);
  pstmt.setString(9,camera);
  pstmt.setString(10,cameraCode);  
  pstmt.setFloat(11,Float.parseFloat(weight)); 
  pstmt.setFloat(12,Float.parseFloat(length));
  pstmt.setFloat(13,Float.parseFloat(width));
  pstmt.setFloat(14,Float.parseFloat(height));  
  pstmt.setString(15,displayMain);
  pstmt.setString(16,displaySub);
  pstmt.setString(17,ringtoneCode);  
  pstmt.setString(18,bandMode);
  pstmt.setString(19,remark);
  pstmt.setString(20,UserName);
  pstmt.setString(21,dateBean.getYearMonthDay());  
  pstmt.setString(22,phonebook);
  pstmt.setString(23,wap);
  pstmt.setString(24,wap_ver);  
  pstmt.setString(25,gprs);
  pstmt.setString(26,gprs_ver); 
  pstmt.setString(27,designHouse);
  pstmt.setString(28,systemMode); 
  pstmt.setString(29,platform); 
  
  pstmt.executeUpdate(); 
  pstmt.close();
  
  //inser Binary File To DB    
  if  (!front_file.isMissing() || !side_file.isMissing() || !open_file.isMissing() || !back_file.isMissing()) 
  {
    Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
    stmt.executeUpdate("insert into PIIMAGE(PROJECTCODE,IMGFRONTVIEW,FNAMEFRONTVIEW,IMGSIDEVIEW,FNAMESIDEVIEW,IMGOPENVIEW,FNAMEOPENVIEW,IMGBACKVIEW,FNAMEBACKVIEW) values('"+projectCode+"',empty_blob(),'"+frontFile_name+"',empty_blob(),'"+sideFile_name+"',empty_blob(),'"+openFile_name+"',empty_blob(),'"+backFile_name+"')");	
    ResultSet rs=stmt.executeQuery("select IMGFRONTVIEW,IMGSIDEVIEW,IMGOPENVIEW,IMGBACKVIEW from PIIMAGE where PROJECTCODE='"+projectCode+"' for UPDATE");  	
    if (rs.next())
    {
     BLOB myblob=null;
     FileInputStream instream=null;
     OutputStream outstream=null;
     int bufsize=0;
     byte[] buffer =null;
     int fileLength=0;   
     
	 if  (!front_file.isMissing())
	 {
       myblob=((OracleResultSet)rs).getBLOB(1);
       instream=new FileInputStream(frontFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	        	   
	 } //end of frontviewfile if
	   
	 if  (!side_file.isMissing())
	 {
       myblob=((OracleResultSet)rs).getBLOB(2);
       instream=new FileInputStream(sideFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();
   	 } //end of sideFileView if
	 
	 if  (!open_file.isMissing())
	 {
       myblob=((OracleResultSet)rs).getBLOB(3);
       instream=new FileInputStream(openFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	   
	 } //end of openViewFile if 
	 
     if  (!back_file.isMissing() )
	 {
       myblob=((OracleResultSet)rs).getBLOB(4);
       instream=new FileInputStream(backFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	   
	 } //end of openViewFile if 
	 
     out.println("Image file upload success!!<BR>");  	          
    } // end of rs if  
	stmt.close();
    rs.close();
  } //enf of open_file,front_file,side_file if	  
  
  if (comm!=null && comm.length>0)
  {   
    for (int i=0;i<comm.length;i++)
    {   
     String commSql="insert into PIPRODCOMM(PROJECTCODE,COMMNAME) values(?,?)";
     PreparedStatement commStmt=con.prepareStatement(commSql);
     commStmt.setString(1,projectCode); 
     commStmt.setString(2,comm[i]); 
     commStmt.executeUpdate();       
     commStmt.close();
    } //end of for  
  } // end of COMM array if
  
  if (chooseFeatures!=null && chooseFeatures.length>0)
  {   
    for (int i=0;i<chooseFeatures.length;i++)
    {   
     String commSql="insert into PIPRODFEATURES(PROJECTCODE,FEATURECODE) values(?,?)";
     PreparedStatement commStmt=con.prepareStatement(commSql);
     commStmt.setString(1,projectCode); 
     commStmt.setString(2,chooseFeatures[i][0]); 
     commStmt.executeUpdate();       
     commStmt.close();
    } //end of for  
  } // end of chooseFeature array if
  
  if (chooseRingers!=null && chooseRingers.length>0)
  {   
    for (int i=0;i<chooseRingers.length;i++)
    {   
     String commSql="insert into PIPRODRINGER(PROJECTCODE,RINGERCODE) values(?,?)";
     PreparedStatement commStmt=con.prepareStatement(commSql);
     commStmt.setString(1,projectCode); 
     commStmt.setString(2,chooseRingers[i][0]); 
     commStmt.executeUpdate();       
     commStmt.close();
    } //end of for  
  } // end of chooseFeature array if
  out.println("insert Data success!!"+projectCode+"<BR>"); 
  out.println("<BR><A HREF='PIInputPage.jsp'>New Product Information</A>");
  out.println("<A HREF='PIQueryAll.jsp'>Query All Product Information</A>");
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
