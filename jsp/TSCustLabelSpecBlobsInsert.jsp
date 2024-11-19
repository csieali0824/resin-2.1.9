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
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" method="post" action="../TSIQCSpecFileBlobsInsert.jsp">
<%
// For upload file By Kerwin
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
// For upload file By Kerwin

String APPNO="";

String custNo=mySmartUpload.getRequest().getParameter("CUST_NO");
String stationNo=mySmartUpload.getRequest().getParameter("STATNO");
String typeID=mySmartUpload.getRequest().getParameter("TYPE_ID");
String organizationID=request.getParameter("MARKETTYPE");
String SPLATFM_NAME="";

//System.err.println("Step1");




// FOR UPLOAD FILE bY KERWIN //



com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
front_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
String frontFile_name=front_file.getFileName();
String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();

com.jspsmart.upload.File side_file=mySmartUpload.getFiles().getFile(1); 
side_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName());
String sideFile_name=side_file.getFileName();
String sideFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName();

// FOR UPLOAD FILE bY KERWIN //

//out.println("Step2="+frontFile_name);

//out.println("Step3="+inspLotNo);

int fileNameLength = frontFile_name.length();
String fileExtName = frontFile_name.substring(fileNameLength-3,fileNameLength); // 取檔案附檔名

int iconFileLength = sideFile_name.length();
String iconFileExtName = null;
  if (iconFileLength>0) // 表示有存圖檔(*.ico, *.bmp, *.jpg)
  {   iconFileExtName = sideFile_name.substring(iconFileLength-3,iconFileLength);  } // 取圖檔案附檔名 

