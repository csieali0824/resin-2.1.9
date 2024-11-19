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
 
String custID=mySmartUpload.getRequest().getParameter("CUSTOMERID");
String custNo=mySmartUpload.getRequest().getParameter("CUSTOMERNO");
String custName=mySmartUpload.getRequest().getParameter("CUSTOMERNAME");
String stationNo=mySmartUpload.getRequest().getParameter("STATNO");
String typeID=mySmartUpload.getRequest().getParameter("TYPE_ID");
String organizationID=mySmartUpload.getRequest().getParameter("MARKETTYPE");
String labelRemark=mySmartUpload.getRequest().getParameter("REMARK");
String tscFamily=mySmartUpload.getRequest().getParameter("ITEMCATE");

String attrVar1=mySmartUpload.getRequest().getParameter("ATTRIBUTE1");
String attrVar2=mySmartUpload.getRequest().getParameter("ATTRIBUTE2");
String attrVar3=mySmartUpload.getRequest().getParameter("ATTRIBUTE3");
String attrVar4=mySmartUpload.getRequest().getParameter("ATTRIBUTE4");
String attrVar5=mySmartUpload.getRequest().getParameter("ATTRIBUTE5");
String attrVar6=mySmartUpload.getRequest().getParameter("ATTRIBUTE6");
String attrVar7=mySmartUpload.getRequest().getParameter("ATTRIBUTE7");
String attrVar8=mySmartUpload.getRequest().getParameter("ATTRIBUTE8");
String attrVar9=mySmartUpload.getRequest().getParameter("ATTRIBUTE9");
String attrVar10=mySmartUpload.getRequest().getParameter("ATTRIBUTE10");
String attrVar11=mySmartUpload.getRequest().getParameter("ATTRIBUTE11");
String attrVar12=mySmartUpload.getRequest().getParameter("ATTRIBUTE12");

if (tscFamily==null || tscFamily.equals("")) tscFamily="ALL";
String frontFile_name="",frontFilePath="",sideFile_name="",sideFilePath="",prevFile_name="",prevFilePath="";
int intRunStep=0;//add by Peggy 20120824
//System.err.println("Step1");

