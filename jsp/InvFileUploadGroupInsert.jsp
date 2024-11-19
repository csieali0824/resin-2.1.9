<!--讀入EXCEL庫存餘額表, 並產生倉別/架位主檔-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Group File Upload Insert</title>
</head>

<body>
<%
try
{
	//
	PreparedStatement stateDel=con.prepareStatement("DELETE FROM INV_GROUP");
	stateDel.executeUpdate();
	stateDel.close();
	
	
	PreparedStatement stateIns=con.prepareStatement("INSERT INTO INV_GROUP "+
	"(GENNAME,GCNNAME,GCODE,GLOC,GDESC)"+" VALUES(?,?,?,?,?)");
	
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	out.println("File name="+upload_file.getFileName());
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); // save file o server
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());   // open uplad file
	jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
	int iSheets = wb.getNumberOfSheets();
	out.println("<BR>"+"Sheets="+iSheets);
	
	jxl.Sheet sht = wb.getSheet(0);  // open work sheet
	String sSheetName = sht.getName();
	out.println("<BR>"+"Sheet Name="+sSheetName);
	int iMaxRows = sht.getRows();  // get max rows
	out.println("MaxRow="+iMaxRows);
		
	String sENAME = "";
	String sCNAME = "";
	String sCode = "";
	
	int n = 1;
	while (n<iMaxRows)
	{
		jxl.Cell wc1 = sht.getCell(1, n);
		String sEN = wc1.getContents();
		
		if (sEN==null || sEN.equals("")) { sEN = sENAME;
		}
		else { sENAME = sEN;
		}
		out.println("<br>"+"EN="+sEN);

		jxl.Cell wc2 = sht.getCell(2, n);
		String sCN = wc2.getContents();
		if (sCN==null || sCN.equals("")) { sCN = sCNAME;
		}
		else { sCNAME = sCN;
		}
		out.println("CN="+sCN);
		
		jxl.Cell wc3 = sht.getCell(3, n);
		String sCd = wc3.getContents();
		if (sCd==null || sCd.equals("")) { sCd = sCode;
		}
		else { sCode = sCd;
		}
		out.println("Code="+sCd);
		
		jxl.Cell wc4 = sht.getCell(4, n);
		String sLoc = wc4.getContents();
		out.println("Loc="+sLoc);
		String sLoct = "";
		String sDesc = "";
		int iIndex = sLoc.indexOf(":");
		if (iIndex>=0) {sLoct = sLoc.substring(0,iIndex); sDesc = sLoc.substring(iIndex+1,sLoc.length());
		}
		else { sLoct = sLoc.trim();
		}
		if (sDesc==null) { sDesc = "";
		}
		sDesc = sDesc.trim();
		
		out.println("Loct="+sLoct);
		out.println("Desc="+sDesc);
			
		n++;
		
		if (sEN!=null && !sEN.equals("") && sCN!=null && !sCN.equals("") && sCd!=null && !sCd.equals("") && sLoct!=null && !sLoct.equals(""))
		{
			stateIns.setString(1,sEN);
			stateIns.setString(2,sCN);
			stateIns.setString(3,sCd);
			stateIns.setString(4,sLoct); 
			stateIns.setString(5,sDesc); 
			stateIns.executeUpdate();
		}
		
	} // end while n
		
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
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>