<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 

<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Vendor File Upload Insert</title>
</head>

<body>
<%
try
{
	//
	PreparedStatement state=con.prepareStatement("DELETE FROM INV_VND");
	state.executeUpdate();
	state.close();
	
	PreparedStatement stateIns=con.prepareStatement("INSERT INTO INV_VND "+
	"(VNDNO,VNDDESC)"+" VALUES(?,?)");
	
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	out.println("file name="+upload_file.getFileName());
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); // save file o server
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());   // open uplad file
	jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
	//int iSheets = wb.getNumberOfSheets();
	//out.println("Sheets="+iSheets+"<BR>");
	jxl.Sheet sht = wb.getSheet(0);  // open work sheet
	String sSheetName = sht.getName();
	int iMaxRows = sht.getRows();  // get max rows
	out.println("<BR>"+"Sheet Name="+sSheetName);
	int n = 1;
	while (n<iMaxRows)
	{
		jxl.Cell wc1 = sht.getCell(0, n);
		String sVend = wc1.getContents();
		out.println("<br>"+"Vend="+sVend);
		jxl.Cell wc2 = sht.getCell(1, n);
		String sCode = wc2.getContents();
		out.println("Code="+sCode);
		n++;
		stateIns.setString(1,sCode);
		stateIns.setString(2,sVend);
		stateIns.executeUpdate();
	}
	stateIns.close();
	wb.close();
}  // end try
catch (Exception e){out.println("Exception:"+e.getMessage());}

%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>