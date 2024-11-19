<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<STYLE type=text/css>
A:link {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:active {
	TEXT-DECORATION: none
}
A:visited {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:hover {
	COLOR: #3333FF; TEXT-DECORATION: none
}
td {
	font-size: 12px;
}
.tab {
	background-image:   url(../jsp/image/bd-2.jpg);
	background-repeat: no-repeat;
	background-position: right bottom;
	background-color: #FFFFFF;
}
</STYLE>
<html>
<head>
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
<title>Nice Label Opener</title>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%

   // For upload file By Kerwin
   //mySmartUpload.initialize(pageContext); 
   //mySmartUpload.upload();
  // For upload file By Kerwin
  
   String front_file=null;

   String custNo=request.getParameter("CUST_NO");
   String stationNo=request.getParameter("STATNO");
   String typeID=request.getParameter("TYPE_ID");
   String organizationID=request.getParameter("MARKETTYPE");
    
   
   //if (projectCode.substring(projectCode.length()-4,projectCode.length()).equals("plus")) projectCode=projectCode.substring(0,projectCode.length()-4)+"+";
   //String whichView=request.getParameter("WHICHVIEW"); //DECIDE TO SHOW WHICH SIDE OF VIEW
   int    bbuffSize = 64 ;  //bbuffSize = 64 ;
   byte[]  bbuff = new byte[bbuffSize] ;  
   
   
  Blob blob;  
  
  try
  {  
   Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
   ResultSet rs=stmt.executeQuery("select * from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID="+typeID+" and ORGANIZATION_ID='"+organizationID+"' for UPDATE ");
   if (rs.next())
   {
    blob = (Blob)rs.getObject("LABEL_BLOBFILE") ;  
    bbuff = blob.getBytes(1, (int)blob.length());
		
	 //String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+rs.getString("LABEL_TEMPFILE"); 
	 String frontFilePath="d:/clientupload/"+rs.getString("LABEL_TEMPFILE");   
	// String frontFilePath="C://tempSample.lbl";
	 front_file=frontFilePath; 
	
	 // 將資料庫取出的Blob檔另存O.S 檔案於給定位置_By Kerwin
	
	 BLOB myblob=null;
     InputStream instream=null;
     FileOutputStream outstream=null;
     int bufsize=0;
     byte[] buffer =null;
     int fileLength=0;   
	 String s = "";
	      	         
	   myblob=((OracleResultSet)rs).getBLOB("LABEL_BLOBFILE");
       //instream=myblob.getBinaryOutputStream();
	   instream=myblob.getBinaryStream(0);
       outstream=new FileOutputStream(frontFilePath);
       bufsize=myblob.getBufferSize();
       buffer = new byte[bufsize];   
       while ((fileLength=instream.read(buffer))!=-1)   
       {        
	     outstream.write(buffer,0,fileLength);
		 outstream.flush(); 
	   }
       instream.close();	 
       outstream.close();		   
	 // 將資料庫取出的Blob檔另存O.S 檔案於給定位置_By Kerwin   
      
    int specFileNameLngth = rs.getString("LABEL_TEMPFILE").length();
    String specFileExtName = rs.getString("LABEL_TEMPFILE").substring(specFileNameLngth-3,specFileNameLngth);
	//out.println("LBL File Open="+specFileExtName); 
	if (specFileExtName=="LBL" || specFileExtName.equals("LBL") || specFileExtName=="lbl" || specFileExtName.equals("lbl"))
    { // 若格式是條碼檔,則以Java呼叫外部程式呼叫 Nice Label
	
      //out.println("LBL File Open="+specFileExtName);
      Runtime runtime=Runtime.getRuntime();
      Process process=null;
      String line=null;
      InputStream is =null;
      InputStreamReader isr=null;
      BufferedReader br=null;
      try
      {     
	     out.println("frontFilePath="+frontFilePath+"<BR>");                          
	     //Runtime.getRuntime().exec("C://Program Files//EuroPlus//NiceLabel//Bin//nice3.exe KerwinSample.lbl ");
		 Runtime.getRuntime().exec("C://Program Files//EuroPlus//NiceLabel//Bin//nice3.exe "+frontFilePath+" /s");
         //process = runtime.exec("cmd /C nicele3.exe");
		 
		 //process = runtime.exec("cmd /C dir");
		 //out.println("cmd /C cd C:/Program Files/EuroPlus/LE/Bin/");
		 //process = runtime.exec("cmd /C C:/Program Files/EuroPlus/LE/Bin/nicele3.exe");
         //process = runtime.exec("cmd /C nicele3.exe");
		 //out.println("1");
	   /*	 
         is = process.getInputStream();
         isr=new InputStreamReader(is);
         br =new BufferedReader(isr);
		 //out.println("2");
         out.println("<pre>");
         while( (line = br.readLine())!=null  )
         {
		  //out.println("3");
          out.println(line);
          out.flush();
		  //response.getOutputStream().flush(); 
         }
         out.println("</pre>");
         is.close();
         isr.close();
         br.close();
		 
		  try {
                if (process.waitFor() != 0) 
				{
                    System.err.println("exit value = " + process.exitValue());
                }
              }
              catch (InterruptedException e)
			  {
                System.err.println(e);
              }	
		*/
		 //out.println("6");
       }
       catch(IOException e )
       {
         out.println(e);
         runtime.exit(1);
       }   
    }  // End of if (specFileExtName=="LBL" || specFileExtName.equals("LBL") || specFileExtName=="lbl")
   stmt.close();
   rs.close(); 
   
  } // End of if (rs.next())
  
 } //end of try
 catch (Exception e)
 {
   out.println(e.getMessage());
 }//end of catch
	
%>
<input type="button" name="Close" value="關閉" onClick="setSubClose()">
<br>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->