if (fileExtName!=null && !fileExtName.equals("lbl") && !fileExtName.equals("LBL"))
{
   %>
      <script language="javascript">
	     alert("請確認上載檔案為標籤檔!!!");
	  </script>
   <%
   
   if (iconFileExtName!=null)
   {
      if ( (!fileExtName.equals("ico") && !fileExtName.equals("ICO")) || (!fileExtName.equals("bmp") && !fileExtName.equals("BMP")) || (!fileExtName.equals("jpg") && !fileExtName.equals("JPG")) )
	  {
	      %>
            <script language="javascript">
	         alert("請確認上載圖檔為*.ICO、*.BMP或*.JPG格式!!!");
	        </script>
          <%
	  }
   }
   
}
else
{
  try
  {   
    Statement state=con.createStatement();
    ResultSet rs=state.executeQuery("select LABEL_TEMPFILE from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' "); 
    if (rs.next())
    {  // 存在,則先刪除,再新增
  
     String sql="delete from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' ";		              
     PreparedStatement pstmt=con.prepareStatement(sql);
	 pstmt.executeUpdate(); 
     pstmt.close();
     
    }
    rs.close();
    state.close();
// Start up for upload file by Kerwin

   // 找客戶編號對應的的客戶識別碼及客戶名稱_起
      int custID = 0;
	  String custName = "";
      Statement stateCust=con.createStatement();
      ResultSet rsCust=stateCust.executeQuery("select CUSTOMER_ID, CUSTOMER_NAME from ORADDMAN.TSCUST_LABEL_SPECS  where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' "); 
      if (rsCust.next())
	  {
	     custID = rsCust.getInt(1);
		 custName = rsCust.getString(2);		 
	  }
	  rsCust.close();
	  stateCust.close();
  //  找客戶編號對應的的客戶識別碼及客戶名稱_迄


  Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  stmt.executeUpdate("insert into ORADDMAN.TSCUST_LABEL_BLOBS(CUSTOMER_ID, CUST_NO, CUSTOMER_NAME, STATNO, TYPE_ID, LABEL_TEMPFILE, LABEL_BLOBFILE, CUST_ICONFILE, CUST_BLOBICON, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, ORGANIZATION_ID) "+
                      " values("+custID+", "+custNo+", '"+custName+"', '"+stationNo+"', '"+typeID+"', '"+frontFile_name+"', empty_blob(), '"+sideFile_name+"', empty_blob(), '"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+organizationID+"')");	
  //inser Binary File To DB for Template Label File    
  if  (!front_file.isMissing()) 
  {
    ResultSet rs7=stmt.executeQuery("select LABEL_BLOBFILE from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' for UPDATE");  	
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
	 
	 // 更新客戶特殊規格標籤檔檔名_起
	    PreparedStatement updtSstmte=con.prepareStatement("update ORADDMAN.TSCUST_LABEL_SPECS set LABEL_TEMPFILE=? where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' ");
		updtSstmte.setString(1,frontFile_name);	  // 客戶樣本標籤檔名  
        updtSstmte.executeUpdate();
        updtSstmte.close();
	 // 更新客戶特殊規格標籤檔檔名_迄
	   
     //System.err.println("Step3");

     out.println("Specification file upload success!!<BR>");  
	 out.println("<A HREF='TSCustLabelSpecBlobsContent.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID='"+typeID+"'&MARKETTYPE="+organizationID+"'>預覽此客戶標籤規格樣本檔:(檔案名稱="+frontFile_name+")</A><BR>");	          	 
    } // end of rs if  
	//stmt.close();
    rs7.close();
  } //enf of open_file,front_file,side_file if	

  //inser Binary Icon File To DB for Customer Icon File 
  if  (!side_file.isMissing()) 
  {
    ResultSet rs8=stmt.executeQuery("select CUST_BLOBICON from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' for UPDATE");  	
    if (rs8.next())
    {
     BLOB myblob=null;
     FileInputStream instream=null;
     OutputStream outstream=null;
     int bufsize=0;
     byte[] buffer =null;
     int fileLength=0;   
     
	 if  (!side_file.isMissing())
	 {
       myblob=((OracleResultSet)rs8).getBLOB(1);
       instream=new FileInputStream(sideFilePath);
       outstream=myblob.getBinaryOutputStream();
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
           outstream.write(buffer,0,fileLength);
       instream.close();	 
       outstream.close();	        	   
	 } //end of frontviewfile if
	 
	 // 更新客戶特殊規格圖樣檔名_起
	    PreparedStatement updtSstmte=con.prepareStatement("update ORADDMAN.TSCUST_LABEL_SPECS set ICON_NAME=? where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' ");
		updtSstmte.setString(1,sideFile_name);	  // 客戶樣本標籤檔名  
        updtSstmte.executeUpdate();
        updtSstmte.close();
	 // 更新客戶特殊規格圖樣檔名_迄
	   
     //System.err.println("Step3");

     out.println("Customer Icon file upload success!!<BR>");  
	 out.println("<A HREF='TSCustLabelIconBlobsContent.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&MARKETTYPE="+organizationID+"'>預覽此客戶標籤特殊圖樣:(檔案名稱="+sideFile_name+")</A>");	          
    } // end of rs if  
	stmt.close();
    rs8.close();
  } //enf of side_file if

 // End of upload file by Kerwin  

 //執行sendMail動作
  
   //  out.println("<img src='../jsp/WSMRNewModelSendMail.jsp?APPUSERID="+WEBID+"&APPNO='"+seqnoApp+"' height='0' width='0'>&nbsp;&nbsp;");	

//end of //執行sendMail動作
 
  
  } //end of try
  catch (Exception e)
  {
   out.println(e.getMessage());
  }//end of catch
} // End of else
//session.setAttribute("INSPLOTNO",inspLotNo);
//response.sendRedirect("TSIQCShowSpecBlobsContent.jsp?INSPLOTNO="+inspLotNo);

%>
<input type="button" name="Close" value="關閉" onClick="setSubClose()">
<br>
<input type="hidden" size="10" name="CUST_NO" value="<%=custNo%>">
<input type="hidden" size="10" name="STATNO" value="<%=stationNo%>">
<input type="hidden" size="10" name="TYPE_ID" value="<%=typeID%>">
<input type="hidden" size="10" name="MARKETTYPE" value="<%=organizationID%>">
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
