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

  <%
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); // save file o server
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());   // open uplad file
	jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
    jxl.Sheet sht = wb.getSheet(0);
	int iMaxRows = sht.getRows(); // get max rows
	//out.println("Max Rows="+iMaxRows+"<BR>");
	String sSheetName = sht.getName();
	//out.println("DATE="+sSheetName);
	String sDate = sSheetName;
	//String sDate= dateBean.getYearMonthDay();
	//刪除當日資料
	String sSqlDel="delete from matectl WHERE  MCDATE ="+sDate+" AND MCMODELNO IN ('2052C','2068C')";   
	PreparedStatement delstmt=dmcon.prepareStatement(sSqlDel);
	delstmt.executeUpdate();
	delstmt.close();
	//
	
    try
	{
         
		    int x=7;
			String sSTOP = "N";
			//while (x<=9) 
			while (x<iMaxRows && sSTOP.equals("N") )  // read cell in work sheet
			{
				//out.println("ROW="+x);
				
				jxl.Cell wc0 = sht.getCell(0, x);
				String s0 = wc0.getContents();
     
				
				String sClass = s0.toUpperCase();
				if (sClass.equals("Total")) { sSTOP = "Y";}
                //out.println("Total 購料數="+sClass);
				
				jxl.Cell wc2 = sht.getCell(2, x);
				String sModel = wc2.getContents();
				if (sModel.equals("2052C") || sModel.equals("2068C")) //不為空值而且Model 為2052C,2068C
			   { 
                //out.println("MODELNO="+sModel);
				jxl.Cell wc3 = sht.getCell(3, x);
				String s3 = wc3.getContents();
				//out.println("wc3="+s3);
				float fInTotalQty = 0;
				if (s3!=null && !s3.equals("")) //不為空值
					{fInTotalQty = Float.parseFloat(s3);}
				//out.println("Total購料數="+fInTotalQty);
				
				jxl.Cell wc4 = sht.getCell(4, x);
				String s4 = wc4.getContents();
				//out.println("wc4="+s4);
				float fTillShipment= 0;
				if (s4!=null && !s4.equals("")) //不為空值
					{fTillShipment = Float.parseFloat(s4);}
				//out.println("未含當月累計出貨數="+fTillShipment);
				
				jxl.Cell wc5= sht.getCell(5, x);
				String s5 = wc5.getContents();
				//out.println("wc5="+s5);
				float fSample= 0;
				if (s5!=null && !s5.equals("")) //不為空值
					{fSample = Float.parseFloat(s5);}
				//out.println("樣品需求="+fSample);
				
				jxl.Cell wc6= sht.getCell(6, x);
				String s6 = wc6.getContents();
				//out.println("wc6="+s6);
				float fMShipment= 0;
				if (s6!=null && !s6.equals("")) //不為空值
					{fMShipment= Float.parseFloat(s6);}
				//out.println("當月出貨數="+fMShipment);
				
				jxl.Cell wc7= sht.getCell(7, x);
				String s7 = wc7.getContents();
				//out.println("wc7="+s7);
				float fStock= 0;
				if (s7!=null && !s7.equals("")) //不為空值
					{fStock= Float.parseFloat(s7);}	
				//out.println("成品 Inventory="+fStock);
				
				jxl.Cell wc8= sht.getCell(8, x);
				String s8 = wc8.getContents();
				//out.println("wc8="+s8);
				float fNetQty= 0;
				if (s8!=null && !s8.equals("")) //不為空值
					{fNetQty= Float.parseFloat(s8);}	
				//out.println("剩餘材料數="+fNetQty);
				
				jxl.Cell wc9= sht.getCell(9, x);
				String s9 = wc9.getContents();
				//out.println("wc9="+s9);
				float fWip= 0;
				if (s9!=null && !s9.equals("")) //不為空值
					{fWip= Float.parseFloat(s9);}	
				//out.println("WIP"+fWip);
				
				jxl.Cell wc10= sht.getCell(10, x);
				String s10 = wc10.getContents();
				//out.println("wc10="+s10);
				float fWholeSetQty= 0;
				if (s10!=null && !s10.equals("")) //不為空值
					{fWholeSetQty= Float.parseFloat(s10);}	
				//out.println("成套材料數="+fWholeSetQty);
				
				jxl.Cell wc11= sht.getCell(11, x);
				String s11 = wc11.getContents();
				//out.println("wc11="+s11);
				float fPWholeSetQty= 0;
				if (s11!=null && !s11.equals("")) //不為空值
					{fPWholeSetQty= Float.parseFloat(s11);}
				//out.println("成套材料數(80%)="+fPWholeSetQty);
				
				jxl.Cell wc12= sht.getCell(12,x);
				String s12 = wc12.getContents();
				//out.println("wc12="+s12);
				float fNWholeSetQty= 0;
				if (s12!=null && !s12.equals("")) //不為空值
					{fNWholeSetQty= Float.parseFloat(s12);}
			    //out.println("不成套材料數="+fNWholeSetQty);
				
				String sSql =  "insert into matectl(mcdate,mcmodelno,mcpurkit,mcshipend,mcship,mcissue,mcstock,mcremkit,mcwipkit,mckit1,mckit2,mckit3,importdate) "+
									"values(?,?,?,?,?,?,?,?,?,?,?,?,?)"; 
				//out.println("sSql="+sSql+"<BR>"); 					
				PreparedStatement seqstmt=dmcon.prepareStatement(sSql);
				seqstmt.setString(1,sDate);  				
				seqstmt.setString(2,sModel);  
				seqstmt.setFloat(3,fInTotalQty);  
				seqstmt.setFloat(4,fTillShipment); 
				seqstmt.setFloat(5,fMShipment);  
				seqstmt.setFloat(6,fSample);  
				seqstmt.setFloat(7,fStock);  				
				seqstmt.setFloat(8,fNetQty); 
				seqstmt.setFloat(9,fWip);  
				seqstmt.setFloat(10,fWholeSetQty); 
				seqstmt.setFloat(11,fPWholeSetQty);  
				seqstmt.setFloat(12,fNWholeSetQty); 
				seqstmt.setString(13,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
				
				seqstmt.executeUpdate(); //out.println("<BR>");		
				seqstmt.close(); 

%>
</p>
<table width="38%" border="1">
  <tr bgcolor="#6699CC"> 
    <td width="51%"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif">更新日期</font></td>
    <td width="49%"> <div align="right"><font color="#FFFFFF" size="2" face="Arial, Helvetica, sans-serif"><%=sDate%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">MODELNO</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=sModel%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">Total購料數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fInTotalQty%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">未含當月累計出貨數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fTillShipment%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">樣品需求</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fSample%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成品 Inventory</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fStock%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">WIP</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fWip%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成套材料數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fWholeSetQty%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">成套材料數 (80%)</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fPWholeSetQty%></font></div></td>
  </tr>
  <tr> 
    <td><font size="2" face="Arial, Helvetica, sans-serif">不成套材料數</font></td>
    <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><%=fNWholeSetQty%></font></div></td>
  </tr>
</table>
 
 <%
 	       }  // end if model in('2052C','2068C')
			x=x+1;	
		}  // end while for read cell    

		} // end of try
		catch (Exception e)
		{ out.println("Exception:"+e.getMessage()); }
		
%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>