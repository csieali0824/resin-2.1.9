<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>

<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 

<html>
<head>
<title>Insert upload file - into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>
<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>  
<%
try {
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); // save file o server
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());   // open uplad file
	jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
	int iSheets = wb.getNumberOfSheets();
	out.println("Sheets="+iSheets+"<BR>");
	
	int n=0;		
	while (n<iSheets)  // read work sheet in work book
	{
		jxl.Sheet sht = wb.getSheet(n);  // open work sheet
		if (sht!=null) {
			String sSheetName = sht.getName();
			out.println("Sheet Name="+sSheetName+"<BR>");
			String sDate = sSheetName;
			//int iDate = Integer.parseInt(sSheetName);
			//out.println("Date="+iDate);
			
			jxl.Cell wcModel = sht.getCell(1, 2);
			String sModel = wcModel.getContents();
			
			if (sModel!=null && !sModel.equals("")) {
			
				int iIndex = sModel.indexOf("-");
				if (iIndex>=0) {sModel = sModel.substring(0,iIndex);}
				int iIndex2 = sModel.indexOf("DB");
				if (iIndex2>=0) {sModel = sModel.substring(iIndex2+2, sModel.length());}
				out.println("MODELNO="+sModel+"<BR>");
				//刪除當日資料
				String sSqlDel="delete from DAILYPROD WHERE  GENDATE ="+sDate+" AND MODELNO='"+sModel+"'";   
				PreparedStatement delstmt=dmcon.prepareStatement(sSqlDel);
				delstmt.executeUpdate();
				delstmt.close();

				int iMaxRows = sht.getRows();  // get max rows
				//out.println("Max Rows="+iMaxRows+"<BR>");
	
				int x=6;
				String sSTOP = "N";
				//while (x<=9) 
				while (x<iMaxRows && sSTOP.equals("N") )  // read cell in work sheet
				{
					out.println("ROW="+x);
					
					jxl.Cell wc1 = sht.getCell(0, x);
					String s1 = wc1.getContents();
					//out.println("wc1="+s1);
					String sStation = s1.toUpperCase();
					if (sStation.equals("PACKING")) { sSTOP = "Y";}
					out.println("wc1="+sStation);
				
					jxl.Cell wc2 = sht.getCell(1, x);
					String s2 = wc2.getContents();
					//out.println("wc2="+s2);
					float fInQty = 0;
					if (s2!=null && !s2.equals("")) //不為空值
						{fInQty = Float.parseFloat(s2);}
					out.println("wc2="+fInQty);
				
					jxl.Cell wc3 = sht.getCell(2, x);
					String s3 = wc3.getContents();
					//out.println("wc3="+s3);
					float fOutQty = 0;
					if (s3!=null && !s3.equals("")) //不為空值
						{fOutQty = Float.parseFloat(s3);}
					out.println("wc3="+fOutQty);
					
					out.println("<BR>");
				
					String sSql =  "insert into dailyprod(MODELNO,LINENUM,STANUM,GENDATE,INQTY,OUTQTY) "+
										"values(?,?,?,?,?,?)"; 
					//out.println("sSql="+sSql+"<BR>"); 					
					PreparedStatement seqstmt=dmcon.prepareStatement(sSql);
					seqstmt.setString(1,sModel);  //out.println("1="+sModel); 				
					seqstmt.setString(2,"LINE");  //out.println("2=");
					seqstmt.setString(3,sStation);  //out.println("3="+sStation);
					seqstmt.setString(4,sDate);  //out.println("4="+sDate);
					seqstmt.setFloat(5,fInQty);  //out.println("5="+);
					seqstmt.setFloat(6,fOutQty);  //out.println("6="+f);
					
					seqstmt.executeUpdate(); //out.println("<BR>");		
					seqstmt.close(); 
					
					x=x+2;
					
				}  // end while for read cell
				
			} // end if modelno
			
			n++;
			
		} // end if (sht==null)
		
	}  // end while for read sheet
	
	wb.close();                            

}	// end try
catch (Exception e){out.println("Exception:"+e.getMessage());	}

%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>