//add try catch by Peggy 20120824
try
{
	intRunStep = 1;
	com.jspsmart.upload.File front_file=mySmartUpload.getFiles().getFile(0);
	frontFile_name=front_file.getFileName();
	//String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName();
	frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+frontFile_name;
	//front_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+front_file.getFileName()); 
	front_file.saveAs(frontFilePath); //modify by Peggy 20120824
	
	com.jspsmart.upload.File side_file=mySmartUpload.getFiles().getFile(1); 
	sideFile_name=side_file.getFileName();
	//String sideFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName();
	sideFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+sideFile_name;
	//side_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+side_file.getFileName());
	side_file.saveAs(sideFilePath); //modify by Peggy 20120824
	
	
	com.jspsmart.upload.File prev_file=mySmartUpload.getFiles().getFile(2); 
	prevFile_name=prev_file.getFileName();
	//String prevFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+prev_file.getFileName();
	prevFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+prevFile_name;
	//prev_file.saveAs("d://clientupload/"+request.getRemoteAddr()+"-"+prev_file.getFileName());
	prev_file.saveAs(prevFilePath);
	
	int fileNameLength = frontFile_name.length();
	String fileExtName = "";
    if  (!front_file.isMissing())
	{
    	fileExtName = frontFile_name.substring(fileNameLength-3,fileNameLength); // 取檔案附檔名
	}
	 
	int iconFileLength = sideFile_name.length();
	String iconFileExtName = null;
  	if (iconFileLength>0) // 表示有存圖檔(*.ico, *.bmp, *.jpg)
  	{   
		iconFileExtName = sideFile_name.substring(iconFileLength-3,iconFileLength);  
	} // 取圖檔案附檔名 
  
	int prevFileLength = prevFile_name.length(); 
	String prevFileExtName = null;
 	if (prevFileLength>0) // 表示有存標籤預覽圖檔(*.ico, *.bmp, *.jpg)
 	{   
		prevFileExtName = prevFile_name.substring(prevFileLength-3,prevFileLength);  
	} // 取標籤預覽圖檔附檔名 

	//out.println("prevFileExtName="+prevFileExtName);
	//out.println("prevFile_name="+prevFile_name);
	//out.println("prev_file="+prev_file);

	if (fileExtName!=null && !fileExtName.equals("lbl") && !fileExtName.equals("LBL"))	
	{
   	%>
    	<script language="javascript">
	    	alert("請確認上載檔案為標籤檔!!!");
	  	</script>
   	<%
   
   		if (iconFileExtName!=null)
   		{
      		if ( (!iconFileExtName.equals("ico") && !iconFileExtName.equals("ICO")) || (!iconFileExtName.equals("bmp") && !iconFileExtName.equals("BMP")) || (!iconFileExtName.equals("jpg") && !iconFileExtName.equals("JPG")) )
	  		{
	      	%>
            	<script language="javascript">
	         	alert("請確認上載圖檔為*.ICO、*.BMP或*.JPG格式!!!");
	        	</script>
          	<%
	  		}
   		}
  
   		if (prevFileExtName!=null)
   		{
      		if ( (!prevFileExtName.equals("ico") && !prevFileExtName.equals("ICO")) || (!prevFileExtName.equals("bmp") && !prevFileExtName.equals("BMP")) || (!prevFileExtName.equals("jpg") && !prevFileExtName.equals("JPG")) )
	  		{
	      	%>
            	<script language="javascript">
	         		alert("請確認上載條碼預覽圖檔為*.ICO、*.BMP或*.JPG格式!!!");
	        	</script>
          	<%
	  		}
   		}
	}
	else
	{
		intRunStep = 2;
    	// 標籤檔(*.lbl)、客戶特殊圖樣(*.ico)、標籤預覽圖樣(*.jpg) BLOB 檔
    	Statement state=con.createStatement();
    	ResultSet rs=state.executeQuery("select LABEL_TEMPFILE from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' "); 
    	if (rs.next())
    	{  // 存在Binary檔,則先刪除,再新增
  
     		String sql="delete from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' ";		              
     		PreparedStatement pstmt=con.prepareStatement(sql);
	 		pstmt.executeUpdate(); 
     		pstmt.close();
    	}
    	rs.close();	
	
		ResultSet rsCSL=state.executeQuery("select * from ORADDMAN.TSCUST_LABEL_SPECS where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' "); 
    	if (rsCSL.next())
    	{  // 存在主檔,則先刪除,再新增
  
     		String sql="delete from ORADDMAN.TSCUST_LABEL_SPECS where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' ";		              
     		PreparedStatement pstmt=con.prepareStatement(sql);
	 		pstmt.executeUpdate(); 
     		pstmt.close();
    	}
    	rsCSL.close();	
    	state.close();
		// Start up for upload file by Kerwin

  		// 新增客戶特殊規格標籤主檔_起
	   	// 找站別代號對應名稱_起
	    String stationName = "";
	    Statement stateStatName=con.createStatement();
	    ResultSet rsStatName=stateStatName.executeQuery("select STATNAME from ORADDMAN.TSCUST_LABEL_STATION where STATNO='"+stationNo+"' "); 
		if (rsStatName.next())
		{
			stationName = rsStatName.getString(1); 
		}
		rsStatName.close();
		stateStatName.close();
	   // 找站別代號對應名稱_迄
	   
	   // 找標籤類型代碼對應名稱_起
	    String typeName = "";
	    Statement stateType=con.createStatement();
	    ResultSet rsType=stateType.executeQuery("select TYPE_NAME from ORADDMAN.TSCUST_LABEL_TYPE where TYPE_ID='"+typeID+"' "); 
		if (rsType.next())
		{
			typeName = rsType.getString(1); 
		}
		rsType.close();
		stateType.close();
	   // 找標籤類型代碼對應名稱_迄
	   
	   	if (tscFamily==null || tscFamily.equals("") || tscFamily.equals("--"))
	   	{
	    	tscFamily = "ALL";
	   	}
	  
	  	intRunStep = 3;
		String sqlInsCSL="insert into ORADDMAN.TSCUST_LABEL_SPECS(CUSTOMER_ID, CUST_NUMBER, CUSTOMER_NAME, CUST_DESCRIPTION, STATNO, STAT_NAME, TYPE_ID, TYPE_DESCRIPTION, LABEL_TEMPFILE, ICON_NAME, ORGANIZATION_ID, LABEL_REMARK, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, TSC_FAMILY, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,TSC_PACKAGE) "+		              
		            "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
        PreparedStatement pstmtCSL=con.prepareStatement(sqlInsCSL);
		pstmtCSL.setInt(1,Integer.parseInt(custID));	// 客戶識別碼
		pstmtCSL.setInt(2,Integer.parseInt(custNo));  // 客戶編號
		pstmtCSL.setString(3,custName);  // 客戶名稱
		pstmtCSL.setString(4,custName);  // 客戶名稱
		pstmtCSL.setString(5,stationNo); // 站別代號
		pstmtCSL.setString(6,stationName); // 站別名稱
		pstmtCSL.setString(7,typeID);      // 站別名稱
		pstmtCSL.setString(8,typeName);    // 站別名稱
		pstmtCSL.setString(9,frontFile_name);     // 標籤樣本檔名
		pstmtCSL.setString(10,sideFile_name);     // 特殊圖樣樣本檔名
		pstmtCSL.setString(11,organizationID);     // 內外銷別
		pstmtCSL.setString(12,labelRemark);        // 備註說明
		pstmtCSL.setString(13,attrVar1);           // 標籤變數1  
		pstmtCSL.setString(14,attrVar2);           // 標籤變數2 
		pstmtCSL.setString(15,attrVar3);           // 標籤變數3  
		pstmtCSL.setString(16,attrVar4);           // 標籤變數4 
		pstmtCSL.setString(17,attrVar5);           // 標籤變數5  
		pstmtCSL.setString(18,attrVar6);           // 標籤變數6 
		pstmtCSL.setString(19,attrVar7);           // 標籤變數7  
		pstmtCSL.setString(20,attrVar8);           // 標籤變數8
		pstmtCSL.setString(21,attrVar9);           // 標籤變數9  
		pstmtCSL.setString(22,attrVar10);          // 標籤變數10 
		pstmtCSL.setString(23,attrVar11);          // 標籤變數11  
		pstmtCSL.setString(24,attrVar12);          // 標籤變數12
		pstmtCSL.setString(25,tscFamily);          // 產品族群 
		pstmtCSL.setString(26,UserName);           // 新增人員 
		pstmtCSL.setString(27,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());          //最後修改日期 
		pstmtCSL.setString(28,UserName);           // 最終修改人員
		pstmtCSL.setString(29,tscFamily);          // 產品Package 
	    pstmtCSL.executeUpdate(); 
        pstmtCSL.close(); 
		
		//out.println("Exception 寫入客戶特殊規格標籤主檔"+e.getMessage());
  		
		intRunStep = 4;
  		// 新增客戶特殊規格標籤主檔_迄
  		Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  		stmt.executeUpdate("insert into ORADDMAN.TSCUST_LABEL_BLOBS(CUSTOMER_ID, CUST_NO, CUSTOMER_NAME, STATNO, TYPE_ID, ORGANIZATION_ID, LABEL_TEMPFILE, LABEL_BLOBFILE, CUST_ICONFILE, CUST_BLOBICON, LABEL_PREVFILE, LABEL_BLOBPREV, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,TSC_PACKAGE) "+
                      " values("+custID+", "+custNo+", '"+custName+"', '"+stationNo+"', '"+typeID+"', '"+organizationID+"', '"+frontFile_name+"', empty_blob(), '"+sideFile_name+"', empty_blob(), '"+prevFile_name+"', empty_blob(), '"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+UserName+"','"+tscFamily+"')");	
		
		intRunStep = 5;					
  		//inser Binary File To DB for Template Label File    
  		if  (!front_file.isMissing()) 
  		{
    		ResultSet rs7=stmt.executeQuery("select LABEL_BLOBFILE from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' for UPDATE");  	
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
	 			}

     			out.println("Specification file upload success!!<BR>");  
	 			out.println("<A HREF='TSCustLabelSpecBlobsContent.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&MARKETTYPE="+organizationID+"'>預覽此客戶標籤規格樣本檔:(檔案名稱="+frontFile_name+")</A><BR>");	          	 
    		}
    		rs7.close();
  		}

  		//inser Binary Icon File To DB for Customer Icon File 
		intRunStep = 6;
  		if  (!side_file.isMissing()) 
  		{
    		ResultSet rs8=stmt.executeQuery("select CUST_BLOBICON from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' for UPDATE");  	
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
	 			}
	 

     			out.println("Customer Icon file upload success!!<BR>");  
	 			out.println("<A HREF='TSCustLabelIconBlobsContent.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&MARKETTYPE="+organizationID+"'>預覽此客戶標籤特殊圖樣:(檔案名稱="+sideFile_name+")</A>");	          
    		}
    		rs8.close();
  		}

  		// Insert into Label Preview JPG File
		intRunStep = 7;
  		if  (!prev_file.isMissing()) 
  		{
    		ResultSet rs9=stmt.executeQuery("select LABEL_BLOBPREV from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' for UPDATE");  	
    		if (rs9.next())
    		{
     			BLOB myblob=null;
     			FileInputStream instream=null;
     			OutputStream outstream=null;
     			int bufsize=0;
     			byte[] buffer =null;
     			int fileLength=0;   
     
	 			if  (!prev_file.isMissing())
	 			{
       				myblob=((OracleResultSet)rs9).getBLOB(1);
       				instream=new FileInputStream(prevFilePath);
       				outstream=myblob.getBinaryOutputStream();
       				bufsize=myblob.getBufferSize();
       				buffer = new byte[bufsize];   
       				while ((fileLength=instream.read(buffer))!=-1)   
           				outstream.write(buffer,0,fileLength);
       				instream.close();	 
       				outstream.close();	        	   
	 			} 

     			out.println("Customer Label Preview file upload success!!<BR>");  
	 			out.println("<A HREF='TSCustLabelPreviewBlobsContent.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&MARKETTYPE="+organizationID+"'>預覽此客戶標籤檔圖樣:(檔案名稱="+prevFile_name+")</A>");	          
    		}
    		rs9.close();
  		}
  		stmt.close();
	}
}
catch (Exception e)
{
	if (intRunStep ==1)
	{
		out.println(frontFilePath);
		out.println(sideFilePath);
		out.println(prevFilePath);
	}
	else if (intRunStep == 3)
	{
		out.println("<font color='red'>寫入客戶特殊規格標籤主檔發生error!</font>");
	}
	out.println("<font color='red'>交易失敗!!(step:"+intRunStep+") "+e.getMessage()+"</font>");
}

%>
<table width="40%" border="1" cellpadding="0" cellspacing="0" >
  <tr>
    <td ><font size="2">客戶特殊規格標籤管理</font></td>      
  </tr>
  <tr>   
    <td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E9"; 	
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	//out.println("sqlE3="+sqlE3);
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlE3);    	
    while(rs.next())
    {
		//out.println("FSEQ="+rs.getString("FSEQ"));
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>");  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}//end of catch  
%>   
  </td>     
 </tr>
</table>
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
