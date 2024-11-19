<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%//@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<title>Upload Check List file</title>
</head>

<body>
<%

	int iYearSelect;
	int iMonthSelect;
	int iMaxMonthDays;
	String sDateSelectFr = "";
	String sDateSelectTo = "";

	try
	{	
		mySmartUpload.initialize(pageContext);
		mySmartUpload.upload();
		String sYear=mySmartUpload.getRequest().getParameter("YEARSET");
		String sMonth=mySmartUpload.getRequest().getParameter("MONTHSET");
		out.println(sYear);
		out.println(sMonth);
	
		if (sYear==null) 
		{ 
			sYear = dateBean.getYearString();
			iYearSelect = dateBean.getYear();
		}
		else iYearSelect = Integer.parseInt(sYear);
	
		if (sMonth==null) 
		{
			sMonth = dateBean.getMonthString();
			iMonthSelect = dateBean.getMonth();
		}
		else iMonthSelect = Integer.parseInt(sMonth);
	
		dateBean.setDate(iYearSelect, iMonthSelect, 1);
		iMaxMonthDays = dateBean.getMonthMaxDay();
		
		sDateSelectFr = sYear + sMonth + "01";
		sDateSelectTo = sYear + sMonth + String.valueOf(iMaxMonthDays);
		
		out.println("DATE FROM="+sDateSelectFr);
		out.println("DATE   TO="+sDateSelectTo);
		out.println("<BR>");


	} // end of try
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());		  
	} 
		

		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		//save file to server
		upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
		//open file from server
		InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());
		//open excel file work book
		jxl.Workbook wb = Workbook.getWorkbook(is);
		//open excel file first work sheet
		jxl.Sheet sht = wb.getSheet(0);
		int iMaxRows = sht.getRows();
		//out.println("Last Row="+iMaxRows+"<BR>");



	
	String sPreDate="";
	String sPreLine="";
	String sPreModel="";
	String sPreStation="";
	String sPreDefQty="";
	String sPreDefRate="";
	String sPreSymp="";
	String sPreResn="";
	String sPreAct="";
	String sPrePIC="";
	String sPreStatus="";
	
	

    //String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間
	try
    { 
		// 先刪除後新增;相當於作修改
		String sqlDModel="delete from DMADMIN.QCPROD WHERE  GENDATE >="+sDateSelectFr+" AND GENDATE <="+sDateSelectTo;   
		//out.println(sqlDModel); 
		PreparedStatement seqstmt=dmcon.prepareStatement(sqlDModel);
		seqstmt.executeUpdate();
		seqstmt.close();
                       
    } //end of try
    catch (Exception e)
    {
		 out.println("Exception:"+e.getMessage());		  
    }  


	
	int n = 0;
	//while (n<=223)
	while (n<5000 && n<iMaxRows) //read cell from work sheet
	{
		out.println("Row="+n);
		
		jxl.Cell wc1 = sht.getCell(0, n);
		String sDate = wc1.getContents();
		//out.println("cell 1="+sDate);

		int iIndx1 = sDate.indexOf("/");
		int iIndx2 = sDate.indexOf(";"); 

		String sMonth = "0";
		String sDay = "0";
		if(iIndx1>0) //判斷為日期型態 MM/DD, 把資料修正成YYYY/MM/DD
		{ 
			sMonth = sDate.substring(0,iIndx1); 
			if(iIndx2>0) { sDay = sDate.substring(iIndx1+1,iIndx2);  } 
			if (Integer.parseInt(sMonth) < 10 && Integer.parseInt(sDay) < 10) { sDate = dateBean.getYearString()+"0"+sMonth+"0"+sDay; }
			else if (Integer.parseInt(sMonth) < 10 && Integer.parseInt(sDay) > 9) { sDate = dateBean.getYearString()+"0"+sMonth+sDay; }  
			else if (Integer.parseInt(sMonth) > 9 && Integer.parseInt(sDay) < 10) { sDate = dateBean.getYearString()+sMonth+"0"+sDay; } 
			else if (Integer.parseInt(sMonth) > 9 && Integer.parseInt(sDay) > 9) { sDate = dateBean.getYearString()+sMonth+sDay; } 
			sPreDate=sDate;
		}
		if (sDate==null || sDate.equals("")) { sDate = sPreDate; iIndx1=1;} 
		//如果是空值, 則設定同上一筆的日期, 並將Index=1做為後續判斷用, 表示該筆的第一欄是日期
		out.println("cell 1="+sDate);
		
		jxl.Cell wc2 = sht.getCell(1, n);
		String sLine = wc2.getContents();		
		if (sLine==null || sLine.equals("")) {sLine = sPreLine;} //如果是空值, 則設定同上一筆
		else {sPreLine = sLine;}
		out.println("cell 2="+sLine);
		
		jxl.Cell wc3 = sht.getCell(2, n);
		String sModel = wc3.getContents();
		int iIndex = sModel.indexOf("-");
		int iIndex2 = sModel.length();
		if (iIndex>0) {sModel = sModel.substring(iIndex+1,iIndex2);}
		if (sModel==null || sModel.equals("")) {sModel = sPreModel;}  //如果是空值, 則設定同上一筆
		else {sPreModel = sModel;}
		out.println("cell 3="+sModel);
		
		jxl.Cell wc4 = sht.getCell(3, n);
		String sStation = wc4.getContents();
		if (sStation==null || sStation.equals("")) {sStation = sPreStation;} //如果是空值, 則設定同上一筆
		else {sPreStation = sStation;}
		out.println("cell 4="+sStation);
		
		jxl.Cell wc5 = sht.getCell(4, n);
		String sDefQty= wc5.getContents();
		//out.println("cell 5="+sDefQty);
		float fDefQty = 0;
		if (sDefQty!=null && !sDefQty.equals("") && iIndx1>0) //不為空值, 且該筆的第一欄是日期
			{fDefQty = Float.parseFloat(sDefQty);}
		out.println("cell 5="+fDefQty);
		
		jxl.Cell wc6 = sht.getCell(5, n);
		String sDefRate = wc6.getContents();
		//out.println("cell 6="+sDefRate);

		float fDefRate = 0;
		int iLen = 0;
		if (sDefRate!=null && !sDefRate.equals("") && iIndx1>0) //不為空值, 且該筆的第一欄是日期)
		{ 
			iLen = sDefRate.length();
			sDefRate = sDefRate.substring(0,iLen-1); //最後一位的%符號不要
			fDefRate = Float.parseFloat(sDefRate);
		}
		out.println("cell 6="+fDefRate);
		
		jxl.Cell wc7 = sht.getCell(6, n);
		String sSymp = wc7.getContents();
		if (sSymp==null) {sSymp = "";}
		else if (sSymp.length()>=60) {sSymp=sSymp.substring(0,59);}
		//out.println(sSymp.length());
		out.println("cell 7="+sSymp);
		
		jxl.Cell wc8 = sht.getCell(7, n);
		String sResn = wc8.getContents();
		if (sResn==null) {sResn = "";}
		else if (sResn.length()>=300) {sResn=sResn.substring(0,299);}
		//out.println(sResn.length());
		out.println("cell 8="+sResn);
		
		jxl.Cell wc9 = sht.getCell(8, n);
		String sAct = wc9.getContents();
		if (sAct==null) {sAct = "";}
		else if (sAct.length()>=500) {sAct=sAct.substring(0,499);}
		//out.println(sAct.length());
		out.println("cell 9="+sAct);
		
		jxl.Cell wc10 = sht.getCell(9, n);
		String sPIC = wc10.getContents();
		if (sPIC==null) {sPIC = "";}
		else if (sPIC.length()>=60) {sPIC=sPIC.substring(0,59);}
		out.println("cell 10="+sPIC);
		
		jxl.Cell wc11 = sht.getCell(10, n);
		String sStatus = wc11.getContents();
		if (sStatus==null) {sStatus = "";}
		else if (sStatus.length()>=20) {sStatus=sStatus.substring(0,19);}
		sStatus = sStatus.toUpperCase();
		out.println("cell 11="+sStatus);
		
		out.println("<BR>");

		
		

		try {
				if (fDefQty>0 && fDefRate>0 && iIndx1>0) //不良數量及不良率>0, 且該筆的第一欄是日期
				{		
					
					String sqlTC =  "insert into QCPROD(MODELNO,LINENUM,STANUM,GENDATE,NGQTY,DRATE,NGPHE,NGREA,NGWAY,NGPER,SDATE,ADATE,STAT) "+
									"values(?,?,?,?,?,?,?,?,?,?,?,?,?)"; 
					//out.println("sqlTC="+sqlTC+"<BR>"); 					
					PreparedStatement seqstmt=dmcon.prepareStatement(sqlTC);
					seqstmt.setString(1,sModel);  out.println("1="+sModel); 				
					seqstmt.setString(2,sLine);  //out.println("2="+sLine);
					seqstmt.setString(3,sStation);  //out.println("3="+sStation);
					seqstmt.setString(4,sDate);  //out.println("4="+sDate);
					seqstmt.setFloat(5,fDefQty);  //out.println("5="+fDefQty);
					seqstmt.setFloat(6,fDefRate);  //out.println("6="+fDefRate);
					seqstmt.setString(7,sSymp);  //out.println("7="+sSymp);
					seqstmt.setString(8,sResn);  //out.println("8="+sResn);
					seqstmt.setString(9,sAct);   //out.println("9="+sAct);
					seqstmt.setString(10,sPIC);  //out.println("10="+sPIC);
					seqstmt.setString(11,"");
					seqstmt.setString(12,"");
					seqstmt.setString(13,sStatus);   //out.println("13="+sStatus);
					
					seqstmt.executeUpdate(); //out.println("<BR>");		
					seqstmt.close(); 
				
  
				} // end if 
				
			} // end of try
			catch (Exception e)
			{
				 out.println("Exception:"+e.getMessage());		  
			} 
		
	



		n++;
	} // end of while read cell from work sheet
	
	wb.close(); 

%>


</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>