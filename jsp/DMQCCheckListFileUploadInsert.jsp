<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>

<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<html>
<head>
<title>Insert upload file - into Database </title>
</head>

<body>
<p><A HREF='../WinsMainMenu.jsp'>HOME</A></p>
<%  
	//取得傳入參數
	String sModelNo=request.getParameter("MODELNO");

	if ( sModelNo==null )  { sModelNo = ""; out.println("未傳入MODELNO");}
	
    mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	//out.println("/wins/report/"+upload_file.getFileName());
    upload_file.saveAs("D:\\resin-2.1.9\\webapps\\wins\\report\\"+sModelNo+"CHECKLIST.xls");
	//InputStream is = new FileInputStream("D:\\resin-2.1.9\\webapps\\wins\\report\\"+upload_file.getFileName());   // open uplad file
	InputStream is = new FileInputStream("D:\\resin-2.1.9\\webapps\\wins\\report\\"+sModelNo+"CHECKLIST.xls");  // open uplad file
	//jxl.Workbook wb = Workbook.getWorkbook(is);  // open work bookC:\\resin-2.1.9\\webapps\\wins\\report\\
	//wb.close();  
	
    //out.println(userID);
	//String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
    try
      {
                String sSql =  "insert into FILEREFCTL(FRMODELNO,FRUPUSER,FRFILENAME,FRTRANSDTIME,FRTYPE) "+
							   "values(?,?,?,?,?)"; 
				//out.println("sSql="+sSql+"<BR>"); 					
				PreparedStatement seqstmt=dmcon.prepareStatement(sSql);
				seqstmt.setString(1,sModelNo);  //out.println("1="+sModel); 				
				seqstmt.setString(2,userID);  //out.println("2="+);
				seqstmt.setString(3,upload_file.getFileName());  //out.println("3="+sStation);
				//seqstmt.setString(4,strDateTime);
				seqstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //out.println("4="+sDate);				
				seqstmt.setString(5,"CHECKLIST");
				out.println("結轉成功");
				seqstmt.executeUpdate(); //out.println("<BR>");		
				seqstmt.close();  
 
    }	// end try
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());				
	}                               

%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
