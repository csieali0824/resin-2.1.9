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
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }  
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<script language="javascript">
function setSubClose()
{
  this.window.close();  
}
</script>
</script>
<body>
<FORM NAME="MYFORM" method="post" action="../IQCInclude/TSIQCSpecFileBlobsInsert.jsp">
<%
// For upload file By Kerwin
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
// For upload file By Kerwin

String APPNO="";

String inspLotNo=mySmartUpload.getRequest().getParameter("INSPLOTNO");
String classID=mySmartUpload.getRequest().getParameter("CLASSID");

String SPLATFM_NAME="";

//System.err.println("Step1");




// FOR UPLOAD FILE bY KERWIN //



com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
front_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
String frontFile_name=front_file.getFileName();
String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();


// FOR UPLOAD FILE bY KERWIN //

//out.println("Step2="+frontFile_name);

//out.println("Step3="+inspLotNo);
//out.println("Step4="+classID);
//out.println("Step5="+UserName);
//out.println("Step6="+frontFilePath);

try
{   
  Statement state=con.createStatement();
  ResultSet rs=state.executeQuery("select FILES from ORADDMAN.TSCIQC_SPECFILE where INSPLOT_NO='"+inspLotNo+"' "); 
  if (rs.next())
  {  // 存在,則先刪除,再新增
  
     String sql="delete from ORADDMAN.TSCIQC_SPECFILE where INSPLOT_NO='"+inspLotNo+"' ";		              
     PreparedStatement pstmt=con.prepareStatement(sql);
	 pstmt.executeUpdate(); 
     pstmt.close();
     
  }
  rs.close();
  state.close();
// Start up for upload file by Kerwin

   Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
   stmt.executeUpdate("insert into ORADDMAN.TSCIQC_SPECFILE(INSPLOT_NO,FILES,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,CLASS_ID,FILE_NAME) values('"+inspLotNo+"',empty_blob(),'"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+classID+"','"+frontFile_name+"')");	
  //inser Binary File To DB    
  if  (!front_file.isMissing()) 
  {
    ResultSet rs7=stmt.executeQuery("select FILES from ORADDMAN.TSCIQC_SPECFILE where INSPLOT_NO='"+inspLotNo+"' for UPDATE");  	
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
	   
     //System.err.println("Step3");

     out.println("Specification file upload success!!<BR>");  
	 out.println("<A HREF='../IQCInclude/TSIQCShowSpecBlobsContent.jsp?INSPLOTNO="+inspLotNo+"'>預覽此規格圖面:(檔案名稱="+frontFile_name+")</A>");	          
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

//session.setAttribute("INSPLOTNO",inspLotNo);
//response.sendRedirect("TSIQCShowSpecBlobsContent.jsp?INSPLOTNO="+inspLotNo);

%>
<input type="button" name="Close" value="關閉" onClick="setSubClose()">
<br>
<input type="hidden" size="10" name="INSPLOTNO" value="<%=inspLotNo%>">
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
